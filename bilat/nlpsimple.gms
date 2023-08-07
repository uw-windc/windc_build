$title Gravity based bilateral interstate trade coefficients

set hs(i) Goods with HS data /
	pdr, wht, gro, v_f, osd, c_b, pfb, ocr, ctl, oap, wol, oxt, tex,
	lum, ppp, oil nmm, fmp, eeq, ome, mvh, otn, omf, fof, fbp, alt, pmt,
	ogs, uti, crp /;
				   
alias(s,ss);

parameter
	node_exp(s,i)	International exports through state s,
	node_imp(s,i)	International imports through state s;

$gdxin "trade_data\node_trade_43.gdx"
$loaddc node_exp node_imp

set	missing(i,*)	Commodities with missing trade data;
missing(hs(i),"exp") = yes$(not sum(s,node_exp(s,i)));
missing(hs(i),"imp") = yes$(not sum(s,node_imp(s,i)));
abort$card(missing)	missing;


parameter	tradechk	Cross check on trade;
tradechk(i,"export","chk") = vst(i,"usa")+sum(r,vxmd(i,"usa",r)) - sum(s,node_exp(s,i));
tradechk(i,"import","chk") = vim(i,"usa") - sum(s, node_imp(s,i));
tradechk(i,"export","gtap") = vst(i,"usa")+sum(r,vxmd(i,"usa",r));
tradechk(i,"import","gtap") = vim(i,"usa");
tradechk(i,"export","HS") = sum(s,node_exp(s,i));
tradechk(i,"import","HS") = sum(s,node_imp(s,i));
OPTION tradechk:3:1:2;
display tradechk;

*	Bring in the bilateral state distance data

parameter	dist(s,ss)	Intra-state distance,
		tau_n(i,s,ss)	Iceberg trade cost (intra-national trade),
		tau_m(i,s,ss)	Iceberg trade cost (imports),
		tau_x(i,s,ss)	Iceberg trade cost (exports);

$gdxin trade_data/dist.gdx
$loaddc dist

*	Convert to 1000s of miles:

dist(s,ss) = dist(s,ss)/1000;
display dist;

parameter	esub_n(i)	Elasticity (intra-national trade),
		esub_m(i)	Elasticity (imports),
		esub_x(i)	Elasticity (exports);

esub_n(i) = 4*esubdm(i);
esub_m(i) = 2*esubdm(i);
esub_x(i) = 2*esubdm(i);

tau_n(hs(i),s,ss)$dist(s,ss) = dist(s,ss)**(-0.7/(1-esub_n(i)));
tau_m(hs(i),s,ss)$dist(s,ss) = dist(s,ss)**(-0.7/(1-2*esub_m(i)));
tau_x(hs(i),s,ss)$dist(s,ss) = dist(s,ss)**(-0.7/(1-2*esub_x(i)));
option tau_n:3:0:1, tau_m:3:0:1, tau_x:3:0:1;
display tau_n, tau_m, tau_x;

parameter	ndref(i,s)	Demand from the national market, 
		mdref(i,s)	Import demand,
		xdref(i,s)	Export demand
		nsref(i,s)	Supply to the national market, 
		msref(i,s)	Import supply, 
		xsref(i,s)	Export supply;

xdref(hs(i),s) = (vst(i,"usa")+sum(r,vxmd(i,"usa",r))) * node_exp(s,i)/sum(ss,node_exp(ss,i));
msref(hs(i),s) = vim(i,"usa") * node_imp(s,i)/sum(ss,node_imp(ss,i));

parameter	thetavom(i,s)	Regional share of output
		thetaz(i,s)	Regional share of absorption;

thetavom(hs(i),s) = vom(i,"usa",s)/sum(ss,vom(i,"usa",ss));
thetaz(hs(i),s) = a0(i,"usa",s)/sum(ss,a0(i,"usa",ss));

xsref(hs(i),s) = thetavom(i,s) * (vst(i,"usa")+sum(r,vxmd(i,"usa",r)));
mdref(hs(i),s) = thetaz(i,s)*vim(i,"usa");
nsref(hs(i),s) = vom(i,"usa",s) - xsref(i,s);
ndref(hs(i),s) = a0(i,"usa",s) - mdref(i,s);
display nsref, ndref;

set	ib(i)		Sector to balance;
	i_n(i,ss,s)	Potential trade in domestic

variable	OBJ		Objective function

