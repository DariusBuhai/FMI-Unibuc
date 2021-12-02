import Test.QuickCheck
import Data.Maybe
import Data.Char


double :: Int -> Int
double x = x + x
triple :: Int -> Int
triple x = 3*x
penta :: Int -> Int
penta x = x * 5
test x = (double x + triple x) == (penta x)
myLookUp :: Int -> [(Int,String)]-> Maybe String
--myLookUp x list = let l = [s | (i,s)<-list,i==x] in if length l == 0 then Nothing else Just $ head l
myLookUp nr [] = Nothing
myLookUp nr (x : xs)
     | fst x == nr = Just (snd x)
     | otherwise = myLookUp nr xs
     
-- *Main> myLookUp 2 [(1,"mere"),(2,"pere")]
-- Just "pere"
-- *Main> myLookUp 2 [(1,"mere"),(2,"pere"),(2,"caisa")]
-- Just "pere"
-- *Main> myLookUp 2 [(1,"mere")]
-- Nothing
-- *Main> myLookUp 1 [(1,"")]
-- Just ""
-- *Main> myLookUp 1 []
-- Nothing
-- *Main> myLookUp 3 [(1,"mere"),(2,"pere"),(2,"caisa")]
-- Nothing
-- *Main> myLookUp 2 [(1,"mere"),(2,"")]
-- Just ""


testLookUp :: Int -> [(Int,String)] -> Bool
testLookUp x l = myLookUp x l == lookup x l

testLookUpCond :: Int -> [(Int,String)] -> Property
testLookUpCond n list = n > 0 && n `div` 5 == 0 ==> testLookUp n list

myLookUp' :: Int -> [(Int, String)] -> Maybe String
myLookUp' nr [] = Nothing
myLookUp' nr ((n, sirul) : t)
     | n == nr && sirul == "" = Just ""
     | n == nr = let (c:sir ) = sirul in Just ((toUpper c) : sir)  --sau daca vrem ca restul sa fie litere mici
     | otherwise = myLookUp' nr t                                  -- punem (map toLower sir) in loc de sir

-- *Main> myLookUp' 2 [(1,"mere"),(2,"pere")]
-- Just "Pere"
-- *Main> myLookUp' 2 [(1,"mere"),(2,"pere"),(2,"caisa")]
-- Just "Pere"
-- *Main> myLookUp' 2 [(1,"mere")]
-- Nothing
-- *Main> myLookUp' 1 [(1,"")]
-- Just ""
-- *Main> myLookUp' 1 []
-- Nothing
-- *Main> myLookUp' 3 [(1,"mere"),(2,"pere"),(2,"caisa")]
-- Nothing
-- *Main> myLookUp' 2 [(1,"mere"),(2,"")]
-- Just ""


testLookUp' :: Int -> [(Int,String)] -> Bool
testLookUp' x l = myLookUp' x l == lookup x l

-- *Main> quickCheck testLookUp'
-- *** Failed! Falsified (after 58 tests and 13 shrinks):
-- -44
-- [(-44,"a")]  --normal, pt ca myLookUp' schimba afisarea


capitalized :: String -> String
capitalized (h:t) = (toUpper h): t
capitalized [] = []

testLookUpCond2 :: Int -> [(Int,String)] -> Property
testLookUpCond2 n list = foldr (&&) True (map (\x ->(capitalized (snd x)) == (snd x)) list) ==> testLookUp' n list

-- *Main> quickCheck testLookUpCond2
-- +++ OK, passed 100 tests; 747 discarded.
-- *Main> quickCheck testLookUpCond2
-- +++ OK, passed 100 tests; 708 discarded.
-- *Main> quickCheck testLookUpCond2
-- +++ OK, passed 100 tests; 537 discarded.

     
data ElemIS = I Int | S String
     deriving (Show,Eq)

instance Arbitrary ElemIS where
  arbitrary = do
    i <- arbitrary
    s <- arbitrary
    elements[I i, S s]

myLookUpElem :: Int -> [(Int,ElemIS)]-> Maybe ElemIS
myLookUpElem x list = let l = [s | (i,s)<-list,i==x] in if length l == 0 then Nothing else Just $ head l

-- *Main> myLookUpElem 2 [(2,S "caisa"),(1, I 1)]
-- Just (S "caisa")
-- *Main> myLookUpElem 3 [(2,S "caisa"),(1, I 1)]
-- Nothing
-- *Main> myLookUpElem 2 [(2,S ""),(1, I 1)]
-- Just (S "")
-- *Main> myLookUpElem 2 []
-- Nothing
-- *Main> myLookUpElem 1 [(2,S "caisa"),(1, I 1)]
-- Just (I 1)

testLookUpElem :: Int -> [(Int,ElemIS)] -> Bool
testLookUpElem x l = myLookUpElem x l == lookup x l

 -- * No instance for (Arbitrary ElemIS)
        -- arising from a use of `quickCheck'  --fara Arbitrary
        
-- *Main> quickCheck testLookUpElem
-- +++ OK, passed 100 tests.
