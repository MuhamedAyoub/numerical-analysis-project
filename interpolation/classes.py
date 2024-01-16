from typing import Union, Self

class Polynomial:
    """
    A type for working with polynomials
    Note: coefficients are assigned in ascending order (0 -> n)
    """
    def __init__(self, *args):
        self._coefficients = list(args)

    def __eq__(self, other):
        return self._coefficients == other._coefficients 

    def __ne__(self, other):
        return self._coefficients != other._coeffiecients

    def __repr__(self):
        if len(self._coefficients) == 0:
            return "0"
        for i in self._coefficients:
            if i != 0:
                return " + ".join([
                    (
                        f"{self._coefficients[i] if self._coefficients[i] != 1 or i == 0 else ''}{f'X^{i}' if i != 0 else ''}"
                    ) 
                    for i in range(len(self._coefficients)) 
                    if self._coefficients[i] != 0
                ])
        return "0"


    def __len__(self):
        return len(self._coefficients)

    def __add__(self, other):
        if isinstance(other, int) or isinstance(other, float):
            return Polynomial(*[
                self._coefficients[0] + other if i == 0 else self._coefficients[i]
                for i in range(len(self._coefficients))
            ])

        if type(other) != self.__class__:
            raise TypeError("Invalid Type: expected polynomial")

        return Polynomial(*[
            (self._coefficients[i] if i < len(self._coefficients) else 0) +
            (other._coefficients[i] if i < len(other._coefficients) else 0)
            for i in range(max(len(self._coefficients), len(other._coefficients)))
        ])

    def __radd__(self, other):
        return self.__add__(other)

    def sum(*polynomials):
        result = Polynomial()
        for polynomial in polynomials:
            result += polynomial
        return result

    def __mul__(self, other):
        if isinstance(other, int) or isinstance(other, float):
            return Polynomial(*[
                i * other for i in self._coefficients
            ])

        if type(other) != self.__class__:
            raise TypeError("Invalid Type: expected polynomial")

        return Polynomial.sum(*[
            Polynomial(*[
                (self._coefficients[i] * other._coefficients[j - i] if j >= i else 0)
                for j in range(i + len(other._coefficients))
            ])
            for i in range(len(self._coefficients))
        ])
    def __rmul__(self, other):
        return self.__mul__(other)

    def mul(*polynomials: Union[Self, int, float]):
        result = Polynomial(1)
        for polynomial in polynomials:
            result *= polynomial
        return result

    def eval(self, x):
        return sum([self._coefficients[i] * (x ** i) for i in range(len(self._coefficients))])


class ConsoleFormatter:
    BOLD = "\033[1m"
    GREEN = "\033[32m"
    UNDERLINE = "\033[4m"
    END = "\033[0m"

    @staticmethod
    def bold(text):
        return f"{ConsoleFormatter.BOLD}{text}{ConsoleFormatter.END}"

    @staticmethod
    def underline(text):
        return f"{ConsoleFormatter.UNDERLINE}{text}{ConsoleFormatter.END}"

    @staticmethod
    def push(text):
        return f"                   {text}"

    @staticmethod
    def header(text):
        return f"""
{ConsoleFormatter.push(ConsoleFormatter.bold(ConsoleFormatter.underline(f'{text}')))}
"""
    @staticmethod
    def green(text):
        return f"{ConsoleFormatter.GREEN}{text}{ConsoleFormatter.END}"
