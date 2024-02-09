import asyncio
from math import floor
import os
import json
from graphics import Circle, GraphWin, Oval, Point, Rectangle

class Polynomial:
    def __init__(self, coefficients):
        self.coeffiecient = coefficients

    def eval(self, value):
        return sum([coeff * value for coeff in self.coeffiecient])

class Animator:
    def __init__(self, playables, window):
        self.playables = playables
        self.update_intersections()
        self.intersection_radius = 5
        self.window = window

    def update_intersections(self):
        animations = []
        for playable in self.playables:
            animation = playable.get_next_position_animation()
            if (animation != None):
                animations.append(animation)
        self.intersections = []
        if (len(animations) > 0):
            intersections = json.loads(os.popen(f"Rscript --json '{json.dumps(animations)}'").read())
            for intersection in intersections:
                self.intersections.append(Circle(Point(intersection[0][0], intersection[1][0]), self.intersection_radius))

    def play(self):
        for intersection in self.intersections:
            intersection.draw(self.window)
        for playable in self.playables:
            playable.play()
            z
        
class Playable:
    def __init__(self, animatable):
        self.animatable = animatable
        self.queues = {}
        output = json.loads(os.popen(f"Rscript ../api/console.r --json '{json.dumps(animatable.animations)}'").read())
        print(output)
        for attribute in output[0]:
            animation = {
                "operation": attribute["operation"],
                "polynomial": attribute[f"polynomial{'polynomials' in attribute.keys()}"],
                "duration": attribute["duration"]
            }
            if animation["operation"] not in self.queues.keys():
                self.queues[animation["operation"]] = []
            self.queues[animation["operation"]].append(animation)

    def get_first_position_animation(self):
        if "position" in self.queues.keys():
            return self.queues["position"][0]
        return None

    async def play_queue(self, queue):
        while True:
            if (len(queue) == 0):
                return
            animation = queue.pop(0)
            if animation["operation"] == "size":
                await self.animatable.animate_size(animation["duration"], animation["polynomial"])
            elif animation["operation"] == "position":
                await self.animatable.animate_position(
                    animation["duration"],
                    animation["polynomial"]["x"],
                    animation["polynomial"]["y"]
                )
            
    async def play(self):
        tasks = []
        for operation in self.queues.keys():
            tasks.append(asyncio.create_task(self.play_queue(self.queues[operation])))
        await asyncio.gather(*tasks)

class Animatable:
    def __init__(self, shape: Circle | Oval | Rectangle, window: GraphWin) -> None:
        self.step = 0.2
        self.shape = shape
        self.original = shape
        self.window = window

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
            self.shape.draw(self.window)
            return
        xdiff = self.getX_diff() * multiplier
        ydiff = self.getY_diff() * multiplier
        top_right = Point(
            self.shape.getCenter().getX() - xdiff / 2,
            self.shape.getCenter().getY() + ydiff / 2
        )
        bottom_left = Point(
            self.shape.getCenter().getX() + xdiff / 2,
            self.shape.getCenter().getY() - ydiff / 2
        )

        if (type(self.shape) == Oval):
            self.shape = Oval(top_right, bottom_left)
        elif (type(self.shape == Rectangle)):
            self.shape = Rectangle(top_right, bottom_left)

        self.shape.draw(self.window)

    def setXY(self, x, y):
        self.shape.move(x - self.getX(), y - self.getY())

    def animate(self, animations):
        for attribute in animations:
            if (attribute["operation"] == "size"):
                if (type(attribute["points"][0] != list)):
                    attribute["points"] = [
                        [(i + 1) / len(attribute["points"]), attribute["points"][i]] 
                        for i in range(len(attribute["points"]))
                    ]
                    attribute["points"].insert(0, [0, 1])
                if (attribute["points"][len(attribute["points"]) - 1][0] != 1):
                    raise ValueError("last keyframe should be at 100%")
            elif (attribute["operation"] == "position"):
                if (len(attribute["points"]) == 2):
                    attribute["points"] = [
                        [(i + 1) / len(attribute["points"]), *attribute["points"][i]] 
                        for i in range(len(attribute["points"]))
                    ]
                    attribute["points"].unshift([0, self.getX(), self.getY()])
                if (attribute["points"][len(attribute["points"]) - 1][0] != 1):
                    raise ValueError("last keyframe should be at 100%")
        self.animations = animations
        return Playable(self)

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

