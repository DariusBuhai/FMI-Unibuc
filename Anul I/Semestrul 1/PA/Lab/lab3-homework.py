# Tema: se dau mai multe cataloage, sa se intercaleze
# cat1 = {"Darius":[10], "Florin":[10, 10]}
# cat2 = {"Darius":[10], "Florin":[10,10,10]}
# abs1 = {"Florin": 2}
# abs2 = {"Darius": 1, "Florin": 1}

cat1 = {"Darius":[10], "Florian":[10,10,10]}
cat2 = {"Marius":[10],"George": [10], "Darius": [9], "Florian":[10, 5]}

abs1 = {"Darius": 1, "Florian": 3}
abs2 = {"Marius": 1, "Florian": 0}

for c1 in cat1:
    if c1 in cat2:
        found = True
        for n in cat1[c1]:
            cat2[c1].append(n)
    else:
       cat2[c1] = cat1[c1]
    cat2[c1].sort()

for a1 in abs1:

    found = False
    for a2 in abs2:
        if a1 == a2:
            found = True
            abs2[a2] += abs1[a1]
    if not found:
        abs2[a1] = abs1[a1]
    num = abs2[a1]

    if a1 in cat2:
        while len(cat2[a1]) > 0 and num > 0:
            num -= 1
            cat2[a1].pop()

for c2 in cat2:
    nr = 0
    sums = 0
    for n in cat2[c2]:
        nr += 1
        sums += n
    cat2[c2] = sums/nr

print(cat2)