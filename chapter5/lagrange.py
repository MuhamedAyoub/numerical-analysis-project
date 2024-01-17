from classes import ConsoleFormatter, Polynomial
import time

def lagrange(points):
    time_start = time.time()
    lagrange_polynomials = [
        points[points_counter][1] * Polynomial.mul(*[
            Polynomial(
                -1 * points[lagrange_counter][0] / (points[points_counter][0] - points[lagrange_counter][0]), 
                1 / (points[points_counter][0] - points[lagrange_counter][0])
            ) for lagrange_counter in range(len(points)) if lagrange_counter != points_counter
        ]) for points_counter in range(len(points))
    ]
    print(ConsoleFormatter.header("Lagrange Polynomials:"))
    for i in range(len(lagrange_polynomials)):
        print(f"l{i}(X) = {lagrange_polynomials[i]}")
    p = Polynomial.sum(*lagrange_polynomials)
    time_end = time.time()
    print(ConsoleFormatter.header("Result:"))
    print(f"{ConsoleFormatter.green(ConsoleFormatter.bold('P(X)'))} = {p}")
    print(ConsoleFormatter.header("Executed in:"))
    print(f"{time_end - time_start}s")
    return p
