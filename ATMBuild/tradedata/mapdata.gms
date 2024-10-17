$title	Aggregate the Trade Data to Allign with GTAPWiNDC 

$call 'gams countrycodes gdx=countrycodes'

set	r(*)		All regions in cty_code
	rg20(*)		Regions in the GTAPWiNDC dataset
	rmap(r,rg20)	Mapping from r to rg20;

$gdxin 'countrycodes.gdx'
$load r=cty_code rg20
$loaddc rmap

$call 'gams commoditycodes gdx=commoditycodes'

set	hs6(*)		Commodity codes for traded goods,
	i43(*)		Sectors in the GTAPWiNDC dataset
	imap(hs6,i43)	Mapping from hs6 to i43;

$gdxin 'commoditycodes.gdx'
$load hs6 i43
$loaddc imap

$call 'gams portcodes gdx=portcodes'

set	p(*)		Ports in the lower 48,
	pd(*)		Port districts
	pmap(p,pd)	Mapping from p to pd;

$gdxin 'portcodes.gdx'
$load p pd
$loaddc pmap

alias (i,hs6)

set	rtype /	det	Set r is an individual country (set r) /;

*	Ignore data in aggregated regions:

*		cgp	Set r is a country grouping (set g)

parameter	m(i,r,p,rtype),
		x(i,r,p,rtype);

$gdxin 'exports.gdx'
$load x

$gdxin 'imports.gdx'
$load m

set		flow /	export, import /;

set	k(i,r,p);

set	j(i43,rg20,pd);

set	jk(i43,rg20,pd,i,r,p);

parameter	trade(i43,rg20,pd,flow)	Port-District Trade Flows;

option k<x;
jk(i43,rg20,pd,k(i,r,p)) = imap(i,i43) and rmap(r,rg20) and pmap(p,pd);
option j<jk;
trade(j,"export") = sum(jk(j,k),x(k,"det"))/1e9;
option clear=jk;

option k<m;
jk(i43,rg20,pd,k(i,r,p)) = imap(i,i43) and rmap(r,rg20) and pmap(p,pd);
option j<jk;
trade(j,"import") = sum(jk(j,k),m(k,"det"))/1e9;
option trade:3:3:1;
display trade;

execute_unload 'rawdata.gdx', trade, i43, rg20, pd;

$exit

execute 'gdxxrw i=rawdata.gdx o=trade.xlsx par=trade rng=PivotData!a2 cdim=0';

parameter	pdsize(pd,*)	Port size;
pdsize(pd,flow) = sum((i43,rg20),trade(i43,rg20,pd,flow));
pdsize(pd,"total") = sum(flow,pdsize(pd,flow));
display pdsize;