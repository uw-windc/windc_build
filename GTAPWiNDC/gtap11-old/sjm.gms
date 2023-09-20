variable	OBJ	SJM objective;

parameter	tau_P(%i_P%),tau_PM(%i_PM%),tau_PF(%i_PF%),tau_PS(%i_PS%),tau_PT(%i_PT%);

equation	objdef	Defines OBJ;	

objdef..	OBJ =e=   sum((h_RA,i_P),  P(i_P)   * e(RA,P))	! e:P(i,r),P("g",r),P("i",r),P("i",rnum)
			+ sum((h_RA,i_PM), PM(i_PM) * e(RA,PM))	! e:PM(i,r)
			+ sum((h_RA,i_PF), PF(i_PF) * e(RA,PF))	! e:PF(f,r)

			+ sum(i_P,  P(i_P)   * tau_P(i_P))	! t:rto, t:rtfd
			+ sum(i_PM, PM(i_PM) * tau_PM(i_PM))	! t:rtfi
			+ sum(i_PF, PF(i_PF) * tau_PF(i_PF))	! t:rtf
			+ sum(i_PS, PS(i_PS) * tau_PS(i_PS))	! t:rtf
			+ sum(i_PT, PT(i_PT) * tau_PT(i_PT))	! t:rtxs,rtms

			- sum(r, RA.L(r) * log(P("c",r)));


model gmr_sjm / objdef, profit_Y, profit_M, profit_FT, profit_YT /;

parameter vxm;
vxm(i,r) = sum(rr,vxmd(i,r,rr)) + vst(i,r);
display vxm;

vb(r) = sum(i,vim(i,r) - vxm(i,r) - sum(rr,vxmd(i,r,rr)*(-rtxs(i,r,rr))+(vxmd(i,rr,r)*(1-rtxs(i,rr,r))+sum(j,vtwr(j,i,rr,r)))*rtms(i,rr,r)));
parameter	vbchk;
vbchk = sum(r,vb(r));
display vbchk;

$ontext
$model:gmr_trade

$sectors:
	M(i,r)$vim(i,r)			! Imported inputs
	YT(j)$vtw(j)			! Transportation services

$commodities:
	P(g,r)$(i(g) and vom(g,r))		! Domestic output price
	PM(i,r)$vim(i,r)		! Import price
	PT(j)$vtw(j)			! Transportation services

$consumers:
	RA(r)		! Representative agent


$prod:M(i,r)$vim(i,r)	s:(2*esubdm(i))  rr.tl:0
	o:PM(i,r)	q:vim(i,r)
	i:P(i,rr)	q:vxmd(i,rr,r)	p:pvxmd(i,rr,r) rr.tl:
+		a:RA(rr) t:(-rtxs(i,rr,r)) a:RA(r) t:(rtms(i,rr,r)*(1-rtxs(i,rr,r)))
	i:PT(j)#(rr)	q:vtwr(j,i,rr,r) p:pvtwr(i,rr,r) rr.tl: a:RA(r) t:rtms(i,rr,r)

$prod:YT(j)$vtw(j)  s:1
	o:PT(j)		q:vtw(j)
	i:P(j,r)	q:vst(j,r)

$demand:RA(r)  s:1
	d:PM(i,r)	q:vim(i,r)
	e:P(i,r)	q:vxm(i,r)
	e:P("man","chn")	q:vb(r)

$offtext
$sysinclude mpsgeset gmr_trade

gmr_trade.iterlim = 0;
$include gmr_trade.gen
solve gmr_trade using mcp;

$exit





objaltdef..	OBJ =e= 


objdef.m = 1;
profit_Y.M(j_Y)   = Y.L(j_Y);
profit_M.M(j_M)   = M.L(j_M);
profit_FT.M(j_FT) = FT.L(j_FT);
profit_YT.M(j_YT) = YT.L(j_YT);

*	Bring in the tax adjustment terms:

$ondotl
tau_PF(i_PF) = sum((ij_PF_Y(i_PF,j_Y),h_RA), Y(j_Y)*mu(PF,Y,RA));
tau_PS(i_PS) = sum((ij_PS_Y(i_PS,j_Y),h_RA), Y(j_Y)*mu(PS,Y,RA));
tau_PM(i_PM) = sum((ij_PM_Y(i_PM,j_Y),h_RA), Y(j_Y)*mu(PM,Y,RA));
tau_P(i_P)   = sum((ij_P_Y(i_P,j_Y),h_RA),   Y(j_Y)*mu(P, Y,RA)) 
	   + sum((ij_P_M(i_P,j_M),h_RA),     M(j_M)*mu(P, M,RA));
tau_PT(i_PT) = sum((ij_PT_M(i_PT,j_M),h_RA), M(j_M)*mu(PT,M,RA));

