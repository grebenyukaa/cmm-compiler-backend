{-# LANGUAGE OverloadedStrings #-}

module Emit where

import LLVM.General.Module
import LLVM.General.Context

import qualified LLVM.General.AST as AST
import qualified LLVM.General.AST.Constant as C
import qualified LLVM.General.AST.IntegerPredicate as IP

import Data.Word
import Data.Int
import Data.Foldable (foldrM)
import Control.Monad.Except
import Control.Monad.State (gets)
import Control.Applicative
import qualified Data.Map as Map

import Codegen
import qualified Astbuilder as S

import Debug.Trace

data GFSymbolTable = GFSymbolTable {
    gSym :: GSymbolTable
  , fSym :: FSymbolTable
}

izero = cons $ C.Int 32 0
true = cons $ C.Int 1 1
false = cons $ C.Int 1 0

cmmType :: S.Type -> AST.Type
cmmType sty = case sty of
  S.Void -> cmmVoid
  S.Number -> cmmInt
  S.Reference size -> cmmVec $ fromIntegral size

cmmCInt32 :: Int -> C.Constant
cmmCInt32 val = C.Int 32 $ toInteger val

cmmCInt32Vec :: Int -> C.Constant -> C.Constant
cmmCInt32Vec size init = 
  let inits = cycle [init] in 
    C.Vector $ take size inits

cmmDefaultVal :: S.Type -> C.Constant
cmmDefaultVal ty =
  case ty of
    S.Number -> cmmCInt32 0
    S.Reference size -> cmmCInt32Vec size (cmmDefaultVal S.Number)

genPhi :: AST.Type -> Bool
genPhi ty =
  case ty of
    AST.VoidType -> False
    otherwise -> True
--

toSig :: [S.Vardecl] -> [(AST.Type, AST.Name)]
toSig = map (\(S.Vardecl nm ty) -> (cmmType ty, AST.Name nm))

codegenTop :: S.Declaration -> LLVM ()
codegenTop fdecl@(S.Funcdecl ty name args body) = do
  gst <- gets gSymtab
  fst' <- gets fSymtab
  defineFunc (cmmType ty) name fnargs $ createBlocks $ execCodegen $ cgenDecl fdecl $ GFSymbolTable { gSym=gst, fSym=fst' }
  where
    fnargs = toSig args

codegenTop (S.VD (S.Vardecl name ty)) = do
  defineGlobalVar (cmmType ty) name $ Just $ cmmDefaultVal ty --AST doesn't support global var initialization

codegenTop (S.Extdecl ty name args) = do
  external (cmmType ty) name fnargs
  where fnargs = toSig args

-------------------------------------------------------------------------------
-- Operations
-------------------------------------------------------------------------------

lt :: [AST.Operand] -> Codegen AST.Operand
lt ab = do
  setCurType cmmInt
  icmp IP.SLT (ab !! 0) (ab !! 1)

le :: [AST.Operand] -> Codegen AST.Operand
le ab = do
  setCurType cmmInt
  icmp IP.SLE (ab !! 0) (ab !! 1)

gt :: [AST.Operand] -> Codegen AST.Operand
gt ab = do
  setCurType cmmInt
  icmp IP.SGT (ab !! 0) (ab !! 1)

ge :: [AST.Operand] -> Codegen AST.Operand
ge ab = do
  setCurType cmmInt
  icmp IP.SGE (ab !! 0) (ab !! 1)

eq :: [AST.Operand] -> Codegen AST.Operand
eq ab = do
  setCurType cmmInt
  icmp IP.EQ (ab !! 0) (ab !! 1)

ne :: [AST.Operand] -> Codegen AST.Operand
ne ab = do
  setCurType cmmInt
  icmp IP.NE (ab !! 0) (ab !! 1)

callF :: AST.Type -> AST.Name -> [AST.Operand] -> Codegen AST.Operand
callF ty nm args = do
  setCurType ty
  call (externf ty nm) args

ops = Map.fromList [
      ("+", iadd)
    , ("-", isub)
    , ("*", imul)
    , ("/", idiv)
    , ("<", lt)
    , (">", gt)
    , ("<=", le)
    , (">=", ge)
    , ("==", eq)
    , ("!=", ne)
--    , ("<<", \_ -> iadd [izero, izero])
--    , (">>", \_ -> isub [izero, izero])
    , ("<<", callF cmmInt $ AST.Name "getChar")
    , (">>", callF cmmInt $ AST.Name "putChar")
  ]

cgenDecl :: S.Declaration -> GFSymbolTable -> Codegen AST.Operand
cgenDecl (S.Funcdecl ty name args body) gst = do
  entry <- addBlock entryBlockName
  setBlock entry
  forM args $ \(S.Vardecl nm ty) -> do
    var <- alloca $ cmmType ty
    store var $ local (cmmType ty) $ AST.Name nm
    assign nm var
  --cgen' body >>= ret
  cgen' body gst

cgenRead :: S.Expression -> AST.Operand -> GFSymbolTable -> Codegen AST.Operand
cgenRead (S.Takeadr var) val gfst = do
  a <- getvar var $ gSym gfst
  store a val
  getCurType >>= setCurType
  return val

cgenAss :: S.Expression -> S.Expression -> GFSymbolTable -> Codegen AST.Operand
cgenAss (S.Takeadr var) val gfst = do -- trace ("var = " ++ show var ++ ", val = " ++ show val) $ do
  a <- getvar var $ gSym gfst
  cval <- cgen val gfst
  store a cval
  getCurType >>= setCurType
  return cval

cgenAss brop@(S.BracketOp arr idx) val gfst = do
  cval <- cgen val gfst
  arrPtr <- cgen brop gfst
  store arrPtr cval
  getCurType >>= setCurType
  return cval

cgen :: S.Expression -> GFSymbolTable -> Codegen AST.Operand
cgen (S.Assign varList val) gfst = -- trace ("cgen Assign: " ++ show varList ++ ", " ++ show val) $
  let
    vp = take (length varList - 1) varList
    vl = last varList
  in
    foldr (\a b -> b *> a) (cgenAss vl val gfst) $ map (\(v1, v2) -> cgenAss v1 v2 gfst) $ zip vp $ drop 1 vp ++ [vl]

cgen (S.Takeval exp) gfst = cgen exp gfst

cgen (S.Takeadr x) gfst = getvar x (gSym gfst) >>= load

cgen (S.ConstInt n) _ = do
  setCurType cmmInt
  return $ cons $ cmmCInt32 n

cgen (S.ConstArr vals) _ = do
  setCurType $ cmmVec $ fromIntegral $ length vals
  return $ cons $ C.Vector $ cmmCInt32 <$> vals

cgen (S.Call fn args) gfst = do
  largs <- mapM ((flip cgen) gfst) args
  if Map.member fn ops then
    if fn /= "<<" then
      (ops Map.! fn) largs
    else
      do
        rval <- (ops Map.! fn) []
        cgenRead (args !! 0) rval gfst
  else
    case (lookup fn $ fSym gfst) of
      Just ftype -> callF ftype (AST.Name fn) largs
      Nothing -> error $ "Call to undeclared external funcion: " ++ (show fn)

cgen (S.BracketOp arr exp) gfst = do --trace "BracketOp!" $ do
  arrv <- cgen arr gfst
  expv <- cgen exp gfst
  setCurType $ cmmPtr cmmInt
  getElementPtr arrv [expv]

cgen' :: S.Statement -> GFSymbolTable -> Codegen AST.Operand
cgen' (S.Expsta exp) gfst = cgen exp gfst
cgen' (S.Return (Just val)) gfst = do
  retv <- cgen val gfst
  ret $ Just retv
  return retv
cgen' (S.Return Nothing) _ = do
  ret Nothing
  return izero

cgen' (S.Complex vars blcs) gfst = do
  forM vars $ \(S.Vardecl nm ty) -> do
    var <- alloca $ cmmType ty
    --store var $ local (cmmType ty) $ AST.Name nm
    assign nm var
  if blcs /= []
    then foldl1 (\a b -> a *> b) $ map (\blc -> cgen' blc gfst) blcs
    else return izero

cgen' (S.Ite cond tr (Just fl)) gfst = do
  ifthen <- addBlock "if.then"
  ifelse <- addBlock "if.else"
  ifexit <- addBlock "if.exit"

  -- %entry
  ------------------
  cond <- cgen cond gfst
  cbr cond ifthen ifelse -- Branch based on the condition

  -- if.then
  ------------------
  setBlock ifthen
  trval <- cgen' tr gfst  -- Generate code for the true branch
  ct <- getCurType
  br ifexit              -- Branch to the merge block
  ifthen <- getBlock

  -- if.else
  ------------------
  setBlock ifelse
  flval <- cgen' fl gfst  -- Generate code for the false branch
  br ifexit              -- Branch to the merge block
  ifelse <- getBlock

  -- if.exit
  ------------------
  setBlock ifexit

  return izero
  --ct <- getCurType
  --if genPhi ct
  --  then phi ct [(trval, ifthen), (flval, ifelse)]
  --  else return izero

cgen' (S.Ite cond tr Nothing) gfst = do
  ifthen <- addBlock "if.then"
  ifelse <- addBlock "if.else"
  ifexit <- addBlock "if.exit"

  -- %entry
  ------------------
  cond <- cgen cond gfst
  cbr cond ifthen ifelse -- Branch based on the condition

  -- if.then
  ------------------
  setBlock ifthen
  trval <- cgen' tr gfst  -- Generate code for the true branch
  br ifexit              -- Branch to the merge block
  ifthen <- getBlock

  setBlock ifelse
  br ifexit

  -- if.exit
  ------------------
  setBlock ifexit

  return izero
  --ct <- getCurType
  --if (genPhi ct)
  --  then phi ct [(trval, ifthen), (cons $ cmmCInt32 0, ifelse)]
  --  else return izero

cgen' (S.While cond blc) gfst = do
  brcond <- addBlock "while.cond"
  brloop <- addBlock "while.loop"
  brexit <- addBlock "while.exit"

  br brcond

  setBlock brcond
  cond <- cgen cond gfst
  cbr cond brloop brexit

  setBlock brloop
  cgen' blc gfst
  br brcond

  setBlock brexit
  return izero

-------------------------------------------------------------------------------
-- Compilation
-------------------------------------------------------------------------------

liftError :: ExceptT String IO a -> IO a
liftError = runExceptT >=> either fail return

codegen :: LLVMState -> [S.Declaration] -> IO AST.Module
codegen mod fns = withContext $ \context ->
  liftError $ withModuleFromAST context newast $ \m -> do
    llstr <- moduleLLVMAssembly m
    --putStrLn llstr
    return newast
  where
    modn    = mapM codegenTop fns
    newast  = astm $ runLLVM mod modn