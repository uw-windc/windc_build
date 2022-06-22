$title	Generate a Sparse Version of the GTAP Dataset (filter.gms)

$set fs %system.dirsep% 

file kcon/con/;

*	Define a set of values for which filtering fractions
*	will be reported:

set	reltol	Alternative relative tolerance /3*6/,
	abstol	Alternative absolute tolerances /4*9/;

$if not set abstol $set abstol 6
$if not set reltol $set reltol 4

$if not set gtapv  $set gtapv  10
$if not set yr	   $set yr     14
$if not set ds	   $set ds     gsd

putclose kcon //"Reading dataset %ds%."/;

$include "%system.fp%gtapdata"

parameter
	neg_vdfm(i,g,r)		Negative elements of vdfm,
	neg_vifm(i,g,r)		Negative elements of vifm,
	neg_vfm(f,i,r)		Negative elements of vfm,
	neg_va(i,r)		Negative elements of imputed va,
	neg_vxmd(i,r,s)		Negative elements of vxmd,
	neg_vtwr(j,i,r,s)	Negative elements of vtwr;

neg_vdfm(i,g,r) = min(0,vdfm(i,g,r));
neg_vifm(i,g,r) = min(0,vifm(i,g,r));
neg_vfm(f,i,r) = min(0,vfm(f,i,r));
neg_vxmd(i,r,s) = min(0,vxmd(i,r,s));
neg_vtwr(j,i,r,s) = min(0,vtwr(j,i,r,s));

if (card(neg_vdfm), display "Benchmark data:", neg_vdfm;);
if (card(neg_vifm), display "Benchmark data:", neg_vifm;);
if (card(neg_vfm),  display "Benchmark data:", neg_vfm;);
if (card(neg_vxmd), display "Benchmark data:", neg_vxmd;);
if (card(neg_vtwr), display "Benchmark data:", neg_vtwr;);
  


*	Impose an absolute filter tolerance:

*	Set the filter tolerance here:

parameter	trace(*,*)	Array cardinaltiy;

trace("vom","%ds%")  = card(vom);
trace("vdfm","%ds%") = card(vdfm);
trace("vifm","%ds%") = card(vifm);
trace("vxmd","%ds%") = card(vxmd);
trace("vtwr","%ds%") = card(vtwr);
trace("vfm","%ds%")  = card(vfm);

*	Define the filter on trade using vx rather than filtering vxmd and vtwr
*	individually:

parameter	vx(i,r,s)	Value of exports (net tax and tariff);
vx(i,r,s) = vxmd(i,r,s) + sum(j,vtwr(j,i,r,s));

*	Report filtering rates for various absolute tolerances:

parameter	absfrac		Fraction of nonzeros dropped with absolute threshold;
absfrac("vxmd",abstol) = 100*sum((i,r,s  )$(vxmd(i,r,s)   and (not round(vx(i,r,s), abstol.val))),1)/card(vxmd);
absfrac("vtwr",abstol) = 100*sum((i,j,r,s)$(vtwr(i,j,r,s) and (not round(vx(j,r,s), abstol.val))),1)/card(vtwr);
absfrac("vdfm",abstol) = 100*sum((i,g,r  )$(vdfm(i,g,r)   and (not round(vdfm(i,g,r),  abstol.val))),1)/card(vdfm);
absfrac("vifm",abstol) = 100*sum((i,g,r  )$(vifm(i,g,r)   and (not round(vifm(i,g,r),  abstol.val))),1)/card(vifm);
absfrac("vfm", abstol) = 100*sum((f,g,r)$(vfm(f,g,r)       and (not round(vfm(f,g,r),   abstol.val))),1)/card(vfm);
option absfrac:1;
display absfrac;


*	Filter the data based on the specified tolerance:

