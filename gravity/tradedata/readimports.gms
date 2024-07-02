$title	Use CENSUS API to Read Imports by Port at HS6 Level

$goto csv2gdx

*	This is my Census API key:

$set key e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e
$log Downloading import data.

$ontext

Requested columns:

	1 "I_COMMODITY"
	2 "I_COMMODITY_SDESC"
	3 "CTY_CODE"
	4 "CTY_NAME"
	5 "PORT"
	6 "PORT_NAME"
	7 "GEN_VAL_YR"
	8 "YEAR"		2017
	9 "MONTH"		12
	10 "COMM_LVL"		HS6
	11 "SUMMARY_LVL"

$offtext


$if not exist imports.csv $call curl -o imports.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=%key%&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"

$log	You need to edit import.csv
$log.
$log	Replace "],^J[" by "^J" and "[[" by "" and "]]" by ""

$call pause

$label csv2gdx

$if not exist import_m.gdx $call csv2gdx imports.csv output=import_m.gdx  id=m index=(1,3,5,11) autorow=r value=7 useheader=y fieldsep=comma 
$if not exist import_i.gdx $call csv2gdx imports.csv output=import_i.gdx id=i index=1 autorow=r text=2 useheader=y 
$if not exist import_r.gdx $call csv2gdx imports.csv output=import_r.gdx id=r index=3 autorow=r text=4 useheader=y 
$if not exist import_p.gdx $call csv2gdx imports.csv output=import_p.gdx id=p index=5 autorow=r text=6 useheader=y 

set	ri(*)	Row index
	ii(*)	Indices
	rr(*)	Country
	pp(*)	Port
	r_(ri<,rr<)	Country
	p_(ri,pp<)	Port
	i_(ri,ii<)	Commodity;


$gdxin import_r.gdx
$load r_=r

$gdxin import_i.gdx
$load i_=i

$gdxin import_p.gdx
$load p_=p

set	rtype /	cgp	Set r is a country grouping
		det	Set r is an individual country /;

parameter	m_(ri,ii,rr,pp,rtype)	"Year-to-Date General Imports -- Total Value";

$gdxin import_m.gdx
$loaddc m_=m

set	i(*)	Commodities,
	p(*)	Ports,
	r(*)	Countries;

i(ii) = no;
p(pp) = no;
r(rr) = no;
loop(i_(ri,ii)$(not i(ii)),
	i(ii) = i_(ri,ii);
);
loop(p_(ri,pp)$(not p(pp)),
	p(pp) = p_(ri,pp);
);
loop(r_(ri,rr)$(not r(rr)),
	r(rr) = r_(ri,rr);
);

option i:0:0:1, p:0:0:1, r:0:0:1;
display i, p, r;

set	j(ii,rr,pp,rtype)	Index mapping;
option j<m_;

parameter	nz(ii,rr,pp,rtype);
nz(j) = sum(ri$m_(ri,j),1) - 1;
option nz:0:0:1;
display nz;

set	rij(ri,ii,rr,pp,rtype);
option rij<m_;

parameter	m(ii,rr,pp,rtype)	"Year-to-Date General Imports -- Total Value";

loop(rij(ri,j),	m(j) = m_(ri,j););

execute_unload 'imports.gdx',i,r,p,m;
