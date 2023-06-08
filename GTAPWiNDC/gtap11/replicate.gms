$title	 GTAPinGAMS -- GAMS/MPSGE and GAMS/MCP Formulations for the Global Multiregional Model

*	This version of the model assumes that goods produced
*	for the domestic and export markets are perfect substitutes.

$if not set yr    $set yr    2017
$if not set ds    $set ds    g20_10

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

$if not set mgeonly $set mgeonly no
$if %mgeonly%==yes $exit


*       -------------------------------------------------------------------------------
*       Macros to diagnose the functional form:

$macro  Leontief(sigma)         (yes$(round(sigma,2)=0))
$macro  CobbDouglas(sigma)      (yes$(round(sigma-1,2)=0))
$macro  CES(sigma)              (yes$(round(sigma-1,2)<>0 and round(sigma,2)<>0))

*       -------------------------------------------------------------------------------
*       Benchmark value shares:

parameter
	cf0(g,r)		Factor cost
	cm0(g,r)		Material cost
	cy0(g,r)		Reference total cost,
	vxmt(i,rr,r)		Value of imports gross transport cost,
	theta_cf0(g,r)		Value added share of cost,
	theta_vfm(f,g,r)	Factor share of value added,
	theta_cm0(i,g,r)	Armington share of material cost,
	theta_vdfm(i,g,r)	Domestic share of Armington composite,
	theta_vst(j,r)		Value share,
	theta_vxmd(i,rr,r)	Value share of goods in imports,
	theta_vtwr(j,i,rr,r)	Value share of transportation services,
	theta_vim(i,rr,r)	Bilateral import value share
	theta_evom(f,j,r)	Value shares of specific factors;

*	-----------------------------------------------------------------------------
*	Production and final demand activities:

* $prod:Y(g,r)$vom(g,r) s:0 m:esub(g) va:esubva(g) i.tl(m):esubdm(i)  
* 	o:P(g,r)	q:vom(g,r)	a:RA(r)  t:rto(g,r)
* 	i:P(i,r)	q:vdfm(i,g,r)	p:(1+rtfd0(i,g,r)) i.tl:  a:RA(r) t:rtfd(i,g,r)
* 	i:PM(i,r)	q:vifm(i,g,r)	p:(1+rtfi0(i,g,r)) i.tl:  a:RA(r) t:rtfi(i,g,r)
* 	i:PS(sf,g,r)	q:vfm(sf,g,r)	p:(1+rtf0(sf,g,r))  va:   a:RA(r) t:rtf(sf,g,r)
* 	i:PF(mf,r)	q:vfm(mf,g,r)	p:(1+rtf0(mf,g,r))  va:   a:RA(r) t:rtf(mf,g,r)

*       User cost indices for factors, domestic and imported intermediate inputs:

$macro P_PF(f,g,r) (((PF(f,r)$mf(f)+PS(f,g,r)$sf(f))*(1+rtf(f,g,r)) \
                / (1+rtf0(f,g,r)))$theta_vfm(f,g,r)  + 1$(theta_vfm(f,g,r)=0))

$macro P_D(i,g,r)  ((P(i,r)*(1+rtfd(i,g,r)) \
                / (1+rtfd0(i,g,r)))$theta_vdfm(i,g,r) + 1$(not theta_vdfm(i,g,r)))

$macro P_I(i,g,r)  ((PM(i,r)*(1+rtfi(i,g,r)) \
                / (1+rtfi0(i,g,r)))$(1-theta_vdfm(i,g,r)) + 1$(theta_vdfm(i,g,r)=1))

*	Factor cost index:

$macro C_F(g,r) ( \ 
        ( ( sum(f.local$theta_vfm(f,g,r),  theta_vfm(f,g,r)*P_PF(f,g,r)))$Leontief(esubva(g)) + \
          (prod(f.local$theta_vfm(f,g,r),  P_PF(f,g,r)**theta_vfm(f,g,r)))$CobbDouglas(esubva(g)) + \
          ( sum(f.local$theta_vfm(f,g,r),  theta_vfm(f,g,r)*P_PF(f,g,r)**(1-esubva(g)))**(1/(1-esubva(g))))$CES(esubva(g)))$cf0(g,r) )

