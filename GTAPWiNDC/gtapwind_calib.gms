vxm(i,r) = sum(rr,vxmd(i,r,rr)) + vst(i,r);
vnm(i,r) = sum(z_(i,r,s),nd0(i,r,s))
vtw(j)   = sum((i,r,rr),vtwr(j,i,r,rr));
vst(j,r) = vst(j,r) * vtw(j)/sum(rr,vst(j,rr));
vim(i,r) = sum(rr,vxmd(i,rr,r)*pvxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r)*pvtwr(i,rr,r)));
evomh(f,r,s,h) = evomh(f,r,s,h) * sum(g,vfm(f,g,r,s))/sum(h.local,evomh(f,r,s,h));
c0(r,s,h) = sum(i,cd0(i,r,s,h));
sav0(r,s,h) = sum(h,evomh(f,r,s,h)) + sum(trn,hhtrn0(r,s,h,trn)) - c0(r,s,h);

variables	ns0_(i,r,s)	Region supply to the national market 
		nd0_(r,g)	Regional demand from national market,

		xs0_(i,r,s)	Export supply
		md0_(i,r,s)	Import demand

		vom_(g,r,s)	Total supply at market prices,
		yl0_(i,r,s)	Local domestic absorption,
		vfm_(f,g,r,s)	Factor demand at market prices,

		a0_(i,r,s)	Absorption;

equations	market_py, market_pn, market_pz, market_pm, market_p, market_pl, market_ps;
		profit_y, profit_z;


market_py(y_(g,r,s))..	vom_(g,r,s) =e= sum(i(g),
				sum(x_(i,r),xs0_(i,r,s)) + 
				sum(n_(i,r),ns0_(i,r,s)) + 
				sum(z_(i,r,s),yl0_(i,r,s))) 

				+ (vb(r)+sum(rh_(r,s,h),sav0(r,s,h)))$sameas(g,"i") 

				( - sum((i,r,rr),rtxs(i,r,rr)*vxmd(i,r,rr))
				  + sum((i,rr,r),rtms(i,rr,r)*(sum(j,vtwr(j,i,rr,r))+(1-rtxs(i,rr,r))*vxmd(i,rr,r))) 
				  + sum(z_(i,r,s), md0_(i,r,s)*rtm(i,r,s) + (nd0_(i,r,s)+yl0_(i,r,s))*rtd(i,r,s)) 
				  + sum(f,vfm(f,g,r,s)*rtf(f,g,r)) )$sameas(g,"g");

market_pn(i,r)..	sum((n_(i,r),s),ns0_(i,r,s)) =e= sum(z_(i,r,s),nd0_(i,r,s));

market_pz(i,r,s)..	a0_(i,r,s) =e= sum(y_(g,r,s),vafm_(i,g,r,s)) + sum(c_(r,s,h),cd0(i,r,s,h));

market_pm(i,r)..	sum(s,md0_(i,r,s)) =e= vim(i,r);

market_p(i,r)..		vxm_(i,r) =e= sum(m_(i,rr),vxmd(i,r,rr)) + sum(yt_(i),vst(i,r));

market_pl(mf,r,s)..	sum(h,evomh(mf,r,s,h)) =e= sum(g,vfm_(mf,g,r,s));

market_ps(sf,r)..	sum((h,s),evomh(sf,r,s,h)) =e= sum((g,s),vfm_(sf,g,r,s));

profit_y(y_(g,r,s))..	vom_(g,r,s)*(1-rto(g,r)) =e= sum(i,vafm_(i,g,r,s,)) + sum(f,vfm_(f,g,r,s)*(1+rtf(f,g,r)));

profit_z(z_(i,r,s))..	a0_(i,r,s) =e= (1+rtf(i,r,s))*(yl0_(i,r,s)+nd0_(i,r,s)) + (1+rtm(i,r,s))*md0_(i,r,s);



