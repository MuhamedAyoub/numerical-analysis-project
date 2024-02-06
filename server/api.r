library(plumber)
file_path_ch2  = file.path(dir_path, "server/src/chapter2/algorithms.r")
file_path_ch7  = file.path(dir_path, "server/src/chapter7/index.r")
file_path_ch4  = file.path(dir_path, "server/src/chapter4/algorithms.r")

source(file_path_ch2)
source(file_path_ch7)
source(file_path_ch4)


#' @filter cors
cors <- function(req, res) {
  
  res$setHeader("Access-Control-Allow-Origin", "*")
  
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200 
    return(list())
  } else {
    plumber::forward()
  }
  
}
#* @post /ch2
#* @param selected_method
#* @param coefficient
#* @param values
function(selected_method , coefficient , values) {

    coefficient = as.matrix(coefficient)
    print(coefficient)
    if (selected_method == "Gauss") {
        gaussianEliminationPartialPivoting(A=coefficient, b=values)
    } else if (selected_method == "LU") {
         luDecompositionSolve(A=coefficient,B=values)
    } else if (selected_method == "Cholesky") {
        choleskyDecompositionSolve(A=coefficient,B=values)
    } else {
        list(status="error", msg="Method not found")
    }
}



#* @get /ch7
#* @param method_name
function(method_name) {
    list(getPalindMatrix(selected_method = method_name))
}


#* @get /ch4
#* @param mat
#* @param method_name
function(mat, method_name) {
   getCompressedImage(mat, method_name)
}

