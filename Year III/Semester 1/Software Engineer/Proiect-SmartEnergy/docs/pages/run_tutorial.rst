==============
Run Tutorial
==============

After installing the :ref:`requirements`, the next steps are necessary in order to run the app.

****************
Running on Linux
****************

1. **Start the MQTT Broker service in order to enable the MQTT clients to communicate**.

We use Mosquitto to run it:
::
    sudo service mosquitto start 

To see if the service is running use the command `netstat –at`.

To stop it, use the command `sudo service mosquitto stop`.

2. **Running the application.**
In order to run the app you have to write this command in the command line:
::
    $ python3 wsgi.py


*******
Testing
*******
To run the tests and see the coverage:
::
    $ coverage run -m pytest
For generating a coverage report, run this command:
::
    $ coverage report


***************
Developer Tools
***************

OpenAPI
=======
We exposed the REST API HTTP using Open API Specification - `Swagger <https://swagger.io/specification/>`_. 


AsyncAPI
========
For documenting the API MQTT we used AsyncAPI - `Specification <https://www.asyncapi.com/docs/specifications/v2.3.0>`_.
For accesing the studio use this `link <https://studio.asyncapi.com/?url=https://raw.githubusercontent.com/asyncapi/asyncapi/v2.2.0/examples/simple.yml>`_.