import Data.List
import Test.QuickCheck 

myInt = 5555555555555555555555555555555555555555555555555555555555555555555555555555555555555

double :: Integer -> Integer
double x = x+x

triple :: Integer -> Integer
triple x = x+x+x

penta :: Integer -> Integer
penta x = x+x+x+x+x

test x = (double x + triple x) == (penta x) 

testf x = (double x + double x) == (penta x) 

--maxim :: Integer -> Integer -> Integer
maxim x y = if (x > y) 
               then x 
          else y
               
max3 x y z = let
             u = maxim x y 
             in (maxim  u z)
             
testmax x y = ((maxim x y) >= x) && ((maxim x y) >= y)
               