nonnegative
variables	ALPHA_N(i,s)	Share parameter - national trade,
		ALPHA_M(i,s)	Share parameter - import market,
		ALPHA_X(i,s)	Share parameter - export market,

		P_N(i,s)		Cost index -- national trade
		P_M(i,s)		Cost index -- import trade
		P_X(i,s)		Cost index -- export trade

		ND(i,s,ss)	National flow,
		MD(i,s,ss)	Import flow,
		XD(i,s,ss)	Export flow;

equations	pndef, pmdef, pxdef, nddef, mddef, xddef, pnmarket, pmmarket, pxmarket;

pndef(ib(i),s)..	P_N(i,s) =e= sum(i_n(i,ss,s), (ALPHA_N(i,ss)*tau_n(i,ss,s))**(1-esub_n(i)))**(1/(1-esub_n(i)));

pmdef(ib(i),s)..	P_M(i,s) =e= sum(i_m(i,ss,s), (ALPHA_M(i,ss)*tau_m(i,ss,s))**(1-esub_m(i)))**(1/(1-esub_m(i)));

pxdef(ib(i),s)..	P_X(i,s) =e= sum(i_x(i,ss,s), (ALPHA_X(i,ss)*tau_x(i,ss,s))**(1-esub_x(i)))**(1/(1-esub_x(i)));


nddef(i_n(ib(i),ss,s))..	ND(i,ss,s) =e= ndref(i,s) * (ALPHA_N(i,ss) * tau_n(i,ss,s) / P_N(i,s))**esub_n(i);

mddef(i_m(ib(i),ss,s))..	MD(i,ss,s) =e= mdref(i,s) * (ALPHA_M(i,ss) * tau_m(i,ss,s) / P_M(i,s))**esub_m(i);

xddef(i_x(ib(i),ss,s))..	XD(i,ss,s) =e= xdref(i,s) * (ALPHA_X(i,ss) * tau_x(i,ss,s) / P_X(i,s))**esub_x(i);


pnmarket(ib(i),s)..	nsref(i,s) =e= sum(i_n(i,s,ss),ND(i,s,ss));

pmmarket(ib(i),s)..	msref(i,s) =e= sum(i_m(i,s,ss),MD(i,s,ss));

pxmarket(ib(i),s)..	xsref(i,s) =e= sum(i_x(i,s,ss),XD(i,s,ss));

model estimate /pndef.P_N, pmdef.P_M, pxdef.P_X, 
		nddef.ND, mddef.MD, xddef.XD, 
		pnmarket.ALPHA_N, pmmarket.ALPHA_M, pxmarket.ALPHA_X/;

model estimate_n /pndef.P_N, nddef.ND, pnmarket.ALPHA_N/;
model estimate_d /pmdef.P_M, mddef.MD, pmmarket.ALPHA_M/;
model estimate_x /pxdef.P_X, xddef.XD, pxmarket.ALPHA_X/;

ALPHA_N.L(hs(i),s) = nsref(i,s)/sum(ss,nsref(i,ss));
ALPHA_M.L(hs(i),s) = msref(i,s)/sum(ss,msref(i,ss));
ALPHA_X.L(hs(i),s) = xsref(i,s)/sum(ss,xsref(i,ss));

P_N.L(hs(i),s) = 1;
P_M.L(hs(i),s) = 1;
P_X.L(hs(i),s) = 1;

P_N.LO(hs(i),s) = 1e-5;
P_M.LO(hs(i),s) = 1e-5;
P_X.LO(hs(i),s) = 1e-5;

ND.L(hs(i),s,ss) = ndref(i,ss)*ALPHA_N.L(i,s);
MD.L(hs(i),s,ss) = mdref(i,ss)*ALPHA_M.L(i,s);
XD.L(hs(i),s,ss) = xdref(i,ss)*ALPHA_X.L(i,s);

ND.FX(hs(i),s,ss)$(not ndref(i,ss) and nsref(i,s)) = 0;
MD.FX(hs(i),s,ss)$(not mdref(i,ss) and msref(i,s)) = 0;
XD.FX(hs(i),s,ss)$(not xdref(i,ss) and xsref(i,s)) = 0;

ALPHA_N.FX(hs(i),s)$(not nsref(i,s)) = 0;
ALPHA_M.FX(hs(i),s)$(not msref(i,s)) = 0;
ALPHA_X.FX(hs(i),s)$(not xsref(i,s)) = 0;

P_N.FX(hs(i),s)$(not nsref(i,s)) = 0;
P_M.FX(hs(i),s)$(not msref(i,s)) = 0;
P_X.FX(hs(i),s)$(not xsref(i,s)) = 0;

loop(hs$sameas(hs,"wht"),
	ib(i) = yes$sameas(i,hs);
	solve estimate_n using mcp;
); 
	


