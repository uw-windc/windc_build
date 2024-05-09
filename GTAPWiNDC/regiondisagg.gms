$title	Disaggregate Subregions in USA for 2014 based on WINDC Benchmark

$if not set ds $set ds 43
$if not set datasets $set datasets 2017


*	Point to a WiNDC dataset:

$set windc_datafile	%datasets%/windc/%ds%.gdx
$set gtapwindc_datafile %datasets%/gtapwindc/%ds%_stub
$set dsout              %datasets%/gtapwindc/%ds%

*	Define the region to be balanced:

$if not set rb $set rb usa

*	Start off by reading the sets of subregions and 
*	households in the WiNDC dataset:

$gdxin %windc_datafile%

*	Subregions are are typically either states or census regions.
*	Households are currently quntiles (h1*h5).

set	s_usa	Subregions in USA
	h_usa	Households in USA

$load s_usa=r h_usa=h

*	Declare sets s and h to include the subregions and households
*	we will add as well as the "rest" region/household which is
*	in the stub dataset.  We need to make these declarations so
*	that we can add data without having domain violations.

set	s	Subregions in the model /set.s_usa, rest/
	h	Households in the model /set.h_usa, rest/,
	sb(s)	Subregions to balance   /set.s_usa/
	hb(h)	Households to balance   /set.h_usa/;

alias (s,ss);

$include gtapwindc_data

*	Declare WiNDC parameters we will use for targetting the disaggregation:

parameter
    ls0(s,h)		Labor supply (net),
    le0(s,ss,h)		Household labor endowment,
    tl0(s,h)		Household labor tax rate,
    ke0(s,h)		Household interest payments,
    ld0(s,g)		Labor demand,
    kd0(s,g)		Capital demand,
    ty0(s,g)		Output tax
    tk0(s)		Capital tax
    ys0(s,g,i)		Make
    i0(s,i)		Investment
    g0(s,i)		Government expenditure

set    m	Margins / trd "trade",
			  trn "transport" /;

parameters

*	Several parameter identifiers have been used in the GTAPWiNDC database
*	so we need to add a suffix to make the names unique:

    a0_windc(s,i)		Aggregate supply
    md0_windc(s,m,i)		Margin inputs
    cd0_windc(s,i,h)		Household level expenditures,
    hhtrn0_windc(s,h,trn)	Household transfers
    xs0_windc(s,i)		Regional supply to export markets,
    ns0_windc(s,i)		Regional supply to national market,
    m0_windc(s,i)		Import demand
    nd0_windc(s,i)		Regional demand from national market
    sav0_windc(s,h)		Base year savings;

$gdxin %windc_datafile%
$loaddc le0 tl0 ke0 ld0 kd0 i0 g0 ys0 ty0 tk0

*	Labor supply net of tax:

ls0(s,h) = sum(ss,le0(s,ss,h))*(1-tl0(s,h));

*	Read and rename these parameters:

$loaddc cd0_windc=cd0_h a0_windc=a0 md0_windc=md0 nd0_windc=nd0 ns0_windc=xn0 
$loaddc hhtrn0_windc=hhtrn0, m0_windc=m0 sav0_windc=sav0 xs0_windc=x0


*	Provide a comparison of trade flows in the two datasets:

parameter	trade	Trade comparison: %windc_data% vs %ds%;
trade(i,"exports","windc") = sum(s,xs0_windc(s,i));
trade(i,"imports","windc") = sum(s,m0_windc(s,i));
trade(i,"exports","gtap") = sum(r,vxmd(i,"%rb%",r)) + vst(i,"%rb%");
trade(i,"imports","gtap") = sum(r,vxmd(i,r,"%rb%")+sum(j,vtwr(i,j,r,"%rb%")));
option trade:3:1:2;
display trade;

*	Trade data and economic transactions in other regions remain unchanged:

set	rb(r)		Region to balance /%rb%/;

parameter	cshare(i,*)	Consumption value shares (%);
loop(rb,
	cshare(i,"gtap") = 100 * cd0(i,rb,"rest","rest")/sum(i.local,cd0(i,rb,"rest","rest"));
	cshare(i,"windc") = 100 * sum((sb(s),hb(h)),cd0_windc(s,i,h))/sum((i.local,sb(s),hb(h)),cd0_windc(s,i,h));
);
option cshare:1;
display cshare;

parameter	mshare(i,m)	Margin share (average);
mshare(i,m)$sum((sb(s),hb(h)),cd0_windc(s,i,h))  
	=	sum((sb(s),hb(h))$a0_windc(s,i),cd0_windc(s,i,h) * md0_windc(s,m,i)/a0_windc(s,i)) /
		sum((sb(s),hb(h)),cd0_windc(s,i,h));