*	Armington cost index for commodity i input to sector g:

$macro C_A(i,g,r) ( \
        (theta_vdfm(i,g,r)*P_D(i,g,r) + (1-theta_vdfm(i,g,r))*P_I(i,g,r))$Leontief(esubdm(i)) + \
        (P_D(i,g,r)**theta_vdfm(i,g,r) * P_I(i,g,r)**(1-theta_vdfm(i,g,r)))$CobbDouglas(esubdm(i)) + \
        ( (theta_vdfm(i,g,r) *P_D(i,g,r)**(1-esubdm(i)) + \
        (1-theta_vdfm(i,g,r))*P_I(i,g,r)**(1-esubdm(i)))**(1/(1-esubdm(i))))$CES(esubdm(i)))

$macro C_M(g,r) ( \
 ( (sum(i.local$theta_cm0(i,g,r),  theta_cm0(i,g,r) * C_A(i,g,r)**(1-esub(g)))**(1/(1-esub(g))))$CES(esub(g)) + \
    prod(i.local$theta_cm0(i,g,r), C_A(i,g,r)**theta_cm0(i,g,r))$CobbDouglas(esub(g)) + \
    sum(i.local$theta_cm0(i,g,r),  theta_cm0(i,g,r) * C_A(i,g,r))$Leontief(esub(g)) ) )

*       Unit cost function - primary factors and materials:

$macro C_Y(g,r) (theta_cf0(g,r)*C_F(g,r) + (1-theta_cf0(g,r))*C_M(g,r))

*       Intermediate input demand functions for domestic and imported commodities:

$macro DDFM(i,g,r)	((vdfm(i,g,r) * (C_A(i,g,r)/P_D(i,g,r))**esubdm(i) * (C_M(g,r)/C_A(i,g,r))**esub(g))$vdfm(i,g,r))

$macro DIFM(i,g,r)	((vifm(i,g,r) * (C_A(i,g,r) /P_I(i,g,r)  )**esubdm(i) * (C_M(g,r)/C_A(i,g,r))**esub(g))$vifm(i,g,r))

*	Primary factor demands:

$macro DFM(f,g,r)	(vfm(f,g,r)  *  (C_F(g,r)/P_PF(f,g,r))**esubva(g))$vfm(f,g,r)

*       Associated tax revenue flows:

$macro REV_TO(g,r)	(Y(g,r)*rto(g,r)*P(g,r)*vom(g,r))
$macro REV_TFD(i,g,r)	(Y(g,r)*(rtfd(i,g,r) * P(i,r)  * DDFM(i,g,r))$(rm(r)*rtfd(i,g,r)*vdfm(i,g,r)))
$macro REV_TFI(i,g,r)	(Y(g,r)*(rtfi(i,g,r) * PM(i,r) * DIFM(i,g,r))$(rm(r)*rtfi(i,g,r)*vifm(i,g,r)))
$macro REV_TF(f,g,r) 	(Y(g,r)*(rtf(f,g,r)  * DFM(f,g,r) * ((PS(f,g,r))$sf(f)+(PF(f,r))$mf(f)))$(rm(r)*vom(g,r)*rtf(f,g,r)*vfm(f,g,r)))

*	-----------------------------------------------------------------------------
*	Profit function for international transportation services:

*. $prod:YT(j)$vtw(j)  s:1
*.	o:PT(j)		q:vtw(j)
*.	i:P(j,r)	q:vst(j,r)

*	Demand Function:

$macro DST(j,r)    ((vst(j,r)*PT(j)/P(j,r))$vst(j,r))

*	-----------------------------------------------------------------------------
*	Bilateral trade -- import demand:

*.$prod:M(i,r)$vim(i,r)	s:(2*esubdm(i))  rr.tl:0
*.	o:PM(i,r)	q:vim(i,r)
*.	i:P(i,rr)	q:vxmd(i,rr,r)	p:pvxmd(i,rr,r) rr.tl:
*.		a:RA(rr) t:(-rtxs(i,rr,r)) a:RA(r) t:(rtms(i,rr,r)*(1-rtxs(i,rr,r)))
*.	i:PT(j)#(rr)	q:vtwr(j,i,rr,r) p:pvtwr(i,rr,r) rr.tl: a:RA(r) t:rtms(i,rr,r)

*	User cost indices:

$macro P_M(i,rr,r)   ((P(i,rr) * (1-rtxs(i,rr,r))*(1+rtms(i,rr,r))/pvxmd(i,rr,r))$vxmd(i,rr,r) + 1$(vxmd(i,rr,r)=0))
$macro P_T(j,i,rr,r) ((PT(j)*(1+rtms(i,rr,r))/pvtwr(i,rr,r))$vtwr(j,i,rr,r)+1$(vtwr(j,i,rr,r)=0))

*	Price index of bilateral imports (Leontief cost function):

$macro PT_M(i,rr,r) (P_M(i,rr,r)*theta_vxmd(i,rr,r) + sum(j.local, P_T(j,i,rr,r)*theta_vtwr(j,i,rr,r)))

*	Unit cost function for imports (CES):

$macro CIM(i,r) ( \
   sum(rr.local, theta_vim(i,rr,r) * PT_M(i,rr,r) )$Leontief(2*esubdm(i)) + \
   prod(rr.local, PT_M(i,rr,r)**theta_vim(i,rr,r) )$CobbDouglas(2*esubdm(i)) + \
  (sum(rr.local, theta_vim(i,rr,r) * PT_M(i,rr,r)**(1-2*esubdm(i)))**(1/(1-2*esubdm(i))))$CES(2*esubdm(i)) )

*	Compensated demand function:

$macro DXMD(i,rr,r)   ((vxmd(i,rr,r)   * (PM(i,r)/PT_M(i,rr,r))**(2*esubdm(i)))$vxmd(i,rr,r))
$macro DTWR(j,i,rr,r) ((vtwr(j,i,rr,r) * (PM(i,r)/PT_M(i,rr,r))**(2*esubdm(i)))$vtwr(j,i,rr,r))

*	Tax revenue:

$macro REV_TXS(i,s,r)	(M(i,r)*DXMD(i,s,r)*PX(i,s)*rtxs(i,s,r))$vxmd(i,s,r)
$macro REV_TMS(i,rr,r)	(M(i,r)*rtms(i,rr,r)*DXMD(i,rr,r)*((1-rtxs(i,rr,r))*P(i,rr) + \
		 sum(j$vtwr(j,i,rr,r), PT(j)*vtwr(j,i,rr,r)/vxmd(i,rr,r)))$(vxmd(i,rr,r)*rtms(i,rr,r)))

*	-----------------------------------------------------------------------------
*	Transforamtion sector for sluggish factors:

*	$prod:FT(sf,r)$evom(sf,r)  t:etrae(sf)
*		o:PS(sf,j,r)	q:vfm(sf,j,r)
*		i:PF(sf,r)	q:evom(sf,r)

$macro PVFM(sf,r)  (sum(j.local,theta_evom(sf,j,r)*PS(sf,j,r)**(1+etaf(sf)))**(1/(1+etaf(sf))))
$macro SFM(sf,j,r) (vfm(sf,j,r)*(PS(sf,j,r)/PVFM(sf,r))**etaf(sf))

*	-----------------------------------------------------------------------------
*	Generate code for model calibration:

$setlocal datetime %system.date%%system.time%
$onechov >gmr_mcp.gen
*       Calibration code for gmr_mcp.gms (%datetime%)    >gmr_mcp.gen

cf0(g,r) = sum(f, vfm(f,g,r)*(1+rtf0(f,g,r)));
cm0(g,r) = sum(i, vdfm(i,g,r)*(1+rtfd0(i,g,r)) + vifm(i,g,r)*(1+rtfi0(i,g,r)));
cy0(g,r) = cf0(g,r) + cm0(g,r);
theta_cf0(g,r)$cy0(g,r)  = cf0(g,r) / cy0(g,r);

