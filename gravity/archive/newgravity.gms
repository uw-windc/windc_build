$set gtapwindc_datafile ..\GTAPWiNDC\2017\gtapwindc\43_filtered.gdx

set	seq /export,"export*",import,"import*", e_gtap, e_census, m_gtap, m_census/;

$include ..\GTAPWiNDC\gtapwindc_data
*.$include ..\GTAPWiNDC\gtapwindc_mge
*	Assume that land can move freely across sectors within each state:

option s:0:0:1;
display s;

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

etrae("lnd") = 8;

set	pd(*)	Port districts;

set		flow /	export, import /;

parameter	trade(i,r,pd,flow)	Trade data;
$gdxin 'tradedata\tradedata.gdx'

$load pd
$loaddc trade

option pd:0:0:1;
display pd;


set itrd(i)		Sectors with trade flows;
option itrd<trade;
itrd(itrd) = i(itrd);
option itrd:0:0:1;
display itrd;

set		loc /set.s, set.pd/;

parameter	dist(s,loc)	Distances from state to state or port;
$gdxin 'geography.gdx'
$load dist

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

parameter
	y0(s)		Reference output (data)
	d0(s)		Reference demand (data)
	m0(r,pd)	Reference aggregate imports (data)
	x0(pd,r)	Reference aggregate exports (data)

set	s_(s)	States (excluding rest);
s_(s) = yes$(not sameas(s,"rest"));

file kput; kput.lw=0; put kput;

parameter	thetam(i,r,pd)	Import shares
		thetax(i,pd,r)	Export shares;

thetam(itrd(i),r,pd)$trade(i,r,pd,"import")
	= trade(i,r,pd,"import")/sum(pd.local,trade(i,r,pd,"import"));
thetax(itrd(i),pd,r)$trade(i,r,pd,"export")
	= trade(i,r,pd,"export")/sum(pd.local,trade(i,r,pd,"export"));

parameter	chk;
chk(itrd(i),r,"m") = round(1 - sum(pd,thetam(i,r,pd)),3);
chk(itrd(i),r,"x") = round(1 - sum(pd,thetax(i,pd,r)),3);
display chk;

loop(itrd(i),
	y0(s48(s)) = vom(i,"usa",s);

	m0(r,pd) = thetam(i,r,pd) * 
		( vxmd(i,r,"usa")*pvxmd(i,r,"usa")+sum(j,vtwr(j,i,r,"usa"))*pvtwr(i,r,"usa") );

	x0(pd,r) = vxmd(i,"usa",r) * thetax(i,pd,r);

	d0(s48(s)) = a0(i,"usa",s);

	put_utility 'gdxout' / i.tl,'.gdx';
	execute_unload s48=s,pd,r,y0,d0,m0,x0,dist;
);
