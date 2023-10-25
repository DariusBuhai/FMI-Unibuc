module Exp where
import Parsing
import Control.Applicative

data Exp = Lit Int
         | Add Exp Exp
         | Mul Exp Exp
         deriving (Eq,Show)

evalExp   :: Exp -> Int
evalExp   (Lit n)    = n
evalExp   (Add e f) = evalExp e + evalExp f
evalExp   (Mul e f) = evalExp e * evalExp f


parseExp :: Parser Exp
parseExp =
    parseTerm
    <|>
    pure Add <*> parseTerm <* token (char '+') <*> parseExp
  where
    parseTerm =
          parseFactor
          <|>
          pure Mul <*> parseFactor <* token (char '*') <*> parseTerm
    parseFactor =
          Lit <$> parseInt
          <|>
          char '(' *> skipSpace *> parseExp <* skipSpace <* char ')'

