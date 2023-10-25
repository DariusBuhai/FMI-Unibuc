import Prelude hiding (lookup)
import qualified Data.List as List

class Collection c where
    empty :: c key value
    singleton :: key -> value -> c key value
    insert:: Ord key => key -> value -> c key value -> c key value
    lookup:: Ord key => key -> c key value -> Maybe value
    delete :: Ord key => key -> c key value -> c key value
    keys :: c key value -> [key]
    keys collection = [fst x | x<- toList collection]
    values :: c key value -> [value]
    values collection = [snd x | x<- toList collection] 
    toList :: c key value -> [(key, value)]
    fromList :: Ord key => [(key, value)] -> c key value
    fromList = foldr (Prelude.uncurry insert) empty
    -- fromList list = insertInto empty list
    --     where
    --         insertInto :: Ord key => c ke value -> [(key, value)] -> c key value
    --         insertInto acc [] = acc
    --         insertInto acc (x:xs) = insertInto (insert (fst x) (snd x) acc) xs

newtype PairList  k v
    = PairList {getPairList ::[(k,v)]}

--exercitiul 1
instance Collection PairList where
  empty = PairList []
  singleton a b = PairList ([(a,b)])
  insert a b c = PairList ( getPairList c ++ [(a,b)])
  lookup k c = lookup' k (getPairList c)
    where 
      lookup' _ [] = Nothing
      lookup' a (x:xs) | fst x == a = Just (snd x)
                       | otherwise = lookup' a xs
  delete k c = PairList (delete' k (getPairList c))
    where
      delete' k (x:xs) | fst x == k = delete' k xs
                       | otherwise = x : delete' k xs
  toList c = getPairList c

--exercitiul 2
data SearchTree key value
  = Empty
  | Node
      (SearchTree key value) -- elemente cu cheia mai mica 
      key                    -- cheia elementului
      (Maybe value)          -- valoarea elementului
      (SearchTree key value) -- elemente cu cheia mai mare

instance Collection SearchTree where
  empty = Empty
  singleton a b = Node Empty a (Just b) Empty
  insert a b (Node l key value r ) | a<key = Node (insert a b l) key value r
                                   | a>key = Node l key value (insert a b r) 
                                   | a==key = Node l key (Just b) r
  insert a b Empty = singleton a b
  lookup _ Empty = Nothing
  lookup k (Node l key o r ) | k == key = o
                             | k < key = lookup k l
                             | k > key = lookup k r
  delete k (Node l key value r) | k == key = Node l key Nothing r
                                | k < key = Node (delete k l) key value r 
                                | k > key = Node l key value (delete k r)
  toList Empty = []
  toList (Node l key (Just value) r ) = toList l ++ [(key,value)] ++ toList r
  toList (Node l _ Nothing r ) = toList l++ toList r  

data Element k v
    = Element k (Maybe v)
    | OverLimit
  
--3 a
instance Eq k => Eq (Element k v) where
    (Element k1 v1) == (Element k2 v2) = k2 == k1
    --(Element k1 v1) /= (Element k2 v2) = k2 /= k1
    (Element k v) == OverLimit = False
    OverLimit == (Element k v) = False
    OverLimit == OverLimit = True

--3 b
instance Ord k => Ord (Element k v) where
    (Element k1 v1) <= (Element k2 v2) = k1 <= k1
    OverLimit <= (Element k v) = False
    (Element k v) <= OverLimit = True

--3 c 
instance (Show k, Show v) => Show (Element k v) where
    show (Element k (Just v)) = "("++ show k ++ ","++ show v++")"
    show (Element k (Nothing)) = show k
    show OverLimit = "[]"


--4
data BTree key value
  = BEmpty
  | BNode [(BTree key value, Element key value)]

instance Collection BTree where
  empty = BEmpty
  singleton a b = BNode [(BEmpty, Element a (Just b))]
--   lookup _ BEmpty = Nothing
--   lookup k list 
--     | length (filter (\t -> fst t ==k) list)==0 = Nothing
--     | length (filter (\t -> fst t ==k) list)==1 = snd (filter (\t -> fst t ==k) list)!!0
--     | otherwise = Nothing

-- get_lista_elemente :: BTree key value-> [Element key value]
-- get_lista_elemente BEmpty = []
-- get_lista_elemente (BNode tree) = [snd x | x<-tree] ++ (foldr (++) [] (map get_lista_perechi [fst x| x<-tree]))