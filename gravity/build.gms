$call gams geographytrade gdx=geographytrade.gdx
$call gams ..\gtapwindc\gtapwindc_mge.gms --ds=43

*	Need to fix the GDX output to be consistent with the subsequent model:
*.$call gams bilatgravity
*.$call gams gtapwindc_bilat.gms
