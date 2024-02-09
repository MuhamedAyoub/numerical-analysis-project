import asyncio
from graphics import Rectangle, Point, Circle, Oval, GraphWin
import objects

# coordinates start at top left
window = GraphWin("Animation", 700, 700, autoflush=True)
window.setBackground("black")

r = objects.Animatable(Rectangle(Point(-30, -30), Point(30, 30)), window, "blue").draw()
c = objects.Animatable(Circle(Point(50, 600), 60), window, "red").draw()
o = objects.Animatable(Oval(Point(640, 575), Point(660, 625)), window, "red").draw()
csize = objects.Animatable(Circle(Point(350, 500), 50), window, "purple").draw()

asyncio.run(
    objects.Animator([
        r.animate([
            {
                "operation": "position",
                "points": [
                    [0, 0],
                    [337, 160],
                    [350, 350],
                    [363, 160],
                    [700, 0]
                ],
                "duration": 10
            },
        ]),
        c.animate([
            {
                "operation": "position",
                "points": [
                    [50, 600],
                    [337, 170],
                    [350, 50]
                ],
                "duration": 10
            }
        ]),
        o.animate([
            {
                "operation": "position",
                "points": [
                    [650, 600],
                    [363, 170],
                    [350, 50]
                ],
                "duration": 10
            }
        ]),
        csize.animate([
            {
                "operation": "size",
                "points": [1, 2, 1.2, 3, 0.8],
                "duration": 7.5
            },
            {
                "operation": "size",
                "points": [1.5, 2.5, 3, 0.1],
                "duration": 2
            }
        ])
    ], window).play()
)

window.getMouse()
window.close()
