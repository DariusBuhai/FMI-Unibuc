-- http://www.inf.ed.ac.uk/teaching/courses/inf1/fp/



import Data.Char
import Data.List
import Test.QuickCheck


-- 1.
rotate :: Int -> [Char] -> [Char]
rotate n l
  | n > 0
  , n < length l
  = suf ++ pre
  where
    (pre, suf) = splitAt n l
rotate _ _ = error "număr negativ sau prea mare"

-- 2.
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l + 1 - m) (rotate m str') == str'
  where
    str' = "ab" ++ str
    l = length str + 1
    m = 1 + k `mod` l

-- 3.
makeKey :: Int -> [(Char, Char)]
makeKey n = zip alphabet (rotate n alphabet)
  where
    alphabet = ['A'..'Z']

-- 4.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp c l = head $ [y | (x, y) <- l, x == c] ++ [c]

-- 5.
encipher :: Int -> Char -> Char
encipher n c = lookUp c (makeKey n)

-- 6.
normalize :: String -> String
normalize = map toUpper . filter isAlphaNum

-- 7.
encipherStr :: Int -> String -> String
encipherStr n = map (encipher n) . normalize

-- 8.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey = map (\(x,y) -> (y,x))

-- 9.
decipher :: Int -> Char -> Char
decipher n c = lookUp c (reverseKey (makeKey n))

decipherStr :: Int -> String -> String
decipherStr = map . decipher

data Fruct
  = Mar String Bool
  | Portocala String Int

ionatanFaraVierme = Mar "Ionatan" False
goldenCuVierme = Mar "Golden Delicious" True
portocalaSicilia10 = Portocala "Sanguinello" 10

listaFructe =
    [ Mar "Ionatan" False
    , Portocala "Sanguinello" 10
    , Portocala "Valencia" 22
    , Mar "Golden Delicious" True
    , Portocala "Sanguinello" 15
    , Portocala "Moro" 12
    , Portocala "Tarocco" 3
    , Portocala "Moro" 12
    , Portocala "Valencia" 2
    , Mar "Golden Delicious" False
    , Mar "Golden" False
    , Mar "Golden" True
    ]

ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala soi _) =
    soi `elem` ["Tarocco", "Moro", "Sanguinello"]
ePortocalaDeSicilia _ = False

nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia fructe = sum [felii | p@(Portocala _ felii) <- fructe, ePortocalaDeSicilia p]

nrMereViermi :: [Fruct] -> Int
nrMereViermi fructe = length [1 | Mar _ True <- fructe]

data Linie = L [Int]

data Matrice = M [Linie]

verifica :: Matrice -> Int -> Bool
verifica (M linii) n = foldr f True linii
  where
    f (L linie) b = sum linie == n && b
--verifica (M linii) n = all (== n) (map (\(L l) -> sum l) linii)

instance Show Linie where
  show (L linie) = intercalate " " (map show linie)

instance Show Matrice where
  show (M linii) = intercalate "\n" (map show linii)

doarPozN :: Matrice -> Int -> Bool
doarPozN (M linii) n = and [all (>0) l | L l <- linii, length l == n] 