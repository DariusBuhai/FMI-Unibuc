{-# LANGUAGE RankNTypes #-}
module HaskellChurch where

-- A boolean is any way to choose between two alternatives
newtype CBool = CBool {cIf :: forall t. t -> t -> t}

instance Show CBool where
    show b = show $ cIf b True False
