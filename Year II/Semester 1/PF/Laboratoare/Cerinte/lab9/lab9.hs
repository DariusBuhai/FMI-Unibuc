
import           Prelude hiding (lookup)
import qualified Data.List as List

class Collection c where
  empty :: c key value
  singleton :: key -> value -> c key value
  insert
      :: Ord key
      => key -> value -> c key value -> c key value
  lookup :: Ord key => key -> c key value -> Maybe value
  delete :: Ord key => key -> c key value -> c key value
  keys :: c key value -> [key]
  values :: c key value -> [value]
  toList :: c key value -> [(key, value)]
  fromList :: Ord key => [(key,value)] -> c key value

newtype PairList k v
  = PairList { getPairList :: [(k, v)] }

data SearchTree key value
  = Empty
  | Node
      (SearchTree key value) -- elemente cu cheia mai mica 
      key                    -- cheia elementului
      (Maybe value)          -- valoarea elementului
      (SearchTree key value) -- elemente cu cheia mai mare

order = 1

data Element k v
  = Element k (Maybe v)
  | OverLimit

data BTree key value
  = BEmpty
  | BNode [(BTree key value, Element key value)]

