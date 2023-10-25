
#### Nume: Buhai Darius
#### Grupă: 334
#### Subiecte netratate: -

## Exercițiul 1

**(a)**:
**Fals** - Decriptarea, folosind OTP, a textului criptat 0x253505ba folosind cheia 0x717056ee este mesajul clar <ins>TEST</ins>.

**(b)**:
**Adevărat**

**(c)**:
**Adevărat**

**(d)**:
**Fals** - Un PRP presupune ca pentru fiecare intrare, iesirea sa contina exact bitii de intrare, permutați <ins>pseudoaleatoar</ins> (ex. pentru o cheie fixata K si PRPK : {0,1}<sup>4</sup> → {0,1} <sup>4</sup>, PRPK(1101) = 1011 poate fi o atribuire corecta dar PRPK(1101) = 0101 este întotdeauna o atribuire incorectă).


**(e)**:
**Fals** - Este recomandat să se folosească RSA pentru transmiterea <ins>cheilor</ins> în mod criptat.

**(f)**:
**Fals** - Pentru a asigura integritatea unor fisiere personale, este suficient sa stocați pe calculatorul propriu fișierele <ins>semnate digital</ins> și valoarea SHA256 corespunzătoare fiecăruia sub forma (file1,SHA256(file1)), (file2,SHA256(file2)). . . . .

**(g)**:
**Fals** - SHA256(PAROLA) = <ins>0x467b4a3eca61a4e6 2447400d93fc35d4 295c08ffa2b04ae9 42f4de03fa62f464</ins>

**(h)**:
**Adevărat** - Deși problema reală este Diffie-Hellman ce poate fi rezolvată foarte ușor dacă putem rezolva Problema Logaritmului Discret.

**(i)**:
**Adevărat** 

**(j)**:
**Adevărat**

## Exercițiul 2

**(a)**:
Principiul **Principle of (key) separation** este satisfacut deoarece site-ul foloseste protocolul TLS cu 2 chei pentru integritate și 2 pentru confidențialitate.

**(b)**:
**Principle of the weakest link** nu este satisfacut deoarece câmpurile de introducere a datelor nu sunt sanitizate, iar utilizatorii pot plasa comenzi cu prețuri modificate de ei (prețuri negative chiar). Nesanitizarea câmpurilor poate fi cel mai slab punct al website-ului prin care un posibil atacator accesa vulnerabilitățile site-ului (Ex: Comenzi cu prețuri modificate sau chiar și sql-inject).

**(c)**:
#### Confidențialitate:
 - Conexiunea dintre client și server este confidențială deoarece foloseste TLS.
 - Fișierele stocate local nu sunt confidențiale, deoarece algoritmul AES-ECB poate fi foarte ușor spart.

#### Integritate
 - Integritatea aplicației este verificată prin protocolul TLS ce stabilește conexiunea dintre client și server.
 - Conturile utilizatorilor nu sunt integre, deoarece parolele lor pot fi schimbate foarte ușor de un atacator (descris la următorul subpunct) și utilizatorii pot fi impersonați.

**(d)**:
Un atacator poate genera un link de **resetare a parolei** folosind username-ul, ziua curentă și funcția PRNG cunoscută (folosită de aplicație) pentru a schimba parola unui utilizator și pentru a se autentifica. Astfel un atacator poate **impersona** orice utilizator ce are cont pe platformă.

## Exercițiul 3
**(a)**: Funcția verif() este definită astfel:
 - Input: **σ (semnatura)**, **pk = (N, e) și m (mesajul inițial)** 
 - Calculăm **m'' = σ<sup>e</sup> (mod N)**
 - Calculăm **m' = 0<sup>8</sup> || 0<sup>7</sup>1 || FF<sup>x</sup> || 0<sup>8</sup> || m**,
 - Verificam dacă **m'' = m'**
 - Output: **Adevărat sau Fals** în funcție de verificarea anterioară

**(b)**: Da, deoarece:

 - Fie **m<sub>1</sub> = 2m și σ<sub>1</sub> = 2<sup>d</sup>σ**
 - Știm că **m'' = m'** (semnătura σ este validă)
 - Știm că **d*e = 1**
 - **m<sub>1</sub>'' = 2<sup>de</sup>σ<sup>e</sup><sub>1</sub> (mod N) = 2σ<sup>e</sup> (mod N) = 2m''**
 - **m<sub>1</sub>' = 0<sup>8</sup> || 0<sup>7</sup>1 || FF<sup>x</sup> || 0<sup>8</sup> || 2m<sub>1</sub> = 2m'**
 - Prin urmare, **2m'' = 2m'** (Adevărat)


**(c)**: Observăm ca mesajul nostru m<sup>-</sup> poate fi alterat astfel:
 - La mesajul m<sup>-</sup> se pot adăuga multiplii de N, astfel încât mesajul m să rămână la fel.
 - **m = lsb<sub>|N|/2-1</sub> (m<sup>-</sup> mod N) = lsb<sub>|N|/2-1</sub> (m<sup>-</sup> + <ins>x*N</ins> mod N)**, unde x este mesajul inserat de un atacator

**(d)**: Pentru a preveni această inserție vom împărți m<sup>-</sup> în grupuri de câte |N|/2-1 biți (m<sup>-</sup> = m<sup>-</sup><sub>1</sub> || m<sup>-</sup><sub>2</sub> ... || m<sup>-</sup><sub>|N|/2-1 </sub> ) și le vom concatena valorile mod 1 în m.
 - **Pasul 0.** m<sup>-</sup> se transformă în 0 < |m| < |N|/2 astfel: m = (m<sup>-</sup><sub>1</sub> mod 1) || (m<sup>-</sup><sub>2</sub> mod 1) || ... || (m<sup>-</sup><sub>|N|/2-1</sub> mod 1), unde m<sup>-</sup><sub>i</sub> este împărțirea lui m<sup>-</sup> în |N|/2-1 grupuri de *biți*.

*Notă: m<sup>-</sup> = noul nostru mesaj - cel din cerință.*



<br>

## Exercițiul 4
MAC-ul dat nu este sigur, deoarece valoarea lui **m AND NOT(m)** va fi intotdeauna **= 0**, iar functia **MAC** va returna mereu acelasi raspuns (mesajul primit in cele 2 functii este mereu la fel, egal cu 0).

```
Mac'(k, m) = Mac(k, m AND NOT(m)) = Mac(k, 0)
Vrfy'(k, m, t) = Vrfy(k, m AND NOT(m), t) = Vrfy(k, 0, t)
```