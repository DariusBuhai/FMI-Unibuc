module HaskellChurchMonad where

-- A boolean is any way to choose between two alternatives
newtype CBool t = CBool {cIf :: t -> t -> t}

toBool :: CBool Bool -> Bool
toBool b = cIf b True False

--The boolean constant true always chooses the first alternative
cTrue :: CBool t
cTrue = CBool $ \t f -> t

--The boolean constant false always chooses the second alternative
cFalse :: CBool t
cFalse = CBool $ \t f -> f

--The boolean negation switches the alternatives
cNot :: CBool t -> CBool t
cNot b = CBool $ \t f -> cIf b f t

--The boolean conjunction can be built as a conditional
(&&:) :: CBool t -> CBool t -> CBool t
b1 &&: b2 = CBool $ \t f -> cIf b1 (cIf b2 t f) f
infixr 3 &&:

--The boolean disjunction can be built as a conditional
(||:) :: CBool t -> CBool t -> CBool t
b1 ||: b2 = CBool $ \t f -> cIf b1 t (cIf b2 t f)
infixr 2 ||:

-- a pair is a way to compute something based on the values
-- contained within the pair.
newtype CPair a b t = CPair { cOn :: (a -> b -> t) -> t }

toPair :: CPair a b (a,b) -> (a,b)
toPair p = cOn p (,)

-- builds a pair out of two values as an object which, when given
--a function to be applied on the values, it will apply it on them.
cPair :: a -> b -> CPair a b t
cPair a b = CPair $ \f -> f a b

--first projection uses the function selecting first component on a pair
cFst :: CPair a b a -> a
cFst p = cOn p (\f s -> f)

--second projection
cSnd :: CPair a b b -> b
cSnd p = cOn p (\f s -> s)

-- A natural number is any way to iterate a function s a number of times 
-- over an initial value z
newtype CNat t = CNat { cFor :: (t -> t) -> t -> t }

-- An instance to show CNats as regular natural numbers
toNat :: CNat Integer -> Integer
toNat n = cFor n (1 +) 0

--0 will iterate the function s 0 times over z, producing z
c0 :: CNat t
c0 = CNat $ \s z -> z

--1 is the the function s iterated 1 times over z, that is, z
c1 :: CNat t
c1 = CNat $ \s z -> s z

--Successor n either
--   - applies s one more time in addition to what n does
--   - iterates s  n times over (s z)
cS :: CNat t -> CNat t
cS n = CNat $ \s z -> s (cFor n s z)

--Addition of m and n is done by iterating s n times over m
(+:) :: CNat t -> CNat t -> CNat t
m +: n = CNat $ \s z -> cFor n s . cFor m s
infixl 6 +:

--Multiplication of m and n can be done by composing n and m
(*:) :: CNat t -> CNat t -> CNat t
m *: n = CNat $ cFor n . cFor m
infixl 7 *:

{-
--Exponentiation of m and n can be done by applying n to m
(^:) :: CNat -> CNat -> CNat
(^:) = \m n -> CNat $ cFor n (cFor m)
infixr 8 ^:

--Testing whether a value is 0 can be done through iteration
--  using a function constantly false and an initial value true
cIs0 :: CNat -> CBool
cIs0 = \n -> cFor n (\_ -> cFalse) cTrue

--Predecessor (evaluating to 0 for 0) can be defined iterating
--over pairs, starting from an initial value (0, 0)
cPred :: CNat -> CNat
cPred = undefined

--substraction from m n (evaluating to 0 if m < n) is repeated application
-- of the predeccesor function
(-:) :: CNat -> CNat -> CNat
(-:) = \m n -> cFor n cPred m

-- Transform a Num value into a CNat (should yield c0 for nums <= 0)
cNat :: (Ord p, Num p) => p -> CNat
cNat n = undefined

-- We can define an instance Num CNat which will allow us to see any
-- integer constant as a CNat (e.g.   12 :: CNat ) and also use regular
-- arithmetic
instance Num CNat where
    (+) = (+:)
    (*) = (*:)
    (-) = (-:)
    abs = id
    signum n = cIf (cIs0 n) 0 1
    fromInteger = cNat

-- m is less than (or equal to) n if when substracting n from m we get 0
(<=:) :: CNat -> CNat -> CBool
(<=:) = undefined
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

-- equality on naturals can be defined my means of comparisons
(==:) :: CNat -> CNat -> CBool
(==:) = undefined

-}