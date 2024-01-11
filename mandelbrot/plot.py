import json
import matplotlib.pyplot as plt

with open('./mandelbrot_prj/solution/csim/build/out.json') as f:
# with open('./actual.json') as f:
    d = json.load(f)
    grid = d["grid_int"]

    plt.imshow(grid)
    # plt.show()
    plt.savefig('mandel.png')

    #for i in range()
    #" .:-;!/>)|&IH%*#"[cell&15]