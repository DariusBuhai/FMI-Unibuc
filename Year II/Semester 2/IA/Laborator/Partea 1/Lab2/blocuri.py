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
    def __init__(self, start):
        self.start = start

    def indiceNod(self, n):
        return self.noduri.index(n)

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent, c):
        listaSuccesori = []

        return listaSuccesori

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return (sir)

    def testScop(nod):
        return

    # not fin := exista sti, stj astfel incat len(sti) and len(stj) and len(sti) != len(stj)


start = [[1, 23, 4, 5, 6, 7, 8], [34, 45, 10], [100, 1000, 34, 6], [2312, 667, 37]]

gr = Graph(start)


def uniform_cost(gr):
    global nrSolutiiCautate
    c = [NodParcurgere(-1, start, 0, None)]
    continua = True
    while (len(c) > 0 and continua):
        nodCurent = c.pop(0)
        # print("Processing node ", nodCurent.info)

        if gr.testScop(nodCurent):
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
    print("Got here")
    uniform_cost(gr)