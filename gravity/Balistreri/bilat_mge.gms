$title	GTAP-WINDC Model with bilateral state trade

*	Read the GTAP-WiNDC data:

$if not set year $set year 2017
$set datasets %year%

$set fs %system.dirsep% 
$if not set ds $set ds 43
$if not set gtapwindc_datafile $set gtapwindc_datafile ..%fs%GTAPWiNDC%fs%%datasets%%fs%gtapwindc%fs%%ds%.gdx


$include gtapwindc_data

*---------
*	Set up for adding bilateral state trade
Alias (s,ss);

Set usa(r) set of countries that include bilateral intranational trade /usa/
    bst_(i) set of goods with bilateral state trade / 
* ag goods
	pdr  "Paddy rice",
	wht  "Wheat",
	gro  "Cereal grains nec",
	v_f  "Vegetables, fruit, nuts",
	osd  "Oil seeds",
	c_b  "Sugar cane, sugar beet",
	pfb  "Plant-based fibers",
	ocr  "Crops nec",
	ctl  "Bovine cattle, sheep, goats and horses",
	oap  "Animal products nec",
	rmk  "Raw milk",
	wol  "Wool, silk-worm cocoons"
* food products
	fbp	"Food and beverage and tobacco products (311FT)"

	/,
	NX_(i,r,s)  Flag: International exports from node at s
	NM_(i,r)    Flag: International nodal imports
	PNM_(i,r,s) Flag: Price of imports from node s;

Parameter 
	bst0(i,r,s,ss) Bilateral state trade
	xnn0(i,r,s,ss) International trade from s launched from node ss
	nnx0(i,r,s)    Total international trade launched from node s
	Nvim0(i,r,s)   International imports into node s
	Nmd0(i,r,s,ss) International imports into s destine for ss;

nx_(i,r,s)     = no;
nm_(i,r)       = no;
pnm_(i,r,s)    = no;
bst0(i,r,s,ss) = 0;
xnn0(i,r,s,ss) = 0;
nnx0(i,r,s)    = 0;
Nvim0(i,r,s)   = 0; 
Nmd0(i,r,s,ss) = 0;

*---------

$ontext
$model:gtapwindc

$sectors:
	Y(g,r,s)$y_(g,r,s)		  ! Production (includes I and G)
	C(r,s,h)$c_(r,s,h)		  ! Consumption 
	X(i,r,s)$x_(i,r,s)		  ! Disposition
	NX(i,r,s)$nx_(i,r,s)		  ! Exports at node s
	NM(i,r)$nm_(i,r)		  ! CET Imports to nodes s
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

	PNM(i,r,s)$pnm_(i,r,s)		  ! Price of imports from node s
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
* These are the original lines: active when we do not have bilateral state trade
	i:PD(i,r,s)	q:xd0(i,r,s)	 a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s))
	i:P(i,r)	q:nd0(i,r,s)	 a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s)) nm:
	i:PM(i,r)	q:md0(i,r,s)	 a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s)) nm:
* These are the active lines when we have bilateral state trade (flat nesting for gravity)
	i:PY(i,r,ss)	q:bst0(i,r,ss,s) a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s))
	i:PNM(i,r,ss)	q:Nmd0(i,r,ss,s) a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s))

$prod:FT(sf,r,s)$ft_(sf,r,s)  t:etrae(sf)
	o:PS(sf,g,r,s)	q:vfm(sf,g,r,s)
	i:PF(sf,r,s)	q:evom(sf,r,s)

$prod:X(i,r,s)$x_(i,r,s)  t:etrndn(i)
	o:P(i,r)	q:xn0(i,r,s)
	o:PD(i,r,s)	q:xd0(i,r,s)
	i:PY(i,r,s)	q:(vom(i,r,s)-sum(ss,bst0(i,r,s,ss)))

$prod:NX(i,r,s)$nx_(i,r,s)  s:esubdm(i)
	o:P(i,r)	q:nnx0(i,r,s)
	i:PY(i,r,ss)	q:xnn0(i,r,ss,s)

*	CET expansion of PM to import nodes
$prod:NM(i,r)$nm_(i,r)  t:etrndn(i)
	o:PNM(i,r,s)	q:Nvim0(i,r,s)
	i:PM(i,r)	q:vim(i,r)

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

*~NB(ejb): Not sure why we need this bit of code?  
*          These accounts are already zero.
xd0(i,r,s)$(not z_(i,r,s)) = 0;
evom(sf,r,s)$(not sum(h,evomh(sf,r,s,h))) = 0;
vfm(sf,g,r,s)$(not y_(g,r,s)) = 0;

$include gtapwindc.gen
solve gtapwindc using mcp;
Abort$(gtapwindc.objval > 1e-4) "Initial GTAP-WiNDC Calibration failure";

