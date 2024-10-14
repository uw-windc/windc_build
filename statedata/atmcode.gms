*	Some additional code for ATM calculations.

$exit

		v_PY(r,g)	Content of domestic commodity,
		v_PN(g)		Content of national market commodity,
		v_PA(r,g)	Content of absorption,
		v_PI(r,mrg)	Content of margin,

$exit



parameter	content(r,s)	Content,
		atm(g,*,*)	Trade multiplier value;


parameter	v_PYn(r,g)	Lagged content
		dev		Deviation /1/
		iter_log	Iteration log

set	iter /iter1*iter25/;

*	First solve the model iteratively:

content(r,s) = y0(r,s)$ags(s);

$onechov >%gams.scrdir%itersolve.gms
v_PY(r,s) = 1$content(r,s);
dev = 1;
loop(iter$round(dev,2),
	v_PI(r,mrg) =  sum(g,v_PY(r,g)*ms0(r,g,mrg))/sum(g,ms0(r,g,mrg));
	v_PN(g(ru))$n0(g) = sum(r, v_PY(r,g)*yn0(r,g)) / n0(g);
	v_PA(r,g)$a0(r,g) = (v_PY(r,g)*yd0(r,g) + v_PN(g)*dn0(r,g) + 
			sum(mrg,v_PI(r,mrg)*md0(r,g,mrg))) / a0(r,g);
	v_PYn(r,s)$y0(r,s) = ( sum(g,v_PA(r,g)*id0(r,g,s)) + content(r,s) ) / y0(r,s);
	dev = sum((r,s)$y0(r,s), abs(v_PYn(r,s)-v_PY(r,s)));
	v_PY(r,s) = v_PYn(r,s);
	iter_log(iter,"dev") = dev;
);
display iter_log;
$offecho

$include %gams.scrdir%itersolve
atm(g,"all","all")$x0n(g) = sum(r,x0(r,g)*v_PY(r,g))/x0n(g) - 1$ags(g);
option atm:0;
display atm;

file kcon /con:/; kcon.lw=0; kcon.nw=0; kcon.nd=0; put kcon;

alias (r,rr), (s,ss);
loop(rr,
  putclose '  --  Running ',rr.tl/;
  loop(ss$ags(ss),
	content(r,s) = y0(r,s)$(sameas(r,rr) and sameas(s,ss));
$include %gams.scrdir%itersolve
	atm(g,rr,ss)$x0n(g) = sum(r,x0(r,g)*v_PY(r,g))/x0n(g) - (x0(rr,g)/x0n(g))$content(rr,g);
));

parameter atmchk	Check on adding-up;
atmchk(g)$atm(g,"all","all") = 100 * (sum((rr,ags(ss)),atm(g,rr,ss)) / atm(g,"all","all") - 1);
display atmchk;

parameter	atmtot	Aggregate impacts;
atmtot("state",    g,r) = sum(ags(s),atm(g,r,s));
atmtot("commodity",g,s) = sum(r,atm(g,r,s));
option atmtot:3:0:1;
display atmtot;

$exit

parameter	distrib		Distribution of impacts;
distrib(r,"output") = sum(s,v_PY(r,s)*y0(r,s));
distrib(r,"export") = sum(s,v_PY(r,s)*x0(r,s));
distrib(r,"consum") = sum(g,v_PA(r,g)*cd0(r,g));

$exit



atmval(g,"mcp") = 1000 * (v_PY(g) - 1$ags(g));

option atmval:0:1:1;
display atmval;

$exit

equations	def_PY, def_PI, def_PN, def_PA;

def_PY(r,s)$y0(r,s)..	v_PY(r,s) * y0(r,s) =e= sum(g,v_PA(r,g)*id0(r,g,s)) + content(r,s);

def_PI(r,mrg)..		v_PI(r,mrg)*sum(g,ms0(r,g,mrg))  =e= sum(g,v_PY(r,g)*ms0(r,g,mrg));

def_PN(g)$n0(g)..	v_PN(g)*n0(g) =e= sum(r,v_PY(r,g)*yn0(r,g));

def_PA(r,g)$a0(r,g)..	v_PA(r,g)*a0(r,g) =e= v_PY(r,g)*yd0(r,g) + v_PN(g)*dn0(r,g) + 
					sum(mrg,v_PI(r,mrg)*md0(r,g,mrg));

v_PY.FX(r,g)$(not y0(r,g)) = 0;
v_PA.FX(r,g)$(not a0(r,g)) = 0;
v_PN.FX(g)$(not n0(g)) = 0;

model atmsys /def_PY.v_PY, def_PN.v_PN, def_PI.v_PI, def_PA.v_PA /;

atmsys.solvelink = 5;
content(r,s) = y0(r,s)$ags(s);
solve atmsys using mcp;

$ondotl

atm(g,"all","all")$sum(r,x0(r,g)) = 1000 * (sum(r,x0(r,g)*v_PY(r,g))/sum(r,x0(r,g)) - 1$ags(g));

option atm:0:0:1;
display atm;

$exit



option atm:0;
display atm;

alias (r,rr), (s,ss);;
loop(rr,
	loop(ss$ags(ss),
		content(r,s) = y0(r,s)$(sameas(r,rr) and sameas(s,ss));
		solve atmsys using mcp;
		atm(g,rr,ss)$sum(r,x0(r,g)) = 
		  round(1000 * (sum(r,x0(r,g)*v_PY(r,g))/sum(r,x0(r,g)) - 1$content(rr,ss)));
	);
);

parameter atmchk	Check on adding-up;
atmchk(g) = atm(g,"all","all") - sum((rr,ags(ss)),atm(g,rr,ss));
display atmchk;


$exit


