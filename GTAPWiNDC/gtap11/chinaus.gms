$include gtapdata

parameter	trade	Benchmark trade statistics,
		labvsh	Labor value share;

alias (r,rr);
set	r_rr(r,rr) /usa.chn, chn.usa/;

trade(r_rr(r,rr),i,"rtms") = 100*rtms(i,r,rr);
trade(r_rr(r,rr),i,"rtxs") = 100*rtxs(i,r,rr);
trade(r_rr(r,rr),i,"vxmd") = vxmd(i,r,rr);

set	labor(f) /
	mgr	Officials and Mangers legislators (ISCO-88 Major Groups 1-2), 
	tec	Technicians technicians and associate professionals
	clk	Clerks
	srv	Service and market sales workers
	lab	Agricultural and unskilled workers (Major Groups 6-9) /;

labvsh(i,labor(f)) = 100*vfm(f,i,"chn")/vom(i,"chn");

option trade:3:1:1;
option labvsh:1;
display trade, labvsh;

execute_unload 'chinaus.gdx',trade,labvsh,i;

execute 'gdxxrw i=chinaus.gdx o=chinaus.xlsx par=trade rng=tradedata!a2 cdim=0 par=labvsh rng=labvsh!a2 cdim=0 set=i rng=sectors!a2 rdim=1';

