$title	Generate an Aggregate Dataset (summary or industry)

$if not set target $set target summary

$if not set source $set source gedata

set	yr	Years with summary tables /1997*2022/,
	s(*)	Sectors

	mrg	Margins /trd,trn/,
	xd	Exogenous demand /
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",
		F06C  	"Federal Government defense: Consumption expenditures",
		F06E  	"Federal national defense: Gross investment in equipment",
		F06N  	"Federal national defense: Gross investment in intellectual property products",
		F06S  	"Federal national defense: Gross investment in structures",
		F07C  	"Federal Government nondefense: Consumption expenditures",
		F07E  	"Federal nondefense: Gross investment in equipment",
		F07N  	"Federal nondefense: Gross investment in intellectual property products",
		F07S  	"Federal nondefense: Gross investment in structures",
		F10C  	"State and local government consumption expenditures",
		F10E  	"State and local: Gross investment in equipment",
		F10N  	"State and local: Gross investment in intellectual property products",
		F10S  	"State and local: Gross investment in structures" /;

$call gams mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx

*	Source aggregation is always detailed:

set	d(*)		Detailed aggregation;
$load d 
alias (d,sd,gd);

set	s(*)		Aggregation target
	s_d(s,d)	Target-source mapping;

$if %target%==summary  $loaddc s=s s_d=sd
$if %target%==industry $loaddc s=k s_d=kd

alias (s,g),(s_d,g_d);

$gdxin data\%source%.gdx

*	Regional aggregation not yet implemented. Target
*	aggregation is currently the same as the source.

set	r(*)	Regions;
$load r

parameter	
	ys0(yr,r,sd,gd)		Make matrix
	y0(yr,r,gd)		Aggregate supply
	ld0(yr,r,sd)		Labor demand
	kd0(yr,r,sd)		Capital demand
	id0(yr,r,gd,sd)		Intermediate demand,
	ty0(yr,r,sd)		Output tax rate
	vx0(yr,gd)		Aggregate exports
	rx0(yr,gd)		Re-exports
	x0(yr,r,gd)		Regional exports
	ms0(yr,r,gd,mrg)	Margin supply,
	yd0(yr,r,gd)		Domestic demand,
	ns0(yr,r,gd)		Supply to the national market 
	n0(yr,gd)		National market aggregate supply
	fd0(yr,r,gd,xd)		Final demand
	cd0(yr,r,gd)		Consumer demand
	a0(yr,r,gd)		Absorption
	nd0(yr,r,gd)		National market demand
	m0(yr,r,gd)		Imports
	tm0(yr,r,gd)		Import tariff
	ta0(yr,r,gd)		Product tax
	md0(yr,r,mrg,gd)	Margin demand;

$loaddc ys0 y0 ld0 kd0 id0 ty0 vx0 rx0 x0 ms0 
$loaddc yd0 ns0 n0 fd0 cd0 a0 nd0 m0 tm0 ta0 md0

parameters
	ys0_(yr,r,s,g)		Make matrix
	y0_(yr,r,g)		Aggregate supply
	ld0_(yr,r,s)		Labor demand
	kd0_(yr,r,s)		Capital demand
	id0_(yr,r,g,s)		Intermediate demand,
	ty0_(yr,r,s)		Output tax rate
	vx0_(yr,g)		Aggregate exports
	rx0_(yr,g)		Re-exports
	x0_(yr,r,g)		Regional exports
	ms0_(yr,r,g,mrg)	Margin supply,
	yd0_(yr,r,g)		Domestic demand,
	ns0_(yr,r,g)		Supply to the national market 
	n0_(yr,g)		National market aggregate supply
	fd0_(yr,r,g,xd)		Final demand
	cd0_(yr,r,g)		Consumer demand
	a0_(yr,r,g)		Absorption
	nd0_(yr,r,g)		National market demand
	m0_(yr,r,g)		Imports
	tm0_(yr,r,g)		Import tariff
	ta0_(yr,r,g)		Product tax
	md0_(yr,r,mrg,g)	Margin demand;

ys0_(yr,r,s,g) = sum((s_d(s,sd),g_d(g,gd)), ys0(yr,r,sd,gd));
id0_(yr,r,g,s) = sum((s_d(s,sd),g_d(g,gd)), id0(yr,r,gd,sd));

y0_(yr,r,g) = sum(g_d(g,gd), y0(yr,r,gd));
ld0_(yr,r,s) = sum(s_d(s,sd), ld0(yr,r,sd));
kd0_(yr,r,s) = sum(s_d(s,sd), kd0(yr,r,sd));
vx0_(yr,g)		= sum(g_d(g,gd),vx0(yr,gd));
rx0_(yr,g)		= sum(g_d(g,gd),rx0(yr,gd));
x0_(yr,r,g)		= sum(g_d(g,gd),x0(yr,r,gd));
ms0_(yr,r,g,mrg)	= sum(g_d(g,gd),ms0(yr,r,gd,mrg));
yd0_(yr,r,g)		= sum(g_d(g,gd),yd0(yr,r,gd));
ns0_(yr,r,g)		= sum(g_d(g,gd),ns0(yr,r,gd));
n0_(yr,g)		= sum(g_d(g,gd),n0(yr,gd));
fd0_(yr,r,g,xd)		= sum(g_d(g,gd),fd0(yr,r,gd,xd));
cd0_(yr,r,g)		= sum(g_d(g,gd),cd0(yr,r,gd));
a0_(yr,r,g)		= sum(g_d(g,gd),a0(yr,r,gd));
nd0_(yr,r,g)		= sum(g_d(g,gd),nd0(yr,r,gd));
m0_(yr,r,g)		= sum(g_d(g,gd),m0(yr,r,gd));
md0_(yr,r,mrg,g)	= sum(g_d(g,gd),md0(yr,r,mrg,gd));

*	Aggregate tax rates:

ty0(yr,r,sd) = ty0(yr,r,sd) * sum(gd,ys0(yr,r,sd,gd));
tm0(yr,r,gd) = tm0(yr,r,gd) * m0(yr,r,gd);
ta0(yr,r,gd) = ta0(yr,r,gd) * a0(yr,r,gd);

ty0_(yr,r,s)		= sum(s_d(s,sd),ty0(yr,r,sd));
tm0_(yr,r,g)		= sum(g_d(g,gd),tm0(yr,r,gd));
ta0_(yr,r,g)		= sum(g_d(g,gd),ta0(yr,r,gd));

ty0_(yr,r,s) = ty0_(yr,r,s) * sum(g,ys0_(yr,r,s,g));
tm0_(yr,r,g) = tm0_(yr,r,g) * m0_(yr,r,g);
ta0_(yr,r,g) = ta0_(yr,r,g) * a0_(yr,r,g);

execute_unload 'data\gedata_%target%.gdx', yr, r, s,
	ys0_=ys0, y0_=y0, ld0_=ld0, kd0_=kd0, id0_=id0, ty0_=ty0, 
	vx0_=vx0, rx0_=rx0, x0_=x0, ms0_=ms0, yd0_=yd0, ns0_=ns0, 
	n0_=n0, fd0_=fd0, cd0_=cd0, a0_=a0, nd0_=nd0, m0_=m0, 
	tm0_=tm0, ta0_=ta0, md0_=md0