vxmd(i,r,s  )$(not round(vx(i,r,s),   %abstol%)) = 0;
vtwr(j,i,r,s)$(not vxmd(i,r,s)) = 0;
vdfm(i,g,r  )$(not round(vdfm(i,g,r),   %abstol%)) = 0;
vifm(i,g,r  )$(not round(vifm(i,g,r),   %abstol%)) = 0;
vfm( f,g,r  )$(not round(vfm(f,g,r),    %abstol%)) = 0;


*	Identify sectors which are no longer in the model:

vom(g,r)$(not i(g)) = sum(i, vdfm(i,g,r)*(1+rtfd(i,g,r)) + vifm(i,g,r)*(1+rtfi(i,g,r)))/(1-rto(g,r));
vdm(i,r) = sum(g, vdfm(i,g,r));
vom(i,r) = vdm(i,r) + sum(s, vxmd(i,r,s)) + vst(i,r);

*	Remove intermediate inputs from those sectors:

vdfm(i,j,r)$(not vom(j,r)) = 0;
vifm(i,j,r)$(not vom(j,r)) = 0;
vfm(f,g,r)$(not vom(g,r)) = 0;

trace("vom" ,"abstol") = card(vom);
trace("vdfm","abstol") = card(vdfm);
trace("vifm","abstol") = card(vifm);
trace("vxmd","abstol") = card(vxmd);
trace("vtwr","abstol") = card(vtwr);
trace("vfm" ,"abstol") = card(vfm);

parameter	vtmd(i,r,s)	Aggregate transport service;
vtmd(i,r,s) = sum(j,vtwr(j,i,r,s));


set		noimports(i,r)	Markets with zero import supply or demand;

parameter	imports		Import market statistics;


$onechov >%gams.scrdir%importfilter.gms

noimports(i,s) = yes$(min(

*	Import supply:

	sum(r,(vxmd(i,r,s)*(1-rtxs(i,r,s))+vtmd(i,r,s))*(1+rtms(i,r,s))),

*	Import demand:

	sum(g,vifm(i,g,s))) = 0);

imports(noimports(i,s),"supply") = sum(r,(vxmd(i,r,s)*(1-rtxs(i,r,s))+vtmd(i,r,s))*(1+rtms(i,r,s)));
imports(noimports(i,r),"demand") = sum(g,vifm(i,g,r));
option imports:3:2:1;
display imports;

*	Drop trade flows and intermediate demand in markets where supply or demand
*	is zero:

vxmd(i,r,s)$noimports(i,s) = 0;
vtmd(i,r,s)$noimports(i,s) = 0;
vtwr(j,i,r,s)$noimports(i,s) = 0;
vifm(i,g,r)$noimports(i,r) = 0;

*	Aggregate sectoral supply equals sectoral demand:

vom(i,r) = sum(s, vxmd(i,r,s)) + sum(g,vdfm(i,g,r)) + vst(i,r);
vdm(i,r) = sum(g, vdfm(i,g,r));
vxm(i,r) = sum(s, vxmd(i,r,s)) + vst(i,r);
vtmd(i,r,s) = sum(j,vtwr(j,i,r,s));
vim(i,s) = sum(r,(vxmd(i,r,s)*(1-rtxs(i,r,s))+vtmd(i,r,s))*(1+rtms(i,r,s)));
$offecho

set	vainfo /va, vom, rto, vid/;

parameter	va(i,r)			Value-added
		vid(g,r)		Value of intermediate demand,
		valog(i,r,vainfo)	Log of value-added data for sectors with zero;


parameter	iscale, vscale, dscale, itrlog, dev /1/;

set		iter /iter0*iter10/;

$onechov >%gams.scrdir%scale.gms

rtxs(i,r,s)$(not vxmd(i,r,s)) = 0;
rtms(i,r,s)$(not vxmd(i,r,s)) = 0;
rtfd(i,g,r)$(not vdfm(i,g,r)) = 0;
rtfi(i,g,r)$(not vifm(i,g,r)) = 0;

