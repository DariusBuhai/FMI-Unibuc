
myInt = 5555555555555555555555555555555555555555555555555555555555555555555555555555555555555

double :: Integer -> Integer
double x = x+x

main = print (double myInt)

data Alegere
  = Piatra
  | Foarfeca
  | Hartie
  deriving (Eq, Show)

instance Ord Alegere where
    Piatra <= Hartie = True
    Hartie <= Foarfeca = True
    Foarfeca <= Piatra = True
