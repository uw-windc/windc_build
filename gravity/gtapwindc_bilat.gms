$title	Canonical Template GTAP-WINDC Model (MGE format)

*	Read the data:

$if not set ds $set ds 43

$include ..\gtapwindc\gtapwindc_data

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

*	These symbols only enter the regions with bilateral national
*	markets:

vdfm(i,r,s,ss)	= 0;
vifm(i,r,s)	= 0;

parameter	chk		Cross check on PE calculations;

*	Aggregate supply equals exports plus domestic supply:

chk(s,itrd(i)) = round(yref(i,s) - xref(i,s) - dref(i,s),3);
abort$card(chk) "Error: yref deviation:", chk;

*	Domestic supply in state s equals bilateral sales from
*	state s to all other states ss:

chk(s,itrd(i)) = round(dref(i,s) - sum(ss,vdfm_(i,s,ss)),3);
abort$card(chk) "Error: dref deviation:", chk;

*	Gross output in the PE calculation equals gross output in the 
*	GE database:

chk(s,itrd(i)) = round(yref(i,s) - vom(i,"usa",s),3);
abort$card(chk) "Error: yref deviation:",chk;
	
*	Aggregate absorpotion of commodity i in state s in the GE database (a0)
*	equals aggregate imports from other states and from abroad (vdfm_, vifm_,
*	rtd0_, and rtm0_ from the PE calculation):

chk(s,itrd(i)) = round(a0(i,"usa",s) - sum(ss,vdfm_(i,ss,s))*(1+rtd0_(i,"usa",s)) - vifm_(i,s)*(1+rtm0_(i,"usa",s)),3);
abort$card(chk) "Error: a0<>vdfm+vifm:", chk;


parameter trdchk	Cross check on imports;

*	GE database balance of imports gross of tax equals the demand for 
*	imports across all sectors:

trdchk(itrd(i),"vim<>md0")  = round(vim(i,"usa") - sum(s,md0(i,"usa",s)),3);

*	Consistency of gross imports in the GE and PE data:

trdchk(itrd(i),"vim<>vifm") = round(vim(i,"usa") - sum(s,vifm_(i,s)),3);

*	Aggregate exports in the GE dataset (vxm) equals the sum of imputed exports
*	at the state level in the PE model (xref):

trdchk(itrd(i),"vxm<>xref") = round(vxm(i,"usa") - sum(s,xref(i,s)),3);
abort$card(trdchk) "Imbalance in trade accounts:", trdchk;

set	pnm(i,r)	Pooled national market,
	bnm(i,r)	Bilateral national market;

$ontext
$model:gtapwindc

$sectors:
	Y(g,r,s)$y_(g,r,s)		  ! Production (includes I and G)
	X(i,r)$x_(i,r)			  ! Export demand
	N(i,r)$(pnm(i,r) and n_(i,r))	  ! National market demand (omitted in the bilateral model)
	Z(i,r,s)$z_(i,r,s)		  ! Armington demand
	C(r,s,h)$c_(r,s,h)		  ! Consumption 
	FT(sf,r)$pk_(sf,r)		  ! Specific factor transformation
	FTS(sf,r,s)$evom(sf,r,s)	  ! Specific factor transformation -- state level
	M(i,r)$m_(i,r)			  ! Import
	YT(j)$yt_(j)			  ! Transport

$commodities:
	PY(g,r,s)$py_(g,r,s)		  ! Output price
	PZ(i,r,s)$pz_(i,r,s)		  ! Armington composite price
	PN(i,r)$(pnm(i,r) and pn_(i,r))	  ! National market price (omitted in the bilateral model)
	P(i,r)$p_(i,r)			  ! Export market price
	PC(r,s,h)$pc_(r,s,h)		  ! Consumption price 
	PL(mf,r,s)$pf_(mf,r,s)		  ! Wage income
	PKS(sf,r,s)$evom(sf,r,s)	  ! Capital price by state
	PK(sf,r)$pk_(sf,r)		  ! Capital income
	PS(f,g,r,s)$ps_(f,g,r,s)	  ! Sector-specific primary factors
	PM(i,r)$pm_(i,r)		  ! Import price
	PT(j)$pt_(j)			  ! Transportation services

