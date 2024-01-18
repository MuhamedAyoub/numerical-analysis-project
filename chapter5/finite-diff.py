from helpers import ConsoleFormatter, Polynomial, sort_points
from math import factorial
from time import time

def calc_coefficients(points):
    points = sort_points(points)
    if not equidistant(points):
        raise ValueError("points are not equidistant")

    table = list(map(list, points))
    coefficients = [points[0][1]]
    for col in range(2, len(points) + 1):
        for row in range(0, len(points)):
            if row < col - 1:
                table[row].append('')
                continue
            value = (table[row][col - 1] - table[row - 1][col - 1])
            if row == col - 1:
                coefficients.append(value)
            table[row].append(value)
    print(ConsoleFormatter.header("FDF Algorithm:"))
    ConsoleFormatter.table(table)
    print(ConsoleFormatter.header("Coefficients:"))
    for i in range(len(coefficients)):
        print(f"{ConsoleFormatter.bold(f'∇{i}f₀')} = {coefficients[i]}")
    return coefficients

def equidistant(points):
    interval_length = abs(points[0][0] - points[1][0])
    for i in range(1, len(points)):
        if abs(points[i][0] - points[i - 1][0]) != interval_length:
            return False
    return True

def finite_diff(points):
    print(ConsoleFormatter.section("Finite Difference Method:"))

    tmp = sort_points(points)
    step = (tmp[len(tmp) - 1][0] - tmp[0][0]) / (len(points) - 1)

    time_start = time()
    coefficients = calc_coefficients(points)
    p = Polynomial.sum(*[
        (coefficients[i] / (factorial(i) * (step ** i))) * Polynomial.mul(*[1, *[
            Polynomial(-points[j][0], 1)
            for j in range(i)
        ]])
        for i in range(len(points))
    ])
    time_end = time()

    print(ConsoleFormatter.header("Result:"))
    print(f"{ConsoleFormatter.green(ConsoleFormatter.bold('P(X)'))} = {p}")
    print(ConsoleFormatter.header("Executed in:"))
    print(f"{time_end - time_start}s")
    return [p, time_end - time_start]


finite_diff([(0, 1), (1, 2), (2, 4)])
