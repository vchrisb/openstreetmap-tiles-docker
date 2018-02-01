# OpenStreetMap Tile Server Container

This repository contains instructions for building a
[Docker](https://www.docker.io/) image containing the OpenStreetMap tile
serving software stack.  It is based on the
[Switch2OSM instructions](https://switch2osm.org/manually-building-a-tile-server-16-04-2-lts/).

As well as providing an easy way to set up and run the tile serving software it
also provides instructions for managing the back end database, allowing you to:

* Import OSM data into the database


Run `docker run -e GIS_HOST=x.x.x.x -e GIS_USER=postgres -e GIS_DATABASE=gis -e GIS_PASSWORD=password -p 80:80 -d --name osm vchrisb/openstreetmap-tiles`.

## About

The container runs Ubuntu 16.04 (Xenial) and is based on the
[phusion/baseimage-docker](https://github.com/phusion/baseimage-docker).  It
includes:

* Apache 2.4
* The latest [Osm2pgsql](http://wiki.openstreetmap.org/wiki/Osm2pgsql) code (at
  the time of image creation)
* The ubuntu package of [Mapnik](http://mapnik.org/)
* The latest [Mod_Tile](http://wiki.openstreetmap.org/wiki/Mod_tile) code (at
  the time of image creation)
* The latest [Carto](https://github.com/gravitystorm/openstreetmap-carto) stylesheet
