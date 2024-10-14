$title	Write Supply-Use Workbook for a Projected Year

$if not set yr $set yr 2021
$set wb data\supplyuse_%yr%
$call copy /y data\supplyuse.xlsx %wb%.xlsx

set	yr	 Years with tables /1997*2022/,
	s(*)	Sectors in the summary table
	d(*)	Sectors in the detailed table
	j(*)	Sector identifiers in BEA data
	jd(j,d)	Mapping from j to d

	s_row(*) Supply table rows (in addition to commodities) 
	s_col(*) Supply table columns (in addition to sectors) 
	u_row(*) Use table rows (in addition to commodities) 
	u_col(*) Use table columns (in addition to sectors) 

$call gams mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx
$loaddc s d j s_row s_col u_row u_col jd

sets	rs_d(*) / (set.d), (set.s_row) /,
	cs_d(*) / (set.d), (set.s_col) /,
	ru_d(*) / (set.d), (set.u_row) /,
	cu_d(*) / (set.d), (set.u_col) /,

	rs(*) / (set.j), (set.s_row) /,
	cs(*) / (set.j), (set.s_col) /,
	ru(*) / (set.j), (set.u_row) /,
	cu(*) / (set.j), (set.u_col) /;

parameter
	use(yr,ru_d,cu_d)	The BEA Domestic Use of Commodities by Industries - (Millions of dollars),
	supply(yr,rs_d,cs_d)	The BEA Domestic Supply of Commodities by Industries - (Millions of dollars);

$gdxin 'data\iobalanced.gdx'
$loaddc use supply
$gdxin

set	rsmap(rs_d,rs)	Mapping of supply table row labels,
	csmap(cs_d,cs)	Mapping of supply table colum labels,
	rumap(ru_d,ru)	Mapping of supply table row labels,
	cumap(cu_d,cu)	Mapping of supply table colum labels;

rsmap(rs_d(s_row),rs(s_row)) = yes;
csmap(cs_d(s_col),cs(s_col)) = yes;
rumap(ru_d(u_row),ru(u_row)) = yes;
cumap(cu_d(u_col),cu(u_col)) = yes;

rsmap(rs_d(d),rs(j)) = jd(j,d);
csmap(cs_d(d),cs(j)) = jd(j,d);
rumap(ru_d(d),ru(j)) = jd(j,d);
cumap(cu_d(d),cu(j)) = jd(j,d);

parameter
	use_%yr%(ru,cu)	The BEA Domestic Use of Commodities by Industries - (Millions of dollars),
	supply_%yr%(rs,cs)	The BEA Domestic Supply of Commodities by Industries - (Millions of dollars);

use_%yr%(ru,cu)    = sum((rumap(ru_d,ru),cumap(cu_d,cu)),   use("%yr%",ru_d,cu_d));
supply_%yr%(rs,cs) = sum((rsmap(rs_d,rs),csmap(cs_d,cs)),supply("%yr%",rs_d,cs_d));

set	supply_title /"The Supply Table, %yr% -- Projected"/,
	use_title    /"The Use Table, %yr% -- Projected"/;

execute_unload '%wb%.gdx', supply_%yr%, use_%yr%, supply_title, use_title;
$onecho >%gams.scrdir%gdxxrw.rsp
par=supply_%yr%  rng=supply!c6..pa409 clear  rdim=1 cdim=1 
set=supply_title rng=supply!a1..a1    rdim=1 cdim=0 values=nodata
par=use_%yr%     rng=use!a6..pj417    clear  rdim=1 cdim=1 
set=use_title    rng=use!a1..a1       rdim=1 cdim=0 values=nodata
$offecho
execute 'gdxxrw i=%wb%.gdx o=%wb%.xlsx @%gams.scrdir%gdxxrw.rsp';


