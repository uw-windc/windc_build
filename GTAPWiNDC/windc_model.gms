$title	Read either the static and steady-state datasets and replicate the static equilibrium

$eolcom !

* -----------------------------------------------------------------------------
* set options
* -----------------------------------------------------------------------------

* -----------------------------------------------------------------------------
* read in dataset
* -----------------------------------------------------------------------------

$if not set ds   $set ds cps_static_gtap_32_state

$include windc_data

parameter	
	ls0(r,h)	Labor supply (net),
	esubL(r,h)	Leisure-consumption elasticity,
	etaK		Capital transformation elasticity /4/,
	ta(r,g)		Consumption taxes,
	ty(r,s)		Production taxes
	tm(r,g)		Import taxes,
	tk(r,s)		Capital taxes,
	tl(r,h)		Household labor taxes;

ls0(r,h) = sum(q,le0(r,q,h))*(1-tl0(r,h));

ta(r,g) = ta0(r,g);
ty(r,s) = ty0(r,s);
tm(r,g) = tm0(r,g);
tk(r,s) = tk0(r);
tl(r,h) = tl0(r,h);

* -----------------------------------------------------------------------------
* static model
* -----------------------------------------------------------------------------

$ontext 
$model:mcf_mge

$sectors:
        Y(r,s)$y_(r,s)          !       Production
        X(r,g)$x_(r,g)          !       Disposition
        A(r,g)$a_(r,g)          !       Absorption
	LS(r,h)			!	      Labor supply
	KS			!	      Aggregate capital stock
        C(r,h)			!       Household consumption
        MS(r,m)                 !       Margin supply

$commodities:
        PA(r,g)$a0(r,g)         !       Regional market (input)
        PY(r,g)$s0(r,g)         !       Regional market (output)
        PD(r,g)$xd0(r,g)        !       Local market price
        RK(r,s)$kd0(r,s)	!       Sectoral rental rate
	RKS			!	      Capital stock
        PM(r,m)                 !       Margin price
        PC(r,h)			!       Consumer price index
        PN(g)                   !       National market price for goods
	PLS(r,h)		!	      Leisure price
        PL(r)                   !       Regional wage rate
	PK			!     	Aggregate return to capital
        PFX                     !       Foreign exchange

$consumer:
	RA(r,h)			!	      Representative agent
	NYSE			!	      Aggregate capital owner
	INVEST			!	      Aggregate investor
	GOVT			!	      Aggregate government

$auxiliary:
	      SAVRATE		!	      Domestic savings rate
	      TRANS		!	      Budget balance rationing variable
	      SSK		!	      Steady-state capital stock

$prod:Y(r,s)$y_(r,s)  s:0 va:1
	o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)       p:(1-ty0(r,s))
        i:PA(r,g)       q:id0(r,g,s)
        i:PL(r)         q:ld0(r,s)     va:
        i:RK(r,s)       q:kd0(r,s)     va:	a:GOVT t:tk(r,s)       p:(1+tk0(r))

$report:
	v:KD(r,s)$kd0(r,s)	i:RK(r,s)	prod:Y(r,s)

$prod:X(r,g)$x_(r,g)  t:4
        o:PFX           q:(x0(r,g)-rx0(r,g))
        o:PN(g)         q:xn0(r,g)
        o:PD(r,g)       q:xd0(r,g)
        i:PY(r,g)       q:s0(r,g)

$prod:A(r,g)$a_(r,g)  s:0 dm:4  d(dm):2
        o:PA(r,g)       q:a0(r,g)               a:GOVT t:ta(r,g)       p:(1-ta0(r,g))
        o:PFX           q:rx0(r,g)
        i:PN(g)         q:nd0(r,g)      d:
        i:PD(r,g)       q:dd0(r,g)      d:
        i:PFX           q:m0(r,g)       dm:     a:GOVT t:tm(r,g)       p:(1+tm0(r,g))
        i:PM(r,m)       q:md0(r,m,g)

$report:
	v:MD(r,g)$m0(r,g)	i:PFX	prod:A(r,g)

$prod:MS(r,m)
        o:PM(r,m)       q:(sum(g, md0(r,m,g)))
        i:PN(gm)        q:nm0(r,gm,m)
        i:PD(r,gm)      q:dm0(r,gm,m)

$prod:C(r,h)	  s:1
        o:PC(r,h)       q:c0_h(r,h)
        i:PA(r,g)       q:cd0_h(r,g,h)

$prod:LS(r,h)
	o:PL(q)		q:le0(r,q,h)	a:GOVT	t:tl(r,h)	p:(1-tl0(r,h))
	i:PLS(r,h)	q:ls0(r,h)

