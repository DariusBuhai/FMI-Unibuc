import Test.QuickCheck

f :: Int -> Int -> Int
f x y = x - y

-- f 3 5 = (f 3) 5 = (\y -> 3 + y) 5 = 3 + 5

test1 = map (f 3) [1, 2, 6]

test2 = map (`f` 3) [1, 2, 6]



f' :: (Int, Int) -> Int
f' (x, y) = x - y

test3 = map (\y -> f' (3, y)) [1, 2, 6]

test4 = map (\x -> f' (x, 3)) [1, 2, 6]



f'' :: (Int, Int) -> Int
f'' p = fst p + snd p

-- f' (3, 5) = 3 + 5

test :: (Int, Int) -> Bool
test (x, y) = f x y == f' (x, y)

-- Prelude> quickCheck (\(x, y) -> f x y = f' (x, y) )