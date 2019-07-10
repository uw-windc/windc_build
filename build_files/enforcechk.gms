$TITLE Micro-consistency check without subnational trade flows

$IF NOT SET year $SET year 2016
$IF NOT SET satdata $SET satdata bluenote

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


SET r "States";
SET s	"Goods\sectors (national data)";
SET m	"Margins (trade or transport)";
SET gm(s)	"Commodities employed in margin supply";

$GDXIN %dsdir%%sep%WiNDC_cal_%year%_%satdata%.gdx
$LOADDC r
$LOADDC s
$LOADDC m

ALIAS(s,g),(r,rr);

PARAMETER ys0(r,s,g) "Sectoral supply";
PARAMETER id0(r,g,s) "Intermediate demand";
PARAMETER ld0(r,s) "Labor demand";
PARAMETER kd0(r,s) "Capital demand";
PARAMETER m0(r,g) "Imports";
PARAMETER x0(r,g) "Exports of goods and services";
PARAMETER rx0(r,g) "Re-exports of goods and services";
PARAMETER md0(r,m,g) "Total margin demand";
PARAMETER nm0(r,g,m) "Margin demand from national market";
PARAMETER dm0(r,g,m) "Margin supply from local market";
PARAMETER s0(r,g) "Aggregate supply";
PARAMETER a0(r,g) "Armington supply";
PARAMETER ta0(r,g) "Benchmark excise ta";
PARAMETER ta(r,g) "Counterfactual excise ta";
PARAMETER tm0(r,g) "Benchmark import tariff";
PARAMETER tm(r,g) "Counterfactual import tariff";
PARAMETER cd0(r,g) "Final demand";
PARAMETER c0(r) "Aggregate final demand";
PARAMETER yh0(r,g) "Household production";
PARAMETER bopdef0(r) "Balance of payments";
PARAMETER hhadj(r) "Household adjustment";
PARAMETER g0(r,g) "Government demand";
PARAMETER i0(r,g) "Investment demand";
PARAMETER xn0(r,g) "Regional supply to national market";
PARAMETER xd0(r,g) "Regional supply to local market";
PARAMETER dd0(r,g) "Regional demand from local  market";
PARAMETER nd0(r,g) "Regional demand from national market";

* Production data:

$LOADDC ys0
$LOADDC ld0
$LOADDC kd0
$LOADDC id0

* Consumption data:

$LOADDC yh0
$LOADDC cd0
$LOADDC c0
$LOADDC i0
$LOADDC g0
$LOADDC bopdef0
$LOADDC hhadj

* Trade data:

$LOADDC s0
$LOADDC xd0
$LOADDC xn0
$LOADDC x0
$LOADDC rx0
$LOADDC a0
$LOADDC nd0
$LOADDC dd0
$LOADDC m0
$LOADDC ta0
$LOADDC tm0

ta(r,s) = ta0(r,s);
tm(r,s) = tm0(r,s);

* Margins:

$LOADDC md0
$LOADDC nm0
$LOADDC dm0

gm(g) = yes$(sum((m,r), nm0(r,g,m) + dm0(r,g,m)) or sum((m,r), md0(r,m,g)));

SET y_(r,s) "Production zero profit indicator";
SET x_(r,g) "Disposition zero profit indicator";
SET a_(r,g) "Absorption zero profit indicator";
SET pa_(r,g) "Absorption market indicator";
SET py_(r,g) "Output market indicator";
SET pd_(r,g) "Regional market indicator";
SET pk_(r,s) "Capital market indicator";

y_(r,s) = (sum(g, ys0(r,s,g))>0);
x_(r,g) = s0(r,g);
a_(r,g) = (a0(r,g) + rx0(r,g));
pa_(r,g) = a0(r,g);
py_(r,g) = s0(r,g);
pd_(r,g) = xd0(r,g);
pk_(r,s) = kd0(r,s);

$ontext
$model:enforcechk

$sectors:
	Y(r,s)$y_(r,s)		!	Production
	X(r,g)$x_(r,g)		!	Disposition
	A(r,g)$a_(r,g)		!	Absorption
	C(r)			!	Aggregate final demand
	MS(r,m)			!	Margin supply

$commodities:
	PA(r,g)$pa_(r,g)	!	Regional market (input)
	PY(r,g)$py_(r,g)	!	Regional market (output)
	PD(r,g)$pd_(r,g)	!	Local market price
	PN(g)			!	National market
	PL(r)			!	Wage rate
	PK(r,s)$pk_(r,s)	!	Rental rate of capital
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

$prod:A(r,g)$a_(r,g)  s:0 dm:4  d:2
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
$SYSINCLUDE mpsgeset enforcechk


$IFTHENI %system.filesys% == MSNT
$CALL "copy enforcechk.gen %reldir%%sep%temp%sep%enforcechk.gen";
$CALL "del enforcechk.gen";
$ENDIF

$IFTHENI %system.filesys% == UNIX
$CALL "cp enforcechk.gen %reldir%%sep%temp%sep%enforcechk.gen";
$CALL "rm enforcechk.gen";
$ENDIF

enforcechk.workspace = 100;
enforcechk.iterlim = 0;

$INCLUDE %reldir%%sep%temp%sep%enforcechk.gen


$IFTHENI.kestrel "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_mcp%' /;
PUT 'neos_server %neosserver%';
PUTCLOSE opt;
$ENDIF.kestrel

SOLVE enforcechk using mcp;

ABORT$(enforcechk.objval>1e-5) "Error in benchmark calibration with regional data.";
