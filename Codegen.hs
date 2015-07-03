{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Codegen where

import Data.Word
import Data.String
import Data.List
import Data.Function
import qualified Data.Map as Map

import Control.Monad.State
import Control.Applicative

import LLVM.General.AST
import LLVM.General.AST.Global
import qualified LLVM.General.AST as AST
import qualified LLVM.General.AST.Global as G

import qualified LLVM.General.AST.Constant as C
import qualified LLVM.General.AST.Attribute as A
import qualified LLVM.General.AST.Linkage as L
import qualified LLVM.General.AST.CallingConvention as CC
import qualified LLVM.General.AST.IntegerPredicate as IP
import qualified LLVM.General.AST.AddrSpace as AddSp

---------------------------------------------------------------------------------
-- Types
-------------------------------------------------------------------------------

cmmVoid :: Type
cmmVoid = VoidType

cmmInt :: Type
cmmInt = IntegerType 32

cmmChar :: Type
cmmChar = IntegerType 8

cmmStr :: Word32 -> Type
cmmStr len = VectorType len cmmChar

cmmVec :: Word32 -> Type
cmmVec len = VectorType len cmmInt

cmmPtr :: Type -> Type
cmmPtr ty = PointerType ty $ AddSp.AddrSpace 1

-------------------------------------------------------------------------------
-- Module Level
-------------------------------------------------------------------------------

type GSymbolTable = [(String, Type)]
type FSymbolTable = [(String, Type)]

data LLVMState = LLVMState {
    astm :: AST.Module
  , gSymtab :: GSymbolTable
  , fSymtab :: FSymbolTable
} deriving (Show)

newtype LLVM a = LLVM { unLLVM :: State LLVMState a }
  deriving (Functor, Applicative, Monad, MonadState LLVMState )

runLLVM :: LLVMState -> LLVM a -> LLVMState
runLLVM = flip (execState . unLLVM)

emptyModule :: String -> AST.Module
emptyModule label = defaultModule { moduleName = label }

emptyLLVMState :: String -> LLVMState
emptyLLVMState modn = 
  LLVMState { 
    astm = emptyModule modn,
    gSymtab = [],
    fSymtab = []
  }

addDefn :: Definition -> LLVM ()
addDefn d = do
  m <- gets astm
  let defs = moduleDefinitions m in
    modify $ \s -> s { astm = m { moduleDefinitions = defs ++ [d] } }

defineFunc :: Type -> String -> [(Type, Name)] -> [BasicBlock] -> LLVM ()
defineFunc retty label argtys body = do 
  _ <- addDefn $
    GlobalDefinition $ functionDefaults {
      name        = Name label
    , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
    , returnType  = retty
    , basicBlocks = body
    }
  fst <- gets fSymtab
  modify $ \s -> s { fSymtab = (label,retty):fst }

defineGlobalVar :: Type -> String -> (Maybe C.Constant) -> LLVM ()
defineGlobalVar t n iv = do
  _ <- addDefn $ GlobalDefinition $ globalVariableDefaults {
      name        = Name n
    , G.type'     = t
    , initializer = iv
    , linkage     = L.Common
    }
  gst <- gets gSymtab
  modify $ \s -> s { gSymtab = (n,t):gst }

external ::  Type -> String -> [(Type, Name)] -> LLVM ()
external retty label argtys = do 
  _ <- addDefn $
    GlobalDefinition $ functionDefaults {
      name        = Name label
    , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
    , returnType  = retty
    , basicBlocks = []
    }
  fst <- gets fSymtab
  modify $ \s -> s { fSymtab = (label,retty):fst }

-------------------------------------------------------------------------------
-- Names
-------------------------------------------------------------------------------

type Names = Map.Map String Int

uniqueName :: String -> Names -> (String, Names)
uniqueName nm ns =
  case Map.lookup nm ns of
    Nothing -> (nm,  Map.insert nm 1 ns)
    Just ix -> (nm ++ show ix, Map.insert nm (ix+1) ns)

instance IsString Name where
  fromString = Name . fromString

-------------------------------------------------------------------------------
-- Codegen State
-------------------------------------------------------------------------------

type SymbolTable = [(String, Operand)]

data CodegenState
  = CodegenState {
    currentBlock :: Name                     -- Name of the active block to append to
  , blocks       :: Map.Map Name BlockState  -- Blocks for function
  , symtab       :: SymbolTable              -- Function scope symbol table
  , blockCount   :: Int                      -- Count of basic blocks
  , count        :: Word                     -- Count of unnamed instructions
  , names        :: Names                    -- Name Supply
  , tmpVarIdx    :: Int                      -- Tmp variable number
  , curType      :: Type                     -- Last instruction type
  } deriving Show

data BlockState
  = BlockState {
    idx   :: Int                            -- Block index
  , stack :: [Named Instruction]            -- Stack of instructions
  , term  :: Maybe (Named Terminator)       -- Block terminator
  } deriving Show

-------------------------------------------------------------------------------
-- Codegen Operations
-------------------------------------------------------------------------------

newtype Codegen a = Codegen { runCodegen :: State CodegenState a }
  deriving (Functor, Applicative, Monad, MonadState CodegenState )

sortBlocks :: [(Name, BlockState)] -> [(Name, BlockState)]
sortBlocks = sortBy (compare `on` (idx . snd))

createBlocks :: CodegenState -> [BasicBlock]
createBlocks m = map makeBlock $ sortBlocks $ Map.toList (blocks m)

makeBlock :: (Name, BlockState) -> BasicBlock
makeBlock (l, bs@(BlockState _ s t)) = BasicBlock l s (maketerm t)
  where
    maketerm (Just x) = x
    maketerm Nothing = error $ "Block has no terminator: " ++ (show l)

entryBlockName :: String
entryBlockName = "entry"

emptyBlock :: Int -> BlockState
emptyBlock i = BlockState i [] Nothing

emptyCodegen :: CodegenState
emptyCodegen = CodegenState (Name entryBlockName) Map.empty [] 1 0 Map.empty 0 cmmVoid

execCodegen :: Codegen a -> CodegenState
execCodegen m = execState (runCodegen m) emptyCodegen

setCurType :: Type -> Codegen ()
setCurType ty = do
  modify $ \s -> s { curType = ty }

getCurType :: Codegen (Type)
getCurType = do
  ct <- gets curType
  return ct

freshTmpVar :: Codegen Int
freshTmpVar = do
  i <- gets tmpVarIdx
  modify $ \s -> s { tmpVarIdx = 1 + i }
  return $ i + 1

fresh :: Codegen Word
fresh = do
  i <- gets count
  modify $ \s -> s { count = 1 + i }
  return $ i + 1

instr :: Instruction -> Codegen (Operand)
instr ins = do
  n <- fresh
  let ref = (UnName n)
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = i ++ [ref := ins] } )
  return $ local cmmInt ref

