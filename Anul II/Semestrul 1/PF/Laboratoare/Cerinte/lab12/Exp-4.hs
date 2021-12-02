module Exp where
import Parsing
import Control.Applicative

data Exp = Lit Int
         | Add Exp Exp
         | Sub Exp Exp
         | Mul Exp Exp
         | Div Exp Exp
         deriving (Eq,Show)

evalExp   :: Exp -> Int
evalExp   (Lit n)    = n
evalExp   (Add e f) = evalExp e + evalExp f
evalExp   (Sub e f) = evalExp e - evalExp f
evalExp   (Mul e f) = evalExp e * evalExp f
evalExp   (Div e f) = evalExp e `div` evalExp f


parseExp :: Parser Exp
parseExp =
    parseTerm
    <|>
    pure Add <*> parseTerm <* token (char '+') <*> parseExp
    <|>
    pure Sub <*> parseTerm <* token (char '-') <*> parseTerm
    -- nu permitem expresie la - ca sa evitam problemele
  where
    parseTerm =
          parseFactor
          <|>
          pure Mul <*> parseFactor <* token (char '*') <*> parseTerm
          <|>
          pure Div <*> parseFactor <* token (char '/') <*> parseFactor
          -- nu permitem expresie la - ca sa evitam problemele
    parseFactor =
          Lit <$> parseInt
          <|>
          char '(' *> skipSpace *> parseExp <* skipSpace <* char ')'

parseEvalExp :: String -> Int
parseEvalExp s = evalExp e
  where
    e = parse parseExp s