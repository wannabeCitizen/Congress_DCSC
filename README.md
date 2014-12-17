Congress_DCSC
=============

This project includes all the parts needed for a deployable cloud-based system for scraping and parsing the Congressional Record, hosting it in Redis Databases, and handling requests through a Python Flask Webserver and a RabbitMQ RPC System.  

Some of the Puppet configuration, especially the bootstrapping scripts, is taken or modelled off of Matt Monaco's puppet config used in the CSEL in the Computer Science department at CU Boulder. The code is hosted at:
https://git.cs.colorado.edu/csel/puppet/tree/master

Also many thanks to the [Sunlight Foundation](http://www.sunlightfoundation.com) for creating an XML parser for the Congressional, which we used in this project.
