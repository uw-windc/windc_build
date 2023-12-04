$title	Filter the GTAP-WINDC Database

*	Read the data:

$if not set ds $set ds 43

$if not set gtap_version $include "gtapingams.gms"

$if not set datasets $set datasets 2017

$set dsout              %datasets%/gtapwindc/%ds%_filtered

$if not defined y_ $include %system.fp%gtapwindc_data

set	prec	Alternative precisions (decimals) /4*8/;

$macro	nzcount(item,domain,prec)  sum((&&domain&),1$round(&&item&(&&domain&),prec.val))

set	m	Matricies for filtering /
		vfm, vafm, vom, vxmd, ns0, yl0, nd0, md0, cd0 /

set	d(*)	Domains;

set	md(m,d<) /
		vfm."f,g,r,s"
		vafm."i,g,r,s"
		vom."g,r,s"
		vxmd."i,r,rr"
		ns0."i,r,s"
		yl0."i,r,s"
		nd0."i,r,s"
		md0."i,r,s" 
		cd0."i,r,s,h" 
		/;

parameter	nz(m,*)	Number of nonzeros;


nz("vfm" ,"card") = card(vfm) ;
nz("vafm","card") = card(vafm);
nz("vxmd","card") = card(vxmd);
nz("ns0" ,"card") = card(ns0) ;
nz("yl0" ,"card") = card(yl0) ;
nz("nd0" ,"card") = card(nd0) ;
nz("md0" ,"card") = card(md0) ;
nz("cd0" ,"card") = card(cd0) ;



nz("vfm" ,prec) = card(vfm)  - nzcount(vfm ,"f,g,r,s",prec);
nz("vafm",prec) = card(vafm) - nzcount(vafm,"i,g,r,s",prec);
nz("vxmd",prec) = card(vxmd) - nzcount(vxmd,"i,r,rr",prec );
nz("ns0" ,prec) = card(ns0)  - nzcount(ns0 ,"i,r,s",prec  );
nz("yl0" ,prec) = card(yl0)  - nzcount(yl0 ,"i,r,s",prec  );
nz("nd0" ,prec) = card(nd0)  - nzcount(nd0 ,"i,r,s",prec  );
nz("md0" ,prec) = card(md0)  - nzcount(md0 ,"i,r,s",prec  );
nz("cd0" ,prec) = card(cd0)  - nzcount(cd0 ,"i,r,s,h",prec);




*	RELTOL changes data footprint:

$if not set reltol $set reltol 4

*	ABSTOL does not have a big effect:

$if not set abstol $set abstol 7

parameter	reltol	Relative filter tolerance /1e-%reltol%/,
		abstol	Absolute filter tolerance /1e-%abstol%/;

vfm(f,g,r,s) $(vfm(f,g,r,s) < abstol) = 0;
vafm(i,g,r,s)$(vafm(i,g,r,s)< abstol) = 0;
vxmd(i,r,rr) $(vxmd(i,r,rr) < abstol) = 0;
ns0(i,r,s)   $(ns0(i,r,s)   < abstol) = 0;
yl0(i,r,s)   $(yl0(i,r,s)   < abstol) = 0;
nd0(i,r,s)   $(nd0(i,r,s)   < abstol) = 0;
md0(i,r,s)   $(md0(i,r,s)   < abstol) = 0;
cd0(i,r,s,h) $(cd0(i,r,s,h) < abstol) = 0;
vst(j,r)     $(vst(j,r)     < abstol) = 0;

nz("vfm" ,"abstol") = card(vfm)  - nz("vfm" ,"card");
nz("vafm","abstol") = card(vafm) - nz("vafm","card");
nz("vxmd","abstol") = card(vxmd) - nz("vxmd","card");
nz("ns0" ,"abstol") = card(ns0)  - nz("ns0" ,"card");
nz("yl0" ,"abstol") = card(yl0)  - nz("yl0" ,"card");
nz("nd0" ,"abstol") = card(nd0)  - nz("nd0" ,"card");
nz("md0" ,"abstol") = card(md0)  - nz("md0" ,"card");
nz("cd0" ,"abstol") = card(cd0)  - nz("cd0" ,"card");


parameter	vfmtot, vafmtot, vxmdtot, ns0tot, yl0tot, nd0tot, md0tot, cd0tot;
vfmtot(".",g,r,s)  = sum(f ,vfm(f,g,r,s) );
vfmtot(f,".",r,s)  = sum(g ,vfm(f,g,r,s) );
vafmtot(".",g,r,s) = sum(i ,vafm(i,g,r,s));
vafmtot(i,".",r,s) = sum(g ,vafm(i,g,r,s));
vxmdtot(i,r,".")   = sum(rr,vxmd(i,r,rr) );
vxmdtot(i,".",rr)  = sum(r ,vxmd(i,r,rr) );
ns0tot(".",r,s)    = sum(i ,ns0(i,r,s)   );
ns0tot(i,r,".")    = sum(s ,ns0(i,r,s)   );
yl0tot(".",r,s)    = sum(i ,yl0(i,r,s)   );
yl0tot(i,r,".")    = sum(s ,yl0(i,r,s)   );
nd0tot(".",r,s)    = sum(i ,nd0(i,r,s)   );
nd0tot(i,r,".")    = sum(s ,nd0(i,r,s)   );
md0tot(".",r,s)    = sum(i ,md0(i,r,s)   );
md0tot(i,r,".")    = sum(s ,md0(i,r,s)   );
cd0tot(".",r,s,h)  = sum(i ,cd0(i,r,s,h) );

