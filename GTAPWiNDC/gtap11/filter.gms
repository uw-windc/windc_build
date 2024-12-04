$title	Filter to Create a GTAPinGAMS Dataset

*	Which GTAP dataset?

$if not set yr $set yr 2017
$if not set ds $set ds gtapingams

$if not set gtap_version $include "gtapingams.gms"

*	RELTOL changes data footprint:

$if not set reltol $set reltol 4

*	ABSTOL does not have a big effect:

$if not set abstol $set abstol 7

parameter	reltol	Relative filter tolerance /1e-%reltol%/,
		abstol	Absolute filter tolerance /1e-%abstol%/;

$include %system.fp%gtapdata

alias (r,rr), (g,gg);

parameter	trace		Aggregate values;
$set pt gtap11
trace("vst",r,"%pt%") = sum((i),vst(i,r));
trace("vtwr",r,"%pt%") = sum((i,j,rr),vtwr(i,j,r,rr));
trace("vxmd",r,"%pt%") = sum((i,rr),vxmd(i,r,rr));
trace("vdfm",r,"%pt%") = sum((i,g),vdfm(i,g,r));
trace("vifm",r,"%pt%") = sum((i,g),vifm(i,g,r));
trace("vfm",r,"%pt%") = sum((f,g),vfm(f,g,r));

parameter	nz(*,*)		Nonzero count;
nz("vst","gtap11") = card(vst);
nz("vtwr","gtap11") = card(vtwr);
nz("vxmd","gtap11") = card(vxmd);
nz("vdfm","gtap11") = card(vdfm);
nz("vifm","gtap11") = card(vifm);
nz("vfm","gtap11") = card(vfm);

vst(i,r)$(vst(i,r)<abstol) = 0;
vtwr(j,i,rr,r)$(vtwr(j,i,rr,r)<abstol) = 0;
vxmd(i,rr,r)$(vxmd(i,rr,r)<abstol) = 0;
vdfm(i,g,r)$(vdfm(i,g,r)<abstol) = 0;
vifm(i,g,r)$(vifm(i,g,r)<abstol) = 0;
vfm(f,g,r)$(vfm(f,g,r)<abstol) = 0;

nz("vst","abstol") = card(vst) - nz("vst","gtap11");
nz("vtwr","abstol") = card(vtwr) - nz("vtwr","gtap11");
nz("vxmd","abstol") = card(vxmd) - nz("vxmd","gtap11");
nz("vdfm","abstol") = card(vdfm) - nz("vdfm","gtap11");
nz("vifm","abstol") = card(vifm) - nz("vifm","gtap11");
nz("vfm","abstol") = card(vfm) - nz("vfm","gtap11");

parameter	vxmdtot,vdfmtot,vtwrtot,vifmtot;
vxmdtot(i,r,".") = sum(rr,vxmd(i,r,rr));
vxmdtot(i,".",rr) = sum(r,vxmd(i,r,rr));
vtwrtot(i,rr,r) = sum(j,vtwr(j,i,rr,r));
vdfmtot(i,".",r) = sum(g,vdfm(i,g,r));
vdfmtot(".",g,r) = sum(i,vdfm(i,g,r));
vifmtot(i,".",r) = sum(g,vifm(i,g,r));
vifmtot(".",g,r) = sum(i,vifm(i,g,r));

*	Filter based on the relative tolerance:

vxmd(  i,rr,r)$(  vxmd(i,rr,r)<reltol * min(vxmdtot(i,rr,"."),vxmdtot(i,".",r))) = 0;
vtwr(j,i,rr,r)$(vtwr(j,i,rr,r)<reltol * vtwrtot(i,rr,r)) = 0;
vdfm(i,g,   r)$(   vdfm(i,g,r)<reltol * min(vdfmtot(i,".",r),vdfmtot(".",g,r))) = 0;
vifm(i,g,   r)$(   vifm(i,g,r)<reltol * min(vifmtot(i,".",r),vifmtot(".",g,r))) = 0;

*	Drop transport margins and tariffs on non-existent trade links:

vtwr(j,i,rr,r)$(not vxmd(i,rr,r)) = 0;

*	Scale exports of trade margins to match trade margin demand:

vst(j,r) = vst(j,r)/sum(rr,vst(j,rr)) * sum((i,r1,r2),vtwr(j,i,r1,r2));

rtxs(i,r,rr)$(not vxmd(i,r,rr)) = 0;
rtms(i,r,rr)$(not vxmd(i,r,rr)) = 0;

nz("vst","reltol")  = card(vst)  - nz("vst","gtap11")  - nz("vst","abstol");
nz("vtwr","reltol") = card(vtwr) - nz("vtwr","gtap11") - nz("vtwr","abstol");
nz("vxmd","reltol") = card(vxmd) - nz("vxmd","gtap11") - nz("vxmd","abstol");
nz("vdfm","reltol") = card(vdfm) - nz("vdfm","gtap11") - nz("vdfm","abstol");
nz("vifm","reltol") = card(vifm) - nz("vifm","gtap11") - nz("vifm","abstol");
nz("vfm","reltol")  = card(vfm)  - nz("vfm","gtap11")  - nz("vfm","abstol");

