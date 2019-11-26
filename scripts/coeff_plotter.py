import matplotlib.pyplot as plt

file="mfcc_2_3.txt"

with open(file) as f:
    lines = f.readlines()
    x = [line.split()[0] for line in lines]
    y = [line.split()[1] for line in lines]

# método 1
import numpy as np
x1 = np.array(x)
x2 = x1.astype(np.float)
y1 = np.array(y)
y2 = y1.astype(np.float)

plt.plot(x2,y2, marker='.', linestyle='None')
plt.show()


#método 2
# plt.plotfile(file, (0,1), delimiter="\t", subplots=False, linestyle='None', marker='.')
# plt.show()
