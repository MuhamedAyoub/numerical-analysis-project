library(plumber)
file_path_ch2  = file.path(dir_path, "server/src/chapter2/algorithms.r")
file_path_ch7  = file.path(dir_path, "server/src/chapter7/index.r")

source(file_path_ch2)
source(file_path_ch7)

#* @get /
#* @param mat 
function(mat) {
    # mat is matrix
    # return the dim of the matrix
    print("Getting data")
    print(mat)
    list(status="success", dim=dim(mat) , msg="Hello" )
}


#* @get /ch2
#* @param method_name
#* @param A
#* @param b 
function(method_name , A , b) {
    if (method_name == "GaussTotal") {
        list(status="success", x=gaussianEliminationTotalPivoting(A, b))
    } else if (method_name == "LU") {
        x= luDecompositionSolve(A,b)
        list(status="success", x=x)
    } else if (method_name == "cholesky") {
        x =  choleskyDecompositionSolve(A,b)
        list(status="success", x=x)
    } else {
        list(status="error", msg="Method not found")
    }
}



#* @get /ch7
function( ) {
    list(getPalindMatrix())
}


#* @get /ch4
#* @param mat
#* @param method_name
function(mat, method_name) {
   getCompressedImage(mat, method_name)
}