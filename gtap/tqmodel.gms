$title	Tariff Quota Simulations with the GTAP-WiNDC Model

$if not set ds $set ds gtap_10_cps_2014

set	dsets	Recognized datasets /
			gtap_32_cps_2014,
			gtap_32_soi_2014,
			gtap_10_cps_2014,
			gtap_10_soi_2014 /;

set	ds(dsets)	Cross check that the dataset is recognized /%ds%/;

$include gtapwindc_data

singleton set	pmt(i) /
$if %ds%==gtap_32_cps_2014	pmt
$if %ds%==gtap_32_soi_2014	pmt
$if %ds%==gtap_10_cps_2014	eis
$if %ds%==gtap_10_soi_2014	eis
	/, usa(r) /usa/;


*	-------------------------------------------------------------------------------------------------
*	Read the policy assumptions:

set	r232(r)	Trading partners covered by 232 tariff /chn,eur,oec,row/;

set	col		Input data /
	"2014 tariff *"		  Informational column
	"232 tariff"		    Tariff applied in previous administration
	"capital"		        Capital stock multiplier
	"quota"			        Quota target
	"in quota tariff"	  In-quota tariff rate
	"out quota tariff"	Out-quota tariff rate /;

parameter	policy(r232,col)	Policy assumptions;

$IFTHENI %system.filesys% == UNIX 
$call 'csv2gdx i=policy.csv o=%gams.scrdir%policy.gdx id=policy index=1 values=2..lastCol useHeader=y'
$ELSE 
$call 'gdxxrw i=tqmodel.xlsx o=%gams.scrdir%policy.gdx par=policy rng=policy rdim=1 cdim=1 checkdate'
$ENDIF

$gdxin %gams.scrdir%policy.gdx


*	Read input data table with domain checking:

$loaddc policy
$gdxin
*	-------------------------------------------------------------------------------------------------


*	-------------------------------------------------------------------------------
*	Logic for the tariff-quota model starts here.
*	-------------------------------------------------------------------------------

parameter	vmcif(i,rr,r)	Value of imports CIF (gross of tariff and transport cost);
vmcif(i,rr,r) = 0;

set	
  q	            Quota levels /	in	"In-quota trade",
				                        out	"Out-quota trade" /,

	b_(i,rr,r,q)	Bilateral flows with tariff-quotas;

b_(i,rr,r,q) = no;

parameter	
    rtms_q(i,rr,r,q)	Import tariff rates,
		quota(i,rr,r,q)		Permissible quota,
		esub_pmt		Elasticity structure for PMT,
		vxmd0(r,rr)		Benchmark trade in PMT ($),
		s_vfm(f,g,r,s)		Factor supply multiplier;

quota(i,rr,r,q) = 0;
rtms_q(i,rr,r,q) = 0;

esub_pmt("m") = esubm(pmt);
esub_pmt("dm") = esubdm(pmt);
esub_pmt("nm") = 2*esubdm(pmt);
esub_pmt("etrndn") = etrndn(pmt);
vxmd0(r,rr) = vxmd(pmt,r,rr);
s_vfm(sf,g,r,s) = 1;
display esub_pmt, vxmd0;


$ontext
$model:gtapwindc

$sectors:
	Y(g,r,s)$y_(g,r,s)		    ! Production (includes I and G)
	C(r,s,h)$c_(r,s,h)		    ! Consumption 
	X(i,r,s)$x_(i,r,s)		    ! Disposition
	Z(i,r,s)$z_(i,r,s)		    ! Armington demand
	FT(f,r,s)$ft_(f,r,s)		  ! Specific factor transformation
	M(i,r)$m_(i,r)			      ! Import
	YT(j)$yt_(j)			        ! Transport

*	Added activity represents quota-constrained trade flows:

	B(i,rr,r,q)$b_(i,rr,r,q)	! Bilateral export (for quota constrained trade)