$prod:KS  t:etaK
	o:RK(r,s)	q:kd0(r,s)
	i:RKS		q:(sum((r,s),kd0(r,s)))

$demand:RA(r,h)	  
	e:PLS(r,h)	q:ls0(r,h)
	d:PC(r,h)       q:c0_h(r,h)
	e:PFX		q:(sum(trn, hhtrn0(r,h,trn)))	r:TRANS
	e:PK		q:ke0(r,h)
	e:PFX		q:(-sav0(r,h))	r:SAVRATE

$report:
	v:W(r,h)	w:RA(r,h)

$demand:NYSE
	d:PK
	e:PY(r,g)	q:yh0(r,g)
	e:RKS		  q:(sum((r,s),kd0(r,s)))	r:SSK

$demand:INVEST  s:0
	d:PA(r,g)	q:i0(r,g)
	e:PFX		  q:totsav0	r:SAVRATE
	e:PFX		  q:fsav0

$demand:GOVT
	d:PA(r,g)	q:g0(r,g)
	e:PFX           q:(-sum((r,h,trn), hhtrn0(r,h,trn)))	r:TRANS	
	e:PFX           q:govdef0

$constraint:SSK
	sum((r,g),i0(r,g)*PA(r,g)) =e= sum((r,g),i0(r,g))*RKS;

$constraint:SAVRATE
	INVEST =e= sum((r,g), PA(r,g)*i0(r,g))*SSK;

$constraint:TRANS
	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));

$offtext
$sysinclude mpsgeset mcf_mge -mt=1

TRANS.L = 1;
SAVRATE.L = 1;
SSK.FX = 1;

mcf_mge.workspace = 1000;
mcf_mge.iterlim=0;
$include %gams.scrdir%mcf_mge.gen
solve mcf_mge using mcp;

abort$round(mcf_mge.objval,4) "Benchmark calibration of mcf_mge fails.";

set	macct	Macro accounts /
		C	Household consumption,
		G	Public expenditure
		D	Government deficit
		I	Investment
		L	Labor income
		T	Government to household transfers
		K	Capital income
		S	Household saving
		F	Foreign savings
		GDP	Gross domestic product /;
		

parameter	macroaccounts(macct,*)	Macro economic accounts;
macroaccounts("C","$") = sum((r,h),c0_h(r,h));
macroaccounts("G","$") = sum((r,g),g0(r,g));
macroaccounts("D","$") = govdef0 + fsav0;
macroaccounts("I","$") = sum((r,g),i0(r,g));
macroaccounts("L","$") = sum((r,h),ls0(r,h));
macroaccounts("T","$") = sum((r,h,trn),hhtrn0(r,h,trn));
macroaccounts("K","$") = sum((r,h),ke0(r,h));
macroaccounts("S","$") = sum((r,h),sav0(r,h));
macroaccounts("F","$") = fsav0 + govdef0;
macroaccounts("GDP","$") = macroaccounts("C","$") + macroaccounts("G","$") + macroaccounts("I","$") - fsav0 - govdef0;

macroaccounts("C","%GDP") = 100 * macroaccounts("C","$")/macroaccounts("GDP","$");
macroaccounts("G","%GDP") = 100 * macroaccounts("G","$") / macroaccounts("GDP","$");
macroaccounts("D","%GDP") = 100 * macroaccounts("D","$") / macroaccounts("GDP","$");
macroaccounts("I","%GDP") = 100 * macroaccounts("I","$") / macroaccounts("GDP","$");
macroaccounts("L","%GDP") = 100 * macroaccounts("L","$") / macroaccounts("GDP","$");
macroaccounts("T","%GDP") = 100 * macroaccounts("T","$") / macroaccounts("GDP","$");
macroaccounts("K","%GDP") = 100 * macroaccounts("K","$") / macroaccounts("GDP","$");
macroaccounts("S","%GDP") = 100 * macroaccounts("S","$") / macroaccounts("GDP","$");
macroaccounts("F","%GDP") = 100 * macroaccounts("F","$") / macroaccounts("GDP","$");

option macct:0:0:1;
option macroaccounts:3;
display macroaccounts macct;

$exit

set	agrfoo(g)	Agricultural and food products /
	fbp	"Food and beverage and tobacco products (311FT)",
	agr	"Agricultural products"/;

parameter	expend(*,g,h)	Household consumption expenditures;
expend("$",agrfoo(g),h) = sum(r,cd0_h(r,g,h));
expend("%",agrfoo(g),h)$expend("$",g,h) 
			= 100 * sum(r,cd0_h(r,g,h)) / sum((r,g.local),cd0_h(r,g,h));
option expend:1:2:1;
display expend;
$exit

