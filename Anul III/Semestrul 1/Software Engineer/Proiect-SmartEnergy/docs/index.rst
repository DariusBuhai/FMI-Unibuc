.. SmartEnergy documentation master file, created by
   sphinx-quickstart on Tue Feb  1 18:49:49 2022.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to SmartEnergy's documentation!
======================================

SmartEnergy is an IoT application whose purpose is to interact with 
smart devices in a home to make the energy consumed more efficient.

|smartenergy_img|

In order to install everything necessary check out :doc:`requirements <pages/requirements>`.
For more usage information refer to :doc:`run_tutorial <pages/features>`.
For a complete list of features, see :doc:`features <pages/features>`.

The data set is taken from `Smart* Data Set for Sustainability <https://traces.cs.umass.edu/index.php/Smart/Smart>`_.

The code base is hosted on GitHub, at this link: `SoftwareEngineerUB/SmartEnergy <https://github.com/SoftwareEngineerUB/SmartEnergy>`_.

********************
Technologies Used
********************
* We used `Flask <https://flask.palletsprojects.com/en/2.0.x/>`_ to implement the HTTP Connection.
* The `Flask-MQTT extention <https://flask-mqtt.readthedocs.io/en/latest/>`_ was used to implement the MQTT Connection.
* The database used is `SQLite <https://www.sqlite.org/index.html>`_.

=======================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   pages/features
   pages/requirements
   pages/run_tutorial


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