$consumers:
	RH(r,s,h)$rh_(r,s,h)		  ! Representative household
	GOVT(r)				  ! Public expenditure
	INV(r)				  ! Investment

$prod:Y(g,r,s)$y_(g,r,s) s:0  va:esubva(g) 
	o:PY(g,r,s)	q:vom(g,r,s)	a:GOVT(r) t:rto(g,r)
	i:PZ(i,r,s)	q:vafm(i,g,r,s)	
	i:PS(sf,g,r,s)	q:vfm(sf,g,r,s)  p:(1+rtf0(sf,g,r))  va: a:GOVT(r) t:rtf(sf,g,r)
	i:PL(mf,r,s)	q:vfm(mf,g,r,s)  p:(1+rtf0(mf,g,r))  va: a:GOVT(r) t:rtf(mf,g,r)

*	Export:

$prod:X(i,r)$x_(i,r)  s:esubx(i)
	o:P(i,r)		q:vxm(i,r)
	i:PY(i,r,s)$pnm(i,r)	q:xs0(i,r,s)
	i:PY(i,r,s)$bnm(i,r)	q:xref(i,s)

*	Supply to the domestic market:

$prod:N(i,r)$(pnm(i,r) and n_(i,r))  s:esubn(i)
	o:PN(i,r)	q:vnm(i,r)
	i:PY(i,r,s)	q:ns0(i,r,s)

*	Pooled national market:

$prod:Z(i,r,s)$(pnm(i,r) and z_(i,r,s))  s:esubdm(i)  nm:(2*esubdm(i))
	o:PZ(i,r,s)	q:a0(i,r,s)
	i:PY(i,r,s)	q:yl0(i,r,s)	a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s))
	i:PN(i,r)	q:nd0(i,r,s)	a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s)) nm:
	i:PM(i,r)	q:md0(i,r,s)	a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s)) nm:

*	Bilateral national model:

$prod:Z(i,r,s)$(bnm(i,r) and z_(i,r,s))  s:esubdm(i)  nm:(2*esubdm(i))  mm(nm):(4*esubdm(i))
	o:PZ(i,r,s)	q:a0(i,r,s)
	i:PY(i,r,ss)	q:vdfm(i,r,ss,s) a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s))  nm:$sameas(s,ss) mm:$(not sameas(s,ss))
	i:PM(i,r)	q:vifm(i,r,s)	 a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s))

$prod:FT(sf,r)$pk_(sf,r)  t:0
	o:PKS(sf,r,s)	q:evom(sf,r,s)
	i:PK(sf,r)	q:(sum(s,evom(sf,r,s)))

$prod:FTS(sf,r,s)$evom(sf,r,s)  t:etrae(sf)
	o:PS(sf,g,r,s)	q:vfm(sf,g,r,s)   
	i:PKS(sf,r,s)	q:evom(sf,r,s)

$prod:C(r,s,h)$c_(r,s,h)  s:1
	o:PC(r,s,h)	q:c0(r,s,h)	
	i:PZ(i,r,s)	q:cd0(i,r,s,h)  

*	---------------------------------------------------------------------------
*	These activities are unchanged from the GTAP model:

$prod:M(i,r)$m_(i,r)	s:esubm(i)  rr.tl:0
	o:PM(i,r)	q:vim(i,r)
	i:P(i,rr)	q:vxmd(i,rr,r)	p:pvxmd(i,rr,r) rr.tl:
+		a:GOVT(rr) t:(-rtxs(i,rr,r))	
+		a:GOVT(r)  t:(rtms(i,rr,r)*(1-rtxs(i,rr,r)))
	i:PT(j)#(rr)	q:vtwr(j,i,rr,r) p:pvtwr(i,rr,r) rr.tl: 
+		a:GOVT(r)  t:rtms(i,rr,r)

