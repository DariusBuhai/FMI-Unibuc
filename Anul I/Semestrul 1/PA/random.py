
def cmlsc():
    a = [1, 7, 3, 9, 8]
    b = [7, 5, 8]
    c = []
    m, n = 5, 3
    for i in range(m):
        c.append([])
        for j in range(n):
            r = 0
            if j > 0 and i > 0:
                r = max(c[i][j-1], c[i-1][j])
            if a[i] == b[j]:
                r += 1
            c[i].append(r)
    print(c[m-1][n-1])


def cmsc():
    a = [3, 4, 5, 7, 1 ,8, 1, 4, 5, 9]
    #### 1  2  3  4  1  5  1  2  3  6
    maxi = [1]
    for i in range(1, len(a)):
        maxi.append(1)
        for j in range(i-1, -1, -1):
            if a[j] < a[i] and maxi[j] + 1 > maxi[i]:
                maxi[i] = maxi[j] + 1
    print(max(maxi))

def parc_n(f, m_ad, n):
    res = [f]
    for i in range(1, n+1):
        if m_ad[f][i] == 1:
            res1 = parc_n(i, m_ad, n)
            res.extend(res1)
    return res



def sort_topo():
    arc = [[1, 2], [1, 3], [3, 4], [3, 5], [5, 9], [4, 6], [4, 7], [4, 8]]
    n = 9
    m_ad = [[0 for x in range(n+1)] for y in range(n+1)]
    vis = [0 for x in range(n)]
    top_i = 0
    for x in arc:
        m_ad[x[0]][x[1]] = 1
        vis[x[1]-1] = 1
    top_i = vis.index(0)+1
    print(parc_n(top_i, m_ad, n))


sort_topo()
cmlsc()
cmsc()