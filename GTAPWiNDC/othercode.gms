$exit




parameter	chk_market_py(*,*,*), chk_market_pn(*,*), chk_market_pz(*,*,*), chk_market_pm(*,*),
		chk_market_pl(*,*,*), chk_market_ps(*,*), chk_profit_y(*,*,*), chk_profit_z(*,*,*),
		chk_govtincome(*);

$onecho >%gams.scrdir%chkmodel.gms
$ondotl
chk_market_py(y_(g,rb(r),s)) = round(
		VOM_(g,r,s) - ( sum(i(g),
					sum(x_(i,r),	XS0_(i,r,s)) + 
					sum(n_(i,r),	NS0_(i,r,s)) + 
					sum(z_(i,r,s),	YL0_(i,r,s))) 

				+ (vb(r)+sum(rh_(r,s,h),sav0(r,s,h)))$sameas(g,"i") 

				+ (GOVT(r)*thetag(r,s))$sameas(g,"g") ), 3);


chk_govtincome(r) =	round(
			sum(s,vom("g",r,s)) - ( - sum((i,rr),rtxs(i,r,rr)*vxmd(i,r,rr))
			+ sum((i,rr),rtms(i,rr,r)*(sum(j,vtwr(j,i,rr,r))+(1-rtxs(i,rr,r))*vxmd(i,rr,r))) 
			+ sum(z_(i,r,s), MD0_(i,r,s)*rtm(i,r,s) + (ND0_(i,r,s)+YL0_(i,r,s))*rtd(i,r,s)) 
			+ sum((f,g,s),vfm(f,g,r,s)*rtf(f,g,r)) ), 3);

chk_market_pn(pn_(i,rb(r))) = round( sum((n_(i,r),s),NS0_(i,r,s)) - sum(z_(i,r,s),ND0_(i,r,s)), 3);

chk_market_pz(pz_(i,rb(r),s)) =	round(A0_(i,r,s) - (sum(y_(g,r,s),VAFM_(i,g,r,s)) + sum(c_(r,s,h),cd0(i,r,s,h))),3);

chk_market_pm(pm_(i,rb(r))) = round(sum(s,MD0_(i,r,s)) - vim(i,r),3);

chk_market_pl(pf_(mf,rb(r),s)) = round(sum(h,evomh(mf,r,s,h)) - sum(g,VFM_(mf,g,r,s)),3);

chk_market_ps(sf,rb(r)) = round(sum((h,s),evomh(sf,r,s,h)) - sum((g,s),VFM_(sf,g,r,s)),3);

chk_profit_y(y_(y_(g,rb(r),s))) = round(VOM_(g,r,s)*(1-rto(g,r)) - ( sum(i,VAFM_(i,g,r,s)) + 
				sum(f,VFM_(f,g,r,s)*(1+rtf(f,g,r))) ), 3);

chk_profit_z(z_(i,rb(r),s)) = round(A0_(i,r,s) - ( (1+rtd(i,r,s))*(YL0_(i,r,s)+ND0_(i,r,s)) + (1+rtm(i,r,s))*MD0_(i,r,s)),3);

option	chk_market_py:3:0:1, chk_market_pn:3:0:1, chk_market_pz:3:0:1,
	chk_market_pm:3:0:1, chk_market_pl:3:0:1, chk_market_ps:3:0:1,
	chk_profit_y:3:0:1, chk_profit_z:3:0:1, chk_govtincome:3:0:1;

display chk_market_py, chk_market_pn, chk_market_pz, chk_market_pm,
	chk_market_pl, chk_market_ps, chk_profit_y, chk_profit_z,
	chk_govtincome;

$offecho

$exit

*	Calibrate markets for international transport services:

vtw(j)   = sum((i,r,rr),vtwr(j,i,r,rr));

*	Careful here as this may affect all regions in the dataset,
*	not just the US.  However, this should already be balanced
*	and there should be no change:

vst(j,r)$sum(rr,vst(j,rr)) = vtw(j)*vst(j,r)/sum(rr,vst(j,rr));

*	Calibrate international imports:
vxm(i,r) = sum(rr,vxmd(i,r,rr)) + vst(i,r);

*	Calibrate CIF imports:
vim(i,r) = sum(rr,vxmd(i,rr,r)*pvxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r)*pvtwr(i,rr,r)));

*	Calibrate household expenditure and savings:

sav0(r,s,h) = sum(f,evomh(f,r,s,h)) + sum(trn,hhtrn0(r,s,h,trn)) - c0(r,s,h);


$exit

parameter	pachk;
pachk(i,s,"a0") = a0(i,"usa",s);
pachk(i,s,"vafm") = sum(g,vafm(i,g,"usa",s));
pachk(i,s,"cd0") = sum(h,cd0(i,"usa",s,h));
option pachk:3:2:1;
display pachk;

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

a0(i,r,s)      = yl0(i,r,s)*(1+rtd0(i,r,s)) + nd0(i,r,s)*(1+rtd0(i,r,s)) + md0(i,r,s)*(1+rtm0(i,r,s));
vafm(i,g,r,s)$(not a0(i,r,s)) = 0;
cd0(i,r,s,h)$(not a0(i,r,s)) = 0;
c0(r,s,h) = sum(i,cd0(i,r,s,h));

vom(y_(g,r,s)) = (1/(1-rto(g,r))) * (sum(i,vafm(i,g,r,s)) + sum(f,vfm(f,g,r,s)*(1+rtf0(f,g,r))));
vim(i,r)       = sum(rr, vxmd(i,rr,r)*pvxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r)*pvtwr(i,rr,r)));

parameter	vomchk(i,r,s)	Market clearance for py
		vimchk(i,r)	Market clearance for pm;

vomchk(i,r,s) = vom(i,r,s) - ( xs0(i,r,s) + ns0(i,r,s) + yl0(i,r,s) );
vimchk(i,r) = vim(i,r) - sum(s,md0(i,r,s));
option vomchk:3:0:1, vimchk:3:0:1;
display vomchk, vimchk;

