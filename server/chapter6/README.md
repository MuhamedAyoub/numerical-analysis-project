## Setup
- install `python<version>`
- install `pip`
- install virtualenv using `pip install virtualenv`
- create a virtual env using `python<version> venv -m [folder name]`
- execute `[folder name]/bin/activate` script (use `source [folder name]/bin/activate` on Linux)
- run pip install -r requirements.txt
- run the script using `python blur.py`

follow [freecodecamp article](https://www.freecodecamp.org/news/how-to-setup-virtual-environments-in-python/) if 
you get stuck in the dependency installation process

### NOTE
make sure you execute the script, after entering into the virtual environment

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

