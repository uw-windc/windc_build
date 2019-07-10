$TITLE Micro-consistency check on aggregation :/

$IF NOT SET year $SET year 2016
$IF NOT SET aggr	$SET aggr bluenote


* Set directory structure:

$IF NOT SET reldir $SET reldir "."
$IF NOT SET dsdir $SET dsdir "../built_datasets"

$IF NOT SET neos $SET neos "no"
$IF NOT SET neosserver $SET neosserver "neos-server.org:3333"
$IF NOT SET kestrel_nlp $SET kestrel_nlp "conopt"
$IF NOT SET kestrel_lp $SET kestrel_lp "cplex"
$IF NOT SET kestrel_qcp $SET kestrel_qcp "cplex"
$IF NOT SET kestrel_mcp $SET kestrel_mcp "path"

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF


$IFTHENI.kestrel "%neos%" == "yes"
FILE opt / kestrel.opt /;
$ENDIF.kestrel


SET yr "Years of IO data";
SET r "States";
SET s	"Goods and sectors from BEA";
SET gm(s)	"Margin related sectors";
SET m	"Margins (trade or transport)";

$GDXIN %dsdir%%sep%WiNDC_disagg_%aggr%.gdx
$LOADDC yr
$LOADDC r
$LOADDC s
$LOADDC m

ALIAS(s,g);

PARAMETER ys0_(yr,r,g,s) "Sectoral supply";
PARAMETER id0_(yr,r,s,g) "Intermediate demand";
PARAMETER ld0_(yr,r,s) "Labor demand";
PARAMETER kd0_(yr,r,s) "Capital demand";
PARAMETER m0_(yr,r,s) "Imports";
PARAMETER x0_(yr,r,s) "Exports of goods and services";
PARAMETER rx0_(yr,r,s) "Re-exports of goods and services";
PARAMETER md0_(yr,r,m,s) "Total margin demand";
PARAMETER nm0_(yr,r,g,m) "Margin demand from national market";
PARAMETER dm0_(yr,r,g,m) "Margin supply from local market";
PARAMETER s0_(yr,r,s) "Aggregate supply";
PARAMETER a0_(yr,r,s) "Armington supply";
PARAMETER ta0_(yr,r,s) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0_(yr,r,s) "Import tariff";
PARAMETER cd0_(yr,r,s) "Final demand";
PARAMETER c0_(yr,r) "Aggregate final demand";
PARAMETER yh0_(yr,r,s) "Household production";
PARAMETER fe0_(yr,r) "Factor endowments";
PARAMETER bopdef0_(yr,r) "Balance of payments";
PARAMETER hhadj_(yr,r) "Household adjustment";
PARAMETER g0_(yr,r,s) "Government demand";
PARAMETER i0_(yr,r,s) "Investment demand";
PARAMETER xn0_(yr,r,g) "Regional supply to national market";
PARAMETER xd0_(yr,r,g) "Regional supply to local market";
PARAMETER dd0_(yr,r,g) "Regional demand from local market";
PARAMETER nd0_(yr,r,g) "Regional demand from national market";

* Production data:

$LOADDC ys0_
$LOADDC ld0_
$LOADDC kd0_
$LOADDC id0_

* Consumption data:

$LOADDC yh0_
$LOADDC fe0_
$LOADDC cd0_
$LOADDC c0_
$LOADDC i0_
$LOADDC g0_
$LOADDC bopdef0_
$LOADDC hhadj_

* Trade data:

$LOADDC s0_
$LOADDC xd0_
$LOADDC xn0_
$LOADDC x0_
$LOADDC rx0_
$LOADDC a0_
$LOADDC nd0_
$LOADDC dd0_
$LOADDC m0_
$LOADDC ta0_
$LOADDC tm0_

* Margins:

$LOADDC md0_
$LOADDC nm0_
$LOADDC dm0_
$GDXIN


gm(g) = yes$(sum((yr,r,m), (nm0_(yr,r,g,m) + dm0_(yr,r,g,m))) or sum((yr,r,m), md0_(yr,r,m,g)));

PARAMETER ys0(r,g,s) "Sectoral supply";
PARAMETER id0(r,s,g) "Intermediate demand";
PARAMETER ld0(r,s) "Labor demand";
PARAMETER kd0(r,s) "Capital demand";
PARAMETER m0(r,s) "Imports";
PARAMETER x0(r,s) "Exports of goods and services";
PARAMETER rx0(r,s) "Re-exports of goods and services";
PARAMETER md0(r,m,s) "Total margin demand";
PARAMETER nm0(r,g,m) "Margin demand from national market";
PARAMETER dm0(r,g,m) "Margin supply from local market";
PARAMETER s0(r,s) "Aggregate supply";
PARAMETER a0(r,s) "Armington supply";
PARAMETER ta0(r,s) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0(r,s) "Import tariff";
PARAMETER cd0(r,s) "Final demand";
PARAMETER c0(r) "Aggregate final demand";
PARAMETER yh0(r,s) "Household production";
PARAMETER bopdef0(r) "Balance of payments";
PARAMETER hhadj(r) "Household adjustment";
PARAMETER g0(r,s) "Government demand";
PARAMETER i0(r,s) "Investment demand";
PARAMETER xn0(r,g) "Regional supply to national market";
PARAMETER xd0(r,g) "Regional supply to local market";
PARAMETER dd0(r,g) "Regional demand from local  market";
PARAMETER nd0(r,g) "Regional demand from national market";

