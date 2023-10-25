# Software Engineer

 - Notare: ```100%``` project based
 - Project Repository: [Smart Energy](https://github.com/SoftwareEngineerUB/SmartEnergy)

## Planul semestrului
 
 - **S1**: prezentarea motivației cursului, a obiectivelor cursului, și a metodelor de evaluare. 
   - [x] Temă – veți forma o echipă de 4-6 personae și veți complete un formular pe care îl voi posta pe Teams
 - **S2**: prezentarea documentației de analiză – strategii de planificare a aplicației. 
   - [x] Temă – inițierea documentului de analiză
 - **S3**: feedback documentația de analiză – strategii de planificare a lucrului în echipă
 - **S4 -> S14**
   - Feedback aplicație, dezvoltare Q&A
   - Diferite prezentări în funcție de nevoile echipelor (folosirea OpenAPI, AsyncAPI, principii de testare, documentarea pentru utilizator, etc.)

## Proiect

 - Fiecare echipă (de 4 – 6 studenți) va avea ca obiectiv să creeze un program relativ simplu, dar documentat, și testat.
 - Colecția de aplicații dezvoltate de echipele voastre în acest semestru vor contribui la construirea unui dataset de programe mock IoT.
 - Ce este un program IoT?
   - Internet of Things este o rețea de obiecte fizice („things”) care dispun de senzori, software și alte tehnologii pentru a le interconecta, și a schimba informații cu alte dispozitive, sau cu internetul.
   - Nu va trebui să integrați dispozitive hardware.

## Specificatii Program
 - Programul pe care voi îl dezvoltați ar trebui să fie „creierul” unui device smart.
 - Va prelua date „din mediul inconjurător” – informații despre lumină, temperatură, perioadă a anului, oră, umiditate ș.a.m.d.
 - Va prelua date date/setate de utilizator – setări, sau date transmise de utilizator / de un hub central teoretic
 - Va transmite starea în care dispozitivul se află, diferitele operațiuni pe care dispozitivul le face
 - Programul trebuie scris în C++ / Java / Python / Golang
 - Puteți folosi orice librărie de C++/Java/Python/Golang, orice compilator, orice IDE.
 - Programul va trebui să comunice folosind două protocoluri: HTTP și MQTT.

## Evaluare
 - Nota finală va fi data de două elemente: 
   - 1 punct din oficiu
   - 9 puncte -> programul realizat
 - Programul trebuie să respecte următoarele cerințe (2.5p):
   - [x] Expune un Rest API HTTP – documentat folosind Open API (Swagger)
   - [x] Expune un API MQTT – documentat folosind AsyncAPI
   - [x] Aplicația să aibă minim 5 funcționalități – puteți să vă gândiți la ele ca sell points ale aplicației. Depinde de aplicația pe care v-ați propus să o faceți, dar chestii de genul o funcționalitate e scăderea, o altă funcționalitate e adunarea, nu înseamnă chiar că sunt diferite
   - [x] Tot ce faceți să se găsească într-un singur repo.
 - Pentru puncte programul trebuie să respecte următoarele cerințe:
   - [ ] Toate funcționalitățile și/sau toate endpoints au unit teste asociate. +1.5p
   - [x] Documentația de analiză este up to date + 1p
   - [ ] Documentația de utilizare reflectă aplicația reală + 1p
   - [x] Să prelucreze date reale (fie că accesează un alt api pentrua prelua date, fie că descărcați un set de date pe care îl dați apoi aplicației) + 1p
   - [x] Utilizarea unui tool de testare automată (gen RESTler) pentru a identifica buguri. +1.5p
   - [ ] Integration tests +1p
   - [ ] Coverage al testelor de 80% + 0.5p


