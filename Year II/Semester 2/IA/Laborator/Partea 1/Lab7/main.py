import time
import copy


class Joc:
    """
    Clasa care defineste jocul.
    """
    NR_COLOANE = 7
    nr_con = 4
    JMIN = None
    JMAX = None
    GOL = '#'

    def __init__(self, tabla=None):  # Constructorul clasei
        if tabla is not None:
            self.matr = tabla
        else:
            self.matr = [Joc.GOL] * self.NR_COLOANE ** 2  # Daca nu exista o tabla, o intializez cu
            # NR_coloane ^ 2 de locuri goale, i.e. '#'

    def pos(self, a, b):
      return a * self.NR_COLOANE + b


    def final(self):
        rez = False
        for i in range(self.NR_COLOANE):
          for j in range(self.NR_COLOANE):
            if self.matr[self.pos(i, j)] != '#':

              u_linie= u_coloana = u_diagonala1 = u_diagonala2 = True

              for dx in range(4):
                if j + dx < self.NR_COLOANE and self.matr[self.pos(i, j + dx)] == self.matr[self.pos(i, j)]:
                    pass
                else:
                  u_linie = False

                if i + dx < self.NR_COLOANE and self.matr[self.pos(i+ dx, j)] == self.matr[self.pos(i, j)]:
                  pass
                else:
                  u_coloana = False

                if i + dx < self.NR_COLOANE and j + dx < self.NR_COLOANE and self.matr[self.pos(i+ dx,j + dx)] == self.matr[self.pos(i, j)]:
                    pass
                else:
                    u_diagonala1 = False

                if i + dx < self.NR_COLOANE and j - dx >= 0 and self.matr[self.pos(i+ dx, j - dx)] == self.matr[self.pos(i, j)]:
                    pass
                else:
                    u_diagonala2 = False

              if u_linie or u_coloana or u_diagonala1 or u_diagonala2:
                rez = self.matr[self.pos(i, j)]



        if rez:
            return rez
        elif Joc.GOL not in self.matr:
            return 'remiza'
        else:
            return False

            # Voi calcula mutarile posibile pe actuala tabla

    def castigaJucator(self, jucator, list):
        distEl = set(list)
        return len(distEl) == 1 and distEl.pop() == jucator

    def grupOk(self, jucator, lista):
      k = len(lista)
      return self.castigaJucator(jucator, lista[0: k-1]) and lista[k - 1] == Joc.GOL or self.castigaJucator(jucator, lista[1: k]) and lista[0] == Joc.GOL

    def numarElementeInLinie(self, maxJucator, minJucator):

        total = [0, 0]
        #pozitia 0 jucator 0, 1 jucator x
        coef = [1, 2, 5, 10]

        vx = [0, 1, 1, 1]
        vy = [1, 0, 1, -1]

        for i in range(self.NR_COLOANE):
          for j in range(self.NR_COLOANE):
            for k in range(2, 6):
              for t in range(4):
                if i + vx[t]*k < self.NR_COLOANE and j+vy[t]*k < self.NR_COLOANE and i + vx[t]*k >= 0 and j + vy[t]*k >= 0:
                  lista = [self.matr[self.pos(i + vx[t]*l, j + vy[t]*l)]for l in range(k)]
                  if(self.grupOk(maxJucator, lista)):
                    total[0] += coef[k-2]
                  if(self.grupOk(minJucator, lista)):
                    total[1] += coef[k-2]

        return total


        #########


    def mutari(self, jucator):
        l_mutari = []

        n = len(self.matr)
        pos = 0
        for j in range(self.NR_COLOANE):
          pos = 0
          for i in range(self.NR_COLOANE):
            if self.matr[self.pos(i, j)] == '#':
              pos = i

          if pos < self.NR_COLOANE:
            noua_stare = copy.deepcopy(self.matr)
            noua_stare[self.pos(pos, j)] = jucator
            l_mutari.append(Joc(noua_stare))

        return l_mutari


        if self.JMAX not in self.matr:
            copie_matr = copy.deepcopy(self.matr)
            copie_matr[i] = jucator
            l_mutari.append(Joc(copie_matr))
        return l_mutari

    # linie deschisa inseamna linie pe care jucatorul mai poate forma o configuratie pierzatoare
    # Configuratie pierzatoare inseamna 3 * x sau 3 * 0 pe linie/coloana/diagonala

    def estimeaza_scor(self, adancime):
        #de revizuit
        t_final = self.final()
        # if (adancime==0):
        if t_final == self.__class__.JMAX:
            return (99 + adancime)
        elif t_final == self.__class__.JMIN:
            return (-99 - adancime)
        elif t_final == 'remiza':
            return 0
        else:
            valori = self.numarElementeInLinie(self.__class__.JMAX, self.__class__.JMIN)
            return valori[0] - valori[1]

    def __str__(self):
        sir = ''
        for i in range(self.NR_COLOANE):
            sir = sir + (" ".join(str(x) for x in self.matr[i * self.NR_COLOANE:(i + 1) * self.NR_COLOANE]) + "\n")
        return sir


