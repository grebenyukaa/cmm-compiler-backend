{
module Cmm_happy(
    happyParseToTree,
    Reference,
    TExpression(..),
    TDeclaration(..),
    TStatement(..),
    )where
import Cmm_alex
}

%name happyParseToTree DeclarationList
%tokentype { Posed Token}
%error { parseError }

%token
    array       {Posed _ (Array _)}
    num         {Posed _ (Num _)}
    name        {Posed _ (Name _)}
    "["         {Posed _ (Symbol "[")}
    "]"         {Posed _ (Symbol "]")}
    "{"         {Posed _ (Symbol "{")}
    "}"         {Posed _ (Symbol "}")}
    "("         {Posed _ (Symbol "(")}
    ")"         {Posed _ (Symbol ")")}
    ";"         {Posed _ (Symbol ";")}
    ","         {Posed _ (Symbol ",")}
    "=="        {Posed _ (Symbol "==")}
    "="         {Posed _ (Symbol "=")}
    "<="        {Posed _ (Symbol "<=")}
    "<"         {Posed _ (Symbol "<")}
    ">="        {Posed _ (Symbol ">=")}
    ">"         {Posed _ (Symbol ">")}
    "!="        {Posed _ (Symbol "!=")}
    "+"         {Posed _ (Symbol "+")}
    "-"         {Posed _ (Symbol "-")}
    "*"         {Posed _ (Symbol "*")}
    "/"         {Posed _ (Symbol "/")}
    "int"       {Posed _ (Symbol "int")}
    "void"      {Posed _ (Symbol "void")}
    "if"        {Posed _ (Symbol "if")}
    "else"      {Posed _ (Symbol "else")}
    "while"     {Posed _ (Symbol "while")}
    "return"    {Posed _ (Symbol "return")}
    "read"      {Posed _ (Symbol "read")}
    "write"     {Posed _ (Symbol "write")}

%nonassoc ")"
%nonassoc "else"
    
    %%

DeclarationList ::{ [TDeclaration] }
DeclarationList : Declaration                           { [$1] }
                | DeclarationList Declaration           { $1 ++ [$2] }
                
Declaration     ::{ TDeclaration }
Declaration     : VarDeclaration                        { $1 }
                | FunDeclaration                        { $1 }

VarDeclaration  ::{ TDeclaration }
VarDeclaration  : "int" name ";"                        { let (Posed p (Name n)) = $2
                                                          in (Intdecl (Posed p n)) }
                | "int" name "[" num "]" ";"            { let (Posed p (Name n)) = $2;
                                                              (Posed p2 (Num i)) = $4
                                                          in (Arrdecl (Posed p n) (Posed p2 i)) }

FunDeclaration  ::{ TDeclaration }
FunDeclaration  : "int" name "(" Params ")" CompoundStmt    { let (Posed p (Name n)) = $2
                                                              in (Fundecl (Posed p n) $4 $6) }
                | "void" name "(" Params ")" CompoundStmt   { let (Posed p (Name n)) = $2
                                                              in (Procdecl (Posed p n) $4 $6) }

Params          ::{ [TDeclaration] }
Params          : "void"                                { [] }
                | ParamList                             { $1 }
ParamList       ::{ [TDeclaration] }
ParamList       : Param                                 { [$1] }
                | ParamList "," Param                   { $1 ++ [$3] }
Param           ::{ TDeclaration }
Param           : "int" name                            { let (Posed p (Name n)) = $2
                                                          in Intdecl (Posed p n) }
                | "int" name "[" "]"                    { let (Posed p (Name n)) = $2
                                                          in Arrdecl (Posed p n) (Posed p 0) }
CompoundStmt    ::{ TStatement }
CompoundStmt    : "{" LocalDeclarations StatementList "}"   { CompSta $2 $3 }
---------
LocalDeclarations   ::{ [TDeclaration] }
LocalDeclarations   : {--}                              { [] }
                    | LocalDeclarations VarDeclaration  { $1 ++ [$2] }

StatementList   ::{ [TStatement] }
StatementList   : {--}                                  { [] }
                | StatementList Statement               { $1 ++ [$2] }

Statement       ::{ TStatement }
Statement       : ExpressionStmt                        { $1 }
                | CompoundStmt                          { $1 }
                | SelectionStmt                         { $1 }
                | IterationStmt                         { $1 }
                | ReturnStmt                            { $1 }
                | ReadStmt                              { $1 }
                | WriteStmt                             { $1 }

ExpressionStmt  ::{ TStatement }
ExpressionStmt  : Expression ";"                        { ExpSta $1 }
                | ";"                                   { EmpSta }

