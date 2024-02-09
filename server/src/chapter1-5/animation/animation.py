import asyncio
from graphics import Rectangle, Point, Circle, Oval, GraphWin
import objects

# print(json.loads(os.popen(f"Rscript console.r --json '{json.dumps(json.load(open('query.json')))}'").read()))
window = GraphWin("Animation", 700, 700, autoflush=True)

async def f():
    x = 355
    y = 355
    previous = None
    for i in range(10):
        await asyncio.sleep(0.2)
        if previous != None:
            previous.undraw()
        previous = Circle(Point(x, y), 50)
        previous.draw(window)
        x += 5
        y += 5

r = objects.Animatable(Rectangle(Point(375, 375), Point(325, 325)), window).draw()
o = objects.Animatable(Oval(Point(690, 690), Point(660, 670)), window).draw()

asyncio.run(
    r.animate([
        {
            "operation": "position",
            "points": [
                [350, 350],
                [375, 375],
                [375, 350],
                [350, 325],
                [350, 350]
            ],
            "duration": 10
        }
    ]).play()
)

# objects.Animator([
# ], window).play()

window.getMouse()
window.close()
