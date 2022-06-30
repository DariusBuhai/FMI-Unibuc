# Racism Analysis

## NATURALLANGUAGEPROCESSING

### 1. ALEGEREA DATASETULUI

Pentru alegerea datasetului am optat pentru datasetul tweets_hate_speech_detection oferit de
Hugging Face. Acest dataset contine 31,962 de tweet-uri colectate folosind API-ul de la Tweeter si
clasificate in tweet-uri rasiste si non-rasiste.

Fiecare intrare din dataset este formata din 3 campuri:

1. id-ul tweet-ului
2. label-ul tweet-ului (0 = neutru, 1 = rasist)
3. textul tweet-ului

### 2. ARTICOLE ASOCIATE

Pentru a înt,elege mai bine contextul studiului discursului rasist, am analizat un set de articole
s,tiint,ifice care au la baz ̆a aceeas,i tematic ̆a.

De aceea, am ales paper-ul „Whose opinions matter? Perspective-aware models to identify
opinions of hate speech victims in abusive language detection” [ 1 ] scris de Sohail Akhtar, Vale-
rio Basiles,i Viviana Patti. Acesta prezint ̆a un studiu bazat pe faptul c ̆a unele caracteristici ale
diferitelor comunit ̆at,i influent,eaz ̆a opiniile acestora, iar, de aceea, în analiza tipurilor de hate
speech, trebuie luate în calcul mai multe criterii. Se folosesc de un data set adnotat de persoane
care fac parte din comunit ̆at,ile cele mai afectate de hate speech, ar ̆atând astfel cum predicit,iile
f ̆acute cu aceste informat,ii sunt mai bune decât cele produse prin alte metode.

De asemenea, un alt articol care a contribuit la formarea unei imagini despre tema aleas ̆a a
fost „A survey of Race, Racism, and Anti-Racism in NLP” [ 2 ] scris de Anjalie Field, Su Lin
Blodgett, Zeerak Waseems,i Yulia Tsvetkov. Acesta prezint ̆a ideea c ̆a, studiul limbajelor naturale
de procesare este influent,at de caracteristica rasei, dar acest fapt este ignorat în multe lucr ̆ari de
specialitate. De asemenea, articolul subliniaz ̆a ideea c ̆a research-ul pentru NLP ar trebui s ̆a fie
mai inclusiv în practicile sale.

Un al treilea articol ales de noi a fost „Racism Detection by Analyzing Differential Opinions
Through Sentiment Analysis of Tweets Using Stacked Ensemble GCR-NN Model” [ 3 ] scris de
Ernesto Lee, Furqan Rustam, Patrick Bernard Washington, Fatima El Barakaz, Wajdi Aljedaanis,i
Imran Ashraf. Acest paper îs,i propune prezentarea unui model de deep learning care detecteaz ̆a
tweet-uri rasiste prin intermediul sentiment analysis. Modelul ales combina gated recurrent unit
(GRU), convolutional neural networks (CNN)s,i recurrent neural networks RNN, cu o detect,ie de
97%.

### 3. PREPROCESAREA DATELOR

De cele mai multe ori cont,inutul reg ̆asit pe internet, din partea utilizatorilor, nu este într-o form ̆a
optim ̆a pentru a fi procesats,i a se aplica metode de înv ̆at,are. Devine important ̆a normalizarea
textului prin aplicarea unei serii de pas,i de preprocesare. Am aplicat un set de pas,i de preproce-
sare pentru a-l face potrivit pentru algoritmii de înv ̆at,ares,i pentru a reduce dimensiunea setului
de caracteristici.

Din punctul de vedere al clasific ̆arii unui text, cele mai importante aspecte ale preproces ̆arii
necesare setului de date ales implic ̆a:


- **Eliminarea userului:** Fiecare utilizator Twitter are un nume de utilizator unic. Orice lucru
    îndreptat c ̆atre acel utilizator poate fi indicat scriind numele de utilizator precedat de „@”,
    care nu furnizeaz ̆a nicio informat,ie util ̆a, fiind un nume propriu.
