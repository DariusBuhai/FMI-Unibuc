t = [3, 2, 1, 1, 5, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1]
# t = [2, 3, 1, 5, 1, 1, 4]
#t = [1, 2, 3, 4, 1, 1, 1]
t = [1, 2]

def greedy():
    index = 0
    count = 1
    while index < len(t):
        val = t[index]
        maxiafter = -99999
        maxip = index
        index2 = val
        for i in range(index+1, min(index+val+1, len(t))):
            index2 -= 1
            valc = t[i]
            after = valc - index2
            if after > maxiafter:
                maxiafter = after
                maxip = i
        count += 1
        ######
        if maxip == len(t)-1:
            return count
        ######
        if maxip + t[maxip] >= len(t)-1:
            return count + 1
        index = maxip
    return count

print(greedy())
