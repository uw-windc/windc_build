$call gams iobalance s=iobalance
$call gams gravitycalc
$call gams loadchk r=iobalance 
$call gams suaggr
$call gams atmcalc --ds=supplyuse_2022 --mkt=national --tradedata=..\tradedata\aggtradedata.gdx o=uniform.lst gdx=uniform 
$call gams atmcalc --ds=supplyusegravity_2022 o=gravity.lst gdx=gravity 
$call gdxmerge ..\bea_IO\national.gdx uniform.gdx gravity.gdx 
$call gdxxrw i=merged.gdx o=atm.xlsx par=atm rng=PivotData!a2 cdim=0 

