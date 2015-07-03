{
{-# Language LambdaCase #-}
module Cmm_alex (Token(..), Posed(..), alexScanTokens) where
}

%wrapper "posn"

-- $white
$letter = [a-z A-Z]
$digit = 0-9

--{- name literal -}
@name = $letter+

--{- integer literal -}
@int = \-? $digit+

--{- char literal -}
@escapeseq = 0 | a | b | f | n | r | t | \\ | \' | \" | \?
@escapechar = \\ @escapeseq
@char = $printable | @escapechar
@character = \' @char \'

--{- string literal -}
@string = \" $printable* \"

--{- symbol literal -}
@symbol = "[" | "]" | "{" | "}" | "(" | ")" | ";" | "," 
        | "==" | "=" | "<=" | "<" | ">=" | ">" |  "!=" 
        | "+" | "-" | "*" | "/"

--{- reserved word literal -}
@reserved = "int" | "void"   | "if"  | "else" | "while" | "return" | "read" | "write" 

--{- comments -}
@comment = "//" .* 
    | "/*" (. | \n)* "*/"
    
----------------------------------------------------
tokens :-
    
    $white+         ;
    @comment        ;
    @reserved       {pose Symbol}
    @name           {pose Name}
    @string         {pose (\s -> Array $ map fromEnum $ sanstr s)}
    @character      {pose (\s -> Num $ fromEnum $ (read s :: Char))}
    @int            {pose (\s -> Num $ read s)}
    @symbol         {pose Symbol}

{
data Token =
    Symbol String |
    Array [Int]   |
    Num Int       |
    Name String 
    deriving (Eq, Show)
    
data Posed a = Posed (Int,Int) a
instance (Eq a => Eq (Posed a)) where
    (==) (Posed _ a) (Posed _ b) = a == b
instance (Show a => Show (Posed a)) where
    show (Posed p a) = concat [show p, "~", show a]

pose::(String->a)->AlexPosn->String->Posed a
pose constr (AlexPn abs line col) s = Posed (line, col) (constr s)

sanstr ('"':tail) = sanstrlast tail
sanstrlast = \case 
    [] -> []
    a:[] | a == '"' ->'\0':[]
    a:b -> a:sanstrlast b

}