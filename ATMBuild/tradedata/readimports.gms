$title	Use CENSUS API to Read Imports by Port at HS6 Level

*   2-Jul-2024   3:15:56p     55,859,926   imports.gdx


*	Get a Census API key:

$include censuskey 

$ontext

Requested columns for imports.csv:
	1 I_COMMODITY
	2 CTY_CODE
	3 PORT
	4 GEN_VAL_YR
	5 YEAR=2017
	6 MONTH=12
	7 COMM_LVL=HS6
	8 SUMMARY_LVL

Requested columns for goods.csv:
	1 I_COMMODITY
	2 I_COMMODITY_SDESC
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

$log Downloading import data.

$if not exist imports_m.json $call curl -o imports_m.json "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY,CTY_CODE,PORT,GEN_VAL_YR&key=%key%&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
$if not exist imports_i.json $call curl -o imports_i.json "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY,I_COMMODITY_SDESC&key=%key%&YEAR=2017&MONTH=12&COMM_LVL=HS6"
$if not exist imports_r.json $call curl -o imports_r.json "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=CTY_CODE,CTY_NAME&key=%key%&YEAR=2017&MONTH=12&SUMMARY_LVL=DET"
$if not exist imports_g.json $call curl -o imports_g.json "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=CTY_CODE,CTY_NAME&key=%key%&YEAR=2017&MONTH=12&SUMMARY_LVL=CGP"
$if not exist imports_p.json $call curl -o imports_p.json "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=PORT,PORT_NAME&key=%key%&YEAR=2017&MONTH=12"

$if not exist imports_m.csv $call tr -d "[]" <imports_m.json 	       >imports_m.csv
$if not exist imports_i.csv $call tr -d "[]" <imports_i.json   	       >imports_i.csv
$if not exist imports_r.csv $call tr -d "[]" <imports_r.json 	       >imports_r.csv
$if not exist imports_g.csv $call tr -d "[]" <imports_g.json  	       >imports_g.csv
$if not exist imports_p.csv $call tr -d "[]" <imports_p.json   	       >imports_p.csv

$label csv2gdx
$if not exist imports_m.gdx  $call csv2gdx imports_m.csv output=imports_m.gdx id=m index=(1,2,3,8) value=4 useheader=y fieldsep=comma 
$if not exist imports_i.gdx  $call csv2gdx imports_i.csv output=imports_i.gdx id=i index=1 text=2          useheader=y fieldsep=comma 
$if not exist imports_r.gdx  $call csv2gdx imports_r.csv output=imports_r.gdx id=r index=1 text=2          useheader=y fieldsep=comma 
$if not exist imports_g.gdx  $call csv2gdx imports_g.csv output=imports_g.gdx id=g index=1 text=2          useheader=y fieldsep=comma 
$if not exist imports_p.gdx  $call csv2gdx imports_p.csv output=imports_p.gdx id=p index=1 text=2          useheader=y fieldsep=comma 

set	rtype /	cgp	Set r is a country grouping (set g)
		det	Set r is an individual country (set r) /;

set	i(*)		Commodities
	r(*)		Countries
	g(*)		Groups
	p(*)		Ports;

$gdxin imports_r.gdx
$load r

$gdxin imports_g.gdx
$load g

$gdxin imports_i.gdx
$load i

$gdxin imports_p.gdx
$load p

alias (u,*);

parameter	m(i,u,p,rtype)	"Year-to-Date General Imports -- total value";
$gdxin 'imports_m.gdx'
$loaddc m

set	rg(*)	Regions and Groups;
rg(r) = yes;
rg(g) = yes;


execute_unload 'imports.gdx',i,r,g,rg,p,m;
