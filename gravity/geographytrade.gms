$title  Quick and Dirty State-Port Geography Calculation

$if not set trade_data $set trade_data %system.fp%../data/gravity/

set	elast	Elasticities used for iceberg trade cost calculations /"3.0","4.0","5.0"/;

parameter	epsilon		Elasticity of trade wrt trade cost /-1/;

$include sets

set	c(fips)		Counties for which we have both coordinate and GDP;
c(fips) = yes$min(round(gdp(fips)),round(loc(fips,"lon")),round(loc(fips,"lat")));

set	missing(fips)	Missing counties;
missing(fips) = fips(fips)$(not c(fips));

*	Don't worry about the locations which are not counties:

missing(fips)$( (ord(fips.tl,3)=ord("0",1)) and 
		(ord(fips.tl,4)=ord("0",1)) and 
		(ord(fips.tl,5)=ord("0",1)) )  = no;

option missing:0:0:1;
display missing;

set	cmap(fips,st)	Mapping from county to state;
cmap(c,st) = fips(c)$((ord(c.tl,1)=ord(st.tl,1)) and (ord(c.tl,2)=ord(st.tl,2)));
option cmap:0:0:1;
display cmap;

parameter	stategdp(st)	State GDP;
stategdp(st) = sum(cmap(c,st),gdp(c));
option stategdp:0:0:1;
display stategdp;

parameter	theta(fips,st)	County share of state GDP;
theta(cmap(c,st)) = gdp(c)/stategdp(st);

parameter	r			Radius of the earth (miles) /3949/
		dist(usps,*)		Distance state to port and state to state;

$macro lamda(c)		(pi * loc(c,"lon") / 180)
$macro phi(c)		(pi * loc(c,"lat") / 180)

$macro lamda1(c)	(pi * loc(c,"lon") / 180)
$macro phi1(c)		(pi * loc(c,"lat") / 180)

$macro lamda2(port)	(pi * portloc(port,"lon") / 180)
$macro phi2(port)	(pi * portloc(port,"lat") / 180)

alias (c,c1,c2), (usps,s1,s2), (st,st1,st2),(cmap,c1map,c2map),(stmap,stmap1,stmap2);

loop((usps,port),
  dist(usps,port) = sum((stmap(usps,st),cmap(c,st)), theta(c,st) * 
	r*arccos(sin(phi1(c))*sin(phi2(port)) +
		 cos(phi1(c))*cos(phi2(port)) * cos(abs(lamda1(c)-lamda2(port)))));
);

file kcon /"con:"/; kcon.lw=0; put kcon /;

loop(s1,
  putclose 'Calculating distances for ',s1.tl/;
  loop(s2,
    dist(s1,s2) = sum((stmap1(s1,st1),stmap2(s2,st2),c1map(c1,st1),c2map(c2,st2))$(not sameas(c1,c2)), 
	theta(c1,st1) * theta(c2,st2) * 
	r*arccos(sin(phi(c1))*sin(phi(c2)) +
		 cos(phi(c1))*cos(phi(c2)) * cos(abs(lamda(c1)-lamda(c2)))));
));
option dist:0:0:1;
display dist;

parameter	tau(usps,*,elast)		Travel cost to closest port;
tau(usps,"min",elast) = smin(port,dist(usps,port)**(epsilon/(1-elast.val)));
tau(usps,"max",elast) = smax(port,dist(usps,port)**(epsilon/(1-elast.val)));
tau(usps,"ave",elast) = sum(port,dist(usps,port)**(epsilon/(1-elast.val)))/card(port);
option tau:1:1:2;
display tau;

parameter 
	hsimp(*,*)	HS level imports by district,
	hsexp(*,*)	HS level exports by district;

$gdxin %trade_data%\imp_hstrd.gdx
$load HSimp

$gdxin %trade_data%\exp_hstrd.gdx
$load HSexp

parameter	totchk	Cross check on total imports;
totchk("imp","$") = sum((port,hs6),HSimp(port,hs6))-HSimp("usa_all","0");
totchk("imp","%") = 100 * (sum((port,hs6),HSimp(port,hs6))/HSimp("usa_all","0") - 1);
totchk("exp","$") = sum((port,hs6), HSexp(port,hs6))-HSexp("usa_all","0");
totchk("exp","%") = 100 * (sum((port,hs6),HSexp(port,hs6))/HSexp("usa_all","0") - 1);

alias (u,*);

*	Report entries for non-mainland ports:

totchk(u,"$exp")$(not port(u)) = sum(hs6,hsimp(u,hs6));
totchk(u,"$imp")$(not port(u)) = sum(hs6,hsexp(u,hs6));
option totchk:1
display totchk;

set	xx	Non-mainland ports /
	XX_LowV, XX_SanJ, XX_USVI, XX_VUOP, XX_Mail, XX_NMC/;

*	Add these ports to St Louis:

hsexp("MO_StLo",hs6) = hsexp("MO_StLo",hs6) + sum(xx,hsexp(xx,hs6));
hsimp("MO_StLo",hs6) = hsimp("MO_StLo",hs6) + sum(xx,hsimp(xx,hs6));


set	notrade(*,*)	Goods without trade data;

*	The HS6 to GTAPinGAMS mapping comes from Aguiar (2016.. updated 2023).
*	GTAP Resource #5111.  (Modification to GTAPinGAMS energy good labels). 
*	There are many HS6 labels which do not appear in the mapping.  
*	Some are obsolete or redundant catagories.  Others are aggregates, 
*	where the Census trade sheet has no data for the disaggregate.  
*	To manage we drop entries without data from the set of HS6 goods 
*	of concern.  

notrade("hs6",hs6) = not sum(map(hs6,i),1);

*	The HS6 only include merchandise (tangible) trade goods, so services 
*	are not included (and raw milk).  Here we Display those GTAP goods 
*	which are not include in the Census trade data.

*	rmk wtr cns trd afs otp wtp atp whs cmn ofi ins rsa obs ros osg edu
*	hht dwe

notrade("gtap",i) = not sum(map(hs6,i),1);
option notrade:0:0:1;
display notrade;

set	itrd(i)	Commodities with trade data;
itrd(i) = i(i)$(not notrade("gtap",i));
option itrd:0:0:1;
display itrd;

parameter trade(port,i,*)	GTAP trade flows by port;
trade(port,i,"import") = sum(map(hs6,i),hsimp(port,hs6));
trade(port,i,"export") = sum(map(hs6,i),hsexp(port,hs6));

parameter	thetam(port,i)	Average import share;
thetam(port,itrd(i)) = trade(port,i,"import")/sum(port.local,trade(port,i,"import"));

parameter	pm(i,usps,elast)	Import price;
pm(itrd(i),usps,elast) = sum(port, thetam(port,i) * dist(usps,port)**(-0.7))**(1/(1-elast.val));
option pm:1:2:1;
display pm;
