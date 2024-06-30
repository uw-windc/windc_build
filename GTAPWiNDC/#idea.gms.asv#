set	allmkt /national, census.tl, s.tl/
	mkt(allmkt) /national/;	

ns0(i,mkt,r,s)  Supply of good i to market mkt in region r, subregion s
nd0(i,mkt,r,s)  Demand for good i from market mkt in region r, subregion s
yd0(i,r,s)      Demand for local goods
md0(i,r,s)      Demand for imports

$prod:Z(i,r,s)$z_(i,r,s)  s:esubdm(i)  dn:esubdn(i) nn:esubnn(i)
	o:PZ(i,r,s)	q:a0(i,r,s)
	i:PY(i,r,s)	q:yd0(i,r,s)    dn:
	i:PN(i,mkt,r)	q:nd0(i,mkt,r,s) a:GOVT(r) t:rtd(i,r,s) p:(1+rtd0(i,r,s)) nn:
	i:PM(i,r)	q:md0(i,r,s)	 a:GOVT(r) t:rtm(i,r,s) p:(1+rtm0(i,r,s)) 

$prod:NS(i,mkt,r)$n_(i,r)  s:esubn(i)
	o:PN(i,mkt,r)	q:vnm(i,mkt,r)
	i:PY(i,r,s)	q:ns0(i,mkt,r,s)


