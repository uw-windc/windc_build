$if not set threads $set threads 8

$if not set gtapv  $set gtapv  10
$if not set yr	   $set yr     11
$if not set ds	   $set ds     gtapingams
$if not set output $set output gtapingams_rto

$set rto d:\gtap10\gamsdata\gtap9\2011\gtapingams.gdx


file ktitle; ktitle.lw=0; ktitle.nd=0; ktitle.nw=0;

$include "%system.fp%gtapdata"

parameter	vtmd(i,r,s)	Aggregate transport service;
vtmd(i,r,s) = sum(j,vtwr(j,i,r,s));

vim(i,s) =  sum(r$vxmd(i,r,s),(vxmd(i,r,s)*(1-rtxs(i,r,s))+vtmd(i,r,s))*(1+rtms(i,r,s)));

set		mkt(i,r)	Markets in the model;
mkt(i,r) = yes$vom(i,r);

set	rb(r)	Region to balance;

variables	OBJ		Objective function;

nonnegative 
variables	VID_(g,r)	Total intermediate demand,
		VIFM_(j,g,r)	Imported intermediate,
		VDFM_(j,g,r)	Domestic intermediate,
		VFM_(f,i,r)	Factor inputs,
		VOM_(g,r)	Commodity supply,
		DP_VIFM(j,g,r)	Positive deviation in VIFM
		DN_VIFM(j,g,r)	Negative deviation in VIFM
		DP_VDFM(j,g,r)	Positive deviation in VDFM
		DN_VDFM(j,g,r)	Negative deviation in VDFM,
		DP_VFM(f,i,r)	Positive deviation in VFM
		DN_VFM(f,i,r)	Negative deviation in VFM;

equations	objdef, vimtot, viddef, vomdef, output, delta_vifm, delta_vdfm, delta_vfm;

objdef..	OBJ =e= sum(rb(r),
			sum((i,g)$vifm(i,g,r), sqr(VIFM_(i,g,r)-vifm(i,g,r))) +
			sum((i,g)$vdfm(i,g,r), sqr(VDFM_(i,g,r)-vdfm(i,g,r))) +
			sum((g)$vom(g,r),	 sqr(VOM_(g,r)-vom(g,r))) +
			sum((f,i)$vfm(f,i,r),	 sqr(VFM_(f,i,r)-vfm(f,i,r))) +
			sum((j,g)$vifm(j,g,r), DP_VIFM(j,g,r)+DN_VIFM(j,g,r)) + 
			sum((j,g)$vdfm(j,g,r), DP_VDFM(j,g,r)+DN_VDFM(j,g,r)) +
			sum((f,i)$vfm(f,i,r),  DP_VFM(f,i,r)+DN_VFM(f,i,r)));

vimtot(i,rb(r))$vim(i,r)..	vim(i,r) =e= sum(g,VIFM_(i,g,r));

viddef(g,rb(r))$vom(g,r)..	VID_(g,r) =e= sum(j, VIFM_(j,g,r)*(1+rtfi(j,g,r))+VDFM_(j,g,r)*(1+rtfd(j,g,r)));

delta_vifm(j,g,rb(r))$vifm(j,g,r).. DP_VIFM(j,g,r) - DN_VIFM(j,g,r) =e= VIFM_(j,g,r) - vifm(j,g,r);

delta_vdfm(j,g,rb(r))$vdfm(j,g,r).. DP_VDFM(j,g,r) - DN_VDFM(j,g,r) =e= VDFM_(j,g,r) - vdfm(j,g,r);

delta_vfm(f,i,rb(r))$vfm(f,i,r).. DP_VFM(f,i,r) - DN_VFM(f,i,r) =e= VFM_(f,i,r) - vfm(f,i,r);

vomdef(g,rb(r))$vom(g,r)..	(1-rto(g,r))*VOM_(g,r) =e= VID_(g,r) + sum((f,i(g)),VFM_(f,i,r)*(1+rtf(f,i,r)));