class Stare:
    """
    Clasa folosita de algoritmii minimax si alpha-beta
    Are ca proprietate tabla de joc
    Functioneaza cu conditia ca in cadrul clasei Joc sa fie definiti JMIN si JMAX (cei doi jucatori posibili)
    De asemenea cere ca in clasa Joc sa fie definita si o metoda numita mutari() care ofera lista cu configuratiile posibile in urma mutarii unui jucator
    """

    def __init__(self, tabla_joc, j_curent, adancime, parinte=None, scor=None):
        self.tabla_joc = tabla_joc
        self.j_curent = j_curent

        # adancimea in arborele de stari
        self.adancime = adancime

        # scorul starii (daca e finala) sau al celei mai bune stari-fiice (pentru jucatorul curent)
        self.scor = scor

        # lista de mutari posibile din starea curenta
        self.mutari_posibile = []

        # cea mai buna mutare din lista de mutari posibile pentru jucatorul curent
        self.stare_aleasa = None

    def jucator_opus(self):
        if self.j_curent == Joc.JMIN:
            return Joc.JMAX
        else:
            return Joc.JMIN

    def mutari(self):
        l_mutari = self.tabla_joc.mutari(self.j_curent)
        juc_opus = self.jucator_opus()
        l_stari_mutari = [Stare(mutare, juc_opus, self.adancime - 1, parinte=self) for mutare in l_mutari]

        return l_stari_mutari

    def __str__(self):
        sir = str(self.tabla_joc) + "(Joc curent:" + self.j_curent + ")\n"
        return sir


""" Algoritmul MinMax """


def min_max(stare):
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.scor = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare
    # calculez toate mutarile posibile din starea curenta
    stare.mutari_posibile = stare.mutari()

    # aplic algoritmul minimax pe toate mutarile posibile (calculand astfel subarborii lor)
    mutari_scor = [min_max(x) for x in
                   stare.mutari_posibile]  # expandez(constr subarb) fiecare nod x din mutari posibile

    if stare.j_curent == Joc.JMAX:
        # daca jucatorul e JMAX aleg starea-fiica cu scorul maxim
        stare.stare_aleasa = max(mutari_scor, key=lambda x: x.scor)
    else:
        # daca jucatorul e JMIN aleg starea-fiica cu scorul minim
        stare.stare_aleasa = min(mutari_scor, key=lambda x: x.scor)

    stare.scor = stare.stare_aleasa.scor
    return stare

def alpha_beta(alpha, beta, stare):
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.scor = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    if alpha > beta:
        return stare  # este intr-un interval invalid deci nu o mai procesez

    stare.mutari_posibile = stare.mutari()

    if stare.j_curent == Joc.JMAX:
        scor_curent = float('-inf')

        for mutare in stare.mutari_posibile:
            # calculeaza scorul
            stare_noua = alpha_beta(alpha, beta, mutare)  # aici construim subarborele pentru stare_noua

            if (scor_curent < stare_noua.scor):
                stare.stare_aleasa = stare_noua
                scor_curent = stare_noua.scor
            if (alpha < stare_noua.scor):
                alpha = stare_noua.scor
                if alpha >= beta:
                    break

    elif stare.j_curent == Joc.JMIN:
        scor_curent = float('inf')
        # completati cu rationament similar pe cazul stare.j_curent==Joc.JMAX
        for mutare in stare.mutari_posibile:
            # calculeaza scorul
            stare_noua = alpha_beta(alpha, beta, mutare)  # aici construim subarborele pentru stare_noua

            if (scor_curent > stare_noua.scor):
                stare.stare_aleasa = stare_noua
                scor_curent = stare_noua.scor
            if (beta > stare_noua.scor):
                beta = stare_noua.scor
                if alpha >= beta:
                    break

    stare.scor = stare.stare_aleasa.scor

    return stare


def afis_daca_final(stare_curenta):
    final = stare_curenta.tabla_joc.final()
    if (final):
        if (final == "remiza"):
            print("Remiza!")
        else:
            print("A pierdut " + final)

        return True

    return False


