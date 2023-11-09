$title	 GTAPinGAMS -- GAMS/MPSGE and GAMS/MCP Formulations for the Global Multiregional Model

$setglobal gtap_version gtap11a

*	This version of the model assumes that goods produced
*	for the domestic and export markets are perfect substitutes.

$if not set yr    $set yr    2017
$if not set ds    $set ds    g20_43

*	Read the data file:

$include %system.fp%gtapdata

*	Subsistence demand for the LES model:

parameter	sdd(i,r)	Subsistence demand (domestic)
		sdi(i,r)	Subsistence demand (imported);

sdd(i,r) = vdfm(i,"c",r)*(1-betales(r)*eta(i,r)); 
sdi(i,r) = vifm(i,"c",r)*(1-betales(r)*eta(i,r)); 
vdfm(i,"c",r) = vdfm(i,"c",r) - sdd(i,r);
vifm(i,"c",r) = vifm(i,"c",r) - sdi(i,r);
vom("c",r) = (sum(i,vdfm(i,"c",r)*(1+rtfd(i,"c",r)) +  
		    vifm(i,"c",r)*(1+rtfi(i,"c",r))) ) /(1-rto("c",r));

alias (r,rt);

set	sf(f)	Specific factor,
	mf(f)	Mobile factors;
sf(f) = no;

set	specific	Factors treated as specific /lnd, res/;

sf(f)$sameas(f,"lnd") = yes;
sf(f)$sameas(f,"res") = yes;

mf(f) = (not sf(f));


*	Define a numeraire region for denominating international transfers:
singleton set	rnum(r)	Numeraire region;
rnum(r) = yes$(vom("c",r)=smax(r.local,vom("c",r)));
display rnum;

mf(f) = (not sf(f));

parameter	vtw(j)		Aggregate transport margin supply
		esub(g)		Elasticity of substitution in final demand /c 1/;

vtw(j) = sum(r,vst(j,r));


alias (r,rr);

alias (s,i);

parameter
	va(g)		Value-added,
	vP(g,r,s)	VA content domestic output price
	vPM(i,r,s)	VA content import price
	vPT(j,s)	VA content transportation services;

set	ags(i)	Ag sectors /c_b, ctl, gro, oap, ocr, osd, pdr, pfb, rmk, v_f, wht, wol /;

loop(r$sameas(r,"usa"),
  va(ags(s)) = rto(s,r)*vom(s,r) + sum(i, rtfd(i,s,r)*vdfm(i,s,r)+rtfi(i,s,r)*vifm(i,s,r)) + sum(f, vfm(f,s,r)*(1+rtf(f,s,r)));
);
vPM(i,r,s) = 0;
vPT(j,s) = 0;

parameter	agstax(g,*,*)	Agricultural tax rates;
agstax(ags(s),"rto",s) = round(100*rto(s,"usa"),1);
agstax(ags(s),"rtfd",i) = round(100 * rtfd(i,s,"usa"),1);
agstax(ags(s),"rtfi",i) = round(100 * rtfd(i,s,"usa"),1);
agstax(ags(s),"rtf",f) = round(100 * rtf(f,s,"usa"),1);
option agstax:1:1:2;
display agstax;
display va;

set	iter /iter1*iter10/;

vP(g,r,s)$vom(g,r) = va(g)$(sameas(g,s) and sameas(r,"USA") ) /vom(g,r);

loop(ags(s),
  loop(iter,
	vP(g,r,s)$vom(g,r) = ( sum(i,vP(i,r,s)*vdfm(i,g,r) + vPM(i,r,s)*vifm(i,g,r)) + va(g)$(sameas(g,s) and sameas(r,"USA") ) ) /vom(g,r);
	vPT(j,s)$vtw(j) = sum(r, vP(j,r,s)*vst(j,r)) / vtw(j);
	vPM(i,r,s)$vim(i,r) = sum(rr, vxmd(i,rr,r)*vP(i,rr,s) + sum(j, vtwr(j,i,rr,r)*vPT(j,s)))/vim(i,r); 
));

parameter	agrcontent	Factor content;
agrcontent(ags(s),"direct") = va(s) /vom(s,"usa");
agrcontent(ags(s),"own")   = vP(s,"usa",s);
agrcontent(ags(s),"total") = sum(i$ags(i),vP(s,"usa",i));
display agrcontent;

$exit

$ontext
$model:gmr_mge

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
	PS(f,g,r)$(sf(f) and vfm(f,g,r))

$consumers:
	RA(r)		! Representative agent


$prod:Y(g,r)$vom(g,r) s:0 m:esub(g) va:esubva(g) i.tl(m):esubdm(i)  
	o:P(g,r)	q:vom(g,r)	a:RA(r)  t:rto(g,r)
	i:P(i,r)	q:vdfm(i,g,r)	p:(1+rtfd0(i,g,r)) i.tl:  a:RA(r) t:rtfd(i,g,r)
	i:PM(i,r)	q:vifm(i,g,r)	p:(1+rtfi0(i,g,r)) i.tl:  a:RA(r) t:rtfi(i,g,r)

	i:PS(sf,g,r)	q:vfm(sf,g,r)	p:(1+rtf0(sf,g,r))  va:   a:RA(r) t:rtf(sf,g,r)

	i:PF(mf,r)	q:vfm(mf,g,r)	p:(1+rtf0(mf,g,r))  va:   a:RA(r) t:rtf(mf,g,r)

$prod:M(i,r)$vim(i,r)	s:(2*esubdm(i))  rr.tl:0
	o:PM(i,r)	q:vim(i,r)
	i:P(i,rr)	q:vxmd(i,rr,r)	p:pvxmd(i,rr,r) rr.tl:
+		a:RA(rr) t:(-rtxs(i,rr,r)) a:RA(r) t:(rtms(i,rr,r)*(1-rtxs(i,rr,r)))
	i:PT(j)#(rr)	q:vtwr(j,i,rr,r) p:pvtwr(i,rr,r) rr.tl: a:RA(r) t:rtms(i,rr,r)

$prod:YT(j)$vtw(j)  s:1
	o:PT(j)		q:vtw(j)
	i:P(j,r)	q:vst(j,r)

$prod:FT(sf,r)$evom(sf,r)  t:etaf(sf)
	o:PS(sf,j,r)	q:vfm(sf,j,r)
	i:PF(sf,r)	q:evom(sf,r)

$demand:RA(r)  s:0
	d:P("c",r)	q:vom("c",r)
	e:P(i,r)	q:(-sdd(i,r))
	e:PM(i,r)	q:(-sdi(i,r))
	e:PF(f,r)	q:evom(f,r)
	e:P("g",r)	q:(-vom("g",r))
	e:P("i",r)	q:(-vom("i",r))
	e:P("i",rnum)	q:vb(r)

$offtext
$sysinclude mpsgeset gmr_mge
gmr_mge.workspace = 1024;
gmr_mge.iterlim = 0;
$include gmr_mge.gen
solve gmr_mge using mcp;
abort$round(gmr_mge.objval,3) "Benchmark replication problem with the MGE model.";
