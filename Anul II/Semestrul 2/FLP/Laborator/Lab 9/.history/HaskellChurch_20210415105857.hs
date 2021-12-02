{-# LANGUAGE RankNTypes #-}
module HaskellChurch where

-- A boolean is any way to choose between two alternatives
newtype CBool = CBool {cIf :: forall t. t -> t -> t}

-- An instance to show CBools as regular Booleans
instance Show CBool where
    show b = show $ cIf b True False
