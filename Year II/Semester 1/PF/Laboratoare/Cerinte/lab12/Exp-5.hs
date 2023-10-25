module Exp where
import Parsing
import Control.Applicative
import Data.Char

data Exp = Lit Int
         | Id String
         | Add Exp Exp
         | Sub Exp Exp
         | Mul Exp Exp
         | Div Exp Exp
         deriving (Eq,Show)

type Env = [(String, Int)]

myLookup :: String -> [(String, Int)] -> Int
myLookup s env = case lookup s env of
    Just i -> i
    Nothing -> 0

evalExp   :: Exp -> Env -> Int
evalExp   (Id s)    env = myLookup s env
evalExp   (Lit n)   env = n
evalExp   (Add e f) env = evalExp e env + evalExp f env
evalExp   (Sub e f) env = evalExp e env - evalExp f env
evalExp   (Mul e f) env = evalExp e env * evalExp f env
evalExp   (Div e f) env = evalExp e env `div` evalExp f env

parseId :: Parser String
parseId = pure (:) <*> satisfy isAlpha <*> many (satisfy idChar)
  where
    idChar c = isAlphaNum c || c == '_'

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
          Id <$> parseId
          <|>
          char '(' *> skipSpace *> parseExp <* skipSpace <* char ')'

parseEvalExp :: String -> Env -> Int
parseEvalExp s env = evalExp e env
  where
    e = parse parseExp s