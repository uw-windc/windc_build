$title	 GTAPinGAMS -- GAMS/MPSGE Formulation

$if not set gtapv $set gtapv 10
$if not set yr    $set yr    14
$if not set ds    $set ds    g20_macro

$include %system.fp%gtapdata

$ontext
$model:gtap

$sectors:
	Y(g,r)$(rm(r)*vom(g,r))		! Supply
	M(i,r)$(rm(r)*vim(i,r))		! Imports
	YT(j)$vtw(j)			! Transportation services
	FT(f,r)$(rm(r)*sf(f)*evom(f,r))	! Specific factor transformation
	A(i,r)$(rm(r)*vcm(i,r))		! Armington final demand quantity index (CDE model)
	X(i,r)$vem(i,r)			! Exports to or from rest of world (SOE model)

$commodities:
	P(g,r)$(rm(r)*(vom(g,r)-vxm(g,r)))		! Domestic output price
	PE(g,r)$(rx(r)*vem(g,r)+rm(r)*vxm(g,r))		! Export market
	PM(j,r)$(rm(r)*vim(j,r))			! Import price
	PT(j)$vtw(j)					! Transportation services
	PF(f,r)$(rm(r)*evom(f,r))			! Primary factors rent
	PS(f,g,r)$(rm(r)*sf(f)*vfm(f,g,r))		! Sector-specific primary factors
	PFX$card(rx)					! Real exchange rate (SOE model)
	PA(i,r)$(rm(r)*vcm(i,r))			! Armington final demand price

$consumers:
	RA(r)$rm(r)		! Representative agent
	ROW$card(rx)		! Rest of world (SOE model)

$auxiliary:
	D(i,r)$(rm(r)*vcm(i,r)) ! Demand (index)
	U(r)$(rm(r)*cde(r))	! Utility (index)
	CC(r)$(rm(r)*cde(r))	! Consumption cost index
	W(r)$(rm(r)*cde(r))	! Per capita welfare (money metric index);

$prod:Y(g,r)$(rm(r)*vom(g,r)) s:0 t:etadx(g) m:esub(g,r) va:esubva(g) i.tl(m):esubdm(i)  
	o:P(g,r)	q:(vom(g,r)-vxm(g,r))	a:RA(r)  t:rto(g,r)	p:(1-rto(g,r))
	o:PE(g,r)	q:vxm(g,r)		a:RA(r)  t:rto(g,r)	p:(1-rto(g,r))
	i:P(i,r)	q:vdfm(i,g,r)	p:(1+rtfd0(i,g,r)) i.tl:  a:RA(r) t:rtfd(i,g,r)
	i:PM(i,r)	q:vifm(i,g,r)	p:(1+rtfi0(i,g,r)) i.tl:  a:RA(r) t:rtfi(i,g,r)
	i:PS(sf,g,r)	q:vfm(sf,g,r)	p:(1+rtf0(sf,g,r))  va:   a:RA(r) t:rtf(sf,g,r)
	i:PF(mf,r)	q:vfm(mf,g,r)	p:(1+rtf0(mf,g,r))  va:   a:RA(r) t:rtf(mf,g,r)

$prod:YT(j)$vtw(j)  s:1
	o:PT(j)				q:vtw(j)
	i:PE(j,r)$(rm(r)*vxm(j,r)) 	q:vst(j,r)
	i:P(j,r)$(rm(r)*(not vxm(j,r)))	q:vst(j,r)
	i:PFX				q:(sum(rx,vst(j,rx)))

$prod:M(i,r)$(rm(r)*vim(i,r))	s:esubm(i)  s.tl:0
	o:PM(i,r)			q:vim(i,r)
	i:PE(i,rm)$vxm(i,rm)		q:vxmd(i,rm,r)	p:pvxmd(i,rm,r) rm.tl: 
+		a:RA(rm) t:(-rtxs(i,rm,r)) a:RA(r) t:(rtms(i,rm,r)*(1-rtxs(i,rm,r)))
	i:P(i,rm)$(not vxm(i,rm))	q:vxmd(i,rm,r)	p:pvxmd(i,rm,r) rm.tl:
+		a:RA(rm) t:(-rtxs(i,rm,r)) a:RA(r) t:(rtms(i,rm,r)*(1-rtxs(i,rm,r)))
	i:PT(j)#(s)			q:vtwr(j,i,s,r) p:pvtwr(i,s,r) s.tl: a:RA(r) t:rtms(i,s,r)
	i:PE(i,rx)$vem(i,rx)		q:vxmd(i,rx,r)	p:pvxmd(i,rx,r) rx.tl: 
+		a:ROW    t:(-rtxs(i,rx,r)) a:RA(r) t:(rtms(i,rx,r)*(1-rtxs(i,rx,r)))

