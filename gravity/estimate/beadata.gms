$title	Generate Gravity Calibration Datasets for Traded Sectors

$set gtapwindc_datafile ..\..\GTAPWiNDC\2017\gtapwindc\43_filtered.gdx

*	Faster -- just read the data:

$include ..\..\GTAPWiNDC\gtapwindc_data

option r:0:0:1;
display r;
$exit

*	More defensive -- verify that the dataset is balanced:
*.$include ..\..\GTAPWiNDC\gtapwindc_mge

*	Generate datasets for the lower 48 and DC:

set	s48(s) /
	AL    Alabama
	AR    Arizona
	AZ    Arkansas
	CA    California
	CO    Colorado
	CT    Connecticut
	DE    Delaware
	DC    District of Columbia
	FL    Florida
	GA    Georgia
	ID    Idaho
	IL    Illinois
	IN    Indiana
	IA    Iowa
	KS    Kansas
	KY    Kentucky
	LA    Louisiana
	ME    Maine
	MD    Maryland
	MA    Massachusetts
	MI    Michigan
	MN    Minnesota
	MS    Mississippi
	MO    Missouri
	MT    Montana
	NE    Nebraska
	NV    Nevada
	NH    New Hampshire
	NJ    New Jersey
	NM    New Mexico
	NY    New York
	NC    North Carolina
	ND    North Dakota
	OH    Ohio
	OK    Oklahoma
	OR    Oregon
	PA    Pennsylvania
	RI    Rhode Island
	SC    South Carolina
	SD    South Dakota
	TN    Tennessee
	TX    Texas
	UT    Utah
	VT    Vermont
	VA    Virginia
	WA    Washington
	WV    West Virginia
	WI    Wisconsin
	WY    Wyoming /;

set	pd(*)	Port districts;

set	flow /	export, import /;

parameter	trade(i,r,pd,flow)	Trade data;
$gdxin '..\tradedata\tradedata.gdx'
$load pd
$loaddc trade
option pd:0:0:1;
display pd;


set itrd(i)		Sectors with trade flows;
option itrd<trade;
itrd(itrd) = i(itrd);
option itrd:0:0:1;
display itrd;

set	gdata /	e0	Exports (total)
		m0	Imports (total)
		y0	Production (state)
		d0	Demand (state) /,

	yr(*)	Years with BEA data
	gb(*)	BEA goods;

parameter	gravitydata(yr<,gb<,*,gdata)	Benchmark data for the gravity estimation;

$gdxin 'd:\GitHub\windc_build\statedata\gravitydata.gdx'
$load gravitydata

set	trdmap(gb,i)	Trade map;
$load trdmap
option trdmap:0:0:1;
display trdmap;

$ifthen.aggregate %aggregate%==yes

set	ragg	Aggregate regions (to create smaller model) /
		CHN  China and Hong Kong
		CAN  Canada
		USA  United States
		MEX  Mexico
		EUR  Europe
		OEC  Other OECD
		ROW  Rest of world /;
		
set	rmap(ragg,r) /
	CHN.CHN  China and Hong Kong
	CAN.CAN  Canada
	USA.USA  United States
	MEX.MEX  Mexico
	EUR.(FRA, DEU, ITA, GBR, REU)
	OEC.(JPN,KOR,ANZ,TUR),
	ROW.(IDN, IND, ARG, BRA, RUS, SAU, ZAF, OEX, LIC, MIC) /;

$else.aggregate
alias (ragg,r);
set	rmap(ragg,r); rmap(r,r) = yes;
$endif.aggregate

parameter	thetam(i,ragg,pd)	Import shares
		thetax(i,pd,ragg)	Export shares
		tottrade(i,*)	Total trade;

tottrade(itrd(i),"import") = sum((rmap(ragg,r),pd),trade(i,r,pd,"import"));

thetam(itrd(i),ragg,pd)$tottrade(i,"import") = 
	sum(rmap(ragg,r),trade(i,r,pd,"import")) / tottrade(i,"import");

tottrade(itrd(i),"export") = sum((rmap(ragg,r),pd),trade(i,r,pd,"export"));

thetax(itrd(i),pd,ragg)$tottrade(i,"export") = 
	sum(rmap(ragg,r),trade(i,r,pd,"export")) / tottrade(i,"export");

set	i_ragg(i,ragg);

parameter	thetachk;
option i_ragg<thetam;
thetachk(itrd(i),"m") = sum((i_ragg(i,ragg),pd),thetam(i,ragg,pd)) - 1;
option i_ragg<thetax;
thetachk(itrd(i),"x") = sum((pd,i_ragg(i,ragg)),thetax(i,pd,ragg)) - 1;
option thetachk:3:1:1;
display thetachk;

parameter
	y0(yr,gb,s)		Reference output (data)
	z0(yr,gb,s)		Reference absorption (data)
	m0(yr,gb,ragg,pd)	Reference aggregate imports (data)
	x0(yr,gb,pd,ragg)	Reference aggregate exports (data);

loop((yr,trdmap(gb,itrd(i))),
	y0(yr,gb,s48(s)) = gravitydata(yr,gb,s,"y0");
	m0(yr,gb,ragg,pd) = thetam(i,ragg,pd) * gravitydata(yr,gb,"total","m0");
	x0(yr,gb,pd,ragg) = thetax(i,pd,ragg) * gravitydata(yr,gb,"total","e0");
	z0(yr,gb,s48(s)) = gravitydata(yr,gb,s,"d0");
);


$if not dexist datasets $call mkdir datasets
execute_unload 'datasets\bea.gdx',ragg=r,s48=s,pd,yr,gb=g,y0,m0=md0,x0=xs0,z0;

