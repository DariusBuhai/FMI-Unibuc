a = [[2, 3, 4, 5],
     [5, 6, 1, 7],
     [4, 5, 1, 8],
     [2, 4, 8, 1]]

m, n = 4, 4
for i in range(1, n):
    for j in range(0, m):
        if j > 0:
            a[i][j] += max(a[i-1][j-1], [i-1][j])
        else:
            a[i][j] += a[i-1][j]

print(max(a[m-1]))
