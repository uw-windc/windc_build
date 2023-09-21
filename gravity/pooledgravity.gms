$title Use Gravity to Calibrate Bilateral Interstate Trade Flows

*	Read the data:

$if not set ds $set ds 43

$set gtapwindc_datafile ..\GTAPWiNDC\datasets\gtapwindc\%ds%.gdx

$include ..\GTAPWiNDC\gtapwindc_data

alias (s,ss);

set	prt(*)	Ports;
$gdxin 'geographytrade.gdx'
$load prt=port

parameter	epsilon		Elasticity of trade wrt trade cost;
$load epsilon


parameter	dist(s,*)	Port distances;
$loaddc dist

*	Set the domestic distance for DC to one mile -- we run into numerical 
*	problems when it equals zero.

dist("dc","dc") = 1;

set	impexp /import, export/

parameter	trade(prt,i,impexp)	Trade flows by port;
$load trade

option trade:3:2:1;
display trade;


set itrd(i)		Sectors with trade flows;
option itrd<trade;
itrd(itrd) = i(itrd);
option itrd:0:0:1;
display itrd;

parameter	tradeshare(prt,i,impexp)	Trade shares;
tradeshare(prt,i,impexp) = sum(i.local,trade(prt,i,impexp))/sum((i.local,prt.local),trade(prt,i,impexp));
tradeshare(prt,itrd(i),impexp) = trade(prt,i,impexp)/sum(prt.local,trade(prt,i,impexp));


parameters
	tau_L(i,s)	Transport cost multiplier for domestic trade
	tau_x(i,s)	Transport cost multiplier for exports,
	tau_m(i,s)	Transport cost multiplier for imports,
	tau_n(i,s)	Transport cost to national market,

	lamda_a(i,s)	Productivity multiplier

	esub_dm(i)	Elasticity of substitution - domestic versus international,
	esub_ln(i)	Elasticity of substitution - local versus national,
	esub_n(i)	Elasticity of substitution - domestic supply,
	esub_x(i)	Elasticity of substitution  in export demand,

	a_0(i,s)	Absorption,
	a_tot(i)	Total absorption,
	xd_0(i,s)	Local supply,
	nd_0(i,s)	Demand from national market,
	md_0(i,s)	Imports,
	ns_0(i,s)	Supply to national market,
	xs_0(i,s)	Export supply,
	x_0(i)		Aggregate exports,
	m_0(i)		Aggregate imports,
	y_0(i,s)	Production,
	y_tot(i)	Total production,
	L_0(i)		Total production sold locally,
	n_0(i)		Total production sold in the national market,

	thetaL(i,s)	Local share of demand,
	thetan(i,s)	National share of demand,
	thetam(i,s)	Import share of demand,
	thetay(i,s)	Share of supply net local demand;


parameter	market		Market balance conditions;
market(i,"vom") = sum(s,vom(i,"usa",s));
market(i,"vim") = vim(i,"usa");
market(i,"vxm") = sum(r,vxmd(i,"usa",r)) + vst(i,"usa");
market(i,"d0") = sum((s),xd0(i,"usa",s)+nd0(i,"usa",s));
market(i,"m0") = sum((s),md0(i,"usa",s));
market(i,"dchk") = market(i,"vom") - market(i,"vxm") - market(i,"d0");
market(i,"mchk") =  market(i,"vim") - market(i,"m0");
market(i,"chk") = market(i,"vom") + market(i,"vim") - market(i,"vxm") - market(i,"d0") - market(i,"m0");
display market;

lamda_a(i,s) = 1;

tau_L(i,s) = 1;
tau_n(i,s) = 1;
tau_x(i,s) = 1;
tau_m(i,s) = 1;

esub_dm(i) = 4;
esub_ln(i) = 2;
esub_n(i) = 4;
esub_x(i) = 8;

y_0(i,s) = vom(i,"usa",s);
y_tot(i) = sum(s,y_0(i,s));

*	Total exports:

x_0(i) = sum(r,vxmd(i,"usa",r))+vst(i,"usa");
m_0(i) = vim(i,"usa");
a_0(i,s) = xd0(i,"usa",s) + nd0(i,"usa",s) + md0(i,"usa",s);
a_tot(i) = sum(s,a_0(i,s));

display y_0, x_0, m_0, a_0;

*	State s share of aggregate commodity i supply:

parameter	lpc(i)	Local purchase coefficient /(set.i) 1/;

