# Ref https://stackoverflow.com/questions/52285104/3d-scatterplots-with-hue-colormap-and-legend

import seaborn as sns
import pandas as df
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.colors import ListedColormap

labels = ["x", "y", "z"]

dat = df.read_table(f"lorenz_prj/solution/csim/build/out.dat", sep=",", header=None, names=labels)

# axes instance
fig = plt.figure(figsize=(6,6))
ax = Axes3D(fig, auto_add_to_figure=False)
fig.add_axes(ax)

# get colormap from seaborn
cmap = ListedColormap(sns.color_palette("husl", 256).as_hex())

# plot
sc = ax.scatter(dat.x, dat.y, dat.z, s=4, c=dat.x, marker='o', cmap=cmap, alpha=1)
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

# legend
# plt.legend(*sc.legend_elements(), bbox_to_anchor=(1.05, 1), loc=2)

# save
plt.savefig("lorenz.png", bbox_inches='tight')
