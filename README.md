## About
A project for Analyse Numérique, contains sample use cases of algorithms studied in the course 

- __Chapter 1__: root finding algorithms (newton-raphson, dichotomie, point milieu)
    __Used For__: Detection of collisions between objects
- __Chapter 2__: Solving Linear Systems of Equations (lu, gauss, cholesky)
- __Chapter 3__: Solving Lineas Systems Of Equations (Numeric) (jacobi, gauss-seidel, relaxation)
    __Used For__: Finding the origin of a given vector can be applied in reversing the orientation of an image
- __Chapter 4__: Finding Eigen Values(puissance itérée, déflation, jacobi et rotation de givens)
    __Used For__: Image compression
- __Chapter 5__: interpolation (lagrange, différences divisés, différences finis)
    __Used For__: Creating smooth animations from keyframes
- __Chapter 6__: numerical integration (trapézes, simpson, trapézes composites, simpson composites)
    __Used For__: Image blurring

## Note
- Chapter 1 and 5 are put into one project as they are both utilized
- the source code of the algorithms is located under `server/src`

## Dependencies
### R
install `plumber`, `magick`
### Python
run `pip install -r requirements.py.txt` located on each folder
make sure to install `numpy` and `matplotlib` using `pip install numpy matplotlib`
### Website
run `npm install` on the root folder

## How to execute
### Starting web site
run `npm run dev` and visit the website at the specified address
Chapter 2 is on the Web site

### Python Scripts
for Chapter 1-5 run in the `animation` folder `python animaton.py`
for Chapter 3 run `plot.py` after setting the input in input.json if you prefer, else input the data after running the script

### R scripts
for Chapter 6 run `Rscript console.r [image path] [sigma (default = 1)]`

## Samples
sample are provided with each chapter's code for ease of viewing
