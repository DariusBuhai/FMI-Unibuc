forest = []
trees = []
with open("arie.in", "r") as r:
    forest.extend([int(x) for x in r.readline().split()])
    forest.extend([int(x) for x in r.readline().split()])
    r.readline()
    trees = [(int(x.split()[0]), int(x.split()[1])) for x in r.read().split('\n')]

import random

random.shuffle(trees)

def find_tree(a, b, c, d):
    global count
    count -= 1
    for tree in trees:
        count += 1
        if a < tree[0] < c and b < tree[1] < d:
            return tree
    return None


def modulo(x):
    if x < 0:
        return -x
    return x

count = 0
#             x  y  x  y
def find_area(a, b, c, d):
    global count
    count += 1
    tree = find_tree(a, b, c, d)
    if tree is None:
        return modulo(a - c) * modulo(b - d)
    a1 = find_area(a, b, c, tree[1])
    a2 = find_area(tree[0], b, c, d)
    a3 = find_area(a, tree[1], c, d)
    a4 = find_area(a, b, tree[0], d)
    return max(a1, a2, a3, a4)


print("\nMaximum area:", find_area(forest[0], forest[1], forest[2], forest[3]))
n = len(trees)
countp = 0
while count > 0:
    countp += 1
    count //= n

print("Complexity: n^", countp, sep='')

