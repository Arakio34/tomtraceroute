#!/bin/bash

setup(){
	mkdir script
	mkdir data
	wget https://mailfud.org/geoip-legacy/GeoIPCity.dat.gz
	mv GeoIpCity.dat.gz data/GeoIpCity.dat.gz
	gzip -df data/GeoIpCity.dat.gz	

}