$commodities:
	PY(g,r,s)$py_(g,r,s)		  ! Output price
	PZ(i,r,s)$pz_(i,r,s)		  ! Armington composite price
	PD(i,r,s)$pd_(i,r,s)		  ! Local goods price
	P(i,r)$p_(i,r)			      ! National goods price
	PC(r,s,h)$pc_(r,s,h)		  ! Consumption price 
	PF(f,r,s)$pf_(f,r,s)		  ! Primary factors rent
	PS(f,g,r,s)$ps_(f,g,r,s)	! Sector-specific primary factors
	PM(i,r)$pm_(i,r)		      ! Import price
	PT(j)$pt_(j)			        ! Transportation services

*	New markets added to represent tariff quotas and explicit bilateral trade flows:

	PB(i,rr,r)$vmcif(i,rr,r)	    ! Bilateral export price
	PQ(i,rr,r,q)$quota(i,rr,r,q)	! Quota rent on bilateral trade

$consumers:
	RH(r,s,h)$rh_(r,s,h)		      ! Representative household
	GOVT(r)				                ! Public expenditure
	INV(r)				                ! Investment

$prod:Y(g,r,s)$y_(g,r,s) s:0  va:esubva(g) 
	o:PY(g,r,s)	q:vom(g,r,s)				a:GOVT(r) t:rto(g,r)
	i:PZ(i,r,s)	q:vafm(i,g,r,s)	
	i:PS(sf,g,r,s)	q:vfm(sf,g,r,s)	p:(1+rtf0(sf,g,r))    va: a:GOVT(r) t:rtf(sf,g,r)
	i:PF(mf,r,s)	  q:vfm(mf,g,r,s)	p:(1+rtf0(mf,g,r))    va: a:GOVT(r) t:rtf(mf,g,r)

$prod:X(i,r,s)$x_(i,r,s)  t:etrndn(i)
	o:P(i,r)	  q:xn0(i,r,s)
	o:PD(i,r,s)	q:xd0(i,r,s)
	i:PY(i,r,s)	q:vom(i,r,s)

$prod:Z(i,r,s)$z_(i,r,s)  s:esubdm(i)  nm:(2*esubdm(i))
	o:PZ(i,r,s)	q:a0(i,r,s)
	i:PD(i,r,s)	q:xd0(i,r,s)	a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s)) nm:
	i:P(i,r)	q:nd0(i,r,s)	  a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s)) nm:
	i:PM(i,r)	q:md0(i,r,s)	  a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s)) 

$report:
	v:MZ(i,r,s)$md0(i,r,s)	i:PM(i,r)	prod:Z(i,r,s)

$prod:C(r,s,h)$c_(r,s,h)  s:1
	o:PC(r,s,h)	q:c0(r,s,h)	
	i:PZ(i,r,s)	q:cd0(i,r,s,h)  

$prod:FT(sf,r,s)$ft_(sf,r,s)  t:etrae(sf)
	o:PS(sf,g,r,s)	q:(vfm(sf,g,r,s)*s_vfm(sf,g,r,s))
	i:PF(sf,r,s)	  q:evom(sf,r,s)

$prod:M(i,r)$m_(i,r)	s:esubm(i)   rr.tl:0
	o:PM(i,r)	q:vim(i,r)

*	Standard GTAPinGAMS specification with bilateral trade flows represented
*	by price-responsive demand (no additional dimensions are required):

	i:P(i,rr)$(not vmcif(i,rr,r))	q:vxmd(i,rr,r)	p:pvxmd(i,rr,r) rr.tl:
+		a:GOVT(rr) t:(-rtxs(i,rr,r)) 
+		a:GOVT(r)  t:(rtms(i,rr,r)*(1-rtxs(i,rr,r)))
	i:PT(j)#(rr) q:(vtwr(j,i,rr,r)$(not vmcif(i,rr,r))) p:pvtwr(i,rr,r) rr.tl:
+		a:GOVT(r)  t:rtms(i,rr,r)

*	We need a separate price for bilateral flows which are subject to tariff-quota:

	i:PB(i,rr,r)	q:vmcif(i,rr,r)

