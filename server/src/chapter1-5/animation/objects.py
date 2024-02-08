import asyncio
from math import floor
from typing import Type, Union

from graphics import Circle, Oval, Point, Rectangle

class Polynomial:
    def __init__(self, coefficients):
        self.coeffiecient = coefficients

    def eval(self, value):
        return sum([coeff * value for coeff in self.coeffiecient])


class Animatable:
    def __init__(self, shape: Circle | Oval | Rectangle) -> None:
        self.step = 0.2
        self.shape = shape
        self.original = shape

    def getX(self):
        return self.shape.getCenter().getX()

    def getY(self):
        return self.shape.getCenter().getY()

    def getX_diff(self):
        if (type(self.shape) == Circle):
            return self.shape.getRadius()
        return(abs(self.shape.getP1().getX() - self.shape.getP2().getX()))

    def getY_diff(self):
        if (type(self.shape) == Circle):
            return self.shape.getRadius()
        return(abs(self.shape.getP1().getY() - self.shape.getP2().getY()))

    def setSize(self, multiplier):
        self.shape.undraw()
        if (type(self.shape) == Circle):
            self.shape = Circle(self.shape.getCenter(), self.shape.getRadius() * multiplier)
        elif (type(self.shape == Oval)):
            xdiff = self.getX_diff() * multiplier
            ydiff = self.getY_diff() * multiplier
            self.shape = Oval(
                Point(
                    self.shape.getCenter().getX() - xdiff / 2,
                    self.shape.getCenter().getY() + ydiff / 2
                ),
                Point(
                    self.shape.getCenter().getX() + xdiff / 2,
                    self.shape.getCenter().getY() - ydiff / 2
                )
            )

    def setXY(self, x, y):
        self.shape.move(x - self.getX(), y - self.getY())

    def animate(self, animations):
        pass

    async def animate_size(self, duration, polynomial):
        polynomial = Polynomial(polynomial)
        for i in range(floor(duration / self.step)):
            self.setSize(polynomial.eval(i * self.step))
            await asyncio.sleep(self.step)

    async def animate_position(self, duration, xpoly, ypoly):
        xpoly = Polynomial(xpoly)
        ypoly = Polynomial(ypoly)
        for i in range(floor(duration / self.step)):
            self.setXY(xpoly.eval(i * self.step), ypoly.eval(i * self.step))
            await asyncio.sleep(self.step)

    def play(self, animations):
        ani = {
            "operation": "size",
            "polynomial": [1, 2, 3],
            "duration": 20
        }
        for animation in animations:
            pass