theta_vfm(f,g,r)$cf0(g,r) = vfm(f,g,r)*(1+rtf0(f,g,r)) / cf0(g,r);

theta_cm0(i,g,r)$cm0(g,r) = 
	(vdfm(i,g,r)*(1+rtfd0(i,g,r)) + vifm(i,g,r)*(1+rtfi0(i,g,r))) / cm0(g,r);

theta_vdfm(i,g,r)$vdfm(i,g,r) = vdfm(i,g,r)*(1+rtfd0(i,g,r)) / 
	(vdfm(i,g,r)*(1+rtfd0(i,g,r)) + vifm(i,g,r)*(1+rtfi0(i,g,r)));

theta_vst(j,r)$vtw(j) = vst(j,r)/sum(r.local,vst(j,r));

vxmt(i,rr,r)$vxmd(i,rr,r) = vxmd(i,rr,r)*pvxmd(i,rr,r) + sum(j,vtwr(j,i,rr,r)*pvtwr(i,rr,r));

theta_vxmd(i,rr,r)= (vxmd(i,rr,r)*pvxmd(i,rr,r) / vxmt(i,rr,r))$vxmt(i,rr,r);
theta_vtwr(j,i,rr,r) = (vtwr(j,i,rr,r)*pvtwr(i,rr,r) / vxmt(i,rr,r))$vxmt(i,rr,r);
theta_vim(i,rr,r)$vxmt(i,rr,r)	= vxmt(i,rr,r)/vim(i,r);
theta_evom(sf,j,r)$evom(sf,r) = vfm(sf,j,r)/evom(sf,r);
$offecho

*	-----------------------------------------------------------------------------
*	Declared arguments for model variables:

$setglobal j_Y	g,r
$setglobal j_M	i,r
$setglobal j_FT	f,r
$setglobal j_YT	j
$setglobal i_P	g,r
$setglobal i_PM	i,r
$setglobal i_PT	j
$setglobal i_PF	f,r
$setglobal i_PS	f,g,r
$setglobal h_RA	r

sets
	j_Y(%j_Y%)			Sector activity level Y
	j_M(%j_M%)			Sector activity level M
	j_FT(%j_FT%)			Sector activity level FT
	j_YT(%j_YT%)			Sector activity level YT

	i_P(%i_P%)			Commodity market price P
	i_PM(%i_PM%)			Commodity market price PM
	i_PT(%i_PT%)			Commodity market price PT
	i_PF(%i_PF%)			Commodity market price PF
	i_PS(%i_PS%)			Commodity market price PS

	h_RA(%h_RA%)			Consumer income RA

*	Index retrieval tuples:

	indices_Y(%j_Y%,%j_Y%)		Index mapping for Y,
	indices_M(%j_M%,%j_M%)		Index mapping for M,
	indices_FT(%j_FT%,%j_FT%)	Index mapping for FT,
	indices_YT(%j_YT%,%j_YT%)	Index mapping for YT,
	indices_P(%i_P%,%i_P%)		Index mapping for P,
	indices_PM(%i_PM%,%i_PM%)	Index mapping for PM,
	indices_PT(%i_PT%,%i_PT%)	Index mapping for PT,
	indices_PF(%i_PF%,%i_PF%)	Index mapping for PF,
	indices_PS(%i_PS%,%i_PS%)	Index mapping for PS,
	indices_RA(%h_RA%,%h_RA%)	Index mapping for RA,

*	Intermediate demands:

	ij_PS_FT(%i_PS%,%j_FT%)		Input-output domain
	ij_PF_FT(%i_PF%,%j_FT%)		Input-output domain
	ij_P_Y(%i_P%,%j_Y%)		Input-output domain
	ij_PM_Y(%i_PM%,%j_Y%)		Input-output domain
	ij_PS_Y(%i_PS%,%j_Y%)		Input-output domain
	ij_PF_Y(%i_PF%,%j_Y%)		Input-output domain
	ij_PM_M(%i_PM%,%j_M%)		Input-output domain
	ij_P_M(%i_P%,%j_M%)		Input-output domain
	ij_PT_M(%i_PT%,%j_M%)		Input-output domain
	ij_P_YT(%i_P%,%j_YT%)		Input-output domain
	ij_PT_YT(%i_PT%,%j_YT%)		Input-output domain

