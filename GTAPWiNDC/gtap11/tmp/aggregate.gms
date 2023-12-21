$title	Aggregation Program for the GTAP11 Database

$if not set target $set target msmr
$if not set yr     $set yr 2017
$if not set reltol $set reltol 4
$if not set ds     $set ds gtapingams_%reltol%
$if not set output $set output %target%
$if not set datadir $set datadir %system.fp%%yr%/

$include "%system.fp%gtapdata"

*	Calling program points to the target mapping:

$include defines\%target%

parameter	mapbug(*)	Problems with mapping;
mapbug(r) = 1 - sum(mapr(r,rr),1);
abort$card(mapbug)	"Error in mapr -- each r must be uniquely mapped.",mapbug;
mapbug(rr) = (sum(mapr(r,rr),1) = 0);
abort$card(mapbug)	"Error in mapr -- each rr must have some constituents.",mapbug;
mapbug(i) = 1 - sum(mapi(i,ii),1);
abort$card(mapbug)	"Error in mapi -- each i must be uniquely mapped.",mapbug;
mapbug(ii) = (sum(mapi(i,ii),1) = 0);
abort$card(mapbug)	"Error in mapi -- each ii must have some constituents.",mapbug;
mapbug(f) = 1 - sum(mapf(f,ff),1);
abort$card(mapbug)	"Error in mapf -- each f must be uniquely mapped.",mapbug;
mapbug(ff) = (sum(mapf(f,ff),1) = 0);
abort$card(mapbug)	"Error in mapf -- each ff must have some constituents.",mapbug;

alias (i,j,k), (ii,jj,kk);
alias (r,s), (rr,ss);

alias (maps,mapr), (mapi,mapj);
set  mapg(*,*)/c.c, i.i, g.g /;
mapg(i,ii) = mapi(i,ii);

set	gg(*)	All goods in aggregate model plus C - G - I /
		c	Household,
		g	Government consumption,
		i	Investment/;

gg(ii) = ii(ii);
option gg:0:0:1;
display gg;

abort$sum(ii$(sameas(ii,"c") or sameas(ii,"g") or sameas(ii,"i")),1) "Invalid identifier: C, G and I are reserved.";

parameters
	vom_(*,rr)	Gross output
	vfm_(ff,*,rr)	Endowments - Firms' purchases at market prices,
	vdfm_(ii,*,rr)	Intermediates - firms' domestic purchases at market prices,
	vifm_(ii,*,rr)	Intermediates - firms' imports at market prices,
	vxmd_(ii,rr,ss)	Trade - bilateral exports at market prices,
	vst_(ii,rr)	Trade - exports for international transportation
	vtwr_(ii,jj,rr,ss)	Trade - Margins for international transportation at world prices,

	pop_(rr)	Population,

$ontext
	evt_(ii,rr,rr)	Volume of energy trade (mtoe),
	evd_(ii,*,rr)	Domestic energy use (mtoe),
	evi_(ii,*,rr)	Imported energy use (mtoe),
	eco2d_(ii,*,rr)	CO2 emissions in domestic fuels - Mt CO2",
	eco2i_(ii,*,rr)	CO2 emissions in foreign fuels - Mt CO2",
