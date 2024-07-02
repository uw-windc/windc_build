$title	Use CENSUS API to Read Exports by Port at HS6 Level

*	   2-Jul-2024   3:11:46p     67,782,757   exports.gdx

*	Get a Census API key:

$include censuskey

$ontext

Requested columns for exports.csv:

	1 E_COMMODITY
	2 CTY_CODE
	3 PORT
	4 ALL_VAL_YR
	5 YEAR=2017
	6 MONTH=12
	7 COMM_LVL=HS6
	8 SUMMARY_LVL

Requested columns for goods.csv:

	1 E_COMMODITY
	2 E_COMMODITY_SDESC
	3 GEN_VAL_YR
	4 YEAR=2017
	5 MONTH=12
	6 COMM_LVL=HS6

Requested columns for regions.csv:

	1 CTY_CODE
	2 CTY_NAME
	3 GEN_VAL_YR
	4 YEAR=2017
	5 MONTH=12
	6 SUMMARY_LVL

Requested columns for ports.csv:

	1 PORT
	2 PORT_NAME
	3 GEN_VAL_YR
	4 YEAR=2017
	5 MONTH=12

$offtext

$log Downloading export data.

$if not exist exports_x.json $call curl -o exports_x.json "https://api.census.gov/data/timeseries/intltrade/exports/porths?get=E_COMMODITY,CTY_CODE,PORT,ALL_VAL_YR&key=%key%&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
$if not exist exports_i.json $call curl -o exports_i.json "https://api.census.gov/data/timeseries/intltrade/exports/porths?get=E_COMMODITY,E_COMMODITY_SDESC&key=%key%&YEAR=2017&MONTH=12&COMM_LVL=HS6"
$if not exist exports_r.json $call curl -o exports_r.json "https://api.census.gov/data/timeseries/intltrade/exports/porths?get=CTY_CODE,CTY_NAME&key=%key%&YEAR=2017&MONTH=12&SUMMARY_LVL=DET"
$if not exist exports_g.json $call curl -o exports_g.json "https://api.census.gov/data/timeseries/intltrade/exports/porths?get=CTY_CODE,CTY_NAME&key=%key%&YEAR=2017&MONTH=12&SUMMARY_LVL=CGP"
$if not exist exports_p.json $call curl -o exports_p.json "https://api.census.gov/data/timeseries/intltrade/exports/porths?get=PORT,PORT_NAME&key=%key%&YEAR=2017&MONTH=12"

$call pause

$if not exist exports_x.csv $call tr -d "[]" <exports_x.json 	       >exports_x.csv
$if not exist exports_i.csv $call tr -d "[]" <exports_i.json   	       >exports_i.csv
$if not exist exports_r.csv $call tr -d "[]" <exports_r.json 	       >exports_r.csv
$if not exist exports_g.csv $call tr -d "[]" <exports_g.json  	       >exports_g.csv
$if not exist exports_p.csv $call tr -d "[]" <exports_p.json   	       >exports_p.csv

$call pause

$label csv2gdx
$if not exist exports_x.gdx  $call csv2gdx exports_x.csv output=exports_x.gdx id=x index=(1,2,3,8) value=4 useheader=y fieldsep=comma 
$if not exist exports_i.gdx  $call csv2gdx exports_i.csv output=exports_i.gdx id=i index=1 text=2      useheader=y fieldsep=comma 
$if not exist exports_r.gdx  $call csv2gdx exports_r.csv output=exports_r.gdx id=r index=1 text=2      useheader=y fieldsep=comma 
$if not exist exports_g.gdx  $call csv2gdx exports_g.csv output=exports_g.gdx id=g index=1 text=2      useheader=y fieldsep=comma 
$if not exist exports_p.gdx  $call csv2gdx exports_p.csv output=exports_p.gdx id=p index=1 text=2      useheader=y fieldsep=comma 

set	rtype /	cgp	Set r is a country grouping
		det	Set r is an individual country /;

set	i(*)		Commodities
	r(*)		Countries
	g(*)		Groups
	p(*)		Ports;

$gdxin exports_r.gdx
$load r

$gdxin exports_g.gdx
$load g

$gdxin exports_i.gdx
$load i

$gdxin exports_p.gdx
$load p

alias (u,*);

parameter	x(i,u,p,rtype)	"Year-to-Date General Exports -- total value";
$gdxin 'exports_x.gdx'
$loaddc x

set	rg(*)	Regions and Groups;
rg(r) = yes;
rg(g) = yes;

execute_unload 'exports.gdx',i,r,g,rg,p,x;
