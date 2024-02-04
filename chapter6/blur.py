import numpy as np
import matplotlib.pyplot as plt
import os
from multiprocessing import Pool

img = plt.imread("./sample.png")
kernels = dict()
channels = len(img[0, 0])

def kernel(mode):
    output = os.popen(f"Rscript kernel.r {mode} 1").read()
    kernels[mode] = np.array(
        list(
            map(
                lambda weight: [weight if i < 3 else 1 for i in range(4)],
                list(map(lambda x: float(x) - 0.0000001, output[output.index('"'):-1].strip('"').split(";")))
            )
        )
    ).reshape(5, 5, 4)

modes = ["trapezoids", "simpson", "simple_trapezoids", "simple_simpson"]

for mode in modes:
    kernel(mode)

def blur(mode):
    kernel = kernels[mode]
    print(f"processing: {mode}")
    img_new = np.empty(img.shape)
    for pixrow in range(0, img.shape[0]):
        for pixcol in range(0, img.shape[1]):
            left_add = max(-2, 0 - pixcol)
            right_add = min(3, img.shape[1] - pixcol)
            top_add = max(-2, 0 - pixrow)
            bottom_add = min(3, img.shape[0] - pixrow)
            pixels = img[(pixrow + top_add):(pixrow + bottom_add), (pixcol + left_add):(pixcol + right_add)]
            img_new[pixrow, pixcol] = np.sum(
                np.multiply(
                    kernel[(2 + top_add):(2 + bottom_add), (2 + left_add):(2 + right_add),],
                    pixels,
                ),
                axis = (0, 1)
            )
            if (len(img_new[pixrow, pixcol]) > 3):
                img_new[pixrow, pixcol, 3] = min(
                    img_new[pixrow, pixcol, 3] / (np.sum(pixels, axis = (0, 1))[3] or 1),
                    0.999999
                )

    plt.imsave(f"./output-{mode}.png", img_new)

result = Pool(processes = len(modes)).map(blur, modes)
