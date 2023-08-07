$title Gravity based bilateral interstate trade coefficients

$if not set i $set i wht


alias(s,ss);

*	Bring in the bilateral state distance data

parameter	dist(s,ss)	Intra-state distance,
		tau(s,ss)	Iceberg trade cost;

$gdxin trade_data/dist.gdx
$loaddc dist

*	Convert to 1000s of miles:

dist(s,ss) = dist(s,ss)/1000;
display dist;

tau(s,ss)$dist(s,ss) = dist(s,ss)**(-0.7/(1-esubdm("%i%")));

display tau;


*	Three bilateral flows:
*		1) state-state domestic, 
*		2) state-state-export, 
*		3)import-state-state

set	mkt /	s2s	State to state (intrastate),
		s2s2x	State to port (export),
		m2s2s	Port to state (import)/;

variable	OBJ		Objective function;

parameter	rpc		Regional purchase coefficient /1.1/;

parameter	dref(s,ss)	Reference domestic demand (no trade cost),
		mref(s,ss)	Reference import demand (no trade cost),
		xref(s,ss)	Reference export demand (no trade cost),

		zref(s)		Value of aggregate expenditure (domestic plus import),
		vom_(s)		Supply for domestic and export market,
		vim_(s)		Supply for import markets,
		vxm_(s)		Demand for export markets;

vom_(s) = vom("%i%","usa",s);
vim_(s) = md0("%i%","usa",s);

parameter	thetadref(s)	Regional share of domestic demand
		thetavom(s)	Regional share of output
		thetavim(s)	Regional share of output
		thetazref(s)	Regional share of absorption;

thetavom(s) = vom_(s)/sum(ss,vom_(ss));
thetavim(s) = vim_(s)/sum(ss,vim_(ss))

*	Assume proportional exports for now:

vxm_(s) = thetavom(s) * (vst("%i%",r)+sum(r,vxmd(i,"usa",r)));

zref(s) = vom_(s) - vxm_(s) + vim_(s);

thetazref(s) = zref(s)/sum(ss,zref(ss));

dref(s,s) = rpc * thetazref(s) * (vom_(s)-vxm_(s));
dref(s,ss)$(not sameas(s,ss)) = (1-rpc*thetazref(s))*(vom_(s)-vxm_(s)) * thetazref(ss)/(1-thetazref(s));

variable	OBJ		Objective function -- calibration precision;

nonnegative
variables	THETAZ(s)	Local share of absorption
		THETANM(s)	Domestic share of the NM composite
		THETAN(s,ss)	Bilateral in national market,
		THETAM(s,ss)	Bilateral share in import market,
		THETAX(s,ss)	Bilateral share in export market,

objdef..	OBJ =e= sum((s,ss),
			sqr(THETAN(s,ss)*THETANM(ss)*(1-THETAZ(ss))*zref(ss)-DREF(s,ss))$(not sameas(s,ss)) +
			sqr(THETAZ(s)*zref(s)-dref(s,s))$sameas(s,ss) +
			sqr(THETAM(s,ss)*THETANM(s,ss)*(1-THETAZ(ss))*zref(ss)-mref(s,ss)) +
			sqr(THETAX(s,ss)*vxm(ss)-xref(s,ss)));

pzdef(s)..	PZ(s) =e= (THETAZ(s)*(PY(s)*tau(s,s))**(1-esubz) + (1-THETAZ(s))*PNM(s)**(1-esubz))**(1/(1-esubz));

pnmdef(s)..	PNM(s) =e= (THETANM(s)*PN(s)**(1-esubdm) + (1-THETANM(s))*PM(s)**(1-esubnm))**(1/(1-esubnm));

pndef(s)..	PN(s) =e= sum(ss, THETAN(ss,s)*(PY(ss)*tau(ss,s))**(1-esubn))**(1/(1-esubn));

pmdef(s)..	PM(s) =e= sum(ss, THETAM(ss,s)*(PM(ss)*tau(ss,s))**(1-esubm))**(1/(1-esubm));

pxdef(s)$xref(s)..	PX(s) =e= sum(ss, THETAX(ss,s)*(PY(ss)*tau(ss,s))**(1-esubx))**(1/(1-esubx));

*	Domestic demand:

ddef(s,ss)..	D(s,ss) =e= 
			THETAZ(s)*zref(s) * ((PZ(s)/(PY(s)*tau(s,s)))**esubz)$sameas(s,ss) +
			(THETAN(s,ss)*THETANM(ss)*(1-THETAZ(ss))*zref(ss) *
				(PZ(ss)/PNM(ss))**esubz * 
				(PNM(ss)/PN(ss))**esubnm * 
				(PN(ss)/(PY(s)*tau(s,ss)))**esubn)$(not sameas(s,ss));