$prod:YT(j)$yt_(j)  s:1
	o:PT(j)		q:vtw(j)
	i:P(j,r)	q:vst(j,r)

*	---------------------------------------------------------------------------
*	Final demand -- these based on data coming from the WiNDC database:

$demand:RH(r,s,h)$rh_(r,s,h)  
	d:PC(r,s,h)			q:c0(r,s,h)
	e:PL(mf,r,s)			q:evomh(mf,r,s,h)
	e:PK(sf,r)$pk_(sf,r)		q:evomh(sf,r,s,h)
	e:PKS(sf,r,s)$(not pk_(sf,r))	q:evomh(sf,r,s,h)
	e:PC(rnum,"rest","rest")	q:(-sav0(r,s,h)+sum(trn,hhtrn0(r,s,h,trn)))

$demand:GOVT(r)
	d:PY("g",r,s)			q:vom("g",r,s)
	e:PC(rnum,"rest","rest")	q:(-sum((rh_(r,s,h),trn),hhtrn0(r,s,h,trn)))

$demand:INV(r)
	d:PY("i",r,s)			q:vom("i",r,s)
	e:PC(rnum,"rest","rest")	q:(vb(r)+sum(rh_(r,s,h),sav0(r,s,h)))

$offtext
$sysinclude mpsgeset gtapwindc

gtapwindc.workspace = 1024;
gtapwindc.iterlim = 0;

*	All markets are pooled in the original GTAPWiNDC dataset:
pnm(i,r) = yes;
bnm(i,r) = no;

*	Replicate: %replicate%

$if "%replicate%"=="no" $exit

gtapwindc.iterlim = 100000;
$include gtapwindc.gen
solve gtapwindc using mcp;

$exit

*	Replication for the national market model:

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

*	Not included in trade data:
*.		rmk 	Raw milk

		wol 	"Wool, silk-worm cocoons" /;

set	notrd(i);
notrd(iag(i)) = not itrd(i);
display notrd;

*	Populate parameters for the bilateral national model:

vdfm(itrd(i),"usa",s,ss) = vdfm_(i,s,ss);
vifm(itrd(i),"usa",s) = vifm_(i,s);

parameter	vomchk;
loop(r$sameas(r,"usa"),
	yl0(itrd(i),r,s) = vdfm(i,r,s,s);
	ns0(itrd(i),r,s) = sum(ss,vdfm(i,r,s,ss))-vdfm(i,r,s,s);
	nd0(itrd(i),r,s) = sum(ss,vdfm(i,r,ss,s)) - vdfm(i,r,s,s);
	md0(itrd(i),r,s) = vifm(i,"usa",s);
	xs0(itrd(i),r,s) = xref(i,s);
	vnm(itrd(i),r) = sum(s,ns0(i,r,s));
	vomchk(s,itrd(i))$y_(i,r,s) = round(vom(i,r,s) - xs0(i,r,s) - yl0(i,r,s) - ns0(i,r,s),3);
);
display vomchk;

*	Benchmark replication with the bilateral trade model:

rtd(itrd(i),"usa",s) = rtd0_(i,"usa",s);
rtm(itrd(i),"usa",s) = rtm0_(i,"usa",s);

rtd0(itrd(i),"usa",s) = rtd0_(i,"usa",s);
rtm0(itrd(i),"usa",s) = rtm0_(i,"usa",s);

$include gtapwindc.gen
solve gtapwindc using mcp;


$exit

chk(s,itrd(i)) = round(a0(i,"usa",s) - sum(ss,vdfm_(i,ss,s))*(1+rtd0_(i,"usa",s)) - vifm_(i,s)*(1+rtm0_(i,"usa",s)),3);
abort$card(chk) "Error: a0<>vdfm+vifm:", chk;

