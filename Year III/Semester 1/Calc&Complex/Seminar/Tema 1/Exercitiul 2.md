## Exercitiul 2

- Ideea, complexitatea si tranzitiile pentru o MT care accepta wwRw peste alfabetul ```a,b, c```

## Metoda de rezolvare

Posibil input: ```aabbaaaab```

### Pasul 1 (Impartim cuvantul in 2 parti: w si wRw, verificand astfel daca lungimea lui este divizibila cu 3)
Cat timp exista caracterele ```a, b sau c```:

 - (1) Daca pe prima pozitie se afla caracterul ```X, Y sau Z```, trecem la **pasul 2**
 - (1) Daca pe prima pozitie se afla caracterul ```a, b sau c```,  il inlocuim cu (```X, Y sau Z```)
 - (2) Parcurgem spre dreapta toate simbolurile (```a, b sau c```) pana gasim B sau ```x, y, z```. Cand am ajuns la final, ne intoarcem cu o pozitie spre stanga
 - (2) Parcurgem 2 caractere ```a, b sau c``` spre stanga si le inlocuim cu ```x, y sau z```
 - (2) Parcurgem toate simbolurile (```a, b sau c```) spre stanga pana dam de ```B, X, Y sau Z```. Ne intoarcem cu o pozitie spre dreapta si repetam pasul 1.

```
aabbaaaab -> XXYyxxxxy
```

### Pasul 2 (verificam daca ultimele 2 cuvinte formeaza un palindrom)
Cat timp exista caracterele ```x, y sau z```
 - (1) Parcurgem sirul nostru spre dreapta cat timp gasim caracterele: ```X, Y sau Z```
 - (2) Daca in sirul nostru gasim ```0```, trecem la **pasul 3**.
 - (2) Daca in sirul nostru gasim ```x```, il notam cu ```0 ```  si parcurgem sirul nostru spre dreapta cat timp gasim caracterele ```x, y sau z```. La final ne intoarce cu un caracter spre stanga (Caractere posibile: ```X, Y, Z, B```). Daca pe pozitia curenta nu gasim ```x```, RESPINGEM.
 - (2) Daca in sirul nostru gasim ```y```, il notam cu ```0 ```  si parcurgem sirul nostru spre dreapta cat timp gasim caracterele ```x, y sau z```. La final ne intoarce cu un caracter spre stanga (Caractere posibile: ```X, Y, Z, B```). Daca pe pozitia curenta nu gasim ```y```, RESPINGEM.
 - (2) Daca in sirul nostru gasim ```z```, il notam cu ```0 ```  si parcurgem sirul nostru spre dreapta cat timp gasim caracterele ```x, y sau z```. La final ne intoarce cu un caracter spre stanga (Caractere posibile: ```X, Y, Z, B```). Daca pe pozitia curenta nu gasim ```z```, RESPINGEM.
 - Parcurgem sirul nostru spre stanga cat timp gasim caracterele ```x, y sau z```. Repetam pasul 2.

```
XXYyxxxxy -> XXY000XXY
```

### Pasul 3 (Verificam daca ce se afla in sirul de la final se afla si in sirul de la inceput)
Cat timp exista caracterele: ```X, Y sau Z```
 - (1) Parcurgem sirul nostru spre stanga, sarind peste caracterele: ```0, X, Y sau Z```. La final daca am gasit caracterul ```B```, sarim cu o pozitie spre dreapta.
 - (2) Daca in sirul nostru gasim ```0```, **ACCEPTAM** sirul.
 - (2) Daca in sirul nostru gasim ```X```, il notam cu ```B ```  si parcurgem sirul nostru spre dreapta cat timp gasim caracterele ```0, X, Y sau Z```. Parcurgem sirul nostru spre stanga cat timp gasim caracterele: ```X, Y sau Z```. La final ne intoarcem cu un caracter spre dreapta, sarind peste ```0```. Daca pe pozitia curenta nu gasim ```X```, **RESPINGEM**.
 - (2) Daca in sirul nostru gasim ```Y```, il notam cu ```B ```  si parcurgem sirul nostru spre dreapta cat timp gasim caracterele ```0, X, Y sau Z```. Parcurgem sirul nostru spre stanga cat timp gasim caracterele: ```X, Y sau Z```. La final ne intoarcem cu un caracter spre dreapta, sarind peste ```0```. Daca pe pozitia curenta nu gasim ```Y```, **RESPINGEM**.
 - (2) Daca in sirul nostru gasim ```Z```, il notam cu ```B ```  si parcurgem sirul nostru spre dreapta cat timp gasim caracterele ```0, X, Y sau Z```. Parcurgem sirul nostru spre stanga cat timp gasim caracterele: ```X, Y sau Z```. La final ne intoarcem cu un caracter spre dreapta, sarind peste ```0```. Daca pe pozitia curenta nu gasim ```Z```, **RESPINGEM**.
 - (3) Parcurgem sirul nostru spre stanga cat timp gasim caracterele: ```0, X, Y, Z```. Repetam pasul 3.

```
XXY000XXY -> BBB000000
```- Acceptam sirul

### Complexitate timp:

O(n^2)

### Complexitate spatiu:
O(n) - > nu folosim spatiu suplimentar



