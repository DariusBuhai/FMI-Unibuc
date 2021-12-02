import Numeric.Natural

produsRec :: [Integer] -> Integer
produsRec = undefined



produsFold :: [Integer] -> Integer
produsFold = undefined


andRec :: [Bool] -> Bool
andRec = undefined



andFold :: [Bool] -> Bool
andFold = undefined

concatRec :: [[a]] -> [a]
concatRec = undefined



concatFold :: [[a]] -> [a]
concatFold = undefined

rmChar :: Char -> String -> String
rmChar = undefined




rmCharsRec :: String -> String -> String
rmCharsRec = undefined

test_rmchars :: Bool
test_rmchars = rmCharsRec ['a'..'l'] "fotbal" == "ot"



rmCharsFold :: String -> String -> String
rmCharsFold = undefined



logistic :: Num a => a -> a -> Natural -> a
logistic rate start = f
  where
    f 0 = start
    f n = rate * f (n - 1) * (1 - f (n - 1))




logistic0 :: Fractional a => Natural -> a
logistic0 = logistic 3.741 0.00079
ex1 :: Natural
ex1 = undefined


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
