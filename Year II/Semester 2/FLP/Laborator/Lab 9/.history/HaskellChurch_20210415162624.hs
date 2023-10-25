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

--Fun with arithmetic and pairs

--Define factorial. You can iterate over a pair to contain the current index and so far factorial
cFactorial :: CNat -> CNat
cFactorial = undefined

--Define Fibonacci. You can iterate over a pair to contain two consecutive numbers in the sequence
cFibonacci :: CNat -> CNat
cFibonacci = undefined

--Given m and n, compute q and r satisfying m = q * n + r. If n is not 0 then r should be less than n.
--hint repeated substraction, iterated for at most m times.
cDivMod :: CNat -> CNat -> CPair CNat CNat
cDivMod = undefined



-- a list is a way to aggregate a sequence of elements given an agge
newtype CList a = CList { cFoldR :: forall b. (a -> b -> b) -> b -> b }

instance Foldable CList where
    foldr agg init xs = cFoldR xs agg init

churchNil :: Term
churchNil = lams ["agg", "init"] (v "init")

cNil :: CList a
cNil = CList $ \agg init -> init

churchCons :: Term
churchCons = lams ["x","l","agg", "init"]
    (v "agg"
    $$ v "x"
    $$ (v "l" $$ v "agg" $$ v "init")
    )

(.:) :: a -> CList a -> CList a
(.:) = \x xs -> CList $ \agg init -> agg x (cFoldR xs agg init)

churchList :: [Term] -> Term
churchList = foldr (\x l -> churchCons $$ x $$ l) churchNil

cList :: [a] -> CList a
cList = foldr (.:) cNil

churchNatList :: [Integer] -> Term
churchNatList = churchList . map churchNat

cNatList :: [Integer] -> CList CNat
cNatList = cList . map cNat

churchSum :: Term
churchSum = lam "l" (v "l" $$ churchPlus $$ church0)

cSum :: CList CNat -> CNat
cSum = sum -- since CList is an instance of Foldable; otherwise:  \l -> cFoldR l (+) 0

churchIsNil :: Term
churchIsNil = lam "l" (v "l" $$ lams ["x", "a"] churchFalse $$ churchTrue)

cIsNil :: CList a -> CBool
cIsNil = \l -> cFoldR l (\_ _ -> cFalse) cTrue

churchHead :: Term
churchHead = lams ["l", "default"] (v "l" $$ lams ["x", "a"] (v "x") $$ v "default")

cHead :: CList a -> a -> a
cHead = \l d -> cFoldR l (\x _ -> x) d

churchTail :: Term
churchTail = lam "l" (churchFst $$
    (v "l"
    $$ lams ["x","p"] (lam "t" (churchPair $$ v "t" $$ (churchCons $$ v "x" $$ v "t"))
          $$ (churchSnd $$ v "p"))
    $$ (churchPair $$ churchNil $$ churchNil)
    ))

cTail :: CList a -> CList a
cTail = \l -> cFst $ cFoldR l (\x p -> (\t -> cPair t (x .: t)) (cSnd p)) (cPair cNil cNil)

cLength :: CList a -> CNat
cLength = \l -> cFoldR l (\_ n -> cS n) 0

fix :: Term
fix = lam "f" (lam "x" (v "f" $$ (v "x" $$ v "x")) $$ lam "x" (v "f" $$ (v "x" $$ v "x")))

divmod :: (Enum a, Num a, Ord b, Num b) => b -> b -> (a, b)
divmod m n = divmod' (0, 0)
  where
    divmod' (x, y)
      | x' <= m = divmod' (x', succ y)
      | otherwise = (y, m - x)
      where x' = x + n

divmod' m n =
  if n == 0 then (0, m)
  else
    Function.fix
    (\f p -> 
        (\x' ->
            if x' > 0 then f ((,) (succ (fst p)) x')
            else if (<=) n (snd p) then ((,) (succ (fst p)) 0)
            else p)
        ((-) (snd p) n))
    (0, m)

churchDivMod' :: Term
churchDivMod' = lams ["m", "n"]
  (churchIs0 $$ v "n"
  $$ (churchPair $$ church0 $$ v "m")
  $$ (fix
      $$ lams ["f", "p"]
          (lam "x"
              (churchIs0 $$ v "x"
              $$ (churchLte $$ v "n" $$ (churchSnd $$ v "p")
                  $$ (churchPair $$ (churchS $$ (churchFst $$ v "p")) $$ church0)
                  $$ v "p"
                 )
              $$ (v "f" $$ (churchPair $$ (churchS $$ (churchFst $$ v "p")) $$ v "x"))
              )
          $$ (churchSub $$ (churchSnd $$ v "p") $$ v "n")
          )
      $$ (churchPair $$ church0 $$ v "m")
      )
  )

churchSudan :: Term
churchSudan = fix $$ lam "f" (lams ["n", "x", "y"]
    (churchIs0 $$ v "n"
        $$ (churchPlus $$ v "x" $$ v "y")
        $$ (churchIs0 $$ v "y"
            $$ v "x"
            $$ (lam "fnpy"
                (v "f" $$ (churchPred $$ v "n")
                $$ v "fnpy"
                $$ (churchPlus $$ v "fnpy" $$ v "y")
                )
                $$ (v "f" $$ v "n" $$ v "x" $$ (churchPred $$ v "y"))
                )
            )
    ))

churchAckermann :: Term
churchAckermann = fix $$ lam "A" (lams ["m", "n"]
    (churchIs0 $$ v "m"
    $$ (churchS $$ v "n")
    $$ (churchIs0 $$ v "n"
        $$ (v "A" $$ (churchPred $$ v "m") $$ church1)
        $$ (v "A" $$ (churchPred $$ v "m")
            $$ (v "A" $$ v "m" $$ (churchPred $$ v "n")))
        )
    )
    )

