$ontext

Look at the year 2022 for ru_d = ORE and cu_d = ORE. 
	"iobalance.gms" has a value that is basically 0 whereas 
	"project.gms" has a value of 220808.894109. 

You should add an "unload" statement to project.

The outputs of project.gms match my basic calibration, which is why I
think it's correct.

$offtext

set yr(*), ru_d(*), cu_d(*);

parameter use_project(yr,ru_d,cu_d), use_iobalance(yr,ru_d,cu_d);

*	$call gams oldproject r=project gdx=oldproject

$gdxin oldproject.gdx
$load yr ru_d cu_d
$loaddc use_project=use

*	$call gams iobalance  r=project gdx=iobalance 

$gdxin iobalance.gdx
$loaddc use_iobalance=use

parameter	compare;
compare(yr,"project") = use_project(yr,"ore","ore");
compare(yr,"iobalance") = use_iobalance(yr,"ore","ore");
display compare;
