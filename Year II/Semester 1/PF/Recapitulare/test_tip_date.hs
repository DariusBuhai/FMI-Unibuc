import Data.Char

data Poate a = Nimic | Doar a deriving (Show, Eq)

instance (Num a) => Semigroup (Poate a) where
   (Doar a) <> (Doar b) = Doar (a + b)
   (Doar a) <> Nimic = Doar a
   Nimic <> (Doar b) = Doar b
   _ <> _ = Nimic

instance (Num a) => Monoid (Poate a) where
   mempty = Nimic

instance Functor Poate where
   fmap _ Nimic = Nimic
   fmap f (Doar a) = Doar (f a) 

instance Monad Poate where
   return a = Doar a
   Nimic >>= amb = Nimic
   Doar a >>= amb = amb a

instance Applicative Poate where
   pure = return
   mf <*> ma = do
      f <- mf
      a <- ma
      return (f a)

main = undefined
