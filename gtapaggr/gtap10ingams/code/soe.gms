$title	 GTAPinGAMS -- GAMS/MPSGE Formulation

$if %run%==yes $goto run


$if not set gtapv $set gtapv 10
$if not set yr    $set yr    14
$if not set ds    $set ds    g20_macro

$include "%system.fp%gtapdata"

parameter
	vdm_(g)		Aggregate demand for domestic output,
	vom_(g)		Total supply at market prices,
	vxm_(g)         Export market supply,

	vim_(i)		Aggregate imports,
	evom_(f)	Aggregate factor endowment at market prices,
	vfm_(f,g)	Endowments - Firms' purchases at market prices,
	vdfm_(i,g)	Intermediates - firms' domestic purchases at market prices,
	vifm_(i,g)	Intermediates - firms' imports at market prices,
	vxmd_(i,r)	Trade - bilateral exports at market prices,
	vtwr_(i,j,s)	Trade - Margins for international transportation at world prices,

	rto_(g)		Output (or income) subsidy rates
	rtf_(f,g)	Primary factor and commodity rates taxes 
	rtfd_(i,g)	Firms domestic tax rates
	rtfi_(i,g)	Firms' import tax rates
	rtxs_(i,r)	Export subsidy rates
	rtms_(i,r)	Import taxes rates
	vb_		Current account;

$set r bra

vb_ = vb("%r%");
vom_(g) = vom(g,"%r%");
vdm_(g) = vdm(g,"%r%");
vxm_(g) = vxm(g,"%r%");

vim_(i) = vim(i,"%r%");
evom_(f) = evom(f,"%r%");
vfm_(f,g) = vfm(f,g,"%r%");
vdfm_(i,g) = vdfm(i,g,"%r%");
vifm_(i,g) = vifm(i,g,"%r%");
vxmd_(i,r) = vxmd(i,r,"%r%");
vtwr_(i,j,s) = vtwr(i,j,s,"%r%");

rto_(g) = rto(g,"%r%");
rtf_(f,g) = rtf(f,g,"%r%");
rtfd_(i,g) = rtfd(i,g,"%r%");
rtfi_(i,g) = rtfi(i,g,"%r%");
rtxs_(i,r) = rtxs(i,r,"%r%");
rtms_(i,r) = rtms(i,r,"%r%");

execute_unload 'gtapsoe.gdx', i, f, g, r, sf, mf, vb_=vb,
	vom_=vom, vxm_=vxm, vdfm_=vdfm, vifm_=vifm, vfm_=vfm, evom_=evom, vim_=vim, vxm_=vxm, vtwr_=vtwr, vxmd_=vxmd, 
	rto_=rto, rtf_=rtf, rtfd_=rtfd, rtfi_=rtfi, rtxs_=rtxs, rtms_=rtms, 
	etadx, esub, esubva, esubdm, esubt,esubd, esubm, etrae;

*.execute 'gams soe --run=yes o=soe_run.lst';

$exit
$label run


$gdxin 'gtapsoe.gdx'

set	g(*)	Goods plus C - SD - DD -- G and I,
	i(g)	Goods
	f(*)	Factors
	r(*)	Regions
	sf(f)	Sluggish primary factors (sector-specific),
	mf(f)	Mobile primary factors;

$load g i f r sf mf

alias (r,s), (i,j);

parameter
	vdm(g)		Aggregate demand for domestic output,
	vom(g)		Total supply at market prices,
	vxm(g)          Export market supply,

	vim(i)		Aggregate imports,
	evom(f)		Aggregate factor endowment at market prices,
	vfm(f,g)	Endowments - Firms' purchases at market prices,
	vdfm(i,g)	Intermediates - firms' domestic purchases at market prices,
	vifm(i,g)	Intermediates - firms' imports at market prices,
	vxmd(i,r)	Trade - bilateral exports at market prices,
	vtwr(i,j,s)	Trade - Margins for international transportation at world prices,

	vb		Current account,

	rto(g)		Output (or income) subsidy rates
	rtf(f,g)	Primary factor and commodity rates taxes 
	rtfd(i,g)	Firms domestic tax rates
	rtfi(i,g)	Firms' import tax rates
	rtxs(i,r)	Export subsidy rates
	rtms(i,r)	Import taxes rates,

	etadx(g)        Export elasticity of transformation D vs E,
	esubdm(i)	Elasticity of substitution D vs M,
	esubt(i)	Elasticity of top-level input substitution',
	esubd(i)	Elasticity of substitution (M versus D),
	esubva(g)	Elasticity of substitution between factors,
	esubm(i)	Intra-import elasticity of substitution,
	etrae(f)	Elasticity of transformation;

$loaddc vom vxm vim evom vfm vdfm vifm vxmd vtwr vb rto rtf rtfd rtfi rtxs rtms 
$loaddc etadx esubdm esubt esubd esubva esubm etrae 
$gdxin

