
mul [] = 0
mul [x] = x
mul (a:b:c) = a * b + mul(c)

prim n = [x  | x <- [1..n], n `mod` x == 0] == [1, n]
prime n = [x | x <- [1..n], prim x]

map' f lista = foldr (\x accum -> (f x):accum) [] lista
filter' conditie lista = 
   let op x accum = if conditie x then x:accum else accum in
   foldr op [] lista

data Alegere = Piatra | Foarfece | Hartie

containsr x lista = foldr (\elem accum -> if elem == x then True else accum) False lista
containsr2 x lista = foldr (\elem accum -> (x==elem) || accum) False lista

data Expr = Numar Int 
    | Adunare Expr Expr 
    | Inmultire Expr Expr 
    | Scadere Expr Expr 
    deriving (Show)

expr = Adunare (Inmultire (Numar 2) (Adunare (Numar 5) (Numar 7))) (Numar 3)

eval (Numar n) = n
eval (Adunare expr1 expr2) = (eval expr1) + (eval expr2)
eval (Inmultire expr1 expr2) = (eval expr1) * (eval expr2)
eval (Scadere expr1 expr2) = (eval expr1) - (eval expr2)

data Stiva =  Goala | Element Int Stiva deriving (Show)

add x stiva = Element x stiva
pop Goala = error "Stiva e goala"
pop (Element x stiva) = (stiva, x)

data Optional = Nimic | Ceva Int deriving (Show)
divopt _ 0 = Nimic
divopt a b = Ceva (a `div` b)

find [] _ = Nimic
find ((a, b): t) cheie = if a == cheie then Ceva b else find t cheie

data Fructe = Mere String Int | Portocale Int | Nuci Int deriving (Show)

--main
main = print("Salut")
