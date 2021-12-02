factorial 0 = 1
factorial n = n * (factorial (n-1))

log2 0 = error "Nu are sens"
log2 1 = 0
log2 n = 1 + (log2 (n / 2))

length' [] = 0
length' [_] = 1
length' [_,_] = 2
length' [_,_,_] = 3
length' _ = error "Hai pa"

real_length [] = 0
real_length [_] = 1
real_length n = (real_length (tail n)) + 1

suma [] = 0
suma n = (suma (tail n)) + (head n)

imparele' [] = []
imparele' (h:t) = 
   let res = imparele' t in
   if even h then
       res
   else
       h:res

fibRec a b 0 = a
fibRec a b n = fibRec b (a + b) (n - 1)
fib n = fibRec 0 1 n

a = [1,2,3,4]
b = [x*2 | x<-a]

inInterval _ _ [] = []
inInterval x y (h:t) = 
   if h>=x && h<=y then
       h:(inInterval x y t)
    else
        inInterval x y t

pozitive l = length [x | x<-l, x>0]

pozitiiImpare [] = []
pozitiiImpare (h:t) = 
   let l = length (h:t) in
      if odd l then
          h:(pozitiiImpare t)
      else
          pozitiiImpare t