$prod:FT(sf,r)$(rm(r)*evom(sf,r))  t:etrae(sf)
	o:PS(sf,j,r)	q:vfm(sf,j,r)
	i:PF(sf,r)	q:evom(sf,r)

$demand:RA(r)$rm(r)  s:0
	d:P(cd,r)		q:vom(cd,r)
	e:P("g",r)		q:(-vom("g",r))
	e:P("i",r)		q:(-vom("i",r))
	e:P("i",rnum)$rm(rnum)	q:vb(r)
	e:PFX$rx(rnum)		q:vb(r)
	e:PF(f,r)		q:evom(f,r)

*	Coefficient for the LES demand system:

	e:P("sd",r)		q:(-vom("sd",r))

*	Coefficient for the CDE demand system:

	d:PF(f,r)$cde(r)	q:evom(f,r)
	e:PF(f,r)$cde(r)	q:evom(f,r)
	e:PA(i,r)$cde(r)	q:(-vcm(i,r))	R:D(i,r)

*	-------------------------------------------------------------------
*	Additional code for the SOE closure:

$prod:X(i,r)$(rm(r)*vem(i,r))
	o:PFX				q:(pem0(i,r)*vem(i,r))
	i:P(i,r)$(not vxm(i,r))		q:vem(i,r)	a:RA(r)	t:(-rtxs_row(i,r))
	i:PE(i,r)$vxm(i,r)		q:vem(i,r)	a:RA(r)	t:(-rtxs_row(i,r))

$prod:X(i,r)$(rx(r)*vem(i,r))
	o:PE(i,r)		q:vem(i,r)
	i:PFX			q:vem(i,r)

$demand:ROW$card(rx)
	e:PFX			q:rowpfx
	e:P("i",rnum)$rm(rnum)	q:(-sum(rm,vb(rm)))
	e:PT(j)			q:(-sum((i,s,rx), vtwr(j,i,s,rx)))
	d:PFX

$prod:A(i,r)$(rm(r)*vcm(i,r))  s:esubdm(i)  
	o:PA(i,r)	q:vcm(i,r)
	i:P(i,r)	q:vdfm(i,"c",r)	p:(1+rtfd0(i,"c",r)) a:RA(r) t:rtfd(i,"c",r)
	i:PM(i,r)	q:vifm(i,"c",r)	p:(1+rtfi0(i,"c",r)) a:RA(r) t:rtfi(i,"c",r)


$constraint:D(i,r)$(rm(r)*vcm(i,r))
	D(i,r) * sum(j$thetac(j,r), thetac(j,r) * 
	  U(r)**((1-subpar(j,r))*incpar(j,r)) * 
		(PA(j,r)/CC(r))**(1-subpar(j,r))) 
		   =e= U(r)**((1-subpar(i,r))*incpar(i,r)) *
			(PA(i,r)/CC(r))**(-subpar(i,r));

$constraint:U(r)$(cde(r)*rm(r))
	sum(f, PF(f,r)*evom(f,r)) =e= RA(r);

$constraint:CC(r)$(cde(r)*rm(r))
	sum(i, thetac(i,r) * U(r)**((1-subpar(i,r))*incpar(i,r)) * 
		(PA(i,r)/CC(r))**(1-subpar(i,r))) =e= 1;

$constraint:W(r)$(cde(r)*rm(r))
	sum(i, thetac(i,r) * U(r)**((1-subpar(i,r))*incpar(i,r)) * 
			 (1/W(r))**(1-subpar(i,r))) =e= 1;

$report:
	v:V_VST(i,r)$(vst(i,r) and rm(r) and (not vxm(i,r)))	i:P(i,r)	prod:YT(i)
	v:V_VST(i,r)$(vst(i,r) and rm(r) and vxm(i,r))		i:PE(i,r)	prod:YT(i)
	v:V_VDM(g,r)$(rm(r)*(vom(g,r)-vxm(g,r)))		o:P(g,r)	prod:Y(g,r)
	v:V_XMD(i,s,r)$(vxmd(i,s,r)*rm(s)*vxm(i,s))		i:PE(i,s) 	prod:M(i,r)
	v:V_XMD(i,s,r)$(vxmd(i,s,r)*rx(s))			i:PE(i,s) 	prod:M(i,r)
	v:V_VXM(g,r)$(rm(r)*vom(g,r)*vxm(g,r))			o:PE(g,r)	prod:Y(g,r)
	v:V_DFM(i,g,r)$(rm(r)*vom(g,r)*vdfm(i,g,r))		i:P(i,r)	prod:Y(g,r)
	v:V_IFM(i,g,r)$(rm(r)*vom(g,r)*vifm(i,g,r))		i:PM(i,r)	prod:Y(g,r)
	v:V_FM(f,g,r)$(sf(f)*rm(r)*vom(g,r)*vfm(f,g,r))		i:PS(f,g,r)	prod:Y(g,r)
	v:V_FM(f,g,r)$(mf(f)*rm(r)*vom(g,r)*vfm(f,g,r))		i:PF(f,r)	prod:Y(g,r)
	v:V_XMD(i,s,r)$(vxmd(i,s,r)*rm(s)*(not vxm(i,s)))	i:P(i,s) 	prod:M(i,r)
	v:V_VDA(i,r)$(RM(R)*vcm(i,r)*vdfm(i,"c",r))		i:P(i,r)	PROD:A(i,r)
	v:V_VIA(i,r)$(RM(R)*vcm(i,r)*vifm(i,"c",r))		i:PM(i,r)	PROD:A(i,r)

