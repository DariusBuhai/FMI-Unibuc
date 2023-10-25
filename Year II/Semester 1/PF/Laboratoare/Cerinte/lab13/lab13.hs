
import Data.Char

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

type Input = String
type Output = String
 
newtype MyIO a = MyIO { runIO :: Input -> (a, Input, Output)}

myGetChar :: MyIO Char
myGetChar = undefined
 
testMyGetChar :: Bool
testMyGetChar = runIO myGetChar "Ana" == ('A', "na", "")
 
myPutChar :: Char -> MyIO ()
myPutChar = undefined
 
testMyPutChar :: Bool
testMyPutChar = runIO (myPutChar 'C') "Ana" == ((), "Ana", "C")

instance Functor MyIO where
 
testFunctorMyIO :: Bool
testFunctorMyIO = runIO (fmap toUpper myGetChar) "ana" == ('A', "na", "")

instance Applicative MyIO where
 
testPureMyIO :: Bool
testPureMyIO = runIO (pure 'C') "Ana" == ('C', "Ana", "")
 
testApMyIO :: Bool
testApMyIO = runIO (pure (<) <*> myGetChar <*> myGetChar) "Ana" == (True, "a", "")

instance Monad MyIO where
 
testBindMyIO :: Bool
testBindMyIO = runIO (myGetChar >>= myPutChar) "Ana" == ((), "na", "A")
