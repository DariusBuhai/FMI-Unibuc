<!-- README template used: https://github.com/othneildrew/Best-README-Template -->

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<h3 align="center">Smart Energy</h3>
  <p align="center">
    Efficient usage of limited sources of energy for unlimited posibilities.
  </p>


<!-- ABOUT THE PROJECT -->
## Despre proiect
În contextul actualei **crize de mediu** și al încălzirii globale, echipa noastra propune un program **IoT** al cărui scop este de a interacționa cu device-urile smart dintr-o locuință pentru a **eficientiza energia consumată**. În acest sens programul ar putea fi implementat pe o sursa smart de energie (sau pe distribuitori de energie precum un prelungitor) electrica unde ar urma sa comunice cu restul de device-uri smart cu scopul de a realiza **statistici** și a efectua acțiuni ce vor diminua consumul de energie.

Documentatia proiectului poate fi accesata aici: [Documentatie Read The Docs](https://smartenergy.readthedocs.io/en/latest/index.html).

Informatii detaliate despre proiect pot fi consultate in cadrul paginii wiki: [Documentului de analiza](https://github.com/SoftwareEngineerUB/SmartEnergy/wiki/Document-de-Analiza-a-aplicatiei-SmartEnergy).

## Membrii echipa

* Buhai Darius
* Bulaceanu Alexandra
* Savu Ioan
* Rusu Andrei
* Mitoi Stefan
* Stanciu Calin

### Tool-uri folosite

* [Flask](https://flask.palletsprojects.com/en/2.0.x/)
* [Flask-MQTT](https://flask-mqtt.readthedocs.io/en/latest/)
* [SQLite](https://www.sqlite.org/index.html)
* [Mosquitto](https://mosquitto.org/)
* [pytest](https://docs.pytest.org/en/6.2.x/)


## Instructiuni de instalare


## Prerequisites


Este necesar python3..
Se poate downloada [aici](https://www.python.org/downloads)_. 
De asemenea [package manager-ul pip](https://pypi.org/project/pip) trebuie si el instalat.


## Mosquitto MQTT Broker


Pentru instalare Mosquitto MQTT Broker, se utilizeaza [official page](https://mosquitto.org/download) si se selecteaza versiunea corespunzatoare sistemului de operare utilizat.


## Pentru Ubuntu:

Rulam comanda de instalare:
```sh
    sudo apt-get install mosquitto
```

Porinim serviciul:
```sh
    sudo systemctl start mosquitto
```
Verificam daca ruleaza serviciul:
```sh
    sudo systemctl status mosquitto
```

## Pentru Mac: 

Se foloseste Homebrew si se instaleaza serviciul:
```sh
    brew install mosquitto
```


## Instalare


1. Se creaza un virtual environment:

Pe Linux:
Instalare:
```sh
    sudo pip install virtualenv
```
In interiorul folderul-ui de proiect se creaza env-ul
```sh
    cd SmartEnergy/
    virtualenv .venv
```

In loc de venv, se poate utiliza orice alt nume pentru identificarea virtual env

Activam mediul creat:
```sh
    source .venv/bin/activate
```

In acest punct ar trebui sa fie activat in linia de comanda.
Dezactivare:
```sh
    deactivate
```

2. Instalam dependintele
```sh
    pip install -r requirements.txt
```

3. Initializam baza de date:
```sh
    python3 app/util/database.py
```

## Intructiuni de rulare si utilizare


## Rulare pe Linux

1. **Pornire MQTT Broker**.

We use Mosquitto to run it:
```sh
    sudo service mosquitto start
```

Pnetru a vederea daca ruleaza serviciul `netstat –at`.

Pentru a-l opri `sudo service mosquitto stop`.

2. **Rulare aplicatie**

```sh
    $ python3 wsgi.py
```


## Testare

Pentru rularea testelor si obtinerea coverage-ului:
```sh
    $ coverage run -m pytest
```
Pentru generarea unui raport de coverage:
```sh
    $ coverage report
```


## Developer Tools


## OpenAPI

Am expus REST API HTTP utilizand Open API Specification - [Swagger](https://swagger.io/specification/). 


## AsyncAPI

Pentru API MQTT am folosit AsyncAPI [Specification](https://www.asyncapi.com/docs/specifications/v2.3.0)
Studio-ul de editare poate fi accesat la acest [link](https://studio.asyncapi.com/?url=https://raw.githubusercontent.com/asyncapi/asyncapi/v2.2.0/examples/simple.yml).


### Read the Docs Documentation

Am utilizat tool-ul [Read the Docs](https://readthedocs.org).
Documentatia acestuia este disponibila [aici](https://smart-pots.readthedocs.io). 

Am utilizat [Sphinx](https://www.sphinx-doc.org/en/master). Codul se poate consulta in folderul [docs](https://github.com/SoftwareEngineerUB/SmartEnergy/tree/main/docs)

Comanda necesare:
```sh
make html
```


## Identificare bug-uri cu RESTler

Am utilizat tool-ul [Restler](https://github.com/microsoft/restler-fuzzer).

1. Se face download la repo-ul urmator:
```sh
git clone https://github.com/microsoft/restler-fuzzer.git && cd restler-fuzzer
```

2. Se creaza un restler_bin
```sh
mkdir ../restler_bin
```

3. Se da build la acest folder
```sh
python ./build-restler.py --dest_dir ../restler_bin
```

4. Se sterge repo-ul
```sh
cd .. && rm restler-fuzzer
```

5. Ne mutam in directorul restler_bin
```sh
cd restler_bin
```

6. Compilam fisierle necesare pentru Restler
```sh
dotnet ./restler/Restler.dll compile --api_spec ./swagger.json
```

7. Se ruleaza
```sh
dotnet ./restler/Restler.dll test --grammar_file grammar.py --dictionary_file dict.json --settings engine_settings.json --no_ssl
```


## Licenta

Utilizam Apache-2.0 License. Accesati `LICENSE` pentru mai multe informatii.


## Contributii

Proiectul este open-source, ceea ce inseamna ca incurajam orice contributie.


## Surse de informare
The following list includes resources we found helpful and would like to give credit to:

* [How to Write Your First AsyncAPI Specification](https://nordicapis.com/how-to-write-your-first-asyncapi-specification/)
* [How to Set Up Your Python Project Docs for Success🎉](https://towardsdatascience.com/how-to-set-up-your-python-project-docs-for-success-aab613f79626)

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/SoftwareEngineerUB/SmartEnergy.svg?style=for-the-badge
[contributors-url]: https://github.com/SoftwareEngineerUB/SmartEnergy/graphs/contributors

[stars-shield]: https://img.shields.io/github/stars/SoftwareEngineerUB/SmartEnergy.svg?style=for-the-badge
[stars-url]: https://github.com/SoftwareEngineerUB/SmartEnergy/stargazers

[issues-shield]: https://img.shields.io/github/issues/SoftwareEngineerUB/SmartEnergy.svg?style=for-the-badge
[issues-url]: https://github.com/SoftwareEngineerUB/SmartEnergy/issues

[license-shield]: https://img.shields.io/github/license/SoftwareEngineerUB/SmartEnergy.svg?style=for-the-badge
[license-url]: https://github.com/SoftwareEngineerUB/SmartEnergy/blob/main/LICENSE