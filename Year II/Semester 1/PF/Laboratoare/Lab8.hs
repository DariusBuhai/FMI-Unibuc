data MyList a = Nil | a ::: (MyList a)

instance Show a => Show (MyList a) where
   show Nil = "[]"
   show (head ::: Nil) = show head ++ "]"
   show (head ::: tail) = show head ++ "," ++ show tail

instance Functor MyList where
   fmap _ Nil = Nil
   fmap f (head ::: tail) = (f head) ::: (fmap f tail)

instance Foldable MyList where
   foldr _ accum Nil = accum
   foldr f accum (head ::: tail) = 
      let x = foldr f accum tail in
      f head x

data MyPair a b = P a b

divisori x = [y | y<-[1..x], x `mod` y == 0]

head' [] = Nothing
head' (h:_) = Just h

inverse 0 = Nothing
inverse x = Just (1.0 / x)

-- I/O folosind monade
main = do
   name <- getLine
   putStrLn ("Hello world: "++name)


-- Tema de implementat moadele:

--bind :: (Monad m) => m a -> (a -> m b) -> m b

-- starship :: (Monad m) => m (a -> b) -> m a -> m b
