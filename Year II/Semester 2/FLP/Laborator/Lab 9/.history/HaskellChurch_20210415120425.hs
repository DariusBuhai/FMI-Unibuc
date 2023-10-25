{-# LANGUAGE RankNTypes #-}
module HaskellChurch where

-- A boolean is any way to choose between two alternatives
newtype CBool = CBool {cIf :: forall t. t -> t -> t}

-- An instance to show CBools as regular Booleans
instance Show CBool where
    show b = show $ cIf b True False

--The boolean constant true always chooses the first alternative
cTrue :: CBool
cTrue = undefined

--The boolean constant false always chooses the second alternative
cFalse :: CBool
cFalse = undefined

--The boolean negation switches the alternatives
cNot :: CBool -> CBool
cNot = undefined

--The boolean conjunction can be built as a conditional
(&&:) :: CBool -> CBool -> CBool
(&&:) = undefined
infixr 3 &&:

--The boolean disjunction can be built as a conditional
(||:) :: CBool -> CBool -> CBool
(||:) = undefined
infixr 2 ||:

-- a pair is a way to compute something based on the values
-- contained within the pair.
newtype CPair a b = CPair { cOn :: forall c . (a -> b -> c) -> c }

--An instance to show CPairs as regular pairs.
instance (Show a, Show b) => Show (CPair a b) where
    show p = show $ cOn p (,)

-- builds a pair out of two values as 
cPair :: a -> b -> CPair a b
cPair = undefined

--first projection
cFst :: CPair a b -> a
cFst = undefined

--second projection
cSnd :: CPair a b -> b
cSnd = undefined


-- A natural number is any way to iterate a function a number of times 
-- over an initial value
newtype CNat = CNat { cFor :: forall t. (t -> t) -> t -> t }

-- An instance to show CNats as regular natural numbers
instance Show CNat where
    show n = show $ cFor n (1 +) (0 :: Integer)

x0 :: CNat

cS :: CNat -> CNat
cS = \t -> CNat $ \s z -> s (cFor t s z)

iterate' :: (Ord t, Num t) => t -> (p -> p) -> p -> p
iterate' n f a = go n
  where
    go n
      | n <= 0 = a
      | otherwise  = f (go (n - 1))

churchNat :: Integer -> Term
churchNat n = lams ["s", "z"] (iterate' n (v "s" $$) (v "z"))

cNat :: (Ord p, Num p) => p -> CNat
cNat n = CNat $ \s z -> (iterate' n (s $) z)

churchPlus :: Term
churchPlus = lams ["n", "m", "s", "z"] (v "n" $$ v "s" $$ (v "m" $$ v "s" $$ v "z"))

(+:) :: CNat -> CNat -> CNat
(+:) = \n m -> CNat $ \s -> cFor n s . cFor m s
infixl 6 +:

churchPlus' :: Term
churchPlus' = lams ["n", "m"] (v "n" $$ churchS $$ v "m")

churchMul :: Term
churchMul = lams ["n", "m", "s"] (v "n" $$ (v "m" $$ v "s"))

(*:) :: CNat -> CNat -> CNat
(*:) = \n m -> CNat $ cFor n . cFor m
infixl 7 *:

churchMul' :: Term
churchMul' = lams ["n", "m"] (v "n" $$ (churchPlus' $$ v "m") $$ church0)

churchPow :: Term
churchPow = lams ["m", "n"] (v "n" $$ v "m")

(^:) :: CNat -> CNat -> CNat
(^:) = \m n -> CNat $ cFor n (cFor m)
infixr 8 ^:

churchPow' :: Term
churchPow' = lams ["m", "n"] (v "n" $$ (churchMul' $$ v "m") $$ church1)

churchIs0 :: Term
churchIs0 = lam "n" (v "n" $$ (churchAnd $$ churchFalse) $$ churchTrue)

cIs0 :: CNat -> CBool
cIs0 = \n -> cFor n (cFalse &&:) cTrue

churchS' :: Term
churchS' = lam "n" (v "n" $$ churchS $$ church1)

churchS'Rev0 :: Term
churchS'Rev0 = lams ["s","z"] church0

churchPred :: Term
churchPred =
    lam "n"
        (churchIf
        $$ (churchIs0 $$ v "n")
        $$ church0
        $$ (v "n" $$ churchS' $$ churchS'Rev0))

churchSub :: Term
churchSub = lams ["m", "n"] (v "n" $$ churchPred $$ v "m")

(-:) :: CNat -> CNat -> CNat
(-:) = \m n -> cFor n cPred m

instance Num CNat where
    (+) = (+:)
    (*) = (*:)
    (-) = (-:)
    abs = id
    signum n = cIf (cIs0 n) 0 1
    fromInteger = cNat

instance Enum CNat where
    toEnum = cNat
    fromEnum n = cFor n succ 0

churchLte :: Term
churchLte = lams ["m", "n"] (churchIs0 $$ (churchSub $$ v "m" $$ v "n"))

(<=:) :: CNat -> CNat -> CBool
(<=:) = \m n -> cIs0 (m - n)
infix 4 <=:

churchGte :: Term
churchGte = lams ["m", "n"] (churchLte $$ v "n" $$ v "m")

(>=:) :: CNat -> CNat -> CBool
(>=:) = \m n -> n <=: m
infix 4 >=:

churchLt :: Term
churchLt = lams ["m", "n"] (churchNot $$ (churchGte $$ v "m" $$ v "n"))

(<:) :: CNat -> CNat -> CBool
(<:) = \m n -> cNot (m >=: n)
infix 4 <:

churchGt :: Term
churchGt = lams ["m", "n"] (churchLt $$ v "n" $$ v "m")

(>:) :: CNat -> CNat -> CBool
(>:) = \m n -> n <: m
infix 4 >:

churchEq :: Term
churchEq = lams ["m", "n"] (churchAnd $$ (churchLte $$ v "m" $$ v "n") $$ (churchLte $$ v "n" $$ v "m"))

(==:) :: CNat -> CNat -> CBool
(==:) = \m n -> m <=: n &&: n <=: m