*	Final demand:
	ih_P_RA(%i_P%,%h_RA%)		Final demand domain

*	Tax payments:

	jh_Y_RA(%j_Y%,%h_RA%)		Tax payments from production
	jh_M_RA(%j_M%,%h_RA%)		Tax payments from trade

*	Endowments:

	hi_RA_P(%h_RA%,%i_P%)		Endowment domain
	hi_RA_PM(%h_RA%,%i_PM%)		Endowment domain
	hi_RA_PF(%h_RA%,%i_PF%)		Endowment domain;

$onechov >>gmr_mcp.gen

j_Y(g,r) = yes$vom(g,r);
j_M(i,r) = yes$vim(i,r);
j_FT(sf,r) = yes$evom(sf,r);
j_YT(j) = yes$vtw(j);

i_P(g,r) = yes$vom(g,r);
i_PM(i,r) = yes$vim(i,r);
i_PT(j) = yes$vtw(j);
i_PF(f,r) = yes$evom(f,r);
i_PS(f,g,r) = yes$(sf(f)*vfm(f,g,r));

h_RA(r) = yes;

*	Intermediate demand:

ij_PS_FT(i_PS(sf,j,r),j_FT(sf,r)) = yes$vfm(sf,j,r);
ij_PF_FT(i_PF(sf,r),j_FT(f,r)) = yes$evom(sf,r);
ij_P_Y(i_P(i,r),j_Y(g,r)) = yes$vdfm(i,g,r);
ij_P_Y(i_P(g,r),j_Y(g,r)) = yes;
ij_PM_Y(i_PM(i,r),j_Y(g,r)) = yes$vifm(i,g,r);
ij_PS_Y(i_PS(sf,g,r),j_Y(g,r)) = yes$vfm(sf,g,r);
ij_PF_Y(i_PF(mf,r),j_Y(g,r)) = yes$vfm(mf,g,r);
ij_PM_M(i_PM(i,r),j_M(i,r)) = yes;
ij_P_M(i_P(i,rr),j_M(i,r)) = yes$vxmd(i,rr,r);
ij_PT_M(i_PT(j),j_M(i,r)) = yes$sum(rr,vtwr(j,i,rr,r));
ij_P_YT(i_P(j,r),j_YT(j)) = yes$vst(j,r);
ij_PT_YT(i_PT(j),j_YT(j)) = yes;
ih_P_RA(i_P("c",r),h_RA(r)) = yes;

*	Tax payments:

jh_Y_RA(j_Y(g,r),h_RA(r)) = yes$(abs(rto(g,r))+sum(i,abs(rtfd(i,g,r))+abs(rtfi(i,g,r)))+sum(f,abs(rtf(f,g,r))));
jh_M_RA(j_M(i,r),h_RA(rr)) = yes$(abs(rtxs(i,rr,r)) or (sameas(r,rr) and sum(rr.local,abs(rtms(i,rr,r)))));

*	Endowment:

hi_RA_P(h_RA(r),i_P(g,r)) = yes$(sum(i(g),abs(sdd(i,r)))+abs(vom(g,r))$(sameas(g,"i") or sameas(g,"g")));
hi_RA_P(h_RA(r),i_P("i",rnum))$vb(r) = yes;
hi_RA_PM(h_RA(r),i_PM(i,r)) = yes$sdi(i,r);
hi_RA_PF(h_RA(r),i_PF(f,r)) = yes$evom(f,r);

*	Set up arrays for retrieving tuples:

