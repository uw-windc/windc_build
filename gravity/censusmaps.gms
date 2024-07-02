$eolcom !

$if not set mkt $set mkt census

set     censusmap(census,s)      Mapping of census regions to states /
		   neg.(ct,me,ma,nh,ri,vt)
		   mid.(nj,ny,pa)
		   enc.(il,in,mi,oh,wi)
		   wnc.(ia,ks,mn,mo,ne,nd,sd)
		   sac.(de,fl,ga,md,dc,nc,sc,va,wv)
		   esc.(al,ky,ms,tn)
		   wsc.(ar,la,ok,tx)
		   mtn.(az,co,id,mt,nv,nm,ut,wy)
		   pac.(ak,ca,hi,or,wa) /;


set   agcensusmap(agcensus,s)   Mapping between census divisions and states /
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
         mdw.(        
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


ns0(itrd(i),mkt,rb,s) = 0;
nd0(itrd(i),mkt,rb,s) = 0;
vnm(itrd(i),mkt,rb) = 0;
n_(itrd(i),mkt,rb) = no;
pn_(itrd(i),mkt,rb) = no;

ns0(itrd(i),mkt(%mkt%),rb,s)$%mkt%map(%mkt%,s) = sum(ss,bd0(i,rb,s,ss));
nd0(itrd(i),mkt(%mkt%),rb,s) = sum(%mkt%map(%mkt%,ss),bd0(i,rb,ss,s));

vnm(itrd(i),mkt(%mkt%),rb) = sum(s,ns0(i,mkt,rb,s));
n_(itrd(i),mkt(%mkt%),rb) = vnm(i,mkt,rb);
pn_(itrd(i),mkt(%mkt%),rb) = vnm(i,mkt,rb);

bd0(itrd(i),rb,s,ss)$sum(n_(i,mkt,rb),1) = 0;

$include gtapwindc.gen
solve gtapwindc using mcp;

rtms(i,r,"usa") = 0.5;
gtapwindc.iterlim = 10000;
$include gtapwindc.gen
solve gtapwindc using mcp;
