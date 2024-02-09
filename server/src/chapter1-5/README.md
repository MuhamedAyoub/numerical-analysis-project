## What it does
given some keyframes from some attribute, outputs the polynomial that would be used in the animation, 
if the animation regards the position the intersections of paths of objects is returned as well.

## How it work
uses interpolation to get get the polynomials to be used in the animation
uses root finding algorithms (chapter 1) to find collision points

## Dependencies
`jsonlite`

## How to use
write the input to the program in a json file following the format in `query.json`, and input it to 
`Rscript console.r [file name]`

## Note
included is a video of a program using the two methods to animate some objects and to determine collistions 
between them
to run install graphics.py and run animation/animate.py
