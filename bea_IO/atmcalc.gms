$title	Canonical Template GTAP-WINDC Model (MGE format)

*	Alternative: gdp

$if not set metric $set metric output


$if not set ds $set ds data\gebalanced

set	yr(*)	Years with summary tables 
	s(*)	Sectors
	r(*)	Regions
	mrg	Margins /trd,trn/,
	xd	Exogenous demand /
*.		F010  	"Personal consumption expenditures",
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",
		F06C  	"Federal Government defense: Consumption expenditures",
		F06E  	"Federal national defense: Gross investment in equipment",
		F06N  	"Federal national defense: Gross investment in intellectual property products",
		F06S  	"Federal national defense: Gross investment in structures",
		F07C  	"Federal Government nondefense: Consumption expenditures",
		F07E  	"Federal nondefense: Gross investment in equipment",
		F07N  	"Federal nondefense: Gross investment in intellectual property products",
		F07S  	"Federal nondefense: Gross investment in structures",
		F10C  	"State and local government consumption expenditures",
		F10E  	"State and local: Gross investment in equipment",
		F10N  	"State and local: Gross investment in intellectual property products",
		F10S  	"State and local: Gross investment in structures" /;

$gdxin %ds%.gdx
$load yr s r

alias (s,g,ss,gg);

option s:0:0:1;
display s;

parameter	
	ld0(yr,r,s)	Labor demand
	kd0(yr,r,s)	Capital demand
	lvs(yr,r,s)	Labor value share
	kl0(yr,r,s)	Aggregate factor earnings (K+L)
	x0(yr,r,g)	Regional exports
	d0(yr,r,g)	Domestic demand,
	rx0(yr,r,g)	Re-exports
	ns0(yr,r,g)	Supply to the national market 
	n0(yr,g)	National market aggregate supply
	a0(yr,r,g)	Absorption
	m0(yr,r,g)	Imports
	ty0(yr,r,s)	Output tax rate
	tm0(yr,r,g)	Import tariff
	ta0(yr,r,g)	Product tax
	nd0(yr,r,g)	National market demand,
	am(yr,r,mrg,g)	Trade and transport margin,
	ms0(yr,r,g,mrg)	Margin supply,
	ys0(yr,r,s,g)	Make matrix
	id0(yr,r,g,s)	Intermediate demand,
	id0(yr,r,g,s)	Intermediate demand,
	cd0(yr,r,g)	Final demand
	fd0(yr,r,g,xd)	Final demand
	md0(yr,r,mrg,g)	Margin demand;

$loaddc ys0 ld0 kd0 id0 rx0 x0 ms0 ns0 nd0 cd0 a0 m0 ty0 tm0 ta0 md0
$load fd0
parameter
	ty(yr,r,s)	Output tax rate
	tm(yr,r,g)	Import tariff
	ta(yr,r,g)	Product tax;

ty(yr,r,s) = ty0(yr,r,s);
tm(yr,r,g) = tm0(yr,r,g);
ta(yr,r,g) = ta0(yr,r,g);

*	Choose the base year

singleton set yb(yr) /2017/;

parameter	epsilonx(g)	Export demand elasticity;
epsilonx(g) = 2;

parameter	vx0(yr,g)	Aggregate exports,
		y0(yr,r,g)	Aggregate output,
		n0(yr,g)	Aggregate national market;

y0(yr,r,g) = sum(s,ys0(yr,r,s,g));
vx0(yr,g) = sum(r,x0(yr,r,g));
n0(yr,g) = sum(r,ns0(yr,r,g));

set	y_(yr,r,s)	Set of active Y sectors
	pa_(yr,r,g)	Set of active PA markets;

parameter	abstol /6/;
y_(yr,r,s) = round(sum(g,ys0(yr,r,s,g)),abstol);
pa_(yr,r,g) = a0(yr,r,g) + max(0,-sum(xd,fd0(yr,r,g,xd)))

