
with open("maxsecv.in", "r") as r:
    inp = r.read()

inp = inp.split('\n')
n = int(inp[0])
inp = inp[1].replace(' ', '')

maxi1 = 0
maxi2 = 0
cm = 0

for x in inp:
    if x == '1':
        cm += 1
    else:
        if cm > maxi1:
            maxi2 = maxi1
            maxi1 = cm
        elif cm > maxi2:
            maxi2 = cm
        cm = 0

if cm > maxi1:
    maxi2 = maxi1
    maxi1 = cm
elif cm > maxi2:
    maxi2 = cm

with open("maxsecv.out", "w") as w:
    w.write(str(maxi1+maxi2))
