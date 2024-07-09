$title	Generate Gravity Calibration Datasets for Traded Sectors

$set gtapwindc_datafile ..\..\GTAPWiNDC\2017\gtapwindc\43_filtered.gdx

*	Faster -- just read the data:

$include ..\..\GTAPWiNDC\gtapwindc_data

parameter
	m0(i,r)		Import supply,
	x0(i,r)		Export demand,
	y0(i,s)		Reference output (data),
	z0(i,s)		Reference demand (data),
	nref(i,s,s)	Intra-national trade,
	mref(i,r,s)	Imports,
	xref(i,s,r)	Exports;

$if not set ds $set ds a

$call gdxmerge datasets\%ds%\*.gdx
$gdxin 'merged.gdx'
$load m0 x0 y0 z0 nref mref xref
