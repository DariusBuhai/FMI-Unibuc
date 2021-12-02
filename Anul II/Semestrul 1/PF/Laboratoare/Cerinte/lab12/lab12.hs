
import System.Random

newtype MyRandom a = MyRandom { runRandom :: StdGen -> (a,StdGen) }

randomPositive :: MyRandom Int
randomPositive = (MyRandom next)

randomBoundedInt :: Int -> MyRandom Int
randomBoundedInt = undefined

randomLetter :: MyRandom Char
randomLetter = undefined

random10LetterPair :: MyRandom (Int, Char)
random10LetterPair = undefined

