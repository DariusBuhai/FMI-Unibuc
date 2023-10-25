instance Monad M where
  return x = ...
  sw >>= f = ...

instance Applicative M where
  pure = return
  a <*> b = do
    f <- a
    f <$> b

instance Functor M where
  fmap f a = f <$> a