thetaL(i,s) = lpc(i) * y_0(i,s)/y_tot(i) * (y_tot(i)-x_0(i))/a_tot(i);

display thetaL;

L_0(i) = sum(s,thetaL(i,s)*a_0(i,s));

n_0(i) = y_tot(i) - L_0(i) - x_0(i);

abort$(smin(i,n_0(i))<0) "Negative national supply.";

alias (s,ss);

thetan(i,s) = (1 - thetaL(i,s)) * n_0(i) / (n_0(i) + m_0(i));
thetam(i,s) = (1 - thetaL(i,s)) * m_0(i) / (n_0(i) + m_0(i));

parameter	thetachk(i,s)	Cross check on totals;
thetachk(i,s) = 1 - thetaL(i,s) - thetan(i,s) - thetam(i,s);
display thetachk;

thetay(i,s)$y_0(i,s) = (y_0(i,s)-thetaL(i,s)*a_0(i,s))/(y_tot(i)-L_0(i));

display thetay;

set	ib(i)	Sector to balance;

parameter	endow(i)	Endowment (PE closure device);
endow(i) = y_tot(i) + m_0(i);

$ontext
$model:gravity

$sectors:
	AD(i,s)$(a_0(i,s) and ib(i))		! Absorption (Armington demand)
	AN(i)$(n_0(i) and ib(i))		! Absorption (domestic trade)

$commodities:
	P(i,s)$(a_0(i,s) and ib(i))		! Demand price
	PY(i,s)$(y_0(i,s) and ib(i))		! Output price
	PM(i)$(m_0(i) and ib(i))		! Import price
	PN(i)$(n_0(i) and ib(i))		! National market price
	PFX					! Price level

$consumers:
	AX(i)$(x_0(i) and ib(i))		! Exports
	D(i,s)$(a_0(i,s) and ib(i))		! Absorption
	RA					! PE Closure

$auxiliary:
	SY(i,s)$(y_0(i,s) and ib(i))		! Output supply
	SM(i)$(m_0(i) and ib(i))		! Import supply

$prod:AD(i,s)$(a_0(i,s) and ib(i))  s:esub_dm(i)  d:esub_ln(i) 
	o:P(i,s)	q:(lamda_a(i,s)*a_0(i,s))
	i:PY(i,s)	q:(tau_L(i,s)*thetaL(i,s)*a_0(i,s)) p:(1/tau_L(i,s))  d:
	i:PN(i)		q:(tau_n(i,s)*thetan(i,s)*a_0(i,s)) p:(1/tau_n(i,s))  d:
	i:PM(i)		q:(tau_m(i,s)*thetam(i,s)*a_0(i,s)) p:(1/tau_m(i,s)) 

$prod:AN(i)$(n_0(i) and ib(i))   s:esub_n(i)
	o:PN(i)		q:n_0(i)
	i:PY(i,s)	q:(tau_n(i,s)*thetay(i,s)*n_0(i))	p:(1/tau_n(i,s))

$demand:AX(i)$(x_0(i) and ib(i))   s:esub_x(i)
	d:PY(i,s)	q:(tau_x(i,s)*thetay(i,s)*x_0(i))	p:(1/tau_x(i,s))
	e:PFX		q:x_0(i)	

$report:
	v:PY_AD(i,s)$(a_0(i,s) and ib(i) and thetay(i,s))	i:PY(i,s)	prod:AD(i,s)
	v:PN_AD(i,s)$(a_0(i,s) and ib(i) and thetan(i,s))	i:PN(i)	p	prod:AD(i,s)
	v:PM_AD(i,prt,s)$(a_0(i,s) and ib(i) and m_0(i))	i:PM(i)		prod:AD(i,s)
	V:PY_AN(i,s)$(n_0(i) and ib(i) and thetay(i,s))		i:PY(i,s)	prod:AN(i)


$demand:RA
	d:PFX
	e:PFX					q:(sum(ib,endow(ib)))
	e:PY(i,s)$(y_0(i,s) and ib(i))		q:y_0(i,s)		r:SY(i,s)
	e:PM(i)$(m_0(i) and ib(i))		q:m_0(i)		r:SM(i)

$demand:D(i,s)$(a_0(i,s) and ib(i))
	d:P(i,s)
	e:PFX		q:a_0(i,s)

$constraint:SY(i,s)$(y_0(i,s) and ib(i))
	SY(i,s)*PY(i,s) =e= PFX;

