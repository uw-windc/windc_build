$title	Calculate the Agricultural Trade Multipliers

$include beadata

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

parameter	v_PY(r,s)	Agricultural content - state output
		v_PX(g)		Agricultural content - exports
		v_PN(g)		Agricultural content - national market
		v_PI(mrg)	Agricultural content - margin
		v_PA(r,g)	Agricultural content - absorption
		v_PYn(r,g)	Updated agricultural content - state output,
		content(r,g)	Sectoral content (output or VA),
		dev		Deviation
		iter_log	Iteration log
		atmval(g,*)	Trade multiplier values;

content(r,ags(s)) = ys0_(yb,r,s);
dev = 1;
v_PY(r,s)$y_(yb,r,s) = content(r,s)/ys0_(yb,r,s);
loop(iter$round(dev,2),
	v_PX(g)$vx0(yb,g) = sum(r,v_PY(r,g)*(x0(yb,r,g)-rx0(yb,r,g)))/ vx0(yr,g);


	v_PN(g)$n0(yb,g) = sum(r,v_PY(r,g)*ns0(yb,r,g))/n0(yb,g);

	v_PI(mrg) = sum((r,g),v_PY(r,g)*ms0(yb,r,g,mrg))/sum((r,g),ms0(yb,r,g,mrg));

	v_PA(r,g)$a0(yb,r,g) = ( v_PN(g)*nd0(yb,r,g) + v_PY(r,g)*yd0(yb,r,g) +
		sum(mrg,v_PI(mrg)*md0(yb,r,mrg,g))) / a0(yb,r,g);

	v_PYn(r,s)$y_(yb,r,s) = ( sum(g,v_PA(r,g)*id0_(yb,r,g,s))+content(r,s) ) / ys0_(yb,r,s);

	dev = sum((r,s)$y_(yb,r,s), abs(v_PYn(r,s)-v_PY(r,s)));
	v_PY(r,s)$y_(yb,r,s) = v_PYn(r,s);
	iter_log(iter,"dev") = dev;
	atmval(g,"symm_iter") = 1000 * (v_PX(g) - 1$ags(g));
	atmval(g,"v_PY") = 1000 * (v_PY("usa",g) - 1$ags(g));
);
display iter_log;

option atmval:3;
display atmval;

$exit

file kcon /con:/; put kcon; kcon.lw=0;

set	metric /gdp, output/

parameter	iterlog(yr,metric,iter,*)	Iteration log,
		atm(yr,s,metric)		Agricultural trade multipliers;


loop(yr,
  yb(yr) = yes;

  loop(metric,
	if (sameas(metric,"gdp"),
	  content(r,ags(s)) = ys0_(yb,r,s)*ty_(yb,r,s)+ld0_(yb,r,s)+kd0_(yb,r,s)
	else
	  content(r,ags(s)) = ys0_(yb,r,s)
	);

	dev = 1;
	v_PY(r,s)$y_(yb,r,s) = content(r,s)/ys0_(yb,r,s);
	loop(iter$round(dev,2),
	    v_PX(g)$vx0(yb,g) = sum(r,v_PY(r,g)*(x0(yb,r,g)-rx0(yb,r,g)))/ sum(r,x0(yb,r,g));
	    v_PN(g)$n0(yb,g) = sum(r,v_PY(r,g)*ns0(yb,r,g))/n0(yb,g);
	    v_PI(mrg) = sum((r,g),v_PY(r,g)*ms0(yb,r,g,mrg))/sum((r,g),ms0(yb,r,g,mrg));
	    v_PA(r,g)$a0(yb,r,g) = ( v_PN(g)*nd0(yb,r,g) + v_PY(r,g)*yd0(yb,r,g) +
		sum(mrg,v_PI(mrg)*md0(yb,r,mrg,g))) / a0(yb,r,g);
	    v_PYn(r,s)$y_(yb,r,s) = ( sum(g,v_PA(r,g)*id0_(yb,r,g,s))+content(r,s) ) / ys0_(yb,r,s);
	    dev = sum((r,s)$y_(yb,r,s), abs(v_PYn(r,s)-v_PY(r,s)));
	    v_PY(r,s)$y_(yb,r,s) = v_PYn(r,s);
	    iterlog(yr,metric,iter,"dev") = dev;

	    putclose "yr:",yr.tl,", metric:",metric.tl, ", iter:",iter.tl,", dev:",dev/;

	 );
	 atm(yr,g,metric) = v_PX(g) - 1$ags(g);
));

option atm:3:2:1;
display atm;

$exit

execute_unload 'atm.gdx',atm;
execute 'gdxxrw i=atm.gdx o=atm.xlsx par=atm rng=PivotData!a2 cdim=0 intastext=n';
