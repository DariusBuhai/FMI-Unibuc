# Capitolul 2 - Application Layer

## Cuprins
- [Introducere](#intro)
- [Domain Name System](#dns)
- [HTTP/S requests](#https)
  - [DNS over HTTPS](#doh)
  - [Exerciții HTTP](#exercitii_http)
- [Socket API](#socket)
- [UDP](#udp)
  - [Exerciții socket UDP](#exercitii_udp)
- [TCP](#tcp)
  - [Exerciții socket TCP](#exercitii_tcp)
  - [TCP 3-way handshake](#shake)

<a name="intro"></a> 
## Introducere

În cadrul acestui capitol folosim orchestratia de containere definită [aici](https://github.com/senisioi/computer-networks/blob/2021/capitolul2/docker-compose.yml). Pentru a rula această orchestrație, este suficient să executăm:
```bash
cd computer-networks/capitolul2
docker network prune
docker-compose up -d
```

<a name="dns"></a> 
## [Domain Name System](https://dnsmonitor.com/dns-tutorial-1-the-basics/)

Folosim DNS pentru a afla IP-urile corespunzătoare numelor. În general numele sunt ([Fully Qualified Domain Names](https://kb.iu.edu/d/aiuv)) salvate cu [un punct în plus la sfârșit](https://stackexchange.github.io/dnscontrol/why-the-dot).

- [DNS și DNS over HTTPS cartoon](https://hacks.mozilla.org/2018/05/a-cartoon-intro-to-dns-over-https/). 
- [DNS server types](https://www.cloudflare.com/learning/dns/dns-server-types/)
- [DNSSEC](https://www.cloudflare.com/dns/dnssec/how-dnssec-works/)


În linux și macOS există aplicația `dig` cu care putem interoga entries de DNS. Puteți rula aceleași exemple dintr-un container docker `docker-compose exec rt1 bash`. 
```bash
#1. cele 12 root servers de DNS:
dig 
;; ANSWER SECTION:
.     18942 IN  NS  m.root-servers.net.
.     18942 IN  NS  a.root-servers.net.
.     18942 IN  NS  b.root-servers.net.
.     18942 IN  NS  c.root-servers.net.
.     18942 IN  NS  d.root-servers.net.
.     18942 IN  NS  e.root-servers.net.
.     18942 IN  NS  f.root-servers.net.
.     18942 IN  NS  g.root-servers.net.
.     18942 IN  NS  h.root-servers.net.
.     18942 IN  NS  i.root-servers.net.
.     18942 IN  NS  j.root-servers.net.
.     18942 IN  NS  k.root-servers.net.
.     18942 IN  NS  l.root-servers.net.

#2. facem request-uri iterative pentru a afla adresa IP corespunzatoare lui fmi.unibuc.ro
dig @a.root-servers.net fmi.unibuc.ro

;; AUTHORITY SECTION:
ro.     172800  IN  NS  sec-dns-b.rotld.ro.
ro.     172800  IN  NS  dns-c.rotld.ro.
ro.     172800  IN  NS  dns-at.rotld.ro.
ro.     172800  IN  NS  dns-ro.denic.de.
ro.     172800  IN  NS  primary.rotld.ro.
ro.     172800  IN  NS  sec-dns-a.rotld.ro.

#3. interogam un nameserver responsabil de top-level domain .ro
dig @sec-dns-b.rotld.ro fmi.unibuc.ro

;; QUESTION SECTION:
fmi.unibuc.ro.     IN  A

;; AUTHORITY SECTION:
unibuc.ro.    86400 IN  NS  ns.unibuc.ro.

;; ADDITIONAL SECTION:
ns.unibuc.ro.   86400 IN  A 80.96.21.3


#am aflat de la @sec-dns-b.rotld.ro ca ns.unibuc.ro se gaseste la adresa: 80.96.21.3
#4. trimitem un ultim mesaj:
mesaj = "hey, ns.unibuc.ro, care este adresa IP pentru numele fmi.unibuc.ro?"
IP dst:  80.96.21.3 (ns.unibuc.ro)
PORT dst: aplicația de pe portul: 53 - constanta magică (vezi IANA și ICANN)

#cand fac cererea, deschid un port temporar (47632)
#pentru a primi inapoi raspunsul DNS destinat aplicatiei care a făcut cererea
```

Interogări către serverul DNS 8.8.8.8 de la google.
```bash
# interogam serverul 8.8.8.8 pentur a afla la ce IP este fmi.unibuc.ro
dig @8.8.8.8 fmi.unibuc.ro

; <<>> DiG 9.10.3-P4-Ubuntu <<>> @8.8.8.8 fmi.unibuc.ro
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16808
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;fmi.unibuc.ro.         IN  A

;; ANSWER SECTION:
fmi.unibuc.ro.      12925   IN  A   193.226.51.15

;; Query time: 39 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Wed May 13 13:29:13 EEST 2020
;; MSG SIZE  rcvd: 58

```
DNS stochează nu doar informații despre IP-ul corespunzător unui hostname, ci există mai multe tipuri de intrări ([record types](https://ns1.com/resources/dns-types-records-servers-and-queries)) în baza de date:

- A record / Address Mapping - stochează perechi de NUME - IPv4
- AAAA Record - similar cu A, pentru adrese IPv6
- CNAME / Canonical Name - are rolul de a face un alias între un hostname existent și un alt hostname, ex: nlp.unibuc.ro -> nlp-unibuc.github.io
- MX / Mail Exchanger - spcifică server de email SMTP pentru domeniu, încercați `dig @8.8.8.8 fmi.unibuc.ro MX`
- NS / Name Server - specifică ce Authoritative Name Server este responabil pentru o anumită zonă de DNS (ex., pentru fmi.unibuc.ro este ns1.fmi.unibuc.ro), încercați `dig @8.8.8.8 fmi.unibuc.ro NS`
- PTR / Reverse-lookup Pointer - permite interogarea in functie de IP pentru a afla numele
- TXT / Text data - conține informații care pot fi procesate de alte servicii, `dig @8.8.8.8 fmi.unibuc.ro TXT`
- SOA / Start of Authority - conține informații despre autoritatea care se ocupă de acest nume

Protocolul pentru DNS lucrează la nivelul aplicației și este standardizat pentru UDP, port 53. Acesta se bazează pe request-response iar în cazul în care nu se primesc răspunsuri după un număr de reîncercări (de multe ori 2), programul anunță că nu poate găsi IP-ul pentru hostname-ul cerut ("can't resolve"). Headerul protocolului [este definit aici](http://www.networksorcery.com/enp/protocol/dns.htm).



<a name="https"></a>
## HTTP/S requests
Intrati in  browser si apasati tasta F12. Accesati pagina https://fmi.unibuc.ro si urmariti in tabul Network
request-urile HTTP.
- Protocolul [HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)
- [Metode HTTP](http://httpbin.org/#/HTTP_Methods)
- Protocolul [HTTPS](https://robertheaton.com/2014/03/27/how-does-https-actually-work/)
- Video despre HTTPS [aici](https://www.youtube.com/watch?v=T4Df5_cojAs)

```python
import requests
from bs4 import BeautifulSoup

# dictionar cu headerul HTTP sub forma de chei-valori
headers = {
    "Accept": "text/html",
    "Accept-Language": "en-US,en",
    "Cookie": "__utmc=177244722",
    "Host": "fmi.unibuc.ro",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.79 Safari/537.36"
}

response = requests.get('https://fmi.unibuc.ro', headers=headers)
print (response.text[:200])

# proceseaza continutul html
supa = BeautifulSoup(response.text)

# cauta lista cu clasa ultimeleor postari
div = supa.find('ul', {'class': 'wp-block-latest-posts__list'})

print(div.text)
```

<a name="doh"></a>
### [DNS over HTTPS](https://datatracker.ietf.org/doc/rfc8484/?include_text=1)
Pentru securitare și privacy, sunt dezvoltate metode noi care encriptează cererile către DNS.
DNS over HTTPS sau DoH este explicat in detaliu [aici](https://hacks.mozilla.org/2018/05/a-cartoon-intro-to-dns-over-https/). 
Privacy-ul oferit de DoH poate fi exploatat și de [malware](https://www.zdnet.com/article/first-ever-malware-strain-spotted-abusing-new-doh-dns-over-https-protocol/) iar mai multe detalii despre securitatea acestuia pot fi citite [aici](https://secure64.com/wp-content/uploads/2019/06/doh-dot-investigation-6.pdf).


<a name="exercitii_http"></a>
### Exerciții HTTP/S
1. Cloudflare are un serviciu DoH care ruleaza pe IP-ul [1.1.1.1](https://blog.cloudflare.com/announcing-1111/). Urmăriți [aici documentația](https://developers.cloudflare.com/1.1.1.1/dns-over-https/json-format/) pentru request-uri de tip GET către cloudflare-dns și scrieți o funcție care returnează adresa IP pentru un nume dat ca parametru. Indicații: setați header-ul cu {'accept': 'application/dns-json'}. 
2. Executati pe containerul `rt1` scriptul 'simple_flask.py' care deserveste API HTTP pentru GET si POST. Daca accesati in browser [http://localhost:8001](http://localhost:8001) ce observati?
3. Conectați-vă la containerul `docker-compose exec rt2 bash`. Testati conexiunea catre API-ul care ruleaza pe rt1 folosind curl: `curl -X POST http://rt1:8001/post  -d '{"value": 10}' -H 'Content-Type: application/json'`. Scrieti o metoda POST care ridică la pătrat un numărul definit în `value`. Apelați-o din cod folosind python requests.
4. Urmăriți alte exemple de request-uri pe [HTTPbin](http://httpbin.org/)


<a name="socket"></a> 
## Socket API
Este un [API](https://www.youtube.com/watch?v=s7wmiS2mSXY) disponibil în mai toate limbajele de programare cu care putem implementa comunicarea pe rețea la un nivel mai înalt. Semnificația flag-urilor este cel mai bine explicată în tutoriale de [unix sockets](https://www.tutorialspoint.com/unix_sockets/socket_core_functions.htm) care acoperă partea de C. În limbajul [python](https://docs.python.org/2/library/socket.html) avem la dispoziție exact aceleași funcții și flag-uri ca în C iar interpretarea lor nu ține de un limbaj de programare particular.

<a name="udp"></a> 
### User Datagram Protocol - [UDP](https://tools.ietf.org/html/rfc768)

Este un protocol simplu la [nivelul transport](https://www.youtube.com/watch?v=hi9BVTNvl4c&list=PLfgkuLYEOvGMWvHRgFAcjN_p3Nzbs1t1C&index=50). Header-ul acestuia include portul sursă, portul destinație, lungime și un checksum opțional:
```
  0      7 8     15 16    23 24      31
  +--------+--------+--------+--------+
  |     Source      |   Destination   |
  |      Port       |      Port       |
  +--------+--------+--------+--------+
  |                 |                 |
  |     Length      |    Checksum     |
  +--------+--------+--------+--------+
  |
  |       data octets / payload
  +---------------- ...
```
Toate câmpurile din header sunt reprezentate pe câte 16 biți sau 2 octeți:
- Portul sursă și destinație în acest caz poate fi între 0 și 65535, nr maxim pe 16 biți. [Portul 0](https://www.lifewire.com/port-0-in-tcp-and-udp-818145) este rezervat iar o parte din porturi cu valori până la 1024 sunt [well-known](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers#Well-known_ports) și rezervate de către sistemul de operare. Pentru a putea aloca un astfel de port de către o aplicație client, este nevoie de drepturi de administrator.
- Length reprezintă lungimea în bytes a headerului și segmentului de date. Headerul este împărțit în 4 cîmpuri de 16 biți, deci are 8 octeți în total.
- Checksum - suma în complement față de 1 a bucăților de câte 16 biți, complementați cu 1, vezi mai multe detalii [aici](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#Checksum_computation) și [RFC1071 aici](https://tools.ietf.org/html/rfc1071) și [exemplu de calcul aici](https://www.youtube.com/watch?v=xWsD6a3KsAI). Este folosit pentru a verifica dacă un pachet trimis a fost alterat pe parcurs și dacă a ajuns integru la destinație.
- Payload sau data reprezintă datele de la nivelul aplicației. Dacă scriem o aplicație care trimite un mesaj de la un client la un server, mesajul nostru va reprezenta partea de payload.


Câteva caracteristi ale protocolului sunt descrise [aici](https://en.wikipedia.org/wiki/User_Datagram_Protocol#Attributes) iar partea de curs este acoperită în mare parte [aici](https://www.youtube.com/watch?v=Z1HggQJG0Fc&index=51&list=PLfgkuLYEOvGMWvHRgFAcjN_p3Nzbs1t1C).
UDP este implementat la nivelul sistemului de operare, iar Socket API ne permite să interacționăm cu acest protocol folosind apeluri de sistem.


#### Tutorial

##### UDP Server

În primă fază trebuie să importăm [librăria socket](https://docs.python.org/3/library/socket.html):
```python
import socket
```

Se instanțiază un obiect `sock` cu [AF_INET](https://stackoverflow.com/questions/1593946/what-is-af-inet-and-why-do-i-need-it) pentru adrese de tip IPv4, `SOCK_DGRAM` (datagrams - connectionless, unreliable messages of a fixed maximum length) pentru datagrams și `IPPROTO_UDP` pentru a specifica protocolul UDP:
```python
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
```

Apelăm funcția [bind](http://man7.org/linux/man-pages/man2/bind.2.html) pentru a asocia un port unei adrese și pentru ca aplicația sa își aloce acel port prin care poate primi sau transmite mesaje. In cazul de fata, adresa folosita este [localhost](https://whatismyipaddress.com/localhost), pe interfata loopback, ceea ce inseamnă că aplicația noastră nu va putea comunica cu alte dispozitive pe rețea, ci doar cu alte aplicații care se găsesc pe același calculator/container:

```python
port = 10000
adresa = 'localhost'
# tuplu adresa, port
server_address = (adresa, port)

#functia bind primeste ca parametru un obiect de tip tuplu
sock.bind(server_address)
```
Pentru a aloca un port astfel încât serverul să poată comunica pe rețea, trebuie fie să folosim adresa IP a interfeței pe care o folosim pentru comunicare (eth0 în cadrul containerelor de docker), fie să folosim o meta-adresă IP rezervată: `0.0.0.0` face ca toate interfețele să fie deschise către comunicare. Mai multe detalii despre această adresă puteți [citi aici](https://fossbytes.com/ip-address-0-0-0-0-meaning-default-route-uses/).

În momentul în care un client trimite serverului mesaje, acestea sunt stocate într-un buffer. Dimensiunea bufferului depinde de configurarea sistemului de operare, detaliile pentru linux sunt [aici](http://man7.org/linux/man-pages/man7/udp.7.html#DESCRIPTION) sau o postare cu mai multe explicații [aici](https://jvns.ca/blog/2016/08/24/find-out-where-youre-dropping-packets/).
Pentru a primi un mesaj, serverul poate să apeleze funcția `recvfrom` care are ca parametru numărul de bytes pe care să-l citească din buffer și o serie de [flags](https://manpages.debian.org/buster/manpages-dev/recv.2.en.html) optionale.

```python
# citeste 16 bytes din buffer
data, address = sock.recvfrom(16)
```

Funcția produce un apel blocant, deci programul stă în așteptare ca bufferul să se umple de octeți pentru a fi citiți. În cazul în care serverul nu primește mesaje, metoda stă în așteptare. Putem regla timpul de așteptare prin [settimeout](https://docs.python.org/3/library/socket.html#socket.socket.settimeout).

Valoarea returnată este un tuplu cu octeții citiți și adresa de la care au fost trimiși:
```python
print("Date primite: ", data)
print("De la adresa: ", address)
```

Folosim funcția `sendto` pentru a transmite octeți către o adresă de tip tuplu. Putem trimite înapoi un string prin care confirmăm primirea mesajului:
```python
payload =  bytes('Am primit: ', 'utf-8') + data
sent = sock.sendto(payload, address)
print ("Au fost trimisi ", sent, ' bytes')
```

În cele din urmă putem închide socket-ul folosind metoda `close()`

```python
sock.close()
```

##### UDP Client

Pentru a putea trimite mesaje, clientul trebuie să folosească adresa IP și port corespunzătoare serverului:
```python
import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)

port = 10000
adresa = 'localhost'
server_address = (adresa, port)
```

În python3, un string nu poate fi trimis prin socket decât dacă este convertit în șir de octeți.
Conversia se poate face fie prin alegerea unei [codificări](http://kunststube.net/encoding/):
```python
mesaj = "salut de la client, 你好"
print(type(mesaj))
# encoding utf-16
octeti = mesaj.encode('utf-16')
print (octeti)
print(type(octeti))
```
În linux codificarea default este UTF-8, un format în care unitățile de reprezentare a caracterelor sunt formate din 8 biți. Pentru a printa literele în terminal ar fi bine să folosim UTF-8. Caracterele ASCII putem să le convertim în bytes punând litera `b` în față:
```python
octeti = b"salut de la client cu" # nu merg caractere non-ascii 'țășîâ'
# apelam string encode
octeti = octeti + "你好".encode('utf-8')
# sau apelam constructorul de bytes cu un encoding
octeti = octeti + bytes("你好", 'utf-8')
print (octeti)
```

Observăm aici că nu am apelat metoda bind ca în server, dar cu toate astea metoda `sendto` pe care o folosim pentru a trimite octeții alocă implicit un [port efemer](https://en.wikipedia.org/wiki/Ephemeral_port) pe care îl utilizează pentru a trimite și primi mesaje.
```python
sent = sock.sendto(octeti, server_address)
```

Prin același socket putem apela si metoda de citire, în cazul de față 18 bytes din buffer. În cazul în care serverul nu trimite înapoi niciun mesaj, apelul va bloca programul indefinit până când va primi mesaje în buffer.
```python
data, adresa_de_la_care_primim = sock.recvfrom(18)
print(data, adresa_de_la_care_primim)
```

În cele din urmă pentru a închide conexiunea și portul, apelăm funcția close:
```python
sock.close()
```

O diagramă a procesului anterior este reprezentată aici:
![alt text](https://raw.githubusercontent.com/senisioi/computer-networks/2020/capitolul2/UDPsockets.jpg)


<a name="exercitii_udp"></a>
### Exerciții UDP
În directorul capitolul2/src aveți două scripturi [udp_server.py](https://github.com/senisioi/computer-networks/blob/2021/capitolul2/src/udp_server.py) și [udp_client.py](https://github.com/senisioi/computer-networks/blob/2021/capitolul2/src/udp_client.py). Spre deosebire de exemplul prezentat mai sus, serverul stă în continuă aștepatre de mesaje iar clientul trimite mesajul primit ca prim argument al programului.
1. Executați serverul apoi clientul fie într-un container de docker fie pe calculatorul vostru personal: `python3 udp_server.py` și `python3 udp_client.py "mesaj de trimis"`.
2. Modificați adresa de pornire a serverului din 'localhost' în IP-ul rezervat descris mai sus cu scopul de a permite serverului să comunice pe rețea cu containere din exterior. 
3. Porniți un terminal în directorul capitolul2 și atașați-vă la containerul rt1: `docker-compose exec rt1 bash`. Pe rt1 folositi calea relativă montată în directorul elocal pentru a porni serverul: `python3 /elocal/src/udp_server.py`. 
4. Modificați udp_client.py ca el să se conecteze la adresa serverului, nu la 'localhost'. Sfaturi: puteți înlocui localhost cu adresa IP a containerului rt1 sau chiar cu numele 'rt1'.
5. Porniți un al doilea terminal în directorul capitolul2 și rulați clientul în containerul rt2 pentru a trimite un mesaj serverului:  `docker-compose exec rt2 bash -c "python3 /elocal/src/udp_client.py salut"`
6. Deschideți un al treilea terminal și atașați-vă containerului rt1: `docker-compose exec rt1 bash`. Utilizați `tcpdump -nvvX -i any udp port 10000` pentru a scana mesajele UDP care circulă pe portul 10000. Apoi apelați clientul pentru a genera trafic.
7. Containerul rt1 este definit în [docker-compose.yml](https://github.com/senisioi/computer-networks/blob/2021/capitolul2/docker-compose.yml) cu redirecționare pentru portul 8001. Modificați serverul și clientul în așa fel încât să îl puteți executa pe containerul rt1 și să puteți să vă conectați la el de pe calculatorul vostru sau de pe rețeaua pe care se află calculatorul vostru.


<a name="tcp"></a> 
### Transmission Control Protocol - [TCP](https://tools.ietf.org/html/rfc793#page-15)

Este un protocol mai avansat de la [nivelul transport](http://www.erg.abdn.ac.uk/users/gorry/course/inet-pages/transport.html). 
Header-ul acestuia este mai complex și va fi explicat în detaliu în [capitolul3](https://github.com/senisioi/computer-networks/blob/2021/capitolul3/README.md#tcp):
```
  0                   1                   2                   3   Offs.
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
 -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 |          Source Port          |       Destination Port        |  1
 -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 |                        Sequence Number                        |  2
 -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 |                    Acknowledgment Number                      |  3
 -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 | Data  |0 0 0| |C|E|U|A|P|R|S|F|                               |
 |Offset | Res.|N|W|C|R|C|S|S|Y|I|            Window             |  4
 |       |     |S|R|E|G|K|H|T|N|N|                               |
 -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 |           Checksum            |         Urgent Pointer        |  5
 -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 |                    Options   (if data offset > 5)             | 
 -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 |                    Application data                           | 
 -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
```


Câteva caracteristici ale protocolului sunt descrise [aici](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#TCP_segment_structure).
Înainte de a face pașii de mai jos, urmăriți partea de curs acoperită în mare parte [aici](https://www.youtube.com/watch?v=c6gHTlzy-7Y&list=PLfgkuLYEOvGMWvHRgFAcjN_p3Nzbs1t1C&index=52). Între un client și un server se execută un proces de stabilire a conexiunii prin [three-way handshake](https://www.geeksforgeeks.org/computer-network-tcp-3-way-handshake-process/).


#### Tutorial

##### TCP Server

Server-ul se instanțiază cu [AF_INET](https://stackoverflow.com/questions/1593946/what-is-af-inet-and-why-do-i-need-it), `SOCK_STREAM` (fiindcă TCP operează la nivel de [byte streams](https://softwareengineering.stackexchange.com/questions/216597/what-is-a-byte-stream-actually)) și `IPPROTO_TCP` pentru specificarea protocolului TCP.

```python
# TCP socket 
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, proto=socket.IPPROTO_TCP)

port = 10000
adresa = 'localhost'
server_address = (adresa, port)
sock.bind(server_address)
```

Protocolul TCP stabilește o conexiune între client și server prin acel 3-way handshake [explicat aici](https://www.youtube.com/watch?v=c6gHTlzy-7Y&list=PLfgkuLYEOvGMWvHRgFAcjN_p3Nzbs1t1C&index=52). Numărul de conexiuni în aștepare se poate stabili prin metoda `listen`, apel prin care se marchează în același timp socketul ca fiind gata să accepte conexiuni.

```python
sock.listen(5)
```

Metoda `accept` este una blocantă și stă în așteptarea unei conexiuni. În cazul în care nu se conectează niciun clinet la server, metoda va bloca programul indefinit. Altfel, când un client inițializează 3-way handshake, metoda accept construieste un obiect de tip socket nou prin care se menține conexiunea cu acel client în mod specific.

```python
while True:
   conexiune, addr = sock.accept()
   time.sleep(30)
   # citim 16 bytes in bufferul asociat conexiunii
   payload = conexiune.recv(16)
   # trimitem înapoi un mesaj
   conexiune.send("Hello from TCP!".encode('utf-8'))
   # închidem conexiunea, dar nu și socket-ul serverului care
   # așteaptă alte noi conxiuni TCP
   conexiune.close()

sock.close()
```

##### TCP Client

Clientul trebuie să folosească adresa IP și portul cu serverului:
```python
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, proto=socket.IPPROTO_TCP)

port = 10000
adresa = 'localhost'
server_address = (adresa, port)
```

Prin apelul funcției connect, se inițializează 3-way handshake și conexiunea cu serverul.

```python
# 3-way handshake creat
sock.connect(server_address)
# trimite un mesaj
sock.send("Mesaj TCP client".encode('utf-8'))
# primeste un mesaj
data = sock.recv(1024)
print (data)
# inchide conexiunea
sock.close()
```

O diagramă a procesului anterior este reprezentată aici:
![alt text](https://raw.githubusercontent.com/senisioi/computer-networks/2020/capitolul2/TCPsockets.png)


<a name="exercitii_tcp"></a> 
### Exerciții TCP
În directorul capitolul2/src aveți două scripturi [tcp_server.py](https://github.com/senisioi/computer-networks/blob/2021/capitolul2/src/tcp_server.py) și [tcp_client.py](https://github.com/senisioi/computer-networks/blob/2021/capitolul2/src/udp_client.py).
1. Executați serverul apoi clientul fie într-un container de docker fie pe calculatorul vostru personal: `python3 tcp_server.py` și `python3 tcp_client.py "mesaj de trimis"`.
2. Modificați adresa de pornire a serverului din 'localhost' în IP-ul rezervat '0.0.0.0' cu scopul de a permite serverului să comunice pe rețea cu containere din exterior. Modificați tcp_client.py ca el să se conecteze la adresa serverului, nu la 'localhost'. Pentru client, puteți înlocui localhost cu adresa IP a containerului rt1 sau chiar cu numele 'rt1'.
3. Într-un terminal, în containerul rt1 rulați serverul: `docker-compose exec rt1 bash -c "python3 /elocal/src/tcp_server.py"`. 
4. Într-un alt terminal, în containerul rt2 rulați clientul: `docker-compose exec rt1 bash -c "python3 /elocal/src/tcp_client.py TCP_MESAJ"`
5. Mai jos sunt explicați pașii din 3-way handshake captați de tcpdump și trimiterea unui singur byte de la client la server. Salvați un exemplu de tcpdump asemănător care conține și partea de [finalizare a conexiunii TCP](http://www.tcpipguide.com/free/t_TCPConnectionTermination-2.htm). Sfat: Modificați clientul să trimită un singur byte fără să facă recv. Modificați serverul să citească doar un singur byte cu recv(1) și să nu facă send. Reporniți serverul din rt1. Deschideți un al treilea terminal, tot în capitolul2 și rulați tcpdump: `docker-compose exec rt1 bash -c "tcpdump -Snnt tcp"` pentru a porni tcpdump pe rt1. 

<a name="shake"></a> 
### 3-way handshake
Exemplu 3-way handshake captat cu tcpdump:
```
tcpdump -Snn tcp
```

#### SYN:
Clientul apelează funcția connect(('198.13.0.14', 10000)) iar mesajul din spate arată așa:
```
   IP 172.111.0.14.59004 > 198.13.0.14.10000: Flags [S], seq 2416620956, win 29200, options [mss 1460,sackOK,TS val 897614012 ecr 0,nop,wscale 7], length 0
```

- Flags [S] - cerere de sincronizare de la adresa 172.111.0.14 cu portul 59004 către adresa 198.13.0.14 cu portul 10000
- seq 2416620956 - primul sequence nr pe care îl setează clientul în mod aleatoriu
- win 29200 - Window Size inițial. Pentru mai multe detalii, puteți consulta capitolul3 sau [video de aici](https://www.youtube.com/watch?v=Qpkr_12RQ7k)
- options [mss 1460,sackOK,TS val 897614012 ecr 0,nop,wscale 7] - reprezintă Opțiunile de TCP ce vor fi detaliate în capitolul3. Cele mai importante sunt prezentate pe scurt în [acest tutorial](http://www.firewall.cx/networking-topics/protocols/tcp/138-tcp-options.html). Cele din tcpdump în ordinea asta sunt: [Maximum Segment Size (mss)](http://fivedots.coe.psu.ac.th/~kre/242-643/L08/html/mgp00005.html), [Selective Acknowledgement](https://wiki.geant.org/display/public/EK/SelectiveAcknowledgements), [Timestamps](http://fivedots.coe.psu.ac.th/~kre/242-643/L08/html/mgp00011.html) (pentru round-trip-time), NOP (no option pentru separare între opțiuni) și [Window Scaling](http://fivedots.coe.psu.ac.th/~kre/242-643/L08/html/mgp00009.html).
- length 0 - mesajul SYN nu are payload, conține doar headerul TCP

#### SYN-ACK:
În acest punct lucrurile se întâmplă undeva în interiorul funcției accept din server la care nu avem acces. Serverul răspunde prin SYN-ACK:
```
   IP 198.13.0.14.10000 > 172.111.0.14.59004: Flags [S.], seq 409643424, ack 2416620957, win 28960, options [mss 1460,sackOK,TS val 2714984427 ecr 897614012,nop,wscale 7], length 0
```

- Flags [S.] - . (punct) reprezintă flag de Acknowledgement din partea serverului (198.13.0.14.10000) că a primit pachetul și returnează și un Acknowledgement number: ack 2416620957 care reprezintă Sequence number trimis de client + 1 (vezi mai sus la SYN).
- Flags [S.] - în același timp, serverul trimite și el un flag de SYN și propriul Sequence number: seq 409643424
- optiunile sunt la fel ca înainte și length 0, mesajul este compus doar din header, fără payload


#### ACK:
După primirea cererii de sincronizare a serverului, clientul confirmă primirea, lucru care se execută în spatele funcției connect:
```
   IP 172.111.0.14.59004 > 198.13.0.14.10000: Flags [.], ack 409643425, win 229, length 0
```
- Flags [.] - . (punct) este pus ca flack de Ack și se transmite Ack Number ca fiind seq number trimis de server + 1: ack 409643425
- length 0, din nou, mesajul este fără payload, doar cu header

#### PSH:
La trimiterea unui mesaj, se folosește flag-ul push (PSH) și intervalul de secventă de dimensiune 1:
```
   IP 172.111.0.14.59004 > 198.13.0.14.10000: Flags [P.], seq 2416620957:2416620958, ack 409643425, win 229, length 1
```
- Flags [P.] - avem P și . (punct) care reprezintă PUSH de mesaj nou și Ack ultimului mesaj
- seq 2416620957:2416620958 - se trimite o singură literă (un byte) iar numărul de secvență indică acest fapt
- ack 409643425 - la orice mesaj, se confirmă prin trimiterea de Ack a ultimului mesaj primit, in acest caz se re-confirmă SYN-ACK-ul de la server
- length 1 - se trimite un byte în payload 


#### ACK:
Serverul dacă primește mesaju, trimite automat un mesaj cu flag-ul ACK și Ack Nr numărul de octeți primiți. 
```
    IP 198.13.0.14.10000 > 172.111.0.14.59004: Flags [.], ack 2416620958, win 227, length 0
```
- Flags [.] - flag de Ack
- ack 2416620958 - semnifică am primit octeți pana la 2416620957, aștept octeți de la Seq Nr 2416620958
- length 0 - un mesaj de confirmare nu are payload 

