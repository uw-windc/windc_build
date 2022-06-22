$title	 Calibrate the CDE Demand Systems

$if not set threads $set threads 1
option threadsAsync=%threads%;
$if not %threads%==1 option limrow=0, limcol=0, solprint=off;

$if not set gtapv $set gtapv 10
$if not set yr $set yr 11

$if not set ds $set ds gtapingams
$include "%system.fp%gtapdata"

alias (r,rr), (i,k);

$if not set rcalib  $set rcalib set.r
set	rcalib(r)	Regions to solve /%rcalib%/;

file	ktitle; ktitle.lw=0; ktitle.nw=0; ktitle.nd=0;

thetac(i,r) = (vdfm(i,"c",r)*(1+rtfd(i,"c",r)) + vifm(i,"c",r)*(1+rtfi(i,"c",r))) /
	 sum(j,vdfm(j,"c",r)*(1+rtfd(j,"c",r)) + vifm(j,"c",r)*(1+rtfi(j,"c",r)));

parameter	sigma(i,r)	Effective CES elasticity of substitution;
sigma(i,r) = -epsilon(i,r)/(1-thetac(i,r))
display sigma;

parameter	sigmaave(r)	Average effective CES elasticity;
sigmaave(r) = -sum(i, thetac(i,r)*epsilon(i,r)/(1-thetac(i,r)));
display sigmaave;

set	rb(r)	Region to balance;

variables
	OBJ		Objective function (necessary share minimization),

	INCPARV(i,r)	Expansion coefficient,
	SUBPARV(i,r)	Share coefficient, 

	EPSILONV(i,r)	Calibrated own-price elasticity of demand,
	ETAV(i,r)	Calibrated income elasticity of demand;

equations	objcde, epsilondef, etadef;

objcde..
	OBJ =e= sum((i,rb(r))$thetac(i,r), thetac(i,r) * 
			(sqr(EPSILONV(i,r) - epsilon(i,r))) + 
			 sqr(ETAV(i,r)     - eta(i,r)) +
			 sqr(INCPARV(i,r) - incpar(i,r)));

epsilondef(i,rb(r))$thetac(i,r)..
	EPSILONV(i,r) =e= -SUBPARV(i,r) * sqr(1-thetac(i,r))
		- thetac(i,r)*sum(k,thetac(k,r)*SUBPARV(k,r))
		+ sqr(thetac(i,r))*SUBPARV(i,r);


etadef(i,rb(r))$thetac(i,r)..
	ETAV(i,r) =e= 
		(INCPARV(i,r)*(1-SUBPARV(i,r)) + 
		 sum(k,thetac(k,r)*INCPARV(k,r)*SUBPARV(k,r))) / 
			sum(k,thetac(k,r)*INCPARV(k,r)) 
		+ (SUBPARV(i,r) - sum(k,thetac(k,r)*SUBPARV(k,r)));

model cdecalib /objcde, epsilondef, etadef/;

SUBPARV.UP(i,r) = 0.999;
SUBPARV.LO(i,r) = 0.0001;
INCPARV.LO(i,rr)  = 0;

EPSILONV.L(i,rr) = epsilon(i,rr);
ETAV.L(i,rr)     = eta(i,rr);
SUBPARV.L(i,rr)  = subpar(i,rr);
INCPARV.L(i,rr)  = incpar(i,rr);

parameter	handle(r)	Pointer for grid solution
		cdelog		Log of CDE calibration results,
		cdecompare	Comparison of target and realized elasticities;

set		submit(r)	List of regions to submit,
		done(r)		List of regions which are completed;

$ifthen.cde_threads %threads%==1
  done(r) = no;
  loop(rr,
	rb(r) = yes$sameas(r,rr);

	cdecalib.solvelink = 2;
	option nlp = ipopt;
	solve cdecalib using nlp minimizing OBJ;

	cdelog(rr,"modelstat") = cdecalib.modelstat;
	cdelog(rr,"solvestat") = cdecalib.solvestat;
	cdelog(rr,"OBJ.L") = OBJ.L;
	cdelog(rr,"ndev(epsilon)") = 
		sum(i$thetac(i,rr),1$round(EPSILONV.L(i,rr)-epsilon(i,rr),2));
	cdelog(rr,"ndev(eta)") = 
		sum(i$thetac(i,rr),1$round(ETAV.L(i,rr)-eta(i,rr),2));

	loop((i,rb(r))$thetac(i,r),
	  cdecompare(i,r,"1","epsilonv") = EPSILONV.L(i,r);
	  cdecompare(i,r,"1","epsilon")  = epsilon(i,r);
	  cdecompare(i,r,"2","etav")     = ETAV.L(i,r);
	  cdecompare(i,r,"2","eta")	 = eta(i,r);
	  cdecompare(i,r,"3","subparv")  = SUBPARV.L(i,r);
	  cdecompare(i,r,"3","subpar")   = subpar(i,r);
	  cdecompare(i,r,"4","incparv")  = INCPARV.L(i,r);
	  cdecompare(i,r,"4","incpar")   = incpar(i,r);     ));

