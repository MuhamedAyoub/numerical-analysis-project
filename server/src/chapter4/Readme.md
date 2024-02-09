# Image Compression Project Documentation

## Overview:
This project demonstrates the compression of images using three different methods: Power Iteration, Deflation Method, and Givens Rotation. The goal is to reduce the size of an image while retaining its essential features by finding the dominant eigenvalue and eigenvector of the covariance matrix of its pixels.

## Requirements:
- Python 3.x
- NumPy
- scikit-image (skimage)
- matplotlib
- PIL (Python Imaging Library)

## Installation:
1. Clone or download the project from the GitHub repository.
2. Install the required dependencies using pip:

`pip install numpy scikit-image matplotlib pillow`

## Usage
1. Enter the path to the image file you want to compress when prompted.
2. The script will apply each compression method and display the compressed images along with their Mean Squared Error (MSE) and Peak Signal-to-Noise Ratio (PSNR) compared to the original image.

## File Descriptions:
- `main.ipynb`: Main script for image compression.
## Algorithms:
- **Power Iteration**: Finds the dominant eigenvalue and eigenvector of a matrix.
- **Deflation Method**: Finds multiple eigenvalues and eigenvectors by repeatedly applying power iteration and deflating the matrix.
- **Givens Rotation**: Finds the dominant eigenvalue and eigenvector using Givens rotation.

## Outputs:
- Compressed images are displayed along with their MSE and PSNR compared to the original image.

## Limitations:
- The project currently supports only grayscale images.
- The compression quality may vary depending on the characteristics of the input image.

## Future Improvements:
- Add support for color images.
- Implement additional compression algorithms for comparison.

## Author:
__Ameri Mohamed Ayoub__
