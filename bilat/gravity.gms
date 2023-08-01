$Stitle Gravity based bilateral interstate trade coefficients

* Eliminate the country and commodity index to clean up the assignments

$if not set r $set r usa
$if not set i $set i pdr

Set st(s)   states only (this set excludes the rest region);

Alias(st,stt);

*	Bring in the bilateral state distance data

Parameter dist(st,stt);

$gdxin trade_data/dist.gdx
$loaddc st=s
$loaddc dist

display dist;

Set scn distance elasticity variation /
		low	Low elasticity,
		med	Medium elasticity,
		hig	High elasticity,
		ext	Extreme elasticity (potentially non-convex) /;

*	There are three different bilateral flows we need to track: 
*	1) state-state, 2) state-state-export, 3)import-state-state.
*	We assume seperable demand systems for each.

Set	mkt /	s2s	State to state,
		s2s2x	State to port to export,
		m2s2s	Import to port to state /;

Parameter
	exp0(mkt,st)	Observed expenditures in st by market
	sup0(mkt,st)	Observed output from st destine for state absorption
	sig		GE model elasticity of substitution
	telast(scn)	"Observable elasticity of trade wrt distance (1-sig)*rho" /med -0.7/
	rho(scn)	Calculated elasticity of trade costs wrt distance ;

exp0("s2s"  ,st) = sum(stt,bst0("%i%","%r%",stt,st));
sup0("s2s"  ,st) = sum(stt,bst0("%i%","%r%",st,stt));
exp0("s2s2x",st) = sum(stt,xnn0("%i%","%r%",stt,st));
sup0("s2s2x",st) = sum(stt,xnn0("%i%","%r%",st,stt));
exp0("m2s2s",st) = sum(stt,Nmd0("%i%","%r%",stt,st));
sup0("m2s2s",st) = sum(stt,Nmd0("%i%","%r%",st,stt));

sig	 = esubdm("%i%");
rho(scn) = telast(scn)/(1-sig);

$ontext
Currently this model is just an assignment of trade flows
	based on parameters.  The equations indicate the 
	fitted flows, however, which might ultimately be 
	calibrated to a set of observed flows.
$offtext

Nonnegative Variables
	XV(mkt,st,stt)	Gravity based nominal trade
	CES_P(mkt,st)	CES price index
	ALPHA(mkt,st)	Preference weight (transformed as in AvW)
	TAU(st,stt)	Bilateral iceberg cost factor
	;

Equations
	trade(mkt,st,stt)	Gravity based nominal trade
	CESPdef(mkt,st)		Unit expenditure function
	MKT_clr(mkt,st)		Market clearance (state to state)
	tau_def(st,stt)		Bilateral iceberg cost factor;

*	Nominal value of Marshallian Demand:
*	Assume initial fob price is one so delivered price is TAU(st,stt).

trade(mkt,st,stt)$(sup0(mkt,st) and exp0(mkt,stt))..	
	XV(mkt,st,stt) =e= exp0(mkt,stt) * (ALPHA(mkt,st)*tau(st,stt)/CES_P(mkt,stt))**(1-sig);

CESPdef(mkt,stt)$exp0(mkt,stt)..
	CES_P(mkt,stt) =e= sum(st$sup0(mkt,st), (ALPHA(mkt,st) * TAU(st,stt))**(1-sig))**(1/(1-sig));

mkt_clr(mkt,st)$sup0(mkt,st)..	
	sup0(mkt,st) =e= sum(stt$exp0(mkt,stt),XV(mkt,st,stt));

tau_def(st,stt)..
	TAU(st,stt) =e= dist(st,stt)**rho("med");

model gravity /
	trade.XV,
	CESPdef.CES_P
	mkt_clr.ALPHA
	tau_def.tau/;

*	Give us some start values:
XV.L("s2s"  ,st,stt)$(sup0("s2s",st) and exp0("s2s",stt)) 
	= bst0("%i%","%r%",st,stt);
XV.L("s2s2x",st,stt)$(sup0("s2s2x",st) and exp0("s2s2x",stt)) 
	= xnn0("%i%","%r%",st,stt);
XV.L("m2s2s",st,stt)$(sup0("m2s2s",st) and exp0("m2s2s",stt)) 
	= Nmd0("%i%","%r%",st,stt);

ALPHA.l(mkt,st)$sup0(mkt,st) = 1;
ALPHA.lo(mkt,st)$sup0(mkt,st) = 1e-6;
CES_P.l(mkt,stt)$exp0(mkt,stt) = 1;

TAU.l(st,stt)=dist(st,stt)**rho("med");

*gravity.iterlim = 0;
Solve gravity using MCP;

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


