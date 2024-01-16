from classes import Polynomial

def lagrange(points):
    return Polynomial.sum(*[
        points[points_counter][1] * Polynomial.mul(*[
            Polynomial(
                -1 * points[lagrange_counter][0] / (points[points_counter][0] - points[lagrange_counter][0]), 
                1 / (points[points_counter][0] - points[lagrange_counter][0])
            ) for lagrange_counter in range(len(points)) if lagrange_counter != points_counter
        ]) for points_counter in range(len(points))
    ])

print(lagrange([(0, 1), (1, 2), (2, 4)]))

