<?php
/*Before you can use this script, you need to load an aggregate function e.g.

CREATE AGGREGATE textcat_all(
  basetype    = text,
  sfunc       = textcat,
  stype       = text,
  initcond    = ''
);

http://stackoverflow.com/questions/43870/how-to-concatenate-strings-of-a-string-field-in-a-postgresql-group-by-query

*/

header("Content-Type: application/vnd.google-earth.kml+xml");
header("Content-Disposition: attachment; filename=location.kml");

//DB config
$dbname = "france";
$host = "localhost";
$username = "user";
$password = "pass";

$ourFileName = "france_php.kml";
$ourFileHandle = fopen($ourFileName, 'w') or die("can't open file");

try {
    $dbh = new PDO("pgsql:dbname=$dbname;host=$host", $username, $password);
    
    foreach($dbh->query("SELECT '<?xml version=\"1.0\" encoding=\"UTF-8\"?><kml xmlns=\"http://earth.google.com/kml/2.1\"><Document>\n'||textcat_all(replace(replace(st_askml(the_geom),'<MultiGeometry>','<Placemark>'||'\n<name>'||'Departement '||code_dept||'</name>\n'||'<description>'||'Departement '||code_dept||'</description>\n'||'<MultiGeometry>'),'</MultiGeometry>','</MultiGeometry></Placemark>')||'\n')||'</Document></kml>' FROM departement") as $row) {
$kml_string = $row[0];
fwrite($ourFileHandle, $kml_string);

    }
    $dbh = null;
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}

fclose($ourFileHandle);

//echo $kml_string;