$offtext

	rto_(*,rr)	Output (or income) subsidy rates
	rtf_(ff,*,rr)	Primary factor and commodity rates taxes 
	rtfd_(ii,*,rr)	Firms domestic tax rates
	rtfi_(ii,*,rr)	Firms' import tax rates
	rtxs_(ii,rr,ss)	Export subsidy rates
	rtms_(ii,rr,ss)	Import taxes rates,

	subp_(ii,rr)	"CDE substitution parameter",
	incp_(ii,rr)	"CDE expansion parameter",
	esbv_(ii,rr)	"CES elast. of subs. for primary factors in production",
	sbvr_(ii,rr)	"CES between primary factors in production at region level",
	esbd_(ii,rr)	"Armington CES elast. of subs. for domestic/imported allocation",
	sbdr_(ii,rr)	"Armington CES for domestic/imported allocation at region level",
	esbm_(ii,rr)	"Armington CES elast. of subs. for regional allocation of imports",
	sbmr_(ii,rr)	"Armington CES for regional allocation of imports at region level",
	esbs_(ii)	"CES elast. of subs. for international transport margin services",
	esbg_(rr)		"CES elast. of subs. for government demand",
	esbi_(rr)		"CES elast. of subs. for investment",
	etre_(ff,rr) 	"CET elast. of transformation bet. sectors for sluggish primary factors"

	eta_(ii,rr)	"Income elasticity of demand",
	aues_(ii,jj,rr)	"Allen-Uzawa elasticity substitution matrix",

	eco2d_(ii,*,rr)	"CO2 emissions from domestic product (Mt)",
	eco2i_(ii,*,rr)	"CO2 Emissions from imported product (Mt)",

	nco2emit_(pol,*,*,rr)		'Industrial and household non-CO2 emissions, mmt',
	nco2process_(pol,*,*,rr)	'IO-based process emissions, mmt',
	landuse_(pol,lu,rr)		'Land-use emissions, mmt'

	evd_(ii,*,rr)	Domestic energy use (mtoe),
	evi_(ii,*,rr)	Imported energy use (mtoe),
	evt_(ii,rr,rr)	Volume of energy trade (mtoe);

file kcon/''/; put kcon;

putclose //"Aggregating vom."/;
$batinclude "%system.fp%aggr" vom  g r   vom_
putclose //"Aggregating vst."/;
$batinclude "%system.fp%aggr" vst  i r   vst_
putclose //"Aggregating vfm."/;
$batinclude "%system.fp%aggr" vfm  f j r vfm_
putclose //"Aggregating vdfm."/;
$batinclude "%system.fp%aggr" vdfm i g r vdfm_
putclose //"Aggregating vifm."/;
$batinclude "%system.fp%aggr" vifm i g r vifm_
putclose //"Aggregating vxmd."/;
$batinclude "%system.fp%aggr" vxmd i r s vxmd_
putclose //"Aggregating vtwr."/;
$batinclude "%system.fp%aggr"  vtwr i j r s vtwr_
putclose //"Aggregating pop."/;
$batinclude "%system.fp%aggr" pop r pop_

putclose //"Aggregating eco2d."/;
$batinclude "%system.fp%aggr" eco2d i g r eco2d_
putclose //"Aggregating eco2i."/;
$batinclude "%system.fp%aggr" eco2i i g r eco2i_

putclose //"Aggregating evd."/;
$batinclude "%system.fp%aggr" evd i g r evd_
putclose //"Aggregating evi."/;
$batinclude "%system.fp%aggr" evi i g r evi_
putclose //"Aggregating evt."/;
$batinclude "%system.fp%aggr" evt i r s evt_

putclose //"Aggregating nco2emit."/;
nco2emit_(pol,ii,gg,rr) = sum((mapi(i,ii),i_f,mapg(g,gg),mapr(r,rr))$sameas(i_f,i),nco2emit(pol,i_f,g,r));
nco2emit_(pol,ff,gg,rr) = sum((mapf(f,ff),i_f,mapg(g,gg),mapr(r,rr))$sameas(i_f,f),nco2emit(pol,i_f,g,r));
*.nco2emit_(pol,"output",gg,rr) = sum((mapg(g,gg),mapr(r,rr)),nco2emit(pol,"output",g,r));

putclose //"Aggregating nco2process."/;
nco2process_(pol,ii,jj,rr)	= sum((mapi(i,ii),i_o,mapj(j,jj),mapr(r,rr))$sameas(i_o,i), nco2process(pol,i_o,j,r));
nco2process_(pol,"output",jj,rr) = sum((mapj(j,jj),mapr(r,rr)), nco2process(pol,"output",j,r));

landuse_(pol,lu,rr) = sum(mapr(r,rr),landuse(pol,lu,r));
parameter	vcm(i,r)	Value of consumption expenditure;
vcm(j,r) = vdfm(j,"c",r)*(1+rtfd(j,"c",r)) + 
	   vifm(j,"c",r)*(1+rtfi(j,"c",r));

parameter	vcm_(ii,rr)	Value of consumption expenditure (aggregated);
vcm_(ii,rr) = sum((mapi(i,ii),mapr(r,rr)), vcm(i,r));

putclose //"Aggregating eta."/;