$report:
	v:BM(i,rr,r)$(m_(i,r) and vxmd(i,rr,r) and (not vmcif(i,rr,r)))	i:P(i,rr) prod:M(i,r)

*	Bilateral trade flow:

$prod:B(i,rr,r,q)$b_(i,rr,r,q)  s:0
	o:PB(i,rr,r)	q:vmcif(i,rr,r)
	i:P(i,rr)	q:vxmd(i,rr,r)	p:pvxmd(i,rr,r)
+		a:GOVT(rr) t:(-rtxs(i,rr,r))	
+		a:GOVT(r)  t:(rtms_q(i,rr,r,q)*(1-rtxs(i,rr,r)))
	i:PT(j)		q:vtwr(j,i,rr,r) p:pvtwr(i,rr,r)
+		a:GOVT(r)  t:rtms_q(i,rr,r,q)
	i:PQ(i,rr,r,q)$quota(i,rr,r,q)	q:vxmd(i,rr,r)

$prod:YT(j)$yt_(j)  s:1
	o:PT(j)		q:vtw(j)
	i:P(j,r)	q:vst(j,r)

*	---------------------------------------------------------------------------
*	Final demand -- these based on data coming from the WiNDC database:

$demand:RH(r,s,h)$rh_(r,s,h)  
	d:PC(r,s,h)	q:c0(r,s,h)
	e:PF(f,r,s)	q:evomh(f,r,s,h)
	e:PC(r,s,h)	q:(-htax0(r,s,h))
	e:PC(r,s,h)	q:(-hsav0(r,s,h))

$demand:GOVT(r)
	d:PY("g",r,s)	q:vom("g",r,s)
	e:PC(r,s,h)	q:htax0(r,s,h)
	e:PQ(i,r,rr,q)	q:quota(i,r,rr,q)

$demand:INV(r)
	d:PY("i",r,s)			q:vom("i",r,s)
	e:PC(r,s,h)			  q:hsav0(r,s,h)
	e:PC(rnum,"rest","rest")	q:vb(r)

$offtext
$sysinclude mpsgeset gtapwindc

*	Set up a short-run model:

*	i. Capital is sector-specific and not mobile

sf("cap") = yes;
mf("cap") = no;

*	ii. We have a sector specific price for capital when it enters
*	production.

ps_(f,g,r,s) = vfm(f,g,r,s)$sf(f);

*	iii. Need a factor allocation activity for all sector-specific factors:

ft_(f,r,s) = evom(f,r,s)$sf(f);

*	iv. Elasticity of transformation is zero for capital:

etrae("cap") = 0;

*	v. Capital supply is at benchmark level for all specific factors:

s_vfm(sf,g,r,s) = 1$vfm(sf,g,r,s);

set		itm		Items to report /
			y	Production,
			z	Absorption,
			m	Imports,
			c	Consumption (welfare)
			pf	Factor price /;

set		fmt		Format of the pivot report item /
			".L"	    Level value,
			"$"	      Real value,
			"%_bmk"	  Percentage change from 2014 benchmark,
			"%_232"	  Percentage change from post-232 equilibrium,
			"$d_bmk" Change in $ from 2014 benchmark,
			"$d_232" Change in $ from post-232 equilibrium/;

set		scn		Scenarios /	
			bmk	Benchmark equilibrium
			232	Post 232 steel tariffs
			exp	Expansion of PMT capacity
			tq	232 tariff replaced by a tariff quota /;

*	The third dimnsion will cover sectors and primary factors.  Create an
*	alias to the universe to represent these UELs:
alias (u,*);

parameter	
    pivotdata(scn,itm,u,r,s,fmt)	Pivot report,
		trade(scn,r,rr,fmt)		        PMT trade flows,
		pnum				                  Numeraire price index;

$onechov >%gams.scrdir%report.gms
trade(%1,rr,r,"$")$(m_(pmt,r) and vxmd(pmt,rr,r) and (not vmcif(pmt,rr,r))) = BM.L(pmt,rr,r);
trade(%1,rr,r,"$")$vmcif(pmt,rr,r) = sum(b_(pmt,rr,r,q),B.L(pmt,rr,r,q)*vxmd(pmt,rr,r));