parameter	profit	Check on profit;
profit(yr,r,s,"PY") = sum(g,ys0(yr,r,s,g));
profit(yr,r,s,"PA") = sum(g,id0(yr,r,g,s));
profit(yr,r,s,"VABAS") = ld0(yr,r,s) + kd0(yr,r,s) + sum(g,ys0(yr,r,s,g))*ty(yr,r,s);
profit(yr,r,s,"chk") = profit(yr,r,s,"PY") - profit(yr,r,s,"PA") - profit(yr,r,s,"VABAS");
option profit:3:1:1;
*.display profit;

parameter	market	Check on market clearance;
market(yr,r,g,"Y") = sum(s,ys0(yr,r,s,g));
market(yr,r,g,"ES") = x0(yr,r,g) - rx0(yr,r,g);
market(yr,r,g,"N") = ns0(yr,r,g);
market(yr,r,g,"MS") = sum(mrg,ms0(yr,r,g,mrg));
market(yr,r,g,"chk") = market(yr,r,g,"Y") - market(yr,r,g,"ES") - 
		    market(yr,r,g,"N") - market(yr,r,g,"MS");
option market:3:1:1;
*.display market;

alias (u,*);
profit(yr,r,s,u)$(not round(profit(yr,r,s,"chk"),6)) = 0;
display profit;

market(yr,r,g,u)$(not round(market(yr,r,g,"chk"),6)) = 0;
display market;

parameter	yd0(yr,r,g)	Local demand, 
		vb(yr,r)	Current account balance, 
		vbchk		Cross check on current account;

yd0(yr,r,g) = 0;

vb(yr,r) = sum(g,cd0(yr,r,g)) + sum((g,xd),fd0(yr,r,g,xd)) - sum(s,ld0(yr,r,s)+kd0(yr,r,s))
		- sum(g$a0(yr,r,g), (m0(yr,r,g)-rx0(yr,r,g))*tm(yr,r,g) + a0(yr,r,g)*ta(yr,r,g))
		- sum(y_(yr,r,s),sum(g,ys0(yr,r,s,g))*ty(yr,r,s));

vbchk(yr) = sum(r,vb(yr,r));

display vb, vbchk;

*	Convert to a symmetric dataset:

parameter	theta(yr,r,s,g)		Sector s share of good g supply,
		ys0_(yr,r,g)		Output of good g,
		ty_(yr,r,g)		Output tax,
		ty0_(yr,r,g)		Output tax (benchmark),
		id0_(yr,r,gg,g)		Intermediate demand,
		ld0_(yr,r,g)		Labor demand,
		kd0_(yr,r,g)		Capital demand;

*	Sector s share of commodity g supply in region r:

theta(yb,r,s,g)$ys0(yb,r,s,g) = ys0(yb,r,s,g)/sum(ss,ys0(yb,r,ss,g));

ys0_(yb,r,g) = sum(s,ys0(yb,r,s,g));
y_(yb,r,s) = ys0_(yb,r,s);

ty_(yb,r,g)$ys0_(yb,r,g) = sum(s,ty(yb,r,s)*ys0(yb,r,s,g))/ys0_(yb,r,g);
ty0_(yb,r,g) = ty_(yb,r,g);
id0_(yb,r,gg,g) = sum(s,theta(yb,r,s,g)*id0(yb,r,g,s));
ld0_(yb,r,g)    = sum(s,theta(yb,r,s,g)*ld0(yb,r,s));
kd0_(yb,r,g)    = sum(s,theta(yb,r,s,g)*kd0(yb,r,s));

set	ags(s)  Agricultural sectors/ 
		osd_agr  "Oilseed farming (1111A0)",
		grn_agr  "Grain farming (1111B0)",
		veg_agr  "Vegetable and melon farming (111200)",
		nut_agr  "Fruit and tree nut farming (111300)",
		flo_agr  "Greenhouse, nursery, and floriculture production (111400)",
		oth_agr  "Other crop farming (111900)",
		dry_agr  "Dairy cattle and milk production (112120)",
		bef_agr  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)",
		egg_agr  "Poultry and egg production (112300)",
		ota_agr  "Animal production, except cattle and poultry and eggs (112A00)" /;

