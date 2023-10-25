
{- (20pct) Definiți extensia evaluării unui arbore/literal astfel încât aceasta să aibă tipul rezultat `Maybe Val`, 
unde rezultatul final să fie `Nothing` în cazul în care evaluarea se finalizează prin eroare în implementarea de la pct (2).-}

type M = Maybe

type ValM = M Int
type Val = Int

data Operatie = Add
                | If Operatie Operatie
data Lit = V Val | Id String
data Arb
   = Leaf Lit
   | Node Operatie [Arb]

type Stare = [(String, Val)]  

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