$title	bluenote-based energy tax model

* -----------------------------------------------------------------------------
* set options
* -----------------------------------------------------------------------------

* set the dataset (without file extension)
$if not set ds $set ds WiNDC_bluenote_cps_state_2017

* file separator
$set sep %system.dirsep%

* convert these environment variables to $setglobal so that they are
* passed through to the included files:
$setglobal ds    %ds%


* -----------------------------------------------------------------------------
* read in dataset
* -----------------------------------------------------------------------------

$include readdata

parameter
    ls0(r,h)	Labor supply (net),
    lsr0(r,h)	Leisure demand,
    esubL(r,h)	Leisure-consumption elasticity,
    etaK	Capital transformation elasticity /4/,
    ta(r,g)	Consumption taxes,
    ty(r,s)	Production taxes,
    tm(r,g)	Import taxes,
    te(r,g)	Energy data (ad-valorem)
    tk(r,s)     Capital taxes,
    tl(r,h)	Labor taxes;

ls0(r,h) = sum(q,le0(r,q,h))*(1-tl0(r,h));
lsr0(r,h) = 0.75 * ls0(r,h);
esubL(r,h) = 2;

ta(r,g) = ta0(r,g);
ty(r,s) = ty0(r,s);
tm(r,g) = tm0(r,g);
tk(r,s) = tk0(r);
tl(r,h) = tl0(r,h);
te(r,g) = 0;

* energy goods in the bluenote dataset:
set
    eg(g)	Energy goods /col, gas, oil, ele/,
    ffuel(g)	Fossil fuels /col, gas, oil/,
    xi(s)	Extractive industries /col, cru, gas/
    nx(s)	Non-extractive industries;

parameters
    rd0(r,s)	Resource demand
    sigmax(r,s)	Fossil fuel Supply elasticity response
    eta(s)	Price elasticity of fossil fuel supply / cru 2, gas 2, col 4/
    thetard(r,s) Resource demand value share;

thetard(r,xi(s))$sum(g,ys0(r,s,g)) = kd0(r,s)*(1+tk0(r))/sum(g,ys0(r,s,g));
sigmax(r,xi(s))$thetard(r,s) = eta(s) * (1-thetard(r,s))/thetard(r,s);
nx(s) = (not xi(s));
rd0(r,xi(s)) = kd0(r,s);
kd0(r,xi) = 0;


* -----------------------------------------------------------------------------
* Energy model based on bluenote recalibration
* -----------------------------------------------------------------------------

$ontext 
$model:energy

$sectors:
        Y(r,s)$y_(r,s)          !       Production
        X(r,g)$x_(r,g)          !       Disposition
        A(r,g)$a_(r,g)          !       Absorption
	LS(r,h)			!	Labor supply
	KS			!	Aggregate capital stock
        C(r,h)			!       Household consumption
        MS(r,m)                 !       Margin supply

$commodities:
        PA(r,g)$a0(r,g)         !       Regional market (input)
        PY(r,g)$s0(r,g)         !       Regional market (output)
        PD(r,g)$xd0(r,g)        !       Local market price
        RK(r,s)$kd0(r,s)	!       Sectoral rental rate
	PR(r,s)$rd0(r,s)	!	Energy resource earnings
	RKS			!	Capital stock
        PM(r,m)                 !       Margin price
        PC(r,h)			!       Consumer price index
        PN(g)                   !       National market price for goods
	PLS(r,h)		!	Leisure price
        PL(r)                   !       Regional wage rate
	PK			!     	Aggregate return to capital
        PFX                     !       Foreign exchange

$consumer:
        RA(r,h)			!	Representative agent
	NYSE			!	Aggregate capital owner
	INVEST			!	Aggregate investor
	GOVT			!	Aggregate government

$auxiliary:
	SAVRATE			!	Domestic savings rate
	TRANS			!	Budget balance rationing variable
	SSK			!	Steady-state capital stock

$prod:Y(r,s)$(y_(r,s) and nx(s))  t:0 s:0.5 e:1 m:0 va(m):1
	o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)       p:(1-ty0(r,s))
        i:PA(r,g)       q:id0(r,g,s)   a:GOVT t:te(r,g)	e:$(eg(g) and (not sameas(g,s))) m:$((not eg(g)) or sameas(g,s))
        i:PL(r)         q:ld0(r,s)     va:
        i:RK(r,s)       q:kd0(r,s)     va:	a:GOVT t:tk(r,s)       p:(1+tk0(r))

$prod:Y(r,s)$(y_(r,s) and xi(s))  t:0 s:sigmax(r,s) m:0
	o:PY(r,g)	q:ys0(r,s,g)	a:GOVT t:ty(r,s)		p:(1-ty0(r,s))
        i:PA(r,g)       q:id0(r,g,s)	a:GOVT t:te(r,g)	m:
        i:PL(r)         q:ld0(r,s)				m:
	i:PR(r,s)	q:rd0(r,s)      a:GOVT t:tk(r,s)	p:(1+tk0(r))