pivotdata(%1,"Y",g,r,s,".L")$y_(g,r,s) = Y.L(g,r,s);
pivotdata(%1,"Y",g,r,s,"$")$y_(g,r,s) = Y.L(g,r,s)*vom(g,r,s);
pivotdata(%1,"Z",i,r,s,".L")$z_(i,r,s) = Z.L(i,r,s);
pivotdata(%1,"Z",i,r,s,"$")$z_(i,r,s) = Z.L(i,r,s)*a0(i,r,s);
pivotdata(%1,"M",i,r,s,".L")$md0(i,r,s) = MZ.L(i,r,s)/md0(i,r,s);
pivotdata(%1,"M",i,r,s,"$")$m_(i,r) = MZ.L(i,r,s);
pivotdata(%1,"C",h,r,s,".L")$rh_(r,s,h) = C.L(r,s,h);
pivotdata(%1,"C",h,r,s,"$")$rh_(r,s,h) = C.L(r,s,h)*c0(r,s,h);

*	Numeraire price index:

pnum(r,s)$sum(h,c0(r,s,h)) = sum(h, PC.L(r,s,h)*c0(r,s,h))/sum(h,c0(r,s,h));

*	Real factor prices:

pivotdata(%1,"PF",f,r,s,".L")$pnum(r,s) = PF.L(f,r,s)/pnum(r,s);
pivotdata(%1,"PF",f,r,s,"$")$pnum(r,s) = PF.L(f,r,s)/pnum(r,s)*evom(f,r,s);
$offecho

*	Verify that we have a handshake on the benchmark dataset:

gtapwindc.workspace = 1024;
gtapwindc.iterlim = 0;
$include gtapwindc.gen
solve gtapwindc using mcp;

abort$round(gtapwindc.objval,2) "Fail to replicate the benchmark.";

*	Generate a report of the benchmark replication:

$batinclude %gams.scrdir%report '"bmk"'

*	Generate an "echo-print" of benchmark tariff rates on PMT:

parameter	rtms232(r,rr)	Benchmark tariffs on PMT (%);
rtms232(r,rr) = round(rtms(pmt,r,rr) * 100);
option rtms232:0;
display rtms232;

*	Apply the 232 tariff:

rtms(pmt,r232(r),usa) = policy(r232,"232 tariff");

*	Generate a savepoint file so that the program can be reruns quickly:

gtapwindc.savepoint = 1;
$if exist '232_p.gdx' execute_loadpoint '232_p.gdx';

*	Avoid numerical issues with convergence:

$echo	convergence_tolerance 5e-5	>path.opt
gtapwindc.optfile = 1;

gtapwindc.iterlim = 100000;
$include gtapwindc.gen
solve gtapwindc using mcp;

execute "mv -f gtapwindc_p.gdx 232_p.gdx";

$batinclude %gams.scrdir%report '"232"'

*	Replicate with bilateral trade:

*	Add the in-quota bilateral trade activities:

b_(pmt(i),r232(rr),usa(r),"in") = yes$vxmd(i,rr,r);

*	Calculate the value of benchmark imports CIF:

vmcif(pmt(i),r232(rr), usa(r)) = 
	vxmd(i,rr,r)*pvxmd(i,rr,r) + sum(j,vtwr(j,i,rr,r)*pvtwr(i,rr,r));

*	Assign bilateral trade activity level based on the previous GTAP model solution:

B.L(pmt(i),r232(rr),usa(r),"in")$vxmd(i,rr,r) = BM.L(i,rr,r)/vxmd(i,rr,r);

*	We are doing a benchmark replication so the in-quota tariff rate is simply
*	equal to the GTAP rate of protection:

rtms_q(b_(i,rr,r,"in")) = rtms(i,rr,r);

*	Assign the CIF price index based on the GTAP benchmark:

