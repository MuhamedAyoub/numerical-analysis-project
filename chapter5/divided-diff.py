from time import time
from helpers import ConsoleFormatter, Polynomial

def calc_coeff(points):
    points = sorted(points, key=lambda point: point[0])

    table = list(map(list, points))
    coefficients = [points[0][1]]
    for col in range(2, len(points) + 1):
        for row in range(0, len(points)):
            if row < col - 1:
                table[row].append('')
                continue
            value = (table[row][col - 1] - table[row - 1][col - 1]) / (table[row][0] - table[row - col + 1][0])
            if row == col - 1:
                coefficients.append(value)
            table[row].append(value)
    print(ConsoleFormatter.header("Newton Algorithm:"))
    ConsoleFormatter.table(table)
    print(ConsoleFormatter.header("Coefficients:"))
    for i in range(len(coefficients)):
        print(f"""{ConsoleFormatter.bold(f'f[{", ".join([f"x{j}" for j in range(i + 1)])}]')} = {coefficients[i]}""")
    return coefficients


def devided_diff(points):
    print(ConsoleFormatter.section("Devided Differences Method:"))

    time_start = time()
    coefficients = calc_coeff(points)
    p = Polynomial.sum(*[
        coefficients[i] * Polynomial.mul(*[1, *[
            Polynomial(-points[j][0], 1) for j in range(i)
        ]])
        for i in range(len(points))
    ])
    time_end = time()

    print(ConsoleFormatter.header("Result:"))
    print(f"{ConsoleFormatter.green(ConsoleFormatter.bold('P(X)'))} = {p}")
    print(ConsoleFormatter.header("Executed in:"))
    print(f"{time_end - time_start}s")
    return [p, time_end - time_start]

devided_diff([(0, 1), (1, 2), (2, 4)])
