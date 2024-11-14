$title	Create a Symmetric Table and Calculate ATMs

set s	Sectors /a1, a2/;

alias(s,g);

set	va	Value-added accounts /v1/,
	fd	Final demand accounts /pce, export, xfd/,
	mrg	Margins /trans, trade/,
	xd(*)	Exogenous demand /   xfd /;

set	ru(*)	Use matrix rows / (set.g), (set.va)/,
	cu(*)	Use matrix columns / (set.s), (set.fd)/,
	rs(*)	Supply matrix rows / (set.g) /,
	cs(*)	Supply matrix columns / (set.s), (set.mrg)/,
	u_col	Use columns in addition to s / (set.fd)/,
	u_row	Use rows in addition to g / (set.va)/,
	s_col	Supply columns in addition to s / (set.mrg) /;

set	c(*)	All column elements /set.s, set.s_col, set.u_col/;

table use(ru,cu)
	    a1  a2  pce export xfd
	a1  1   3   3   4       2
	a2  2   4   -4  1       1
	v1  2   5;

table supply(rs, cs)
	    a1  a2  trans   trade
	a1  2   7   3        1
	a2  3   5   -3      -1;

set	unz(ru,cu)	Use matrix nonzeros, 
	snz(rs,cs)	Supply matrix nonzeros;

option	unz<use, snz<supply;

parameter	s0(s)		Aggregate supply by sector s
		y0(g)		Aggregate production of good g, 
		a0(g)		Aggregate demand for good g (including margins);

s0(s) = sum(snz(rs(g),cs(s)),supply(snz));
y0(g) = sum(snz(rs(g),cs(s)),supply(snz));
a0(g) = sum(unz(ru[g],cu),   use[unz]);

parameter	omega(*,*)	Fraction of good g provided by sector s;
omega(g,s) = sum(snz(rs(g),cs(s)),supply(snz))/y0(g);

variables	Y(s)		Content of sector s,
		X(g)		Content of commodity g;

equations	def_PY, def_PI, def_PA;

def_PY(s(cu))..	Y(s) =e=  1$sameas(s,"a1") + sum(ru(g),X(g)*use(ru,cu)/s0(s));

def_PA(g(rs))..	X(g) =e= sum(cs(s), Y(s)*supply(rs,cs)/a0(g));

model atmsys /def_PY.Y, def_PA.X /;

solve atmsys using mcp;

parameter	atmval;
$set sim mcp
atmval(s,"Y","%sim%") = Y.L(s);
atmval(g,"X","%sim%") = X.L(g);

alias(g, gg);
parameter
	io[s]		"Industry output"
	co[g]		"Commodity demand"
	b[g,s]		"Intermediate demand per unit of sectoral output"
	d[s,g]		"Sector s output per unit demand for good g",
	cc[g,gg]	;

*	Industry supply:
io[s(cs)] = sum(rs[g], supply[rs,cs]);

*.co[g] = sum(unz(ru[g],cu[s]), use[unz]) + sum(xd, fd0[g,xd]) + cd0[g] + x0[g];

*	Commodity output:

co[g(ru)] = sum(cu, use[ru,cu]);

display s0, io, a0, co;

*.b[g,s]  = sum(unz(ru[g], cu[s]), use[unz]/IO[s]);

*	Input of good g per unit supply of industry s:

b[g(ru),s(cu)]  = use[ru,cu]/IO[s];

*	Supply of sector s per unit demand for commodity g:

d[s[cs],g[rs]] = supply[rs,cs]/CO[g];

cc[g,gg] = sum(s, B[g,s]*D[s,gg]);

variable	X[g]		Content of good g;
equation	invert[g];

invert[g].. sum(gg, (1$(sameas(g,gg)) - cc[g,gg])*X[gg]) =e= 1$(sameas(g, "a1"));

model classic /invert.X/;
solve classic using mcp;

$set sim classic
*atmval(s,"Y","%sim%") = Y.L(s);
atmval(g,"X","%sim%") = X.L(g);
display atmval; 


variable	Y(s)	Intermediate content per unit output of sector s;

equation invertalt, ydef;

invertalt[g]..   X[g] =E= sum(s, b(g,s)*Y[s]) + 1$(sameas(g, "a1"));

ydef[s]..	 Y[s] =e= sum(gg, d(s,gg) * X(gg));

model classicalt /invertalt.X, ydef.Y/;
solve classicalt using mcp;

$set sim classicalt
atmval(s,"Y","%sim%") = Y.L(s);
atmval(g,"X","%sim%") = X.L(g);
display atmval; 


equations	xdefalt, ydefalt;

ydefalt[s]..	Y(s) =e= 1$sameas(s,"a1") + sum(g, b[g,s]*X(g));

xdefalt[g]..	X(g) =e= sum(s, d[s,g]*Y(s));

model atmalt /xdefalt.X, ydefalt.Y/;
solve atmalt using mcp;

$set sim mcpalt
atmval(s,"Y","%sim%") = Y.L(s);
atmval(g,"X","%sim%") = X.L(g);
display atmval; 

parameter	ms0(g,mrg)	Margin supply,
		md0(mrg,g)	Margin demand,
		mu(g,mrg)	Margin supply fraction,
		id0(g,s)	Intermediate demand
		ys0(s,g)	Supply;


ms0(g(rs),mrg(cs)) = -min(0,supply(rs,cs));
md0(mrg(cs),g(rs)) = max(0,supply(rs,cs));
id0(g(ru),s(cu)) = use(ru,cu);
ys0(s(cs),g(rs)) = supply(rs,cs);
mu(g,mrg) = ms0(g,mrg)/sum(s,ys0(s,g));

variables	Z(mrg)		Content of margin;

equations	def_Y, def_X, def_Z;

def_Y(s)..	s0(s)*Y(s) =e=  s0(s)$sameas(s,"a1") + sum(g,X(g)*id0(g,s));

def_X(g)..	X(g)*a0(g) =e= sum(s, Y(s) * ys0(s,g) * (1 - sum(mrg,mu(g,mrg)))) + sum(mrg, Z(mrg)*md0(mrg,g));

def_Z(mrg)..	Z(mrg)*sum(g,md0(mrg,g)) =e= sum(s,Y(s)*sum(g,ys0(s,g)*mu(g,mrg)));

model atmz /def_Y.Y, def_X.X, def_Z.Z/;
solve atmz using mcp;

$set sim atmz
atmval(mrg,"Z","%sim%") = Z.L(mrg);
atmval(s,"Y","%sim%") = Y.L(s);
atmval(g,"X","%sim%") = X.L(g);
display atmval; 

equations	alt_Y, alt_X, alt_Z;

alt_Y(s)..	s0(s)*Y(s) =e=  sum(g,X(g)*ys0(s,g));

alt_X(g)..	X(g)*a0(g) =e= sum(s, Y(s)*id0(g,s))+ sum(mrg, Z(mrg)*md0(mrg,g)) + a0(g)$sameas(g,"a1");

alt_Z(mrg)..	Z(mrg)*sum(g,md0(mrg,g)) =e= sum(s,Y(s)*sum(g,ys0(s,g)*mu(g,mrg)));

model altz /def_Y.Y, def_X.X, def_Z.Z/;
solve altz using mcp;

$set sim altz
atmval(mrg,"Z","%sim%") = Z.L(mrg);
atmval(s,"Y","%sim%") = Y.L(s);
atmval(g,"X","%sim%") = X.L(g);
display atmval; 