vfm(f,g,r,s) $(vfm(f,g,r,s)		< reltol*min(vfmtot(".",g,r,s) ,vfmtot(f,".",r,s)))  = 0;
vafm(i,g,r,s)$(vafm(i,g,r,s)	< reltol*min(vafmtot(".",g,r,s),vafmtot(i,".",r,s))) = 0;
vxmd(i,r,rr) $(vxmd(i,r,rr)		< reltol*min(vxmdtot(i,".",r)  ,vxmdtot(i,r,".")))   = 0;
ns0(i,r,s)   $(ns0(i,r,s)		< reltol*min(ns0tot(".",r,s)   ,ns0tot(i,r,".")))    = 0;
yl0(i,r,s)   $(yl0(i,r,s)		< reltol*min(yl0tot(".",r,s)   ,yl0tot(i,r,".")))    = 0;
nd0(i,r,s)   $(nd0(i,r,s)		< reltol*min(nd0tot(".",r,s)   ,nd0tot(i,r,".")))    = 0;
md0(i,r,s)   $(md0(i,r,s)		< reltol*min(md0tot(".",r,s)   ,md0tot(i,r,".")))    = 0;
cd0(i,r,s,h) $(cd0(i,r,s,h)		< reltol*min(cd0tot(".",r,s,h) ,a0(i,r,s)))          = 0;

nz("vfm" ,"reltol") = card(vfm)  - nz("vfm" ,"card");
nz("vafm","reltol") = card(vafm) - nz("vafm","card");
nz("vxmd","reltol") = card(vxmd) - nz("vxmd","card");
nz("ns0" ,"reltol") = card(ns0)  - nz("ns0" ,"card");
nz("yl0" ,"reltol") = card(yl0)  - nz("yl0" ,"card");
nz("nd0" ,"reltol") = card(nd0)  - nz("nd0" ,"card");
nz("md0" ,"reltol") = card(md0)  - nz("md0" ,"card");
nz("cd0" ,"reltol") = card(cd0)  - nz("cd0" ,"card");
option nz:0;
display nz;




*	Identify the nonzero structure:

y_(g,r,s)     = vom(g,r,s       );
x_(i,r)       = vxm(i,r         );
n_(i,r)       = vnm(i,r         );
pn_(i,r)      = n_(i,r          );
z_(i,r,s)     = a0(i,r,s        );
c_(r,s,h)     = c0(r,s,h        );
ft_(sf,r,s)   = evom(sf,r,s     );
m_(i,r)       = vim(i,r         );
yt_(j)        = vtw(j           );
py_(g,r,s)    = vom(g,r,s       );
pz_(i,r,s)    = a0(i,r,s        );
p_(i,r)       = sum(s,xs0(i,r,s));
pc_(r,s,h)    = c0(r,s,h        );
pf_(f,r,s)    = evom(f,r,s      );
ps_(sf,g,r,s) = vfm(sf,g,r,s    );
pm_(i,r)      = vim(i,r         );
pt_(j)        = vtw(j           );
rh_(r,s,h)    = c0(r,s,h        );

*	Cinch the zero profit conditions:

vom(y_(g,r,s)) = (1/(1-rto(g,r))) * (sum(i,vafm(i,g,r,s)) + sum(f,vfm(f,g,r,s)*(1+rtf0(f,g,r))));
vnm(i,r) = sum(s,ns0(i,r,s));
a0(i,r,s) = yl0(i,r,s)*(1+rtd0(i,r,s)) + nd0(i,r,s)*(1+rtd0(i,r,s)) + md0(i,r,s)*(1+rtm0(i,r,s));
evom(f,r,s) = sum(g,vfm(f,g,r,s));
c0(r,s,h) = sum(i,cd0(i,r,s,h));
vnm(i,r) = sum(s,ns0(i,r,s));
vim(i,r) = sum(rr, vxmd(i,rr,r)*pvxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r)*pvtwr(i,rr,r)));
vtw(j) = sum(r,vst(j,r));

execute_unload '%dsout%',
	r,g,i,f,s,h,sf,mf,
	vom, vafm, vfm, yl0, a0,
	md0, xs0, nd0, ns0, c0, cd0, evom, evomh, 
	rtd, rtd0, rtm, rtm0, esube,
	etrndn, hhtrn0, sav0,
	rto, rtf, rtf0, vim, vxmd, pvxmd, pvtwr, rtxs, rtms, vtw, vtwr, vst, vb,
	esubva,  etrae, esubdm, esubm;