parameter	chk_tau_PF, chk_tau_PS, chk_tau_PM, chk_tau_P, chk_tau_PT;
chk_tau_PF(i_PF(mf,r)) = tau_PF(i_PF) - sum(g, rtf(mf,g,r)*vfm(mf,g,r));
chk_tau_PS(i_PS(sf,g,r)) = tau_PS(i_PS) - rtf(sf,g,r)*vfm(sf,g,r);
chk_tau_PM(i_PM(i,r)) = tau_PM(i_PM) - sum(g,vifm(i,g,r)*rtfi(i,g,r));
chk_tau_P(i_P(i,r)) = tau_P(i_P) - sum(g,vdfm(i,g,r)*rtfd(i,g,r)) - vom(i,r)*rto(i,r) - sum(rr,vxmd(i,r,rr)*(rtms(i,r,rr)*(1-rtxs(i,r,rr))-rtxs(i,r,rr)));
chk_tau_PT(i_PT(j)) = tau_PT(i_PT) - sum((i,r,rr),vtwr(j,i,r,rr)*rtms(i,r,rr));
display chk_tau_PF, chk_tau_PS, chk_tau_PM, chk_tau_P, chk_tau_PT;

OBJ.L =	  sum((i_P,h_RA),  P(i_P)   * e(RA,P))	! e:P(i,r),P("g",r),P("i",r),P("i",rnum)
	+ sum((i_PM,h_RA), PM(i_PM) * e(RA,PM))	! e:PM(i,r)
	+ sum((i_PF,h_RA), PF(i_PF) * e(RA,PF))	! e:PF(f,r)

	+ sum(i_P,  P(i_P)   * tau_P(i_P))
	+ sum(i_PM, PM(i_PM) * tau_PM(i_PM))
	+ sum(i_PF, PF(i_PF) * tau_PF(i_PF))
	+ sum(i_PS, PS(i_PS) * tau_PS(i_PS))
	+ sum(i_PT, PT(i_PT) * tau_PT(i_PT))  
	- sum(r, RA.L(r) * log(P("c",r)));

parameter pmchk(i,r,*);
pmchk(i_PM(i,r),"M") = sum(j_M(i,r), a(PM,M));
pmchk(i_PM(i,r),"Y") = sum(j_Y(g,r), a(PM,Y));
pmchk(i_PM(i,r),"E") = sum(h_RA(r), e(RA,PM));
pmchk(i_PM(i,r),"MU_Y") = sum((j_Y(g,r),h_RA(r)), mu_PM_Y_RA(i_PM,j_Y,h_RA));
pmchk(i_PM(i,r),"MU(PM,Y,RA)") = sum((j_Y(g,r),h_RA(r)), mu(PM,Y,RA));
pmchk(i_PM(i,r),"TAU_PM") = tau_PM(i_PM);
pmchk(i_PM(i,r),"chk") = pmchk(i_PM,"M") + pmchk(i_PM,"Y") + pmchk(i_PM,"E");
option pmchk:3:2:1;
display pmchk; 

parameter	achk;
achk(i_PM("col","chn"),j_Y) = a(PM,Y);
option achk:3:0:1;
display achk;

P.LO(g,r) = 1e-5;
PM.LO(i,r) = 1e-5;
PT.LO(j) = 1e-5;
PF.LO(f,r) = 1e-5;
PS.LO(f,g,r) = 1e-5;

P.M(g,r) = 0;
PM.M(i,r) = 0;
PT.M(j) = 0;
PF.M(f,r) = 0;
PS.M(f,g,r) = 0;

*.option nlp=ipopt;
option limrow=10000, limcol=10000;

option nlp=examiner; 

gmr_sjm.optfile = yes;

$onecho >examiner.opt
dumpSoluPoint    true
examineInitpoint true
returnInitPoint  true
$offecho

solve gmr_sjm using nlp minimizing OBJ;
	
$exit
option nlp=examiner; 

gmr_sjm.optfile = yes;

$onecho >examiner.opt
dumpSoluPoint    true
examineInitpoint true
returnInitPoint  true
$offecho


gmr_sjm.optfile = no;

option nlp=conopt;
solve gmr_sjm using nlp minimizing OBJ;

tau_P(i_P(i,r)) = rto(i,r)*vom(i,r)*Y.L(i,r) + sum(g$vom(g,r),rtfd(i,g,r)*DDFM(i,g,r)*Y.L(g,r)) 
		+ sum(rr$vxmd(i,r,rr), DXMD(i,r,rr)*M(i,rr) * 
			(-rtxs(i,r,rr) + rtms(i,r,rr)*(1-rtxs(i,r,rr))));

tau_PM(i_PM(i,r)) = sum(g$vom(g,r), rtfi(i,g,r)*DIFM(i,g,r)*Y(g,r));

