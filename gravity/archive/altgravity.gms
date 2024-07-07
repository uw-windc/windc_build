$title Use Gravity to Calibrate Bilateral Interstate Trade Flows


set   agcensus           Aggregated Census regions /
               nor    ! northeast
	       mdw    ! midwest
	       sou    ! south
	       wes    ! west
      /;


set	census      Census divisions /
		neg     "New England" 
		mid     "Mid Atlantic" 
		enc     "East North Central" 
		wnc     "West North Central" 
		sac     "South Atlantic" 
		esc     "East South Central" 
		wsc     "West South Central" 
		mtn     "Mountain" 
		pac     "Pacific" /;


set	mkt	Set of possible markets 
		/pooled, national, set.agcensus, set.census/;

*	Read the data:


$set gtapwindc_datafile ..\GTAPWiNDC\2017\gtapwindc\43_filtered.gdx

$include ..\GTAPWiNDC\gtapwindc_mge

set	pd(*)	Port districts
$gdxin 'tradedata/tradedata.gdx'
$load pd

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

parameters
	tau_d(i,s,ss)	Transport cost multiplier on domestic flows,
	tau_x(i,s,prt)	Transport cost multiplier for exports
	tau_m(i,prt,s)	Transport cost multiplier for imports,

	esub_nn(i)	Elasticity of substitution intranational imports,
	esub_ln(i)	Elasticity of substitution - local versus other domestic,
	esub_dm(i)	Elasticity of substitution - domestic versus international,
	esub_mm(i)	Elasticity of substitution - imports by port,
	esub_x(i)	Elasticity of substitution  in export demand,

	yref(i,s)	State output (domestic + export),
	aref(i,s)	State absorption (domestic + import -- net of tax),
	eref(i,prt)	Exports,
	mref(i,prt)	Imports;

parameter	market		Market balance conditions;
market(i,"vom") = sum(s,vom(i,"usa",s));
market(i,"vim") = vim(i,"usa");
market(i,"vxm") = sum(r,vxmd(i,"usa",r)) + vst(i,"usa");
market(i,"d0") = sum((mkt,s),nd0(i,mkt,"usa",s));
market(i,"m0") = sum((s),md0(i,"usa",s));
market(i,"dchk") = market(i,"vom") - market(i,"vxm") - market(i,"d0");
market(i,"mchk") =  market(i,"vim") - market(i,"m0");
market(i,"chk") = market(i,"vom") + market(i,"vim") - market(i,"vxm") - market(i,"d0") - market(i,"m0");
display market;

esub_ln(i) = 3;
esub_nn(i) = 5;
esub_dm(i) = 4;
esub_mm(i) = 8;
esub_x(i)  = 8;

yref(i,s) = vom(i,"usa",s);

parameter	theta_e(i,prt)	Export value share,
		theta_m(i,prt)	Import value share;

loop(itrd(i),

	theta_e(i,prt)$sum(prt.local,trade(prt,i,"export")) = 
		trade(prt,i,"export") / sum(prt.local,trade(prt,i,"export"));
	theta_m(i,prt)$sum(prt.local,trade(prt,i,"import")) = 
		trade(prt,i,"import") / sum(prt.local,trade(prt,i,"import"));

*	Filter the trade flows:

	theta_e(i,prt)$(theta_e(i,prt)<.01) = 0;
	theta_m(i,prt)$(theta_m(i,prt)<.01) = 0;

	theta_e(i,prt) = theta_e(i,prt) / sum(prt.local, theta_e(i,prt));
	theta_m(i,prt) = theta_m(i,prt) / sum(prt.local, theta_m(i,prt));

	eref(i,prt) = theta_e(i,prt) * (sum(r,vxmd(i,"usa",r))+vst(i,"usa"));
	mref(i,prt) = theta_m(i,prt) * vim(i,"usa");
);
display mref, eref;

*	Absorption -- net of tax:

aref(itrd(i),s) = sum(mkt,nd0(i,mkt,"usa",s)) + md0(i,"usa",s);

