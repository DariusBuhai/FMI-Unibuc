import random
import termcolor

with open("rucsac.in", "r") as r:
    weight = int(r.readline())
    obji = [[float(y) for y in x.split()] for x in r.read().split('\n')]
    obji = [[x[1], x[0], round(x[1]/x[0], 2)] for x in obji]

# random.shuffle(obji)
# print(obji)

def calc(obj):
    s = 0
    for e in obj:
        s += e[0]
    return s

def partition(obj, l, r):
    pi = obj[r][2]  # pivot
    i = l
    g = obj[r][1]
    for j in range(l, r):
        if obj[j][2] >= pi:
            g += obj[j][1]
            obj[j], obj[i] = obj[i], obj[j]
            i += 1
    obj[i], obj[r] = obj[r], obj[i]
    return [i, g]



def quickselect(obj, l, lw, r, weight):

    if l > r:
        dif = weight - lw
        difp = dif / obj[l][1]
        add = difp * obj[l][0]
        return calc(obj[:l]) + round(add, 2)
    res = partition(obj, l, r)
    m, g = res[0], res[1]

    if g + lw == weight:
        return calc(obj[:m+1])
    elif g + lw > weight:
        return quickselect(obj[:], l, lw, m-1, weight)
    else:
        return quickselect(obj[:], m+1, g + lw, r, weight)


ini = quickselect(obji[:], 0, 0, len(obji)-1, weight)
for i in range(0, 1000):
    random.shuffle(obji)
    new = quickselect(obji[:], 0, 0, len(obji)-1, weight)
    if new != ini:
        print(termcolor.colored("Error, printed: "+str(new)+" error caused when object = "+str(obji), 'red'))
print("\nCorrect answer:", ini)

