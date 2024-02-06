## Libraries
`magick` used for reading, blurring, and saving images

## Note
the code to blur the image is provided in `blur-snippet.py`

## Blurring Process
first the image is loaded as a matrix where each item represents a pixel, afterwards the kernel is applied 
on each pixel.

## Explanation
The given program blurs an image using gaussian blur technique.
For every pixel of the original image a new pixel is generated using the surrounding pixel values in a 
`5*5` matrix. The contribution of each pixel into the output is determined using a weight. Weights are 
stored in a `5*5` matrix called the __kernel__, and are determined using the integral of the 
normal density function (normal distribution). Since the former function doesn't have a definite primitive 
numerical method are used to compute the integral in intervals of length __(b - a) / 25__ where b = 2 
and a = -2 ([-2, -1.84], [-1.84, -1.68], ...). For composite methods 3 sub intervals are used per integral. 
After computation the obtained values (`Xi`) are normalized by dividing them by their sum 
__Xi / sum(Xi)__ the output is then stored in the __kernel__. The new pixel value is obtained by summing 
the product of surrounding pixels by their respective weights (pixel[1, 1] * kernel[1, 1]).

