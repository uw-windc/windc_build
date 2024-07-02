$title	Filter and Save Trade Data

singleton set	rb(r) /usa/;

parameter	mktchk;
mktchk(itrd(i),rb(r),s,"supply") = round(vom(i,r,s) - (xs_0(i,s) + sum(ss,bvdfm(i,s,ss))),3);
mktchk(itrd(i),rb(r),s,"demand") = round(a0(i,rb,s) - (bvifm(i,s)*(1+rtm0(i,r,s)) +
				sum(ss,bvdfm(i,ss,s)*(1+rtd0(i,r,s)))),3);
option mktchk:3:3:1;
display mktchk;

parameter	penalty /1000/;

nonnegative
variable	BVDFM_(i,s,ss), BVIFM_(i,s);

variable	OBJ;

equation	objdef, supply, demand, imports;

objdef..	OBJ =e= sum((itrd(i),s,ss)$bvdfm(i,s,ss), 
			   bvdfm(i,s,ss)*sqr(BVDFM_(i,s,ss)/bvdfm(i,s,ss)-1)) +
			sum((itrd(i),s)$bvifm(i,s), bvifm(i,s)*sqr(BVIFM_(i,s)/bvifm(i,s)-1)) +
			sum((itrd(i),s,ss)$(not bvdfm(i,s,ss)), penalty * BVDFM_(i,s,ss)) +
			sum((itrd(i),s)$(not bvifm(i,s)), penalty * BVIFM_(i,s));

supply(itrd(i),rb(r),s)..  vom(i,r,s) =e= xs_0(i,s) + sum(ss,BVDFM_(i,s,ss));

demand(itrd(i),rb(r),s).. a0(i,r,s) =e= sum(ss,	BVDFM_(i,ss,s)*(1+rtd0(i,r,s))) + 
						BVIFM_(i,s)    *(1+rtm0(i,r,s));

imports(itrd(i),rb(r))..  vim(i,r) =e= sum(s,BVIFM_(i,s));

model lsqr /objdef, supply, demand/;

option vom:3:0:1; display vom;
option a0:3:0:1; display a0;

BVDFM_.L(i,s,ss) = bvdfm(i,s,ss);
BVIFM_.L(i,s) = bvifm(i,s);

BVDFM_.FX(i,s,ss)$(sameas(s,"rest") or sameas(ss,"rest")) = 0;
BVIFM_.FX(i,"rest") = 0;

option qcp=cplex;
SOLVE lsqr USING QCP minimizing OBJ;

parameter	abstol	Absolute tolerance /1e-5/
		reltol	Relative tolerance /1e-3/;

bvdfm(i,s,ss)$(bvdfm(i,s,ss)<abstol) = 0;
bvifm(i,s)$(bvifm(i,s)<abstol) = 0;
bvdfm(i,s,s)$(not bvdfm(i,s,s)) = 0.5 * vom(i,rb,s);
SOLVE lsqr USING QCP minimizing OBJ;

BVDFM_.FX(i,s,ss)$(bvdfm_.L(i,s,ss)<abstol) = 0;
BVIFM_.FX(i,s)$(bvifm_.l(i,s)<abstol) = 0;
SOLVE lsqr USING QCP minimizing OBJ;

parameter	bd0(i,r,s,ss)	Bilateral trade
		vifm(i,r,s)	Imports
		yd0(i,r,s)	Domestic supply and demand;

bd0(itrd(i),rb,s,ss) = BVDFM_.L(i,s,ss);
option bvdfm:3:0:1;
display bvdfm;

vifm(itrd(i),rb,s) = BVIFM_.L(i,s);

a0(itrd(i),rb,s) = sum(ss,	bd0(i,rb,ss,s)*(1+rtd0(i,rb,s))) + 
				vifm(i,rb,s)    *(1+rtm0(i,rb,s));
xs0(itrd(i),rb,s) = xs_0(i,s);
nd0(itrd(i),rb,s) = nd_0(i,s);
md0(itrd(i),rb,s) = md_0(i,s);
yd0(itrd(i),rb,s) = yd_0(i,s);

$exit

set	pnm(i,r)	Pooled national market
	bnm(i,r)	Bilateral national markets;

pnm(i,r) = yes;
bnm(i,r) = no;

$ontext
$model:gtapwindc_b

$sectors:
	Y(g,r,s)$y_(g,r,s)		  ! Production (includes I and G)
	X(i,r)$x_(i,r)			  ! Export demand
	N(i,r)$(pnm(i,r) and n_(i,r))	  ! National market demand (omitted in the bilateral model)
	Z(i,r,s)$z_(i,r,s)		  ! Armington demand
	C(r,s,h)$c_(r,s,h)		  ! Consumption 
	FT(sf,r)$pk_(sf,r)		  ! Specific factor transformation
	FTS(sf,r,s)$evom(sf,r,s)	  ! Specific factor transformation -- state level
	M(i,r)$m_(i,r)			  ! Import
	YT(j)$yt_(j)			  ! Transport

