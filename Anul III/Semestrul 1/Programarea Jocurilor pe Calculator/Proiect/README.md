# Doomixel

## Membrii Echipă:
 - [Darius Buhai](https://github.com/DariusBuhai)
 - [Silviu Stăncioiu](https://github.com/SilviuShader)
 - [Dabu Alexandru](https://github.com/DabuAlexandru)
 - [Ana Maria Ungureanu](https://github.com/anayep)
 - [Stefan Gradinaru](https://github.com/svk-svk)

## Cerințe proiect:

- Proiect în echipe de aproximativ 5-6 oameni.
- Task - conceperea si implementarea unui joc demonstrativ de orice natură dar care să poată rula pe PC sub Windows 10 sau cele mai recente variante de Ubuntu sau MacOS.
Game Engine folosit: Unity (latest edition)
- Version control folosit: GitLab/GitHub - după preferințe
- Obiective: În primul rând să fie un proiect la care participă toți membri echipei pe un rol sau altul; Jocul rezultat să fie playable și ”awesome”. Preferabil să puncteze cât mai multe dintre elementele discutate la curs.

## Descriere joc
### Ideea de baza a proiectului
Doomixel este un joc first-person shooter, de tip pseudo-3D, asemenea primelor jocuri din seria Doom și Wolfenstein. 

### Înainte să începi jocul
Jucătorul este întâmpinat de un meniu de început care prezintă mai multe opțiuni.
* **Play**: Opțiunea care va trimite jucătorul în scenă pentru a putea parcurge jocul
* **Leaderboard**: Jucătorul își poate vizualiza progresul dintre runde în secțiunea de Leaderboard. Aici va putea vedea scorul acumulat, în ordine, de la prima rundă jucată, până la ultima. Deasupra va apărea highscore-ul, unde va putea vedea care este scorul maxim obținut. Informațiile despre sesiunile anterioare vor fi salvate într-un fișier local.
* **Options**: Jucătorul va fi întâmpinat de un submeniu de unde va putea să seteze dificultatea dorită (între easy, medium și hard) și volumul jocului
* **Quit**: Jucătorul poate să părăsească jocul

### În timpul jocului
Jucătorul este întâmpinat de melodia de fundal a jocului în momentul în care va începe o nouă sesiune. Acesta poate să dea pauză jocului folosind tasta Escape, fiind astfel întâmpinat de meniul de pauză. Prezența acestui meniu face ca scena să se opreasă și îi oferă jucătorului opțiunea să se întoarcă în sesiune sau să termine sesiunea actuală și să se întoarcă în meniul principal, salvând astfel și scorul sesiunii în leaderboard.

### Generare procedurala a camerelor
Camerele sunt generate procedural, iar în fiecare moment din joc vor exista numai două-trei camere, în funcție de caz. În momentul în care ieși dintr-o cameră, ușa se va închide, iar camera va fi distrusă, iar în contrast, când vei intra în noua cameră, de partea ușii celeilalte se va genera următoarea cameră. În ceea ce privește varietatea, ușile din cameră au o stilizare random, aleasă dintr-un set de imagini. 

### Game flow
În fiecare cameră vor fi cate 5 inamici, care se spawneaza cu o probabilitate p între 4 tipuri. În momentul în care toți inamicii sunt doborâți, ușa către următoarea cameră se va deschide, permițând player-ului să treacă în stadiul următor. Playerul are doar 5 vieți, care nu se regenerează, deci, pe parcursul jocului de tip arcade endless, o viață pierdută nu va putea fi recuperată. În momentul în care player-ul va pierde o viață, va intra într-o perioadă de invincibilitate de câteva secunde, care va fi marcată prin flicker-ul armei. Odată ce jucatorul pierde toate cele 5 viețile, jocul se va termina, iar ecranul de end game o să apară, permițând începerea unui joc nou, sau întoarcerea în meniul principal.

### Opțiunile de dificultate
Referitor la game flow, prin alegerea unei dificultăți mai avansate se vor întâmpla următoarele: Inamicii vor avea mai multă viață, vor ataca mai des, iar player-ul va primi mai puține gloanțe și va trage la intervale mai mari de timp.

### Tipurile de inamici
Jocul prezintă 4 tipuri de inamici: 2 de tip uman, care atacă de la apropiere, și 2 de alt tip (monstru/turetă), care atacă de la distanță, folosind gloanțe specifice lor. Fiecare dintre inamici are câte o particularizare care îl face unic:
* **Male Human**: Acesta este un inamic care atacă de la apropiere, astfel că va încerca să se apropie de player pentru a îl putea răni.
* **Female Human**: Acesta este un inamic asemănător celui precedent, însă cu o viteză și o rază de atac mai mari.
* **Turret**: Acest inamic este unul staționar care trage cu gloanțe în player. Datorită faptului că nu se poate mișca, raza lui de atac este foarte mare, atacând cu gloanțe în momentul în care detectează player-ul.
* **FlyingMonster**: Acest inamic este asemănător celui precedent, însă ce îl face special este că se poate mișca, având și acesta o rază de vizibilitate foarte mare. Dintre toți inamicii, acesta este cel mai special, deoarece, în funcție de direcția în care se mișcă, își va schimba înfățișarea pentru a arăta acest lucru (vom putea vedea monstrul din mai multe unghiuri: laterale, față - spate).

### Detalii tehnice inamici
Inamicii din joc au 3 state-uri:
* **Wander:** Inamicul se plimba prin scenă, în funcție de niste waypoint-uri prestabilite în momentul în care a fost creat. 
* **Engage/Follow:** În momentul în care inamicul va zări player-ul, va intra în state-ul de engage. Acesta va încerca să se apropie suficient de player încât să îl poată ataca (în cazul turetei, raza de engage și de atac coincid, deoarece este o unitate staționară).
* **Attack:** Odată ce player-ul este în raza de atac, inamicul va încerca să îl rănească, fie fizic, fie de la distanță, folosind niște bile de energie roșii. Fiecare inamic, indiferent de tip, are un cooldown pentru atacuri, astfel că în intervalul în care nu atacă, player-ul nu va fi rănit de ei.

Logica și comportamentul inamicilor sunt realizate folosind două elemente cheie: nav mesh și raycasting.
* Nav mesh: 
> inamicii au fiecare caracteristicile lor, dar în principal există inamici de tip Human și inamici de tip Monster. Human sunt Nav Mesh Agents care ocupă puțin spațiu și se mișcă repede. Monster sunt Nav Mesh Agents care ocupă mult spațiu, iar logica lor ține mai mult de state, nu de stopping distance sau alte caracteristici ale agentului.

> în ceea ce privește nav mesh surface-ul. Odată ce o cameră este generată, asupra ei va fi aplicat un nav mesh, care va avea câte o suprafață diferită pentru fiecare tip de agent (human/monster). După ce suprafața s-a generat, nav mesh agentul va fi și el activat, astfel încât să se poată folosi de nav mesh pentru a se putea orienta prin scenă.

* Raycasting:
> Fiecare inamic are un fascicul de raze pe care îl proiectează în direcția în care privește. Dacă player-ul intersetează aceste raze la o anumită distanță, state-ul lui va fi schimbat în cel de Engage.

### Diferite tipuri de muniție
> Jucătorul va avea la început un tip de glonț pellet, care reprezintă muniția default, fiind cel mai slab tip de muniție, însă care este infinită. Mai există și alte tipuri de gloanțe, astfel că unele gloanțe sunt efective asupra unor anumite tipuri de inamici (dintre cele 4 menționate mai sus), sau au un efect de slow asupra oricărui inamic, sau dau în general foarte mult damage, comparativ. În momentul în care distrugi un inamic vei primi un număr variabil de gloanțe, de un tip random (dintre cele 7 posibile).

### UI
Jucătorul are în baza ecranului două elemente:
* Meniul de selecție a muniției:
> Este o bandă cu mai multe chenare unde sunt prezente gloanțele pe care le primește jucătorul prin doborârea inamicilor. Acesta poate să dea scroll printre ele pentru a selecta un alt tip de muniție, sau prin a apăsa tasta corespunzătoare poziției chenarului (1-6). Fiecare tip de glonț are asociat în acest chenar și canitatea de muniție, astfel încât jucătorul să fie conștient de ce i-a rămas.
* Jucătorul în sine:
> Jucătorul este reprezentat printr-un frame format dintr-un pistol ținut de două mâini. Acesta se mișcă în stânga și in dreapta, pe o traiectorie parabolică, și rămâne fixat pe mijloc în timp ce trage. Atunci când jucătorul e ranit, acest frame începe un eveniment de flicker pentru a marca faptul că a fost rănit și că pentru moment este invincibil.

