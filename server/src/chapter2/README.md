# Algorithms for Solving Systems of Equations with 10 Variables

## Overview

This document describes R functions that implement several algorithms for solving systems of linear equations with 10 variables. The included algorithms are:

Gaussian Elimination with Total Pivoting
Gaussian Elimination with Partial Pivoting
LU Decomposition
Cholesky Decomposition
## Functions

### Gaussian Elimination Functions

gaussianEliminationTotalPivoting(a_matrix, b_matrix)
gaussianEliminationPartialPivoting(a_matrix, b_matrix)
### Decomposition Functions

luDecompositionSolve(A, B)
choleskyDecompositionSolve(A, B)
## Controller Function

### Ch2Controller(A, B, selected_method)

## Usage

See the provided test cases for examples of how to use the functions.

## Additional Information

Each function includes input validation to ensure correct matrix dimensions and properties.
The controller function allows for choosing the desired solution method.


## Examples
`use the Given Matrices for each function ` 


## Author 
__ Ameri Mohamed Ayoub __