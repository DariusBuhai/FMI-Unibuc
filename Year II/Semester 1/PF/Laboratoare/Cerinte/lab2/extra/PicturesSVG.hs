-----------------------------------------------------------------------
--
-- 	Haskell: The Craft of Functional Programming, 3e
-- 	Simon Thompson
-- 	(c) Addison-Wesley, 1996-2011.
-- 
-- 	PicturesSVG
--
--      The Pictures functionality implemented by translation  
--      SVG (Scalable Vector Graphics)
--
--      These Pictures could be rendered by conversion to ASCII art,
--      but instead are rendered into SVG, which can then be viewed in 
--      a browser: google chrome does a good job. 
--
-----------------------------------------------------------------------


module PicturesSVG where

import System.IO
import Test.QuickCheck
import Control.Monad (liftM, liftM2)

-- Pictures represened by a type of trees, so this is a deep
-- embedding.

data Picture 
 = Img Image 
 | Above Picture Picture
 | Beside Picture Picture
 | Over Picture Picture
 | FlipH Picture
 | FlipV Picture
 | Invert Picture
 | Empty
   deriving (Eq,Show)

-- Coordinates are pairs (x,y) of integers
--
--  o------> x axis
--  |
--  |
--  V
--  y axis


type Point = (Int,Int)

-- The Point in an Image gives the dimensions of the image in pixels.

data Image = Image Name Point
             deriving (Eq,Show)

data Name  = Name String
             deriving (Eq,Show)

--
-- The functions over Pictures
--

above, beside, over :: Picture -> Picture -> Picture 

above x Empty = x
above Empty x = x
above x y   = Above x y
beside Empty x = x
beside x Empty = x
beside x y = Beside x y 
over x Empty = x
over Empty x = x
over  x y  = Over x y
 
-- flipH is flip in a horizontal axis
-- flipV is flip in a vertical axis
-- negative negates each pixel

-- The definitions of flipH, flipV, negative push the 
-- constructors through the binary operations to the images 
-- at the leaves.

-- Original implementation incorrect: it pushed the 
-- flipH and flipV through all constructors ... 
-- Now it distributes appropriately over Above, Beside and Over.

flipH, flipV, invert :: Picture -> Picture 

flipH (Above pic1 pic2)  = (flipH pic2) `Above` (flipH pic1)
flipH (Beside pic1 pic2) = (flipH pic1) `Beside` (flipH pic2)
flipH (Over pic1 pic2)   = (flipH pic1) `Over` (flipH pic2)
flipH pic                = FlipH pic

flipV (Above pic1 pic2)  = (flipV pic1) `Above` (flipV pic2)
flipV (Beside pic1 pic2) = (flipV pic2) `Beside` (flipV pic1)
flipV (Over pic1 pic2)   = (flipV pic1) `Over` (flipV pic2)
flipV pic                = FlipV pic

invert = Invert

invertColour = Invert

-- Convert an Image to a Picture

img :: Image -> Picture 

img = Img

--
-- Library functions
--

-- Dimensions of pictures

width,height :: Picture -> Int

width (Img (Image _ (x,_))) = x 
width (Above pic1 pic2)     = max (width pic1) (width pic2)
width (Beside pic1 pic2)    = (width pic1) + (width pic2)
width (Over pic1 pic2)      = max (width pic1) (width pic2)
width (FlipH pic)           = width pic
width (FlipV pic)           = width pic
width (Invert pic)          = width pic

height (Img (Image _ (x,y))) = y 
height (Above pic1 pic2)     = (height pic1) + (height pic2)
height (Beside pic1 pic2)    = max (height pic1) (height pic2)
height (Over pic1 pic2)      = max (height pic1) (height pic2)
height (FlipH pic)           = height pic
height (FlipV pic)           = height pic
height (Invert pic)          = height pic

--
-- Converting pictures to a list of basic images.
--

-- A Filter represents which of the actions of flipH, flipV 
-- and invert is to be applied to an image in forming a
-- Basic picture.

data Filter = Filter {fH, fV, neg :: Bool}
              deriving (Show)

newFilter = Filter False False False

data Basic = Basic Image Point Filter
             deriving (Show)

-- Flatten a picture into a list of Basic pictures.
-- The Point argument gives the origin for the coversion of the
-- argument.

flatten :: Point -> Picture -> [Basic]

