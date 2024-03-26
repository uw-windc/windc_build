*	Generate GDX files with Census Port-trade 
$call gams read_HS_trade.gms

*~~~Run the new programs from Tom (Jan 2024)
$call gams geographytrade gdx=geographytrade.gdx --ds=windc_43

*	Check the GTAPWiNDC accounts
$call gams ..\gtapwindc\gtapwindc_mge.gms --ds=43

* a github edit 

*	Estimate the bilateral flows
$call gams bilatgravity gdx=bilatgravity
*.$call pause
*.$call gams gtapwindc_bilat.gms
