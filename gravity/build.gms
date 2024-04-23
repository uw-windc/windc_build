*	Generate GDX files with Census Port-trade 
$call gams read_HS_trade.gms

*~~~Run the new programs from Tom (Jan 2024)
$call gams geographytrade gdx=geographytrade.gdx

*	Check the GTAPWiNDC accounts
$call gams ..\gtapwindc\gtapwindc_mge.gms --ds=43

*	Estimate the bilateral flows
$call gams bilatgravity gdx=bilatgravity

*	Filter the bilateral flows
$call gams filter gdx=filter

*.$call pause
$call gams gtapwindc_bilat.gms
