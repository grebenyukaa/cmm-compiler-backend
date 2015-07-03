module Dictutils (
    module Dictutils,
    lookup)
where
import Data.List

haskey::Eq a => a->[(a,b)]->Bool
haskey _ [] = False
haskey key (d:ict) = if key == fst d then True else haskey key ict

hasval::Eq b => b->[(a,b)]->Bool
hasval _ [] = False
hasval val (d:ict) = if val == snd d then True else hasval val ict

