$title	Canonical Template GTAP-WINDC Model (MGE format)

*	Read the data:

$if not set ds $set ds 43
$include ..\gtapwindc\gtapwindc_data

set	iag(i)			Agricultural sectors/ 
		pdr 	Paddy rice
		wht 	Wheat
		gro 	Cereal grains nec
		v_f 	"Vegetables, fruit, nuts"
		osd 	Oil seeds
		c_b 	"Sugar cane, sugar beet"
		pfb 	Plant-based fibers
		ocr 	Crops nec
		ctl 	"Bovine cattle, sheep, goats and horses"
		oap 	Animal products nec
		rmk 	Raw milk
		wol 	"Wool, silk-worm cocoons" /;

*	Alternative: gdp

$if not set metric $set metric output

*	Alternative: bilateral

$if not set model $set model recalib


set	pk_(f,r)	Capital market;
option pk_<ft_;

alias (s,ss);

parameter

*	Note: In the bilatgravity calculation we omit the
*	region index because our calculations only involve
*	the USA:

	yref(i,s)	State output (domestic + export),
	xref(i,s)	Exports,
	dref(i,s)	Supply to the domestic market,

	vdfm_(i,s,ss)	Intra-national trade,
	vifm_(i,s)	Imports,

*	Data structures for the model need to include the 
*	regional index:
	vdfm(i,r,s,ss)	Intra-national trade

	vifm(i,r,s)	Imports (gravity estimate)

*	Read revised tax rates which are used in the
*	gravity calculation to clean up profit conditions:

	rtd0_(i,r,s)	Benchmark tax rate on domestic demand
	rtm0_(i,r,s)	Benchmark tax rate on import demand

set	itrd(i)		Sectors with bilateral trade data;

*	Read these data from the PE calculation -- the GDX file contains
*	all parameters so we can retrieve additional symbols if needed.

$gdxin 'bilatgravity.gdx'
$load itrd yref xref dref 

*	Rename these parameters so that we can add the region index and/or avoid
*	overwriting values already in the database:
 
$load vdfm_=vdfm vifm_=vifm rtd0_=rtd0 rtm0_=rtm0

*	Populate parameters for the bilateral national model:

vdfm(itrd(i),"usa",s,ss) = vdfm_(i,s,ss);
vifm(itrd(i),"usa",s) = vifm_(i,s);

rtd(itrd(i),"usa",s) = rtd0_(i,"usa",s);
rtm(itrd(i),"usa",s) = rtm0_(i,"usa",s);

rtd0(itrd(i),"usa",s) = rtd0_(i,"usa",s);
rtm0(itrd(i),"usa",s) = rtm0_(i,"usa",s);

*	Do the ATM calculation for the model based on 
*	a pooled national market.

singleton set	re(r)			Region to evaluate /usa/;

sets	is(i,s)			Content to evaluate,
	samesector(i,s,i,s)	Sector identifier;

alias (s,ss);

parameter	v_P(i,   j,ss)	"Value-added content of Y(j,ss) in P(i)",
		v_PN(i,  j,ss)  "Value-added content of Y(j,ss) in PN(i)",
		v_PZ(i,s,j,ss)	"Value-added content of Y(j,ss) in PZ(i,s)",
		v_PY(i,s,j,ss)	"Value-added content of Y(j,ss) in PY(i,s)",
		v_PYn(i,s,j,ss)	"Updated estimate of v_PY";

set		iter /iter1*iter10/;

parameter	iterlog(iter,*)	Iteration log
		dev		Deviation,
		atm(i,s,iag)	Export content,
		content(i,r,s)	Sectoral content (output or VA);

$if %metric%==gdp	content(i,re(r),s) = rto(i,r)*vom(i,r,s)+sum(f,vfm(f,i,r,s)*(1+rtf0(f,i,r)));
$if %metric%==output	content(i,re(r),s) = vom(i,r,s);

file	kcon /"con:"/; kcon.lw=0; put kcon;

$goto %model%


$label recalib