$commodities:
	PY(g,r,s)$py_(g,r,s)		  ! Output price
	PZ(i,r,s)$pz_(i,r,s)		  ! Armington composite price
	PN(i,r)$(pnm(i,r) and pn_(i,r))	  ! National market price (omitted in the bilateral model)
	P(i,r)$p_(i,r)			  ! Export market price
	PC(r,s,h)$pc_(r,s,h)		  ! Consumption price 
	PL(mf,r,s)$pf_(mf,r,s)		  ! Wage income
	PKS(sf,r,s)$evom(sf,r,s)	  ! Capital price by state
	PK(sf,r)$pk_(sf,r)		  ! Capital income
	PS(f,g,r,s)$ps_(f,g,r,s)	  ! Sector-specific primary factors
	PM(i,r)$pm_(i,r)		  ! Import price
	PT(j)$pt_(j)			  ! Transportation services

$consumers:
	RH(r,s,h)$rh_(r,s,h)		  ! Representative household
	GOVT(r)				  ! Public expenditure
	INV(r)				  ! Investment

$prod:Y(g,r,s)$y_(g,r,s) s:0  va:esubva(g) 
	o:PY(g,r,s)	q:vom(g,r,s)	a:GOVT(r) t:rto(g,r)
	i:PZ(i,r,s)	q:vafm(i,g,r,s)	
	i:PS(sf,g,r,s)	q:vfm(sf,g,r,s)  p:(1+rtf0(sf,g,r))  va: a:GOVT(r) t:rtf(sf,g,r)
	i:PL(mf,r,s)	q:vfm(mf,g,r,s)  p:(1+rtf0(mf,g,r))  va: a:GOVT(r) t:rtf(mf,g,r)

*	Export:

$prod:X(i,r)$x_(i,r)  s:esubx(i)
	o:P(i,r)	q:vxm(i,r)
	i:PY(i,r,s)	q:xs0(i,r,s)

*	Supply to the domestic market:

$prod:N(i,r)$(pnm(i,r) and n_(i,r))  s:esubn(i)
	o:PN(i,r)	q:vnm(i,r)
	i:PY(i,r,s)	q:ns0(i,r,s)

$prod:Z(i,r,s)$(pnm(i,r) and z_(i,r,s))  s:esubdm(i)  
	o:PZ(i,r,s)	q:a0(i,r,s)
	i:PN(i,r)	q:nd0(i,r,s)	a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s)) 
	i:PY(i,r,s)	q:yd0(i,r,s)	a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s)) 
	i:PM(i,r)	q:md0(i,r,s)	a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s)) 

$prod:Z(i,r,s)$(bnm(i,r) and z_(i,r,s))  s:esubdm(i)  nm:(2*esubdm(i))  mm(nm):(4*esubdm(i))
	o:PZ(i,r,s)	q:a0(i,r,s)
	i:PY(i,r,ss)	q:vdfm(i,r,ss,s) a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s))  nm:$sameas(s,ss) mm:$(not sameas(s,ss))
	i:PM(i,r)	q:vifm(i,r,s)	 a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s))

$prod:FT(sf,r)$pk_(sf,r)  t:0
	o:PKS(sf,r,s)	q:evom(sf,r,s)
	i:PK(sf,r)	q:(sum(s,evom(sf,r,s)))

$prod:FTS(sf,r,s)$evom(sf,r,s)
	o:PS(sf,g,r,s)	q:vfm(sf,g,r,s)   
	i:PKS(sf,r,s)	q:evom(sf,r,s)

$prod:C(r,s,h)$c_(r,s,h)  s:1
	o:PC(r,s,h)	q:c0(r,s,h)	
	i:PZ(i,r,s)	q:cd0(i,r,s,h)  

*	---------------------------------------------------------------------------
*	These activities are unchanged from the GTAP model:

$prod:M(i,r)$m_(i,r)	s:esubm(i)  rr.tl:0
	o:PM(i,r)	q:vim(i,r)
	i:P(i,rr)	q:vxmd(i,rr,r)	p:pvxmd(i,rr,r) rr.tl:
+		a:GOVT(rr) t:(-rtxs(i,rr,r))	
+		a:GOVT(r)  t:(rtms(i,rr,r)*(1-rtxs(i,rr,r)))
	i:PT(j)#(rr)	q:vtwr(j,i,rr,r) p:pvtwr(i,rr,r) rr.tl: 
+		a:GOVT(r)  t:rtms(i,rr,r)

$prod:YT(j)$yt_(j)  s:1
	o:PT(j)		q:vtw(j)
	i:P(j,r)	q:vst(j,r)

