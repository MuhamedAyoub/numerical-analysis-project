import os
import json
import graphics as graph
import objects

d = objects.Animatable()
d.animate({
    "size": [1, 2, 3, 4, 5],
    "position": [[1, 2], [3, 4], ]
})

# print(json.loads(os.popen(f"Rscript console.r --json '{json.dumps(json.load(open('query.json')))}'").read()))