loop(re(r),

*	Recalibrate the pooled model dataset based on the bilateral model flows:

	ns0(itrd(i),r,s) = sum(ss,vdfm(i,r,s,ss));
	nd0(itrd(i),r,s) = sum(ss,vdfm(i,r,ss,s)) - vdfm(i,r,s,s);
	md0(itrd(i),r,s) = vifm(i,"usa",s);
	xs0(itrd(i),r,s) = xref(i,s);
	vnm(itrd(i),r) = sum(s,ns0(i,r,s));

*	Track content of all sectors which have nonzero production:

	is(i,s) = yes$content(i,re,s);
	samesector(is,is) = yes;

*	Initial assigment -- direct content:

	v_PY(i,s,is)$y_(i,r,s) = content(i,r,s)$samesector(i,s,is)/vom(i,r,s);

	dev = 1;
	loop(iter$round(dev,2),
		v_P(i,is)$x_(i,r)  = sum(s,xs0(i,r,s)*v_PY(i,s,is))/vxm(i,r);
		v_PN(i,is)$n_(i,r) = sum(s,ns0(i,r,s)*v_PY(i,s,is))/vnm(i,r);
		v_PZ(i,s,is)$z_(i,r,s) = (nd0(i,r,s)*v_PN(i,is))/a0(i,r,s);
		v_PYn(i,s,is)$y_(i,r,s) = (sum(j, vafm(j,i,r,s)*v_PZ(j,s,is)) + 
					           content(i,r,s)$samesector(i,s,is) )/vom(i,r,s);
		dev = sum((i,s,is)$y_(i,r,s), abs(v_PYn(i,s,is)-v_PY(i,s,is)));
		v_PY(i,s,is)$y_(i,r,s) = v_PYn(i,s,is);
		iterlog(iter,"dev") = dev;
		putclose iter.tl,dev/;
	);

        atm(is(i,s),iag) = v_P(iag,is);
);
display iterlog;

$exit

);

$label pooled

loop(re(r),

*	Track content of all sectors which have nonzero production:

	is(i,s) = yes$content(i,re,s);
	samesector(is,is) = yes;

*	Initial assigment -- direct content:

	v_PY(i,s,is)$y_(i,r,s) = content(i,r,s)$samesector(i,s,is)/vom(i,r,s);

	dev = 1;
	loop(iter$round(dev,2),
		v_P(i,is)$x_(i,r)  = sum(s,xs0(i,r,s)*v_PY(i,s,is))/vxm(i,r);
		v_PN(i,is)$n_(i,r) = sum(s,ns0(i,r,s)*v_PY(i,s,is))/vnm(i,r);
		v_PZ(i,s,is)$z_(i,r,s) = (nd0(i,r,s)*v_PN(i,is))/a0(i,r,s);
		v_PYn(i,s,is)$y_(i,r,s) = (sum(j, vafm(j,i,r,s)*v_PZ(j,s,is)) + 
					           content(i,r,s)$samesector(i,s,is) )/vom(i,r,s);
		dev = sum((i,s,is)$y_(i,r,s), abs(v_PYn(i,s,is)-v_PY(i,s,is)));
		v_PY(i,s,is)$y_(i,r,s) = v_PYn(i,s,is)$y_(i,r,s);
		iterlog(iter,"dev") = dev;
		putclose iter.tl,dev/;
	);

        atm(is(i,s),iag) = v_P(iag,is);
);
display iterlog;

$exit

$label bilateral

loop(re(r),

*	Track content of all sectors which have nonzero production:

	is(i,s) = yes$content(i,re,s);
	samesector(is,is) = yes;

*	Initial assigment -- based on pooled model content:

	v_PY(i,s,is)$y_(i,r,s) = content(i,r,s)$samesector(i,s,is)/vom(i,r,s);

	dev = 1;
	loop(iter,
		v_P(i,is)$x_(i,r)  = sum(s,xref(i,s)*v_PY(i,s,is))/vxm(i,r);
		v_PZ(i,s,is)$z_(i,r,s) = sum(ss,v_PY(i,ss,is)*vdfm(i,r,ss,s))/a0(i,r,s);
		v_PYn(i,s,is)$y_(i,r,s) = (sum(j, vafm(j,i,r,s)*v_PZ(j,s,is)) + 
				content(i,r,s)$samesector(i,s,is) )/vom(i,r,s);
		dev = sum((i,s,is)$y_(i,r,s), abs(v_PYn(i,s,is)-v_PY(i,s,is)));
		v_PY(i,s,is)$y_(i,r,s) = v_PYn(i,s,is)$y_(i,r,s);
		iterlog(iter,"dev") = dev;
		putclose iter.tl,dev/;
	);

        atm(is(i,s),iag) = v_P(iag,is);
);
display iterlog;