flatten (x,y) (Img image)        = [Basic image (x,y) newFilter] 
flatten (x,y) (Above pic1 pic2)  = flatten (x,y) pic1 ++ flatten (x, y + height pic1) pic2
flatten (x,y) (Beside pic1 pic2) = flatten (x,y) pic1 ++ flatten (x + width pic1 , y) pic2
flatten (x,y) (Over pic1 pic2)   = flatten (x,y) pic2 ++ flatten (x,y) pic1
flatten (x,y) (FlipH pic)        = map flipFH $ flatten (x,y) pic
flatten (x,y) (FlipV pic)        = map flipFV $ flatten (x,y) pic
flatten (x,y) (Invert pic)       = map flipNeg $ flatten (x,y) pic
flatten (x,y) Empty              = [] 

-- flip one of the flags for transforms / filter

flipFH (Basic img (x,y) f@(Filter {fH=boo}))   = Basic img (x,y) f{fH = not boo}
flipFV (Basic img (x,y) f@(Filter {fV=boo}))   = Basic img (x,y) f{fV = not boo}
flipNeg (Basic img (x,y) f@(Filter {neg=boo})) = Basic img (x,y) f{neg = not boo}

--
-- Convert a Basic picture to an SVG image, represented by a String.
--

convert :: Basic -> String

convert (Basic (Image (Name name) (width, height)) (x,y) (Filter fH fV neg))
  = "\n  <image x=\"" ++ show x ++ "\" y=\"" ++ show y ++ "\" width=\"" ++ show width ++ "\" height=\"" ++
    show height ++ "\" xlink:href=\"" ++ name ++ "\"" ++ flipPart ++ negPart ++ "/>\n"
        where
          flipPart 
              = if      fH && not fV 
                then " transform=\"translate(0," ++ show (2*y + height) ++ ") scale(1,-1)\" " 
                else if fV && not fH 
                then " transform=\"translate(" ++ show (2*x + width) ++ ",0) scale(-1,1)\" " 
                else if fV && fH 
                then " transform=\"translate(" ++ show (2*x + width) ++ "," ++ show (2*y + height) ++ ") scale(-1,-1)\" " 
                else ""
          negPart 
              = if neg 
                then " filter=\"url(#negative)\"" 
                else "" 

-- Outputting a picture.
-- The effect of this is to write the SVG code into a file
-- whose path is hardwired into the code. Could easily modify so
-- that it is an argument of the call, and indeed could also call
-- the browser to update on output.

render :: Picture -> IO ()

render pic 
 = 
   let
       picList = flatten (0,0) pic
       svgString = concat (map convert picList)
       newFile = preamble ++ svgString ++ postamble
   in
     do
       outh <- openFile "svgOut.xml" WriteMode
       hPutStrLn outh newFile
       hClose outh

-- Preamble and postamble: boilerplate XML code. 

preamble
 = "<svg width=\"100%\" height=\"100%\" version=\"1.1\"\n" ++
   "xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n" ++
   "<filter id=\"negative\">\n" ++
   "<feColorMatrix type=\"matrix\"\n"++
   "values=\"-1 0  0  0  0  0 -1  0  0  0  0  0 -1  0  0  1  1  1  0  0\" />\n" ++
   "</filter>\n"

postamble
 = "\n</svg>\n"

--
-- Examples
--

whiteSquare = Img $ Image (Name "images/white.jpg")        (50,50)
blackSquare = Img $ Image (Name "images/black.jpg")        (50,50)
king        = Img $ Image (Name "images/king.png")         (50,50)
queen       = Img $ Image (Name "images/queen.png")        (50,50)
bishop      = Img $ Image (Name "images/bishop.png")       (50,50)
knight      = Img $ Image (Name "images/knight.png")       (50,50)
rook        = Img $ Image (Name "images/rook.png")         (50,50)
pawn        = Img $ Image (Name "images/pawn.png")         (50,50)
clear       = Img $ Image (Name "images/clear.png")        (50,50)

horse = Img $ Image (Name "images/blk_horse_head.jpg") (150, 200)

repeatH n img | n > 0     = foldl1 beside (replicate n img)
              | otherwise = error "The first argument to repeatH should be greater than 1"
                            
repeatV n img | n > 0     = foldl1 above (replicate n img)
              | otherwise = error "The first argument to repeatV should be greater than 1"                            