display mshare;

*	Move trade and transport margins into the TRD commodity and remove these from other goods:

cd0_windc(s,i,h) =  cd0_windc(s,i,h) * (1-sum(m,mshare(i,m))) +
		sum(i.local,cd0_windc(s,i,h)*sum(m,mshare(i,m)))$sameas(i,"trd");

*	Avoid zeros for cns and ogs (both of which have very small expenditure shares in GTAP):

cd0_windc(s,i,h)$(cshare(i,"gtap") and (not cshare(i,"windc"))) 
   = cshare(i,"gtap") * sum((sb(s),i.local,hb(h)),cd0_windc(s,i,h));

cshare(i,"windc*") = 100 * sum((sb(s),hb(h)),cd0_windc(s,i,h))/sum((i.local,sb(s),hb(h)),cd0_windc(s,i,h));
display cshare;

parameter	hhtrn_compare;
hhtrn_compare(trn,"stub") = sum((rb(r),s,h),hhtrn0(r,s,h,trn));
hhtrn_compare(trn,"windc") = sum((s,h),hhtrn0_windc(s,h,trn));

set	dsource /stub,windc/;
hhtrn_compare("total",dsource) = sum(trn,hhtrn_compare(trn,dsource));
display hhtrn_compare;
option trn:0:0:1;
display trn;


set	lf(f)	Labor factors /mgr, tec, clk, srv, lab/,
	kf(f)	Capital factors /cap, lnd, res/;

*	Capital earnings:

sf(f) = kf(f);
mf(f) = lf(f);

parameter	macroaccounts	Macro economic accounts;
loop(rb(r),
	macroaccounts("$","C","GTAP") = sum((s,h),c0(r,s,h));
	macroaccounts("$","G","GTAP") = sum(s,vom("g",r,s));
	macroaccounts("$","I","GTAP") = sum(s,vom("i",r,s));
	macroaccounts("$","L","GTAP") = sum((lf(f),s,h),evomh(lf,r,s,h));
	macroaccounts("$","K","GTAP") = sum((kf(f),s,h),evomh(kf,r,s,h));
	macroaccounts("$","F","GTAP") = vb(r);
	macroaccounts("$","T","GTAP") =  sum((i,rr), rtms(i,rr,r)*((1-rtxs(i,rr,r))*vxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))) - rtxs(i,r,rr)*vxmd(i,r,rr))
				+ sum((i,s), rtd(i,r,s)*nd0(i,r,s) + rtm(i,r,s)*md0(i,r,s))
				+ sum((f,g), rtf(f,g,r)*sum(s,vfm(f,g,r,s)))
				+ sum(g, rto(g,r)*sum(s,vom(g,r,s)));

	macroaccounts("$","C","WiNDC") = sum((s,i,h),cd0_windc(s,i,h));
	macroaccounts("$","G","WiNDC") = sum((s,i),g0(s,i));
	macroaccounts("$","I","WiNDC") = sum((s,i),i0(s,i));
	macroaccounts("$","L","WiNDC") = sum((s,h),ls0(s,h));
	macroaccounts("$","K","WiNDC") = sum((s,h),ke0(s,h));
	macroaccounts("$","LD","WiNDC") = sum((s,g),ld0(s,g));
	macroaccounts("$","KD","WiNDC") = sum((s,g),kd0(s,g));
);
set	src	Source for GDP (WiNDC accounts are incomplete) /GTAP,GTAPWiNDC/;


macroaccounts("$","Expend_GDP",src) = macroaccounts("$","C",src) + macroaccounts("$","G",src) + macroaccounts("$","I",src) - macroaccounts("$","F",src);
macroaccounts("$","Income_GDP",src) = macroaccounts("$","L",src) + macroaccounts("$","K",src) + macroaccounts("$","T",src);

set	gdpitem /
		C	Household consumption,
		G	Public expenditure
		T	Tax revenue
		I	Investment
		L	Labor income
		K	Capital income
		F	Foreign savings /;


macroaccounts("%GDP",gdpitem,src)$macroaccounts("$","Expend_GDP",src) 
	= 100 * macroaccounts("$",gdpitem,src) / macroaccounts("$","Expend_GDP",src);