tau_PF(i_PF(mf,r)) = sum(g$vom(g,r), rtf(mf,g,r)*DFM(mf,g,r)*Y(g,r));
tau_PS(i_PS(sf,g,r))$vom(g,r) = rtf(sf,g,r)*DFM(sf,g,r)*Y(g,r);
tau_PT(i_PT(j)) = sum((i,r,rr)$vtwr(j,i,r,rr), rtms(i,r,rr)*DTWR(j,i,r,rr)*M(i,rr));


tau_P(i_P) =      sum((ij_P_Y(i_P,j_Y),h_RA), Y(j_Y)*mu(P,Y,RA)) 
		+ sum((ij_P_M(i_P,j_M),h_RA), M(j_M)*mu(P,M,RA));

tau_PM(i_PM) =    sum((ij_PM_Y(i_PM,j_Y),h_RA), Y(j_Y)*mu(PM,Y,RA));

tau_PT(i_PT) = sum((ij_PT_M(i_PT,j_M),h_RA), M(j_M)*mu(PT,M,RA));


parameter	pfmchk(f,r)	"Cross check on PF.M";
pfmchk(i_PF(mf(f),r)) = sum(j_Y(g,r), -a(PF,Y)  * (1+rtf(f,g,r)) * Y(g,r)) 
			- sum(h_RA, e(RA,PF)) - sum(j_Y(g,r),vfm(f,g,r)*rtf(f,g,r));
display pfmchk;

parameter pfchk;
pfchk(i_PF(f,r),"FT") = sum(j_FT(sf(f),r), a(PF,FT) * FT(sf,r));
pfchk(i_PF(f,r),"Y")  = sum(j_Y(g,r),      a(PF,Y)  * Y(g,r));
pfchk(i_PF(f,r),"Y*") = sum(j_Y(g,r),      a(PF,Y)  * (1+rtf(f,g,r)) * Y(g,r));
pfchk(i_PF(f,r),"PF.M") = PF.M(i_PF);
pfchk(i_PF(f,r),"rtf*") = sum(j_Y(g,r),      a(PF,Y)  * rtf(f,g,r) * Y(g,r));
pfchk(i_PF(f,r),"RA") = sum(h_RA(r),       e(RA,PF));
pfchk(i_PF(f,r),"chk") = pfchk(f,r,"FT") + pfchk(f,r,"Y") + pfchk(f,r,"RA");

PM.FX(i_PM) = PM.L(i_PM);
PF.FX(i_PF) = PF.L(i_PF);
P.FX(i_P) = P.L(i_P);
PS.FX(i_PS) = PS.L(i_PS);
model gradient /objdef/;
option nlp=conopt;
solve gradient using nlp maximizing OBJ;

pfchk(i_PF(f,r),"dev") = sum(j_Y(g,r), -   a(PF,Y)  * (1+rtf(f,g,r)) * Y(g,r)) - PF.M(i_PF);

option pfchk:3:2:1;
display pfchk;

$exit


market_PF(i_PF(f,r))..
	  sum(j_FT(sf(f),r), a(PF,FT) * FT(sf,r)) ! $prod:FT(sf,r)  -- i:PF(sf,r)
	+ sum(j_Y(g,r),      a(PF,Y)  * Y(g,r))	  ! $prod:Y(g,r) -- i:PF(mf,r)
	+ sum(h_RA(r),       e(RA,PF))		  ! $demand:RA(r) -- e:PF(r,f)


parameter	chk;
chk(i_P,"Y") = sum(j_Y,    a(P,Y)  * Y(j_Y));
chk(i_P,"M") = sum(j_M,	   a(P,M)  * M(j_M));
chk(i_P,"YT") = sum(j_YT,  a(P,YT) * YT(j_YT));
chk(i_P,"d") =  sum(h_RA,  d(P,RA));
chk(i_P,"e") =  sum(h_RA,  e(RA,P));
chk(i_P,"chk") = chk(i_P,"Y") + chk(i_P,"M") + chk(i_P,"YT") - chk(i_P,"d") + chk(i_P,"e");
option chk:3:2:1;
display chk; 

set i_Pchk(i,r)/ser.usa/;

parameter	a_Y, a_M, a_YT, d_RA, e_RA;
a_Y(j_Y) = sum(i_P(i_Pchk),a(P,Y));
a_M(j_M) = sum(i_P(i_Pchk),a(P,M));
a_YT(j_YT) = sum(i_P(i_Pchk),a(P,YT));
d_RA(h_RA) = sum(i_P(i_Pchk),d(P,RA));
e_RA(h_RA) = sum(i_P(i_Pchk),e(RA,P));
option a_Y:3:0:1, a_M:3:0:1, a_YT:3:0:1, d_RA:3:0:1, e_RA:3:0:1;
display a_Y, a_M, a_YT, d_RA, e_RA;