*	Use RAS to recalibrate trade and output data:

loop(iter,

	vtmd(i,r,s) = sum(j,vtwr(j,i,r,s));
	vim(i,s) =  sum(r$vxmd(i,r,s),(vxmd(i,r,s)*(1-rtxs(i,r,s))+vtmd(i,r,s))*(1+rtms(i,r,s)));

*	Filter flows which are to be dropped:

	vifm(i,g,r)$(not vim(i,r)) = 0;
	vxmd(i,s,r)$(not vim(i,r)) = 0;
	vtmd(i,s,r)$(not vxmd(i,s,r)) = 0;
	vtwr(j,i,s,r)$(not vxmd(i,s,r)) = 0;

	iscale(i,s)$vim(i,s) = sum(g,vifm(i,g,s))/vim(i,s) - 1;
	vifm(i,g,r)$vifm(i,g,r) = vifm(i,g,r) / (1+iscale(i,r));

*.	display iscale;

	vscale(i)$sum(r,vst(i,r)) = sum(r,vst(i,r))/sum((j,r,s),vtwr(i,j,r,s))-1;
	vtwr(j,mkt(i,r),s)$vtwr(j,i,r,s)   = vtwr(j,i,r,s)*(1+vscale(j));

*.	display vscale;

*	Output levels after having dropped small sectors:

	vid(g,r) = sum(j, vifm(j,g,r)*(1+rtfi(j,g,r))+vdfm(j,g,r)*(1+rtfd(j,g,r)));

*	Impose nonnegative value-added by taking maximum of market supply and the 
*	value of intermediate demand:

	vom(mkt(i,r)) = max(vid(i,r)/(1-rto(i,r)), sum(s, vxmd(i,r,s)) + sum(g,vdfm(i,g,r)) + vst(i,r));
	dscale(mkt(i,r))$vom(i,r) = (sum(g,vdfm(i,g,r))+sum(s,vxmd(i,r,s))+vst(i,r))/vom(i,r) - 1;

*.	display dscale;

	vst(i,r)$vst(i,r)       =    vst(i,r) / (1+dscale(i,r));
	vdfm(i,g,r)$vdfm(i,g,r) = vdfm(i,g,r) / (1+dscale(i,r));
	vxmd(i,r,s)$vxmd(i,r,s) = vxmd(i,r,s) / (1+dscale(i,r));

	dev = sum((i,r),vim(i,r)*abs(iscale(i,r))) + sum(mkt(i,r),vst(mkt)*abs(vscale(i))) + sum((i,r),vom(i,r)*abs(dscale(i,r)));

	itrlog(iter,"dev") =  dev;
	itrlog(iter,"i") = sum((i,r)$vim(i,r),vim(i,r)*abs(iscale(i,r)));
	itrlog(iter,"v") = sum(mkt(i,r),vst(mkt)*abs(vscale(i)));
	itrlog(iter,"d") = sum((i,r)$vom(i,r),vom(i,r)*abs(dscale(i,r)));

);
display itrlog;

vid(g,r) = sum(j, vifm(j,g,r)*(1+rtfi(j,g,r))+vdfm(j,g,r)*(1+rtfd(j,g,r)));

va(mkt(j,r)) = vom(j,r)*(1-rto(j,r)) - vid(j,r);
neg_va(i,r) = min(0, va(i,r));
valog(i,r,vainfo) = 0;
if (card(neg_va),
	valog(i,r,"va")$neg_va(i,r) = neg_va(i,r);
	valog(i,r,"vom")$neg_va(i,r) = vom(i,r);
	valog(i,r,"rto")$neg_va(i,r) = rto(i,r);
	valog(i,r,"vid")$neg_va(i,r) = vid(i,r);
	option valog:3:2:1;
	display valog;
);
va(i,r) = max(0, va(i,r));

