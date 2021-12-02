import Data.Char
import Data.List

{-
 1. Write a function f :: Char -> Bool that determines whether or not an alphabetic character
 is in the first half of the alphabet (letters before M, inclusive) or not. It should work
 for upper and lower case letters.
 For any character that is not an alphabetic character, f should return an error.
-}
f c = if isAlpha c then
          toLower(c)<='m'
      else
          error "Nu e caracter"

{-
 2. Using f defined above, define a function g :: String -> Bool that given a string returns
 True if the string contains more letters in the first half of the alphabet than in the second half,
 ignoring any character that is not an alphabetic character.
-}
g s = let str1 = filter isAlpha s in
      let str2 = filter f str1 in
      (length str1) `div` 2 < length str2

{-
 3. Again using f, define a function h :: String -> Bool that behaves identically to g, this time using basic
 functions and recursion, but not list comprehension or library functions.
-}
h' _ [] = []
h' fun (x:tail) = if fun x then
                    (x:(h' fun tail))
                  else
                     h' fun tail

h s = let str1 = h' isAlpha s in
      let str2 = h' f str1 in
      (length str1) `div` 2 < length str2

{-
 4. Write a function c :: [Int] -> [Int] that returns a list containing all of the elements in the argument list
 that occur twice in succession. If an element occurs n times in succession, for n >= 2, then it should appear
 n - 1 times in succession in the result. The value of the function applied to the empty list does not need to be defined.

 c [3, 1, 1, 3, 3, 5] = [1, 3]
 c [4, 1, 1, 1, 4, 4] = [1, 1, 4]
 Your definition may use basic functions, list comprehension, and library functions, but not recursion.
-}

c [] = []
c (h:t) = [x | (x,y)<-zip(h:t) t,x == y] 

{-
 5. Define a second function d :: [Int] -> [Int] that behaves identically to c, but this time using basic functions
 and recursion, but not list comprehension or other library functions.
-}
d [] = []
d [_] = []
d (h1:h2:t) = if h1 == h2 then h1:(d (h2:t))
                        else d (h2:t)

{-
 6. Write a QuickCheck property prop_cd to confirm that c and d behave identically.
 Give the type signature of prop_cd and its definition.
-}
--prop_cd = 
--conditie :: Parametrul1 -> Parametrul2 -> ... -> Bool
--conditie ...
prop_cd lista = (c lista) == (d lista)


-- List functions
--1
rotate x key = 
   if x > length key then
       error "Nu-mi place parametrul"
   else
       let newn = take x key in
       (drop x key) ++ newn

--2
prop_rotate k str = rotate (l-m) (rotate m str) == str
                    where l = length str
                          m = if l == 0 then 0 else k `mod` l
--3
makeKey n = zip ['A'..'Z'] (rotate n ['A'..'Z'])

--4
lookUp :: Char -> [(Char, Char)] -> Char
lookUp c lista = head [y | (x, y) <- (lista ++ [(c, c)]), x == c]

--5
enchiper :: Int -> Char -> Char
enchiper n c = lookUp c (makeKey n)

--6
normalize string =  let s2 = filter isAlphaNum string in
                    map toUpper s2
--7
enchiperStr :: Int -> String -> String
enchiperStr n str = [enchiper n x | x <- normalize str]

--8
reverseKey cheie = [(y,x) | (x,y)<-cheie]

--9
dechiper :: Int -> Char -> Char
dechiper n c = let key = reverseKey (makeKey n) in
   lookUp c key

dechiperStr :: Int -> String -> String
dechiperStr n str = [dechiper n x | x <- str]

prop_cipher n string = 
   let m = n `mod` 26 in
   let s = normalize string in
   dechiperStr m (enchiperStr m s) == string

----------
data Linie = L [Int]
data Matrice = M [Linie]

m = (M [L [1,2,3], L [4,5]])

instance Show Linie where
         show (L []) = ""
         show (L [x]) = show x
         show (L (h:t)) = (show h) ++ " " ++ (show (L t))

instance Show Matrice where
         show (M []) = ""
         show (M [x]) = show x
         show (M (h:t)) = (show h) ++ "\n" ++ (show (M t))

--- Ex
map' f lista = foldr (\x accum -> (f x):accum) [] lista
filter' f lista = foldr (\x accum -> if f x then x:accum else accum) [] lista

verifica :: Matrice -> Int -> Bool
verifica (M linii) n = 
    let aux (L inturile) = foldr (+) 0 inturile in
    let l2 = map' aux linii in
    (filter' (/=n) l2) == []


main = print("Hello")
