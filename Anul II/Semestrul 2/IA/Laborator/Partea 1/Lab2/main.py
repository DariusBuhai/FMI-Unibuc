import numpy as np
import copy


class NodParcurgere:
    def __init__(self, id, info, cost, parinte):
        self.id = id  # este indicele din vectorul de noduri
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.cost = cost

    def obtineDrum(self):
        l = [self.info]
        nod = self
        while nod.parinte is not None:
            l.insert(0, nod.parinte.info)
            nod = nod.parinte
        return l

    def afisDrum(self):  # returneaza si lungimea drumului
        l = self.obtineDrum()
        print(("->").join([str(x) for x in l]))
        return len(l)

    def contineInDrum(self, infoNodNou):
        nodDrum = self
        while nodDrum is not None:
            if (infoNodNou == nodDrum.info):
                return True
            nodDrum = nodDrum.parinte

        return False

    def __repr__(self):
        sir = ""
        sir += self.info + "("
        sir += "id = {}, ".format(self.id)
        sir += "drum="
        drum = self.obtineDrum()
        sir += ("->").join(drum)
        sir += " cost:{})".format(self.cost)
        return (sir)

class Graph:  # graful problemei
    def __init__(self, start, scopuri, capacitateBarca, n):
        self.start = start
        self.scopuri = scopuri
        self.capacitateBarca = capacitateBarca
        self.n = n

    def indiceNod(self, n):
        return self.noduri.index(n)

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent, c):
        listaSuccesori = []
        [can, mis, eps] = nodCurent.info
        t1 = 0
        t2 = 0
        if eps == 1:
          t1 = n - can 
          t2 = n - mis
        else:
          t1 = can
          t2 = mis
        for i in range(t1+1):
          for j in range (t2+1):
            if (i == 0 or j==0 or i <= j) and i+j <= self.capacitateBarca and (i != 0 or j!=0):
              canNew = can + eps*i
              misNew = mis + eps*j
              if (canNew == 0 or misNew == 0 or canNew <= misNew) and (n - canNew == 0 or n - misNew == 0 or  n - canNew <= n-misNew):
                res = [canNew, misNew, eps * (-1)]
                if nodCurent.contineInDrum(res):
                  continue
                listaSuccesori.append(NodParcurgere(-1, res,nodCurent.cost + 1, nodCurent))
        return listaSuccesori

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return (sir)


##############################################################################################
#                                 Initializare problema                                      #
##############################################################################################

# pozitia i din vector
capacitate_barca = 4
nrSolutiiCautate = 1
n = 6
start = [n, n, -1]
scopuri = [[0, 0, 1]]

gr = Graph(start, scopuri, capacitate_barca, n)


def uniform_cost(gr):
    global nrSolutiiCautate
    c = [NodParcurgere(-1, start, 0, None)]
    continua = True
    while (len(c) > 0 and continua):
        # print("Coada actuala: " + str(c))
        # input()
        nodCurent = c.pop(0)

        if nodCurent.info in scopuri:
            nodCurent.afisDrum()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                continua = False
        lSuccesori = gr.genereazaSuccesori(nodCurent, c)
        for s in lSuccesori:
            i = 0
            gasit_loc = False
            for i in range(len(c)):
                # diferenta e ca ordonez dupa f
                if c[i].cost >= s.cost:
                    gasit_loc = True
                    break
            if gasit_loc:
                c.insert(i, s)
            else:
                c.append(s)

if __name__ == '__main__':
    uniform_cost(gr)