$constraint:SM(i)$(m_0(i) and ib(i))
	SM(i)*PM(i) =e= PFX;


$offtext
$sysinclude mpsgeset gravity

SY.FX(i,s) = 1;
SM.FX(i) = 1;

PFX.FX = 1;


file kcon / con:/; kcon.lw=0; kcon.nw=0; kcon.nd=3; put kcon;

parameter	tau_min(i,s)	Minimum distance, 
		solvelog	Solution log;

*	Solve each sector independently:

$onechov >path.opt
convergence_tolerance 1e-5
proximal_perturbation 0
crash_method pnewton
$offecho

gravity.optfile = 1;
option sysout=on;

alias (i,ii);

parameter	bmkchk	Cross check on benchmark /0/;
loop(ii$bmkchk,

	ib(i) = yes$sameas(i,ii);

	SY.FX(i,s) = 1;
	SM.FX(i) = 1;

	gravity.workspace=64;
	gravity.iterlim =0;
$include gravity.gen
	solve gravity using mcp;
	abort$round(gravity.objval,2) "Benchmark replication error.";
	put_utility 'title' /'Benchmark precisition for ',ii.tl,' = ',gravity.objval;

	solvelog("objval",ii,"Benchmark") = gravity.objval;
	solvelog("modelstat",ii,"Benchmark") = gravity.modelstat;
	solvelog("solvestat",ii,"Benchmark") = gravity.solvestat;
);

parameter	tradecost	Trade cost calculation /1/;
loop(ii$tradecost,

	ib(i) = yes$sameas(i,ii);

	tau_L(ib(i),s) = dist(s, s)**(epsilon/(1-esub_ln(i)));
	tau_n(ib(i),s) = sum(ss,thetay(i,ss)*dist(s,ss))**(epsilon/(1-esub_ln(i)));
	tau_m(ib(i),s) = sum(prt, tradeshare(prt,i,"import")*dist(s,prt))**(epsilon/(1-esub_dm(i)));

	tau_x(ib(i),s) = sum(prt, tradeshare(prt,i,"export")*dist(s,prt))**(epsilon/(1-esub_x(i)));

	tau_min(ib(i),s)$a_0(i,s) = min( tau_L(i,s), tau_n(i,s), tau_m(i,s), tau_x(i,s) ) + eps;

	lamda_a(ib(i),s)$a_0(i,s) = tau_L(i,s)*thetaL(i,s) + tau_n(i,s)*thetan(i,s) + tau_m(i,s)*thetam(i,s);

	gravity.iterlim =10000;
$include gravity.gen
	solve gravity using mcp;
	put_utility 'title' /'Trade cost counterfactual for ',ii.tl,' precision = ',gravity.objval;

	solvelog("objval",ii,"TradeCost") = gravity.objval;
	solvelog("modelstat",ii,"TradeCost") = gravity.modelstat;
	solvelog("solvestat",ii,"TradeCost") = gravity.solvestat;

);
display tau_min, a_0;
$exit


	SY.LO(ib(i),s)$yref(i,s) = 0;	SY.UP(ib(i),s)$yref(i,s) = inf;

	gravity.iterlim =10000;
$include gravity.gen
	solve gravity using mcp;
	put_utility 'title' /'Output calibration for ',ii.tl,' precision = ',gravity.objval;

	solvelog("objval",ii,"Output") = gravity.objval;
	solvelog("modelstat",ii,"Output") = gravity.modelstat;
	solvelog("solvestat",ii,"Output") = gravity.solvestat;

	SM.LO(ib(i),prt)$mref(i,prt) = 0;	SM.UP(ib(i),prt)$mref(i,prt) = inf;
	gravity.iterlim =10000;
$include gravity.gen
	solve gravity using mcp;
	put_utility 'title' /'Gravity calibration for ',ii.tl,' precision = ',gravity.objval;

	solvelog("objval",ii,"Gravity") = gravity.objval;
	solvelog("modelstat",ii,"Gravity") = gravity.modelstat;
	solvelog("solvestat",ii,"Gravity") = gravity.solvestat;

	endow(ib(i)) = endow(i);
	aref(ib(i),s) = aref(i,s);
	mref(ib(i),prt) = mref(i,prt);
	eref(ib(i),prt) = eref(i,prt);
	yref(ib(i),s) = yref(i,s);
	vdfm(ib(i),ss,s) = PY_AD.L(i,ss,s)*PY.L(i,ss);
	vifm(ib(i),s) = sum(prt, PM_AD.L(i,prt,s)*PM.L(i,prt));
	vxm(ib(i),s) = sum(prt, PY_X.L(i,s,prt) * PY.L(i,s));
	dref(ib(i),s) = sum(ss,vdfm(i,s,ss));

	AD.L(ib,s) = 1;
	Y.L(ib,s) = 1;
	P.L(ib,s) = 1;
	PY.L(ib,s) = 1;
	PD.L(ib,s) = 1;

	bilat.iterlim = 0;
