#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Before you can use this script, you need to load an aggregate function e.g.

CREATE AGGREGATE textcat_all(
  basetype    = text,
  sfunc       = textcat,
  stype       = text,
  initcond    = ''
);

http://stackoverflow.com/questions/43870/how-to-concatenate-strings-of-a-string-field-in-a-postgresql-group-by-query

"""

# To connect to Postgresql
import psycopg2

host = "localhost"
dbname = "france"
username = "user"
password = "pass"

# Connect to an existing database
conn = psycopg2.connect("host=" + host + " dbname=" + dbname + " user=" + username + " password=" + password)

# Open a cursor to perform database operations
cur = conn.cursor()

# Execute a command: this creates a new table
cur.execute("SELECT '<?xml version=\"1.0\" encoding=\"UTF-8\"?><kml xmlns=\"http://earth.google.com/kml/2.1\"><Document>\n'||textcat_all(replace(replace(st_askml(the_geom),'<MultiGeometry>','<Placemark>'||'\n<name>'||'Departement '||code_dept||'</name>\n'||'<description>'||'Departement '||code_dept||'</description>\n'||'<MultiGeometry>'),'</MultiGeometry>','</MultiGeometry></Placemark>')||'\n')||'</Document></kml>' FROM departement")
kml_string = cur.fetchone()

f = open('france_python.kml', 'w')

# print kml_string[0]
f.write(kml_string[0])

f.close()

# Make the changes to the database persistent
#conn.commit() # Here a as reminder

# Close communication with the database
cur.close()
conn.close()

