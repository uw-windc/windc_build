$title	Product the Detailed SU Tables using Summary Tables 

set	yrs	 Years with summary tables /1997*2022/,
	yrd(yrs) Years with detailed tables /2007,2012,2017/;

set	s(*)	Sectors in the summary table
	d(*)	Sectors in the detailed table

	s_row(*) Summary table rows (in addition to commodities) 
	s_col(*) Summary table columns (in addition to sectors) 
	u_row(*) Use table rows (in addition to commodities) 
	u_col(*) Use table columns (in addition to sectors) 

	sd(s,d)	Mapping from summary to detailed commodities;

$call gams mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx
$loaddc s d sd s_row s_col u_row u_col

set	ds(d,s)	Mapping from detailed to summary;
ds(d,s) = sd(s,d);

alias (s,g),(d,ss,gg),(ds,dg);

sets	rs_d(*) / (set.d), (set.s_row) /,
	cs_d(*) / (set.d), (set.s_col) /,
	ru_d(*) / (set.d), (set.u_row) /,
	cu_d(*) / (set.d), (set.u_col) /,

	rs_s(*) / (set.s), (set.s_row) /,
	cs_s(*) / (set.s), (set.s_col) /,
	ru_s(*) / (set.s), (set.u_row) /,
	cu_s(*) / (set.s), (set.u_col) /;

parameter
	use_d(yrd,ru_d,cu_d)	The BEA Domestic Use of Commodities by Detailed Industries - (Millions of dollars),
	supply_d(yrd,rs_d,cs_d)	The BEA Domestic Supply of Commodities by Detailed Industries - (Millions of dollars),

	use_s(yrs,ru_s,cu_s)	The BEA Domestic Use of Commodities by Summary Industries - (Millions of dollars),
	supply_s(yrs,rs_s,cs_s)	The BEA Domestic Supply of Commodities by Summary Industries - (Millions of dollars) ;

$gdxin 'data\bea_summary.gdx'
$loaddc use_s=use supply_s=supply
$gdxin 'data\bea_detailed.gdx'
$loaddc use_d=use supply_d=supply

$ontext
parameter	scale	Scale factor /1e-3/;

use_d(yrd,ru_d,cu_d) = scale * use_d(yrd,ru_d,cu_d);
supply_d(yrd,rs_d,cs_d) = scale * supply_d(yrd,rs_d,cs_d);
use_s(yrs,ru_s,cu_s) = scale * use_s(yrs,ru_s,cu_s);
supply_s(yrs,rs_s,cs_s) = scale * supply_s(yrs,rs_s,cs_s);
$offtext

set	unz_d(ru_d,cu_d)	Use table nonzeros - detailed 
	unz_s(ru_s,cu_s)	Use table nonzeros - summary 

	snz_d(rs_d,cs_d)	Supply table nonzeros - detailed 
	snz_s(rs_s,cs_s)	Supply table nonzeros - summary;

option	unz_d<use_d, unz_s<use_s, snz_d<supply_d, snz_s<supply_s;

sets	um(ru_d,cu_d, ru_s,cu_s) Mapping of use matrix from detailed to summary 
	sm(rs_d,cs_d, rs_s,cs_s) Mapping of supply matrix from detailed to summary;

alias (u,*);

um(unz_d(ru_d(d),    cu_d(u)),     unz_s(ru_s(g),     cu_s(u)) )$(dg(d,g) and u_col(u)) = yes;
um(unz_d(ru_d(u),    cu_d(d)),     unz_s(ru_s(u),     cu_s(s)))$(ds(d,s) and u_row(u))  = yes;
um(unz_d(ru_d(gg),   cu_d(ss)),    unz_s(ru_s(g),     cu_s(s)))$(dg(gg,g) and ds(ss,s)) = yes;

sm(snz_d(rs_d(d),    cs_d(u)),     snz_s(rs_s(g),     cs_s(u)) )$(dg(d,g) and s_col(u)) = yes;
sm(snz_d(rs_d(u),    cs_d(d)),     snz_s(rs_s(u),     cs_s(s)))$(s_row(u) and ds(d,s)) = yes;
sm(snz_d(rs_d(gg),   cs_d(ss)),    snz_s(rs_s(g),     cs_s(s)))$(dg(gg,g) and ds(ss,s)) = yes;

parameter	chk_u(yrd,ru_s,cu_s,*), chk_s(yrd,rs_s,cs_s,*);

chk_u(yrd,unz_s,"dif") = use_s(yrd,unz_s)    - sum(um(unz_d,unz_s), use_d(yrd,unz_d));
chk_s(yrd,snz_s,"dif") = supply_s(yrd,snz_s) - sum(sm(snz_d,snz_s), supply_d(yrd,snz_d));

chk_u(yrd,unz_s,"s table") = use_s(yrd,unz_s);
chk_u(yrd,unz_s,"d table") = sum(um(unz_d,unz_s), use_d(yrd,unz_d));
chk_s(yrd,snz_s,"s table") = supply_s(yrd,snz_s);
chk_s(yrd,snz_s,"d table") = sum(sm(snz_d,snz_s), supply_d(yrd,snz_d));
chk_u(yrd,unz_s,"%")$use_s(yrd,unz_s) 
	= 100 * chk_u(yrd,unz_s,"dif")/use_s(yrd,unz_s);
chk_s(yrd,snz_s,"%")$supply_s(yrd,snz_s) 
	= 100 * chk_s(yrd,snz_s,"dif") /supply_s(yrd,snz_s);
option	chk_u:3:2:1, 
	chk_s:3:2:1;
display chk_u, chk_s;


parameter	
	theta_u(yrd,ru_d,cu_d)	Value share of detailed use coefficient,
	theta_s(yrd,rs_d,cs_d)	Value share of detailed supply coefficient;

loop((um(unz_d,unz_s),yrd)$use_s(yrd,unz_s),
  theta_u(yrd,unz_d)  = use_d(yrd,unz_d)   / use_s(yrd,unz_s);
);

loop((sm(snz_d,snz_s),yrd)$supply_s(yrd,snz_s),
  theta_s(yrd,snz_d)  = supply_d(yrd,snz_d) /supply_s(yrd,snz_s);
);

parameter	weight(yrd,yrs)		Weighting applied to the yrd table when interpolating yrs;
set		w(yrd,yrs)		Years affecting projection to ys;

weight(yrd,yrs)$(abs(yrs.val-yrd.val)<5) = 1 - abs(yrs.val-yrd.val)/5;
weight("2007",yrs)$(yrs.val<2007) = 1;
weight("2017",yrs)$(yrs.val>2017) = 1;
option w<weight;

parameter
	use(yrs,ru_d,cu_d)	Projected Use of Commodities by Industries - (Millions of dollars),
	supply(yrs,rs_d,cs_d)	Projected Supply of Commodities by Industries - (Millions of dollars);

loop((um(unz_d,unz_s),yrs)$use_s(yrs,unz_s),
  use(yrs,unz_d) = sum(w(yrd,yrs), weight(yrd,yrs) * theta_u(yrd,  unz_d) * use_s(yrs,unz_s));
);

loop((sm(snz_d,snz_s),yrs)$supply_s(yrs,snz_s),
  supply(yrs,snz_d) = sum(w(yrd,yrs), weight(yrd,yrs) * theta_s(yrd,snz_d) * supply_s(yrs,snz_s));
);

execute_unload 'data\iounbalanced.gdx', use, supply;
