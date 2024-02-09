import json
import os
import matplotlib.pyplot as plt
import numpy as np

mode = input("manual input [m] or from json [j]: ")

vector = []
base = []

if mode == "m":
    print("Note: dimension <= 3")
    print("enter vector to process (separate coordinates by ';'): ")
    vector = list(map(float, input("> ").split(";")))
    base = []
    for i in range(len(vector)):
        print(f"enter base matrix line {i} (separate coordinates by ';'): ") 
        v = list(map(float, input("> ").split(";")))
        if (len(v) != len(vector)):
            raise ValueError(f"base matrix should be {len(vector)}x{len(vector)}")
        base.append(v)
elif mode == "j":
    d = ""
    with open("./input.json", "r") as fp:
        d = json.load(fp)
    vector = d["vector"]
    base = d["base"]
else:
    raise ValueError("invalid input.")


base = np.transpose(base)
cartisien = [[0 if (j == i) else 0 for j in range(len(vector))] for i in range(len(vector))]
output = os.popen(
    f"Rscript ./console.r '{';'.join(list(map(lambda row: ','.join(map(str, row)), base)))}' '{';'.join(map(str, vector))}'"
).read()
print(output)
output = output.split("\n")
output = output[len(output) - 2]
original = list(map(float, output[output.index('"'):].strip('"\n').split(";")))

print(original)

base = np.transpose(base)

fig = plt.figure()
axes_limits = [max(
    abs(vector[i]),
    abs(original[i]),
    max([abs(base[j][i]) for j in range(len(base))])) 
    for i in range(len(vector))
]

if (len(vector) == 2):
    ax = fig.add_subplot(111, projection = "2d")
    ax.quiver(0, 0, vector[0], vector[1], color = "red", label = "vector")
    ax.quiver(0, 0, original[0], original[1], color = "blue", label =  "original vector")
    for col in range(len(base)):
        v = [base[j][col] for j in range(len(vector))]
        u = [cartisien[j][col] for j in range(len(vector))]
        ax.quiver(0, 0, v[0], v[1], color = "#F06B0F", label = ("base" if col == 0 else ""))
        ax.quiver(0, 0, u[0], u[1], color = "#0F94F0", label = ("original base" if col == 0 else ""))

    ax.set_xlim(-1 * axes_limits[0], axes_limits[0])
    ax.set_ylim(-1 * axes_limits[1], axes_limits[1])
    ax.set_xlabel("X")
    ax.set_ylabel("Y")

elif (len(vector) == 3):
    ax = fig.add_subplot(111, projection = "3d")
    ax.quiver(0, 0, 0, vector[0], vector[1], vector[2], color = "red", label = "vector")
    ax.quiver(0, 0, 0, original[0], original[1], original[2], color = "blue", label  ="original vector")
    for col in range(len(base)):
        v = [base[j][col] for j in range(len(vector))]
        u = [cartisien[j][col] for j in range(len(vector))]
        ax.quiver(0, 0, 0, v[0], v[1], v[2], color = "#F06B0F", label = ("base" if col == 0 else ""))
        ax.quiver(0, 0, 0, u[0], u[1], u[2], color = "#0F94F0", label = ("original base" if col == 0 else ""))

    ax.set_xlim(-1 * axes_limits[0], axes_limits[0])
    ax.set_ylim(-1 * axes_limits[1], axes_limits[1])
    ax.set_zlim(-1 * axes_limits[2], axes_limits[2])
    ax.set_xlabel("X")
    ax.set_ylabel("Y")
    ax.set_zlabel("Z")
    pass
else:
    print(f"vector cannot be plotted the original vector is {original}")
    exit()

plt.title("Solution Plot")
plt.legend(loc = "best")
plt.savefig("plot.png")
