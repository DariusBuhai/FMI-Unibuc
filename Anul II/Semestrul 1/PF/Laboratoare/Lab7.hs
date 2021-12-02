import Test.QuickCheck

binom a b = a^2 + 2*a*b + b^2
test_binom a b = (binom a b) == (a+b)^2

--Pentru testare: quickCheck test_binom

myLookUp :: Int -> [(Int, String)]-> Maybe String
myLookUp x ((key, value):t) = if x == key then Just value else myLookUp x t
myLookUp _ [] = Nothing

myLookUp' x lista = 
   let  l = [value | (key, value) <- lista, key == x] in
   if l == [] then Nothing else Just (head l)

testLookUp :: Int -> [(Int, String)] -> Bool
testLookUp x lista = 
   (lookup x lista) == (myLookUp' x lista)

data ElemIS = I Int | S String deriving (Show, Eq)

instance Arbitrary ElemIS where
   arbitrary = elements [I 5, S "Salut", S "Hello", I 0]

myLookUpElem :: Int -> [(Int, ElemIS)] -> Maybe ElemIS
myLookUpElem = lookup

testLookUpElem :: Int -> [(Int, ElemIS)] -> Bool
testLookUpElem elem lista = (myLookUpElem elem lista) == (lookup elem lista)

maxshow :: (Ord x, Show y, Show y) => x -> x -> y -> y -> String
maxshow a b c d = 
   if a > b then show c
            else show d

data Lista a = Gol | a ::: (Lista a) deriving(Eq, Ord, Read)
instance Show a => Show (Lista a) where
   show Gol = "[]"
   show (head ::: tail)  = show head ++ ":" ++ show tail

data Special a = S1 | S2 deriving(Eq, Show)
data Nested a = S3 (Special a) | I2 Int deriving(Eq, Show)

instance Ord (Special a) where
   x <= y = False

-- Functor, Applicative, Mona


data Arbore a = Leaf | Nod (Arbore a) a (Arbore a)

--instance Show a => Show (Arbore a) where
--   show Leaf 

main = print("Hello world")
