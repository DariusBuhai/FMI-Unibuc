import time
import copy


def elem_identice(lista):  # Intru in aceasta functie cu linia/coloana/diagonala pe care vreau sa o verific

    joc = Joc()
    for i in range(1, len(lista) - 1):
        if lista[i] != joc.GOL:
            if lista[i - 1] == lista[i] and lista[i + 1] == lista[
                i]:  # Aici se face verificarea propriu zisa. Adica daca sunt
                # 3 * x sau 3 * 0
                return lista[i]  # Returnez simbolul pierzator
        return False


class Joc:
    """
    Clasa care defineste jocul.
    """
    NR_COLOANE = 4  # Am ales sa setez numarul de linii, respectiv coloane
    # din program si nu din consola
    JMIN = None
    JMAX = None
    GOL = '#'

    def __init__(self, tabla=None):  # Constructorul clasei
        if tabla is not None:
            self.matr = tabla
        else:
            self.matr = [Joc.GOL] * self.NR_COLOANE ** 2  # Daca nu exista o tabla, o intializez cu
            # NR_coloane ^ 2 de locuri goale, i.e. '#'

    def final(self):
        rez = False

        for i in range(self.NR_COLOANE):

            # Merg pe linie, ex. [0:NR_COLOANE] = [0:4] va lua elementele 0,1,2,3 = prima linie
            if elem_identice(self.matr[self.NR_COLOANE * i:self.NR_COLOANE * (i + 1)]):
                rez = elem_identice(self.matr[self.NR_COLOANE * i:self.NR_COLOANE * (i + 1)])
            if rez:
                return rez

        for i in range(self.NR_COLOANE):

            # Merg pe coloane, ex. [0:NR_COLOANE ^ 2:NR_COLOANE] = [0:16:4] va lua elementele 0,4,8,12 = prima coloana
            if elem_identice(self.matr[i:self.NR_COLOANE * self.NR_COLOANE:self.NR_COLOANE]):
                rez = elem_identice(self.matr[i:self.NR_COLOANE * self.NR_COLOANE:self.NR_COLOANE])
            if rez:
                return rez

        # Merg pe diagonale
        # Diagonala principala, ex. [0:16:5] = [0,5,10,15]
        if elem_identice(self.matr[0:len(self.matr):self.NR_COLOANE + 1]):
            rez = elem_identice(self.matr[0:len(self.matr):self.NR_COLOANE + 1])
        # Diagonala secundara, ex. [3:14:3] = [3,6,9,12]
        if elem_identice(self.matr[self.NR_COLOANE - 1:len(self.matr) - 2:self.NR_COLOANE - 1]):
            rez = elem_identice(self.matr[self.NR_COLOANE - 1:len(self.matr) - 2:self.NR_COLOANE - 1])

        if rez:
            return rez
        elif Joc.GOL not in self.matr:
            return 'remiza'
        else:
            return False

            # Voi calcula mutarile posibile pe actuala tabla

    def mutari(self, jucator):
        l_mutari = []
        for i in range(len(self.matr)):
            if self.matr[i] == Joc.GOL:
                # Daca este spatiu GOL, pot pune simbolul acolo
                if i - 1 >= 0:
                    # Verific la stanga
                    if self.matr[i - 1] == jucator:
                        copie_matr = copy.deepcopy(self.matr)
                        copie_matr[i] = jucator
                        l_mutari.append(Joc(copie_matr))
                if i + 1 < self.NR_COLOANE * self.NR_COLOANE:
                    # Verific la dreapta
                    if self.matr[i + 1] == jucator:
                        copie_matr = copy.deepcopy(self.matr)
                        copie_matr[i] = jucator
                        l_mutari.append(Joc(copie_matr))
                if i - self.NR_COLOANE > 0:
                    # Verific in sus
                    if self.matr[i - self.NR_COLOANE] == jucator:
                        copie_matr = copy.deepcopy(self.matr)
                        copie_matr[i] = jucator
                        l_mutari.append(Joc(copie_matr))
                if i - self.NR_COLOANE + 1 > 0:
                    # Verific in sus dreapta
                    if self.matr[i - self.NR_COLOANE + 1] == jucator:
                        copie_matr = copy.deepcopy(self.matr)
                        copie_matr[i] = jucator
                        l_mutari.append(Joc(copie_matr))
                if i - self.NR_COLOANE - 1 > 0:
                    # Verific in sus stanga
                    if self.matr[i - self.NR_COLOANE - 1] == jucator:
                        copie_matr = copy.deepcopy(self.matr)
                        copie_matr[i] = jucator
                        l_mutari.append(Joc(copie_matr))
                if i + self.NR_COLOANE < self.NR_COLOANE * self.NR_COLOANE:
                    # Verific in jos
                    if self.matr[i + self.NR_COLOANE] == jucator:
                        copie_matr = copy.deepcopy(self.matr)
                        copie_matr[i] = jucator
                        l_mutari.append(Joc(copie_matr))
                if i + self.NR_COLOANE - 1 < self.NR_COLOANE * self.NR_COLOANE:
                    # Verific in jos stanga
                    if self.matr[i + self.NR_COLOANE - 1] == jucator:
                        copie_matr = copy.deepcopy(self.matr)
                        copie_matr[i] = jucator
                        l_mutari.append(Joc(copie_matr))
                if i + self.NR_COLOANE + 1 < self.NR_COLOANE * self.NR_COLOANE:
                    # Verific in jos dreapta
                    if self.matr[i + self.NR_COLOANE + 1] == jucator:
                        copie_matr = copy.deepcopy(self.matr)
                        copie_matr[i] = jucator
                        l_mutari.append(Joc(copie_matr))
                copie_matr = copy.deepcopy(self.matr)
                copie_matr[i] = jucator
                l_mutari.append(Joc(copie_matr))
                # if i-1<=0 or i+1>=self.NR_COLOANE**2 or i-self.NR_COLOANE<=0 or i+self.NR_COLOANE>=self.NR_COLOANE**2 or i-self.NR_COLOANE+1<=0 or i-self.NR_COLOANE-1<=0 or i+self.NR_COLOANE-1>=self.NR_COLOANE**2 or i+self.NR_COLOANE+1>=self.NR_COLOANE**2:
                #   l_mutari = []
                if self.JMAX not in self.matr:
                    copie_matr = copy.deepcopy(self.matr)
                    copie_matr[i] = jucator
                    l_mutari.append(Joc(copie_matr))
        return l_mutari

    # linie deschisa inseamna linie pe care jucatorul mai poate forma o configuratie pierzatoare
    # Configuratie pierzatoare inseamna 3 * x sau 3 * 0 pe linie/coloana/diagonala
    def linie_deschisa(self, lista, jucator):
        for i in range(1, len(lista) - 1):
            if lista[i] == jucator and lista[i + 1] == jucator and lista[i - 1] == self.GOL or lista[i] == jucator and \
                    lista[i - 1] == jucator and lista[i + 1] == self.GOL or lista[i + 1] == jucator and lista[
                i - 1] == jucator and lista[i] == self.GOL:
                return 0
            if i < len(lista) - 2:
                if lista[i] == jucator and lista[i + 1] == self.GOL and lista[i - 1] == jucator:
                    return 0
        return 1

        # Numar cate linii/coloane/diagonale deschise am

    def linii_deschise(self, jucator):
        sum = 0
        for i in range(self.NR_COLOANE):
            # Verific daca am linii deschise
            sum = sum + self.linie_deschisa(self.matr[self.NR_COLOANE * i:self.NR_COLOANE * (i + 1)], jucator)

        for i in range(self.NR_COLOANE):
            # Verific daca am coloane deschise
            sum = sum + self.linie_deschisa(self.matr[i:self.NR_COLOANE * self.NR_COLOANE:self.NR_COLOANE], jucator)

        # Verific daca am diagonalele deschise
        sum = sum + self.linie_deschisa(self.matr[0:len(self.matr):self.NR_COLOANE + 1], jucator)
        sum = sum + self.linie_deschisa(self.matr[self.NR_COLOANE - 1:len(self.matr) - 2:self.NR_COLOANE - 1], jucator)
        return sum

    def estimeaza_scor(self, adancime):
        t_final = self.final()
        # if (adancime==0):
        if t_final == self.__class__.JMAX:
            return (99 + adancime)
        elif t_final == self.__class__.JMIN:
            return (-99 - adancime)
        elif t_final == 'remiza':
            return 0
        else:
            return (self.linii_deschise(self.__class__.JMAX) - self.linii_deschise(self.__class__.JMIN))

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
        stare_curenta = Stare(tabla_curenta, 'x', N.NR_COLOANE)

    timp_total = 0

    while True:
        if (stare_curenta.j_curent == Joc.JMIN):
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
                    else:
                        print("Linie sau coloana invalida..")


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