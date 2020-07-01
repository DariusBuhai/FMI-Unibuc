
def f0():
    a = [1, 3, 5, 7]
    print(a[-1:-(len(a) + 1):-1])
    a = "salut"
    print(list(a))
#f0()

def f1():
    b = input("String: ")
    b = list(b)
    index = 0
    for i in b:
        if ord(i) >= ord('a') and ord(i) <= ord('z'):
            b[index] = chr(ord(i) - 32)
        if ord(i) >= ord('A') and ord(i) <= ord('Z'):
            b[index] = chr(ord(i) + 32)
        index += 1
    print(''.join(b))
#f1()

def f2():
    a = 'a,,\n2,,3'
    print(a.split(' '))
    b = ' 1  3 4'
    print(''.join((b.split())))
#f2()

def f3():  # list comprehension
    a = [1, 2, 3, 4, 5, 6]
    b = [x for x in a if x % 2 == 0]  # {x|x in A si x | r)
    c = [2 ** x for x in range(10)]
    d = [x ** y for x in range(1, 5) for y in range(1, 5)]
    print(b, c, d)
#f3()

def prim(x):
    for d in range(2, int(x**(1/2)+1)):
        if x%d==0:
            return False
    return True

def f4(r = 101):
    print([x for x in range(2, r) if prim(x)]) # prime numbers with list comprehension
#f4()

def t_sec(x):
    return int(x[0])*60*60+int(x[1])*60+int(x[2])

def f5():
    a = '23:00:00'.split(':')
    b = '06:45:00'.split(':')
    dif = t_sec(b)-t_sec(a)
    if dif<=0:
        dif += 24*60*60
    return ':'.join([str(dif // (60 * 60)),str((dif % (60 * 60)) // 60),str(dif % 60)])

# print(f5())
# divizibil cu 4 dar nu cu 100, divizibil cu 400 dar nu cu 10000
def bisect(x):
    if x%4!=0:
        return False
    if x%100!=0:
        return True
    if x%400!=0:
        return False
    if x%10000!=0:
        return False
    return False
print([x for x in range(1900, 2020) if bisect(x)])

# Tema:
# Vi se da un text pe un singur rand format din litere, cifre spatii si semne de punctuatie.
# Trebuie sa numarati cate cuvinte sunt si sa le afisati pe cele mai scurte 10.


