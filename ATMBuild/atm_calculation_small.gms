$title	Create a Symmetric Table and Calculate ATMs

*$if not set yr $set yr 2022
*
*set	yrs(*), ru(*), cu(*), rs(*), cs(*);
*
*set	s(*)	Sectors;
*
*set	s_row(*) Supply table rows (in addition to commodities) 
*	s_col(*) Supply table columns (in addition to sectors) 
*	u_row(*) Use table rows (in addition to commodities) 
*	u_col(*) Use table columns (in addition to sectors);
*
*$call gams %system.fp%mappings gdx=%gams.scrdir%mappings.gdx
*$gdxin %gams.scrdir%mappings.gdx
*$loaddc s=d s_row s_col u_row u_col

set s /a1, a2/;
alias(s,g);
set va /v1/;
set fd /pce, export, xfd/;
set mrg /trans, trade/;

set ru(*) / (set.g), (set.va)/;
set cu(*) / (set.s), (set.fd)/;
set rs(*) / (set.g) /;
set cs(*) / (set.s), (set.mrg)/;
set u_col / (set.fd)/;
set u_row / (set.va)/;
set s_col / (set.mrg) /;
set	c(*)	/set.s, set.s_col, set.u_col/;

table use(ru,cu)
    a1  a2  pce export xfd
a1  1   3   3   4       2
a2  2   4   -4  1       1
v1  2   5;

table supply(rs, cs)
    a1  a2  trans   trade
a1  2   7   3        1
a2  3   5   -3      -1;

set	unz(ru,cu), snz(rs,cs);
option unz<use, snz<supply;


parameter	theta(*,*)	Fraction of good g provided by sector s
		aggsupply(s)	Aggregate supply;


aggsupply(s) = sum(snz(rs(g),cs(s)), supply(snz));
theta(snz(rs(g),cs(s)))$aggsupply(s) = supply(snz) / aggsupply(s);



parameter	iot(*,*)	Input-output table;
iot(ru,g) = sum(cu(s), theta(g,s)*use(ru,cu));
iot(g(ru),cu(u_col)) = use(ru,cu);
iot(g(rs),cs(s_col)) = sum(snz(rs,cs), -supply(rs,cs));


set	xd(*)	Exogenous demand /
    xfd /;


parameter
	y0(g)		Aggregate supply,
	yd0(g)		Domestic supply,
	va0(s)		Value-added,
	id0(g,s)	Intermediate demand,
	x0(g)		Regional exports
	ms0(g,mrg)	Margin supply,
	md0(g,mrg)	Margin demand,
	fd0(g,xd)	Final demand,
	cd0(g)		Consumer demand,
	a0(g)		Absorption,
	m0(g)		Imports /a1 0, a2 0/;


va0(g(cu)) = sum(ru$(not g(ru)), use(ru,cu));
y0(g) = sum(ru,iot(ru,g));
x0(g(ru)) = iot(ru,"export");
*m0(g(ru)) = iot(ru,"mcif") + iot(ru,"madj") + iot(ru,"mdty");
md0(g(ru),mrg(c)) = max(0,-iot(ru,c));
ms0(g(ru),mrg(c)) = max(0,iot(ru,c));
yd0(g) = y0(g) - x0(g) + sum(mrg,md0(g,ms0)-ms0(g,ms0))
cd0(g(ru)) = iot(ru,"pce");
fd0(g(ru),xd(cu)) = iot(ru,cu);
id0(g(ru),s(cu)) = iot(ru,cu);
a0(g) = sum(s,id0(g,s)) + cd0(g) + sum(xd,fd0(g,xd));
display md0, ms0;

parameter	market;
market(g,"a0") = a0(g);
market(g,"yd0") = yd0(g);
market(g,"md0") = sum(mrg,md0(g,mrg));
market(g,"chk") = market(g,"a0") - market(g,"yd0") - market(g,"md0");
display market;
$exit

display y0,a0, id0, x0;

alias (g,gg);


$ontext
$model:commodity

