import random

def gcd(x, y):
    while y:
        z = x%y
        x = y
        y = z
    return x

def lcd(x, y):
    return (x*y)//gcd(x,y)

def lcd_list():
    n = int(input())
    gcd_list = {lcd(i+1,j+1) for i in range(n) for j in range(n)}
    print(gcd_list)

#lcd_list()

def medie(note):
    if len(note):
        return sum(note)/len(note)
    return 1.0

def dict_usages():
    catalog = {
            "Darius": {7, 9},
            "Mihai": {5, 10},
            "Gica": {2, 1}
            }
    print(catalog["Gica"])
    print(catalog.keys())
    print(list(catalog.values()))
    print({om: medie(catalog[om]) for om in catalog.keys()})
#dict_usages()

def generate_accounts():
    with open("date.in", "r") as r:
        names = r.read().split('\n')
    with open("date.out", "w") as w:
        for name in names:
            user = '.'.join(reversed([x.lower() for x in name.split()]))+"@myfmi.unibuc.ro"
            pas = random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
            pas.extend(random.choices('qwertyuiopasdfghjklzxcvbnm',k=3))
            pas.extend(random.choices('1234567890', k=4))
            passtr = ''.join(pas)
            w.write(user+','+passtr+'\n')

def generate_spirala():
    n = 5
    kn = n // 2
    if n % 2 != 0:
        kn += 1
    mat = []
    for k in range(kn):
        for j in range(k, n-k):
            mat.append((k, j))
        for i in range(k+1, n-k):
            mat.append((i, n-k-1))
        for j in range(n-k-2, k, -1):
            mat.append((n-k-1, j))
        for i in range(n-k-1, k, -1):
            mat.append((i, k))
    print(mat)
    spirala = [x[0]*n + (x[1]+1) for x in mat]
    print(spirala)


generate_spirala()