$report:
	v:KD(r,s)$kd0(r,s)			i:RK(r,s)	prod:Y(r,s)
	v:ED(r,g,s)$(eg(g) and y_(r,s))	i:PA(r,g)	prod:Y(r,s)

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
        o:PM(r,m)       q:(sum(gm, md0(r,m,gm)))
        i:PN(gm)        q:nm0(r,gm,m)
        i:PD(r,gm)      q:dm0(r,gm,m)

$prod:C(r,h)	  s:0.5  e:1  c:1
        o:PC(r,h)       q:c0_h(r,h)
        i:PA(r,g)       q:cd0_h(r,g,h)	a:GOVT t:te(r,g) e:$eg(g) c:$(not eg(g))

$report:
	v:EDC(r,g,h)$eg(g)		i:PA(r,g)	prod:C(r,h)

$prod:LS(r,h)
	o:PL(q)		q:le0(r,q,h)	a:GOVT	t:tl(r,h)	p:(1-tl0(r,h))
	i:PLS(r,h)	q:ls0(r,h)

$prod:KS	t:etaK
	o:RK(r,s)	q:kd0(r,s)
	i:RKS		q:(sum((r,s),kd0(r,s)))

$demand:RA(r,h)	  s:esubL(r,h)
        d:PC(r,h)       q:c0_h(r,h)
	d:PLS(r,h)	q:lsr0(r,h)
	e:PLS(r,h)	q:(ls0(r,h)+lsr0(r,h))
	e:PFX		q:(sum(trn, hhtrn0(r,h,trn)))	r:TRANS
        e:PK		q:ke0(r,h)
	e:PFX		q:(-sav0(r,h))			r:SAVRATE

$report:
	v:W(r,h)	w:RA(r,h)

$demand:NYSE
	d:PK
	e:PY(r,g)	q:yh0(r,g)
	e:PR(r,s)	q:rd0(r,s)
	e:RKS		q:(sum((r,s),kd0(r,s)))	r:SSK

$demand:INVEST  s:0
	d:PA(r,g)	q:i0(r,g)
	e:PFX		q:totsav0	r:SAVRATE
	e:PFX		q:fsav0

$demand:GOVT
	d:PA(r,g)	q:g0(r,g)
	e:PFX           q:govdef0
	e:PFX           q:(-sum((r,h), trn0(r,h)))	r:TRANS	

$constraint:SSK
	sum((r,g),i0(r,g)*PA(r,g)) =e= sum((r,g),i0(r,g))*RKS;

$constraint:SAVRATE
	INVEST =e= sum((r,g), PA(r,g)*i0(r,g))*SSK;

$constraint:TRANS
	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));

$offtext
$sysinclude mpsgeset energy

TRANS.L = 1;
SAVRATE.L = 1;
SSK.FX = 1;

energy.workspace = 100;
energy.iterlim=0;
$include energy.gen
solve energy using mcp;

set taxes /tl, tk, ty, ta, tm, te_y, te_c/;	

parameter
    pnum	Numeraire price index;

pnum = sum((r,h),c0_h(r,h)*PC.L(r,h))/sum((r,h),c0_h(r,h));

parameter
    revenue	Tax Revenue by Instrument and Region;

revenue("bmk",r,"TL") =	sum((h,q), tl(r,h) * LS.L(r,h)* le0(r,q,h) * PL.L(q))/pnum;

revenue("bmk",r,"TK") =	sum((s), tk(r,s) * KD.L(r,s) * RK.L(r,s)/pnum);

revenue("bmk",r,"ty") = sum((s)$y_(r,s), ty(r,s)*Y.L(r,s)*sum(g,ys0(r,s,g)*PY.L(r,g))/pnum);

revenue("bmk",r,"ta") =  sum((g)$a_(r,g), A.L(r,g)*a0(r,g)*ta(r,g)*PA.L(r,g)/pnum);

revenue("bmk",r,"tm") = sum((g)$m0(r,g), tm(r,g) * MD.L(r,g)*PFX.L/pnum);

revenue("bmk",r,"te_y") = sum((s)$y_(r,s), sum(eg(g),ED.L(r,g,s)*PA.L(r,g)*te(r,g)/pnum));

revenue("bmk",r,"te_c") = sum((h), sum(eg(g), EDC.L(r,g,h)*PA.L(r,g)*te(r,g)/pnum));

revenue("bmk",r,"revenue") = sum(taxes,revenue("bmk",r,taxes));

revenue("bmk",r,"G.L") = GOVT.L / sum((r.local,g),PA.L(r,g)*g0(r,g));;

revenue("bmk",r,"GOVT.L") = sum(g,PA.L(r,g)*g0(r,g))/pnum * revenue("bmk",r,"G.L");


revenue("bmk","total","chk") = sum(r,revenue("bmk",r,"GOVT.L"))
		- (govdef0 + sum((r,h), trn0(r,h))*(1-TRANS.L))*PFX.L/pnum 
		- sum((r,taxes),revenue("bmk",r,taxes));

alias (u,*);
revenue("bmk","total",u) = sum(r, revenue("bmk",r,u));

option revenue:1:2:1;
display revenue;