vtmd(i,r,s) = sum(j,vtwr(j,i,r,s));
vim(i,s) =  sum(r$vxmd(i,r,s),(vxmd(i,r,s)*(1-rtxs(i,r,s))+vtmd(i,r,s))*(1+rtms(i,r,s)));
vom(g,r)$(not i(g)) = vid(g,r);
vdm(mkt(i,r)) = sum(g,vdfm(i,g,r));
vom(mkt(i,r)) = sum(s, vxmd(i,r,s)) + vdm(mkt) + vst(mkt);

neg_vdfm(i,g,r) = min(0,vdfm(i,g,r));
neg_vifm(i,g,r) = min(0,vifm(i,g,r));
neg_vxmd(i,r,s) = min(0,vxmd(i,r,s));
neg_vtwr(j,i,r,s) = min(0,vtwr(j,i,r,s));
abort$(card(neg_vdfm)+card(neg_vifm)+card(neg_vxmd)+card(neg_vtwr)) 
	"Negative values returned by cinch:", neg_vdfm, neg_vifm, neg_vxmd, neg_vtwr;
$offecho


$include %gams.scrdir%importfilter

set		mkt(i,r)	Markets in the model;
mkt(i,r) = yes$vom(i,r);


putclose kcon //"Scaling the filtered dataset."/;

$include %gams.scrdir%scale

trace("vom","scale")  = card(vom);
trace("vdfm","scale") = card(vdfm);
trace("vifm","scale") = card(vifm);
trace("vxmd","scale") = card(vxmd);
trace("vtwr","scale") = card(vtwr);
trace("vfm","scale") = card(vfm);


putclose kcon //"Calculating filtering thresholds."/;

parameter	vxmd_t(i,r,s)	Threshold scale for vxmd, 
		vifm_t(i,g,s)	Threshold scale for vifm, 
		vdfm_t(i,g,r)	Threshold scale for vdfm;

vid(g,r) = sum(j, vifm(j,g,r)*(1+rtfi(j,g,r))+vdfm(j,g,r)*(1+rtfd(j,g,r)));
vxmd_t(i,r,s) = min(vxm(i,r),vim(i,s));
vifm_t(i,g,r) = min(vid(g,r),vim(i,r));
vdfm_t(i,g,r) = min(vid(g,r),vdm(i,r));

set		n(g,r)		Markets not in the model;

parameter	vomfrac		Output fraction;

vomfrac(i,r) = vom(i,r)/sum(j,vom(j,r));

parameter	relfrac(*,reltol)	Fraction of coefficients dropped with relative tolerances;
relfrac("vxmd",reltol) = 100*sum((i,r,s)$(vxmd(i,r,s) and (vomfrac(i,r) < 10**(-reltol.val)/card(i) or 
                                                            vxmd(i,r,s) < 10**(-reltol.val)*vxmd_t(i,r,s))), 1)/card(vxmd);

relfrac("vifm",reltol) = 100*sum((i,g,s)$(vifm(i,g,s) and (vifm(i,g,s)  < 10**(-reltol.val)*vifm_t(i,g,s))), 1)/card(vifm);

relfrac("vdfm",reltol) = 100*sum((i,g,s)$(vdfm(i,g,s) and (vomfrac(i,s) < 10**(-reltol.val)/card(i) or 
                                                            vdfm(i,g,s) < 10**(-reltol.val)*vdfm_t(i,g,s))), 1)/card(vdfm);

relfrac("vom", reltol) = 100 * sum((i,r)$(vom(i,r)    and (vomfrac(i,r) < 10**(-reltol.val)/card(i))),       1) /card(vom);

option relfrac:1;
display relfrac;


*	Produce a report of the resulting change in nonzeros and dataset density:

parameter	density		Filtering results;

set	array /vdfm, vifm, vfm, vxmd, vtwr/;

