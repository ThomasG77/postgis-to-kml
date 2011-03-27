# KML polygons generator with attributes from PostGIS

# Sample data can be retrieve from http://professionnels.ign.fr/ficheProduitCMS.do?idDoc=6185461
# You have to choose "Télécharger GEOFLA® Départements (format Shapefile)"
# Direct link http://professionnels.ign.fr/DISPLAY/000/528/175/5281750/GEOFLADept_FR_Corse_AV_L93.zip
# Data restricted for non-commercial use

# You have to import them into PostGIS with shp2pgsql

You can use both python and php scripts to generate KML
  * kml_php.php
  * kml_python.py

You have some sql queries samples in postgis_kml_attributes.sql

You only need PostGIS and PHP or Python with this scripts.

For licence, see LICENCE.txt

#Alternatives

If you can install OGR/GDAL (http://www.gdal.org/), a short way to do the same can be
ogr2ogr -f KML output.kml PG:'host=localhost dbname=france user=user password=pass' -sql "SELECT * from departement"
Further about KML in OGR/GDAL http://www.gdal.org/ogr/drv_kml.html

You can for example embed the previous line with parameters in a python script using Subprocess http://docs.python.org/library/subprocess.html
or start to use gdal python for custom needs.

For PHP, you can use embed Exec command http://php.net/manual/fr/function.exec.php


