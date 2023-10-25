--- Recapitulare Haskell

-- Tipuri de date
a :: Int
a = 5

b :: Integer
b = 5

c :: Char
c = 'a'

type Nume = [Char]
d :: Nume
d = "Salut"

f :: Int -> Int -> Int
f x y = x + y

g :: Int -> Int
g = f 3

h :: (Int -> Int) -> Int
h functie = functie 3

-- un nume mai bun ar fi aplica 5
h' :: (Int -> a) -> a
h' functie = functie 5

complicat x y z t w v = x + y + z * t + w * (-v)

complicat' x = \y -> \z -> \t -> \w -> \v -> complicat x y z t w v

l1 :: [Integer]
l1 = [1, 2, 3]

l2 :: [[Int]]
l2 = [[1, 2, 3], [4, 5, 6]]

--l2' :: [[Int]]
--l2' :: [[] Int]
l2' :: [] ([] Int)
l2' = (1:2:3:[]):(4:5:6:[]):[]

l3 :: [Int]
l3 = []

maybe1 :: Maybe Int
maybe1 = Just 5

maybe2 :: Maybe a
maybe2 = Nothing

maybe3 :: Num a => Maybe (Maybe a)
maybe3 = Just (Just 5)

-- Recursivitate
deduplicate [] = []
deduplicate [x] = [x]
deduplicate (x:y:t) = if x == y then deduplicate (y:t) else x:(deduplicate (y:t))

range start step = (start:(range (start+step) step))

divisori n = [x | x <- [1..n], n `mod` x == 0]

-- Concatenare
[] +++ lista = lista
(h:t) +++ lista = h:(t +++ lista)

-- Functii avansate (map, filter, foldl, foldr)
eprim x = divisori x == [1,x]
filtru_prime = filter eprim

toate_pozitive lista = foldr (\elem accum -> elem > 0 && accum) True lista

length' lista = foldr (\_ accum -> 1 + accum) 0 lista

data Expresii a = Numar a | Negare (Expresii a) | (Expresii a) :+: (Expresii a) | (Expresii a) :*: (Expresii a)
instance Show a => Show (Expresii a) where
   show (Numar x) = show x
   show (Negare x) = "-" ++ show x
   show (x :+: y) = "(" ++ show x ++ " x " ++ show y ++ ")"
   show (x :*: y) = show x ++ " * " ++ show y

   

main = print "Hello"
