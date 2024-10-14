$call gams ..\bea_IO\symmetric gdx=national o=national.lst
$call gams symmetric gdx=uniform --ds=supplyuse_2022		o=uniform.lst
$call gams symmetric gdx=gravity --ds=supplyusegravity_2022	o=gravity.lst
$call gdxmerge national.gdx uniform.gdx gravity.gdx id=atm
$call gdxxrw i=merged.gdx o=atmvalues.xlsx par=atm rng=PivotData!a2 cdim=0