*	---------------------------------------------------------------------------
*	Final demand -- these based on data coming from the WiNDC database:

$demand:RH(r,s,h)$rh_(r,s,h)  
	d:PC(r,s,h)			q:c0(r,s,h)
	e:PL(mf,r,s)			q:evomh(mf,r,s,h)
	e:PK(sf,r)$pk_(sf,r)		q:evomh(sf,r,s,h)
	e:PKS(sf,r,s)$(not pk_(sf,r))	q:evomh(sf,r,s,h)
	e:PC(rnum,"rest","rest")	q:(-sav0(r,s,h)+sum(trn,hhtrn0(r,s,h,trn)))

$demand:GOVT(r)
	d:PY("g",r,s)			q:vom("g",r,s)
	e:PC(rnum,"rest","rest")	q:(-sum((rh_(r,s,h),trn),hhtrn0(r,s,h,trn)))

$demand:INV(r)
	d:PY("i",r,s)			q:vom("i",r,s)
	e:PC(rnum,"rest","rest")	q:(vb(r)+sum(rh_(r,s,h),sav0(r,s,h)))

$offtext
$sysinclude mpsgeset gtapwindc_b

nd0(itrd(i),rb(r),s) = sum(ss,vdfm(i,r,ss,s))-vdfm(i,r,s,s);
md0(itrd(i),rb(r),s) = vifm(i,r,s);
yd0(itrd(i),rb(r),s) = vdfm(i,r,s,s);
ns0(itrd(i),rb(r),s) = sum(ss,vdfm(i,r,s,ss)) - vdfm(i,r,s,s);
vnm(itrd(i),rb(r)) = sum(s,ns0(i,r,s));

gtapwindc_b.workspace = 1024;
gtapwindc_b.iterlim = 0;
$include gtapwindc_b.gen
solve gtapwindc_b using mcp;

bnm(itrd,rb) = yes;
pnm(itrd,rb) = no;
$include gtapwindc_b.gen
solve gtapwindc_b using mcp;


$eolcom !

* Define aggregation to Census divisions

set	r9      Census divisions /
		neg     "New England" 
		mid     "Mid Atlantic" 
		enc     "East North Central" 
		wnc     "West North Central" 
		sac     "South Atlantic" 
		esc     "East South Central" 
		wsc     "West South Central" 
		mtn     "Mountain" 
		pac     "Pacific" /;

set     r9map(r9,r)      Mapping of target regions rr and source regions r /
		   neg.(ct,me,ma,nh,ri,vt)
		   mid.(nj,ny,pa)
		   enc.(il,in,mi,oh,wi)
		   wnc.(ia,ks,mn,mo,ne,nd,sd)
		   sac.(de,fl,ga,md,dc,nc,sc,va,wv)
		   esc.(al,ky,ms,tn)
		   wsc.(ar,la,ok,tx)
		   mtn.(az,co,id,mt,nv,nm,ut,wy)
		   pac.(ak,ca,hi,or,wa) /;


set   r4           Aggregated regions /
               nor    ! northeast
	       mid    ! midwest
	       sou    ! south
	       wes    ! west
      /;

set   r4map(r4,r)   Mapping between census divisions and states /
         nor.(        
               ct     ! connecticut
	       me     ! maine
	       ma     ! massachusetts
	       nh     ! new hampshire
	       ri     ! rhode island
	       vt     ! vermont
	       nj     ! new jersey
	       ny     ! new york
	       pa     ! pennsylvania
             )
         mid.(        
	       in     ! indiana
	       il     ! illinois
	       mi     ! michigan
	       oh     ! ohio
	       wi     ! wisconsin
	       ia     ! iowa
	       ks     ! kansas
	       mn     ! minnesota
	       mo     ! missouri
	       ne     ! nebraska
	       nd     ! north dakota
	       sd     ! south dakota
             )
	 sou.(        
	       dc     ! district of columbia
	       de     ! delaware
	       fl     ! florida
	       ga     ! georgia
	       md     ! maryland
	       nc     ! north carolina
	       sc     ! south carolina
	       va     ! virginia
	       wv     ! west virginia
	       al     ! alabama
	       ky     ! kentucky
	       ms     ! mississippi
	       tn     ! tennessee
	       ar     ! arkansas
	       la     ! louisiana
	       ok     ! oklahoma
	       tx     ! texas
             )
         wes.(        
               az     ! arizona
	       co     ! colorado
	       id     ! idaho
	       nm     ! new mexico
	       mt     ! montana
	       ut     ! utah
	       nv     ! nevada
	       wy     ! wyoming
	       ak     ! alaska
	       ca     ! california
	       hi     ! hawaii
	       or     ! oregon
	       wa     ! washington
             )
     /;