PB.L(pmt(i),r232(rr),usa(r)) = 
	( vxmd(i,rr,r)*P.L(i,rr)*(1-rtxs(i,rr,r))*(1+rtms(i,rr,r)) +
	  sum(j, PT.L(j)*vtwr(j,i,rr,r)*(1+rtms(i,rr,r))) )/ vmcif(i,rr,r);

gtapwindc.savepoint = 0;
gtapwindc.iterlim = 0;
$include gtapwindc.gen
solve gtapwindc using mcp;
abort$round(gtapwindc.objval,3) "Fail to provide precise handshake.";

*	The model appears to be operational.  Move forward to scenarios.

*	Calculate an equilibrium in which PMT capacity is expanded:

s_vfm("cap",pmt,r232,s) = policy(r232,"capital");

gtapwindc.iterlim = 1000;
gtapwindc.savepoint = 1;

$if exist 'exp_p.gdx' execute_loadpoint 'exp_p.gdx';

$include gtapwindc.gen
solve gtapwindc using mcp;
execute "mv -f gtapwindc_p.gdx exp_p.gdx";

*	Generate a report for the scenario with expansion of capital stocks:

$batinclude %gams.scrdir%report '"exp"'

*	Then apply a tariff quota on exports of PMT to the USA:

b_(pmt,r232,usa,"out") = yes;

*	The pre-232 tariff applies for up to a 10% increase in exports, and 
*	the 25% tariff applies on out-of-quota imports:

quota(pmt,r232,usa,"in") = policy(r232,"quota");

rtms_q(pmt,r232,usa,"in") = policy(r232,"in quota tariff");
rtms_q(pmt,r232,usa,"out") = policy(r232,"out quota tariff");

$if exist 'tq_p.gdx' execute_loadpoint 'tq_p.gdx';

$include gtapwindc.gen
solve gtapwindc using mcp;

*	Generate a report for the scenario with tariff quota:

execute "mv -f gtapwindc_p.gdx tq_p.gdx";

$batinclude %gams.scrdir%report '"tq"'

*	Report results in a few more formats:

pivotdata(scn,itm,u,r,s,"%_bmk")$pivotdata("bmk",itm,u,r,s,"$")
	= 100 * (pivotdata(scn,itm,u,r,s,"$")/pivotdata("bmk",itm,u,r,s,"$")-1);

pivotdata(scn,itm,u,r,s,"%_232")$pivotdata("232",itm,u,r,s,"$")
	= 100 * (pivotdata(scn,itm,u,r,s,"$")/pivotdata("232",itm,u,r,s,"$")-1);

pivotdata(scn,itm,u,r,s,"$d_bmk")$pivotdata(scn,itm,u,r,s,"$") 
	= pivotdata(scn,itm,u,r,s,"$") - pivotdata("bmk",itm,u,r,s,"$");

pivotdata(scn,itm,u,r,s,"$d_232")$pivotdata(scn,itm,u,r,s,"$") 
	= pivotdata(scn,itm,u,r,s,"$") - pivotdata("232",itm,u,r,s,"$");

trade(scn,rr,r,"%_bmk")$trade("bmk",rr,r,"$")
	= 100 * (trade(scn,rr,r,"$")/trade("bmk",rr,r,"$")-1);

trade(scn,rr,r,"%_232")$trade("232",rr,r,"$")
	= 100 * (trade(scn,rr,r,"$")/trade("232",rr,r,"$")-1);

trade(scn,rr,r,"$d_bmk")$trade("bmk",rr,r,"$")
	= trade(scn,rr,r,"$") - trade("bmk",rr,r,"$");

trade(scn,rr,r,"$d_232")$trade("232",rr,r,"$")
	= trade(scn,rr,r,"$") - trade("232",rr,r,"$");

*	The following display statement makes for a big listing file:
*.option pivotdata:3:0:1;
*.display pivotdata;

execute_unload 'pivotreport.gdx', pivotdata, trade;

$IFTHENI %system.filesys% == MSNT
execute 'gdxxrw i=pivotreport.gdx o=tqmodel.xlsx par=pivotdata rng=PivotData!a2 cdim=0 par=trade rng=trade!a2 cdim=0' ;
$ENDIF




