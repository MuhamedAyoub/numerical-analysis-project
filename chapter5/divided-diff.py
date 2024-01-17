from time import time
from classes import ConsoleFormatter, Polynomial

def calc_coeff(points):
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
    return coefficients


def devided_diff(points):
    time_start = time()
    coefficients = calc_coeff(points)
    print(ConsoleFormatter.header("Coefficients:"))
    for i in range(len(coefficients)):
        print(f"""{ConsoleFormatter.bold(f'f[{", ".join([f"x{j}" for j in range(i + 1)])}]')} = {coefficients[i]}""")
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
    return p
