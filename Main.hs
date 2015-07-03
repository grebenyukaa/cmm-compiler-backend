{-# LANGUAGE BangPatterns #-}

import Prelude hiding (writeFile)
import System.IO hiding (writeFile)
import Control.Monad(when)
import Data.List

import Cmm_alex
import Cmm_happy
import Checker
import Astbuilder

import GHC.IO.Handle
import System.Environment

{-import Data.Yaml(encode)
import Data.ByteString (writeFile)
import Data.ByteString.Char8(pack)-}
import Data.Aeson.Encode.Pretty(encodePretty)
import Data.ByteString.Lazy (writeFile)
import Data.ByteString.Lazy.Char8(pack)

--

import Codegen
import Emit
import JIT
import qualified LLVM.General.AST as AST

encode = encodePretty

defineExtenalIO :: [Declaration] -> [Declaration]
defineExtenalIO ast =
  let 
    fPutChar = Extdecl Void "putChar" [Vardecl "X" Number]
    fGetChar = Extdecl Number "getChar" []
  in
    [fPutChar, fGetChar] ++ ast

main :: IO ()
main = do
    args <- getArgs
    progName <- getProgName
    
    let showUsage = do
        putStrLn $ "Usage:"
        putStrLn $ "  " ++ progName ++ " {option} filename"
        putStrLn $ "  options:"
        putStrLn $ "  -t    output tokens"
        putStrLn $ "  -p    output parse tree"
        putStrLn $ "  -l    redirect output to log file"
        putStrLn $ "  -h    show this help"
        
    let mfnames = filter (\s -> not $ "-" `isSuffixOf` s) args
    
    when (mfnames /= [] && elem "-h" args) $ do showUsage
    
    when (mfnames == []) $ do
        showUsage
        error "File name not specified"
    
    let (fname:_) = mfnames
    
    when (elem "-l" args) $ do
        h <- openFile (fname ++ ".log") WriteMode
        hDuplicateTo h stdout
        
    program <- readFile fname
    let tokens = alexScanTokens program
    --putStrLn $ concat $ map (\t -> show t ++ "\n") $ tokens
    when (elem "-t" args) $ do
        writeFile (fname ++ ".tokens") $ pack $ show tokens
    
    let tree = happyParseToTree tokens
    when (elem "-p" args) $ do
        writeFile (fname ++ ".tree") $ pack $ show tree
        
    --print tree
    let errors = check tree
    mapM_ putStrLn $ map (\(pos, err) -> "Error at " ++ show pos ++": " ++ err) errors
    
    when (errors == []) $ do
        let ast = mkAST tree
        writeFile (fname ++ ".ast") $ encode ast

        llvmModule <- codegen (emptyLLVMState "MyModule") $ defineExtenalIO ast
        --putStrLn $ show llvmModule
        llvmCode <- runJIT llvmModule
        putStrLn "Done"