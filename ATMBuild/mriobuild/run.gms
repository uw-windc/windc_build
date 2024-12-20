$goto atmcalc

*	Set up targets for state-level economic activity and then compute
*	a dataset with uniform domestic and import shares for each commodity
*	in each state.  Write a data file for use in the gravity calculation:

$call gams iobalance s=iobalance

*	Calculate domestic and internatinal trade flows:

$call gams gravitycalc

*	Read the gravity model output and merge this into the supply-use data:

$call gams loadchk r=iobalance 

*	Create a commodity-by-commodity input-output table:

$call gams suaggr

*	Do the ATM calculation with both the uniform trade dataset (calculated
*	in iobalance.gms) and the non-uniform trade dataset (calculated in 
*	gravitycalc.gms):

$label atmcalc

$call gams atmcalc --ds=supplyuse_2022 --mkt=national --tradedata=..\tradedata\aggtradedata.gdx o=uniform.lst gdx=uniform 
$call gams atmcalc --ds=supplyusegravity_2022 o=gravity.lst gdx=gravity 

$call gdxmerge ..\bea_IO\national.gdx uniform.gdx gravity.gdx 
$call gdxxrw i=merged.gdx o=atm.xlsx par=atm rng=PivotData!a2 cdim=0 

