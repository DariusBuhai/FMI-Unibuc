import Test.QuickCheck

import Numeric.Natural

import Data.List (genericIndex)


--7:41

produsRec :: [Integer] -> Integer
produsRec [] = 1
produsRec (x:xs) = x* produsRec xs

produsFold :: [Integer] -> Integer
produsFold = foldr (*) 1

prop_produs :: [Integer] -> Bool
prop_produs x = produsRec x == produsFold x

andRec :: [Bool] -> Bool
andRec [] = True
andRec (x:xs) = x && andRec xs

andFold :: [Bool] -> Bool
andFold = foldr (&&) True

prop_and :: [Bool] -> Bool
prop_and x = andRec x == andFold x

concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (x:xs) = x ++ concatRec xs

concatFold :: [[a]] -> [a]
concatFold = foldr (++) []

prop_concat :: Eq a => [[a]] -> Bool
prop_concat x = concatRec x == concatFold x

rmChar :: Char -> String -> String
rmChar _ [] = []
rmChar c (x:xs) = (if x==c then [] else [x]) ++ (rmChar c xs)

rmCharsRec :: String -> String -> String
rmCharsRec [] s = s
rmCharsRec (x:xs) s = rmCharsRec xs $ rmChar x s
 
test_rmchars :: Bool
test_rmchars = rmCharsRec ['a'..'l'] "fotbal" == "ot"

rmCharsFold :: String -> String -> String
rmCharsFold c s = foldr rmChar s c

prop_rmChars :: String -> String -> Bool
prop_rmChars c s = rmCharsRec c s == rmCharsFold c s

foldr_ :: (a -> b -> b) -> b -> ([a] -> b)
foldr_ op unit = f
  where
    f []     = unit
    f (a:as) = a `op` f as

sumaPatrateImpare :: [Integer] -> Integer
sumaPatrateImpare []     = 0
sumaPatrateImpare (a:as)
  | odd a = a * a + sumaPatrateImpare as
  | otherwise = sumaPatrateImpare as

sumaPatrateImpareFold :: [Integer] -> Integer
sumaPatrateImpareFold = foldr op unit
  where
    unit = 0
    a `op` suma
      | odd a     = a * a + suma
      | otherwise = suma

map_ :: (a -> b) -> [a] -> [b]
map_ f []     = []
map_ f (a:as) = f a : map_ f as

mapFold :: (a -> b) -> [a] -> [b]
mapFold f = foldr op unit
  where
    unit = []
    a `op` l = f a : l

filter_ :: (a -> Bool) -> [a] -> [a]
filter_ p [] = []
filter_ p (a:as)
  | p a       = a : filter_ p as
  | otherwise = filter_ p as

filterFold :: (a -> Bool) -> [a] -> [a]
filterFold p = foldr op unit
  where
    unit = []
    a `op` filtered
      | p a       = a : filtered
      | otherwise = filtered

semn :: [Integer] -> String
semn [] = []
semn (x:xs) | elem x [1..9] = '+' : t'
            | x==0 = '0' :t' 
            | elem x [-9.. -1] = '-' :t' 
            | otherwise = t'
			where t' = semn xs

test_semn :: Bool
test_semn = semn [5, 10, -5, 0] == "+-0" -- 10 este ignorat

semnFold :: [Integer] -> String
semnFold = foldr op unit
  where
    unit = []
    op x filtered 
		| elem x [1..9] = '+' : filtered
		| x==0 = '0' :filtered
		| elem x [-9.. -1] = '-' :filtered
		| otherwise = filtered

medie :: [Double] -> Double
medie l = f l 0 0
  where
    f :: [Double] -> Double -> Double-> Double
    f [] n suma = suma / n
    f (a:as) n suma = f as (n + 1) (suma + a)

medieFold :: [Double] -> Double
medieFold l = (foldr op unit l) 0 0  -- paranteze doar pentru claritate
  where
    unit :: Double -> Double -> Double
    unit n suma = suma / n
    op :: Double -> (Double -> Double -> Double) -> (Double -> Double -> Double)
    (a `op` r) n suma = r (n + 1) (suma + a)

pozitiiPare :: [Integer] -> [Int]
pozitiiPare l = pozPare l 0 -- al doilea argument tine minte pozitia curenta
  where
    pozPare [] _ = []
    pozPare (a:as) i
      | even a = i:pozPare as (i+1)
      | otherwise = pozPare as (i+1)

test_pozitiiPare :: Bool
test_pozitiiPare = pozitiiPare [5, 10, -5, 0] == [1,3]

pozitiiPareFold :: [Integer] -> [Int]
pozitiiPareFold l = (foldr op unit l) 0
  where
    unit :: Int -> [Int]
    unit _ = []
    op :: Integer -> (Int -> [Int]) -> (Int -> [Int])
    op a r p = undefined

zipFold :: [a] -> [b] -> [(a,b)]
zipFold as bs = (foldr op unit as) bs
  where
    unit :: [b] -> [(a,b)]
    unit = undefined
    op :: a -> ([b] -> [(a,b)]) -> [b] -> [(a,b)]
    op = undefined

logistic :: Num a => a -> a -> Natural -> a
logistic rate start = f
  where
    f 0 = start
    f n = let fnm1 = f (n-1) in  rate * fnm1 * (1 - fnm1) 

logistic0 :: Fractional a => Natural -> a
logistic0 = logistic 3.741 0.00079

ex1 :: Natural
ex1 = 20

ex20 :: Fractional a => [a]
ex20 = [1, logistic0 ex1, 3]
 
ex21 :: Fractional a => a
ex21 = head ex20
 
ex22 :: Fractional a => a
ex22 = ex20 !! 2
 
ex23 :: Fractional a => [a]
ex23 = drop 2 ex20
 
ex24 :: Fractional a => [a]
ex24 = tail ex20

ex31 :: Natural -> Bool
ex31 x = x < 7 || logistic0 (ex1 + x) > 2
 
ex32 :: Natural -> Bool
ex32 x = logistic0 (ex1 + x) > 2 || x < 7

ex33 :: Bool
ex33 = ex31 5
 
ex34 :: Bool
ex34 = ex31 7
 
ex35 :: Bool
ex35 = ex32 5
 
ex36 :: Bool
ex36 = ex32 7

findFirst :: (a -> Bool) -> [a] -> Maybe a
findFirst p [] = Nothing
findFirst p (x:xs) = if p x then Just x else findFirst p xs

findFirstNat :: (Natural -> Bool) -> Natural
findFirstNat p = n
  where Just n = findFirst p [0..]

ex4b :: Natural
ex4b = findFirstNat (\n -> n * n >= 12347)


semn :: [Integer] -> String
semn [] = []
semn (x:xs) | elem x [1..9] = '+' : t'
            | x==0 = '0' :t' 
            | elem x [-9.. -1] = '-' :t' 
            | otherwise = t'
			where t' = semn xs

test_semn :: Bool
test_semn = semn [5, 10, -5, 0] == "+-0" -- 10 este ignorat

semnFold :: [Integer] -> String
semnFold = foldr op unit
  where
    unit = []
    op x filtered 
		| elem x [1..9] = '+' : filtered
		| x==0 = '0' :filtered
		| elem x [-9.. -1] = '-' :filtered
		| otherwise = filtered


