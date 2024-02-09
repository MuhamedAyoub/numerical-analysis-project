import { TMatrix } from '@/types/zod';
//@ts-ignore
import type { RDouble } from 'webr';
//@ts-ignore
import { WebR } from 'webr';
const LU = (A: number[][], B: number[]) => {
	return `luDecompositionSolve <- function(A, B) {
        n <- nrow(A)
        m <- ncol(A)
        if (nrow(A) != ncol(A)) { 
            return (list(status="error", msg="Matrix A must be square"))
            
        } 
        lower <- matrix(0, n, n)
        upper <- matrix(0, n, n)
        
        for (i in 1:n) {
            for (k in i:m) {
                upper[i, k] <- A[i, k] - sum(lower[i, 1:(i - 1)] * upper[1:(i - 1), k])
            }
            
            for (k in i:n) {
                if (i == k) {
                    lower[i, i] <- 1 # Diagonal as 1
            } else {
                lower[k, i] <- (A[k, i] - sum(lower[k, 1:(i - 1)] * upper[1:(i - 1), i])) / upper[i, i]
            }
        }
    }
    y <- numeric(n)
    for (i in 1:n) {
        y[i] <- (B[i] - sum(lower[i, 1:(i - 1)] * y[1:(i - 1)])) / lower[i, i]
    }
    
    x <- numeric(n)
    for (i in n:1) {
        if (i < n) {
            x[i] <- (y[i] - sum(upper[i, (i + 1):n] * x[(i + 1):n])) / upper[i, i]
        } else {
            x[i] <- y[i] / upper[i, i]
        }
    }
    
    return(list(status="success", x=x))
    
}
result <- luDecompositionSolve(A=as.matrix(${A}), B=${B});
`;
};

const GAUSSIAN = `gaussianEliminationPartialPivoting <- function(A, B) {
    n <- nrow(A)

    # Augmenting matrix [A|b]
    augmentedMatrix <- cbind(A, B)

    # Applying Gaussian elimination with partial pivoting
    for (i in 1:(n - 1)) {
        # Partial Pivoting
        pivotRow <- which.max(abs(augmentedMatrix[i:n, i])) + (i - 1)
        if (pivotRow != i) {
            augmentedMatrix[c(i, pivotRow), ] <- augmentedMatrix[c(pivotRow, i), ]
        }
        for (j in (i + 1):n) {
            factor <- augmentedMatrix[j, i] / augmentedMatrix[i, i]
            augmentedMatrix[j, ] <- augmentedMatrix[j, ] - factor * augmentedMatrix[i, ]
        }
    }
    x <- numeric(n)
    for (i in n:1) {
        x[i] <- (augmentedMatrix[i, n + 1] - sum(augmentedMatrix[i, (i + 1):n] * x[(i + 1):n])) / augmentedMatrix[i, i]
    }

    return(x)
}

`;
const CHOLESKY = `choleskyDecompositionSolve <- function(A, B) {
  n <- nrow(A)
  
  # Cholesky decomposition
  L <- matrix(0, n, n)
  
  for (i in 1:n) {
    for (j in 1:i) {
      if (i == j) {
        L[i, i] <- sqrt(A[i, i] - sum(L[i, 1:(i-1)]^2))
      } else {
        L[i, j] <- (A[i, j] - sum(L[i, 1:(i-1)] * L[j, 1:(j-1)])) / L[j, j]
      }
    }
  }
  
  # Solving the system using Cholesky decomposition
  # Ly = B (forward substitution)
  y <- numeric(n)
  for (i in 1:n) {
    y[i] <- (B[i] - sum(L[i, 1:(i-1)] * y[1:(i-1)])) / L[i, i]
  }
  
  # Lt x = y (back substitution)
  x <- numeric(n)
  for (i in n:1) {
    x[i] <- (y[i] - sum(L[i+1:n, i] * x[i+1:n])) / L[i, i]
  }
  
  return(x)
}
`;

export const systemSolver = async (data: TMatrix) => {
	const webR = new WebR({});
	await webR.init();
	const { selected_method, coefficient, values } = data;
	const A = coefficient;
	const B = values;

	let result: RDouble[] = [];
	switch (selected_method) {
		case 'LU':
			const result = (await webR.evalR(LU(A, B))) as RDouble;
			try {
				result.toArray();
			} catch (e) {
				console.error(e);
			} finally {
				webR.destroy();
				return result;
			}
		case 'Gauss':
			return await webR.run(GAUSSIAN, A, B);
			break;
		case 'Cholesky':
			return await webR.run(CHOLESKY, A, B);
			break;
	}
	return result;
};