density("commodity","vtwr",j,"before") = sum((i,r,s)$vtwr(j,i,r,s),1);
density("commodity","vxmd",i,"before") = sum((r,s)$vxmd(i,r,s),1);
density("exporter","vxmd",r, "before") = sum((i,s)$vxmd(i,r,s),1);
density("importer","vxmd",s, "before") = sum((i,r)$vxmd(i,r,s),1);
density("region","vfm",r,    "before") = sum((f,g)$vfm(f,g,r),1);
density("factor","vfm",f,    "before") = sum((r,g)$vfm(f,g,r),1);
density("region","vdfm",r,   "before") = sum((i,g)$vdfm(i,g,r),1);
density("region","vifm",r,   "before") = sum((i,g)$vifm(i,g,r),1);
density("commodity","vdfm",i,"before") = sum((r,g)$vdfm(i,g,r),1);
density("commodity","vifm",i,"before") = sum((r,g)$vifm(i,g,r),1);
density("total","total",array,"before") = 
	sum(i,density("commodity",array,i,"before"));

*	First cinch on original data:

putclose kcon //"Cinching the original dataset."/;

*	------------------------------------------------------------------------
*	1. Cinch the original dataset:


$onechov >%gams.scrdir%cinch.gms

vtmd(i,r,s) = sum(j,vtwr(j,i,r,s));
noimports(i,s) = yes$(min(sum(r,(vxmd(i,r,s)*(1-rtxs(i,r,s))+vtmd(i,r,s))*(1+rtms(i,r,s))),sum(g,vifm(i,g,s))) = 0);

vxmd(i,r,s)$noimports(i,s) = 0;
vtmd(i,r,s)$noimports(i,s) = 0;
vtwr(j,i,r,s)$noimports(i,s) = 0;
vifm(i,g,r)$noimports(i,r) = 0;

vom(i,r) = sum(s, vxmd(i,r,s)) + sum(g,vdfm(i,g,r)) + vst(i,r);
vdm(i,r) = sum(g, vdfm(i,g,r));
vxm(i,r) = sum(s, vxmd(i,r,s)) + vst(i,r);
vtmd(i,r,s) = sum(j,vtwr(j,i,r,s));
vim(i,s) = sum(r,(vxmd(i,r,s)*(1-rtxs(i,r,s))+vtmd(i,r,s))*(1+rtms(i,r,s)));

vid(g,r) = sum(j, vifm(j,g,r)*(1+rtfi(j,g,r))+vdfm(j,g,r)*(1+rtfd(j,g,r)));
vxmd_t(i,r,s) = min(vxm(i,r),vim(i,s));
vifm_t(i,g,r) = min(vid(g,r),vim(i,r));
vdfm_t(i,g,r) = min(vid(g,r),vdm(i,r));

vomfrac(i,r) = vom(i,r)/sum(j,vom(j,r));

*	Filter based on the specified tolerance:

vxmd(i,r,s)$(vomfrac(i,r)<10**(-%reltol%)/card(i) or vxmd(i,r,s)<10**(-%reltol%)*vxmd_t(i,r,s))=0;
vtmd(i,r,s)$(not vxmd(i,r,s)) =0;
vtwr(j,i,r,s)$(not vxmd(i,r,s)) =0;
vifm(i,g,s)$(vifm(i,g,s)<10**(-%reltol%)*vifm_t(i,g,s))=0;
vdfm(i,g,s)$(vomfrac(i,s)<10**(-%reltol%)/card(i) or vdfm(i,g,s)<10**(-%reltol%)*vdfm_t(i,g,s))=0;

n(i,r)$vom(i,r) = yes$(vomfrac(i,r)<10**(-%reltol%)/card(i));
option n:0:0:1;
display "Markets dropped from the database:", n;

n(i,r) = yes$(vomfrac(i,r)<10**(-%reltol%)/card(i));
mkt(i,r) = (not n(i,r));

*	Drop data for markets to be excluded:

vst(n(i,r)) = 0;
vtmd(n(i,r),s) = 0;
vtwr(j,n(i,r),s) = 0;