PARAMETER	trev		Tax revenue (total);
loop(rb(r),
  trev = 	sum((i,rr), rtms(i,rr,r)*((1-rtxs(i,rr,r))*vxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))) - rtxs(i,r,rr)*vxmd(i,r,rr))
		+ sum((i,s), rtd(i,r,s)*nd0(i,r,s) + rtm(i,r,s)*md0(i,r,s))
		+ sum((f,g), rtf(f,g,r)*sum(s,vfm(f,g,r,s)))
		+ sum(g, rto(g,r)*sum(s,vom(g,r,s)));
);

*	Implement a proportional disaggregation:

parameter	theta_va(g,s)	Production share,
		theta_c(s,*)	Consumption share,
		va0(i,s)	Value added (labor + capital)
		vatot(i)	Total sectoral value-added;

va0(i,sb(s)) = kd0(s,i)*(1+tk0(s)) + ld0(s,i) + sum(j,ys0(s,i,j))*(1+ty0(s,i));
vatot(i) = sum(sb(s),va0(i,s));



theta_va(i,sb(s))$vatot(i) = va0(i,s)/sum(s.local,va0(i,s));
theta_va("g",sb(s)) = sum(i,g0(s,i))/sum((s.local,i),g0(s,i));
theta_va("i",sb(s)) = sum(i,i0(s,i))/sum((s.local,i),i0(s,i));

*	Fraction of aggregate consumption in state s:

theta_c(sb(s),"c") = sum((i,h),cd0_windc(s,i,h))/sum((s.local,i,h),cd0_windc(s,i,h));

*	Share of state s consumption by household h:

theta_c(sb(s),hb(h)) = sum(i,cd0_windc(s,i,h))/sum((h.local,i),cd0_windc(s,i,h));
display theta_c;

vfm(f, j,rb,sb(s))    = theta_va(j,s)*vfm(f,j,rb,"rest");
vafm(i,g,rb,sb(s))    = theta_va(g,s)*vafm(i,g,rb,"rest");
cd0(i,rb,sb(s),hb(h)) = theta_c(s,h) * theta_c(s,"c") * cd0(i,rb,"rest","rest");

c0(rb,sb(s),hb(h)) = sum(i,cd0(i,rb,s,h));

vom(g,rb,sb(s)) = theta_va(g,s)*vom(g,rb,"rest");
xs0(i,rb,sb(s)) = theta_va(i,s)*xs0(i,rb,"rest");

a0(i,rb,sb(s)) = sum(g,vafm(i,g,rb,s)) + sum(h,cd0(i,rb,s,h));

*	At some point we should compute domestic trade flows in the gravity model, but
*	for the time being we assume that all states have the same sourcing shares:

md0(i,rb,sb(s))$a0(i,rb,"rest") = md0(i,rb,"rest") * a0(i,rb,s)/a0(i,rb,"rest");
nd0(i,rb,sb(s))$a0(i,rb,"rest") = nd0(i,rb,"rest") * a0(i,rb,s)/a0(i,rb,"rest");


*	Exports to the national are calibrated:

ns0(i,rb,sb(s)) = vom(i,rb,s) - xs0(i,rb,s);
abort$(smin((i,rb,sb),ns0(i,rb,sb))<0) "Error: local demand exceeds supply.",ns0;

*	Factor supply:

evom(f,rb,sb(s)) = sum(g,vfm(f,g,rb,s));
evomh(f,rb,sb(s),hb(h)) = theta_c(s,h) * evom(f,rb,s);

*	Transfers -- proportional.

hhtrn0(rb,sb(s),hb(h),trn) = theta_c(s,h) * theta_c(s,"c") * hhtrn0(rb,"rest","rest",trn);

*	Savings imputed from the budget constraint.

sav0(rb,sb(s),hb(h)) = sum(f,evomh(f,rb,s,h)) + sum(trn,hhtrn0(rb,s,h,trn)) - c0(rb,s,h);

*	In the proportional dataset tax rates are the 
*	same in all states:

rtd(i,r,sb(s)) = rtd(i,r,"rest");
rtm(i,r,sb(s)) = rtm(i,r,"rest");

parameter	savhat(s,h)	Target savings
		ehat(f,s,h)	Target factor supply
		chat(i,s,h)	Target consumption;

loop(rb,
	savhat(s,h)             = sav0_windc(s,h)/sum((s.local,h.local),sav0_windc(s,h))  * sav0(rb,"rest","rest");
	ehat(lf(f),sb(s),hb(h)) = ls0(s,h)/sum((sb.local,hb.local),ls0(sb,hb))		  * evomh(f,rb,"rest","rest");
	ehat(kf(f),sb(s),hb(h)) = ke0(s,h)/sum((sb.local,hb.local),ke0(sb,hb))		  * evomh(f,rb,"rest","rest");
	chat(i,sb(s),hb(h))$cd0(i,rb,"rest","rest") = cd0_windc(s,i,h) * cd0(i,rb,"rest","rest") /
						sum((sb.local,hb.local),cd0_windc(sb,i,hb)); 
);