- **Eliminarea link-urilor:** Utilizatorii partajeaz ̆a adesea hyperlinkuri în tweet-urile lor. Twit-
    ter le scurteaz ̆a (folosind serviciul s ̆au intern de scurtare a adreselor URL), cum ar fi
    [http://t.co/FCWXoUd8.](http://t.co/FCWXoUd8.)
- **Eliminarea punctuat,iilor, numerelors,i a caracterelor speciale:** Utilizatorii folosesc punctuat,iile,
    numereles,i caractere speciale într-un mod abuziv, intent,ionat sau accidental, iar acestea nu
    reflect ̆a nicio stare sau sentiments,i elimiarea acestora este necesar ̆a pentru a avea un text
    cât mai curat.
- **Eliminarea cuvintelor scurte:** Termenii precum „hmm”, „oh” sunt foarte put,in folositoris,i
    nu au niciun sens sau rol specific în text.
- **Modificarea literelor mari în litere mici:** Ajut ̆a la ment,inerea fluxului de consistent, ̆as,i
    extragerii de text.
- **Eliminarea caracterelor repetitive:** În limbajul de zi cu zi, oamenii de multe ori nu sunt
    strict gramaticali. Vor scrie lucruri precum „I looooooove it", pentru a sublinia cuvântul
    dragoste. Cu toate acestea, computerele nus,tiu c ̆a „looooooove” este o variat,ie a „iubirii”
    decât dac ̆a li se spune.
- **Modificarea literelor mari în litere mici:** Cuvinte precum „Carte"s,i „carte" înseamn ̆a
    acelas,i lucru, dar atunci când nu sunt convertite în litere mici, cele dou ̆a sunt reprezentate
    ca dou ̆a cuvinte diferite în modelul spat,iului vectorial
- **Eliminarea simbolului # din hashtag-uri:** Simbolul nu ofer ̆a niciun sens util textului în
    analiza sentimentelor, fiind folosit pe ret,elele de socializare, ca o indicat,ie c ̆a o bucat ̆a de
    cont,inut se refer ̆a la un anumit subiect sau apart,ine unei categorii.
- **Eliminarea spat,iilor multiple:** De cele mai multe ori, textele cont,in spat,ii suplimentare sau
    în timpul efectu ̆arii tehnicilor de preprocesare de mai sus, r ̆amâne mai mult de un spat,iu
    intre cuvinte.
- **Stemming:** Exist ̆a multe variante de cuvinte care nu aduc informat,ii nois,i creeaz ̆a redundant, ̆a,
    aducând în cele din urm ̆a ambiguitate atunci când antren ̆am modele de înv ̆at,are automat ̆a
    pentru predict,ii.

### 4. EXTRAGEREA FEATURE-URILOR

Pentru analizarea datelor preprocesate, este nevoie ca acestea s ̆a fie convertite în feature-uri. De-
pinzând de metoda în care urmeaz ̆a s ̆a fie folosite, feature-urile de text pot fi construite folosind
diferite tehnologii. Noi am ales s ̆a transform ̆am datele în reprezent ̆ari numerice vectoriale.

Pentru a putea efectua aceast ̆a operat,ie, avem nevoie s ̆a elimin ̆am toate semnele de punctuat,ie
s,i apoi s ̆a calcul ̆am frecventa cuvintelor. Cu ajutorul acestora putem s ̆a cre ̆am un vocabular cu
anumite caracteristici specifice, prin intermediul funct,iei createVocab.

Vom folosi funct,ia createVectorize pentru a atribui fiec ̆arui caracter din vocabularul creat un
index. Lu ̆am în calcul posibilitatea ca unele carcatere s ̆a nu fie cunoscute s,i, de aceea, lor le vom
atribui indexul 0. În cadrul funct,iei createVectorize, dup ̆a ce efectu ̆am vectorizarea, vom apela
funct,iile vectorizeSenteces s,i pad.

Funct,ia vectorizeSentences este utilizat ̆a pentru a transforma propozit,iile într-o reprezentare
vectorial ̆a. Aceasta ia fiecare tweets,i îl transform ̆a în reprezentarea lui sub form ̆a de indici
specifici caracterelor cont,inute. Apoi, fiec ̆arui indice îi facem reprezentarea one-hot.

Din cauza faptului c ̆a tweet-urile folosite sunt de dimensiuni diferite, este necesar ̆a aducerea
acestora la aceeas,i lungime maxim ̆a. Pentru aceasta folosim funct,ia pad, care primes,te un set de
tweet-uris,i o lungime maxim ̆a. Aceasta are ca scop fie scurtarea datelor care dep ̆as,esc lungimea

### 2


maxim ̆a, fie ad ̆agarea valorii de padding (aleas ̆a de noi ca fiind 1) la datele care sunt mai scurte
dectât lungimea maxim ̆a.

La finalul tuturor acestor pas,i putem extrage feature-urile care urmeaz ̆a s ̆a fie folosite pentru
antrenarea modelului.

### 5. CLASIFICARE

**A. Model folosit**

Pentru clasificarea datelor, am folosit un model CNN cu un dropout (p=0.4), 2 layere convo-
lutionale de size x 128 si 128 x 128, un average pooling 1D si un layer liniar de 128 x 2 pentru
output.
Am folosit functia Adam pentru optimizarea modelului cu learning_rate = 0.001 si CrossEn-
tropyLoss.

**B. Dataset**

Datasetul a fost impartit in 3 dataframe-uri (train 80%, test 10% si validation 10%), fiecare
dataframe fiind stocat in batch-uri de cate 64, randomizate.

**C. Evaluare modelului**
Datorita setului de date neechilibrat (doar 8 % din tweet-uri sunt rasiste), am evaluat acuratetea
ca media dintre acuratetile tweet-urilor rasiste si non-rasiste.

**D. Antrenarea modelului**

Pentru a antrena modelul, am rulat de 40 ori cate 100 de epoci, salvand mereu modelul cel mai
bine evaluat. Astfel, dupa finalizarea unui set de 100 de epoci, incarcam cel mai bun model si il
rulam din nou pe cate 100 de epoci, pentru a se evita overfitting-ul.

**E. Rezultate**

In final, in urma a 3 rulari a cate 100 de epoci (salvand mereu cel mai bun model), am putut obtine
o acuratete maxima de 83.5% (True labels: 84.3%, False labels: 82.8%)

### REFERENCES

1. S. Akhtar, V. Basile, and V. Patti, “Whose opinions matter? perspective-aware models to
    identify opinions of hate speech victims in abusive language detection,” arXiv preprint
    arXiv:2106.15896 (2021).
2. A. Field, S. L. Blodgett, Z. Waseem, and Y. Tsvetkov, “A survey of race, racism, and anti-
    racism in nlp,” arXiv preprint arXiv:2106.11410 (2021).
3. E. Lee, F. Rustam, P. B. Washington, F. E. Barakaz, W. Aljedaani, and I. Ashraf, “Racism
    detection by analyzing differential opinions through sentiment analysis of tweets using
    stacked ensemble gcr-nn model,” IEEE Access **10** , 9717–9728 (2022).