$else.cde_threads

	cdecalib.solvelink = %solvelink.AsyncThreads%;
	done(r) = no;
	handle(r) = 0;
	repeat
	  submit(r) = no;
	  loop(r$(not (done(r) or handle(r))),
	    submit(r) = yes$(card(submit)+card(handle)<%threads%););
	  loop(submit(rr),
	    rb(r) = yes$sameas(r,rr);
	    solve cdecalib using nlp minimizing OBJ;
	    handle(rr) = cdecalib.handle;);
	  put_utility 'title'/ktitle 'CDE calibration.  Finished: ',card(done),', remaining: ',
		(card(r)-card(done)),', running: ',card(handle),'.';
	  display$ReadyCollect(handle) 'Waiting for next instance to collect';
	  loop(rr$handlecollect(handle(rr)),

	    cdelog(rr,"modelstat") = cdecalib.modelstat;
	    cdelog(rr,"solvestat") = cdecalib.solvestat;
	    cdelog(rr,"OBJ.L") = OBJ.L;
	    cdelog(rr,"ndev(epsilon)") = sum(i$thetac(i,rr),1$round(EPSILONV.L(i,rr)-epsilon(i,rr),2));
	    cdelog(rr,"ndev(eta)") = sum(i$thetac(i,rr),1$round(ETAV.L(i,rr)-eta(i,rr),2));

	    rb(r) = yes$sameas(r,rr);
	    loop((i,rb(r))$thetac(i,r),
	      cdecompare(i,r,"1","epsilonv") = EPSILONV.L(i,r);
	      cdecompare(i,r,"1","epsilon")  = epsilon(i,r);
	      cdecompare(i,r,"2","etav")     = ETAV.L(i,r);
	      cdecompare(i,r,"2","eta")	    = eta(i,r);
	      cdecompare(i,r,"3","subparv")  = SUBPARV.L(i,r);
	      cdecompare(i,r,"3","subpar")   = subpar(i,r);
	      cdecompare(i,r,"4","incparv")  = INCPARV.L(i,r);
	      cdecompare(i,r,"4","incpar")   = incpar(i,r););

	    display$handledelete(handle(rr)) 'trouble deleting handles' ;
	    handle(rr) = 0;
	    done(rr) = yes;);

	until (card(done)=card(r)) or timeelapsed > 300;  
	abort$(card(done)<>card(r)) 'CDECALIB jobs did not return:', handle;
$endif.cde_threads

*	Respecify income and price elasticities in case these have
*	been changed because the calibration is inexact:

$ifthen.respecify set respecify

thetac(i,r) = (vdfm(i,"c",r)*(1+rtfd(i,"c",r)) + vifm(i,"c",r)*(1+rtfi(i,"c",r))) /
	 sum(j,vdfm(j,"c",r)*(1+rtfd(j,"c",r)) + vifm(j,"c",r)*(1+rtfi(j,"c",r)));

eta(i,r)$(not thetac(i,r)) = 0;
eta(i,r)$thetac(i,r) = subpar(i,r) - sum(k,thetac(k,r)*subpar(k,r)) + 
	(incpar(i,r)*(1-subpar(i,r)) + sum(k,thetac(k,r)*incpar(k,r)*subpar(k,r))) / 
	sum(k,thetac(k,r)*incpar(k,r));

aues(i,j,r)$(not (thetac(i,r) and thetac(j,r))) = 0;
aues(i,j,r)$(thetac(i,r) and thetac(j,r)) = subpar(i,r) + subpar(j,r) 
		- sum(k,thetac(k,r)*subpar(k,r))
		- (subpar(i,r)/thetac(i,r))$sameas(i,j);
$endif.respecify

metadata("cdecalib%system.time%","date","%system.date%") = yes;
metadata("cdecalib%system.time%","filesys","%system.filesys%") = yes;
metadata("cdecalib%system.time%","username","%system.username%") = yes;
metadata("cdecalib%system.time%","computername","%system.computername%") = yes;
metadata("cdecalib%system.time%","gamsversion","%system.gamsversion%") = yes;
*metadata("cdecalib%system.time%","program","%system.fp%%system.fn%%system.fe%")   = yes;
metadata("cdecalib%system.time%","dataset","%datadir%%ds%.gdx") = yes;
option metadata:0:0:1;
display metadata;

execute_unload '%datadir%%ds%.gdx',      
	r, f, g, i, vfm, vdfm, vifm, vxmd, vst, vtwr, vtrev,
	rto, rtf, rtfd, rtfi, rtxs, rtms, esubt, esubd, esubva, esubm, etrae, 
	eta, aues,  incpar, subpar,
	pop, evd, evi, evt, eco2d, eco2i, forecast, metadata;

option cdelog:0:1:1;
option cdecompare:3:2:2;
display cdecompare, cdelog;

set number /1*4/;
alias (u,*);
cdecompare(i,r,number,u)$(not round(
			  abs(cdecompare(i,r,"1","epsilonv") -
			      cdecompare(i,r,"1","epsilon")) +
			  abs(cdecompare(i,r,"2","etav") -
			      cdecompare(i,r,"2","eta")), 4)) = 0;
display cdecompare;
