{-# OPTIONS_GHC -w #-}
module Cmm_happy(
    happyParseToTree,
    Reference,
    TExpression(..),
    TDeclaration(..),
    TStatement(..),
    )where
import Cmm_alex
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

data HappyAbsSyn 
	= HappyTerminal (Posed Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 ([TDeclaration])
	| HappyAbsSyn5 (TDeclaration)
	| HappyAbsSyn11 (TStatement)
	| HappyAbsSyn13 ([TStatement])
	| HappyAbsSyn21 (TExpression)
	| HappyAbsSyn22 ([Reference])
	| HappyAbsSyn23 (Reference)
	| HappyAbsSyn25 (Posed Token)
	| HappyAbsSyn32 ([TExpression])

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Posed Token)
	-> HappyState (Posed Token) (HappyStk HappyAbsSyn -> [(Posed Token)] -> m HappyAbsSyn)
	-> [HappyState (Posed Token) (HappyStk HappyAbsSyn -> [(Posed Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Posed Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113 :: () => Int -> ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Posed Token)
	-> HappyState (Posed Token) (HappyStk HappyAbsSyn -> [(Posed Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Posed Token) (HappyStk HappyAbsSyn -> [(Posed Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Posed Token)] -> (HappyIdentity) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65 :: () => ({-HappyReduction (HappyIdentity) = -}
	   Int 
	-> (Posed Token)
	-> HappyState (Posed Token) (HappyStk HappyAbsSyn -> [(Posed Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Posed Token) (HappyStk HappyAbsSyn -> [(Posed Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Posed Token)] -> (HappyIdentity) HappyAbsSyn)

action_0 (55) = happyShift action_5
action_0 (56) = happyShift action_6
action_0 (4) = happyGoto action_7
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 _ = happyFail

action_1 (55) = happyShift action_5
action_1 (56) = happyShift action_6
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (7) = happyGoto action_4
action_1 _ = happyFail

action_2 _ = happyReduce_1

action_3 _ = happyReduce_3

action_4 _ = happyReduce_4

action_5 (35) = happyShift action_10
action_5 _ = happyFail

action_6 (35) = happyShift action_9
action_6 _ = happyFail

action_7 (55) = happyShift action_5
action_7 (56) = happyShift action_6
action_7 (63) = happyAccept
action_7 (5) = happyGoto action_8
action_7 (6) = happyGoto action_3
action_7 (7) = happyGoto action_4
action_7 _ = happyFail

action_8 _ = happyReduce_2

action_9 (40) = happyShift action_14
action_9 _ = happyFail

action_10 (36) = happyShift action_11
action_10 (40) = happyShift action_12
action_10 (42) = happyShift action_13
action_10 _ = happyFail

action_11 (34) = happyShift action_21
action_11 _ = happyFail

action_12 (55) = happyShift action_18
action_12 (56) = happyShift action_19
action_12 (8) = happyGoto action_20
action_12 (9) = happyGoto action_16
action_12 (10) = happyGoto action_17
action_12 _ = happyFail

action_13 _ = happyReduce_5

action_14 (55) = happyShift action_18
action_14 (56) = happyShift action_19
action_14 (8) = happyGoto action_15
action_14 (9) = happyGoto action_16
action_14 (10) = happyGoto action_17
action_14 _ = happyFail

action_15 (41) = happyShift action_26
action_15 _ = happyFail

action_16 (43) = happyShift action_25
action_16 _ = happyReduce_10

action_17 _ = happyReduce_11

action_18 (35) = happyShift action_24
action_18 _ = happyFail

action_19 _ = happyReduce_9

action_20 (41) = happyShift action_23
action_20 _ = happyFail

action_21 (37) = happyShift action_22
action_21 _ = happyFail

action_22 (42) = happyShift action_32
action_22 _ = happyFail

action_23 (38) = happyShift action_28
action_23 (11) = happyGoto action_31
action_23 _ = happyFail

action_24 (36) = happyShift action_30
action_24 _ = happyReduce_13

action_25 (55) = happyShift action_18
action_25 (10) = happyGoto action_29
action_25 _ = happyFail

action_26 (38) = happyShift action_28
action_26 (11) = happyGoto action_27
action_26 _ = happyFail

action_27 _ = happyReduce_8

action_28 (12) = happyGoto action_34
action_28 _ = happyReduce_16

action_29 _ = happyReduce_12

action_30 (37) = happyShift action_33
action_30 _ = happyFail

action_31 _ = happyReduce_7

action_32 _ = happyReduce_6

action_33 _ = happyReduce_14

action_34 (55) = happyShift action_37
action_34 (6) = happyGoto action_35
action_34 (13) = happyGoto action_36
action_34 _ = happyReduce_18

action_35 _ = happyReduce_17

action_36 (38) = happyShift action_28
action_36 (39) = happyShift action_49
action_36 (42) = happyShift action_50
action_36 (57) = happyShift action_51
action_36 (59) = happyShift action_52
action_36 (60) = happyShift action_53
action_36 (61) = happyShift action_54
action_36 (62) = happyShift action_55
action_36 (11) = happyGoto action_39
action_36 (14) = happyGoto action_40
action_36 (15) = happyGoto action_41
action_36 (16) = happyGoto action_42
action_36 (17) = happyGoto action_43
action_36 (18) = happyGoto action_44
action_36 (19) = happyGoto action_45
action_36 (20) = happyGoto action_46
action_36 (21) = happyGoto action_47
action_36 (22) = happyGoto action_48
action_36 _ = happyReduce_37

action_37 (35) = happyShift action_38
action_37 _ = happyFail

action_38 (36) = happyShift action_11
action_38 (42) = happyShift action_13
action_38 _ = happyFail

action_39 _ = happyReduce_21

action_40 _ = happyReduce_19

action_41 _ = happyReduce_20

action_42 _ = happyReduce_22

action_43 _ = happyReduce_23

action_44 _ = happyReduce_24

action_45 _ = happyReduce_25

action_46 _ = happyReduce_26

action_47 (42) = happyShift action_73
action_47 _ = happyFail

action_48 (33) = happyShift action_69
action_48 (34) = happyShift action_70
action_48 (35) = happyShift action_71
action_48 (40) = happyShift action_72
action_48 (23) = happyGoto action_63
action_48 (24) = happyGoto action_64
action_48 (26) = happyGoto action_65
action_48 (28) = happyGoto action_66
action_48 (30) = happyGoto action_67
action_48 (31) = happyGoto action_68
action_48 _ = happyFail

action_49 _ = happyReduce_15

action_50 _ = happyReduce_28

action_51 (40) = happyShift action_62
action_51 _ = happyFail

action_52 (40) = happyShift action_61
action_52 _ = happyFail

action_53 (42) = happyShift action_60
action_53 (21) = happyGoto action_59
action_53 (22) = happyGoto action_48
action_53 _ = happyReduce_37

action_54 (35) = happyShift action_58
action_54 (23) = happyGoto action_57
action_54 _ = happyFail

action_55 (21) = happyGoto action_56
action_55 (22) = happyGoto action_48
action_55 _ = happyReduce_37

action_56 (42) = happyShift action_95
action_56 _ = happyFail

action_57 (42) = happyShift action_94
action_57 _ = happyFail

action_58 (36) = happyShift action_75
action_58 _ = happyReduce_39

action_59 (42) = happyShift action_93
action_59 _ = happyFail

action_60 _ = happyReduce_32

action_61 (21) = happyGoto action_92
action_61 (22) = happyGoto action_48
action_61 _ = happyReduce_37

action_62 (21) = happyGoto action_91
action_62 (22) = happyGoto action_48
action_62 _ = happyReduce_37

action_63 (45) = happyShift action_90
action_63 _ = happyReduce_60

action_64 _ = happyReduce_36

action_65 (44) = happyShift action_82
action_65 (46) = happyShift action_83
action_65 (47) = happyShift action_84
action_65 (48) = happyShift action_85
action_65 (49) = happyShift action_86
action_65 (50) = happyShift action_87
action_65 (51) = happyShift action_88
action_65 (52) = happyShift action_89
action_65 (25) = happyGoto action_80
action_65 (27) = happyGoto action_81
action_65 _ = happyReduce_41

action_66 (53) = happyShift action_78
action_66 (54) = happyShift action_79
action_66 (29) = happyGoto action_77
action_66 _ = happyReduce_49

action_67 _ = happyReduce_53

action_68 _ = happyReduce_61

action_69 _ = happyReduce_59

action_70 _ = happyReduce_58

action_71 (36) = happyShift action_75
action_71 (40) = happyShift action_76
action_71 _ = happyReduce_39

action_72 (21) = happyGoto action_74
action_72 (22) = happyGoto action_48
action_72 _ = happyReduce_37

action_73 _ = happyReduce_27

action_74 (41) = happyShift action_105
action_74 _ = happyFail

action_75 (21) = happyGoto action_104
action_75 (22) = happyGoto action_48
action_75 _ = happyReduce_37

action_76 (41) = happyReduce_63
action_76 (43) = happyReduce_63
action_76 (21) = happyGoto action_102
action_76 (22) = happyGoto action_48
action_76 (32) = happyGoto action_103
action_76 _ = happyReduce_37

action_77 (33) = happyShift action_69
action_77 (34) = happyShift action_70
action_77 (35) = happyShift action_71
action_77 (40) = happyShift action_72
action_77 (23) = happyGoto action_98
action_77 (30) = happyGoto action_101
action_77 (31) = happyGoto action_68
action_77 _ = happyFail

action_78 _ = happyReduce_55

action_79 _ = happyReduce_56

action_80 (33) = happyShift action_69
action_80 (34) = happyShift action_70
action_80 (35) = happyShift action_71
action_80 (40) = happyShift action_72
action_80 (23) = happyGoto action_98
action_80 (26) = happyGoto action_100
action_80 (28) = happyGoto action_66
action_80 (30) = happyGoto action_67
action_80 (31) = happyGoto action_68
action_80 _ = happyFail

action_81 (33) = happyShift action_69
action_81 (34) = happyShift action_70
action_81 (35) = happyShift action_71
action_81 (40) = happyShift action_72
action_81 (23) = happyGoto action_98
action_81 (28) = happyGoto action_99
action_81 (30) = happyGoto action_67
action_81 (31) = happyGoto action_68
action_81 _ = happyFail

action_82 _ = happyReduce_47

action_83 _ = happyReduce_43

action_84 _ = happyReduce_44

action_85 _ = happyReduce_46

action_86 _ = happyReduce_45

action_87 _ = happyReduce_48

action_88 _ = happyReduce_51

action_89 _ = happyReduce_52

action_90 _ = happyReduce_38

action_91 (41) = happyShift action_97
action_91 _ = happyFail

action_92 (41) = happyShift action_96
action_92 _ = happyFail

action_93 _ = happyReduce_33

action_94 _ = happyReduce_34

action_95 _ = happyReduce_35

action_96 (38) = happyShift action_28
action_96 (42) = happyShift action_50
action_96 (57) = happyShift action_51
action_96 (59) = happyShift action_52
action_96 (60) = happyShift action_53
action_96 (61) = happyShift action_54
action_96 (62) = happyShift action_55
action_96 (11) = happyGoto action_39
action_96 (14) = happyGoto action_110
action_96 (15) = happyGoto action_41
action_96 (16) = happyGoto action_42
action_96 (17) = happyGoto action_43
action_96 (18) = happyGoto action_44
action_96 (19) = happyGoto action_45
action_96 (20) = happyGoto action_46
action_96 (21) = happyGoto action_47
action_96 (22) = happyGoto action_48
action_96 _ = happyReduce_37

action_97 (38) = happyShift action_28
action_97 (42) = happyShift action_50
action_97 (57) = happyShift action_51
action_97 (59) = happyShift action_52
action_97 (60) = happyShift action_53
action_97 (61) = happyShift action_54
action_97 (62) = happyShift action_55
action_97 (11) = happyGoto action_39
action_97 (14) = happyGoto action_109
action_97 (15) = happyGoto action_41
action_97 (16) = happyGoto action_42
action_97 (17) = happyGoto action_43
action_97 (18) = happyGoto action_44
action_97 (19) = happyGoto action_45
action_97 (20) = happyGoto action_46
action_97 (21) = happyGoto action_47
action_97 (22) = happyGoto action_48
action_97 _ = happyReduce_37

action_98 _ = happyReduce_60

action_99 (53) = happyShift action_78
action_99 (54) = happyShift action_79
action_99 (29) = happyGoto action_77
action_99 _ = happyReduce_50

action_100 (51) = happyShift action_88
action_100 (52) = happyShift action_89
action_100 (27) = happyGoto action_81
action_100 _ = happyReduce_42

action_101 _ = happyReduce_54

action_102 _ = happyReduce_64

action_103 (41) = happyShift action_107
action_103 (43) = happyShift action_108
action_103 _ = happyFail

action_104 (37) = happyShift action_106
action_104 _ = happyFail

action_105 _ = happyReduce_57

action_106 _ = happyReduce_40

action_107 _ = happyReduce_62

action_108 (21) = happyGoto action_112
action_108 (22) = happyGoto action_48
action_108 _ = happyReduce_37

action_109 (58) = happyShift action_111
action_109 _ = happyReduce_29

action_110 _ = happyReduce_31

action_111 (38) = happyShift action_28
action_111 (42) = happyShift action_50
action_111 (57) = happyShift action_51
action_111 (59) = happyShift action_52
action_111 (60) = happyShift action_53
action_111 (61) = happyShift action_54
action_111 (62) = happyShift action_55
action_111 (11) = happyGoto action_39
action_111 (14) = happyGoto action_113
action_111 (15) = happyGoto action_41
action_111 (16) = happyGoto action_42
action_111 (17) = happyGoto action_43
action_111 (18) = happyGoto action_44
action_111 (19) = happyGoto action_45
action_111 (20) = happyGoto action_46
action_111 (21) = happyGoto action_47
action_111 (22) = happyGoto action_48
action_111 _ = happyReduce_37

action_112 _ = happyReduce_65

action_113 _ = happyReduce_30

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 ([happy_var_1]
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_2  4 happyReduction_2
happyReduction_2 (HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_2 _ _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  5 happyReduction_3
happyReduction_3 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  5 happyReduction_4
happyReduction_4 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  6 happyReduction_5
happyReduction_5 _
	(HappyTerminal happy_var_2)
	_
	 =  HappyAbsSyn5
		 (let (Posed p (Name n)) = happy_var_2
                                                          in (Intdecl (Posed p n))
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happyReduce 6 6 happyReduction_6
happyReduction_6 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (let (Posed p (Name n)) = happy_var_2;
                                                              (Posed p2 (Num i)) = happy_var_4
                                                          in (Arrdecl (Posed p n) (Posed p2 i))
	) `HappyStk` happyRest

happyReduce_7 = happyReduce 6 7 happyReduction_7
happyReduction_7 ((HappyAbsSyn11  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (let (Posed p (Name n)) = happy_var_2
                                                              in (Fundecl (Posed p n) happy_var_4 happy_var_6)
	) `HappyStk` happyRest

happyReduce_8 = happyReduce 6 7 happyReduction_8
happyReduction_8 ((HappyAbsSyn11  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (let (Posed p (Name n)) = happy_var_2
                                                              in (Procdecl (Posed p n) happy_var_4 happy_var_6)
	) `HappyStk` happyRest

happyReduce_9 = happySpecReduce_1  8 happyReduction_9
happyReduction_9 _
	 =  HappyAbsSyn4
		 ([]
	)

happyReduce_10 = happySpecReduce_1  8 happyReduction_10
happyReduction_10 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  9 happyReduction_11
happyReduction_11 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 ([happy_var_1]
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  9 happyReduction_12
happyReduction_12 (HappyAbsSyn5  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_2  10 happyReduction_13
happyReduction_13 (HappyTerminal happy_var_2)
	_
	 =  HappyAbsSyn5
		 (let (Posed p (Name n)) = happy_var_2
                                                          in Intdecl (Posed p n)
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happyReduce 4 10 happyReduction_14
happyReduction_14 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (let (Posed p (Name n)) = happy_var_2
                                                          in Arrdecl (Posed p n) (Posed p 0)
	) `HappyStk` happyRest

happyReduce_15 = happyReduce 4 11 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (CompSta happy_var_2 happy_var_3
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_0  12 happyReduction_16
happyReduction_16  =  HappyAbsSyn4
		 ([]
	)

happyReduce_17 = happySpecReduce_2  12 happyReduction_17
happyReduction_17 (HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_17 _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_0  13 happyReduction_18
happyReduction_18  =  HappyAbsSyn13
		 ([]
	)

happyReduce_19 = happySpecReduce_2  13 happyReduction_19
happyReduction_19 (HappyAbsSyn11  happy_var_2)
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  14 happyReduction_20
happyReduction_20 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  14 happyReduction_21
happyReduction_21 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  14 happyReduction_22
happyReduction_22 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  14 happyReduction_23
happyReduction_23 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  14 happyReduction_24
happyReduction_24 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  14 happyReduction_25
happyReduction_25 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  14 happyReduction_26
happyReduction_26 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  15 happyReduction_27
happyReduction_27 _
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn11
		 (ExpSta happy_var_1
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  15 happyReduction_28
happyReduction_28 _
	 =  HappyAbsSyn11
		 (EmpSta
	)

happyReduce_29 = happyReduce 5 16 happyReduction_29
happyReduction_29 ((HappyAbsSyn11  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (SelSta happy_var_3 happy_var_5 Nothing
	) `HappyStk` happyRest

happyReduce_30 = happyReduce 7 16 happyReduction_30
happyReduction_30 ((HappyAbsSyn11  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (SelSta happy_var_3 happy_var_5 (Just happy_var_7 )
	) `HappyStk` happyRest

happyReduce_31 = happyReduce 5 17 happyReduction_31
happyReduction_31 ((HappyAbsSyn11  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (IterSta happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_32 = happySpecReduce_2  18 happyReduction_32
happyReduction_32 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn11
		 (let (Posed pos _) = happy_var_1
                                              in RetSta pos Nothing
	)
happyReduction_32 _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  18 happyReduction_33
happyReduction_33 _
	(HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn11
		 (let (Posed pos _) = happy_var_1
                                              in RetSta pos (Just happy_var_2)
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  19 happyReduction_34
happyReduction_34 _
	(HappyAbsSyn23  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (ReadSta happy_var_2
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  20 happyReduction_35
happyReduction_35 _
	(HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn11
		 (let (Posed p (Symbol "write")) = happy_var_1
                                              in ExpSta $ CallEx (Posed p ">>") [happy_var_2]
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_2  21 happyReduction_36
happyReduction_36 (HappyAbsSyn21  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn21
		 (ComplEx happy_var_1 happy_var_2
	)
happyReduction_36 _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_0  22 happyReduction_37
happyReduction_37  =  HappyAbsSyn22
		 ([]
	)

happyReduce_38 = happySpecReduce_3  22 happyReduction_38
happyReduction_38 _
	(HappyAbsSyn23  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  23 happyReduction_39
happyReduction_39 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 (let (Posed p (Name n)) = happy_var_1
                                              in (Posed p n, Nothing)
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happyReduce 4 23 happyReduction_40
happyReduction_40 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (let (Posed p (Name n)) = happy_var_1
                                              in (Posed p n, Just happy_var_3)
	) `HappyStk` happyRest

happyReduce_41 = happySpecReduce_1  24 happyReduction_41
happyReduction_41 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  24 happyReduction_42
happyReduction_42 (HappyAbsSyn21  happy_var_3)
	(HappyAbsSyn25  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (let (Posed p (Symbol n)) = happy_var_2
                                                                  in CallEx (Posed p n) [happy_var_1, happy_var_3]
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  25 happyReduction_43
happyReduction_43 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_1  25 happyReduction_44
happyReduction_44 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_1  25 happyReduction_45
happyReduction_45 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_45 _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_1  25 happyReduction_46
happyReduction_46 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  25 happyReduction_47
happyReduction_47 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  25 happyReduction_48
happyReduction_48 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  26 happyReduction_49
happyReduction_49 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  26 happyReduction_50
happyReduction_50 (HappyAbsSyn21  happy_var_3)
	(HappyAbsSyn25  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (let (Posed p (Symbol n)) = happy_var_2
                                                          in CallEx (Posed p n) [happy_var_1, happy_var_3]
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_1  27 happyReduction_51
happyReduction_51 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_1  27 happyReduction_52
happyReduction_52 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  28 happyReduction_53
happyReduction_53 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  28 happyReduction_54
happyReduction_54 (HappyAbsSyn21  happy_var_3)
	(HappyAbsSyn25  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (let (Posed p (Symbol n)) = happy_var_2
                                       in CallEx (Posed p n) [happy_var_1, happy_var_3]
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_1  29 happyReduction_55
happyReduction_55 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_55 _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_1  29 happyReduction_56
happyReduction_56 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  30 happyReduction_57
happyReduction_57 _
	(HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (happy_var_2
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  30 happyReduction_58
happyReduction_58 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 (let (Posed p (Num n)) = happy_var_1
                                       in NumLiteral $ Posed p n
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  30 happyReduction_59
happyReduction_59 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 (let (Posed p (Array n)) = happy_var_1
                                       in StringLiteral $ Posed p n
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  30 happyReduction_60
happyReduction_60 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn21
		 (Retrieval happy_var_1
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_1  30 happyReduction_61
happyReduction_61 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happyReduce 4 31 happyReduction_62
happyReduction_62 (_ `HappyStk`
	(HappyAbsSyn32  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (let (Posed p (Name n)) = happy_var_1
                                       in CallEx (Posed p n) happy_var_3
	) `HappyStk` happyRest

happyReduce_63 = happySpecReduce_0  32 happyReduction_63
happyReduction_63  =  HappyAbsSyn32
		 ([]
	)

happyReduce_64 = happySpecReduce_1  32 happyReduction_64
happyReduction_64 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn32
		 ([happy_var_1]
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  32 happyReduction_65
happyReduction_65 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn32
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 63 63 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	Posed _ (Array _) -> cont 33;
	Posed _ (Num _) -> cont 34;
	Posed _ (Name _) -> cont 35;
	Posed _ (Symbol "[") -> cont 36;
	Posed _ (Symbol "]") -> cont 37;
	Posed _ (Symbol "{") -> cont 38;
	Posed _ (Symbol "}") -> cont 39;
	Posed _ (Symbol "(") -> cont 40;
	Posed _ (Symbol ")") -> cont 41;
	Posed _ (Symbol ";") -> cont 42;
	Posed _ (Symbol ",") -> cont 43;
	Posed _ (Symbol "==") -> cont 44;
	Posed _ (Symbol "=") -> cont 45;
	Posed _ (Symbol "<=") -> cont 46;
	Posed _ (Symbol "<") -> cont 47;
	Posed _ (Symbol ">=") -> cont 48;
	Posed _ (Symbol ">") -> cont 49;
	Posed _ (Symbol "!=") -> cont 50;
	Posed _ (Symbol "+") -> cont 51;
	Posed _ (Symbol "-") -> cont 52;
	Posed _ (Symbol "*") -> cont 53;
	Posed _ (Symbol "/") -> cont 54;
	Posed _ (Symbol "int") -> cont 55;
	Posed _ (Symbol "void") -> cont 56;
	Posed _ (Symbol "if") -> cont 57;
	Posed _ (Symbol "else") -> cont 58;
	Posed _ (Symbol "while") -> cont 59;
	Posed _ (Symbol "return") -> cont 60;
	Posed _ (Symbol "read") -> cont 61;
	Posed _ (Symbol "write") -> cont 62;
	_ -> happyError' (tk:tks)
	}

happyError_ 63 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = return
    (<*>) = ap
instance Monad HappyIdentity where
    return = HappyIdentity
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => [(Posed Token)] -> HappyIdentity a
happyError' = HappyIdentity . parseError

happyParseToTree tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


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
{-# LINE 1 "templates\GenericTemplate.hs" #-}
{-# LINE 1 "templates\\GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "C:\\Users\\Dantrag\\AppData\\Local\\Programs\\minghc-7.10.1-x86_64\\ghc-7.10.1\\lib/include\\ghcversion.h" #-}

















{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "templates\\GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 13 "templates\\GenericTemplate.hs" #-}

{-# LINE 46 "templates\\GenericTemplate.hs" #-}








{-# LINE 67 "templates\\GenericTemplate.hs" #-}

{-# LINE 77 "templates\\GenericTemplate.hs" #-}

{-# LINE 86 "templates\\GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 155 "templates\\GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 256 "templates\\GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 322 "templates\\GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