variables
	OBJ		Least squares objective,
	C(i,s,h)	Consumption,
	E(f,s,h)	Factor endowment,
	T(s,h)		Transfers,
	SAV(s,h)	Savings;

nonnegative variable C;

equations objdef, budget, savings, Lendowment, Kendowment, consumption, absorption, taxrevenue;

objdef..		OBJ =e= sum((sb(s),hb(h)),
				sum(i, sqr(C(i,s,h)-chat(i,s,h))) +
				sum(f, sqr(E(f,s,h)-ehat(f,s,h))) +
				sqr(SAV(s,h)-savhat(s,h)) );

budget(sb(s),hb(h))..	sum(i,C(i,s,h)) + SAV(s,h) =e= sum(f, E(f,s,h)) + T(s,h);

savings(rb)..		sum((sb(s),hb(h)),SAV(s,h)) =e= sav0(rb,"rest","rest");

*	Separate labor markets in each state:

Lendowment(rb,lf(f),sb(s))..  sum(hb(h),E(f,s,h)) =e= sum(g,vfm(f,g,rb,s));  

Kendowment(rb,kf(f))..   sum((sb(s),hb(h)),E(f,s,h)) =e= sum((g,sb(s)),vfm(f,g,rb,s));

consumption(rb,i)..	sum((sb(s),hb(h)),C(i,s,h)) =e= cd0(i,rb,"rest","rest");

absorption(rb(r),i,sb(s))..	a0(i,r,s) =e= sum(g,vafm(i,g,r,s)) + sum(hb(h),C(i,s,h));

taxrevenue(rb)..	sum(sb(s),vom("g",rb,s)) + sum((sb(s),hb(h)),T(s,h))  =e= trev;

model hhcalib /objdef, budget, savings, Lendowment, Kendowment, consumption, absorption, taxrevenue/;

C.L(i,sb(s),hb(h)) = sum(rb,cd0(i,rb,s,h));
E.L(f,sb(s),hb(h)) = sum(rb,evomh(f,rb,s,h));
T.L(sb(s),  hb(h)) = sum((rb,trn), hhtrn0(rb,s,h,trn));
SAV.L(sb(s),hb(h)) = sum(rb,sav0(rb,s,h));

solve hhcalib using qcp minimizing OBJ;


*	Create parameters to retain values from the stub dataset calibration:

parameter	vom_rest, cd0_rest, evomh_rest, evom_rest;
loop(rb(r),
	vom_rest(g) = vom(g,r,"rest");
	cd0_rest(i) = cd0(i,r,"rest","rest");
	evomh_rest(f) = evomh(f,r,"rest","rest");
	evom_rest(f) = evom(f,r,"rest");
);

vfm(f,j,rb,"rest") = 0;
vafm(i,g,rb,"rest") = 0;
cd0(i,rb,"rest","rest") = 0;
c0(rb,"rest","rest") = 0;
vom(g,rb,"rest") = 0;
ns0(i,rb,"rest") = 0;
a0(i,rb,"rest") = 0;
md0(i,rb,"rest") = 0;
nd0(i,rb,"rest") = 0;
xs0(i,rb,"rest") = 0;
evom(f,rb,"rest") = 0;
evomh(f,rb,"rest","rest") = 0;
sav0(rb,"rest","rest") = 0;
hhtrn0(rb,"rest","rest",trn) = 0;

rtd(i,rb,sb(s)) = rtd(i,rb,"rest");
rtd0(i,rb,sb(s)) = rtd(i,rb,s);
rtm(i,rb,sb(s)) = rtm(i,rb,"rest");
rtm0(i,rb,sb(s)) = rtm(i,rb,s);

rtd(i,rb, "rest") = 0;
rtd0(i,rb,"rest") = 0;
rtm(i,rb, "rest") = 0;
rtm0(i,rb,"rest") = 0;

*	Save the model with uniform expenditure and income shares:

execute_unload '%dsout%_proportional',
	r,g,i,f,s,h,sf,mf,
	vom, vafm, vfm, ns0, xs0, a0,
	md0, nd0, c0, cd0, evom, evomh, 
	rtd, rtd0, rtm, rtm0, esube,
	etrndn, hhtrn0, sav0,
	rto, rtf, rtf0, vim, vxmd, pvxmd, pvtwr, rtxs, rtms, vtw, vtwr, vst, vb,
	esubva,  etrae, esubdm, esubm;

