sumImpar [] = 0
sumImpar [x] = x
sumImpar (a:b:t) = a + sumImpar(t)

zip3' [] _ _ = []
zip3' _ [] _ = []
zip3' _ _ [] = []
zip3' (ha:ta) (hb:tb) (hc:tc) = (ha,hb,hc):(zip3' ta tb tc)

factori n = [x | x <- [1..n], n `mod` x == 0]
prim n = factori n == [1,n]
numerePrime n = [x | x<-[1..n], prim x]

numerePrimeF n = filter prim [1..n]

-- filter conditie lista
-- [x | x <- lista, conditie x]

-- map transformare lista
-- [x | x <- lista, conditie x]

-- l = [x * x | x <- [1..100], even x]
aux x = x * x
l' = map aux (filter even [1..100])
l'' = map (^2) (filter even [1..100])

adunaX x l = map (+x) l
-- Sau asa...
adunaX' x = map (+x)

-- f l = [x * x - x | x <- l]
f3' l = map (\x -> x * x -x) l

ordoNat [] = True
ordoNat [x] = True
ordoNat (x:xs) = 
   let l = zip (x:xs) xs in
      and [u < v | (u,v) <- l]

-- foldl (b -> a -> b) -> b -> t a -> b
sum' l = foldl (+) 0 l
prod' l = foldl (*) 1 l

max' l = foldl max (-10000000000000) l
reverse' l = foldl (\accum x -> (x: accum)) [] l

-- main 
main = print ( "Salut" )
