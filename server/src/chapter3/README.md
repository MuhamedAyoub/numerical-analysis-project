## What it does
given the vector `v` in the new base `base`, calculate the original vector in the base `e1, e2, ...`

## How it works
the original vector is calculated by solving the linear system of equations `base * orginal = v`, 
using numerical methods __jacobi__, __gauss-seidel__, __relaxation__.

## How to use
run `Rscript console.r [base] [vector]`
__base:__ a11,a12,...,a1n;...;an1,an2,...,ann
__vector:__ v1;v2;v3;...;vn

## Note
provided is a image of the calculation of the original vector using information in `input.json` 
you can write your own input in `input.json` (max dimension is 3).
after installin dependencies using `pip install -r requirement.py.txt` run the script `plot.py`
