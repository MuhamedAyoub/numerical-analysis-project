library(plumber)
#* @get /
#* @param mat 
function(mat) {
    # mat is matrix
    # return the dim of the matrix
    print("Getting data")
    print(mat)
    list(status="success", dim=dim(mat) , msg="Hello" )
}