import json
import matplotlib.pyplot as plt

with open('actual.json') as f:
    d = json.load(f)
    grid_out = d["out_int"]
    
    plt.imshow(grid_out)
    plt.colorbar()
    # plt.show()
    plt.savefig('sandpile.png')
