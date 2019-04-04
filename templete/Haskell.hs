import Control.Monad
import Control.Applicative
import Data.List

-- String, Int, Char, 

-- e.g.
-- 1
-- [a] <- map read . words <$> getline => [1] -> a == 1
-- 1
-- a <- readlLn
-- 1 2 3
-- lst <- map read . words <$> getLine => [1, 2, 3]
-- 1 2 3
-- [l, m, n] <- map read . words <$. getLine :: IO [Int] => [1, 2, 3]
-- 'a'
-- c <- getChar => c == 'a'

main :: IO()
main = undefined
