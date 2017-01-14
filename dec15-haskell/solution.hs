import System.Environment
import Text.Regex.Posix
import Data.List

volume :: Int
volume = 100

calories :: Int
calories = 500

data Ingredient = Ingredient { name :: String
                             , components :: [(String, Int)]
                             } deriving Show

parseIngredient :: String -> Ingredient
parseIngredient str = Ingredient name components
  where
  [[_, name, cstr]] = str =~ "([A-Za-z]+): (.*)$" :: [[String]]
  cparts = cstr =~ "([a-z]+) (-?[0-9]+)" :: [[String]]
  components = map (\[_, s, n] -> (s, read n :: Int)) (sort cparts)

score :: Bool -> [Ingredient] -> [Int] -> Int
score countCalories ingredients amounts = factor*(product (tail scores))
  where
  factor = if countCalories && (head scores) /= calories then 0 else 1
  mulAmt = \ing amt -> map (\(_, k) -> amt*k) (components ing)
  scores = map (max 0) $ map sum $ transpose $
    zipWith mulAmt ingredients amounts

combinations :: Int -> Int -> [[Int]]
combinations vol 1 = [[vol]]
combinations vol n = [0..vol] >>=
  (\c -> map (c:) (combinations (vol - c) (n - 1)))

solve :: [Ingredient] -> Int -> Bool -> Int
solve ingredients vol countCalories = maximum scores
  where
  combs = combinations vol (length ingredients)
  scores = map (score countCalories ingredients) combs


main = do
  args <- getArgs
  let fname = if not(null args) then head args else "input.txt"
  file <- readFile fname
  let inputLines = filter (\s -> length s > 1) (lines file)
  let ingredients = map parseIngredient inputLines
  putStrLn ("Highest score 1: " ++ (show (solve ingredients volume False)))
  putStrLn ("Highest score 2: " ++ (show (solve ingredients volume True)))