parameter	thetac_(ii,rr)	Aggregate value shares in final demand; 
thetac_(ii,rr) = vcm_(ii,rr)/sum(jj,vcm_(jj,rr));

subp_(ii,rr)$vcm_(ii,rr) = 
	sum((mapi(i,ii),mapr(r,rr)), vcm(i,r)*subp(i,r))/vcm_(ii,rr);

eta_(ii,rr)$vcm_(ii,rr) = 
	sum((mapi(i,ii),mapr(r,rr)), vcm(i,r)*eta(i,r))/vcm_(ii,rr);

putclose //"Aggregating incp."/;

*	For the time being, introduce an expenditure average:

incp_(ii,rr)$vcm_(ii,rr) = sum((mapi(i,ii),mapr(r,rr)),
	vcm(i,r)*incp(i,r))/vcm_(ii,rr);

*	First, convert tax rates into tax payments:

rto(g,r)    = rto(g,r)*vom(g,r);
rtf(f,j,r)  = rtf(f,j,r) * vfm(f,j,r);
rtfd(i,g,r) = rtfd(i,g,r) * vdfm(i,g,r);
rtfi(i,g,r) = rtfi(i,g,r) * vifm(i,g,r);
rtms(i,r,s) = rtms(i,r,s)*((1-rtxs(i,r,s)) * vxmd(i,r,s) + sum(j,vtwr(j,i,r,s)));
rtxs(i,r,s) = rtxs(i,r,s) * vxmd(i,r,s);

*	Aggregate:

putclose //"Aggregating rto."/;
$batinclude "%system.fp%aggr" rto g r   rto_
putclose //"Aggregating rtf."/;
$batinclude "%system.fp%aggr" rtf f j r rtf_
putclose //"Aggregating rtfd."/;
$batinclude "%system.fp%aggr" rtfd i g r rtfd_
putclose //"Aggregating rtfi."/;
$batinclude "%system.fp%aggr" rtfi i g r rtfi_
putclose //"Aggregating rtxs."/;
$batinclude "%system.fp%aggr" rtxs i r s rtxs_
putclose //"Aggregating rtms."/;
$batinclude "%system.fp%aggr" rtms i r s rtms_
putclose //"Aggregating vcm."/;
$batinclude "%system.fp%aggr"  vcm i r vcm_

*	First aggregate commodities at the disaggregate regional level:

putclose //"Aggregating epsilon and aues."/;
parameter	epsilon_reg(ii,jj,r)	Own and cross price elasticities of demand for aggregate goods at the regional level;
epsilon_reg(ii,jj,r)$sum((mapi(i,ii),mapj(j,jj)), vcm(i,r)*vcm(j,r))
	  = sum((mapi(i,ii),mapj(j,jj)), aues(i,j,r)*vcm(i,r)*vcm(j,r))
	  / sum((mapi(i,ii),mapj(j,jj)), vcm(i,r)*vcm(j,r)) * sum(mapj(j,jj),thetac(j,r))


parameter	regshare(ii,jj,r,rr)	Regional shares of of each AUES term;
regshare(ii,jj,mapr(r,rr))$(sum(mapi(i,ii),vcm(i,r))*sum(mapj(j,jj),vcm(j,r)))
	=                 sum(mapi(i,ii),vcm(i,r))*sum(mapj(j,jj),vcm(j,r)) /
	  sum(r.local$mapr(r,rr), sum(mapi(i,ii),vcm(i,r))*sum(mapj(j,jj),vcm(j,r)));

*	Form the region-weighted price elasticities to impute the new AUES:

aues_(ii,jj,rr)$(thetac_(ii,rr)*thetac_(jj,rr)) = 
	sum(mapr(r,rr), epsilon_reg(ii,jj,r) * regshare(ii,jj,r,rr)) / thetac_(jj,rr);

*	The calculated AUES matrix may not satisfy the adding-up condition, so we scale the 
*	off-diagonal:

parameter	offdiagscale	Off diagonal scale factor;
offdiagscale(ii,rr)$sum(jj$(not sameas(ii,jj)), aues_(ii,jj,rr)*thetac_(jj,rr))
	= -thetac_(ii,rr)*aues_(ii,ii,rr) / sum(jj$(not sameas(ii,jj)), aues_(ii,jj,rr)*thetac_(jj,rr));
