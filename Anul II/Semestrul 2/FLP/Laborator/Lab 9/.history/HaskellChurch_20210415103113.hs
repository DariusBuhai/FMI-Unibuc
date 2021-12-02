{-# LANGUAGE RankNTypes #-}
module HaskellChurch where

newtype CBool = CBool {cIf :: forall t. t -> t -> t}

instance Show CBool where
    show b = show $ cIf b True False
