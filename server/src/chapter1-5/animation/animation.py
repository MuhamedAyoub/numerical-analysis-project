import asyncio
from graphics import Rectangle, Point, Circle, Oval, GraphWin
import objects

# print(json.loads(os.popen(f"Rscript console.r --json '{json.dumps(json.load(open('query.json')))}'").read()))
window = GraphWin("Animation", 700, 700)

r = objects.Animatable(Rectangle(Point(10, 10), Point(40, 30)), window)
r = objects.Animatable(Oval(Point(690, 690), Point(660, 670)), window)
r = objects.Animatable(Circle(Point(350, 350), 40), window)

asyncio.run(
    r.animate([
        {
            "operation": "size",
            "points": [1, 1.2, 3, 2.1, 5],
            "duration": 10
        }
    ]).play()
)

# objects.Animator([
# ], window).play()

window.getMouse()
window.close()