$include bilat.gen
	solve bilat using mcp;

	solvelog("objval",ii,"Bilat") = bilat.objval;
	solvelog("modelstat",ii,"Bilat") = bilat.modelstat;
	solvelog("solvestat",ii,"Bilat") = bilat.solvestat;

	put_utility 'title' /'Bilateral flow for ',ii.tl,' precision = ',gravity.objval;

);
option solvelog:3:2:1;
display solvelog;

set usa(r) /usa/;

rtd(ii(i),usa(r),s) = rtd(i,r,s)*(xd0(i,r,s)+nd0(i,r,s));
rtm(ii(i),usa(r),s) = rtm(i,r,s)*md0(i,r,s);

parameter	rates;
rates(i,s,"rtd0") = rtd0(i,"usa",s);
rates(i,s,"rtm0") = rtm0(i,"usa",s);
option rates:3:2:1;
display rates;

parameter	lamda(s,i,*)	Tax adjustment multiplier;
lamda(s,itrd(i),"ratio")$(rtd(i,"usa",s)+rtm(i,"usa",s))
	= ((rtd(i,"usa",s)+rtm(i,"usa",s)) /
	   (rtd0(i,"usa",s)*sum(ss,vdfm(i,ss,s)) + rtm0(i,"usa",s)*vifm(i,s)) );
lamda(s,itrd(i),"%")$(rtd(i,"usa",s)+rtm(i,"usa",s))
	= 100 * ((rtd(i,"usa",s)+rtm(i,"usa",s)) -
	   (rtd0(i,"usa",s)*sum(ss,vdfm(i,ss,s)) + rtm0(i,"usa",s)*vifm(i,s)) ) /aref(i,s);
option lamda:2:2:1;
display lamda;

parameter	compare		Comparison of tax rates ;
loop(itrd(i),
	compare(i,s,"rtd0") = rtd0(i,"usa",s);
	compare(i,s,"rtm0") = rtm0(i,"usa",s);
	compare(i,s,"value0") = xd0(i,"usa",s) + nd0(i,"usa",s) + md0(i,"usa",s);
	compare(i,s,"value") = sum(ss,vdfm(i,ss,s))+vifm(i,s);
	compare(i,s,"rt*")$(rtd(i,"usa",s)+rtm(i,"usa",s)) = 
		(rtd(i,"usa",s)+rtm(i,"usa",s))/(sum(ss,vdfm(i,ss,s))+vifm(i,s));
);
option compare:3:2:1;
display compare;

loop(itrd(i),
	rtd0(i,"usa",s)$(rtd(i,"usa",s)+rtm(i,"usa",s)) = (rtd(i,"usa",s)+rtm(i,"usa",s))/(sum(ss,vdfm(i,ss,s))+vifm(i,s));
	rtm0(i,"usa",s)$(rtd(i,"usa",s)+rtm(i,"usa",s)) = (rtd(i,"usa",s)+rtm(i,"usa",s))/(sum(ss,vdfm(i,ss,s))+vifm(i,s));
	rtd(i,"usa",s) = rtd0(i,"usa",s);
	rtm(i,"usa",s) = rtm0(i,"usa",s);
);

parameter	dd0(i,r,s,s)	Intra-national trade;
dd0(itrd(i),usa,ss,s) = vdfm(i,ss,s);
md0(itrd(i),usa,s) = vifm(i,s);
xn0(itrd(i),usa,s) = vxm(i,s);
xd0(itrd(i),usa,s) = dref(i,s);
dd0(i,r,s,s)$(not usa(r)) = xd0(i,r,s);
dd0(i,usa(r),s,s)$(not itrd(i)) = xd0(i,r,s);
nd0(itrd(i),usa,s) = 0;

execute_unload 'gravity.gdx', dd0, md0, nd0, xn0, xd0, esub_ln, esub_nn, itrd, rtd0, rtm0, rtd, rtm;


