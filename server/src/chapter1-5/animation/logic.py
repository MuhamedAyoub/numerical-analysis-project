import asyncio
from math import floor
import os
import json
from typing import LiteralString
from graphics import Circle, GraphWin, Oval, Point, Rectangle, Text, color_rgb

class Polynomial:
    def __init__(self, coefficients):
        self.coeffiecients = coefficients

    def eval(self, value):
        return sum([self.coeffiecients[i] * (value ** i) for i in range(len(self.coeffiecients))])

class Message:
    def __init__(self, text, window: GraphWin):
        self.text = Text(Point(window.getWidth() / 2, window.getHeight() / 2), text)
        self.text.setFace("helvetica")
        self.text.setSize(15)
        self.text.setStyle("bold")
        self.text.draw(window)
        self.text.setTextColor(color_rgb(216, 39, 57))
        pass

    def destroy(self):
        self.text.undraw()

class Animator:
    def __init__(self, playables, window):
        self.collision_color = color_rgb(128, 15, 240)
        self.collision_radius = 5
        self.window = window
        self.playables = playables
        self.update_collisions()

    def update_collisions(self):
        animations = []
        for playable in self.playables:
            animation = playable.get_first_position_animation()
            if (animation != None):
                animations.append({
                    "x" :{
                        "coefficients": animation["polynomial"]["x"], 
                        "start": 0,
                        "end": animation["duration"]
                    },
                    "y" :{
                        "coefficients": animation["polynomial"]["y"], 
                        "start": 0,
                        "end": animation["duration"]
                    },
                })
        self.collisions = []
        if (len(animations) > 0):

            message = Message("processing collisions...", self.window)
            out = os.popen(f"Rscript ../api/root.r --json '{json.dumps(animations)}'").read()
            collisions = json.loads(out)
            print(out)
            message.destroy()

            for collision in collisions:
                circle = Circle(Point(collision[0][0], collision[1][0]), self.collision_radius)
                circle.setFill(self.collision_color)
                self.collisions.append(circle)

    async def play(self):
        for collision in self.collisions:
            collision.draw(self.window)
        animations = []
        for playable in self.playables:
            animations.append(playable.play())
        await asyncio.gather(*animations)
        
class Playable:
    def __init__(self, animatable):
        self.animatable = animatable
        self.queues = {}

        message = Message(f"processing {f'{self.animatable.type} at {self.animatable.getXY()}'}...", self.animatable.window)
        out = os.popen(f"Rscript ../api/console.r --json '[{json.dumps(animatable.animations)}]'").read()
        output = json.loads(out)
        print(out)
        message.destroy()

        for attribute in output["objectPolynomials"][0]:
            animation = {
                "operation": attribute["operation"][0],
                "polynomial": attribute[f"polynomial{'s' if ('polynomials' in attribute.keys()) else ''}"],
                "duration": attribute["duration"][0]
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
    def __init__(self, shape: Circle | Oval | Rectangle, window: GraphWin, color: str | LiteralString | None = None) -> None:
        self.type = ""
        if (type(shape) == Circle):
            self.type = "Circle"
        elif (type(shape) == Rectangle):
            self.type = "Rectangle"
        elif (type(shape) == Oval):
            self.type = "Oval"
        self.step = 0.025
        self.shape = shape
        self.color = color
        if (color != None):
            self.shape.setFill(color)
        self.original = shape.clone()
        self.window = window
    def apply_styles(self, shape: Circle | Oval | Rectangle):
        if self.color != None:
            shape.setFill(self.color)

    def draw(self):
        self.shape.draw(self.window)
        return self

    def getX(self):
        return self.shape.getCenter().getX()

    def getY(self):
        return self.shape.getCenter().getY()

    def getXY(self):
        return f"({self.getX()}, {self.getY()})"

    def getX_diff(self):
        if (type(self.shape) == Circle):
            return self.shape.getRadius()
        return(abs(self.shape.getP1().getX() - self.shape.getP2().getX()))

    def getY_diff(self):
        if (type(self.shape) == Circle):
            return self.shape.getRadius()
        return(abs(self.shape.getP1().getY() - self.shape.getP2().getY()))

    def setSize(self, multiplier):
        new = Circle(Point(0, 0), 0)
        if (type(self.shape) == Circle):
            new = Circle(self.shape.getCenter(), self.original.getRadius() * multiplier)
            self.apply_styles(new)
            self.shape.undraw()
            self.shape = new
            self.shape.draw(self.window)
            return

        original = Animatable(self.original, self.window)
        xdiff = original.getX_diff() * multiplier
        ydiff = original.getY_diff() * multiplier
        top_right = Point(
            original.getX() - xdiff / 2,
            original.getY() + ydiff / 2
        )
        bottom_left = Point(
            original.getX() + xdiff / 2,
            original.getY() - ydiff / 2
        )

        if (type(self.shape) == Oval):
            new = Oval(top_right, bottom_left)
        elif (type(self.shape == Rectangle)):
            new = Rectangle(top_right, bottom_left)

        self.apply_styles(new)
        self.shape.undraw()
        self.shape = new
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
                if (len(attribute["points"][0]) == 2):
                    attribute["points"] = [
                        [(i + 1) / len(attribute["points"]), *attribute["points"][i]] 
                        for i in range(len(attribute["points"]))
                    ]
                    attribute["points"].insert(0, [0, self.getX(), self.getY()])
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

