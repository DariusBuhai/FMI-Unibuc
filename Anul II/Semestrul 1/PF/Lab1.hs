double :: Int -> Int
double x = x*2

z = if 5 > 3 then 2 else 4

modul x = if x < 0 then -x else x
aux x = x^100

f x y  = 
   let lx = length x in
   let ly = length y in
   lx^2 + ly^2 + lx*ly
minim x y z =
    let a = min x y in
        min a z
maxim x y z = 
    let a = max x y in
        max a z

data Alegere = Piatra | Foarfece | Hartie deriving (Eq, Show)
castiga Piatra Foarfece = 1
castiga Foarfece Hartie = 1
castiga Hartie Piatra = 1
castiga Piatra Hartie = 2
castiga Hartie Foarfece = 2
castiga Foarfece Piatra = 2
castiga _ _ = 3

-- main 
main = print ( castiga Piatra Hartie )
