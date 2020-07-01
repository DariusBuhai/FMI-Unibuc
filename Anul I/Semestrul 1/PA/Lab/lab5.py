
INP = True

if INP:
    n = int(input())
else:
    with open("damesah.in", "r") as r:
        n = int(r.read())

pos = []
fpos = []

tcases = 0

diag1 = []
diag2 = []

ttw = ""

def check(i, j):
    if j in pos:
        return False
    if i + j in diag1 or i - j in diag2:
        return False
    return True

def back(i = 0):
    global n
    global tcases
    if i == n:
        tcases += 1
        fpos.append(pos[:])
        return
    for j in range(0, n):
        if check(i, j):
            pos.append(j)
            diag1.append(i + j)
            diag2.append(i - j)
            ###
            back(i + 1)
            ###
            pos.pop()
            diag1.pop()
            diag2.pop()

#### generate all
'''
for n in range(4, 14):
    back()
    tw = fpos[0][:]
    for p in tw:
        ttw += str(p + 1) + " "
    ttw += '\\n' + str(tcases) + "', '"
    fpos.clear()
    tcases = 0

with open("damesah.out", "w") as w:
    w.write(ttw)
'''

#### generated
'''
results = ['2 4 1 3 \n2', '1 3 5 2 4 \n10', '2 4 6 1 3 5 \n4', '1 3 5 7 2 4 6 \n40', '1 5 8 6 3 7 2 4 \n92', '1 3 6 8 2 4 9 7 5 \n352', '1 3 6 8 10 5 9 2 4 7 \n724', '1 3 5 7 9 11 2 4 6 8 10 \n2680', '1 3 5 8 10 12 6 11 2 7 9 4 \n14200', '1 3 5 2 9 12 10 13 4 6 8 11 7 \n73712']
with open("damesah.out", "w") as w:
    w.write(results[n-4])
'''

#### normal

back()

with open("damesah.out", "w") as w:
    tw = fpos[0][:]
    for p in tw:
        ttw += str(p + 1) + " "
    ttw += '\n' + str(tcases)
    w.write(ttw)
