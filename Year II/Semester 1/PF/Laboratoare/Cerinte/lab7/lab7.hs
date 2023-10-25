
double :: Int -> Int
double = undefined
triple :: Int -> Int
triple = undefined
penta :: Int -> Int
penta = undefined

test x = (double x + triple x) == (penta x)

myLookUp :: Int -> [(Int,String)]-> Maybe String
myLookUp = undefined

testLookUp :: Int -> [(Int,String)] -> Bool
testLookUp = undefined

-- testLookUpCond :: Int -> [(Int,String)] -> Property
-- testLookUpCond n list = n > 0 && n `div` 5 == 0 ==> testLookUp n list

data ElemIS = I Int | S String
     deriving (Show,Eq)

myLookUpElem :: Int -> [(Int,ElemIS)]-> Maybe ElemIS
myLookUpElem = undefined

testLookUpElem :: Int -> [(Int,ElemIS)] -> Bool
testLookUpElem = undefined

