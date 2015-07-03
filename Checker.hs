{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE LambdaCase #-}
module Checker(
    check
    )where
import Cmm_alex
import Cmm_happy
import Dictutils
import Data.Either

defaultFunctions::[Namedecl]
defaultFunctions = 
    [("<=", (Function [Boolean, Number, Number],(0,0)))
    ,("<", (Function [Boolean, Number, Number],(0,0)))
    ,(">", (Function [Boolean, Number, Number],(0,0)))
    ,(">=", (Function [Boolean, Number, Number],(0,0)))
    ,("==", (Function [Boolean, Number, Number],(0,0)))
    ,("!=", (Function [Boolean, Number, Number],(0,0)))
    
    ,("+", (Function [Number, Number, Number],(0,0)))
    ,("-", (Function [Number, Number, Number],(0,0)))
    ,("*", (Function [Number, Number, Number],(0,0)))
    ,("/", (Function [Number, Number, Number],(0,0)))
    
    ,(">>", (Function [Void, Number],(0,0)))
    ,("<<", (Function [Void, Reference],(0,0)))]

data Typ = Boolean | Number | Reference | Void | Function [Typ] | Any deriving (Show)
instance (Eq Typ) where
    a == b = 
        case (a,b) of
            (Any,_) -> True
            (_, Any) -> True
            (Boolean,Boolean)->True
            (Number,Number)->True
            (Reference,Reference)->True
            (Void,Void)->True
            (Function a, Function b) -> a == b
            _ -> False
            
type Pos = (Int, Int)

type Namedecl = (String, (Typ, Pos))                   
type Error = (Pos, String)

check::[TDeclaration]->[Error]
check decls = checkTopLevel decls defaultFunctions

checkTopLevel::[TDeclaration]->[Namedecl]->[Error]
checkTopLevel [] _ = []
checkTopLevel (d:ecl) prevdecls =
    case d of
        Intdecl (Posed pos nam) -> 
            if | haskey nam prevdecls  ->
                (pos, "Redefinition of variable"):checkTopLevel ecl prevdecls
               | otherwise ->
                checkTopLevel ecl ((nam, (Number, pos)):prevdecls)
        Arrdecl (Posed posn nam) (Posed poss siz) ->
            if | haskey nam prevdecls -> 
                (posn, "Redefinition of variable"):checkTopLevel ecl prevdecls
               | siz <= 0 ->
                (poss, "Nonpositive array size"):checkTopLevel ecl prevdecls
               | otherwise ->
                checkTopLevel ecl ((nam, (Reference, posn)):prevdecls)
        Fundecl (Posed pos nam) paramsraw body ->
            if | haskey nam prevdecls -> 
                (pos, "Redefinition of variable"):checkTopLevel ecl prevdecls
               | otherwise -> 
                let (pardecl, parerrors) = morphdecl paramsraw prevdecls
                    bodyerrors = checkstat (pardecl++prevdecls) body Number
                    fntype = Number:(map (\(_, (t, _))-> t) pardecl)
                    fdcl = (nam, (Function fntype, pos))
                in bodyerrors ++ parerrors ++ 
                    checkTopLevel ecl (fdcl:prevdecls)
        Procdecl (Posed pos nam) paramsraw body ->
            if | haskey nam prevdecls -> 
                (pos, "Redefinition of variable"):checkTopLevel ecl prevdecls
               | otherwise -> 
                let (pardecl, parerrors) = morphdecl paramsraw prevdecls
                    bodyerrors = checkstat (pardecl++prevdecls) body Void
                    fntype = Void:(map (\(_, (t, _))-> t) pardecl)
                    fdcl = (nam, (Function fntype, pos))
                in bodyerrors ++ parerrors ++ 
                    checkTopLevel ecl (fdcl:prevdecls) 

checkstat::[Namedecl]->TStatement->Typ->[Error]
checkstat prevdecls statement rettyp = 
    case statement of
        CompSta decls nested -> 
            let (locdecl, declerr) = morphdecl decls prevdecls
                tail = concat $ map (\st -> checkstat (locdecl ++ prevdecls) st rettyp) nested
            in (declerr ++ tail)
        SelSta bexpr thn mels ->
            checkexpr Boolean prevdecls bexpr
            ++ checkstat prevdecls thn rettyp
            ++ case mels of Just els -> checkstat prevdecls els rettyp; Nothing -> []
        IterSta bexpr whl ->
            checkexpr Boolean prevdecls bexpr
            ++ checkstat prevdecls whl rettyp
        RetSta p Nothing -> 
            if rettyp == Void then [] else [(p, "Expected empty return")]
        RetSta p (Just rexpr) -> 
            if rettyp == Void then [(p, "Expected expression")] else checkexpr rettyp prevdecls rexpr
        ReadSta (Posed pos nam, Nothing) -> 
            case lookup nam prevdecls of
                Just (Number, _) -> []
                Just _ -> [(pos, "Type mismatch: expected integer variable")]
                Nothing -> [(pos, "Unknown variable")]
        ReadSta (Posed pos nam, Just iexpr) -> 
            case lookup nam prevdecls of
                Just (Number, _) -> [(pos, "Type mismatch: expected array variable")]
                Just (Reference, _) -> checkexpr Number prevdecls iexpr
                Nothing -> [(pos, "Unknown variable")]
        ExpSta sexpr -> checkexpr Any prevdecls sexpr
        EmpSta -> []

checkexpr::Typ->[Namedecl]->TExpression->[Error]
checkexpr typ decls expr = 
    case expr of
        ComplEx assigns cexpr -> 
            case (typ, assigns) of
                (_, []) -> checkexpr typ decls cexpr
                (_, (Posed pos nam, mexpr):ssigns) -> 
                    case (lookup nam decls, mexpr) of
                        (Nothing, _) -> (pos, "Unknown variable"):(checkexpr typ decls (ComplEx ssigns cexpr))
                        (Just (Reference, _), Just iexpr) | typ == Number ->
                            (checkexpr Number decls (ComplEx ssigns cexpr)) 
                            ++ (checkexpr Number decls iexpr)
                        (Just (_, _), Just iexpr) -> 
                            (pos, "Cannot index non-array")
                            :if typ == Number then [] else [(pos, "Type mismatch: expected " ++ show typ)]
                            ++(checkexpr typ decls (ComplEx ssigns cexpr)) 
                            ++ (checkexpr Number decls iexpr)
                        (Just (chaintype, _), Nothing) | chaintype == typ -> 
                            (checkexpr chaintype decls (ComplEx ssigns cexpr)) 
                        (Just (chaintype, _), Nothing) -> 
                            (pos, "Type mismatch: expected " ++ show typ)
                            :(checkexpr typ decls (ComplEx ssigns cexpr)) 
        CallEx (Posed pos nam) argexprs -> 
            case lookup nam decls of
                Nothing -> [(pos, "Unknown variable")]
                Just (Function (rett:argt), _) -> 
                    let mterr = if (rett == typ) then [] else [(pos, "Type mismatch: expected " ++ (show typ) ++ " expression")]
                        argerr = checkcalltypes argt argexprs
                        checkcalltypes [] [] = []
                        checkcalltypes [] _ = [(pos, "Too many arguments in function call")]
                        checkcalltypes _ [] = [(pos, "Too few arguments in function call")]
                        checkcalltypes (ah:at) (bh:bt) = 
                            (checkexpr ah decls bh)++(checkcalltypes at bt)
                    in mterr ++ argerr
                _ -> [(pos, "Expected function name")]
        Retrieval (Posed pos nam, adrexpr) -> 
            let nameerr = case lookup nam decls of
                    Nothing -> [(pos, "Unknown variable")]
                    Just (rettyp, _) -> 
                        if | (rettyp == typ && (case adrexpr of Nothing -> True; _ -> False)) -> []
                           | (rettyp == Reference && (case adrexpr of Nothing -> False; _ -> True)) -> []
                           | otherwise -> [(pos, "Type mismatch: expected " ++ (show typ) ++ " expression")]
                argerr = case adrexpr of
                             Nothing -> []
                             Just iexpr -> checkexpr Number decls iexpr
            in nameerr ++ argerr
        StringLiteral (Posed pos values) -> 
            case typ of Reference -> []; _ -> [(pos, "Type mismatch: expected reference expression")]
        NumLiteral (Posed pos val) ->
            case typ of Number -> []; _ -> [(pos, "Type mismatch: expected integer expression")]

morphdecl::[TDeclaration]->[Namedecl]->([Namedecl], [Error])
morphdecl pars prevdecls = 
    let ep1 = map (\case
                        Intdecl (Posed pos nam) -> Right (nam, (Number, pos))
                        Arrdecl (Posed pos nam) _ -> Right (nam, (Reference, pos))
                        Fundecl (Posed pos _) _ _ -> Left (pos, "Function declaration in nested scope")
                        Procdecl(Posed pos _) _ _ -> Left (pos, "Function declaration in nested scope"))
                   pars
        errs1 = lefts ep1
        pars1 = rights ep1
        (pars2, errs2) = checkdoubles prevdecls pars1
    in (pars2, errs2++errs1)
    
checkdoubles::[Namedecl]->[Namedecl]->([Namedecl], [Error])
checkdoubles prev [] = ([],[])
checkdoubles prev ((nam, (typ, pos)):ar) =
    if (haskey nam prev)
        then let tail = checkdoubles prev ar in (fst tail, (pos, "Redefinition of variable"):snd tail)
        else let p = (nam, (typ, pos)); tail = checkdoubles (p:prev) ar in (p:fst tail, snd tail)
    