display offdiagscale;

aues_(ii,jj,rr)$(not sameas(ii,jj)) = aues_(ii,jj,rr) * offdiagscale(ii,rr);


parameter	aueschk		Homogeneity check on source dataset,
		aueschk_	Homogeneity check on aggregated dataset;

aueschk(i,r)    = round(sum(j, thetac(j,r)*aues(i,j,r)),4);
aueschk_(ii,rr) = round(sum(jj, aues_(ii,jj,rr)*thetac_(jj,rr)),4);

display$card(aueschk) "Homogeneity check for AUES fails (source data).", aueschk;
display$card(aueschk_) "Homogeneity check for AUES fails (aggregated data).", aueschk_;

*.abort$card(aueschk)  "Homogeneity check for AUES fails (source data).", aueschk;

*.abort$card(aueschk_) "Homogeneity check for AUES fails (aggregated data).", aueschk_;

*	The convert tax flows back to rates:

putclose //"Recalculating tax rates and other elasticities."/;

rto_(gg,rr)$vom_(gg,rr) = rto_(gg,rr)/vom_(gg,rr);
rtf_(ff,jj,rr)$vfm_(ff,jj,rr)  = rtf_(ff,jj,rr) / vfm_(ff,jj,rr);
rtfd_(ii,gg,rr)$ vdfm_(ii,gg,rr) = rtfd_(ii,gg,rr) / vdfm_(ii,gg,rr);
rtfi_(ii,gg,rr)$ vifm_(ii,gg,rr) = rtfi_(ii,gg,rr) / vifm_(ii,gg,rr);
rtxs_(ii,rr,ss)$ vxmd_(ii,rr,ss) = rtxs_(ii,rr,ss) / vxmd_(ii,rr,ss);
rtms_(ii,rr,ss)$((1-rtxs_(ii,rr,ss)) * vxmd_(ii,rr,ss) + sum(jj,vtwr_(jj,ii,rr,ss)))
	 = rtms_(ii,rr,ss)/((1-rtxs_(ii,rr,ss)) * vxmd_(ii,rr,ss) + sum(jj,vtwr_(jj,ii,rr,ss)));

parameter
     	esubva_(ii)	"CES elasticity of substitution for primary factors",
     	esubdm_(ii)	"Armington elasticity of substitution D versus M",
	etaf_(ff)	"CET elasticity of transformation for sluggish factors";

esubdm_(ii)$sum(mapi(i,ii), sum((g,r), vdfm(i,g,r)+vifm(i,g,r)))
	= sum(mapi(i,ii), sum((g,r), vdfm(i,g,r)+vifm(i,g,r))*esubdm(i)) /
	  sum(mapi(i,ii), sum((g,r), vdfm(i,g,r)+vifm(i,g,r)));

esubva_(jj)$sum(mapi(j,jj), sum((f,r), vfm(f,j,r)))
	= sum(mapi(j,jj), sum((f,r), vfm(f,j,r)*esubva(j))) /
	      sum(mapi(j,jj), sum((f,r), vfm(f,j,r)));

etaf_(ff)$(smax(mapf(f,ff),etaf(f))=inf) = inf;
etaf_(ff)$((smax(mapf(f,ff),etaf(f))<inf) and sum((jj,rr),vfm_(ff,jj,rr))) = 
	sum(mapf(f,ff), sum((j,r), vfm(f,j,r)*etaf(f))) / sum(mapf(f,ff), sum((j,r), vfm(f,j,r)));
display etaf, etaf_;

parameter	beta(ii,r)	Share of commodity ii demand in constituent region r;
loop((ii,rr)$thetac_(ii,rr),
  beta(ii,r)$mapr(r,rr) = sum(mapi(i,ii),vcm(i,r))/vcm_(ii,rr));

parameter	epsiloneta	Alternative demand elasticity estimates;
epsiloneta(ii,rr,"epsilon","aues") = aues_(ii,ii,rr) * thetac_(ii,rr);
epsiloneta(ii,rr,"epsilon","ces") = 
	sum(mapr(r,rr), beta(ii,r) * 
	sum(mapi(i,ii), (1 - 1/thetac_(ii,rr))/(1 - 1/thetac(i,r)) * 
		thetac(i,r)/thetac_(ii,rr) * epsilon(i,r)));