parameter	thetay(i,s)	Local output share of absorption
		thetam(i,prt)	Import share of absorption
		thetae(i,s)	Regional share of production;

*	Uniformly mixed demand shares:

thetay(i,ss)$yref(i,ss) = yref(i,ss)/sum(s.local,yref(i,s)) *
		(sum(s,yref(i,s))-sum(prt,eref(i,prt))) /
		(sum(s,yref(i,s))+sum(prt,mref(i,prt)-eref(i,prt)));

thetae(i,s) = yref(i,s)/sum(ss,yref(i,ss));

thetam(i,prt)$mref(i,prt) = mref(i,prt)/sum(prt.local,mref(i,prt)) *
		sum(prt.local,mref(i,prt))/
		(sum(s,yref(i,s))+sum(prt.local,mref(i,prt)-eref(i,prt))); 
display thetay, thetam;

set	ib(i)	Current sector to balance;

parameter	endow(i)	Endowment (PE closure device);
endow(i) = sum(s,yref(i,s)) + sum(prt,mref(i,prt));

parameter	pymarket;
pymarket(itrd(i),s) = yref(i,s) - sum(ss,thetay(i,s)*aref(i,ss)) - sum(prt,thetae(i,s)*eref(i,prt));
display pymarket;

parameter	lamda_a(i,s)	Productivity index -- a;
lamda_a(itrd(i),s) = 1;

$ontext
$model:gravity

$sectors:
	Z(i,r,s)$z_(i,r,s)	! Absorption (Armington demand)

$commodities:
	PZ(i,r,s)$pz_(i,r,s)	! Demand price
	PY(g,r,s)$py_(g,r,s)	! Output price
	PP(i,prt)$pp_(i,prt)	! Port price
	PFX			! Price level

$consumers:
	XD(i,prt)$xd_(i,prt)	! Export demand
	D(i,s)$d_(i,s)		! Final demand
	RA			! PE Closure Agent

$auxiliary:
	SY(i,s)$sy_(i,s)	! Output supply
	SM(i,prt)$sm_(i,prt)	! Import supply

