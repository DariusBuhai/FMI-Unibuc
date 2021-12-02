with open("inp.txt", "r") as r:
    inp = r.read().split('\n')
    inp = [[int(y) for y in x.split(' ')] for x in inp[1:]]

## 18 15 53 52 48 24 23
## 1 2 3 4 5 6 7 8 9
## 0 2 3 3 1 0 0 1 0

used = [0 for x in range(10)]
pairs = [[] for x in range(10)]

maxi = 0
index_m = 0
counter_max = 1

for a in inp:
    if used[a[0]] + 1 > used[a[1]]:
        used[a[1]] = used[a[0]] + 1
        pairs[a[1]] = pairs[a[0]][:]
        pairs[a[1]].append(a)
        if used[a[1]] > maxi:
            index_m = a[1]
            maxi = used[a[1]]
            counter_max = 1
        elif used[a[1]] == maxi:
            counter_max += 1

print(pairs[index_m])
print(counter_max)