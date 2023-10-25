module LambdaChurch where

import Data.Char (isLetter)
import Data.List ( nub )

class ShowNice a where
    showNice :: a -> String

class ReadNice a where
    readNice :: String -> (a, String)

data Variable
  = Variable
  { name :: String
  , count :: Int
  }
  deriving (Show, Eq, Ord)

var :: String -> Variable
var x = Variable x 0

instance ShowNice Variable where
    showNice (Variable x 0) = x
    showNice (Variable x cnt) = x <> "_" <> show cnt

instance ReadNice Variable where
    readNice s
      | null x = error $ "expected variable but found " <> s
      | otherwise = (var x, s')
      where
        (x, s') = span isLetter s

freshVariable :: Variable -> [Variable] -> Variable
freshVariable var vars = Variable x (cnt + 1)
  where
    x = name var
    varsWithName = filter ((== x) . name) vars
    Variable _ cnt = maximum (var : varsWithName)


data Term
  = V Variable
  | App Term Term
  | Lam Variable Term
  deriving (Show)

-- alpha-equivalence
aEq :: Term -> Term -> Bool
aEq (V x) (V x') = x == x'
aEq (App t1 t2) (App t1' t2') = aEq t1 t1' && aEq t2 t2'
aEq (Lam x t) (Lam x' t')
  | x == x'   = aEq t t'
  | otherwise = aEq (subst (V y) x t) (subst (V y) x' t')
  where
    fvT = freeVars t
    fvT' = freeVars t'
    allFV = nub ([x, x'] ++ fvT ++ fvT')
    y = freshVariable x allFV
aEq _ _ = False

v :: String -> Term
v x = V (var x)

lam :: String -> Term -> Term
lam x = Lam (var x)

lams :: [String] -> Term -> Term
lams xs t = foldr lam t xs

($$) :: Term -> Term -> Term
($$) = App
infixl 9 $$

instance ShowNice Term where
    showNice (V var) = showNice var
    showNice (App t1 t2) = "(" <> showNice t1 <> " " <> showNice t2 <> ")"
    showNice (Lam var t) = "(" <> "\\" <> showNice var <> "." <> showNice t <> ")"

instance ReadNice Term where
    readNice [] = error "Nothing to read"
    readNice ('(' : '\\' : s) = (Lam var t, s'')
      where
        (var, '.' : s') = readNice s
        (t, ')' : s'') = readNice s'
    readNice ('(' : s) = (App t1 t2, s'')
      where
        (t1, ' ' : s') = readNice s
        (t2, ')' : s'') = readNice s'
    readNice s = (V var, s')
      where
        (var, s') = readNice s

freeVars :: Term -> [Variable]
freeVars (V var) = [var]
freeVars (App t1 t2) = nub $ freeVars t1 ++ freeVars t2
freeVars (Lam var t) = filter (/= var) (freeVars t)


-- subst u x t defines [u/x]t, i.e.,  substituting u for x in t
-- for example [3/x](x + x) == 3 + 3
-- This substitution avoids variable captures so it is safe to be used when 
-- reducing terms with free variables (e.g., if evaluating inside lambda abstractions)
subst
    :: Term     -- ^ substitution term
    -> Variable -- ^ variable to be substitutes
    -> Term     -- ^ term in which the substitution occurs
    -> Term
subst u x (V y)
  | x == y    = u
  | otherwise = V y
subst u x (App t1 t2) = App (subst u x t1) (subst u x t2)
subst u x (Lam y t)
  | x == y          = Lam y t
  | y `notElem` fvU = Lam y (subst u x t)
  | x `notElem` fvT = Lam y t
  | otherwise       = Lam y' (subst u x (subst (V y') y t))
  where
    fvT = freeVars t
    fvU = freeVars u
    allFV = nub ([x] ++ fvU ++ fvT)
    y' = freshVariable y allFV

-- Normal order reduction
-- - like call by name
-- - but also reduce under lambda abstractions if no application is possible
-- - guarantees reaching a normal form if it exists
normalReduceStep :: Term -> Maybe Term
normalReduceStep (App (Lam v t) t2) = Just $ subst t2 v t
normalReduceStep (App t1 t2)
  | Just t1' <- normalReduceStep t1 = Just $ App t1' t2
  | Just t2' <- normalReduceStep t2 = Just $ App t1 t2'
normalReduceStep (Lam x t)
  | Just t' <- normalReduceStep t = Just $ Lam x t'
normalReduceStep _ = Nothing

normalReduce :: Term -> Term
normalReduce t
  | Just t' <- normalReduceStep t = normalReduce t'
  | otherwise = t

reduce :: Term -> Term
reduce = normalReduce

-- alpha-beta equivalence (for strongly normalizing terms) is obtained by
-- fully evaluating the terms using beta-reduction, then checking their
-- alpha-equivalence.
abEq :: Term -> Term -> Bool
abEq t1 t2 = aEq (reduce t1) (reduce t2)

evaluate :: String -> String
evaluate s = showNice (reduce t)
  where
    (t, "") = readNice s


-- Church Encodings in Lambda

------------
--BOOLEANS--
------------

-- A boolean is any way to choose between two alternatives (t -> t -> t)

--The boolean constant true always chooses the first alternative
cTrue :: Term
cTrue = undefined

--The boolean constant false always chooses the second alternative
cFalse :: Term
cFalse = undefined

--If is not really needed because we can use the booleans themselves, but...
cIf :: Term
cIf = undefined

--The boolean negation switches the alternatives
cNot :: Term
cNot = undefined

--The boolean conjunction can be built as a conditional
cAnd :: Term
cAnd = undefined

--The boolean disjunction can be built as a conditional
cOr :: Term
cOr = undefined

---------
--PAIRS--
---------

-- a pair with components of type a and b is a way to compute something based
-- on the values contained within the pair (a -> b -> c) -> c

-- builds a pair out of two values as an object which, when given
--a function to be applied on the values, it will apply it on them.
cPair :: Term
cPair = undefined

--first projection uses the function selecting first component on a pair
cFst :: Term
cFst = undefined

--second projection
cSnd :: Term
cSnd = undefined

-------------------
--NATURAL NUMBERS--
-------------------

-- A natural number is any way to iterate a function s a number of times 
-- over an initial value z ( (t -> t) -> t -> t )


--0 will iterate the function s 0 times over z, producing z
c0 :: Term
c0 = undefined

--1 is the the function s iterated 1 times over z, that is, z
c1 :: Term
c1 = undefined

--Successor n either
--   - applies s one more time in addition to what n does
--   - iterates s  n times over (s z)
cS :: Term
cS = undefined

-- Transform a Num value into a CNat (should yield c0 for nums <= 0)
cNat :: (Ord p, Num p) -> Term
cNat = undefined

--Addition of m and n can be done by composing n s with m s
cPlus :: Term
cPlus = undefined

--Multiplication of m and n can be done by composing n and m
cMul :: Term
cMul = undefined

--Exponentiation of m and n can be done by applying n to m
cPow :: Term
cPow = undefined

--Testing whether a value is 0 can be done through iteration
--  using a function constantly false and an initial value true
cIs0 :: Term
cIs0 = undefined

--Predecessor (evaluating to 0 for 0) can be defined iterating
--over pairs, starting from an initial value (0, 0)
cPred :: Term
cPred = undefined

--substraction from m n (evaluating to 0 if m < n) is repeated application
-- of the predeccesor function
cSub :: Term
cSub = undefined

-- m is less than (or equal to) n if when substracting n from m we get 0
cLte :: Term
cLte = lams ["m", "n"] (cIs0 $$ (cSub $$ v "m" $$ v "n"))

cGte :: Term
cGte = lams ["m", "n"] (cLte $$ v "n" $$ v "m")

cLt :: Term
cLt = lams ["m", "n"] (cNot $$ (cGte $$ v "m" $$ v "n"))

cGt :: Term
cGt = lams ["m", "n"] (cLt $$ v "n" $$ v "m")

cEq :: Term
cEq = lams ["m", "n"] (cAnd $$ (cLte $$ v "m" $$ v "n") $$ (cLte $$ v "n" $$ v "m"))

cPred' :: Term
cPred' = lam "n" (cFst $$
    (v "n"
    $$ lam "p" (lam "x" (cPair $$ v "x" $$ (cS $$ v "x"))
          $$ (cSnd $$ v "p"))
    $$ (cPair $$ c0 $$ c0)
    ))

cFactorial :: Term
cFactorial = lam "n" (cSnd $$
    (v "n"
    $$ lam "p"
        (cPair
        $$ (cS $$ (cFst $$ v "p"))
        $$ (cMul $$ (cFst $$ v "p") $$ (cSnd $$ v "p"))
        )
    $$ (cPair $$ c1 $$ c1)
    ))

cFibonacci :: Term
cFibonacci = lam "n" (cFst $$
    (v "n"
    $$ lam "p"
        (cPair
        $$ (cSnd $$ v "p")
        $$ (cPlus $$ (cFst $$ v "p") $$ (cSnd $$ v "p"))
        )
    $$ (cPair $$ c0 $$ c1)
    ))

cDivMod :: Term
cDivMod =
    lams ["m", "n"]
        (v "m"
        $$ lam "pair"
          (cIf
          $$ (cLte $$ v "n" $$ (cSnd $$ v "pair"))
          $$ (cPair
             $$ (cS $$ (cFst $$ v "pair"))
             $$ (cSub
                $$ (cSnd $$ v "pair")
                $$ v "n"
                )
             )
          $$ v "pair"
          )
        $$ (cPair $$ c0 $$ v "m")
        )

cNil :: Term
cNil = lams ["agg", "init"] (v "init")

cCons :: Term
cCons = lams ["x","l","agg", "init"]
    (v "agg"
    $$ v "x"
    $$ (v "l" $$ v "agg" $$ v "init")
    )

cList :: [Term] -> Term
cList = foldr (\x l -> cCons $$ x $$ l) cNil

cNatList :: [Integer] -> Term
cNatList = cList . map cNat

cSum :: Term
cSum = lam "l" (v "l" $$ cPlus $$ c0)

cIsNil :: Term
cIsNil = lam "l" (v "l" $$ lams ["x", "a"] cFalse $$ cTrue)

cHead :: Term
cHead = lams ["l", "default"] (v "l" $$ lams ["x", "a"] (v "x") $$ v "default")

cTail :: Term
cTail = lam "l" (cFst $$
    (v "l"
    $$ lams ["x","p"] (lam "t" (cPair $$ v "t" $$ (cCons $$ v "x" $$ v "t"))
          $$ (cSnd $$ v "p"))
    $$ (cPair $$ cNil $$ cNil)
    ))

fix :: Term
fix = lam "f" (lam "x" (v "f" $$ (v "x" $$ v "x")) $$ lam "x" (v "f" $$ (v "x" $$ v "x")))

cDivMod' :: Term
cDivMod' = lams ["m", "n"]
  (cIs0 $$ v "n"
  $$ (cPair $$ c0 $$ v "m")
  $$ (fix
      $$ lams ["f", "p"]
          (lam "x"
              (cIs0 $$ v "x"
              $$ (cLte $$ v "n" $$ (cSnd $$ v "p")
                  $$ (cPair $$ (cS $$ (cFst $$ v "p")) $$ c0)
                  $$ v "p"
                 )
              $$ (v "f" $$ (cPair $$ (cS $$ (cFst $$ v "p")) $$ v "x"))
              )
          $$ (cSub $$ (cSnd $$ v "p") $$ v "n")
          )
      $$ (cPair $$ c0 $$ v "m")
      )
  )

cSudan :: Term
cSudan = fix $$ lam "f" (lams ["n", "x", "y"]
    (cIs0 $$ v "n"
        $$ (cPlus $$ v "x" $$ v "y")
        $$ (cIs0 $$ v "y"
            $$ v "x"
            $$ (lam "fnpy"
                (v "f" $$ (cPred $$ v "n")
                $$ v "fnpy"
                $$ (cPlus $$ v "fnpy" $$ v "y")
                )
                $$ (v "f" $$ v "n" $$ v "x" $$ (cPred $$ v "y"))
                )
            )
    ))

cAckermann :: Term
cAckermann = fix $$ lam "A" (lams ["m", "n"]
    (cIs0 $$ v "m"
    $$ (cS $$ v "n")
    $$ (cIs0 $$ v "n"
        $$ (v "A" $$ (cPred $$ v "m") $$ c1)
        $$ (v "A" $$ (cPred $$ v "m")
            $$ (v "A" $$ v "m" $$ (cPred $$ v "n")))
        )
    ))