def main():
    # initializare algoritm
    raspuns_valid = False
    JOC = Joc()
    while not raspuns_valid:
        tip_algoritm = input("Algorimul folosit:\n 1.Minimax\n 2.Alpha-beta\n ")
        if tip_algoritm in ['1', '2']:
            raspuns_valid = True
        else:
            print("Nu ati ales o varianta corecta.")
    raspuns_valid = False
    while not raspuns_valid:
        dificultate = input("Dificultatea jocului: \n 1. Incepator\n 2. Intermediar\n 3. Experimentat\n")
        if dificultate in ['1', '2', '3']:
            raspuns_valid = True
        else:
            print("Nu ati ales o varianta corecta.")
    # initializare jucatori
    raspuns_valid = False
    while not raspuns_valid:
        Joc.JMIN = input("Doriti sa jucati cu x sau cu 0? ").lower()
        if (Joc.JMIN in ['x', '0']):
            raspuns_valid = True
        else:
            print("Raspunsul trebuie sa fie x sau 0.")
    Joc.JMAX = '0' if Joc.JMIN == 'x' else 'x'

    # initializare tabla
    tabla_curenta = Joc()
    print("Tabla initiala")
    print(str(tabla_curenta))

    # creare stare initiala

    if int(dificultate) == 1:
        stare_curenta = Stare(tabla_curenta, 'x', 3)
    if int(dificultate) == 2:
        stare_curenta = Stare(tabla_curenta, 'x', 4)
    if int(dificultate) == 3:
        stare_curenta = Stare(tabla_curenta, 'x', JOC.NR_COLOANE)

    timp_total = 0

    while True:
        if (stare_curenta.j_curent == Joc.JMIN):
            # mai trebuie pusa o validare
            # muta jucatorul
            raspuns_valid = False
            while not raspuns_valid:
                try:
                    renunt = input("Doriti sa iesiti?\nda sau nu\n")
                    if renunt == 'da':
                        return
                    timp_inainte_jucator = int(round(time.time() * 1000))
                    linie = int(input("linie="))
                    coloana = int(input("coloana="))
                    timp_dupa_jucator = int(round(time.time() * 1000))
                    print("Utilizatorul a gandit timp de " + str(
                        timp_dupa_jucator - timp_inainte_jucator) + " milisecunde.")

                    if (linie in range(0, JOC.NR_COLOANE) and coloana in range(0, JOC.NR_COLOANE) and renunt == 'nu'):
                        if stare_curenta.tabla_joc.matr[linie * JOC.NR_COLOANE + coloana] == Joc.GOL:
                            raspuns_valid = True
                        else:
                            print("Exista deja un simbol in pozitia ceruta.")
                    if linie < Joc.NR_COLOANE - 1 and stare_curenta.tabla_joc.matr[JOC.pos(linie + 1, coloana)] == Joc.GOL:
                        print("Pozitie gresita")
                        raspuns_valid = False
                    else:
                        print("Linie sau coloana invalida..")
                   ##################################################
                  ##################################################

                except ValueError:
                    print("Linia si coloana trebuie sa fie numere intregi")

            # dupa iesirea din while sigur am valide atat linia cat si coloana
            # deci pot plasa simbolul pe "tabla de joc"
            stare_curenta.tabla_joc.matr[linie * JOC.NR_COLOANE + coloana] = Joc.JMIN

            # afisarea starii jocului in urma mutarii utilizatorului
            print("\nTabla dupa mutarea jucatorului")
            print(str(stare_curenta))

            # testez daca jocul a ajuns intr-o stare finala
            # si afisez un mesaj corespunzator in caz ca da
            if (afis_daca_final(stare_curenta)):
                print("Scorul este: " + str(stare_curenta.scor) + "vs" + str(stare_actualizata.scor))
                print("Timpul total de joc este:" + str(timp_total) + "milisecunde.")
                break

            # S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = stare_curenta.jucator_opus()

        # --------------------------------
        else:  # jucatorul e JMAX (calculatorul)
            # Mutare calculator

            # preiau timpul in milisecunde de dinainte de mutare
            timp_inainte = int(round(time.time() * 1000))
            if tip_algoritm == '1':
                stare_actualizata = min_max(stare_curenta)
            else:  # tip_algoritm==2
                stare_actualizata = alpha_beta(-500, 500, stare_curenta)
            stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc  # aici se face de fapt mutarea !!!
            print("Tabla dupa mutarea calculatorului")
            print(str(stare_curenta))

            # preiau timpul in milisecunde de dupa mutare
            timp_dupa = int(round(time.time() * 1000))
            timp_total = timp_total + timp_dupa - timp_inainte
            print("Calculatorul a \"gandit\" timp de " + str(timp_dupa - timp_inainte) + " milisecunde.")

            if (afis_daca_final(stare_curenta)):
                print("Timpul total de joc este:" + str(timp_total) + " milisecunde.")
                print("Scorul este: " + str(stare_curenta.scor))
                break

            # S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = stare_curenta.jucator_opus()


if __name__ == "__main__":
    main()
