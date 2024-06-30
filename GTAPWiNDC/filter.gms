$title	Filter one Region in the Gravity-based GTAP-WINDC Database

*	Read the data:

$if not set ds $set ds 43

$if not set gtap_version $include "gtapingams.gms"

$if not set datasets $set datasets 2017

$set dsout  %datasets%/gtapwindc/%ds%_filtered

$if not defined y_ $include %system.fp%gtapwindc_data

set	rb(r)	Region to balance /usa/;

set	state(s); state(s) = yes$(not sameas(s,"rest"));

parameter	yprofit	Cross check on Y profit
		pychk	Cross check on PY market
		pzchk	Cross check on PZ market
		pnchk	Cross check on PN market
		plchk	Cross check on factor markets
		pkschk	Cross check on capital markets;

$onechov >%gams.scrdir%chkmodel.gms

y_(g,r,s)$(not vom(g,r,s)) = no;
a0(i,rb(r),s) = sum(mkt,nd0(i,mkt,r,s))*(1+rtd0(i,r,s)) + md0(i,r,s)*(1+rtm0(i,r,s));
vnm(i,mkt,rb(r)) = sum(s,ns0(i,mkt,r,s));
vxm(i,rb(r)) = sum(s,xs0(i,r,s));
c0(rb(r),s,h) = sum(i,cd0(i,r,s,h));

yprofit(g,r,s) = 0;
yprofit(y_(g,rb(r),s)) = round(vom(g,r,s)*(1-rto(g,r)) - sum(i,vafm(i,g,r,s)) - sum(f,vfm(f,g,r,s)*(1+rtf0(f,g,r))),3);
pzchk(pz_(i,rb(r),s)) = round(sum(z_(i,r,s),a0(i,r,s)) - sum(y_(g,r,s),vafm(i,g,r,s)) - sum(c_(r,s,h),cd0(i,r,s,h)), 3);
pnchk(pn_(i,mkt,rb(r))) = round(vnm(i,mkt,r) - sum(s,nd0(i,mkt,r,s)),3);
plchk(pf_(mf,rb(r),s)) = round(sum(g,vfm(mf,g,r,s)) - sum(h,evomh(mf,r,s,h)),3);
pkschk(sf,rb(r),s) = round(evom(sf,r,s) - sum(g,vfm(sf,g,r,s)),3);

pychk(g,r,s) = 0;
pychk(y_(i,rb(r),state(s))) = 
	round( vom(i,r,s) - ( sum(x_(i,r), xs0(i,r,s)) + sum(n_(i,mkt,r), ns0(i,mkt,r,s)) ) ,3);

pychk("i",rb(r),"all") = round(sum(s,vom("i",r,s)) - (vb(r)+sum(rh_(r,s,h),sav0(r,s,h))),3);

pychk("g",rb(r),"all") = round( sum(s,vom("g",r,s)) - 
		( - sum((i,rr),		rtxs(i,r,rr)*vxmd(i,r,rr))
		+ sum(m_(i,rr),		rtms(i,rr,r)*(sum(j,vtwr(j,i,rr,r))+(1-rtxs(i,rr,r))*vxmd(i,rr,r)))
		+ sum(z_(i,r,s),	rtd(i,r,s) * sum(mkt,nd0(i,mkt,r,s)) + rtm(i,r,s)*md0(i,r,s))
		+ sum((g,s),		rto(g,r)   * vom(g,r,s))
		+ sum((f,y_(g,r,s)),	rtf(f,g,r) * vfm(f,g,r,s)) 
		-sum((rh_(r,s.local,h),trn),hhtrn0(r,s,h,trn))), 3);

display yprofit, pzchk, pnchk, plchk, pkschk, pychk;
$offecho

*	Checking equilibrium conditions before filtering:

$include %gams.scrdir%chkmodel

set	prec	Alternative precisions (decimals) /4*8/;

$macro	nzcount(item,domain,prec)  sum((&&domain&),1$round(&&item&(&&domain&),prec.val))