indices_Y(j_Y,j_Y) = yes;
indices_M(j_M,j_M) = yes;
indices_FT(j_FT,j_FT) = yes;
indices_YT(j_YT,j_YT) = yes;
indices_P(i_P,i_P) = yes;
indices_PM(i_PM,i_PM) = yes;
indices_PT(i_PT,i_PT) = yes;
indices_PF(i_PF,i_PF) = yes;
indices_PS(i_PS,i_PS) = yes;
indices_RA(h_RA,h_RA) = yes;
$offecho

*	Load macros to return netput values:

$macro  a_P_Y(i_P,j_Y) ( sum(indices_Y(j_Y,g,r), \
			  sum(indices_P(i_P,g,r), vom(g,r)) \
			- sum(indices_P(i_P,i,r), DDFM(i,g,r))))
$macro  a_PM_Y(i_PM,j_Y)( sum(indices_Y(j_Y,g,r), sum(indices_PM(i_PM,i,r), -DIFM(i,g,r))) )
$macro	a_PS_Y(i_PS,j_Y)( sum(indices_Y(j_Y,g,r), sum(indices_PS(i_PS,sf,g,r), -DFM(sf,g,r))) )
$macro  a_PF_Y(i_PF,j_Y)( sum(indices_Y(j_Y,g,r), sum(indices_PF(i_PF,mf,r), -DFM(mf,g,r))) )
$macro tau_Y_RA(j_Y,h_RA) (sum((indices_Y(j_Y,g,r),indices_RA(h_RA,r)), \
	                                 rto(g,r)*vom(g,r)*P(g,r) + \ 
	sum(ij_P_Y( i_P(i,r), j_Y),    rtfd(i,g,r)*DDFM(i,g,r)*P(i,r)) + \ 
	sum(ij_PM_Y(i_PM(i,r),j_Y),    rtfi(i,g,r)*DIFM(i,g,r)*PM(i,r)) + \ 
	sum(ij_PS_Y(i_PS(sf,g,r),j_Y), rtf(sf,g,r)*DFM(sf,g,r)*PS(sf,g,r)) + \ 
	sum(ij_PF_Y(i_PF(mf,r),j_Y),   rtf(mf,g,r)*DFM(mf,g,r)*PF(mf,r)) ) )

$macro  a_PM_M(i_PM,j_M) ( sum(indices_M(j_M,i,r), sum(indices_PM(i_PM,i,r), vim(i,r) )) )
$macro  a_P_M(i_P,j_M)	( sum(indices_M(j_M,i,r), sum(indices_P(i_P,i,rr), -DXMD(i,rr,r))) )
$macro  a_PT_M(i_PT,j_M) ( sum((indices_M(j_M,i,r), indices_PT(i_PT,j), ij_P_M(i,rr,j_M)), -DTWR(j,i,rr,r)) )


$macro  tau_M_RA(j_M,h_RA)	( sum((indices_M(j_M,i,r),indices_RA(h_RA,rt)), \
	sum(ij_P_M(i_P(i,rr),j_M), ( -rtxs(i,rr,r)*DXMD(i,rr,r)*P(i,rr) )$sameas(rt,rr) + \
		  (  rtms(i,rr,r)*( (1-rtxs(i,rr,r))*DXMD(i,rr,r)*P(i,rr)))$sameas(rt,r) + \
	 sum(ij_PT_M(i_PT(j),j_M), rtms(i,rr,r)*DTWR(j,i,rr,r)*PT(j))$sameas(rt,r)) ) )

$macro a_PT_YT(i_PT,j_YT) (sum((indices_YT(j_YT,j),indices_PT(i_PT,j)), vtw(j)))
$macro a_P_YT(i_P,j_YT) (sum((indices_YT(j_YT,j),indices_P(i_P,j,r)), -DST(j,r)))
$macro a_PS_FT(i_PS,j_FT) (sum((indices_FT(j_FT,sf,r),indices_PS(i_PS,sf,j,r)), SFM(sf,j,r)))
$macro a_PF_FT(i_PF,j_FT) (sum((indices_FT(j_FT,sf,r),indices_PF(i_PF,sf,r)),  -evom(sf,r)))
$macro	e_RA_P(h_RA,i_P) ( sum(indices_RA(h_RA,r), \
				sum(indices_P(i_P,i,r), -sdd(i,r)) \
				+ sum(indices_P(i_P,"g",r), -vom("g",r)) \
				+ sum(indices_P(i_P,"i",r), -vom("i",r)) \
				+ sum(indices_P(i_P,"i",rnum), vb(r)) ))