$sectors:
	Y(s)	! Sectoral output
	A(g)	! Absorption
	M(mrg)	! Margin supply

$commodities:
	PY(g)	! Output market
	P(g)	! Demand market
	PI(mrg)	! Margin price
	PVA(s)	! Value-added
	PFX	! Foreign exchange

$consumer:
	RA	! Representative agent

$prod:Y(g)
	o:PY(g)		q:y0(g)
	o:PFX		Q:x0(g)
	i:P(gg)		q:id0(gg,g)
	i:PVA(s)	q:va0(s)

$prod:M(mrg)
	o:PI(mrg)	q:(sum(g,ms0(g,mrg)))
	i:PY(g)		q:ms0(g,mrg)

$prod:A(g)
	o:P(g)		q:a0(g)
	i:PY(g)		q:yd0(g)
	i:PI(mrg)	q:md0(g,mrg)

$demand:RA
	d:P(g)		q:cd0(g)
	e:P(g)		q:(-sum(xd,fd0(g,xd)))
	e:PFX		q:(-sum(g,x0(g)))
	e:PVA(s)	q:va0(s)

$offtext
$sysinclude mpsgeset commodity
$include commodity.gen
solve commodity using mcp;
$exit

set	ags(s)  Agricultural sectors /  
		a1/;

parameter	atmval(g,*)	Trade multiplier for comparison;

variables	v_PY(g)		Content of domestic output,
		v_PA(g)		Content of absorption,
		v_PI(mrg)	Content of margin;

equations	def_PY, def_PI, def_PA;

def_PY(s)$y0(s)..	(v_PY(s) - 1$ags(s)) * y0(s) =e= sum(g,v_PA(g)*id0(g,s));
def_PI(mrg)..		v_PI(mrg)*sum(g,ms0(g,mrg))  =e= sum(g,v_PY(g)*ms0(g,mrg));
def_PA(g)$a0(g)..	v_PA(g)*a0(g) =e= v_PY(g)*(y0(g)-x0(g)) + sum(mrg,v_PI(mrg)*md0(g,mrg));

*v_PY.FX(g) = 1;
v_PY.FX(g)$(not y0(g)) = 0;
v_PA.FX(g)$(not a0(g)) = 0;

model atmsys /def_PY.v_PY, def_PI.v_PI, def_PA.v_PA /;
solve atmsys using mcp;

$ondotl

atmval(g,"mcp")$x0(g) = (v_PY(g) - 1$ags(g));

alias(g, gg);
parameter
	io(s)		"Industry output"
	co[g]		"Commodity demand"
	b[g,s]		Intermediate demand per unit of sectoral output
	d[s,g]		Sector s output per unit demand for good g
	cc[g,gg]	

io[s] = sum(snz(rs[g],cs[s]), supply[snz]);
co[g] = sum(unz(ru[g],cu[s]), use[unz]) + sum(xd, fd0[g,xd]) + cd0[g] + x0[g];

b[g,s]  = sum(unz(ru[g], cu[s]), use[unz]/IO[s]);
d[s,g] = sum(snz(rs[g], cs[s]), supply[snz]/CO[g]);
cc[g,gg] = sum(s, B[g,s]*D[s,gg]);

variable x[g];
equation invert[g];

invert[g].. sum(gg, (1$(sameas(g,gg)) - CC[g,gg])*x[gg]) =e= 1$(sameas(g, "a1"));

model classic /invert.x/;
solve classic using mcp;

atmval(g,"classic")$x0(g) = (x.L[g]);


display atmval;


$exit


parameter domestic[g] "domestic shares";

domestic[g] = 1 - x0[g]/(CO[g] + m0[g] - x0[g]);

equation invert_domestic[g];

invert_domestic[g].. sum(gg, (1$(sameas(g,gg)) - CC[g,gg]*domestic[g])*x[gg]) =e= 1$(sameas(g, "a1"));

model classic_domestic /invert_domestic.x/;
solve classic_domestic using mcp;


atmval(g,"domestic")$x0(g) = (x.L[g]);

display atmval;