$prod:Z(i,r,s)$z_(i,r,s)  s:esubdm(i)  dn:(2*esubdm(i))  nn:esubn(i)
	o:PZ(i,r,s)	q:(lamda_a(i,s)*a0(i,r,s))
	i:PY(i,r,ss)	q:(tau_d(i,ss,s)*bd0(i,r,ss,s))	p:(1/tau_d(i,ss,s))  dn:$sameas(s,ss) nn:(not sameas(s,ss))
	i:PP(i,prt)	q:(tau_m(i,prt,s)*


$prod:AD(i,s)$(aref(i,s) and ib(i))  s:esub_dm(i)  L:esub_ln(i)  m:esub_mm(i)  d(L):esub_nn(i) 
  o:PD(i,s)	q:(lamda_a(i,s)*aref(i,s))
  i:PO(i,ss)	q:(tau_d(i,ss, s)*thetay(i, ss)*aref(i,s)) p:(1/tau_d(i,ss,s))  L:$sameas(ss,s)	d:$(not sameas(ss,s))
  i:PI(i,prt)	q:(tau_m(i,prt,s)*thetam(i,prt)*aref(i,s)) p:(1/tau_m(i,prt,s)) m:

$report:
  v:PO_AD(i, ss, s)$(aref(i,s) and ib(i) and thetay(i,ss))  i:PO(i,ss)	prod:AD(i,s)
  v:PO_XD(i,  s,prt)$(eref(i,prt) and ib(i) and thetae(i,s)) d:PO(i,s)	demand:XD(i,prt)
  v:PI_AD(i, prt,s)$(aref(i,s) and ib(i) and thetam(i,prt)) i:PI(i,prt)	prod:AD(i,s)

$demand:XD(i,prt)$(eref(i,prt) and ib(i))   s:esub_x(i)
  d:PO(i,s)	q:(tau_x(i,s,prt)*thetae(i,s)*eref(i,prt))	p:(1/tau_x(i,s,prt))
  e:PFX		q:eref(i,prt)	

$demand:RA
  d:PFX
  e:PFX					q:(sum(ib,endow(ib)))
  e:PO(i,s)$(yref(i,s) and ib(i))	q:yref(i,s)		r:SY(i,s)
  e:PI(i,prt)$(mref(i,prt) and ib(i))	q:mref(i,prt)		r:SM(i,prt)

$demand:D(i,s)$(aref(i,s) and ib(i))
  d:PD(i,s)
  e:PFX		q:aref(i,s)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(i,s)$(yref(i,s) and ib(i))
	SY(i,s)*PO(i,s) =e= PFX;

$constraint:SM(i,prt)$(mref(i,prt) and ib(i))
	SM(i,prt)*PI(i,prt) =e= PFX;

$offtext
$sysinclude mpsgeset gravity

*	On the first pass hold supplies fixed:

SY.FX(i,s) = 1;
SM.FX(i,prt) = 1;

option aref:3:0:1, yref:3:0:1, mref:3:0:1, eref:3:0:1;
*.display aref, yref, mref, eref;

parameter	totals	Total values;
totals(itrd(i),"aref") = sum(s,aref(i,s));
totals(itrd(i),"yref") = sum(s,yref(i,s));
totals(itrd(i),"mref") = sum(prt,mref(i,prt));
totals(itrd(i),"eref") = sum(prt,eref(i,prt));
display totals;

tau_d(i,s,ss) = 1;
tau_x(i,s,prt) = 1;
tau_m(i,prt,s) = 1;

*	Formulate a template PE model which conforms to the WiNDC structure with a 
*	123 formulation for export supply.

parameters	bvdfm(i,ss,s)	Bilateral trade,
		bvifm(i,s)	Imports,
		xref(i,s)	Exports,
		dref(i,s)	Supply to the domestic market;

$ontext
$model:bilat

$sectors:
	AD(i,s)$(aref(i,s) and ib(i))	! Absorption (Armington demand)
	DX(i,s)$(xref(i,s)   and ib(i))	! Exports

$commodities:
	PFD(i,s)$(aref(i,s)  and ib(i))	! Demand price
	PO(i,s)$(yref(i,s) and ib(i))	! Output price
	PD(i,s)$(dref(i,s) and ib(i))	! Domestic price
	PFX				! Price level

$consumers:
	RA				! PE Closure Agent

$prod:AD(i,s)$(aref(i,s) and ib(i))  s:esub_dm(i)  L:esub_ln(i)  m:esub_mm(i)  d(L):esub_nn(i) 
	o:PFD(i,s)	q:aref(i,s)
	i:PD(i,ss)	q:bvdfm(i,ss,s)	p:1  L:$sameas(ss,s)	d:$(not sameas(ss,s)) 
	i:PFX		q:bvifm(i,s)	p:1  m:

$prod:DX(i,s)$(yref(i,s) and ib(i))   t:4
	o:PFX		q:xref(i,s)
	o:PD(i,s)	q:dref(i,s)
	i:PO(i,s)	q:yref(i,s) 

$demand:RA
	d:PFX
	e:PFX			q:(sum(ib,endow(ib)))
	e:PFD(i,s)$ib(i)	q:(-aref(i,s))
	e:PO(i,s)$ib(i)		q:yref(i,s) 		
$offtext
$sysinclude mpsgeset bilat
PFX.FX = 1;

*	Formulate a model with an explicit national market
*	and nested CES demand (not a 123/CET model):

parameter	a_0(i,s)	Absorption
		yd_0(i,s)	Local supply
		nd_0(i,s)	Demand from national market
		md_0(i,s)	Imports
		n_0(i)		Aggregate national supply
		ns_0(i,s)	Supply to national market
		xs_0(i,s)	Export supply
		x_0(i)		Aggregate exports
		y_0(i,s)	Production;

$ontext
$model:national

$sectors:
	AD(i,s)$(a_0(i,s) and ib(i))	! Absorption (Armington demand)
	AN(i)$ib(i)			! National market
	AX(i)$ib(i)			! Export aggregation

$commodities:
	PD(i,s)$(a_0(i,s)  and ib(i))	! Demand price
	PO(i,s)$(y_0(i,s) and ib(i))	! Output price
	PX(i)$(x_0(i)     and ib(i))	! Export price
	NP(i)$ib(i)			! National market price
	PFX				! Price level

$consumers:
	RA				! PE Closure Agent

$prod:AD(i,s)$(a_0(i,s) and ib(i))  s:4  d:8
	o:PD(i,s)	q:a_0(i,s)
	i:PO(i,s)	q:yd_0(i,s)	d:
	i:NP(i)		q:nd_0(i,s)	d:
	i:PFX		q:md_0(i,s)	

$prod:AN(i)$ib(i)  s:8
	o:NP(i)		q:n_0(i)
	i:PO(i,s)	q:ns_0(i,s)

$prod:AX(i)$ib(i)   s:8
	o:PX(i)		q:x_0(i)
	i:PO(i,s)	q:xs_0(i,s)

$demand:RA
	d:PFX
	e:PX(ib)	q:(-x_0(ib))
	e:PD(ib,s)	q:(-a_0(ib,s))
	e:PO(ib,s)	q:y_0(ib,s)
	e:PFX		q:(sum(ib,endow(ib)))

$offtext
$sysinclude mpsgeset national

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
*.option sysout=on;


parameter	shares(i,s,*)		Trade shares,
		nchk			Cross check on national market;

loop(itrd,

	ib(i) = yes$sameas(i,itrd);

	SY.FX(i,s) = 1;
	SM.FX(i,prt) = 1;

*	Benchmark replication (zero trade costs):

	gravity.workspace=64;
	gravity.iterlim =0;
$include gravity.gen
	solve gravity using mcp;
	abort$round(gravity.objval,2) "Benchmark replication error.";
	put_utility 'title' /'Benchmark precisition for ',itrd.tl,' = ',gravity.objval;

	solvelog("objval",itrd,"Benchmark") = gravity.objval;
	solvelog("modelstat",itrd,"Benchmark") = gravity.modelstat;
	solvelog("solvestat",itrd,"Benchmark") = gravity.solvestat;

*	Introduce distances:

	tau_d(ib(i),s,ss)  = dist(s, ss)**(epsilon/(1-esub_nn(i)));
	tau_m(ib(i),prt,s) = dist(s,prt)**(epsilon/(1-esub_dm(i)));
	tau_x(ib(i),s,prt) = dist(s,prt)**(epsilon/(1-esub_x(i)));

*	Scale distances:

	tau_min(ib(i),s)$aref(i,s) = min( 
		smin( ss$thetay(i,ss), tau_d(i, ss,s)), 
		smin(prt$thetam(i,prt),tau_m(i,prt,s)) ) + eps;
	display tau_min, aref;

	tau_d(ib(i),ss,s)$aref(i,s) = tau_d(i,ss,s)/tau_min(i,s);
	tau_m(ib(i),prt,s)$aref(i,s) = tau_m(i,prt,s)/tau_min(i,s);

*	Scale productivity:

	lamda_a(ib(i),s)$aref(i,s) = sum(ss, tau_d(i,ss, s)*thetay(i,ss)) + 
				     sum(prt,tau_m(i,prt,s)*thetam(i,prt));

	gravity.iterlim =10000;
$include gravity.gen
	solve gravity using mcp;
	put_utility 'title' /'Trade cost counterfactual for ',itrd.tl,' precision = ',gravity.objval;

	solvelog("objval",   itrd,"TradeCost") = gravity.objval;
	solvelog("modelstat",itrd,"TradeCost") = gravity.modelstat;
	solvelog("solvestat",itrd,"TradeCost") = gravity.solvestat;

*	Incorporate targeting variable for domestic supply:

	SY.LO(ib(i),s)$yref(i,s) = 0;	
	SY.UP(ib(i),s)$yref(i,s) = inf;

	gravity.iterlim =10000;
$include gravity.gen
	solve gravity using mcp;
	put_utility 'title' /'Output calibration for ',itrd.tl,' precision = ',gravity.objval;

	solvelog("objval",   itrd,"Output") = gravity.objval;
	solvelog("modelstat",itrd,"Output") = gravity.modelstat;
	solvelog("solvestat",itrd,"Output") = gravity.solvestat;

*	Include targeting variable for imports:

	SM.LO(ib(i),prt)$mref(i,prt) = 0;	
	SM.UP(ib(i),prt)$mref(i,prt) = inf;

	gravity.iterlim =10000;
$include gravity.gen
	solve gravity using mcp;
	put_utility 'title' /'Gravity calibration for ',itrd.tl,' precision = ',gravity.objval;

	solvelog("objval",   itrd,"Gravity") = gravity.objval;
	solvelog("modelstat",itrd,"Gravity") = gravity.modelstat;
	solvelog("solvestat",itrd,"Gravity") = gravity.solvestat;

*	Calibrate the national market model based on the gravity model solution:

	ns_0(ib,s) = PO.L(ib,s) * sum(ss$(not sameas(s,ss)),PO_AD.L(ib,s,ss));
	xs_0(ib,s) = PO.L(ib,s) * sum(prt, PO_XD.L(ib,s,prt));
	y_0(ib,s)  = yref(ib,s);
	a_0(ib,s)  = PD.L(ib,s)*lamda_a(ib,s)*aref(ib,s)*AD.L(ib,s);
	nd_0(ib,s) = sum(ss$(not sameas(s,ss)), PO.L(ib,ss)*PO_AD.L(ib,ss,s));
	yd_0(ib,s) = PO.L(ib,s)*PO_AD.L(ib,s,s);
	md_0(ib,s) = sum(prt, PI.L(ib,prt)*PI_AD.L(ib,prt,s));

	nchk(ib,"ns_0") = sum(s,ns_0(ib,s));
	nchk(ib,"nd_0") = sum(s,nd_0(ib,s));
	nchk(ib,"chk")  = nchk(ib,"ns_0") - nchk(ib,"nd_0");

	n_0(ib) = sum(s, ns_0(ib,s));
	x_0(ib) = sum(s, xs_0(ib,s));

	shares(ib,s,"yd/y")$y_0(ib,s) = 100 * yd_0(ib,s)/y_0(ib,s);
	shares(ib,s,"ns/y")$y_0(ib,s) = 100 * ns_0(ib,s)/y_0(ib,s);
	shares(ib,s,"xs/y")$y_0(ib,s) = 100 * xs_0(ib,s)/y_0(ib,s);
	shares(ib,s,"md/a")$a_0(ib,s) = 100 * md_0(ib,s)/a_0(ib,s);
	shares(ib,s,"nd/a")$a_0(ib,s) = 100 * nd_0(ib,s)/a_0(ib,s);
	shares(ib,s,"yd/a")$a_0(ib,s) = 100 * yd_0(ib,s)/a_0(ib,s);

*	Calibrate the bilateral model:

	bvdfm(ib(i),ss,s) = PO.L(i,ss)*PO_AD.L(i,ss,s);
	bvifm(ib(i),s) = sum(prt, PI.L(i,prt)*PI_AD.L(i,prt,s));
	xref(ib(i),s) = sum(prt, PO_XD.L(i,s,prt) * PO.L(i,s));
	dref(ib(i),s) = sum(ss,bvdfm(i,s,ss));

*	Recalibrate prices to unity and replicate the bilateral model:

	AD.L(ib,s) = 1;
	DX.L(ib,s) = 1;
	PD.L(ib,s) = 1;
	PO.L(ib,s) = 1;
	PD.L(ib,s) = 1;

	bilat.iterlim = 0;
$include bilat.gen
	solve bilat using mcp;
	abort$round(bilat.objval,3) "Bilateral model does not calibrate.";

	solvelog("objval",itrd,"Bilat")    = bilat.objval;
	solvelog("modelstat",itrd,"Bilat") = bilat.modelstat;
	solvelog("solvestat",itrd,"Bilat") = bilat.solvestat;
	put_utility 'title' /'Bilateral flow for ',itrd.tl,' precision = ',gravity.objval;

*	Then replicate the national market model:

	national.iterlim = 0;
$include national.gen
	solve national using mcp;
	abort$round(national.objval,3) "National model does not calibrate.";

	solvelog("objval",itrd,"National") = national.objval;
	solvelog("modelstat",itrd,"National") = national.modelstat;
	solvelog("solvestat",itrd,"National") = national.solvestat;
	put_utility 'title' /'National model for ',itrd.tl,' precision = ',gravity.objval;

);
option solvelog:3:2:1, shares:1:2:1;
display solvelog, nchk, shares;

set usa(r) /usa/;

parameter	rates	State-level tax rates;
rates(i,s,"rtd0") = rtd0(i,"usa",s);
rates(i,s,"rtm0") = rtm0(i,"usa",s);
option rates:3:2:1;
display rates;

*	Convert tax rates to values:

rtd(itrd(i),usa(r),s) = rtd(i,r,s)*sum(mkt,nd0(i,mkt,r,s));
rtm(itrd(i),usa(r),s) = rtm(i,r,s)*md0(i,r,s);

parameter	lamda(s,i,*)	Tax adjustment multiplier;

lamda(s,itrd(i),"ratio")$(rtd(i,"usa",s)+rtm(i,"usa",s))
	= ((rtd(i,"usa",s)+rtm(i,"usa",s)) /
	   (rtd0(i,"usa",s)*sum(ss,bvdfm(i,ss,s)) + rtm0(i,"usa",s)*bvifm(i,s)) );

lamda(s,itrd(i),"%")$(rtd(i,"usa",s)+rtm(i,"usa",s))
	= 100 * ((rtd(i,"usa",s)+rtm(i,"usa",s)) -
	   (rtd0(i,"usa",s)*sum(ss,bvdfm(i,ss,s)) + rtm0(i,"usa",s)*bvifm(i,s)) ) /aref(i,s);

option lamda:2:2:1;
display lamda;

parameter	compare		Comparison of tax rates ;
loop(itrd(i),
	compare(i,s,"rtd0") = rtd0(i,"usa",s);
	compare(i,s,"rtm0") = rtm0(i,"usa",s);
	compare(i,s,"value0") = sum(mkt,nd0(i,mkt,"usa",s)) + md0(i,"usa",s);
	compare(i,s,"value") = sum(ss,bvdfm(i,ss,s))+bvifm(i,s);
	compare(i,s,"rt*")$(rtd(i,"usa",s)+rtm(i,"usa",s)) = 
		(rtd(i,"usa",s)+rtm(i,"usa",s))/(sum(ss,bvdfm(i,ss,s))+bvifm(i,s));
);
option compare:3:2:1;
display compare;

loop(itrd(i),
	rtd0(i,"usa",s)$(rtd(i,"usa",s)+rtm(i,"usa",s)) = (rtd(i,"usa",s)+rtm(i,"usa",s))/(sum(ss,bvdfm(i,ss,s))+bvifm(i,s));
	rtm0(i,"usa",s)$(rtd(i,"usa",s)+rtm(i,"usa",s)) = (rtd(i,"usa",s)+rtm(i,"usa",s))/(sum(ss,bvdfm(i,ss,s))+bvifm(i,s));
	rtd(i,"usa",s) = rtd0(i,"usa",s);
	rtm(i,"usa",s) = rtm0(i,"usa",s);
);


$exit

