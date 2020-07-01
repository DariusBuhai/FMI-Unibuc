#from rainbow import RaibowDeck
from pathlib import Path


#RD = RaibowDeck("passwords.txt")
#print(RD.get())


#t = Path("hash.txt").read_text().split('\n')
#r = RD.get()
#str = ''.join(a+':'+b+'\n' for a in t for b in r)
#Path("hash.txt").write_text(str)

#print(RD.find_password("03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4"))

#p = Path("hash.txt").read_text().split('\n')

def prime_generator(n):
    m = []
    for i in range(2, n):
        if i not in m:
            yield i
            j = 2*i
            while j <= n:
                m.append(j)
                j += i

for p in prime_generator(100):
    print(p)
