$title	Generate Gravity Calibration Datasets for Traded Sectors

$set gtapwindc_datafile ..\..\GTAPWiNDC\2017\gtapwindc\43_filtered.gdx

*	Faster -- just read the data:

$include ..\..\GTAPWiNDC\gtapwindc_data

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

parameter	tradecompare	Comparison of US trade;
loop(itrd(i),
	tradecompare(i,r,"e","gtap") = round(vxmd(i,"usa",r),1);
	tradecompare(i,r,"e","cenus") = round(sum(pd,trade(i,r,pd,"export")),1);
	tradecompare(i,r,"m","gtap") = round(
		vxmd(i,r,"usa")*pvxmd(i,r,"usa")+sum(j,vtwr(j,i,r,"usa"))*pvtwr(i,r,"usa"),1);
	tradecompare(i,r,"m","census") = round(sum(pd,trade(i,r,pd,"import")),1);
);
option tradecompare:1:2:2;
display tradecompare;

set	s_(s)	States (excluding rest);
s_(s) = yes$(not sameas(s,"rest"));

file kput; kput.lw=0; put kput;

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

parameter	thetam(i,ragg,pd)	Import shares
		thetax(i,pd,ragg)	Export shares;

thetam(itrd(i),ragg,pd)$sum(rmap(ragg,r),trade(i,r,pd,"import"))
	= sum(rmap(ragg,r),trade(i,r,pd,"import"))/
	    sum((rmap(ragg,r),pd.local),trade(i,r,pd,"import"));

thetax(itrd(i),pd,ragg)$sum(rmap(ragg,r),trade(i,r,pd,"export"))
	= sum(rmap(ragg,r),trade(i,r,pd,"export"))/
	    sum((rmap(ragg,r),pd.local),trade(i,r,pd,"export"));


parameter
	y0(s)		Reference output (data)
	z0(s)		Reference absorption (data)

*	Use m0,x0 here, but rename to md0,xs0 as input to gravity.gms:

	m0(ragg,pd)	Reference aggregate imports (data)
	x0(pd,ragg)	Reference aggregate exports (data)

loop(itrd(i),
	y0(s48(s)) = vom(i,"usa",s);
	m0(ragg,pd) = thetam(i,ragg,pd) * sum(rmap(ragg,r), 
		  vxmd(i,r,"usa")*pvxmd(i,r,"usa")+sum(j,vtwr(j,i,r,"usa"))*pvtwr(i,r,"usa") );
	x0(pd,ragg) = thetax(i,pd,ragg) * sum(rmap(ragg,r),vxmd(i,"usa",r));
	z0(s48(s)) = a0(i,"usa",s);
	put_utility 'gdxout' / 'datasets\',i.tl,'.gdx';
	execute_unload s48=s,pd,r,y0,z0,m0=md0,x0=xs0;
);
