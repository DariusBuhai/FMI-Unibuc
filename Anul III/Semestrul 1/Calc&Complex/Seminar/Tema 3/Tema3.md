# Tema 3
- Verificati ca un numar e prim cu o banda si cu mai multe benzi
- Calculati complexitatea

*Solutia trebuie sa descrie cum functioneaza masina Turing folosind
pasi de maxim O(Lungime benzii)*

## Folosind mai multe benzi

In acest caz putem folosi prima banda (B1) pentru a marca numarul nostru insi a doua banda (B2) pentru a-l imparti la numere de la 2 la el insusi.

- Daca numarul nostru este mai mic decat 1, respingem.
- Daca numarul nostru este 2, acceptam
- Setam valorile lui B2 de la 2 la valoarea primita - 1.
- Daca prin impartirea lui B1 la B2 primim restul 0, atunci numarul primit nu este prim.

### Initializare
- B1: ```numarul nostru```
- B2: ```11BBBBB```

### Pasi: 
- Pasul 1 (Verificam daca numarul nostru este > 1)

Pe B1 inlocuim 1 cu 1 si ne ducem la dreapta. B2 stationeaza. Trecem la Pasul 2.

Daca pe B1 gasim blank, **respingem**. B2 stationeaza.

- Pasul 2 (Verificam daca numarul nostru este 2)

Pe B1 inlocuim 1 cu 1 si ne ducem la dreapta B2 stationeaza.

Daca pe B1 gasim blank, acceptam.
Altfel, trecem la Pasul 3.

- Pasul 3 (Resetam B1)

Cat timp gasim 1 pe B1, ne ducem la stanga. B2 stationeaza

Cand gasim Blank, ne ducem la dreapta si trecem la Pasul 4

- Pasul 4 (Verificam daca benzile au valori egale)

Cat timp gasim 1 pe B1 si 1 pe B2, le parcurgem spre dreapta in acelasi timp.

Daca pe B1 gasim 1 si pe B2 gasim Blank, parcurgem B1 si B2 spre stanga pana gasim Blank. Trecem la Pasul 5.

Daca pe B1 gasim Blank si pe B2 gasim Blank, **acceptam**.

- Pasul 5 (Verificam daca B2 divide B1)

Daca pe B1 si B2 gasim 1, ne mutam pe ambele la dreapta, neschimband nimic.


Daca pe B1 gasim Blank iar pe B2 gasim 1, trecem la Pasul 6.

Daca pe B1 gasim 1 iar pe B2 gasim Blank, parcurgem B2 spre stanga pana gasim Blank, timp in care B1 ramane stationat.

Daca pe B1 si B2 gasim Blank, **respingem**.

- Pasul 6 (Incrementam B2)

Parcurgem B2 spre dreapta pana gasim Blank. B1 ramane stationat.

Cand am gasit Blank, il transformam in 1 si trecem la Pasul 7

- Pasul 7 (Resetam pozitiile B1 si B2)

Parcurgem B1 cat timp gasim 1 spre stanga.

In acelasi timp, parcurgem B2 cat timp gasim 1 spre stanga.

Cand ambele benzi sunt la inceput, ne mutam pe ambele spre dreapta si trecem la pasul 4.
 

### Complexitate:

```O(input^2)```

## Folosing o singura banda

Similar, cu o singura banda vom scrie cele 2 benzi (B1 si B2) pe o singura banda, separate prin ```0```. 

Aplicam algoritmul descris mai sus (pentru 2 benzi), doar ca de data aceasta vom avea o complexitate ```O(input^3)```.