{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DeriveGeneric,DeriveAnyClass #-}

module Astbuilder where
import Cmm_alex
import Cmm_happy
import Dictutils
import Data.Either
import Data.Aeson(ToJSON)
import GHC.Generics

data Type = Number | Reference Int | Void deriving (Eq, Show, Generic, ToJSON)
data Vardecl = Vardecl String Type deriving (Eq, Show, Generic, ToJSON)
data Declaration = 
    VD Vardecl
    | Funcdecl Type String [Vardecl] Statement
    | Extdecl Type String [Vardecl] 
    deriving (Eq, Show, Generic, ToJSON)
    
data Statement =
    Complex [Vardecl] [Statement]
    | Ite Expression Statement (Maybe Statement)
    | While Expression Statement
    | Expsta Expression
    | Return (Maybe Expression)
    deriving (Eq, Show, Generic, ToJSON)
    
data Expression =
    ConstInt Int                -- 7
    | ConstArr [Int]            -- [7,8,9]
    | Takeval Expression        -- (*7) :: Address->Value / first element of array
    | Takeadr String            -- (&x) :: Name->Address
    | Call String [Expression]  
    | Assign [Expression] Expression  -- adr1 = adr2 = adr3 = 7
    | BracketOp Expression Expression
    deriving (Eq, Show, Generic, ToJSON)

convexpr::TExpression->Expression    
convexpr = \case
    ComplEx [] right ->
        convexpr right
    ComplEx lefts right -> 
        Assign (map convref lefts) (convexpr right)
    CallEx (Posed _ nam) parexprs -> 
        Call nam (map convexpr parexprs)
    Retrieval ref ->
        Takeval $ convref ref
    NumLiteral (Posed _ num) ->
        ConstInt num
    StringLiteral (Posed _ arr) ->
        ConstArr arr
    
convref::Reference->Expression
convref ((Posed _ nam), Nothing) = Takeadr nam
convref ((Posed _ nam), Just adrexpr) = BracketOp (Takeadr nam) $ convexpr adrexpr

convvardecl::TDeclaration->Vardecl
convvardecl = \case
    Intdecl (Posed _ nam) -> Vardecl nam Number
    Arrdecl (Posed _ nam) (Posed _ size) -> Vardecl nam (Reference size)
    _ -> error "Unexpected function declaration"

convstat::TStatement->Statement
convstat = \case
    CompSta tdecls tstats ->
        Complex (map convvardecl tdecls) (map convstat tstats)
    SelSta ifexpr tstat mestat -> 
        Ite (convexpr ifexpr) (convstat tstat) (fmap convstat mestat)
    IterSta whexpr wstat ->
        While (convexpr whexpr) (convstat wstat)
    RetSta _ mexpr ->
        Return $ fmap convexpr mexpr
    ReadSta ref ->
        Expsta (Call "<<" [convref ref])
    ExpSta texpr ->
        Expsta (convexpr texpr)
    EmpSta -> 
        Complex [] []
        
mkAST::[TDeclaration]->[Declaration]
mkAST [] = []
mkAST (t:ree) = case t of
    Intdecl (Posed _ nam) -> 
        (VD $ Vardecl nam Number):mkAST ree
    Arrdecl (Posed _ nam) (Posed _ size) -> 
        (VD $ Vardecl nam (Reference size)):mkAST ree
    Fundecl (Posed _ nam) pardecls stat ->
        (Funcdecl Number nam (map (convvardecl) pardecls) (convstat stat)):mkAST ree --AST doesn't support Reference Int =(
    Procdecl (Posed _ nam) pardecls stat ->
        (Funcdecl Void nam (map (convvardecl) pardecls) (convstat stat)):mkAST ree
{-    where 
        getnams::[TDeclaration]->[String]
        getnams [] = []
        getnams (d:ecl) = case d of
            Intdecl (Posed _ nam) -> nam:getnams ecl
            Arrdecl (Posed _ nam) _ -> nam:getnams ecl
            _ -> error "Unexpected function declaration in function parameters"
-}