$offtext
$sysinclude mpsgeset gtap
$call 'mv -f gtap.gen %gtapv%.gen'

alias (i,i_,j_), (f,f_);

$macro	pnum	(P("c",rnum))
$macro DFM(f,g,r)	(V_FM.L(f,g,r)$(rm(r)*vom(g,r)*vfm(f,g,r)))
$macro DDFM(i,g,r)	(V_DFM.L(i,g,r) + V_VDA.L(i,r)$(vcm(i,r) and sameas(g,"c")))
$macro DIFM(i,g,r)	(V_IFM.L(i,g,r) + V_VIA.L(i,r)$(vcm(i,r) and sameas(g,"c")))
$macro REV_TO(g,r)	((rto(g,r)*((P.L(g,r)*V_VDM.L(g,r))$(vom(g,r)-vxm(g,r))+(PE.L(g,r)*v_vxm.L(g,r))$vxm(g,r)))$(rm(r)*vom(g,r)))
$macro REV_TFD(i,g,r)	(rtfd(i,g,r) * P.L(i,r)  * DDFM(i,g,r))
$macro REV_TFI(i,g,r)	(rtfi(i,g,r) * PM.L(i,r) * DIFM(i,g,r))
$macro REV_TF(f,g,r) 	((rtf(f,g,r)  * v_fm.L(f,g,r) * ((PS.L(f,g,r))$sf(f)+(PF.L(f,r))$mf(f)))$(rm(r)*vom(g,r)*vfm(f,g,r)))
$macro XMD(i,s,r)	((V_XMD.L(i,s,r)/vxmd(i,s,r))$(rm(r)*vim(i,r)*vxmd(i,s,r)) + X.L(i,s)$(rm(s) and rx(r) and vxmd(i,s,r)))
$macro PX(i,r)		((P.L(i,r)$(not vxm(i,r)) + PE.L(i,r)$vxm(i,r))$rm(r) + PE.L(i,r)$rx(r))
$macro REV_TXS(i,s,r)	((XMD(i,s,r)*rtxs(i,s,r)*vxmd(i,s,r) * PX(i,s))$(rm(s)*vxmd(i,s,r)*rtxs(i,s,r)))
$macro REV_TMS(i,s,r)	((XMD(i,s,r)*rtms(i,s,r)*(PX(i,s)*(1-rtxs(i,s,r))*vxmd(i,s,r)  + \
			 sum(j_$vtwr(j_,i,s,r), PT.L(j_)*vtwr(j_,i,s,r))))$(rm(r)*vxmd(i,s,r)*rtms(i,s,r)))

gtap.workspace = 1024;
gtap.iterlim = 0;
$include %gtapv%.gen
solve gtap using mcp;

parameter	maxdev	Maximum permissible deviation /1e-3/;

abort$(gtap.objval > maxdev) "GTAP replication fails.", gtap.objval;
$exit



gtap.iterlim = 10000;

alias (r,rr);

parameter	iterlog	Log of impacts;

loop(rr,
	rtms(i,r,rr) = 0;

$include %gtapv%.gen
	solve gtap using mcp;

	iterlog(rr,g) = 100*(Y.L(g,rr)-1);

	rtms(i,r,s) = rtms0(i,r,s);

);


$exit

parameter	va(i,r)		Value added
		vi(i,g,r)	Intermediate demand;

vi(i,g,r) = vifm(i,g,r)*(1+rtfi0(i,g,r))+vdfm(i,g,r)*(1+rtfd0(i,g,r));
va(i,r) = vom(i,r)*(1-rto(i,r)) - sum(j,vi(j,i,r));
display vom, va;


gtap.iterlim = 1000;

parameter rt0(g,r)	Initial output taxes (in %);

rt0(g,r) = 100*rto(g,r);

rto(g,r) = 0;
$include gtap.gen
solve gtap using mcp;

parameter welfare;

welfare(r)	= 100*(Y.l("c",r) - 1);
welfare("all")	= 100*(sum(r, Y.l("c",r)*vom("c",r))/sum(r, vom("c",r)) - 1);

display welfare;

