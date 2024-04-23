$title	Canonical Template GTAP-WINDC Model (MGE format)

*	Read the data:

$if not set ds $set ds 43

$include ..\gtapwindc\gtapwindc_data

set	pk_(f,r)	Capital market;
option pk_<ft_;

alias (s,ss);

parameter

*	Note: In the bilatgravity calculation we omit the
*	region index because our calculations only involve
*	the USA:

	yref(i,s)	State output (domestic + export),
	xref(i,s)	Exports,
	dref(i,s)	Supply to the domestic market,

	vdfm_(i,s,ss)	Intra-national trade,
	vifm_(i,s)	Imports,

	a0_(i,s)	Absorption in the US

*	Data structures for the model need to include the 
*	regional index:

	vdfm(i,r,s,ss)	Intra-national trade
	vifm(i,r,s)	Imports (gravity estimate)

*	Read revised tax rates which are used in the
*	gravity calculation to clean up profit conditions:

	rtd0_(i,r,s)	Benchmark tax rate on domestic demand
	rtm0_(i,r,s)	Benchmark tax rate on import demand;

a0_(i,s) = a0(i,"usa",s);

set	itrd(i)		Sectors with bilateral trade data;

*	Read these data from the PE calculation -- the GDX file contains
*	all parameters so we can retrieve additional symbols if needed.

$gdxin 'bilatgravity.gdx'
$load itrd yref xref dref 

*	Rename these parameters so that we can add the region index and/or avoid
*	overwriting values already in the database:
 
$load vdfm_=vdfm vifm_=vifm rtd0_=rtd0 rtm0_=rtm0

*	These symbols only enter the regions with bilateral national
*	markets:

vdfm(i,r,s,ss)	= 0;
vifm(i,r,s)	= 0;

parameter	chk		Cross check on PE calculations;

*	Aggregate supply equals exports plus domestic supply:

chk(s,itrd(i)) = round(yref(i,s) - xref(i,s) - dref(i,s),3);
abort$card(chk) "Error: yref deviation:", chk;

*	Domestic supply in state s equals bilateral sales from
*	state s to all other states ss:

chk(s,itrd(i)) = round(dref(i,s) - sum(ss,vdfm_(i,s,ss)),3);
abort$card(chk) "Error: dref deviation:", chk;

*	Gross output in the PE calculation equals gross output in the 
*	GE database:

chk(s,itrd(i)) = round(yref(i,s) - vom(i,"usa",s),3);
abort$card(chk) "Error: yref deviation:",chk;
	
*	Aggregate absorpotion of commodity i in state s in the GE database (a0)
*	equals aggregate imports from other states and from abroad (vdfm_, vifm_,
*	rtd0_, and rtm0_ from the PE calculation):

chk(s,itrd(i)) = round(a0_(i,s) - sum(ss,vdfm_(i,ss,s))*(1+rtd0_(i,"usa",s)) - vifm_(i,s)*(1+rtm0_(i,"usa",s)),3);
abort$card(chk) "Error: a0<>vdfm+vifm:", chk;


parameter trdchk	Cross check on imports;

*	GE database balance of imports gross of tax equals the demand for 
*	imports across all sectors:

trdchk(itrd(i),"vim<>md0")  = round(vim(i,"usa") - sum(s,md0(i,"usa",s)),3);

*	Consistency of gross imports in the GE and PE data:

trdchk(itrd(i),"vim<>vifm") = round(vim(i,"usa") - sum(s,vifm_(i,s)),3);

*	Aggregate exports in the GE dataset (vxm) equals the sum of imputed exports
*	at the state level in the PE model (xref):

trdchk(itrd(i),"vxm<>xref") = round(vxm(i,"usa") - sum(s,xref(i,s)),3);
abort$card(trdchk) "Imbalance in trade accounts:", trdchk;

set	pnm(i,r)	Pooled national market,
	bnm(i,r)	Bilateral national market;