terminator :: Named Terminator -> Codegen (Named Terminator)
terminator trm = do
  blk <- current
  modifyBlock (blk { term = Just trm })
  return trm

-------------------------------------------------------------------------------
-- Block Stack
-------------------------------------------------------------------------------

entry :: Codegen Name
entry = gets currentBlock

addBlock :: String -> Codegen Name
addBlock bname = do
  bls <- gets blocks
  ix <- gets blockCount
  nms <- gets names
  let new = emptyBlock ix
      (qname, supply) = uniqueName bname nms
  modify $ \s -> s { blocks = Map.insert (Name qname) new bls
                   , blockCount = ix + 1
                   , names = supply
                   }
  return (Name qname)

setBlock :: Name -> Codegen Name
setBlock bname = do
  modify $ \s -> s { currentBlock = bname }
  return bname

getBlock :: Codegen Name
getBlock = gets currentBlock

modifyBlock :: BlockState -> Codegen ()
modifyBlock new = do
  active <- gets currentBlock
  modify $ \s -> s { blocks = Map.insert active new (blocks s) }

current :: Codegen BlockState
current = do
  c <- gets currentBlock
  blks <- gets blocks
  case Map.lookup c blks of
    Just x -> return x
    Nothing -> error $ "No such block: " ++ show c

-------------------------------------------------------------------------------
-- Symbol Table
-------------------------------------------------------------------------------

assign :: String -> Operand -> Codegen ()
assign var x = do
  lcls <- gets symtab
  modify $ \s -> s { symtab = [(var, x)] ++ lcls }

getvar :: String -> GSymbolTable -> Codegen Operand
getvar var gsymtab = do
  syms <- gets symtab
  case lookup var syms of
    Just x  -> return x
    Nothing -> case lookup var gsymtab of
      Just ty -> return $ ConstantOperand $ C.GlobalReference ty (Name var)
      Nothing -> error $ "Variable not in scope: " ++ show var

-------------------------------------------------------------------------------

-- References
local :: Type -> Name -> Operand
local = LocalReference

global ::  Type -> Name -> C.Constant
global = C.GlobalReference

externf :: Type -> Name -> Operand
externf t n = ConstantOperand $ C.GlobalReference t n

-- Arithmetic and Constants
iadd :: [Operand] -> Codegen Operand
iadd ab = instr $ Add False False (ab !! 0) (ab !! 1) []

isub :: [Operand] -> Codegen Operand
isub ab = instr $ Sub False False (ab !! 0) (ab !! 1) []

imul :: [Operand] -> Codegen Operand
imul ab = instr $ Mul False False (ab !! 0) (ab !! 1) []

idiv :: [Operand] -> Codegen Operand
idiv ab = instr $ SDiv False (ab !! 0) (ab !! 1) []

icmp :: IP.IntegerPredicate -> Operand -> Operand -> Codegen Operand
icmp cond a b = instr $ ICmp cond a b []

getElementPtr :: Operand -> [Operand] -> Codegen Operand
getElementPtr adr idxs = instr $ GetElementPtr False adr idxs []

cons :: C.Constant -> Operand
cons = ConstantOperand

toArgs :: [Operand] -> [(Operand, [A.ParameterAttribute])]
toArgs = map (\x -> (x, []))

-- Effects
call :: Operand -> [Operand] -> Codegen Operand
call fn args = instr $ Call False CC.C [] (Right fn) (toArgs args) [] []

alloca :: Type -> Codegen Operand
alloca ty = instr $ Alloca ty Nothing 0 []

store :: Operand -> Operand -> Codegen Operand
store ptr val = instr $ Store False ptr val Nothing 0 []

load :: Operand -> Codegen Operand
load ptr = instr $ Load False ptr Nothing 0 []

-- Control Flow
br :: Name -> Codegen (Named Terminator)
br val = terminator $ Do $ Br val []

cbr :: Operand -> Name -> Name -> Codegen (Named Terminator)
cbr cond tr fl = terminator $ Do $ CondBr cond tr fl []

ret :: Maybe Operand -> Codegen (Named Terminator)
ret val = terminator $ Do $ Ret val []

phi :: Type -> [(Operand, Name)] -> Codegen Operand
phi ty incoming = instr $ Phi ty incoming []