$macro  e_RA_PM(h_RA,i_PM) (sum((indices_RA(h_RA,r),indices_PM(i_PM,i,r)),-sdi(i,r)))
$macro  e_RA_PF(h_RA,i_PF) (sum((indices_RA(h_RA,r),indices_PF(i_PF,f,r)), evom(f,r)))
$macro  d_P_RA(i_P,h_RA)  ( sum((indices_RA(h_RA,r),indices_P(i_P,"c",r)), RA(r)/P("c",r)) )

*	Interface macros translate user request to the corresponding 
*	model-specific macro:

$macro	a(i,j)	 (a_&&i&_&&j(i_&&i,j_&&j)$ij_&&i&_&&j(i_&&i,j_&&j))
$macro	tau(j,h) (tau_&&j&_&&h(j_&&j,h_&&h))$jh_&&j&_&&h(j_&&j,h_&&h)
$macro	e(h,i)	 (e_&&h&_&&i(h_&&h,i_&&i)$hi_&&h&_&&i(h_&&h,i_&&i))
$macro	d(i,h)	 (d_&&i&_&&h(i_&&i,h_&&h)$ih_&&i&_&&h(i_&&i,h_&&h))

*	Algebraic version of the MPSGE model:

equations
	profit_Y(g,r)		Zero profit condition for Y
	profit_M(i,r)		Zero profit condition for M
	profit_FT(f,r)		Zero profit condition for FT
	profit_YT(j)		Zero profit condition for YT

	market_P(g,r)		Market clearance for P
	market_PM(i,r)		Market clearance for PM
	market_PT(j)		Market clearance for PT
	market_PF(f,r)		Market clearance for PF
	market_PS(f,g,r)	Market clearance for PS

	income_RA(r)		Income balance for RA;


$eolcom !

profit_Y(j_Y)..	! $prod:Y(g,r)$vom(g,r)
	- sum(i_P,  P(i_P)   * a(P,Y))		! o:P(g,r), i:P(i,r)
	- sum(i_PM, PM(i_PM) * a(PM,Y))		! i:PM(i,r)
	- sum(i_PS, PS(i_PS) * a(PS,Y))		! i:PS(sf,g,r)
	- sum(i_PF, PF(i_PF) * a(PF,Y))		! i:PF(mf,g,r)
	+ sum(h_RA,            tau(Y,RA))	! t:rto,rtfd,rtfi,rtf
	=e= 0;

profit_M(j_M)..	! $prod:M(i,r)$vim(i,r)	
	- sum(i_PM, PM(i_PM) * a(PM,M))		! o:PM(i,r)
	- sum(i_P,  P(i_P)   * a(P,M))		! i:P(i,Rr)
	- sum(i_PT, PT(i_PT) * a(PT,M))		! i:PT(j)
	+ sum(h_RA,            tau(M,RA) )	! t:rtxs, rtms
	=e= 0;

profit_FT(j_FT)..	! $prod:FT(sf,r)$evom(sf,r)
	- sum(i_PS, PS(i_PS) * a(PS,FT))	! o:PS(sf,j,r)
	- sum(i_PF, PF(i_PF) * a(PF,ft))	! i:PF(sf,r)
	=e= 0;

profit_YT(j_YT)..	! $prod:YT(j)$vtw(j)..
	- sum(i_PT, PT(i_PT) * a(PT,YT))	! o:PT(j) 
	- sum(i_P,  P(i_P)   * a(P,YT))		! i:P(j,r)
	=e= 0;