epsiloneta(ii,rr,"epsilon","cde") = -subp_(ii,rr) * sqr(1-thetac_(ii,rr))
		- thetac_(ii,rr)*sum(kk,thetac_(kk,rr)*subp_(kk,rr))
		+ sqr(thetac_(ii,rr))*subp_(ii,rr);
epsiloneta(ii,rr,"eta","eta") = eta_(ii,rr);
epsiloneta(ii,rr,"eta","cde") = (incp_(ii,rr)*(1-subp_(ii,rr)) + 
		 sum(kk,thetac_(kk,rr)*incp_(kk,rr)*subp_(kk,rr))) / 
			sum(kk,thetac_(kk,rr)*incp_(kk,rr)) 
		+ (SUBP_(ii,rr) - sum(kk,thetac_(kk,rr)*subp_(kk,rr)));
option epsiloneta:3:2:2;
display epsiloneta;

parameter	demandelast	Demand elasticities (disaggregate vs. aggregate model);
loop((mapr(r,rr),mapi(i,ii))$thetac(i,r),
	demandelast(rr,ii,r,i,"epsilon") = epsilon(i,r);
	demandelast(rr,ii,r,i,"eta")     = eta(i,r);
	demandelast(rr,ii,r,i,"theta")   = thetac(i,r);
	demandelast(rr,ii,r,i,"theta*")  = thetac_(ii,rr);
	demandelast(rr,ii,r,i,"eta*")    = eta_(ii,rr);
	demandelast(rr,ii,r,i,"epsilon*")= epsiloneta(ii,rr,"epsilon","aues"););
option demandelast:3:4:1;
display demandelast;

set	md	Additional metadata /
	aggregate_date		"%system.date%",
	aggregate_inputdata	"%system.fp%%yr%%system.dirsep%%ds%.gdx"
	aggregate_filesys	"%system.filesys%",
	aggregate_username	"%system.username%",
	aggregate_computername	"%system.computername%",
	aggregate_gamsversion	"%system.gamsversion%",
	aggregate_gamsprogram	"%system.fp%%system.fn%%system.fe%"/;

*	Add the md elements to meta being sure to include the
*	descriptive text:

metadata(md) = md(md);

*	GWP indices are aggregated as weighted mean

parameter gwp_(pol,rr,ar);
gwp_(pol,rr,ar)$(sum(r$(mapr(r,rr)*gwp(pol,r,ar)),(sum((i_f,g), nco2emit(pol,i_f,g,r))+ sum((i_o,j), nco2process(pol,i_o,j,r)) + sum(lu, landuse(pol,lu,r)))))
 = sum(r$mapr(r,rr), gwp(pol,r,ar)*(sum((i_f,g), nco2emit(pol,i_f,g,r))+ sum((i_o,j), nco2process(pol,i_o,j,r)) + sum(lu, landuse(pol,lu,r))))/
	sum(r$(mapr(r,rr)*gwp(pol,r,ar)),(sum((i_f,g), nco2emit(pol,i_f,g,r))+ sum((i_o,j), nco2process(pol,i_o,j,r)) + sum(lu, landuse(pol,lu,r))));	

$set fs %system.dirsep%

putclose //"Unloading dataset."/;
*.execute_unload '%yr%%fs%%output%.gdx', 
execute_unload '%yr%%fs%%output%_%yr%.gdx', 
	gg=g, rr=r, ff=f, ii=i, pol, 
	vfm_=vfm, vdfm_=vdfm, vifm_=vifm,vxmd_=vxmd, vst_=vst, vtwr_=vtwr, 
	rto_=rto, rtf_=rtf, rtfd_=rtfd, rtfi_=rtfi, rtxs_=rtxs, rtms_=rtms, 
	pop_=pop, metadata,
	esubdm_=esubdm, esubva_=esubva, etaf_=etaf,
	eco2d_=eco2d, eco2i_=eco2i, 
	evd_=evd, evi_=evi, evt_=evt,
	nco2emit_=nco2emit, nco2process_=nco2process, landuse_=landuse,
	eta_=eta, aues_=aues, incp_=incp, subp_=subp, metadata, gwp_=gwp;

putclose //"All done with aggregation"/;
