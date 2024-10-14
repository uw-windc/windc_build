set	yr(*)	Years,
	g(*)	Commodities,
	s(*)	States,
	scn(*)	Scenarios computed,
	itm	Items reported in itlog /objval,modelstat,solvestat/, 
	stat(*)	Statistics returned in bmkdata;

parameter	itlog(yr<,g<,scn<,itm), bmkdata(yr,g,s<,stat<);
$gdxin 'datasets\bearesults.gdx'
$loaddc itlog
$loaddc bmkdata

option itlog:0:3:1;
display itlog;

set	solved(yr,g)	Solved cases;
solved(yr,g) = (not round(itlog(yr,g,"svar","objval"),5));

itlog(yr,g,scn,itm)$(not solved(yr,g)) = 0;
display itlog;

bmkdata(yr,g,s,stat)$(not solved(yr,g)) = 0;
option bmkdata:2:3:1;
display bmkdata;

execute_unload 'd:\GitHub\windc_build\statedata\gravity.gdx',bmkdata;

set	gb(g);
option gb<solved;

parameter	ng;
ng = card(gb);
option ng:0;
display ng;

execute_unload 'bmkdata.gdx', bmkdata;
*.execute 'gdxxrw i=bmkdata.gdx o=bmkdata.xlsx par=bmkdata rng=PivotData!a2 cdim=0 intastext=n';