set	m	Matricies for filtering /
		vfm, vafm, vom, ns0, nd0, md0, cd0 /

set	d(*)	Domains;

set	md(m,d<) /
		vfm."f,g,r,s"
		vafm."i,g,r,s"
		vom."g,r,s"
		ns0."i,mkt,r,s"
		nd0."i,mk,r,s"
		md0."i,r,s" 
		cd0."i,r,s,h" 
		/;

parameter	nz(m,*)	Number of nonzeros;
nz("vom" ,"card") = card(vom) ;
nz("vfm" ,"card") = card(vfm) ;
nz("vafm","card") = card(vafm);
nz("ns0" ,"card") = card(ns0) ;
nz("nd0" ,"card") = card(nd0) ;
nz("md0" ,"card") = card(md0) ;
nz("cd0" ,"card") = card(cd0) ;

nz("vom" ,prec) = card(vom)  - nzcount(vom ,"g,r,s", prec);
nz("vfm" ,prec) = card(vfm)  - nzcount(vfm ,"f,g,r,s",prec);
nz("vafm",prec) = card(vafm) - nzcount(vafm,"i,g,r,s",prec);
nz("ns0" ,prec) = card(ns0)  - nzcount(ns0 ,"i,mkt,r,s",  prec);
nz("nd0" ,prec) = card(nd0)  - nzcount(nd0 ,"i,mkt,r,s",  prec);
nz("md0" ,prec) = card(md0)  - nzcount(md0 ,"i,r,s",  prec);
nz("cd0" ,prec) = card(cd0)  - nzcount(cd0 ,"i,r,s,h",prec);

*	RELTOL changes data footprint:

$if not set reltol $set reltol 3

*	ABSTOL does not have a big effect:

$if not set abstol $set abstol 6

parameter	reltol	Relative filter tolerance /1e-%reltol%/,
		abstol	Absolute filter tolerance /1e-%abstol%/;

vom(i,rb(r),s)$(vom(i,r,s)<abstol) = 0;
vfm(f,g,rb(r),s) $(vfm(f,g,r,s) < abstol) = 0;
vafm(i,g,rb(r),s)$(vafm(i,g,r,s)< abstol) = 0;
ns0(i,mkt,rb(r),s)$(ns0(i,mkt,r,s)< abstol) = 0;

nd0(i,mkt,rb(r),s)$(nd0(i,mkt,r,s)   < abstol) = 0;
md0(i,rb(r),s)   $(md0(i,r,s)   < abstol) = 0;
cd0(i,rb(r),s,h) $(cd0(i,r,s,h) < abstol) = 0;
vst(j,rb(r))     $(vst(j,r)     < abstol) = 0;

nz("vom" ,"abstol") = card(vom)  - nz("vom" ,"card");
nz("vfm" ,"abstol") = card(vfm)  - nz("vfm" ,"card");
nz("vafm","abstol") = card(vafm) - nz("vafm","card");
nz("ns0" ,"abstol") = card(ns0)  - nz("ns0" ,"card");
nz("nd0" ,"abstol") = card(nd0)  - nz("nd0" ,"card");
nz("md0" ,"abstol") = card(md0)  - nz("md0" ,"card");
nz("cd0" ,"abstol") = card(cd0)  - nz("cd0" ,"card");

