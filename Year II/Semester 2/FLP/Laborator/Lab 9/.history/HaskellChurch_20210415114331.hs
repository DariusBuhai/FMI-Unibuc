{-# LANGUAGE RankNTypes #-}
module HaskellChurch where

-- A boolean is any way to choose between two alternatives
newtype CBool = CBool {cIf :: forall t. t -> t -> t}

-- An instance to show CBools as regular Booleans
instance Show CBool where
    show b = show $ cIf b True False

cTrue :: CBool
cTrue = undefined

cFalse :: CBool
cFalse = undefined

cNot :: CBool -> CBool
cNot = undefined

(&&:) :: CBool -> CBool -> CBool
(&&:) = undefined
infixr 3 &&:

(||:) :: CBool -> CBool -> CBool
(||:) = undefined
infixr 2 ||:


-- A natural number is any way to iterate a function a number of times 
-- over an initial value
newtype CNat = CNat { cFor :: forall t. (t -> t) -> t -> t }

-- An instance to show CNats as regular natural numbers
instance Show CNat where
    show n = show $ cFor n (1 +) (0 :: Integer)

