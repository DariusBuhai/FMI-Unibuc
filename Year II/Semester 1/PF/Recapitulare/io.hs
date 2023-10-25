main = do 
    putStrLn "Hello World"

salut = do 
    nume <- getLine 
    putStrLn ("Salutare " ++ nume)
    putStrLn "Heloooooo"

aplusb = do 
    a <- readLn 
    b <- readLn 
    return (a + b)

citeste_elemente 0 = return [] 
citeste_elemente n = do 
    x <- readLn
    tail <- citeste_elemente (n - 1)
    return (x:tail)

citesten = do 
    n <- readLn :: IO Int
    elemente <- citeste_elemente n
    return (elemente :: [Int])

suman = do 
    lista <- citesten 
    print (sum lista)

citeste_rand :: Read a => IO [a]
citeste_rand = do 
    line <- getLine 
    return (map read (words line))

citeste_randuri :: Read a => Int -> IO [[a]]
citeste_randuri 0 = return []
citeste_randuri n = do 
    rand <- citeste_rand 
    restul <- citeste_randuri (n - 1)
    return (rand:restul)

citeste_matrice :: Read a => IO [[a]]
citeste_matrice = do
    [n, m] <- citeste_rand :: IO [Int]
    matrice <- citeste_randuri n 
    return matrice

data Optional a = None | Some a deriving (Show, Read)
