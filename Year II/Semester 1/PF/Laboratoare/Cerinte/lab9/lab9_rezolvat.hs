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

order :: Int
order = 1

data BTree key value
  = BEmpty
  | BNode [(BTree key value, Element key value)]
  deriving (Show, Eq)

instance Collection BTree where
  empty = BEmpty
  singleton a b = BNode [(BEmpty, Element a (Just b)), (BEmpty, OverLimit)]

  lookup _ BEmpty = Nothing
  lookup k (BNode list) = go list
    where
      go ((less_than_key, OverLimit): list') = lookup k less_than_key
      go ((less_than_key, Element key o): list')
        | k == key = o
        | k < key = lookup k less_than_key
        | k > key = go list'

  delete _ BEmpty = BEmpty
  delete k (BNode list) = BNode (go list)
    where
      go ((less_than_key, OverLimit): list') = (delete k less_than_key, OverLimit): list'
      go ((less_than_key, Element key o): list')
        | k == key = (less_than_key, Element key Nothing): list'
        | k < key = ((delete k less_than_key, Element key o): list')
        | k > key = (less_than_key, Element key o): go list'

  toList BEmpty = []
  toList (BNode list) = go list
    where
      go ((less_than_key, OverLimit):_) = toList less_than_key
      go ((less_than_key, e): list') = toList less_than_key ++ elemToList e ++ go list'
      elemToList (Element key Nothing) = []
      elemToList (Element key (Just v)) = [(key, v)]

  insert k v tree = fst (insert' k v tree)
    where
      insert' k v BEmpty = (singleton k v, True)
      insert' k v (BNode list) = echilibreaza (go list)
      go ((less_than_key, OverLimit): list') =
        let (less_than_key', e) = insert' k v less_than_key
        in if e then let (BNode [(less_than_key'', element'),(greater_than_key'', OverLimit)]) = less_than_key' in [(less_than_key'', element'), (greater_than_key'',OverLimit)]
            else (less_than_key', OverLimit): list'
      go ((less_than_key, Element key o): list')
        | k == key = (less_than_key, Element key (Just v)): list'
        | k < key = 
          let (less_than_key', e) = insert' k v less_than_key
          in if e then let (BNode [(less_than_key'', element'),(greater_than_key'', OverLimit)]) = less_than_key' in (less_than_key'', element'): (greater_than_key'',Element key o): list'
             else (less_than_key', Element key o): list'
        | k > key = (less_than_key, Element key o): go list'
      echilibreaza noduri
        | lnod <= 2 * order + 1 = (BNode noduri, False)
        | otherwise = (BNode [( BNode (mici ++ [(mijlocii, OverLimit)]), emijloc), (BNode mari, OverLimit)], True)
        where
          lnod = length noduri
          mici = take order noduri
          ((mijlocii, emijloc):mari) = drop order noduri

{-
In continuarea acestui laborator vom incerca sa implementam o
versiune de B-arbori in Haskell.
Pentru a reprezenta un nod, am putea sa separam elementele de
subarbori, dar este mult mai convenabil sa le imperechem. O idee
simpla e sa imperechem fiecare subarbore cu elementul imediat in
dreapta lui.
Dar ce vom face cu ultimul subarbore? O idee ar fi sa creem un nou
element artificial care sa fie mai “mare” decat orice alt element.
Atunci ar arata cam asa:
        (k1,v1)   (k2, v2) ... (kn,vn)  OverLimit
    /           /             /           /
mai mici    intre k1      intre kn-1   mai mari decat kn
decat k1    si k2         si kn 


BEmpty

  Element 3 (Just "a")    Element 5 (Just "b")  OverLimit
   /                         /                     /
BEmpty                  BEmpty                  BEmpty
-}