nonnegative
variables	S_VDFM(i,s,ss)	Sparse interstate trade flows
		S_VIFM(i,s)	Sparse import flows,
		S_XREF(i,s)	Sparse export flows,
		S_A0(i,s)	Sparse absorption;

variable	OBJ		Objective function;

equations	exports, imports, absorption, output, objdef;

set	ib(i)	Sector to balance,
	sb(s)	Subregions to balance;

sb(s) = yes$(not sameas(s,"rest"));


alias (sb,ssb);

exports(ib(i))..	vxm(i,"usa") =e= sum(sb(s), S_XREF(i,s));

imports(ib(i))..	vim(i,"usa") =e= sum(sb(s), S_VIFM(i,s));

absorption(ib(i),sb(s))..	S_A0(i,s) =e= sum(ssb(ss), S_VDFM(i,ss,s)*(1+rtd0_(i,"usa",s))) + S_VIFM(i,s)*(1+rtm0_(i,"usa",s));

output(ib(i),sb(s))..	vom(i,"usa",s) =e= S_XREF(i,s) + sum(ss, S_VDFM(i,s,ss));

*	a	Target value
*	b	Estimated value
*	d	Domain

parameter	penalty	/1e3/;

$macro	target(a,b,d,ds)  sum((&&ds), ( abs(a(&&d))*sqr(b(&&d)/a(&&d)-1) )$a(&&d) \
                           + (penalty * b(&&d))$(not a(&&d)))


objdef..	OBJ =e= target(vdfm_, S_VDFM, "i,s,ss", "ib(i),sb(s),ssb(ss)") +
			target(vifm_, S_VIFM, "i,s",	"ib(i),sb(s)") +
			target(xref,  S_XREF, "i,s",	"ib(i),sb(s)") +
			target(a0_,    S_A0,   "i,s",	"ib(i),sb(s)");

model calibrate /exports, imports, absorption, output, objdef/;

parameter	aggbal	Cross check on aggregate balance;
aggbal(itrd(i),"vom") = sum(s,vom(i,"usa",s));
aggbal(itrd(i),"vxm") = vxm(i,"usa");
aggbal(itrd(i),"vim") = vim(i,"usa");
aggbal(itrd(i),"a0") =  sum(sb(s),a0_(i,s));
aggbal(itrd(i),"vdm+vim+rtd+rtm") = sum(sb(s), sum(ssb(ss), vdfm_(i,ss,s)*(1+rtd0_(i,"usa",s))) + vifm_(i,s)*(1+rtm0_(i,"usa",s)));
display aggbal;


S_VDFM.L(i,s,ss) = vdfm_(i,s,ss);
S_VIFM.L(i,s)	 = vifm_(i,s);
S_XREF.L(i,s)	 = xref(i,s);
S_A0.L(i,s) = a0_(i,s);

parameter	itrlog		Iteration log;

loop(itrd,
	ib(i) = sameas(i,itrd);
	solve calibrate using qcp minimizing obj;
	itrlog(itrd,"obj") = OBJ.L;
	itrlog(itrd,"ResUsd") = calibrate.ResUsd;
	itrlog(itrd,"IterUsd") = calibrate.IterUsd;
	itrlog(itrd,"SolveStat") = calibrate.solvestat;
	itrlog(itrd,"ModelStat") = calibrate.modelstat;
);
display itrlog;

*	Apply an absolute filter tolerance of 1e-5:

vdfm_(i,s,ss)$(not round(vdfm_(i,s,ss),5)) = 0;

loop(itrd,
	ib(i) = sameas(i,itrd);
	solve calibrate using qcp minimizing obj;
	itrlog(itrd,"obj") = OBJ.L;
	itrlog(itrd,"ResUsd") = calibrate.ResUsd;
	itrlog(itrd,"IterUsd") = calibrate.IterUsd;
	itrlog(itrd,"SolveStat") = calibrate.solvestat;
	itrlog(itrd,"ModelStat") = calibrate.modelstat;
);
display itrlog;
