# Instagram Analytics

<br>
<img src="https://github.com/DariusBuhai/FMI-Unibuc/blob/main/Licenta/Images/logo.png" width="30%">

## Rezumat
Creșterea numărului de like-uri primite în postările de Instagram, cât și analiza asupra urmăritorilor activi reprezintă niște ustensile destul de importante pentru orice influencer de success.

Pentru aceasta vom crea o aplicație mobilă ce va oferi predicții asupra numărului de like-uri pe care le poate primi o postare pe Instagram. Pentru o predicție cât mai reală voi antrena un model Secvențial cu ~200.000 de postări de Instagram extrase folosind api-ul oferit de Facebook și implementat în limbajul python.

Aplicația de mobil va fi realizată în Flutter și va oferi o interfață grafică pentru prezicerea aprecierilor în funcție de descriere, data, ora și imagine. De asemenea, vom extrage informații relevante din contul utilizatorului de Instagram, ce vor fi folosite în predicția noastră (număr de urmăritori și media like-urilor).

##  Abstract
As an influencer, growing the number of likes for your Instagram posts and analyzing the number of active followers for your page should be a priority, and using various tools for this can become very helpful.

For that, we will create a mobile app that will predict the number of likes that an Instagram post could receive. For the prediction to work, we will train a Sequential model on ~200.000 Instagram posts which will be extracted using the API offered by Facebook and implemented in python.

The mobile app will be created in Flutter and it will include a graphic interface for predicting the number of likes based on a given description, date-time, and image. Also, we will retrieve relevant insights from the user’s Instagram profile which will be needed for our prediction (followers and mean likes).

## Motivație
Analiza audienței și a preferințelor oamenilor pe internet a fost dintotdeauna un subiect de interes pentru mine. Astfel prin această lucrare mă voi axa pe predicția aprecierilor postărilor de instagram în funcție de caracteristicile cele mai importante (câte persoane apar în imagine, descrierea pusă, ora și ziua în care e postată).

Deoarece pentru orice predicție bună avem nevoie de un set de date cât mai mare, voi folosi postări reale extrase folosind api-ul oferit de Facebook și implementat în Python, de la top 300 cei mai urmăriți influenceri.

## Domenii abordate
Această lucrare va include următoarele 3 domenii principale:
 - Inteligența Artificială, folosită pentru realizarea modelelor de tip regression, antrenarea lor și analiza metricilor.
 - Natural Language Processing, folosit pentru a extrage caracteristicile din descrierile postărilor.
 - Aplicații Mobile, realizând o aplicație mobilă în Flutter [4] ce rulează atât pe iOS cât și pe Android.

## Structura lucrării
Lucrarea de licență este impărțită în 2 capitole principale:
 - Predicția like-urilor: Include extragerea dataset-ului, preprocesarea, analiza datelor, extragerea caracteristicilor, definirea modelului și antrenarea sa.
 - Aplicația mobilă: Descrierea procesul de creare a aplicației mobile și a backend- ului ce oferă o interfață vizuală pentru modelul definit.

### Predicția like-urilor
Pentru a realiza o predicție reală asupra numărului de like-uri ce pot fi obținute de o postare, vom aduna cât mai multe postări de la top 300 influenceri și vom antrena un model Secvențial pe diversele caracteristici ce alcătuiesc o postare de success (cuvintele folosite în descriere, numărul de persoane din imagine, numărul de zâmbete din imagine, ziua în care care a fost postată, etc.).

### Aplicația mobilă
Aplicația mobilă va fi realizată în Flutter și va include 3 pagini principale:
1. Pagina de prezicere a numărului de like-uri, aici utilizatorul poate încărca imaginea, ziua și ora la care dorește să o posteze cât și descrierea. Folosind modelul antrenat anterior, utilizatorul va primi o predicție asupra numărului de like-uri raportat la numărul de followeri pe care îi are.
2. Pagina de asociere cu contul de Instagram. Aici utilizatorul își va completa username-ul de instagram și va primii analize asupra numărului de urmăritori și media like-urilor postărilor. Aceste metrici vor fi utilizate automat în predicția postărilor.
3. Pagina de setări, unde utilizatorul își va putea administra contul și setările apli- cației.

<br>
<img src="https://github.com/DariusBuhai/FMI-Unibuc/blob/main/Licenta/Images/preview.png">

### Frontend:
[DariusBuhai/InstagramAnalytics-Flutter](https://github.com/DariusBuhai/InstagramAnalytics-Flutter)


### Backend:
[DariusBuhai/InstagramLikesPrediction](https://github.com/DariusBuhai/InstagramLikesPrediction)