output(i,rb(r))$vom(i,r)..	VOM_(i,r) =e= sum(g,VDFM_(i,g,r)) + sum(s, vxmd(i,r,s)) + vst(i,r);

model	recalib /all/;

VIFM_.L(j,g,r) = vifm(j,g,r);
VDFM_.L(j,g,r) = vdfm(j,g,r);
VOM_.L(g,r) = vom(g,r);
VID_.L(g,r) = sum(j, vifm(j,g,r)*(1+rtfi(j,g,r))+vdfm(j,g,r)*(1+rtfd(j,g,r)));
VFM_.L(f,i,r) = vfm(f,i,r);

VIFM_.FX(j,g,r)$(not vifm(j,g,r)) = 0;
VDFM_.FX(j,g,r)$(not vdfm(j,g,r)) = 0;
VOM_.FX(g,r)$(not vom(g,r)) = 0;
VID_.FX(g,r)$(not sum(j, vifm(j,g,r)*(1+rtfi(j,g,r))+vdfm(j,g,r)*(1+rtfd(j,g,r)))) = 0;

VFM_.FX(f,i,r)$(not vfm(f,i,r)) = 0;


*	Load tax rates:

$if set rto  execute_load '%rto%', rto;
$if set rtfi execute_load '%rtfi%',rtfi;
$if set rtfd execute_load '%rtfd%',rtfd;
$if set rtms execute_load '%rtms%',rtms;
$if set rtxs execute_load '%rtxs%',rtxs;
$if set rtf  execute_load '%rtf%',rtf;

*	Recalibrate CIF imports, accouting for tariff and export tax rates:

vim(i,s) =  sum(r$vxmd(i,r,s),(vxmd(i,r,s)*(1-rtxs(i,r,s))+vtmd(i,r,s))*(1+rtms(i,r,s)));


alias (r,rr);
option qcp = cplex, limrow=0, limcol=0, solprint=off;

parameter	iterlog(r,*)	Iteration log,
		handle(r)	Pointer for grid solution

set		submit(r)	List of regions to submit,
		done(r)		List of regions which are completed;

$ifthen.threads %threads%==1