chk(s,itrd(i)) = round(a0(i,"usa",s) - (yl0(i,"usa",s)+nd0(i,"usa",s))*(1+rtd(i,"usa",s)) - md0
abort$card(chk) "Error: a0<>vdfm+vifm:", chk;

$exit




*	Benchmark replication with the bilateral trade model:

rtd(itrd(i),"usa",s) = rtd0_(i,"usa",s);
rtm(itrd(i),"usa",s) = rtm0_(i,"usa",s);

rtd0(itrd(i),"usa",s) = rtd0_(i,"usa",s);
rtm0(itrd(i),"usa",s) = rtm0_(i,"usa",s);



bnm(itrd(i),"usa") = yes;
pnm(itrd(i),"usa") = no;

$include gtapwindc.gen
solve gtapwindc using mcp;


$exit

set	rb(r) /usa/;

set	macct	Macro accounts /
		C	Household consumption,
		G	Public expenditure
		T	Tax revenue
		I	Investment
		L	Labor income
		K	Capital income
		F	Foreign savings
		GDP	"Gross domestic product (C+I+G-B)"
		"GDP*"	"Gross domestic product (K+L+T)"/;
		

parameter	incomechk;
incomechk(r) = sum((s,h),c0(r,s,h)) + sum(s,vom("g",r,s) + vom("i",r,s)) 
	- sum((f,s,h),evomh(f,r,s,h))
	- vb(r) 
	- (	  sum((i,rr), rtms(i,rr,r)*((1-rtxs(i,rr,r))*vxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))) - rtxs(i,r,rr)*vxmd(i,r,rr))
		+ sum((i,s), rtd(i,r,s)*(xd0(i,r,s)+nd0(i,r,s)) + rtm(i,r,s)*md0(i,r,s))
		+ sum((f,g), rtf(f,g,r)*sum(s,vfm(f,g,r,s)))
		+ sum(g, rto(g,r)*sum(s,vom(g,r,s))) );
display incomechk;

set lf(f) /mgr,tec,clk,srv,lab/, kf(f)/cap,lnd,res/;

parameter	macroaccounts(macct,*)	Macro economic accounts;
loop(rb(r),
	macroaccounts("C","$") = sum((s,h),c0(r,s,h));
	macroaccounts("G","$") = sum(s,vom("g",r,s));
	macroaccounts("I","$") = sum(s,vom("i",r,s));
	macroaccounts("L","$") = sum((lf(f),s,h),evomh(lf,r,s,h));
	macroaccounts("K","$") = sum((kf(f),s,h),evomh(kf,r,s,h));
	macroaccounts("F","$") = vb(r);
	macroaccounts("T","$") =  sum((i,rr), rtms(i,rr,r)*((1-rtxs(i,rr,r))*vxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))) - rtxs(i,r,rr)*vxmd(i,r,rr))
				+ sum((i,s), rtd(i,r,s)*(xd0(i,r,s)+nd0(i,r,s)) + rtm(i,r,s)*md0(i,r,s))
				+ sum((f,g), rtf(f,g,r)*sum(s,vfm(f,g,r,s)))
				+ sum(g, rto(g,r)*sum(s,vom(g,r,s)));

	macroaccounts("GDP","$") = macroaccounts("C","$") + macroaccounts("G","$") + macroaccounts("I","$") - macroaccounts("F","$");
	macroaccounts("GDP*","$") = macroaccounts("L","$") + macroaccounts("K","$") + macroaccounts("T","$");
);
macroaccounts("C","%GDP") = 100 * macroaccounts("C","$") / macroaccounts("GDP","$");
macroaccounts("G","%GDP") = 100 * macroaccounts("G","$") / macroaccounts("GDP","$");
macroaccounts("I","%GDP") = 100 * macroaccounts("I","$") / macroaccounts("GDP","$");
macroaccounts("L","%GDP") = 100 * macroaccounts("L","$") / macroaccounts("GDP","$");
macroaccounts("K","%GDP") = 100 * macroaccounts("K","$") / macroaccounts("GDP","$");
macroaccounts("F","%GDP") = 100 * macroaccounts("F","$") / macroaccounts("GDP","$");

option macct:0:0:1;
option macroaccounts:3;
display macroaccounts macct;
