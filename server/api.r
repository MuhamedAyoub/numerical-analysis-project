library(plumber)
file_path_ch2  = file.path(dir_path, "server/src/chapter2/algorithms.r")
# file_path_ch7  = file.path(dir_path, "server/src/chapter7/index.r")
# file_path_ch4  = file.path(dir_path, "server/src/chapter4/algorithms.r")

source(file_path_ch2)
# source(file_path_ch7)
# source(file_path_ch4)


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
   Ch2Controller(A = coefficient, B = values, selected_method = selected_method)
}

## these routes are Replaced by python code 

# #* @get /ch7
# #* @param method_name
# function(method_name) {
#     list(getPalindMatrix(selected_method = method_name))
# }


# #* @post /ch4
# #* @param mat
# #* @param width
# #* @param height
# #* @param selected_method
# function(mat, width, height, selected_method) {
# print("Received Request ...")

# mat  = as.array(mat)
#  getCompressedImage(img_matrix = mat, method_name = selected_method)

# }