loop(rr,
	rb(r) = yes$sameas(r,rr);

	solve recalib using qcp minimizing OBJ;

	put_utility 'title'/ktitle 'Recalibration.  Finished: ',card(done),', remaining: ',
		(card(r)-card(done)),', running: 1.';

	iterlog(rb(r),"OBJ") = OBJ.L;
 	iterlog(rb(r),"vifm") = sum((i,g)$vifm(i,g,r), sqr(VIFM_.L(i,g,r)-vifm(i,g,r)));
	iterlog(rb(r),"vdfm") = sum((i,g)$vdfm(i,g,r), sqr(VDFM_.L(i,g,r)-vdfm(i,g,r)));
	iterlog(rb(r),"vom") = sum((g)$vom(g,r),	 sqr(VOM_.L(g,r)-vom(g,r)));
	iterlog(rb(r),"vfm") = sum((f,i)$vfm(f,i,r),	 sqr(VFM_.L(f,i,r)-vfm(f,i,r)));
	iterlog(rb(r),"d_vifm") = sum((j,g)$vifm(j,g,r), DP_VIFM.L(j,g,r)+DN_VIFM.L(j,g,r));
	iterlog(rb(r),"d_vdfm") = sum((j,g)$vdfm(j,g,r), DP_VDFM.L(j,g,r)+DN_VDFM.L(j,g,r));

	done(rb(r)) = yes;

);
$else.threads

	recalib.solvelink = %solvelink.AsyncThreads%;
	done(r) = no;
	handle(r) = 0;
	repeat
	  submit(r) = no;
	  loop(r$(not (done(r) or handle(r))),
	    submit(r) = yes$(card(submit)+card(handle)<%threads%););
	  loop(submit(rr),
	    rb(r) = yes$sameas(r,rr);
	    solve recalib using qcp minimizing OBJ;
	    handle(rr) = recalib.handle;);

	  put_utility 'title'/ktitle 'Recalibration.  Finished: ',card(done),', remaining: ',
		(card(r)-card(done)),', running: ',card(handle),'.';
	  display$ReadyCollect(handle) 'Waiting for next instance to collect';
	  loop(rr$handlecollect(handle(rr)),

	    rb(r) = yes$sameas(r,rr);
	    iterlog(rb(r),"OBJ") = OBJ.L;
	    iterlog(rb(r),"vifm") = sum((i,g)$vifm(i,g,r), sqr(VIFM_.L(i,g,r)-vifm(i,g,r)));
	    iterlog(rb(r),"vdfm") = sum((i,g)$vdfm(i,g,r), sqr(VDFM_.L(i,g,r)-vdfm(i,g,r)));
	    iterlog(rb(r),"vom") = sum((g)$vom(g,r),	 sqr(VOM_.L(g,r)-vom(g,r)));
	    iterlog(rb(r),"vfm") = sum((f,i)$vfm(f,i,r),	 sqr(VFM_.L(f,i,r)-vfm(f,i,r)));
	    iterlog(rb(r),"d_vifm") = sum((j,g)$vifm(j,g,r), DP_VIFM.L(j,g,r)+DN_VIFM.L(j,g,r));
	    iterlog(rb(r),"d_vdfm") = sum((j,g)$vdfm(j,g,r), DP_VDFM.L(j,g,r)+DN_VDFM.L(j,g,r));

	    iterlog(rr,"modelstat") = recalib.modelstat;
	    iterlog(rr,"solvestat") = recalib.solvestat;

	    display$handledelete(handle(rr)) 'trouble deleting handles' ;
	    handle(rr) = 0;
	    done(rr) = yes;);

	until (card(done)=card(r)) or timeelapsed > 300;  
	abort$(card(done)<>card(r)) 'RECALIB jobs did not return:', handle;
$endif.threads
display iterlog;

vifm(j,g,r) = VIFM_.L(j,g,r);
vdfm(j,g,r) = VDFM_.L(j,g,r);
vom(g,r)    = VOM_.L(g,r);
vfm(f,i,r) = VFM_.L(f,i,r);

metadata("recalib%system.time%","date","%system.date%") = yes;
metadata("recalib%system.time%","filesys","%system.filesys%") = yes;
metadata("recalib%system.time%","username","%system.username%") = yes;
metadata("recalib%system.time%","computername","%system.computername%") = yes;
metadata("recalib%system.time%","gamsversion","%system.gamsversion%") = yes;
metadata("recalib%system.time%","program","%system.fp%%system.fn%%system.fe%")   = yes;

*	Input data files:

metadata("recalib%system.time%","input","%datadir%%ds%.gdx") = yes;
$if set rto  metadata("recalib%system.time%","rto","%rto%") = yes;
$if set rtfi metadata("recalib%system.time%","rtfi","%rtfi%") = yes;
$if set rtfd metadata("recalib%system.time%","rtfd","%rtfd%") = yes;
$if set rtms metadata("recalib%system.time%","rtms","%rtms%") = yes;
$if set rtxs metadata("recalib%system.time%","rtxs","%rtxs%") = yes;
$if set rtf  metadata("recalib%system.time%","rtf","%rtf%") = yes;
metadata("recalib%system.time%","output","%datadir%%output%.gdx") = yes;

option metadata:0:0:1;
display metadata;

execute_unload '%datadir%%output%.gdx', 
		r, f, g, i,  vfm, vdfm, vifm, vxmd, vst, vtwr, vtrev,
		rto, rtf, rtfd, rtfi, rtxs, rtms, esubt, esubd, esubva, esubm, etrae, 
		eta, aues, incpar, subpar,
		pop, evd, evi, evt, eco2d, eco2i, forecast, metadata;
