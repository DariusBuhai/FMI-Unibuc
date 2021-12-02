import numpy as np
import copy
import math


class NodParcurgere:
    def __init__(self, info, parinte, g, f):
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.f = f
        self.g = g

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
    def genereazaSuccesori(self, nodCurent):
        # de modificat
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
        for i in range(t1 + 1):
            for j in range(t2 + 1):
                if (i == 0 or j == 0 or i <= j) and i + j <= self.capacitateBarca and (i != 0 or j != 0):
                    canNew = can + eps * i
                    misNew = mis + eps * j
                    if (canNew == 0 or misNew == 0 or canNew <= misNew) and (
                            n - canNew == 0 or n - misNew == 0 or n - canNew <= n - misNew):
                        res = [canNew, misNew, eps * (-1)]
                        if nodCurent.contineInDrum(res):
                            continue
                        listaSuccesori.append((res, self.calculeaza_h(res), nodCurent.g + 1))
        return listaSuccesori

    def calculeaza_h(self, nod_info):
        # de completa
        # nod.info = (x, y, eps) h(nod) = [(x + y)/M]
        # consistenta nod.info = (x, y, eps) -> nod'.info = (x',y',-1 * eps) ||h(nod) <= c(nod -> nod') + h(nod')|| echiv ||h(nod) <= 1 + h(nod')|| echiv [(x + y)/M] <= 1 + [(x' + y')/M]
        # x' + y' => x + y - M echiv x' + y' + M >= x + y echiv
        # h(nod) <= c(nod -> nod') + h(nod')
        can, mis, eps = nod_info
        return (can + mis) // self.capacitateBarca

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
n = 10
start = [n, n, -1]
scopuri = [[0, 0, 1]]

gr = Graph(start, scopuri, capacitate_barca, n)


def construieste_drum(nodCurent: NodParcurgere, limita):
    if nodCurent.info in scopuri:
        nodCurent.afisDrum()
        return (True, 0)

    if nodCurent.f > limita:
        return (False, nodCurent.f)

    mini = float('inf')

    for (info, h, g) in gr.genereazaSuccesori(nodCurent):
        (ajuns, lim) = construieste_drum(NodParcurgere(info, nodCurent, g, g + h), limita)
        if ajuns:
            return (True, 0)
        mini = min(mini, lim)

    return (False, mini)


# niv = 1, facem dfs pana la nivel 1, daca am intalnit un scop => ne-am oprit, daca nu atunci distanta de la nodStart pana la nodScop >= 2
# niv = 2 , ......, daca nu atunci distanta de la nodStart pana la NodScop >= 3 ....
def ida_star():
    # niv = h(startNod) facem dfs din nodurile care au niv >= f, daca f > niv nu apelam dfs pe succesori,
    # niv = min({f(nod) | f(nod) > niv si nod este o frunza a arborelui expandat})
    nivel = gr.calculeaza_h(start)
    nodStart = NodParcurgere(start, None, 0, gr.calculeaza_h(start))
    while True:
        (ajuns, lim) = construieste_drum(nodStart, nivel)
        if ajuns:
            break
        if lim == float('inf'):
            print("Nu exista drum!")
            break
        nivel = lim


if __name__ == '__main__':
    ida_star()
