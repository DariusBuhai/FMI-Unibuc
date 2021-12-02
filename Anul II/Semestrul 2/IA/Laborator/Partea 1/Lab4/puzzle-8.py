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
        print("->".join([str(x) for x in l]))
        return len(l)

    def contineInDrum(self, infoNodNou):
        nodDrum = self
        while nodDrum is not None:
            if infoNodNou == nodDrum.info:
                return True
            nodDrum = nodDrum.parinte

        return False

    def __repr__(self):
        sir = ""
        sir += self.info + "("
        sir += "id = {}, ".format(self.id)
        sir += "drum="
        drum = self.obtineDrum()
        sir += "->".join(drum)
        sir += " cost:{})".format(self.cost)
        return sir


class Graph:  # graful problemei
    def __init__(self, start, scop, capacitateBarca, n):
        self.start = start
        self.scop = scop
        self.capacitateBarca = capacitateBarca
        self.n = n

    def indiceNod(self, n):
        return self.noduri.index(n)

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent):
        listaSuccesori = []
        mat = nodCurent.info
        eps = (-1, -1)

        for i in range(len(mat)):
            for j in range(len(mat[0])):
                if mat[i][j] == -1:
                    eps = (i, j)
                    break
        dx = [-1, 1, 0, 0]
        dy = [0, 0, -1, 1]
        for i in range(4):
            nx = eps[0]+dx[i]
            ny = eps[1]+dy[i]
            if 0 <= nx < len(mat) and 0 <= ny < len(mat[0]):
                # deep copy
                succesor = [[y for y in x] for x in mat]
                aux = succesor[nx][ny]
                succesor[nx][ny] = -1
                succesor[eps[0]][eps[1]] = aux
                listaSuccesori.append((succesor, self.calculeaza_h(succesor), nodCurent.g + 1))

        return listaSuccesori

    def calculeaza_h(self, nod_info):
        curr_pos = dict()
        h = 0
        for i in range(len(nod_info)):
            for j in range(len(nod_info[0])):
                curr_pos[nod_info[i][j]] = (i, j)
        for i in range(len(nod_info)):
            for j in range(len(nod_info[0])):
                curr = self.scop[i][j]
                h += abs(i - curr_pos[curr][0]) + abs(j - curr_pos[curr][1])
        return h / 2

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return sir


##############################################################################################
#                                 Initializare problema                                      #
##############################################################################################

capacitate_barca = 1
nrSolutiiCautate = 1
n = 10
start = [[5, 7, 2], [8, -1, 6], [3, 4, 1]]
#scop = [[1, 2, 3], [4, 5, 6], [7, 8, -1]]
scop = [[5, -1, 2], [8, 7, 6], [3, 4, 1]]

gr = Graph(start, scop, capacitate_barca, n)


def construieste_drum(nodCurent: NodParcurgere, limita):
    if nodCurent.info == scop:
        nodCurent.afisDrum()
        return True, 0

    if nodCurent.f > limita:
        return False, nodCurent.f

    mini = float('inf')

    for (info, h, g) in gr.genereazaSuccesori(nodCurent):
        (ajuns, lim) = construieste_drum(NodParcurgere(info, nodCurent, g, g + h), limita)
        if ajuns:
            return True, 0
        mini = min(mini, lim)

    return False, mini


def puzzle_8():
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
    puzzle_8()