market_P(i_P)..	
	  sum(j_Y, a(P,Y)   * Y(j_Y))		! $prod:Y(g,r) -- o:P(g,r), i:P(i,r)
	+ sum(j_M, a(P,M)   * M(j_M))		! $prod:M(i,r) -- i:P(i,rr)
	+ sum(j_YT, a(P,YT) * YT(j_YT))		! $prod:YT(j) -- i:P(j,r)
	=e= 
	  sum(h_RA, d(P,RA)-e(RA,P));		! $demand:RA(r) -- d:P("c",r), e:P(i,r), P("g",r), P("i",r), P("i",rnum)

market_PM(i_PM)..
	  sum(j_Y,  a(PM,Y)  * Y(j_Y))		! $prod:Y(g,r) -- i:PM(i,r)
	+ sum(j_M,  a(PM,M)  * M(j_M))		! $prod:M(i,r) -- o:PM(i,r)
	+ sum(h_RA, e(RA,PM))			! $demand:RA(r) -- e:PM(i,r)
	=e= 0;

market_PF(i_PF)..
	  sum(j_FT, a(PF,FT) * FT(j_FT))	! $prod:FT(sf,r)  -- i:PF(sf,r)
	+ sum(j_Y,  a(PF,Y)  * Y(j_Y))		! $prod:Y(g,r) -- i:PF(mf,r)
	+ sum(h_RA, e(RA,PF))			! $demand:RA(r) -- e:PF(r,f)
	=e= 0;

market_PS(i_PS)..
	+ sum(j_Y,  a(PS,Y) * Y(j_Y))		! $prod:Y(g,r) -- i:PS(sf,g,r)
	+ sum(j_FT, a(PS,FT) * FT(j_FT))	! $prod:FT(sf,r)  -- o:PS(sf,j,r)
	=e= 0;

market_PT(i_PT)..
	+ sum(j_YT, a(PT,YT) * YT(j_YT))	! $prod:YT(j) -- o:PT(j)
	+ sum(j_M,  a(PT,M) * M(j_M))		! $prod:M(i,r) -- i:PT(j)
	=e= 0;

income_RA(h_RA)..	!  $demand:RA(r)

	RA(h_RA) =e= 
		+ sum(i_P, P(i_P) * e(RA,P))		! e:P(i,r),P("g",r),P("i",r),P("i",rnum)
		+ sum(i_PM, PM(i_PM) * e(RA,PM))	! e:PM(i,r)
		+ sum(i_PF, PF(i_PF) * e(RA,PF))	! e:PF(f,r)
		+ sum(j_Y, tau(Y,RA) * Y(j_Y))		! $prod:Y(g,r) -- t:rto,rtfd,rtfi,rtf
		+ sum(j_M, tau(M,RA) * M(j_M))		! $prod:M(i,r) -- t:rtxs, rtms
	;

model gmr_mcp /
	profit_Y.Y,
	profit_M.M,
	profit_FT.FT,
	profit_YT.YT,

	market_P.P,
	market_PM.PM,
	market_PT.PT,
	market_PF.PF,
	market_PS.PS,

	income_RA.RA /;

*	Insert income levels:

RA.L(r) = vom("c",r);


$include gmr_mcp.gen

*	Benchmark replication of the MCP model:

gmr_mcp.iterlim = 0;
solve gmr_mcp using mcp;
abort$round(gmr_mcp.objval,3) "Benchmark replication problem with the MCP model.";

*	Counterfactual in the MGE model:

rtms(i,r,rr) = 0;
gmr_mge.iterlim = 10000;
$include gmr_mge.gen
solve gmr_mge using mcp;
abort$round(gmr_mge.objval,3) "Counterfactual solution fails with the MGE model.";


*	Replication of the counterfactual in the MCP model:

RA.FX("USA") = RA.L("USA");
gmr_mcp.iterlim = 0;
$include gmr_mcp.gen
solve gmr_mcp using mcp;
abort$round(gmr_mcp.objval,3) "Counterfactual replication fails with the MCP model.";

*	Cleanup to check that we are not too far off:

gmr_mcp.iterlim = 10000;
$include gmr_mcp.gen
solve gmr_mcp using mcp;
abort$round(gmr_mcp.objval,3) "Cleanup solution fails with the MCP model.";

