============
Installation
============

#############
Prerequisites
#############

You need to have python3 installed.
Download it `here <https://www.python.org/downloads/>`_. 
Also make sure you also have `pip package manager <https://pypi.org/project/pip/>`_ installed.

**********************************
Mosquitto MQTT Broker
**********************************

For installing Mosquitto MQTT Broker, navigate to the `official page <https://mosquitto.org/download/>`_
and get the version compatible with your own OS.


For Ubuntu:
===========
Run this command to install it:
::
    sudo apt-get install mosquitto

Start the service:
::
    sudo systemctl start mosquitto
Check if the service is running:
::
    sudo systemctl status mosquitto

For Mac: 
========
Use Homebrew and install it with this command:
::
    brew install mosquitto


############
Installation
############

It is recommended to have a virtualenv in order to install all the requirements.
1. Create the virtual environment by executing the following command:

On Linux:
Install the virtualenv
::
    sudo pip install virtualenv
Go inside the project folder and create a new virtual environment
::
    cd SmartEnergy/
    virtualenv .venv

Instead of venv, you could use a different name to identify your virtual env

You have to activate the environment that you just created:
::
    source .venv/bin/activate

At this point you should see that it was activated in the command line.
To deactivate it use:
::
    deactivate

2. Now it is time to install all the libraries and dependencies need to run the app.
Find them in the dedicated file called requirements.txt. Run the command:
::
    pip install -r requirements.txt

3. Initialise the database using:
::
    python3 app/util/database.py