vxmd(n(i,r),s) = 0;
vdfm(i,n) = 0;
vifm(i,n) = 0;
vdfm(i,j,r)$n(i,r) = 0;

vfm(f,n) = 0;
rtf(f,n) = 0;

$offecho


$include %gams.scrdir%cinch
$include %gams.scrdir%importfilter
$include %gams.scrdir%scale

trace("vom", "cinch")  = card(vom);
trace("vdfm","cinch") = card(vdfm);
trace("vifm","cinch") = card(vifm);
trace("vxmd","cinch") = card(vxmd);
trace("vtwr","cinch") = card(vtwr);

*	2. Round taxes and recinch:

rto(g,r)$(not vom(g,r))       = 0;
rtfd(i,g,r)$(not vdfm(i,g,r)) = 0;
rtfi(i,g,r)$(not vifm(i,g,r)) = 0;
rtf(f,g,r)$(not rtf(f,g,r))   = 0;
rtxs(i,r,s)$(not vxmd(i,r,s)) = 0;
rtms(i,r,s)$(not vxmd(i,r,s)) = 0;


rto(g,r)    = round(rto(g,r),2);
rtfd(i,g,r) = round(rtfd(i,g,r),2);
rtfi(i,g,r) = round(rtfi(i,g,r),2);
rtf(f,g,r)  = round(rtf(f,g,r),2);
rtxs(i,r,s) = round(rtxs(i,r,s),2);
rtms(i,r,s) = round(rtms(i,r,s),2);

*	Second cinch with rounded tax rates:

putclose kcon //"Rounding tax rates."/;

$include %gams.scrdir%importfilter
$include %gams.scrdir%cinch
$include %gams.scrdir%scale

trace("vom", "taxround")  = card(vom);
trace("vdfm","taxround") = card(vdfm);
trace("vifm","taxround") = card(vifm);
trace("vxmd","taxround") = card(vxmd);
trace("vtwr","taxround") = card(vtwr);

option trace:0:1:1;
display trace;


putclose kcon //"Recalibrating factor demand."/;

alias (u,*);

va(mkt(i,r)) = sum(f,vfm(f,i,r) * (1+rtf(f,i,r)));

parameter	thetaf(f,i,r)	Factor shares of value-added
		thetafchk	Check on adding up for thetaf;

*	Factor shares of value added in sector i of region r:


thetaf(f,mkt(i,r))$va(i,r) = max(0, vfm(f,i,r) * (1+rtf(f,i,r))) / va(i,r);

*	Factor shares in sectors which have no value-added are assigned
*	the average value across all sectors in the same region:

thetaf(f,mkt(j,r))$(not va(j,r)) = sum(i$va(i,r),vfm(f,i,r)*(1+rtf(f,i,r)))/sum(i,va(i,r));

thetafchk(mkt(i,r)) = round(1 - sum(f,thetaf(f,i,r)),3);
abort$card(thetafchk)	"Error in thetaf0:", thetafchk;


*	Value added in goods production is determined as a
*	residual:

va(mkt(j,r)) = max(vom(j,r)*(1-rto(j,r))-vid(j,r),0);

neg_va(i,r) = min(0, va(i,r));
if (card(neg_va),
	valog(i,r,"va")$neg_va(i,r) = neg_va(i,r);
	valog(i,r,"vom")$neg_va(i,r) = vom(i,r);
	valog(i,r,"rto")$neg_va(i,r) = rto(i,r);
	valog(i,r,"vid")$neg_va(i,r) = vid(i,r);
	option valog:3:2:1;
	abort$card(neg_va) "Negative values in calibrated data.", valog;
);


vfm(f,i,r) = 0;
vfm(f,mkt(i,r))$thetaf(f,i,r) = thetaf(f,i,r)*va(i,r)/(1+rtf(f,i,r));
vfm(f,mkt(i,r))$(not round(vfm(f,i,r),%abstol%)) = 0;

