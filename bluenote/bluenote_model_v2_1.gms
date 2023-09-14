$title	Legacy bluenote-based energy tax model (no households)

* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* set the dataset (without file extension)
$if not set ds $set ds WiNDC_bluenote_cps_state_2017

* file separator
$set sep %system.dirsep%

* convert these environment variables to $setglobal so that they are
* passed through to the included files:
$setglobal ds    %ds%


* -----------------------------------------------------------------------------
* Read in dataset
* -----------------------------------------------------------------------------

$include readdata_v2_1

parameter
    etaK	Capital transformation elasticity /4/,
    ta(r,g)	Consumption taxes,
    ty(r,s)	Production taxes,
    tm(r,g)	Import taxes,
    te(r,g)	Energy data (ad-valorem)
    tk(r,s)     Capital taxes;

ta(r,g) = ta0(r,g);
ty(r,s) = ty0(r,s);
tm(r,g) = tm0(r,g);
tk(r,s) = tk0(r);
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

* (re)calculate additional aggregate parameters

govdef0 = sum((r,g), g0(r,g))
        - sum(r, bopdef0(r))
        - sum(r, tk0(r)*sum(s, kd0(r,s) + rd0(r,s)))
	- sum((r,s,g)$y_(r,s), ty0(r,s) * ys0(r,s,g)) 
	- sum((r,g)$a_(r,g),   ta0(r,g)*a0(r,g) + tm0(r,g)*m0(r,g));

hhadj(r) = c0(r) + sum(g, i0(r,g)) - (sum(s, ld0(r,s) + kd0(r,s) + rd0(r,s) + yh0(r,s)));


* -----------------------------------------------------------------------------
* energy model based on bluenote recalibration
* -----------------------------------------------------------------------------

$ontext 
$model:energy

$sectors:
        Y(r,s)$y_(r,s)          !       Production
        X(r,g)$x_(r,g)          !       Disposition
        A(r,g)$a_(r,g)          !       Absorption
        C(r)			!       Household consumption
        MS(r,m)                 !       Margin supply

$commodities:
        PA(r,g)$a0(r,g)         !       Regional market (input)
        PY(r,g)$s0(r,g)         !       Regional market (output)
        PD(r,g)$xd0(r,g)        !       Local market price
        RK(r,s)$kd0(r,s)	!       Sectoral rental rate
	PR(r,s)$rd0(r,s)	!	Energy resource earnings
        PM(r,m)                 !       Margin price
        PC(r)			!       Consumer price index
        PN(g)                   !       National market price for goods
        PL(r)                   !       Regional wage rate
        PFX                     !       Foreign exchange

$consumer:
        RA(r)			!	Representative agent
	GOVT			!	Aggregate government

$auxiliary:
	TRANS			!	Budget balance rationing variable

$prod:Y(r,s)$(y_(r,s) and nx(s))  t:0 s:0.5 e:1 m:0 va(m):1
	o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)       p:(1-ty0(r,s))
        i:PA(r,g)       q:id0(r,g,s)   		a:GOVT t:te(r,g)       e:$(eg(g) and (not sameas(g,s))) m:$((not eg(g)) or sameas(g,s))
        i:PL(r)         q:ld0(r,s)     va:
        i:RK(r,s)       q:kd0(r,s)     va:	a:GOVT t:tk(r,s)       p:(1+tk0(r))

$prod:Y(r,s)$(y_(r,s) and xi(s))  t:0 s:sigmax(r,s) m:0
	o:PY(r,g)	q:ys0(r,s,g)	a:GOVT t:ty(r,s)		p:(1-ty0(r,s))
        i:PA(r,g)       q:id0(r,g,s)	a:GOVT t:te(r,g)	m:
        i:PL(r)         q:ld0(r,s)				m:
	i:PR(r,s)	q:rd0(r,s)	a:GOVT t:tk(r,s)		p:(1+tk0(r))

$report:
	v:KD(r,s)$kd0(r,s)		i:RK(r,s)	prod:Y(r,s)
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

$prod:C(r)	  s:0.5  e:1  c:1
        o:PC(r)       	q:c0(r)
        i:PA(r,g)       q:cd0(r,g)	a:GOVT t:te(r,g) e:$eg(g) c:$(not eg(g))

$report:
	v:EDC(r,g)$eg(g)	i:PA(r,g)	prod:C(r)

$demand:RA(r)
        d:PC(r)         q:c0(r)
	e:PA(r,g)	q:(-i0(r,g))
	e:PL(r)		q:(sum(s, ld0(r,s)))
        e:RK(r,s)	q:kd0(r,s)
        e:PR(r,s)	q:rd0(r,s)
	e:PY(r,s)	q:yh0(r,s)
	e:PFX		q:hhadj(r)	r:TRANS

$report:
	v:W(r)		w:RA(r)

$demand:GOVT
	d:PA(r,g)	q:g0(r,g)
	e:PFX		q:(sum(r, bopdef0(r)))
	e:PFX           q:govdef0	r:TRANS

$constraint:TRANS
	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));

$offtext
$sysinclude mpsgeset energy

PFX.FX = 1;
TRANS.L = 1;

energy.workspace = 100;
energy.iterlim=0;
$include energy.gen
solve energy using mcp;
