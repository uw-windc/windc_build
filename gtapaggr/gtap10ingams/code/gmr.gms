$title	 GTAPinGAMS -- GAMS/MPSGE Formulation for the GMR Model

*	This version of the model assumes that goods produced
*	for the domestic and export markets are perfect substitutes.

$if not set gtapv $set gtapv 10
$if not set yr    $set yr    14
$if not set ds    $set ds    g20_macro

$include %system.fp%gtapdata

$ontext
$model:gtap

$sectors:
	Y(g,r)$vom(g,r)			! Supply
	M(i,r)$vim(i,r)			! Imported inputs
	FT(f,r)$(sf(f)*evom(f,r))	! Specific factor transformation
	YT(j)$vtw(j)			! Transportation services

$commodities:
	P(g,r)$vom(g,r)			! Domestic output price
	PM(i,r)$vim(i,r)		! Import price
	PT(j)$vtw(j)			! Transportation services
	PF(f,r)$evom(f,r)		! Primary factors rent
	PS(f,g,r)$(sf(f)*vfm(f,g,r))	! Sector-specific primary factors

$consumers:
	RA(r)		! Representative agent

$prod:Y(g,r)$vom(g,r) s:0 m:esub(g,r) va:esubva(g) i.tl(m):esubdm(i)  
	o:P(g,r)	q:vom(g,r)	a:RA(r)  t:rto(g,r)
	i:P(i,r)	q:vdfm(i,g,r)	p:(1+rtfd0(i,g,r)) i.tl:  a:RA(r) t:rtfd(i,g,r)
	i:PM(i,r)	q:vifm(i,g,r)	p:(1+rtfi0(i,g,r)) i.tl:  a:RA(r) t:rtfi(i,g,r)
	i:PS(sf,g,r)	q:vfm(sf,g,r)	p:(1+rtf0(sf,g,r))  va:   a:RA(r) t:rtf(sf,g,r)
	i:PF(mf,r)	q:vfm(mf,g,r)	p:(1+rtf0(mf,g,r))  va:   a:RA(r) t:rtf(mf,g,r)

$prod:M(i,r)$vim(i,r)	s:esubm(i)  s.tl:0
	o:PM(i,r)	q:vim(i,r)
	i:P(i,s)	q:vxmd(i,s,r)	p:pvxmd(i,s,r) s.tl:
+		a:RA(s) t:(-rtxs(i,s,r)) a:RA(r) t:(rtms(i,s,r)*(1-rtxs(i,s,r)))
	i:PT(j)#(s)	q:vtwr(j,i,s,r) p:pvtwr(i,s,r) s.tl: a:RA(r) t:rtms(i,s,r)

$prod:YT(j)$vtw(j)  s:1
	o:PT(j)		q:vtw(j)
	i:P(j,r)	q:vst(j,r)

$prod:FT(sf,r)$evom(sf,r)  t:etrae(sf)
	o:PS(sf,j,r)	q:vfm(sf,j,r)
	i:PF(sf,r)	q:evom(sf,r)

$demand:RA(r)  s:0
	d:P(cd,r)	q:vom(cd,r)
	e:P("sd",r)	q:(-vom("sd",r)) ! Coefficient for the LES demand system

	e:PF(f,r)	q:evom(f,r)
	e:P("g",r)	q:(-vom("g",r))
	e:P("i",r)	q:(-vom("i",r))
	e:P("i",rnum)	q:vb(r)


$offtext
$sysinclude mpsgeset gtap
$call 'mv -f gtap.gen %gtapv%.gen'


gtap.workspace = 1024;
gtap.iterlim = 0;
$include %gtapv%.gen
solve gtap using mcp;
