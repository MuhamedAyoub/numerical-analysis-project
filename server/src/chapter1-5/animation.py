import os
import json
import graphics as graph

# print(json.loads(os.popen(f"Rscript console.r --json '{json.dumps(json.load(open('query.json')))}'").read()))

window = graph.GraphWin("Hello", 200, 200)
c = graph.Circle(graph.Point(50, 50), 10)
c.draw(window)
c.setFill(graph.color_rgb(0, 0, 0))
window.setBackground(graph.color_rgb(255, 255, 20))
window.getMouse()
graph.Rectangle(graph.Point(10, 10), graph.Point(20, 20)).draw(window)
c.move(20, 30)
c.setWidth(20)
window.getMouse()
window.close()

