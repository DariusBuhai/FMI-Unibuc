
import Data.Char
import Data.List

prelStr strin = map toUpper strin

ioString = do
           strin <- getLine
           putStrLn $ "Intrare\n" ++ strin
           let  strout = prelStr strin
           putStrLn $ "Iesire\n" ++ strout

prelNo noin = sqrt noin

ioNumber = do
           noin <- readLn :: IO Double
           putStrLn $ "Intrare\n" ++ (show noin)
           let  noout = prelNo noin
           putStrLn $ "Iesire"
           print noout

inoutFile = do
              sin <- readFile "Input.txt"
              putStrLn $ "Intrare\n" ++ sin
              let sout = prelStr sin
              putStrLn $ "Iesire\n" ++ sout
              writeFile "Output.txt" sout

readPerson :: IO (String, Int)
readPerson = do
    nume <- getLine
    varsta <- readLn
    return (nume, varsta)

showPerson :: (String, Int) -> String
showPerson (nume, varsta) = nume <> " (" <> show varsta <> " ani)"

showPersons :: [(String, Int)] -> String
showPersons [] = ""
showPersons [p] = "Cel mai in varsta este " <> showPerson p <> "."
showPersons ps =
    "Cei mai in varsta sunt: "
    <> intercalate ", " (map showPerson ps)
    <> "."

ceiMaiInVarsta :: [(a, Int)] -> [(a, Int)]
ceiMaiInVarsta ps = filter ((== m) . snd) ps
  where
    m = maximum (map snd ps)

ex1 = do
    n <- readLn :: IO Int
    persons <- sequence (replicate n readPerson)
    let ceiMai = ceiMaiInVarsta persons
    putStrLn (showPersons ceiMai)

readPersonComma :: String -> (String, Int)
readPersonComma s = (nume, read varsta)
  where
    (nume, ',':' ':varsta) = break (== ',') s

readPersons :: String -> [(String, Int)]
readPersons = map readPersonComma . lines

ex2 = do
    persons <- readPersons <$> readFile "ex2.in"
    let ceiMai = ceiMaiInVarsta persons
    putStrLn (showPersons ceiMai)

type Input = String
type Output = String
 
newtype MyIO a = MyIO { runIO :: Input -> (a, Input, Output)}

myGetChar :: MyIO Char
myGetChar = MyIO (\(c:sin) -> (c, sin, ""))
 
testMyGetChar :: Bool
testMyGetChar = runIO myGetChar "Ana" == ('A', "na", "")
 
myPutChar :: Char -> MyIO ()
myPutChar c = MyIO (\sin -> ((), sin, [c]))
 
testMyPutChar :: Bool
testMyPutChar = runIO (myPutChar 'C') "Ana" == ((), "Ana", "C")

instance Functor MyIO where
  fmap f ioa = MyIO iob
    where
      iob sin = (f a, sin', sout')
        where
          (a, sin', sout') = runIO ioa sin
 
testFunctorMyIO :: Bool
testFunctorMyIO = runIO (fmap toUpper myGetChar) "ana" == ('A', "na", "")

instance Applicative MyIO where
  pure a = MyIO (\sin -> (a, sin, ""))
  iof <*> ioa = MyIO iob
    where
      iob sin = (f a, sin'', sout' ++ sout'')
        where
          (f, sin', sout') = runIO iof sin
          (a, sin'', sout'') = runIO ioa sin'
 
testPureMyIO :: Bool
testPureMyIO = runIO (pure 'C') "Ana" == ('C', "Ana", "")
 
testApMyIO :: Bool
testApMyIO = runIO (pure (<) <*> myGetChar <*> myGetChar) "Ana" == (True, "a", "")
 
testApMyIO' :: Bool
testApMyIO' = runIO (myGetChar <* myPutChar 'E' <* myPutChar 'u') "Ana" == ('A', "na", "Eu")

instance Monad MyIO where
  return = pure
  ioa >>= k = MyIO iob
    where
      iob sin = (b, sin'', sout' ++ sout'')
        where
          (a, sin', sout') = runIO ioa sin
          (b, sin'', sout'') = runIO (k a) sin'
 
testBindMyIO :: Bool
testBindMyIO = runIO (myGetChar >>= myPutChar) "Ana" == ((), "na", "A")

readEchoTwice :: MyIO ()
readEchoTwice = do
    c <- myGetChar
    myPutChar c
    myPutChar c

testBindMyIO' :: Bool
testBindMyIO' = runIO readEchoTwice "Ana" == ((), "na", "AA")
