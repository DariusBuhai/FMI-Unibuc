--1
sum2 [] = (0,0)
sum2 [a] = (a, 0)
sum2 (a:b:t) = 
    let last = sum2 t in
       (a + (fst last), b + (snd last))

--2
a % b = mod a b
a / b = div a b
divisor n = filter (\ x -> n % x == 0) [1..n]


--3
sumsquarediv n = foldr (\elem accum -> accum + elem*elem) 0 (divisor n)

--4
data Figura = Cerc Float | Dreptunghi Float Float | Patrat Float deriving (Show)
aria (Cerc raza) = pi * raza ^ 2
aria (Dreptunghi lungime latime) = lungime * latime
aria (Patrat latura) = latura ^ 2

--5
x +*+ y = c
   where a = x^2
         b = y^2
         c = a+b

--6
min' x y
  | x < y = x
  | otherwise = y

--7
data Expr a = Numar a | (Expr a) :+: (Expr a) | (Expr a) :*: (Expr a)
data Nat = Zero | Succ Nat deriving(Show)

egal Zero Zero = True
egal _ Zero = False
egal Zero _ = False
egal (Succ a) (Succ b) = egal a b

instance Eq Nat where
   x == y =  egal x y

instance Ord Nat where
   Zero <= _ = True
   _ <= Zero = False
   (Succ x) <= (Succ y) = (x<=y)

min3 a b c = min (min a b) c

instance Show a => Show (Expr a) where
   show (Numar x) = show x
   show (x :+: y) = show x ++ " + " ++ show y
   show (x :*: y) = "(" ++ show x ++ ") * (" ++ show y ++ ")"

class Meow a where
   meow :: a -> String

instance Show a => Meow (Expr a) where
   meow x = "meow: " ++ (show x)

instance Meow Int where
   meow 1 = "meow"
   meow n = meow (n - 1) ++ " meow"

instance Num Nat where
   Zero + x = x
   (Succ x) + y = Succ (x + y)
   
   Zero * _ = Zero
   (Succ y) * x = (y * x) + x
   
   abs x = x

   signum Zero =  Zero
   signum _ = (Succ Zero)

   x - Zero = x
   Zero - _ = error "eroare, scadem prea mult!"
   (Succ x) - (Succ y) = x - y
   
   fromInteger 0 = Zero
   fromInteger x = if x<0 then error "nu merge cu negative"
                          else Succ (fromInteger (x-1))


main = print("Working")
