$setenv GDAL_DATA	c:\Program Files\qgis 3.34.3\share\gdal
$set ogr2ogr		c:\Program Files\qgis 3.34.3\bin\ogr2ogr.exe
$set ogr2info		c:\Program Files\qgis 3.34.3\bin\ogrinfo.exe
$call 'call "%ogr2ogr%" -f "CSV" test_output_ogr.csv test_output.geojson -progress '
