$if not set yr $set yr 2022

option g:0:0:1, s:0:0:1;
display g, s;
$exit

$if not exist gravitydata_%yr%_out.gdx $call 'gams "d:\GitHub\windc_build\gravity\estimate\gravitycalc"'

parameter gravitydata_(g,*,*);
$gdxin 'gravitydata_%yr%_out.gdx'
$loaddc gravitydata_=gravitydata

parameter	statechk;
statechk(gt(g),r,"y0")  = gravitydata(gt,r,"y0");
statechk(gt(g),r,"y0*") = gravitydata_(gt,r,"yd0") + gravitydata_(gt,r,"yn0") + gravitydata_(gt,r,"yx0");
statechk(gt(g),r,"a0") = gravitydata(gt,r,"a0");
statechk(gt(g),r,"a0*") = gravitydata_(gt,r,"yd0") + gravitydata_(gt,r,"nd0") + gravitydata_(gt,r,"md0");
option statechk:3:2:1;
display statechk;

parameter	nationchk;
nationchk(gt(g),"yn0") = sum(r,gravitydata_(gt,r,"yn0"));
nationchk(gt(g),"nd0") = sum(r,gravitydata_(gt,r,"nd0"));
display nationchk;


parameter	gravitychk;

*.gravitychk(gt(g),"x0") = gravitydata(gt,"total","x0") - sum(r,gravitydata_(gt,r,"yx0"));
*.gravitychk(gt(g),"m0") = gravitydata(gt,"total","m0") - sum(r,gravitydata_(gt,r,"md0"));

gravitychk(gt(g),"y0") = sum(r,gravitydata(gt,r,"y0")) ;
gravitychk(gt(g),"y0*") = 
	  sum(r,gravitydata_(gt,r,"yd0"))
	+ sum(r,gravitydata_(gt,r,"yn0"))
	+ sum(r,gravitydata_(gt,r,"yx0"));

gravitychk(gt(g),"a0") = sum(r,gravitydata(gt,r,"a0")) ;
gravitychk(gt(g),"a0*") = 
	sum(r,gravitydata_(gt,r,"yd0")) +
	sum(r,gravitydata_(gt,r,"nd0")) +
	sum(r,gravitydata_(gt,r,"md0"));
	
display gravitychk;

parameter	supplydemand	Benchmark data;
supplydemand(gt(g),"a0") = sum(r,gravitydata(gt,r,"a0"));
supplydemand(gt(g),"y0") = sum(r,gravitydata(gt,r,"y0"));

parameter	echoprint	Comparison of values;

echoprint(gt(g),r,"MD/A","Uniform") = THETAM.L(g);
echoprint(gt(g),r,"MD/A","Gravity")$gravitydata_(gt,r,"md0") = gravitydata_(gt,r,"md0")/gravitydata(gt,r,"a0");

echoprint(gt(g),r,"YD/A","Uniform") = THETAD.L(g);
echoprint(gt(g),r,"YD/A","Gravity")$gravitydata_(gt,r,"yd0") = gravitydata_(gt,r,"yd0")/gravitydata(gt,r,"a0");

echoprint(gt(g),r,"YD/Y","Uniform")$YD.L(g,r) = YD.L(g,r)/asupply(g,r);
echoprint(gt(g),r,"YD/Y","Gravity")$gravitydata_(gt,r,"yd0") = gravitydata_(gt,r,"yd0")/gravitydata(gt,r,"y0");

echoprint(gt(g),r,"YX/Y","Uniform")$YX.L(g,r) = YX.L(g,r)/asupply(g,r);
echoprint(gt(g),r,"YX/Y","Gravity")$gravitydata_(gt,r,"yx0") = gravitydata_(gt,r,"yx0")/gravitydata(gt,r,"y0");

echoprint(gt(g),r,"YN/Y","Uniform")$YN.L(g,r) = YN.L(g,r)/asupply(g,r);
echoprint(gt(g),r,"YN/Y","Gravity")$gravitydata_(gt,r,"yn0") = gravitydata_(gt,r,"yn0")/gravitydata(gt,r,"y0");

echoprint(gt(g),r,"ND/A","Uniform")$ND.L(g,r) = ND.L(g,r)/ademand(g,r);
echoprint(gt(g),r,"ND/A","Gravity")$gravitydata_(gt,r,"nd0") = gravitydata_(gt,r,"nd0")/gravitydata(gt,r,"a0");

execute_unload 'echoprint.gdx',echoprint, supplydemand;
*.execute 'gdxxrw i=echoprint.gdx o=echoprint.xlsx par=echoprint rng=PivotData!a2 cdim=0 par=supplydemand rng=SupplyDemand!a1 rdim=1 cdim=1';

*	Move the gravity estimates into the input-output table:

*	Share of national import demand for good gt which is in state r:

alpham(gt(g(rs)),r)$sum(snz_n(rs,iimp),1) = gravitydata_(gt,r,"md0")/sum(iimp,supply_n(yb,rs,iimp));

*	Use this to share out both import accounts:

supply(snz_n(rs(g),iimp),r) = alpham(g,r) * supply_n(yb,snz_n);

*	Set up national markets:

supply(rs(gt),"MCIF_N",r) = gravitydata_(gt,r,"nd0");
use(ru(gt),"F040",r)   = gravitydata_(gt,r,"yx0");
use(ru(gt),"F040_N",r) = gravitydata_(gt,r,"yn0");

option snz<supply, unz<use;

rmarket(r,g,"supply") = sum(snz(rs(g),cs(s),r),supply(snz)) + 
			sum(snz(rs(g),txs,r),supply(snz)) +
			sum(snz(rs(g),mrg,r),supply(snz)) + inventory(g,r);
rmarket(r,g,"import") = sum(snz(rs(g),imp,r), supply(snz));
rmarket(r,g,"export") = sum(unz(ru(g),export,r),use(unz));
rmarket(r,g,"demand") =   sum(unz(ru(g),cu(s),r),use(unz))
			+ sum(unz(ru(g),fd,r),use(unz))+inventory(g,r);
rmarket(r,g,"chk") =	rmarket(r,g,"supply") +
			rmarket(r,g,"import") -
			rmarket(r,g,"export") - 
			rmarket(r,g,"demand");
option rmarket:3:2:1;
display rmarket;


set	gs(rs), gu(ru), ss(cs), su(cu);
option gs<snz, gu<unz, ss<snz, su<unz;
gs(rs)$(not g(rs)) = no;
gu(ru)$(not g(ru)) = no;
gs(rs(g)) = g(g);
gu(ru(g)) = g(g);
ss(cs(s)) = s(s);
su(cu(s)) = s(s);
option gs:0:0:1, gu:0:0:1, ss:0:0:1, su:0:0:1;
display gs, gu, ss, su;

set	g_(*), s_(*);
g_(gs) = gs(gs);
g_(gu) = gu(gu);
s_(ss) = ss(ss);
s_(su) = su(su);

option g_:0:0:1, s_:0:0:1;
display g_, s_;


execute_unload 'supplyusegravity_%yr%.gdx', supply, use;
