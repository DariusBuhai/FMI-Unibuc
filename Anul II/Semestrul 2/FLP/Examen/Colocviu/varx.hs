-- Buhai Darius 234
-- Model: 
-- Colocviu FLP

{-Fie tipul de date Arb dat de definiția de mai jos. Aceste definiții vor fi folosite pentru toate exercițiile care urmează.

Pentru fiecare exercițiu, indicați testele pe care le-ați folosit în verificarea soluțiilor. 
-}

type Val = Int
data Operatie = Add
                | If Operatie Operatie
data Lit = V Val | Id String
data Arb
   = Leaf Lit
   | Node Operatie [Arb]

type Stare = [(String, Val)]   -- valori pentru identificatorii (`Id x`) din arbore

eval ::  Arb -> Stare -> Val
eval (Leaf v) env = val v env
eval (Node Add []) _ = 0
eval (Node Add (x:xs)) env = let v = eval x env in
                             let rest = eval (Node Add xs) env in
                             v + rest
eval (Node (If op1 op2) (x:xs)) env = let v = eval x env in
                                      if test v then
                                          eval (Node op1 xs) env
                                      else
                                          eval (Node op2 xs) env
eval (Node (If _ _) []) _ = error "lista vida"

val :: Lit -> Stare -> Val
val (V v) _ = v
val (Id i) env = case lookup i env of
                    Nothing -> error "variabila negasita"
                    (Just x) -> x

test :: Val -> Bool
test = (/= 0)

-- Teste
test1 :: Bool
test1 = eval arb1 [] == 3

test2 :: Bool
test2 = eval arb2 [("a", 10)] == 21 -- Genereaza eroarea: variabila negasita

test3 :: Bool
test3 = eval arb2 [("a", 10), ("b", 11)] == 21

test4 :: Bool
test4 = eval arb3 [("a", 10), ("b", 11)] == 26

test5 :: Bool
test5 = eval arb4 [("a", 0), ("b", 0)] == 26 -- Genereaza eroarea: lista vida

test6 :: Bool
test6 = eval arb4 [("a", 10), ("b", 5)] == 0

arb1 :: Arb
arb1 = Node Add [Leaf (V 1), Leaf (V 2)]

arb2 :: Arb
arb2 = Node Add [Node Add [Leaf (Id "a"), Leaf (Id "b")]]

arb3 :: Arb
arb3 = Node Add [Node Add [Leaf (Id "a"), Leaf (Id "b")], Leaf (V 5)]

arb4 :: Arb
arb4 = Node (If Add (If Add (If Add (If Add Add)))) [Node Add [Leaf (Id "a"), Leaf (Id "b")], Leaf (V 0)]

{-}
(10pct) 1. Finalizati definitia functiilor de interpretare astfel încât valoarea asociata 

unei expresii de forma `Nod op exps`  sa se obtina prin agregarea valorilor corespunzătoare elementelor

listei folosind operatia `op`. Pentru lista vidă se va folosi elementul neutru al operației `op`.

Valorile identificatorilor (literali de forma `Id str`) se vor obține prin căutarea asocierii `(str, v)` in stare.

În cazul în care nu se găsește o valoare pentru variabilă, se va afișa eroarea "variabila negasita" și se va încheia execuția.
-}

{- (20pct) 3. Definiți extensia evaluării unui arbore/literal astfel încât aceasta să aibă tipul rezultat `Maybe Val`, 
unde rezultatul final să fie `Nothing` în cazul în care evaluarea se finalizează prin eroare în implementarea de la pct (2).-}

type M = Maybe

type ValM = M Int

evalM ::  Arb -> Stare -> ValM
evalM (Leaf v) env = valM v env
evalM (Node Add []) _ = return 0
evalM (Node Add (x:xs)) env = do
    v <- evalM x env
    rest <- evalM (Node Add xs) env
    return $ v + rest
evalM (Node (If op1 op2) (x:xs)) env = do
    v <- evalM x env
    if test v then do
        evalM (Node op1 xs) env
    else do
        evalM (Node op2 xs) env
evalM (Node (If _ _) []) _ = Nothing

valM :: Lit -> Stare -> ValM
valM (V v) _ = return v
valM (Id i) env = lookup i env

test :: Val -> Bool
test = (/= 0)

-- Teste
test1 :: Bool
test1 = evalM arb4 [("a", 10), ("b", 5)] == return 0

test2 :: Bool
test2 = evalM arb4 [("a", 0), ("b", 0)] == Nothing

test3 :: Bool
test3 = evalM arb2 [("a", 10)] == Nothing

arb4 :: Arb
arb4 = Node (If Add (If Add (If Add (If Add Add)))) [Node Add [Leaf (Id "a"), Leaf (Id "b")], Leaf (V 0)]

arb2 :: Arb
arb2 = Node Add [Node Add [Leaf (Id "a"), Leaf (Id "b")]]