*	Verify that sectoral profits are zero:

yprofit(g,r) = 0;
yprofit(mkt(i,r)) = round(vom(i,r)*(1-rto(i,r)) - vid(i,r) - sum(f,vfm(f,i,r)*(1+rtf(f,i,r))),2);
abort$card(yprofit) yprofit;

*	Aggregate factor supply equals factor demand:

evom(f,r) = sum(i, vfm(f,i,r));
evom(f,r)$(not round(evom(f,r),%abstol%)) = 0;

*	Impute current account deficits using the
*	regional budget constraint:

vb(r) = vom("c",r) + vom("g",r) + vom("i",r) 
	- sum(f, evom(f,r))
	- sum(g,  vom(g,r)*rto(g,r))
	- sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) + 
			 vifm(i,g,r)*rtfi(i,g,r)))
	- sum((f,g), vfm(f,g,r)*rtf(f,g,r))
	- sum((i,s), rtms(i,s,r) * (vxmd(i,s,r) * (1-rtxs(i,s,r)) + sum(j,vtwr(j,i,s,r))))
	+ sum((i,s), rtxs(i,r,s) * vxmd(i,r,s));

putclose kcon //"Calculating log of density changes."/;

density("commodity","vtwr",j,"after")  = sum((i,r,s)$vtwr(j,i,r,s),1);
density("commodity","vtwr",j,"%reduction")$density("commodity","vtwr",j,"before")  = 
	100 * (1 - density("commodity","vtwr",j,"after") /
		   density("commodity","vtwr",j,"before"));

density("commodity","vxmd",i,"after")  = sum((r,s)$vxmd(i,r,s),1);
density("commodity","vxmd",i,"%reduction")$density("commodity","vxmd",i,"before")  = 
	100 * (1 - density("commodity","vxmd",i,"after") /
		   density("commodity","vxmd",i,"before"));

density("exporter","vxmd",r,"after")  = sum((i,s)$vxmd(i,r,s),1);
density("exporter","vxmd",r,"%reduction")$density("exporter","vxmd",r,"before")  = 
	100 * (1 - density("exporter","vxmd",r,"after") /
		   density("exporter","vxmd",r,"before"));

density("importer","vxmd",s,"after")  = sum((i,r)$vxmd(i,r,s),1);
density("importer","vxmd",s,"%reduction")$density("importer","vxmd",s,"before")  = 
	100 * (1 - density("importer","vxmd",s,"after") /
		   density("importer","vxmd",s,"before"));

density("region","vfm",r,"after")  = sum((f,g)$vfm(f,g,r),1);
density("region","vfm",r,"%reduction")$density("region","vfm",r,"before")  = 
	100 * (1 - density("region","vfm",r,"after") /
		   density("region","vfm",r,"before"));

density("factor","vfm",f,"after")  = sum((r,g)$vfm(f,g,r),1);
density("factor","vfm",f,"%reduction")$density("factor","vfm",f,"before")  = 
	100 * (1 - density("factor","vfm",f,"after") /
		   density("factor","vfm",f,"before"));

density("region","vdfm",r,"after")  = sum((i,g)$vdfm(i,g,r),1);
density("region","vdfm",r,"%reduction")$density("region","vdfm",r,"before")  = 
	100 * (1 - density("region","vdfm",r,"after") /
		   density("region","vdfm",r,"before"));

density("region","vifm",r,"after")  = sum((i,g)$vifm(i,g,r),1);
density("region","vifm",r,"%reduction")$density("region","vifm",r,"before")  = 
	100 * (1 - density("region","vifm",r,"after") /
		   density("region","vifm",r,"before"));

density("commodity","vdfm",i,"after")  = sum((r,g)$vdfm(i,g,r),1);
density("commodity","vdfm",i,"%reduction")$density("commodity","vdfm",i,"before")  = 
	100 * (1 - density("commodity","vdfm",i,"after") /
		   density("commodity","vdfm",i,"before"));

