import numpy as np
import matplotlib.pyplot as plt
import os
from multiprocessing import Pool

path = input("image path(.jpg)[Enter to use sample.jpg]: ")
while path != "" and not os.path.exists(path):
    print("invalid path")
    path = input("image path(.jpg)[Enter to use sample.jpg]: ")

path = path or "sample.jpg"

sigma = -1
while sigma > 2 or sigma < 0:
    sigma = float(input("σ [0, 2](higher sigma mean higher distortion): "))

img = plt.imread(f"{path}")
kernels = dict()
channels = len(img[0, 0])

def kernel(mode):
    output = os.popen(f"Rscript kernel.r {mode} {sigma}").read()
    kernels[mode] = np.array(
        list(
            map(
                lambda weight: [weight if i < 3 else 1 for i in range(channels)],
                list(map(lambda x: float(x) - 0.0000001, output[output.index('"'):-1].strip('"').split(";")))
            )
        )
    ).reshape(5, 5, channels)

modes = ["trapezoids", "simpson", "simple_trapezoids", "simple_simpson"]

for mode in modes:
    kernel(mode)

def blur(mode):
    kernel = kernels[mode]
    print(f"processing: {mode}")
    img_new = np.empty(img.shape, dtype=np.uint8)
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
                axis = (0, 1),
            )
            if (len(img_new[pixrow, pixcol]) > 3):
                img_new[pixrow, pixcol, 3] = min(
                    int(img_new[pixrow, pixcol, 3] / (np.sum(pixels, axis = (0, 1))[3] or 1)),
                    255
                )

    plt.imsave(f"./output-{mode}.jpg", img_new)

result = Pool(processes = len(modes)).map(blur, modes)