ys0(r,g,s) = ys0_('%year%',r,g,s);
id0(r,s,g) = id0_('%year%',r,s,g);
ld0(r,s) = ld0_('%year%',r,s);
kd0(r,s) = kd0_('%year%',r,s);
m0(r,g) = m0_('%year%',r,g);
x0(r,g) = x0_('%year%',r,g);
rx0(r,g) = rx0_('%year%',r,g);
md0(r,m,gm) = md0_('%year%',r,m,gm);
nm0(r,gm,m) = nm0_('%year%',r,gm,m);
dm0(r,gm,m) = dm0_('%year%',r,gm,m);
s0(r,g) = s0_('%year%',r,g);
a0(r,g) = a0_('%year%',r,g);
ta0(r,g) = ta0_('%year%',r,g);
tm0(r,g) = tm0_('%year%',r,g);
cd0(r,g) = cd0_('%year%',r,g);
c0(r) = c0_('%year%',r);
yh0(r,g) = yh0_('%year%',r,g);
bopdef0(r) = bopdef0_('%year%',r);
g0(r,g) = g0_('%year%',r,g);
i0(r,g) = i0_('%year%',r,g);
xn0(r,g) = xn0_('%year%',r,g);
xd0(r,g) = xd0_('%year%',r,g);
dd0(r,g) = dd0_('%year%',r,g);
nd0(r,g) = nd0_('%year%',r,g);
hhadj(r) = hhadj_('%year%',r);

PARAMETER y_(r,s) "Sectors and regions with positive production";
PARAMETER x_(r,g) "Disposition by region";
PARAMETER a_(r,g) "Absorption by region";

y_(r,s)$(sum(g, ys0(r,s,g))>0) = 1;
x_(r,g)$s0(r,g) = 1;
a_(r,g)$(a0(r,g) + rx0(r,g)) = 1;

$ontext
$model:aggchk

$sectors:
	Y(r,s)$y_(r,s)		!	Production
	X(r,g)$x_(r,g)		!	Disposition
	A(r,g)$a_(r,g)		!	Absorption
	C(r)			!	Aggregate final demand
	MS(r,m)			!	Margin supply

$commodities:
	PA(r,g)$a0(r,g)		!	Regional market (input)
	PY(r,g)$s0(r,g)		!	Regional market (output)
	PD(r,g)$xd0(r,g)	!	Local market price
	PN(g)			!	National market
	PL(r)			!	Wage rate
	PK(r,s)$kd0(r,s)	!	Rental rate of capital
	PM(r,m)			!	Margin price
	PC(r)			!	Consumer price index
	PFX			!	Foreign exchange

$consumer:
	RA(r)			!	Representative agent

$prod:Y(r,s)$y_(r,s)  s:0 va:1
	o:PY(r,g)	q:ys0(r,s,g)
	i:PA(r,g)	q:id0(r,g,s)
	i:PL(r)		q:ld0(r,s)	va:
	i:PK(r,s)	q:kd0(r,s)	va:

$prod:X(r,g)$x_(r,g)  t:4
	o:PFX		q:(x0(r,g)-rx0(r,g))
	o:PN(g)		q:xn0(r,g)
	o:PD(r,g)	q:xd0(r,g)
	i:PY(r,g)	q:s0(r,g)

$prod:A(r,g)$a_(r,g)  s:0 dm:4  d(dm):2
	o:PA(r,g)	q:a0(r,g)		a:RA(r)	t:ta0(r,g)	p:(1-ta0(r,g))
	o:PFX		q:rx0(r,g)
	i:PN(g)		q:nd0(r,g)	d:
	i:PD(r,g)	q:dd0(r,g)	d:
	i:PFX		q:m0(r,g)	dm: 	a:RA(r)	t:tm0(r,g) 	p:(1+tm0(r,g))
	i:PM(r,m)	q:md0(r,m,g)

$prod:MS(r,m)
	o:PM(r,m)	q:(sum(gm, md0(r,m,gm)))
	i:PN(gm)	q:nm0(r,gm,m)
	i:PD(r,gm)	q:dm0(r,gm,m)

$prod:C(r)  s:1
    	o:PC(r)		q:c0(r)
	i:PA(r,g)	q:cd0(r,g)

$demand:RA(r)
	d:PC(r)		q:c0(r)
	e:PY(r,g)	q:yh0(r,g)
	e:PFX		q:(bopdef0(r) + hhadj(r))
	e:PA(r,g)	q:(-g0(r,g) - i0(r,g))
	e:PL(r)		q:(sum(s,ld0(r,s)))
	e:PK(r,s)	q:kd0(r,s)

$offtext
$SYSINCLUDE mpsgeset aggchk

$IFTHENI %system.filesys% == MSNT
$CALL "copy aggchk.gen %reldir%%sep%temp%sep%aggchk.gen";
$CALL "del aggchk.gen";
$ENDIF

$IFTHENI %system.filesys% == UNIX
$CALL "cp aggchk.gen %reldir%%sep%temp%sep%aggchk.gen";
$CALL "rm aggchk.gen";
$ENDIF

aggchk.workspace = 500;
aggchk.iterlim = 0;

$INCLUDE %reldir%%sep%temp%sep%aggchk.gen

$IFTHENI.kestrel "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_mcp%' /;
PUT 'neos_server %neosserver%';
PUTCLOSE opt;
$ENDIF.kestrel

SOLVE aggchk using mcp;
ABORT$(aggchk.objval > 1e-5) "Error in benchmark calibration with aggregated data.";