edef(s,ss)$xref(ss)..	E(s,ss) =e= THETAX(s,ss)*vxm(ss)/PX(ss) * (PX(ss)/(PY(s)*tau(s,ss)))**esubx;

mdef(s,ss)$vim(s)..	M(s,ss) =e= THETAM(s,ss)*THETANM(ss)*(1-THETAZ(ss))*zref(ss) *
	(PZ(ss)/PNM(ss))**esubz * (PNM(ss)/PM(ss))**esubnm * (PM(ss)/tau(s,ss))**esubm;

*	vom(s) is the market value of output:

market_PY(s)..	PY(s)*sum(ss, D(s,ss) + E(s,ss)) =e= vom(s);
				
*	vim(s) is the market value of imports:

market_PM(s)..	PM(s)*sum(ss, M(s,ss)) =e= vim(s);


$exit

Nonnegative Variables
		XV(mkt,st,stt)		Gravity based nominal trade
		CES_P(mkt,st)		CES price index
		ALPHA(mkt,st)		Common preference weight
		BETA(mkt,st,stt)	State-specific preference weight,
		TAU(st,stt)		Bilateral iceberg cost factor;

equations
	objdef			Defines the objective function
	trade(mkt,st,stt)	Gravity based nominal trade
	CESPdef(mkt,st)		Unit expenditure function
	MKT_clr(mkt,st)		Market clearance (state to state)
	tau_def(st,stt)		Bilateral iceberg cost factor;




trade(mkt,st,stt)$(sup0(mkt,st) and exp0(mkt,stt))..	
	XV(mkt,st,stt) =e= exp0(mkt,stt) * (BETA(mkt,st,stt)*tau(st,stt)/CES_P(mkt,stt))**(1-sig);

CESPdef(mkt,stt)$exp0(mkt,stt)..
	CES_P(mkt,stt) =e= sum(st$sup0(mkt,st), (BETA(mkt,st,stt) * TAU(st,stt))**(1-sig))**(1/(1-sig));

mkt_clr(mkt,st)$sup0(mkt,st)..	
	sup0(mkt,st) =e= sum(stt$exp0(mkt,stt), XV(mkt,st,stt));

tau_def(st,stt)..
	TAU(st,stt) =e= dist(st,stt)**rho("med");

objdef..	OBJ =e= sum((mkt,st,stt), sqr(ALPHA(mkt,st)-BETA(mkt,st,stt)));

model gravity /
	trade, CESPdef, mkt_clr, tau_def, objdef/;

*	Give us some start values:
XV.L("s2s"  ,st,stt)$(sup0("s2s",st) and exp0("s2s",stt)) = bst0("%i%","%r%",st,stt);
XV.L("s2s2x",st,stt)$(sup0("s2s2x",st) and exp0("s2s2x",stt)) = xnn0("%i%","%r%",st,stt);
XV.L("m2s2s",st,stt)$(sup0("m2s2s",st) and exp0("m2s2s",stt)) = Nmd0("%i%","%r%",st,stt);

ALPHA.l(mkt,st)$sup0(mkt,st) = 1;
ALPHA.lo(mkt,st)$sup0(mkt,st) = 1e-6;
BETA.L(mkt,st,stt)$(sup0(mkt,st) and exp0(mkt,stt)) = 1;
BETA.LO(mkt,st,stt)$(sup0(mkt,st) and exp0(mkt,stt)) = 1e-6;
CES_P.l(mkt,stt)$exp0(mkt,stt) = 1;
TAU.l(st,stt)=dist(st,stt)**rho("med");

*gravity.iterlim = 0;

solve gravity using NLP minimizing OBJ;

$exit

*Reassign the GE coefficients and check the balance

*	bst0(i,r,s,ss) Intra-national trade - bilateral 
*	xnn0(i,r,s,ss) Exports from ss are routed through s (substitution by foreign trade partner)
*	nmd0(i,r,s,ss) International imports into s destine for ss (substitution


bst0("%i%","%r%",st,stt) = XV.l("s2s"  ,st,stt);
xnn0("%i%","%r%",st,stt) = XV.l("s2s2x",st,stt);
nmd0("%i%","%r%",st,stt) = XV.l("m2s2s",st,stt);

$include gtapwindc.gen
solve gtapwindc using mcp;
Abort$(gtapwindc.objval > 1e-4) "Initial GTAP-WiNDC Calibration failure";