cd0(i,rb,sb(s),hb(h)) = C.L(i,s,h);
c0(rb,s,h) = sum(i,cd0(i,rb,s,h));
evomh(f,rb,sb(s),hb(h)) = E.L(f,sb,hb);

parameter	theta_t(s,h,trn)	Transfer shares;
loop(rb,
	theta_t(sb(s),hb(h),trn) = hhtrn0(rb,s,h,trn)/sum(trn.local,hhtrn0(rb,s,h,trn));
);

hhtrn0(rb,sb(s),hb(h),trn) = theta_t(s,h,trn) * T.L(s,h);
sav0(rb,sb(s),hb(h)) = SAV.L(s,h);

set	i_(i)	Commodities
	g_(g)	Sectors;

i_(i) = i(i); g_(g) = g(g);

$if set dropagr i_("agr") = no; g_("agr") = no; cd0("agr",rb,sb,hb)=0;

execute_unload '%dsout%',
	r,g_=g,i_=i,f,s,h,sf,mf,
	vom, vafm, vfm, a0,
	md0, xs0, nd0, ns0, c0, cd0, evom, evomh, 
	rtd, rtd0, rtm, rtm0, esube,
	etrndn, hhtrn0, sav0,
	rto, rtf, rtf0, vim, vxmd, pvxmd, pvtwr, rtxs, rtms, vtw, vtwr, vst, vb,
	esubva,  etrae, esubdm, esubm;



loop(rb(r),
	macroaccounts("$","C","GTAPWiNDC") = sum((sb(s),hb(h)),c0(r,s,h));
	macroaccounts("$","G","GTAPWiNDC") = sum(sb(s),vom("g",r,s));
	macroaccounts("$","I","GTAPWiNDC") = sum(sb(s),vom("i",r,s));
	macroaccounts("$","L","GTAPWiNDC") = sum((lf(f),sb(s),hb(h)),evomh(lf,r,s,h));
	macroaccounts("$","K","GTAPWiNDC") = sum((kf(f),sb(s),hb(h)),evomh(kf,r,s,h));
	macroaccounts("$","F","GTAPWiNDC") = vb(r);
	macroaccounts("$","T","GTAPWiNDC") =  sum((i,rr), rtms(i,rr,r)*((1-rtxs(i,rr,r))*vxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))) - 
						rtxs(i,r,rr)*vxmd(i,r,rr))
				+ sum((i,s), rtd(i,r,s)*nd0(i,r,s) + rtm(i,r,s)*md0(i,r,s))
				+ sum((f,g), rtf(f,g,r)*sum(sb(s),vfm(f,g,r,s)))
				+ sum(g, rto(g,r)*sum(sb(s),vom(g,r,s)));

);
macroaccounts("$","Expend_GDP",src) = macroaccounts("$","C",src) + macroaccounts("$","G",src) + macroaccounts("$","I",src) - macroaccounts("$","F",src);
macroaccounts("$","Income_GDP",src) = macroaccounts("$","L",src) + macroaccounts("$","K",src) + macroaccounts("$","T",src);
macroaccounts("%GDP",gdpitem,src)$macroaccounts("$","Expend_GDP",src) 
	= 100 * macroaccounts("$",gdpitem,src) / macroaccounts("$","Expend_GDP",src);

option macroaccounts:3:2:1;
display macroaccounts;


$exit



parameter	adjustment	Changes in aggregate values;
adjustment("$",g,"vom") = vom_rest(g) - sum(s,vom(g,"%rb%",s));
adjustment("$",i,"cd0") = cd0_rest(i) - sum((s,h),cd0(i,"%rb%",s,h));
adjustment("$",f,"evomh") = evomh_rest(f)-sum((sb(s),hb(h)),evomh(f,"%rb%",s,h));
adjustment("$",f,"evom")  = evom_rest(f) - sum(s,evom(f,"%rb%",s));
adjustment("%",g,"vom")$adjustment("$",g,"vom") = 100 * (sum(s,vom(g,"%rb%",s))/vom_rest(g) - 1);
adjustment("%",i,"cd0")$cd0_rest(i) = 100 * (sum((s,h),cd0(i,"%rb%",s,h))/cd0_rest(i) - 1);;

adjustment("%",f,"evomh")$evomh_rest(f) = 100 * (sum((sb(s),hb(h)),evomh(f,"%rb%",s,h))/evomh_rest(f)-1);
adjustment("%",f,"evom")$vom_rest(f) = 100 * (sum(sb(s),evom(f,"%rb%",s))/evom_rest(f) - 1);
option adjustment:3:2:1;
display adjustment;