parameter	vdm(g)	Supply to the domestic market;
vdm(g) = vom(g) - vxm(g);

parameter
	rtf0(f,g)	Primary factor and commodity rates taxes 
	rtfd0(i,g)	Firms domestic tax rates
	rtfi0(i,g)	Firms' import tax rates
	rtxs0(i,r)	Export subsidy rates
	rtms0(i,r)	Import taxes rates;

rtf0(f,g) = rtf(f,g);
rtfd0(i,g) = rtfd(i,g);
rtfi0(i,g) = rtfi(i,g);

rtxs0(i,s) = rtxs(i,s);
rtms0(i,s) = rtms(i,s);

parameter	pvxmd(i,s)	Import price (power of benchmark tariff)
		pvtwr(i,s)	Import price for transport services;

pvxmd(i,s) = (1+rtms0(i,s)) * (1-rtxs0(i,s));
pvtwr(i,s) = 1+rtms0(i,s);

parameter	esub(g)	Top-level elasticity;
esub(i) = esubt(i);
esub("c") = 1;

parameter	vm(i,s)	Import gross CIF;
vm(i,s) = sum(j,vtwr(j,i,s))*pvtwr(i,s) + vxmd(i,s)*pvxmd(i,s);

parameter	rowpfx	Foreign transfer /0/;

$ontext
$model:gtapsoe

$sectors:
	Y(g)$vom(g)		! Supply
	M(i)$vim(i)		! Imports
	MS(i,s)$vm(i,s)
	FT(sf)$evom(sf)

$commodities:
	P(g)$vdm(g)		! Domestic output price
	PM(j)$vim(j)		! Import price
	PMS(i,s)$vm(i,s)
	PF(f)$evom(f)		! Primary factors rent
	PS(f,g)$(sf(f)*vfm(f,g)) ! Sector-specific primary factors
	PFX			! Real exchange rate (SOE model)

$consumers:
	RA			! Representative agent
	ROW			! Rest of world 

$auxiliary:
	X(i)			! Export index
	VX			! Value of exports index

$prod:Y(g)$vom(g) s:0 m:esub(g) va:esubva(g) i.tl(m):esubdm(i)  
	o:P(g)		q:vom(g)	a:RA  t:rto(g)	p:(1-rto(g))
	i:P(i)		q:vdfm(i,g)	p:(1+rtfd0(i,g)) i.tl:  a:RA t:rtfd(i,g)
	i:PM(i)		q:vifm(i,g)	p:(1+rtfi0(i,g)) i.tl:  a:RA t:rtfi(i,g)
	i:PS(sf,g)	q:vfm(sf,g)	p:(1+rtf0(sf,g))  va:   a:RA t:rtf(sf,g)
	i:PF(mf)	q:vfm(mf,g)	p:(1+rtf0(mf,g))  va:   a:RA t:rtf(mf,g)


$prod:M(i)$vim(i)	s:esubm(i) 
	o:PM(i)		q:vim(i)
	i:PMS(i,s)	q:vm(i,s)

$prod:MS(i,s)$vm(i,s)  s:0
	o:PMS(i,s)	q:vm(i,s)
	i:PFX		q:(sum(j,vtwr(j,i,s)))	p:pvtwr(i,s)	a:RA  t:rtms(i,s)
	i:PFX		q:vxmd(i,s)		p:pvxmd(i,s)	a:ROW t:(-rtxs(i,s)) a:RA t:(rtms(i,s)*(1-rtxs(i,s)))

$prod:FT(sf)$evom(sf)  t:etrae(sf)
	o:PS(sf,j)	q:vfm(sf,j)
	i:PF(sf)	q:evom(sf)

$demand:RA  
	d:P("c")	q:vom("c")
	e:P("g")	q:(-vom("g"))
	e:P("i")	q:(-vom("i"))
	e:PFX		q:vb
	e:PF(f)		q:evom(f)
	e:P("sd")	q:(-vom("sd"))
	e:P(i)		q:(-vxm(i))		r:X(i)
	e:PFX		q:(sum(g,vxm(g)))	r:VX

$demand:ROW
	e:PFX		q:rowpfx
	d:PFX

$constraint:X(i)
	X(i) =e= (P(i)/PFX)**(-esubm(i));

$constraint:VX
	VX =e= sum(i, P(i)*X(i)*vxm(i))/sum(i,vxm(i));

$offtext
$sysinclude mpsgeset gtapsoe

X.L(i) = 1;
VX.L = 1;
rowpfx = 10*sum((i,s),abs(rtxs(i,s))*vxmd(i,s));

PFX.FX = 1;

vb = sum((j,i,s),vtwr(j,i,s)) + sum((i,s),vxmd(i,s)) - sum(g,vxm(g)) - sum((i,s),rtxs(i,s)*vxmd(i,s));


gtapsoe.iterlim = 0;
$include gtapsoe.gen
solve gtapsoe using mcp;
