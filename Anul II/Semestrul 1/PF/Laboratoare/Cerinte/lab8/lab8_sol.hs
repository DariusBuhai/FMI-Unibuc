import Data.List (nub)
import Data.Maybe (fromJust)



type Nume = String
data Prop
  = Var Nume
  | F
  | T
  | Not Prop
  | Prop :|: Prop
  | Prop :&: Prop
  | Prop :->: Prop
  | Prop :<->: Prop
  deriving (Eq, Read)
infixr 2 :|:
infixr 3 :&:

p1 :: Prop
p1 = (Var "P" :|: Var "Q") :&: (Var "P" :&: Var "Q")

p2 :: Prop
p2 = (Var "P" :|: Var "Q") :&: (Not (Var "P") :&: Not (Var "Q"))

p3 :: Prop
p3 = (Var "P" :&: (Var "Q" :|: Var "R")) :&: (Not (Var "P") :&: Not (Var "Q")) :&: (Not (Var "P") :&: Not (Var "R"))

instance Show Prop where
  show (Var nume)= nume
  show (a :|: b) = "("++show a ++ "|" ++ show b++")"
  show (a :&: b) = "("++show a ++ "&" ++ show b++")"
  show (a :->: b) = "("++show a ++ "->" ++ show b++")"
  show (a :<->: b) = "("++show a ++ "<->" ++ show b++")"
  show (Not p) = "(~"++show p++")" 
  show F = "F"
  show T = "T"
  
 
test_ShowProp :: Bool
test_ShowProp =
    show (Not (Var "P") :&: Var "Q") == "((~P)&Q)"

type Env = [(Nume, Bool)]

impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust . lookup a

impl :: Bool -> Bool -> Bool
impl False _ = True
impl _ x = x

echiv :: Bool -> Bool -> Bool
echiv x y = x==y

eval :: Prop -> Env -> Bool
eval (Var x) env = impureLookup x env	
eval T _ = True
eval F _ = False
eval (Not p) env = not $ eval p env
eval (p :&: q) env = eval p env && eval q env
eval (p :|: q) env = eval p env || eval q env
eval (p :->: q) env = eval p env `impl` eval q env
eval (p :<->: q) env = eval p env `echiv` eval q env


 
test_eval = eval  (Var "P" :|: Var "Q") [("P", True), ("Q", False)] == True

variabile :: Prop -> [Nume]
variabile (Var p) = [p]
variabile (Not p) = nub $ variabile p
variabile (p :&: q) = nub $ variabile p ++ variabile q
variabile (p :|: q) = nub $ variabile p ++ variabile q
variabile (p :->: q) = nub $ variabile p ++ variabile q
variabile (p :<->: q) = nub $ variabile p ++ variabile q
variabile _ = [] -- T si F  
 
test_variabile =
  variabile (Not (Var "P") :&: Var "Q") == ["P", "Q"]

envs :: [Nume] -> [[(Nume, Bool)]]
envs [] = []
envs [x] = [[(x,False)],[(x,True)]]
envs (str:xs) = let r = envs xs in  map (\x-> (str,False):x) r  ++ map (\x->(str,True):x) r
 
test_envs = 
    envs ["P", "Q"]
    ==
    [ [ ("P",False)
      , ("Q",False)
      ]
    , [ ("P",False)
      , ("Q",True)
      ]
    , [ ("P",True)
      , ("Q",False)
      ]
    , [ ("P",True)
      , ("Q",True)
      ]
    ]

satisfiabila :: Prop -> Bool
satisfiabila p = or $ map (eval p) $ envs $ variabile p
 
test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q") == True
test_satisfiabila2 = satisfiabila (Not (Var "P") :&: Var "P") == False

valida :: Prop -> Bool
valida p = False== satisfiabila (Not p)

test_valida1 = valida (Not (Var "P") :&: Var "Q") == False
test_valida2 = valida (Not (Var "P") :|: Var "P") == True




show_Bool :: Bool -> String
show_Bool True = "T"
show_Bool False = "F"

tabelAdevar :: Prop -> String
tabelAdevar p = concat $ map (++ "\n") tabel
     where 
       vars = variabile p 
       afis_prima =  concat $ (map (++ " ") vars) ++ [show p]
       evaluari = envs vars
       aux_af tv = (show_Bool tv)++ " "
       afis_evaluare  ev = concat $ (map aux_af [snd p | p <- ev]) ++ [show_Bool (eval p ev)]
       tabel = afis_prima : (map afis_evaluare evaluari)



echivalenta :: Prop -> Prop -> Bool
echivalenta p q = all (\env -> eval (p :<->: q) env) $ envs $ nub $ variabile p ++ variabile q
 
test_echivalenta1 =
  True
  ==
  (Var "P" :&: Var "Q") `echivalenta` (Not (Not (Var "P") :|: Not (Var "Q")))
test_echivalenta2 =
  False
  ==
  (Var "P") `echivalenta` (Var "Q")
test_echivalenta3 =
  True
  ==
  (Var "R" :|: Not (Var "R")) `echivalenta` (Var "Q" :|: Not (Var "Q"))


  
  
  
  
  
  
  
  
  
  
  
tabelaAdevar1 :: Prop -> IO ()
tabelaAdevar1 = table  -- definit mai jos  
  
  -- centre a string in a field of a given width
centre :: Int -> String -> String
centre w s  =  replicate h ' ' ++ s ++ replicate (w-n-h) ' '
            where
            n = length s
            h = (w - n) `div` 2

-- make a string of dashes as long as the given string
dash :: String -> String
dash s  =  replicate (length s) '-'

-- convert boolean to T or F
fort :: Bool -> String
fort False  =  "F"
fort True   =  "T"

-- print a table with columns neatly centred
-- assumes that strings in first row are longer than any others
showTable :: [[String]] -> IO ()
showTable tab  =  putStrLn (
  unlines [ unwords (zipWith centre widths row) | row <- tab ] )
    where
      widths  = map length (head tab)

table p = tables [p]

tables :: [Prop] -> IO ()
tables ps  =
  let xs = nub (concatMap variabile ps) in
    showTable (
      [ xs            ++ ["|"] ++ [show p | p <- ps]           ] ++
      [ dashvars xs   ++ ["|"] ++ [dash (show p) | p <- ps ]   ] ++
      [ evalvars e xs ++ ["|"] ++ [fort (eval p e) | p <- ps ] | e <- envs xs]
    )
    where  dashvars xs        =  [ dash x | x <- xs ]
           evalvars e xs      =  [ fort (eval (Var x) e) | x <- xs ]