parameter	vomtot, vfmtot, vafmtot, ns0tot, nd0tot, md0tot, cd0tot;
vomtot(".",rb,s) = sum(i,vom(i,rb,s));
vomtot(i,rb,".") = sum(s,vom(i,rb,s));
vfmtot(".",g,rb(r),s)  = sum(f ,vfm(f,g,r,s) );
vfmtot(f,".",rb(r),s)  = sum(g ,vfm(f,g,r,s) );
vafmtot(".",g,rb(r),s) = sum(i ,vafm(i,g,r,s));
vafmtot(i,".",rb(r),s) = sum(g ,vafm(i,g,r,s));
ns0tot(".",rb(r),s)    = sum((i,mkt),ns0(i,mkt,r,s)   );
ns0tot(i,rb(r),".")    = sum((s,mkt),ns0(i,mkt,r,s)   );
nd0tot(".",rb(r),s)    = sum((i,mkt),nd0(i,mkt,r,s)   );
nd0tot(i,rb(r),".")    = sum((s,mkt),nd0(i,mkt,r,s)   );
md0tot(".",rb(r),s)    = sum(i ,md0(i,r,s)   );
md0tot(i,rb(r),".")    = sum(s ,md0(i,r,s)   );
cd0tot(".",rb(r),s,h)  = sum(i ,cd0(i,r,s,h) );

vom(i,rb(r),s)$(vom(i,r,s)<reltol*min(vomtot(".",r,s),vomtot(i,r,"."))) = 0;
vfm(f,g,rb(r),s) $(vfm(f,g,r,s)	< reltol*min(vfmtot(".",g,r,s) ,vfmtot(f,".",r,s)))  = 0;
vafm(i,g,rb(r),s)$(vafm(i,g,r,s)< reltol*min(vafmtot(".",g,r,s),vafmtot(i,".",r,s))) = 0;
ns0(i,mkt,rb(r),s) $(ns0(i,mkt,r,s)<reltol*min(ns0tot(".",r,s)   ,ns0tot(i,r,".")))    = 0;
cd0(i,rb(r),s,h) $(cd0(i,r,s,h)	< reltol*min(cd0tot(".",r,s,h) ,a0(i,r,s)))          = 0;

nd0(i,mkt,rb(r),s)$(nd0(i,mkt,r,s)<reltol*min(nd0tot(".",r,s)   ,nd0tot(i,r,".")))    = 0;
md0(i,rb(r),s)   $(md0(i,r,s)	< reltol*min(md0tot(".",r,s)   ,md0tot(i,r,".")))    = 0;

nz("vom" ,"reltol") = card(vom)  - nz("vom" ,"card");
nz("vfm" ,"reltol") = card(vfm)  - nz("vfm" ,"card");
nz("vafm","reltol") = card(vafm) - nz("vafm","card");
nz("ns0" ,"reltol") = card(ns0)  - nz("ns0" ,"card");
nz("nd0" ,"reltol") = card(nd0)  - nz("nd0" ,"card");
nz("md0" ,"reltol") = card(md0)  - nz("md0" ,"card");
nz("cd0" ,"reltol") = card(cd0)  - nz("cd0" ,"card");
option nz:0;
display nz;

*	Checking equilibrium conditions after filtering:

$include %gams.scrdir%chkmodel

parameter	incomeadjust(r,s,h)	Household income adjustment (% consumption);
incomeadjust(rb(r),s,h)$c0(r,s,h) = 100 * (c0(r,s,h) + sav0(r,s,h) - sum(f,evomh(f,r,s,h)) - sum(trn,hhtrn0(r,s,h,trn)))/c0(r,s,h);
option incomeadjust:1:2:1;
display incomeadjust;

*	Balance household budgets with "financial assistance":

hhtrn0(rb(r),s,h,"hfinval") = hhtrn0(r,s,h,"hfinval") + incomeadjust(r,s,h)/100 * c0(r,s,h);

$include gtapwindc_calib.gms

*	Checking equilibrium conditions after calibrating:

$include %gams.scrdir%chkmodel

execute_unload '%dsout%',
	r,g,i,f,s,h,sf,mf, vom, rto, vafm, vfm, rtf0, rtf, a0, rtd0, yd0, nd0, md0,
	ns0, xs0, rtm0, c0, cd0, evom, evomh, hhtrn0, sav0, vim, vxmd, pvxmd,
	pvtwr, rtxs, rtms, vtwr, vtw, vst, vb, esube, esubva, etrndn, etrae,
	esubdm, esubm;

option vom:3:0:1;
display vom;