$title	Canonical Template GTAP-WINDC Model (MGE format)

*	Read the data:

$if not set ds $set ds 43

$set gtapwindc_datafile ..\GTAPWiNDC\datasets\gtapwindc\%ds%.gdx

$include ..\GTAPWiNDC\gtapwindc_data

$ontext
$model:gtapwindc

$sectors:
	Y(g,r,s)$y_(g,r,s)		  ! Production (includes I and G)
	C(r,s,h)$c_(r,s,h)		  ! Consumption 
	X(i,r,s)$x_(i,r,s)		  ! Disposition
	Z(i,r,s)$z_(i,r,s)		  ! Armington demand
	FT(f,r,s)$ft_(f,r,s)		  ! Specific factor transformation
	M(i,r)$m_(i,r)			  ! Import
	YT(j)$yt_(j)			  ! Transport

$commodities:
	PY(g,r,s)$py_(g,r,s)		  ! Output price
	PZ(i,r,s)$pz_(i,r,s)		  ! Armington composite price
	PD(i,r,s)$pd_(i,r,s)		  ! Local goods price

	P(i,r)$p_(i,r)			  ! National goods price
	PC(r,s,h)$pc_(r,s,h)		  ! Consumption price 
	PF(f,r,s)$pf_(f,r,s)		  ! Primary factors rent
	PS(f,g,r,s)$ps_(f,g,r,s)	  ! Sector-specific primary factors
	PM(i,r)$pm_(i,r)		  ! Import price
	PT(j)$pt_(j)			  ! Transportation services

$consumers:
	RH(r,s,h)$rh_(r,s,h)		  ! Representative household
	GOVT(r)				  ! Public expenditure
	INV(r)				  ! Investment


$prod:Y(g,r,s)$y_(g,r,s) s:0  va:esubva(g) 
	o:PY(g,r,s)	q:vom(g,r,s)				a:GOVT(r) t:rto(g,r)
	i:PZ(i,r,s)	q:vafm(i,g,r,s)	
	i:PS(sf,g,r,s)	q:vfm(sf,g,r,s)  p:(1+rtf0(sf,g,r))  va: a:GOVT(r) t:rtf(sf,g,r)
	i:PF(mf,r,s)	q:vfm(mf,g,r,s)  p:(1+rtf0(mf,g,r))  va: a:GOVT(r) t:rtf(mf,g,r)

$prod:Z(i,r,s)$z_(i,r,s)  s:esubdm(i)  nm:(2*esubdm(i))
	o:PZ(i,r,s)	q:a0(i,r,s)
	i:PD(i,r,s)	q:xd0(i,r,s)	a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s))
	i:P(i,r)	q:nd0(i,r,s)	a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s)) nm:
	i:PM(i,r)	q:md0(i,r,s)	a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s)) nm:

$prod:FT(sf,r,s)$ft_(sf,r,s)  t:etrae(sf)
	o:PS(sf,g,r,s)	q:vfm(sf,g,r,s)
	i:PF(sf,r,s)	q:evom(sf,r,s)

$prod:X(i,r,s)$x_(i,r,s)  t:etrndn(i)
	o:P(i,r)	q:xn0(i,r,s)
	o:PD(i,r,s)	q:xd0(i,r,s)
	i:PY(i,r,s)	q:vom(i,r,s)

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
	e:PF(f,r,s)			q:evomh(f,r,s,h)
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

xd0(i,r,s)$(not z_(i,r,s)) = 0;
evom(sf,r,s)$(not sum(h,evomh(sf,r,s,h))) = 0;
vfm(sf,g,r,s)$(not y_(g,r,s)) = 0;

$include gtapwindc.gen
solve gtapwindc using mcp;
