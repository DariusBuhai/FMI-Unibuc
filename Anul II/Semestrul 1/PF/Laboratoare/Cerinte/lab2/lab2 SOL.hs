
-- la nevoie decomentati liniile urmatoare:

import Data.Char
-- import Data.List


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
    fibonacciPereche n = (b,a+b) 
        where 
           (a,b)=fibonacciPereche (n-1)

-- let (a,b)=fibonacciPereche (n-1) in (b,a+b)


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
inIntervalRec _ _ [] = []
inIntervalRec a b (x:xs) 
    | a<=x && x<=b = x: (inIntervalRec a b xs)
    | otherwise = inIntervalRec a b xs


inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b xs = [x | x<-xs , a<=x && x<=b ]

-- L2.3

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (x:xs) 
   | x>0 = 1 + pozitiveRec xs
   | otherwise = pozitiveRec xs

pozitiveComp :: [Int] -> Int
pozitiveComp xs = length [ 1 | x<-xs , x>0 ]

-- L2.4 
pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec xs = pozitiiImpareAux xs 0

pozitiiImpareAux [] _ = []
pozitiiImpareAux (x:xs) a 
    | odd x = a:(pozitiiImpareAux xs (a+1))
    | otherwise = pozitiiImpareAux xs (a+1)

pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp xs = [b | (a,b) <- zip xs [0..] , odd a ]


-- L2.5

multDigitsRec :: String -> Int
multDigitsRec "" = 1
multDigitsRec (c:s) 
   | isDigit c = (digitToInt c) * multDigitsRec s
   | otherwise = multDigitsRec s

multDigitsComp :: String -> Int
multDigitsComp sir = product [digitToInt ch | ch <- sir, isDigit ch]


-- L2.6 

discountRec :: [Float] -> [Float]
discountRec [] = []
discountRec (x:xs) 
   | discount x < 200 =  discount x : discountRec xs
   | otherwise = discountRec xs

discount :: Float -> Float     
discount x = x - 0.25 * x

discountComp :: [Float] -> [Float]
discountComp xs = [ y | x<- xs, let y = discount x, y < 200]
    