density("commodity","vifm",i,"after")  = sum((r,g)$vifm(i,g,r),1);
density("commodity","vifm",i,"%reduction")$density("commodity","vifm",i,"before")  = 
	100 * (1 - density("commodity","vifm",i,"after") /
		   density("commodity","vifm",i,"before"));

density("total","total",array,"after") = 
	sum(i,density("commodity",array,i,"after"));
density("total","total",array,"%reduction")$density("total","total",array,"before") = 
	100 * (1 -	density("total","total",array,"after") /
			density("total","total",array,"before"));

option density:0:2:1;
display density;


parameter	neg_vfm(f,i,r)		Negative elements of vfm;

neg_vdfm(i,g,r) = min(0,vdfm(i,g,r));
neg_vifm(i,g,r) = min(0,vifm(i,g,r));
neg_vxmd(i,r,s) = min(0,vxmd(i,r,s));
neg_vtwr(j,i,r,s) = min(0,vtwr(j,i,r,s));
neg_vfm(f,i,r) = min(0,vfm(f,i,r));

abort$card(neg_vdfm) "Recalibrated data has negative values:", neg_vdfm;
abort$card(neg_vifm) "Recalibrated data has negative values:", neg_vifm;
abort$card(neg_vxmd) "Recalibrated data has negative values:", neg_vxmd;
abort$card(neg_vtwr) "Recalibrated data has negative values:", neg_vtwr;
abort$card(neg_vfm)  "Recalibrated data has negative values:", neg_vfm;


*	Recalibrate elasticities:

thetac(i,r) = (vdfm(i,"c",r)*(1+rtfd(i,"c",r)) + vifm(i,"c",r)*(1+rtfi(i,"c",r))) /
	 sum(j,vdfm(j,"c",r)*(1+rtfd(j,"c",r)) + vifm(j,"c",r)*(1+rtfi(j,"c",r)));
eta(i,r) = (eta(i,r)/sum(j,thetac(j,r)*eta(j,r)))$thetac(i,r);
aues(i,j,r)$(not (thetac(i,r) and thetac(j,r))) = 0;

parameter	auessum(i,r)	Row sum;
auessum(i,r) = sum(j$(not sameas(i,j)),thetac(j,r)*aues(i,j,r));
aues(i,j,r)$(aues(i,j,r) and (not sameas(i,j))) = 
	aues(i,j,r) * (-thetac(i,r)*aues(i,i,r))/auessum(i,r);


putclose kcon //"Saving filtered dataset to %datadir%%ds%_%abstol%_%reltol%.gdx."/;

metadata("filter","date","%system.date%") = yes;
metadata("filter","time","%system.time%") = yes;
metadata("filter","filesys","%system.filesys%") = yes;
metadata("filter","username","%system.username%") = yes;
metadata("filter","computername","%system.computername%") = yes;
metadata("filter","gamsversion","%system.gamsversion%") = yes;
metadata("filter","program","%system.fp%%system.fn%%system.fe%")   = yes;
metadata("filter","input","%datadir%%ds%.gdx") = yes;
metadata("filter","abstol","%abstol%") = yes;
metadata("filter","reltol","%reltol%") = yes;
metadata("filter","output","%datadir%%ds%_%abstol%_%reltol%.gdx") = yes;
option metadata:0:0:1;
display metadata;

execute_unload '%datadir%%ds%_%abstol%_%reltol%.gdx', 
		r, f, g, i,  vfm, vdfm, vifm, vxmd, vst, vtwr, vtrev,
		rto, rtf, rtfd, rtfi, rtxs, rtms, esubt, esubd, esubva, esubm, etrae, 
		eta, aues, incpar, subpar,
		pop, evd, evi, evt, eco2d, eco2i, forecast, metadata;
