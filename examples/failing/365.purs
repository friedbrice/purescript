module Main where

class C a where
  f :: a -> a
  g :: a -> a

instance cS :: C String where
  f s = s
  g = f

main = g "Done"
