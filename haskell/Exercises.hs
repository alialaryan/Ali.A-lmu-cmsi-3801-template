module Exercises
  ( change,
    firstThenApply,
    powers,
    meaningfulLineCount,
    BST (Empty, Node),
    size,
    Shape (Box, Sphere),
    volume,
    surfaceArea,
    insert,
    inorder,
    contains,
  )
where

import Data.Char (isSpace)
import Data.List (find, isPrefixOf)
import Data.Map qualified as Map
import Data.Text (pack, replace, unpack)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
  | amount < 0 = Left "amount cannot be negative"
  | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
  where
    changeHelper [] remaining counts = counts
    changeHelper (d : ds) remaining counts =
      changeHelper ds newRemaining newCounts
      where
        (count, newRemaining) = remaining `divMod` d
        newCounts = Map.insert d count counts


firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply a p f = f <$> find p a
  where
    find :: (a -> Bool) -> [a] -> Maybe a
    find _ [] = Nothing
    find p (x : xs)
      | p x = Just x
      | otherwise = find p xs


powers :: (Integral a) => a -> [a]
powers b = map (b ^) [0 ..]


-- Video helper
meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount path = do
  contents <- readFile path
  return $ length $ filter meaningfulLine $ lines contents
  where
    meaningfulLine line = not (all isSpace line) && not ("--" `isPrefixOf` line)


data Shape
  = Sphere Double
  | Box Double Double Double
  deriving (Eq, Show)

volume :: Shape -> Double
volume (Sphere r) = (4 / 3) * pi * r ^ 3
volume (Box l w h) = l * w * h

surfaceArea :: Shape -> Double
surfaceArea (Sphere r) = 4 * pi * r ^ 2
surfaceArea (Box l w h) = l * w * 2 + (l * h) * 2 + (w * h) * 2


data BST a
  = Empty
  | Node (BST a) a (BST a)
  deriving (Eq)

instance (Show a) => Show (BST a) where
  show Empty = "()"
  show (Node left x right) = "Node " ++ show left ++ " " ++ show x ++ " " ++ show right

size :: BST a -> Int
size Empty = 0
size (Node left _ right) = 1 + size left + size right

contains :: (Ord a) => a -> BST a -> Bool
contains _ Empty = False
contains v (Node left x right)
  | v == x = True
  | v < x = contains v left
  | otherwise = contains v right

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node left x right) = inorder left ++ [x] ++ inorder right

insert :: (Ord a) => a -> BST a -> BST a
insert v Empty = Node Empty v Empty
insert v (Node left x right)
  | v < x = Node (insert v left) x right
  | v > x = Node left x (insert v right)
  | otherwise = Node left x right