SelectionStmt   ::{ TStatement }
SelectionStmt   : "if" "(" Expression ")" Statement                     { SelSta $3 $5 Nothing }
                | "if" "(" Expression ")" Statement "else" Statement    { SelSta $3 $5 (Just $7 )}
                
IterationStmt   ::{ TStatement }
IterationStmt   : "while" "(" Expression ")" Statement  { IterSta $3 $5 }

ReturnStmt      ::{ TStatement }
ReturnStmt      : "return" ";"              { let (Posed pos _) = $1
                                              in RetSta pos Nothing}
                | "return" Expression ";"   { let (Posed pos _) = $1
                                              in RetSta pos (Just $2) }

ReadStmt        ::{ TStatement }
ReadStmt        : "read" Var ";"            { ReadSta $2 }

WriteStmt       ::{ TStatement }
WriteStmt       : "write" Expression ";"    { let (Posed p (Symbol "write")) = $1
                                              in ExpSta $ CallEx (Posed p ">>") [$2] }
----------------------
Expression      ::{ TExpression }
Expression      : ExpressionHead SimpleExpression  { ComplEx $1 $2 }

ExpressionHead  ::{ [Reference] }
ExpressionHead  : {--}                      { [] }
                | ExpressionHead Var "="    { $1 ++ [$2] }

Var             ::{ Reference }
Var             : name                      { let (Posed p (Name n)) = $1
                                              in (Posed p n, Nothing) }
                | name "[" Expression "]"   { let (Posed p (Name n)) = $1
                                              in (Posed p n, Just $3) }

SimpleExpression::{ TExpression }
SimpleExpression: AdditiveExpression                            { $1 }
                | AdditiveExpression Relop AdditiveExpression   { let (Posed p (Symbol n)) = $2
                                                                  in CallEx (Posed p n) [$1, $3] }

Relop           ::{ Posed Token }
Relop           : "<="             { $1 }
                | "<"              { $1 }
                | ">"              { $1 }
                | ">="             { $1 }
                | "=="             { $1 }
                | "!="             { $1 }

AdditiveExpression::{ TExpression }
AdditiveExpression  : Term                              { $1 }
                    | AdditiveExpression Addop Term     { let (Posed p (Symbol n)) = $2
                                                          in CallEx (Posed p n) [$1, $3] }

Addop           ::{ Posed Token }
Addop           : "+"              { $1 }
                | "-"              { $1 }

Term            ::{ TExpression }
Term            : Factor             { $1 }
                | Term Multop Factor { let (Posed p (Symbol n)) = $2
                                       in CallEx (Posed p n) [$1, $3] }
Multop          ::{ Posed Token }
Multop          : "*"              { $1 }
                | "/"              { $1 }

Factor          ::{ TExpression }
Factor          : "(" Expression ")" { $2 }
                | num                { let (Posed p (Num n)) = $1
                                       in NumLiteral $ Posed p n }
                | array              { let (Posed p (Array n)) = $1
                                       in StringLiteral $ Posed p n }
                | Var                { Retrieval $1 }
                | Call               { $1 }

Call            ::{ TExpression }
Call            : name "(" Args ")"  { let (Posed p (Name n)) = $1
                                       in CallEx (Posed p n) $3 }

Args            ::{ [TExpression] }
Args            : {--}                { [] }
                | Expression          { [$1] }
                | Args "," Expression { $1 ++ [$3] }

{
parseError :: Show b => [Posed b] -> a
parseError ((Posed p t):rst) = error $ "Syntax error at " ++ (show p) ++ ": unexpected symbol \"" ++ (show t) ++ "\""

type Reference = (Posed String, Maybe (TExpression))
data TExpression =
    ComplEx [Reference] TExpression
    | CallEx (Posed String) [TExpression]
    | Retrieval Reference
    | StringLiteral (Posed [Int])
    | NumLiteral (Posed Int)
    deriving (Show, Eq)
data TStatement =
    CompSta [TDeclaration] [TStatement]
    | SelSta TExpression TStatement (Maybe TStatement)
    | IterSta TExpression TStatement
    | RetSta (Int,Int) (Maybe TExpression)
    | ReadSta Reference
    | ExpSta TExpression
    | EmpSta
    deriving (Show, Eq)
data TDeclaration =
    Intdecl (Posed String)
    | Arrdecl (Posed String) (Posed Int)
    | Fundecl (Posed String) [TDeclaration] TStatement
    | Procdecl (Posed String) [TDeclaration] TStatement
    deriving (Show, Eq)
}