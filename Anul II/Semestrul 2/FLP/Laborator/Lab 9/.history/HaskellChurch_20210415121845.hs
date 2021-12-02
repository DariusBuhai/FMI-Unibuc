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

-- builds a pair out of two values as an object which, when given
--a function to be applied on the values, it will apply it on them.
cPair :: a -> b -> CPair a b
cPair = undefined

--first projection uses the function selecting first component on a pair
cFst :: CPair a b -> a
cFst = undefined

--second projection
cSnd :: CPair a b -> b
cSnd = undefined

-- A natural number is any way to iterate a function s a number of times 
-- over an initial value z
newtype CNat = CNat { cFor :: forall t. (t -> t) -> t -> t }

-- An instance to show CNats as regular natural numbers
instance Show CNat where
    show n = show $ cFor n (1 +) (0 :: Integer)

--0 will iterate the function s 0 times over z, producing z
c0 :: CNat
c0 = undefined

--1 is the the function s iterated 1 times over z, that is, z
c1 :: CNat
c1 = undefined

--Successor n either
--   - applies s one more time in addition to what n does
--   - iterates s  n times over (s z)
cS :: CNat -> CNat
cS = undefined

--Addition of m and n is done by iterating s n times over m
(+:) :: CNat -> CNat -> CNat
(+:) = undefined
infixl 6 +:

--Multiplication of m and n can be done by composing n and m
(*:) :: CNat -> CNat -> CNat
(*:) = \n m -> CNat $ cFor n . cFor m
infixl 7 *:

--Exponentiation of m and n can be done by applying n to m
(^:) :: CNat -> CNat -> CNat
(^:) = \m n -> CNat $ cFor n (cFor m)
infixr 8 ^:

--Testing whether a value is 0 can be done through iteration
--  using a function constantly false and an initial value true
cIs0 :: CNat -> CBool
cIs0 = \n -> cFor n (\_ -> cFalse) cTrue

(-:) :: CNat -> CNat -> CNat
(-:) = \m n -> cFor n cPred m


cNat :: (Ord p, Num p) => p -> CNat
cNat n = undefined

instance Num CNat where
    (+) = (+:)
    (*) = (*:)
    (-) = (-:)
    abs = id
    signum n = cIf (cIs0 n) 0 1
    fromInteger = cNat

(<=:) :: CNat -> CNat -> CBool
(<=:) = \m n -> cIs0 (m - n)
infix 4 <=:

(>=:) :: CNat -> CNat -> CBool
(>=:) = \m n -> n <=: m
infix 4 >=:

(<:) :: CNat -> CNat -> CBool
(<:) = \m n -> cNot (m >=: n)
infix 4 <:

(>:) :: CNat -> CNat -> CBool
(>:) = \m n -> n <: m
infix 4 >:

(==:) :: CNat -> CNat -> CBool
(==:) = \m n -> m <=: n &&: n <=: m

