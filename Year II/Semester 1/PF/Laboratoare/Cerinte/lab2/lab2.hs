-- la nevoie decomentati liniile urmatoare:

-- import Data.Char
-- import Data.List

-- pentru teste
--import Test.QuickCheck

---------------------------------------------
-------RECURSIE: FIBONACCI-------------------
---------------------------------------------

fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n
  | n < 2     = n
  | otherwise = fibonacciCazuri (n - 1) + fibonacciCazuri (n - 2)

fibonacciEcuational :: Integer -> Integer
fibonacciEcuational 0 = 0
fibonacciEcuational 1 = 1
fibonacciEcuational n =
    fibonacciEcuational (n - 1) + fibonacciEcuational (n - 2)

-- pentru testarea echivalenței celor 2 definiții de mai sus
-- testFibo :: Integer -> Property
-- testFibo n = n >= 0 && n < 25 ==> fibonacciCazuri n == fibonacciEcuational n

{-| @fibonacciLiniar@ calculeaza @F(n)@, al @n@-lea element din secvența
Fibonacci în timp liniar, folosind funcția auxiliară @fibonacciPereche@ care,
dat fiind @n >= 1@ calculează perechea @(F(n-1), F(n))@, evitănd astfel dubla
recursie. Completați definiția funcției fibonacciPereche.

Indicație:  folosiți matching pe perechea calculată de apelul recursiv.
-}
fibonacciLiniar :: Integer -> Integer
fibonacciLiniar 0 = 0
fibonacciLiniar n = snd (fibonacciPereche n)
  where
    fibonacciPereche :: Integer -> (Integer, Integer)
    fibonacciPereche 1 = (0, 1)
    fibonacciPereche n = undefined



---------------------------------------------
----------RECURSIE PE LISTE -----------------
---------------------------------------------
semiPareRecDestr :: [Int] -> [Int]
semiPareRecDestr l
  | null l    = l
  | even h    = h `div` 2 : t'
  | otherwise = t'
  where
    h = head l
    t = tail l
    t' = semiPareRecDestr t

semiPareRecEq :: [Int] -> [Int]
semiPareRecEq [] = []
semiPareRecEq (h:t)
  | even h    = h `div` 2 : t'
  | otherwise = t'
  where t' = semiPareRecEq t

---------------------------------------------
----------DESCRIERI DE LISTE ----------------
---------------------------------------------
semiPareComp :: [Int] -> [Int]
semiPareComp l = [ x `div` 2 | x <- l, even x ]


-- L2.2
inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec lo hi xs = undefined

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp lo hi xs = undefined

-- L2.3

pozitiveRec :: [Int] -> Int
pozitiveRec l = undefined


pozitiveComp :: [Int] -> Int
pozitiveComp l = undefined

-- L2.4 
pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec l = undefined


pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l = undefined


-- L2.5

multDigitsRec :: String -> Int
multDigitsRec sir = undefined

multDigitsComp :: String -> Int
multDigitsComp sir = undefined

-- L2.6 

discountRec :: [Float] -> [Float]
discountRec list = undefined

discountComp :: [Float] -> [Float]
discountComp list = undefined


