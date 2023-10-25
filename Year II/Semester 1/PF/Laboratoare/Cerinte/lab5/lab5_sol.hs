import Test.QuickCheck

import Numeric.Natural

import Data.List (genericIndex)



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

--Univ foldr

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


--Matrici

corect :: [[a]] -> Bool 
corect matrix = foldr (\(x, y) b -> x == y && b) True (zip (init list) (tail list))
  where 
       list = (map (\x -> length x) matrix)


el :: [[a]] -> Int -> Int -> a 
el matrix i j = (matrix !! i) !! j


enumera :: [a] -> [(a, Int)]
enumera list = zip list [0..]

insereazaPozitie :: ([(a, Int)], Int) -> [(a, Int, Int)]
insereazaPozitie (lista, linie) =
     map (\(x, coloana) -> (x, linie, coloana)) lista

transforma :: [[a]] -> [(a, Int, Int)]
transforma matrix = concat (map insereazaPozitie (enumera (map enumera matrix)))

transforma' :: [[a]] -> [(a, Int, Int)]
transforma' = concat . map insereazaPozitie . enumera . map enumera