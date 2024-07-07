$Title read in the census 2017 trade data with full HS disaggregation

$if not set trade_data $set trade_data %system.fp%../data/gravity/

Sets 
	HS	HS6 goods including aggregates /
$include %trade_data%\HS_domain.txt
	710820	monetary gold in gtap mapping but not Census trade
	/,

	HS6(HS) subset that eliminates the aggregates (less than 6 digits) /
$include %trade_data%\HS6_domain.txt
	710820	monetary gold in gtap mapping but not Census trade
	/,

	Dist	Port districts /
$include %trade_data%\port_district_domain.txt
	/
	usa_all(dist) Aggregate /usa_all/;

Parameter 
	HSimp(Dist,HS)	HS level imports by district,
	HSexp(Dist,HS)	HS level exports by district;

$call gdxxrw.exe %trade_data%\Port_Dist_Imp_2017_HS.xlsx o=%trade_data%\imp_hstrd.gdx par=hsimp rng=REPORT!b7
$call gdxxrw.exe %trade_data%\Port_Dist_Exp_2017_HS.xlsx o=%trade_data%\exp_hstrd.gdx par=hsexp rng=REPORT!b7

$gdxin %trade_data%\imp_hstrd.gdx
$loaddc HSimp

$gdxin %trade_data%\exp_hstrd.gdx
$loaddc HSexp

Parameter totchk;
totchk("imp") = sum((dist,hs6)$(not sameas(dist,"usa_all")), 
                      HSimp(dist,hs6)    
		    )-HSimp("usa_all","0");
totchk("exp") = sum((dist,hs6)$(not sameas(dist,"usa_all")), 
                      HSexp(dist,hs6)    
		    )-HSexp("usa_all","0");

Abort$totchk("imp") "Data read error: sum over HS6 imports does not equal total imports";
Abort$totchk("exp") "Data read error: sum over HS6 exports does not equal total exports";

