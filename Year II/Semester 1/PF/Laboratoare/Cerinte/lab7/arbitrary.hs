{-
instance Arbitrary Int where
  arbitrary = ...

instance Arbitrary String where
  arbitrary = ...
-}

data Mine = I Int | S String
  deriving (Show, Eq, Ord)

genInt :: Gen Int
genInt = arbitrary

genString :: Gen String
genString = arbitrary

genMineInt :: Gen Mine
genMineInt = MkGen (\gen i -> I (g gen i))
  g = unGen genInt --  :: QCGen -> Int -> Int

genMineString :: Gen Mine
genMineString = MkGen (\gen i -> S (g gen i))
  g = unGen genString --  :: QCGen -> Int -> Int

instance Arbitrary Mine where
  arbitrary = oneof [genMineInt, genMineString]

{-
newtype Gen a = MkGen { unGen :: QCGen -> Int -> a }

data Gen a = MkGen { unGen :: QCGen -> Int -> a }
-}

