--Créer une kml automatiquement

--Créer une fonction d'agrégation (A executer une seule fois donc commentée)
--http://stackoverflow.com/questions/43870/how-to-concatenate-strings-of-a-string-field-in-a-postgresql-group-by-query

/*
CREATE AGGREGATE textcat_all(
  basetype    = text,
  sfunc       = textcat,
  stype       = text,
  initcond    = ''
);
*/

/*
-- Un exemple fonctionnel pour une table departement avec une colonne code_dept (ne pas décommenter seulement fourni à titre d'exemple)

SELECT textcat_all(code_dept || ',')
FROM departement;

*/


--Juste les géométries

SELECT '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://earth.google.com/kml/2.1">
<Document>\n'--concatene l'en-tete de declaration d'un kml
	||textcat_all(
	        replace(
			replace(st_askml(the_geom),'<MultiGeometry>','<Placemark><MultiGeometry>'),
			'</MultiGeometry>','</MultiGeometry></Placemark>')||'\n'
	) --remplace deux fois les balises (ouverture et fermeture) pour chaque geometrie
	||'</Document>
</kml>'--termine le document par les balises de fermeture du kml
FROM departement
WHERE cast(code_dept as integer) <10 AND code_dept NOT IN ('2A','2B');

--Geometries + Nom + Description

SELECT '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://earth.google.com/kml/2.1">
<Document>\n'--concatene l'en-tete de declaration d'un kml
	||textcat_all(
	        replace(
			replace(st_askml(the_geom),'<MultiGeometry>','<Placemark>'||'\n<name>'||'Departement '||code_dept||'</name>\n'||'\n<description>'||'Departement '||code_dept||'</description>\n'||'<MultiGeometry>'),
			'</MultiGeometry>','</MultiGeometry></Placemark>')||'\n'
	) --remplace deux fois les balises (ouverture et fermeture) pour chaque geometrie
	||'</Document>
</kml>'--termine le document par les balises de fermeture du kml
FROM departement;


-- Idem à précédente mais avec CDATA pour échapper les caractères dans le bloc description (sinon xml invalide) et mettre par exemple du html

SELECT '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://earth.google.com/kml/2.1">
<Document>'||E'\r\n'--concatene l'en-tete de declaration d'un kml
	||textcat_all(
	        replace(
			replace(st_askml(the_geom),'<MultiGeometry>','<Placemark>'||E'\r\n'||'<name>'||'Departement '||code_dept||'</name>'||E'\r\n'||E'\r\n'||'<description><![CDATA['||'Departement '||code_dept||']]></description>'||E'\r\n'||'<MultiGeometry>'),
			'</MultiGeometry>','</MultiGeometry></Placemark>')||E'\r\n'
	) --remplace deux fois les balises (ouverture et fermeture) pour chaque geometrie
	||'</Document>
</kml>'--termine le document par les balises de fermeture du kml
FROM departement
WHERE cast(code_dept as integer) <10 AND code_dept NOT IN ('2A','2B');