set		iter /iter1*iter10/;

parameter	iterlog(iter,*)	Iteration log
		dev		Deviation,
		content(r,g)	Sectoral content (output or VA);

$if %metric%==gdp	content(r,ags(s)) = sum(g,ys0_(yb,r,s,g))*ty(yb,r,s)+ld0(yb,r,s)+kd0(yb,r,s)
$if %metric%==output	content(r,ags(s)) = sum(g,ys0(yb,r,s,g))

parameter	v_PY(r,s)	Agricultural content - state output
		v_PX(g)		Agricultural content - exports
		v_PN(g)		Agricultural content - national market
		v_PI(mrg)	Agricultural content - margin
		v_PA(r,g)	Agricultural content - absorption
		v_PYn(r,g)	Updated agricultural content - state output;

*	Initial assigment -- direct content:


v_PY(r,s)$y_(yb,r,s) = content(r,s)/ys0_(yb,r,s);

file kcon /con:/; put kcon; kcon.lw=0;
dev = 1;
loop(iter$round(dev,2),
	v_PX(g)$vx0(yb,g) = sum(r,v_PY(r,g)*(x0(yb,r,g)-rx0(yb,r,g)))/
					sum(r,x0(yb,r,g));

	v_PN(g)$n0(yb,g) = sum(r,v_PY(r,g)*ns0(yb,r,g))/n0(yb,g);

	v_PI(mrg) = sum((r,g),v_PY(r,g)*ms0(yb,r,g,mrg))/sum((r,g),ms0(yb,r,g,mrg));

	v_PA(r,g)$a0(yb,r,g) = (
		v_PN(g)*nd0(yb,r,g) + v_PY(r,g)*yd0(yb,r,g) +
		sum(mrg,v_PI(mrg)*md0(yb,r,mrg,g)))/a0(yb,r,g);

	v_PYn(r,s)$y_(yb,r,s) = 
		( sum(g,v_PA(r,g)*id0_(yb,r,g,s))+content(r,s) ) / ys0_(yb,r,s);
	dev = sum((r,s)$y_(yb,r,s), abs(v_PYn(r,s)-v_PY(r,s)));
	v_PY(r,s)$y_(yb,r,s) = v_PYn(r,s);
	iterlog(iter,"dev") = dev;
	putclose iter.tl,dev/;
);
display iterlog, v_PX;

$exit

$label bilateral

loop(re(r),

*	Track content of all sectors which have nonzero production:

	is(i,s) = yes$content(i,re,s);
	samesector(is,is) = yes;

*	Initial assigment -- based on pooled model content:

	v_PY(i,s,is)$y_(i,r,s) = content(i,r,s)$samesector(i,s,is)/vom(i,r,s);

	dev = 1;
	loop(iter,
		v_P(i,is)$x_(i,r)  = sum(s,xref(i,s)*v_PY(i,s,is))/vxm(i,r);
		v_PZ(i,s,is)$z_(i,r,s) = sum(ss,v_PY(i,ss,is)*vdfm(i,r,ss,s))/a0(i,r,s);
		v_PYn(i,s,is)$y_(i,r,s) = (sum(j, vafm(j,i,r,s)*v_PZ(j,s,is)) + 
				content(i,r,s)$samesector(i,s,is) )/vom(i,r,s);
		dev = sum((i,s,is)$y_(i,r,s), abs(v_PYn(i,s,is)-v_PY(i,s,is)));
		v_PY(i,s,is)$y_(i,r,s) = v_PYn(i,s,is)$y_(i,r,s);
		iterlog(iter,"dev") = dev;
		putclose iter.tl,dev/;
	);

        atm(is(i,s),iag) = v_P(iag,is);
);
display iterlog;
