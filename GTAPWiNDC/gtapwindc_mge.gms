$title	Canonical Template GTAP-WINDC Model (MGE format)

*	Read the data:

$if not set ds $set ds 43

$if not defined y_ $include %system.fp%gtapwindc_data

set	pk_(f,r)	Capital market;
pk_(sf,r) = sum(s,evom(sf,r,s));

$ontext
$model:gtapwindc

$sectors:
	Y(g,r,s)$y_(g,r,s)		  ! Production (includes I and G)
	X(i,r)$x_(i,r)			  ! Export demand
	N(i,r)$n_(i,r)			  ! National market demand
	Z(i,r,s)$z_(i,r,s)		  ! Armington demand
	C(r,s,h)$c_(r,s,h)		  ! Consumption 
	FT(sf,r)$pk_(sf,r)		  ! Specific factor transformation
	FTS(sf,r,s)$evom(sf,r,s)		  ! Specific factor transformation -- state level
	M(i,r)$m_(i,r)			  ! Import
	YT(j)$yt_(j)			  ! Transport

$commodities:
	PY(g,r,s)$py_(g,r,s)		  ! Output price
	PZ(i,r,s)$pz_(i,r,s)		  ! Armington composite price
	PN(i,r)$pn_(i,r)		  ! National market price
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
	o:P(i,r)	q:vxm(i,r)
	i:PY(i,r,s)	q:xs0(i,r,s)

*	Supply to the domestic market:

$prod:N(i,r)$n_(i,r)  s:esubn(i)
	o:PN(i,r)	q:vnm(i,r)
	i:PY(i,r,s)	q:ns0(i,r,s)

$prod:Z(i,r,s)$z_(i,r,s)  s:esubdm(i)
	o:PZ(i,r,s)	q:a0(i,r,s)
	i:PN(i,r)	q:nd0(i,r,s)	a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s)) 
	i:PM(i,r)	q:md0(i,r,s)	a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s)) 

$prod:FT(sf,r)$pk_(sf,r)  t:0
	o:PKS(sf,r,s)	q:evom(sf,r,s)
	i:PK(sf,r)	q:(sum(s,evom(sf,r,s)))

$prod:FTS(sf,r,s)$evom(sf,r,s)
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
	e:PK(sf,r)			q:evomh(sf,r,s,h)
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

parameter	chk_PG;
chk_PG("vom") = sum(r$sameas(r,"usa"),
			sum(s$(not sameas(s,"rest")), vom("g",r,s)));
chk_PG("rtxs") = sum(r$sameas(r,"usa"),
			-sum((i,rr),	rtxs(i,r,rr)*vxmd(i,r,rr)));
chk_PG("rtms") = sum(r$sameas(r,"usa"),
			sum(m_(i,rr),		rtms(i,rr,r)*(sum(j,vtwr(j,i,rr,r))+(1-rtxs(i,rr,r))*vxmd(i,rr,r))));
chk_PG("rtd") = sum(r$sameas(r,"usa"),
			sum(z_(i,r,s),	rtd(i,r,s) * nd0(i,r,s) + rtm(i,r,s)*md0(i,r,s)));
chk_PG("rto") = sum(r$sameas(r,"usa"),
			sum((g,s),		rto(g,r)   * vom(g,r,s)));
chk_PG("rtf") = sum(r$sameas(r,"usa"),
			sum((f,y_(g,r,s)),	rtf(f,g,r) * vfm(f,g,r,s)));
chk_PG("hhtrn0") = sum(r$sameas(r,"usa"),
			sum((rh_(r,s,h),trn), hhtrn0(r,s,h,trn)));

chk_PG("chk") = sum(r$sameas(r,"usa"),
			sum(s$(not sameas(s,"rest")), vom("g",r,s))
			- ( -sum((i,rr),	rtxs(i,r,rr)*vxmd(i,r,rr))
			+ sum(m_(i,rr),		rtms(i,rr,r)*(sum(j,vtwr(j,i,rr,r))+(1-rtxs(i,rr,r))*vxmd(i,rr,r)))
			+ sum(z_(i,r,s),	rtd(i,r,s) * nd0(i,r,s) + rtm(i,r,s)*md0(i,r,s))
			+ sum((g,s),		rto(g,r)   * vom(g,r,s))
			+ sum((f,y_(g,r,s)),	rtf(f,g,r) * vfm(f,g,r,s))
			- sum((rh_(r,s,h),trn), hhtrn0(r,s,h,trn))));
option chk_PG:3:0:1;
display chk_PG;

*	Assume that land can move freely across sectors within each state:

etrae("lnd") = 8;

$include gtapwindc.gen
solve gtapwindc using mcp;

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
		+ sum((i,s), rtd(i,r,s)*nd0(i,r,s) + rtm(i,r,s)*md0(i,r,s))
		+ sum((f,g), rtf(f,g,r)*sum(s,vfm(f,g,r,s)))
		+ sum(g, rto(g,r)*sum(s,vom(g,r,s))) );
display incomechk;

set lf(f) /mgr,tec,clk,srv,lab/, kf(f)/cap,lnd,res/;

parameter	macroaccounts(*,r,macct)	Macro economic accounts;

macroaccounts("$",r,"C") = sum((s,h),c0(r,s,h));
macroaccounts("$",r,"G") = sum(s,vom("g",r,s));
macroaccounts("$",r,"I") = sum(s,vom("i",r,s));
macroaccounts("$",r,"L") = sum((lf(f),s,h),evomh(lf,r,s,h));
macroaccounts("$",r,"K") = sum((kf(f),s,h),evomh(kf,r,s,h));
macroaccounts("$",r,"F") = vb(r);
macroaccounts("$",r,"T") =  sum((i,rr), rtms(i,rr,r)*((1-rtxs(i,rr,r))*vxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))) - rtxs(i,r,rr)*vxmd(i,r,rr))
			+ sum((i,s), rtd(i,r,s)*nd0(i,r,s) + rtm(i,r,s)*md0(i,r,s))
			+ sum((f,g), rtf(f,g,r)*sum(s,vfm(f,g,r,s)))
			+ sum(g, rto(g,r)*sum(s,vom(g,r,s)));

macroaccounts("$",r,"GDP")  = macroaccounts("$",r,"C") + macroaccounts("$",r,"G") + macroaccounts("$",r,"I") - macroaccounts("$",r,"F");
macroaccounts("$",r,"GDP*") = macroaccounts("$",r,"L") + macroaccounts("$",r,"K") + macroaccounts("$",r,"T");


macroaccounts("%GDP",r,"C") = 100 * macroaccounts("$",r,"C") / macroaccounts("$",r,"GDP");
macroaccounts("%GDP",r,"G") = 100 * macroaccounts("$",r,"G") / macroaccounts("$",r,"GDP");
macroaccounts("%GDP",r,"I") = 100 * macroaccounts("$",r,"I") / macroaccounts("$",r,"GDP");
macroaccounts("%GDP",r,"L") = 100 * macroaccounts("$",r,"L") / macroaccounts("$",r,"GDP");
macroaccounts("%GDP",r,"K") = 100 * macroaccounts("$",r,"K") / macroaccounts("$",r,"GDP");
macroaccounts("%GDP",r,"F") = 100 * macroaccounts("$",r,"F") / macroaccounts("$",r,"GDP");
macroaccounts("%GDP",r,"T") = 100 * macroaccounts("$",r,"T") / macroaccounts("$",r,"GDP");

option macct:0:0:1;
option macroaccounts:3:1:1;
display macroaccounts;