nz("vst","card")  = card(vst);
nz("vtwr","card") = card(vtwr);
nz("vxmd","card") = card(vxmd);
nz("vdfm","card") = card(vdfm);
nz("vifm","card") = card(vifm);
nz("vfm","card")  = card(vfm);

set param /vst,vtwr, vxmd, vdfm, vifm, vfm/;
nz(param,"%")  = round(100 * nz(param,"card")/nz(param,"gtap11"));
option nz:0;
display nz;

$set pt target
trace("vst",r,"%pt%") = sum((i),vst(i,r));
trace("vtwr",r,"%pt%") = sum((i,j,rr),vtwr(i,j,r,rr));
trace("vxmd",r,"%pt%") = sum((i,rr),vxmd(i,r,rr));
trace("vdfm",r,"%pt%") = sum((i,g),vdfm(i,g,r));
trace("vifm",r,"%pt%") = sum((i,g),vifm(i,g,r));
trace("vfm",r,"%pt%") = sum((f,g),vfm(f,g,r));

$include %system.fp%calibrate

$exit

$set pt calibrated
trace("vst",r,"%pt%") = sum((i),vst(i,r));
trace("vtwr",r,"%pt%") = sum((i,j,rr),vtwr(i,j,r,rr));
trace("vxmd",r,"%pt%") = sum((i,rr),vxmd(i,r,rr));
trace("vdfm",r,"%pt%") = sum((i,g),vdfm(i,g,r));
trace("vifm",r,"%pt%") = sum((i,g),vifm(i,g,r));
trace("vfm",r,"%pt%") = sum((f,g),vfm(f,g,r));

option trace:3:2:1;
display trace;

*	Drop emissions which have no corresponding economic transaction:
*	Report change in emissions.

parameter	ghgadj		Changes in aggregate GHG emissions;

ghgadj("eco2d","before") = sum((i,g,r),eco2d(i,g,r));
ghgadj("eco2i","before") = sum((i,g,r),eco2i(i,g,r));
ghgadj(pol,"before") = sum((i_f,g,r), nco2emit(pol,i_f,g,r)) ;

eco2d(i,g,r)$(not vdfm(i,g,r)) = 0;
eco2i(i,g,r)$(not vifm(i,g,r)) = 0;

nco2emit(pol,i_f(i),g,r)$(not (vdfm(i,g,r)+vifm(i,g,r))) = 0;
nco2emit(pol,i_f(f),j,r)$(not vfm(f,j,r)) = 0;
nco2process(pol,i_o(i),j,r)$(not (vdfm(i,j,r)+vifm(i,j,r))) = 0;
nco2process(pol,"output",j,r)$(not vom(j,r)) = 0;

vom(g,r) = (sum(i,vdfm(i,g,r)*(1+rtfd(i,g,r))+vifm(i,g,r)*(1+rtfi(i,g,r)))
		+  sum(f,vfm(f,g,r)*(1+rtf(f,g,r))))/(1-rto(g,r));


ghgadj("eco2d","after") = sum((i,g,r),eco2d(i,g,r));
ghgadj("eco2i","after") = sum((i,g,r),eco2i(i,g,r));
ghgadj(pol,"after") = sum((i_f,g,r), nco2emit(pol,i_f,g,r)) ;

ghgadj("eco2d","%adjust")$ghgadj("eco2d","before") 
	 = 100 * (ghgadj("eco2d","after") / ghgadj("eco2d","before") - 1);

ghgadj("eco2i","%adjust")$ghgadj("eco2i","before") 
	 = 100 * (ghgadj("eco2i","after") / ghgadj("eco2i","before") - 1);

ghgadj(pol,"%adjust")$ghgadj(pol,"before") 
	 = 100 * (ghgadj(pol,"after") / ghgadj(pol,"before") - 1);

display ghgadj;

*	Energy flow which have no corresponding economic transaction:
*	report change in emissions.

parameter	eneadj		Changes in aggregate GHG emissions;

eneadj("evd","before") = sum((i,g,r),evd(i,g,r));
eneadj("evi","before") = sum((i,g,r),evi(i,g,r));

evd(i,g,r)$(not vdfm(i,g,r)) = 0;
evi(i,g,r)$(not vifm(i,g,r)) = 0;

eneadj("evd","after") = sum((i,g,r),evd(i,g,r));
eneadj("evi","after") = sum((i,g,r),evi(i,g,r));

eneadj("evd","%adjust")$eneadj("evd","before") 
	 = 100 * (eneadj("evd","after") / eneadj("evd","before") - 1);

eneadj("evi","%adjust")$eneadj("evi","before") 
	 = 100 * (eneadj("evi","after") / eneadj("evi","before") - 1);

display eneadj;

*	Drop bilateral energy trade which have no corresponding economic transaction
evt(i,r,rr)$(not vxmd(i,r,rr)) = 0;

execute_unload '%system.fp%%gtap_version%/%yr%/gtapingams_%reltol%.gdx',f,g,i,r,pol,
	vfm,vdfm,vifm,vxmd,vst,vtwr,
	rto,rtf,rtfd,rtfi,rtxs,rtms,
	subp, incp, etaf, esubva, esubdm, eta, aues, 
	gwp, evd, evi, evt,
	eco2d, eco2i, nco2emit, nco2process, landuse, pop, metadata;

