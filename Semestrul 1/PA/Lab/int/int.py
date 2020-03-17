with open("int.in", "r") as r:
    r = r.read().split('\n')
    n = int(r[0])
    x = [[int(x) for x in a.split()] for a in r[1:n+1]]

x.sort()

mini = x[0][1]
count = 1
for a in x[1:]:
    if a[0] >= mini:
        mini = a[1]
        count += 1
    else:
        mini = min(a[1], mini)


with open("int.out", "w") as w:
    w.write(str(count))




