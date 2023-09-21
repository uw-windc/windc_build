$Title read in the census 2017 trade data with full HS disaggregation

Sets 
	HS	HS6 goods including aggregates /
$include trade_data\HS_domain.txt
	710820	monetary gold in gtap mapping but not Census trade
	/,

	HS6(HS) subset that eliminates the aggregates (less than 6 digits) /
$include trade_data\HS6_domain.txt
	710820	monetary gold in gtap mapping but not Census trade
	/,

	Dist	Port districts /
$include trade_data\port_district_domain.txt
	/
	usa_all(dist) Aggregate /usa_all/;

Parameter 
	HSimp(Dist,HS)	HS level imports by district,
	HSexp(Dist,HS)	HS level exports by district;

$call gdxxrw.exe trade_data\Port_Dist_Imp_2017_HS.xlsx o=trade_data\imp_hstrd.gdx par=hsimp rng=REPORT!b7
$call gdxxrw.exe trade_data\Port_Dist_Exp_2017_HS.xlsx o=trade_data\exp_hstrd.gdx par=hsexp rng=REPORT!b7

$gdxin trade_data\imp_hstrd.gdx
$loaddc HSimp

$gdxin trade_data\exp_hstrd.gdx
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

Set	i	"gtap11-in-gams goods";

$gdxin ..\GTAPWiNDC\gtap11\2017\gtapingams.gdx
$load i
display i;

$include trade_data\HS_GTAP.map

*	The HS6 to GTAP mapping comes from Aguiar (2016.. updated 2023).
*	GTAP Resource #5111.  (Modification to GTAPinGAMS energy good labels). 
*	There are many HS6 labels which do not appear in the mapping.  
*	Some are obsolete or redundant catagories.  Others are aggregates, 
*	where the Census trade sheet has no data for the disaggregate.  
*	To manage we drop entries without data from the set of HS6 goods 
*	of concern.  

Set HS6_(HS6) Those HS6 goods which have Census data;
HS6_(HS6) = yes$(sum(dist,HSimp(dist,HS6)+HSexp(dist,HS6)));

parameter 
	mapbug(*) HS6_ goods with no mapping to GTAP,
	nontrd(*) Goods in GTAP with no US merchandise trade;

mapbug(hs6_) = 1 - sum(map(hs6_,i),1);
abort$card(mapbug) "Error in map -- each hs6 with data must be mapped.",mapbug;
display mapbug;

nontrd(i) = (sum(map(hs6,i),1)=0);
display nontrd;

*	The HS6 only include merchandise (tangible) trade goods, so services 
*	are not included (and raw milk).  Here we Display those GTAP goods 
*	which are not include in the Census trade data.
*rmk 1.000,    wtr 1.000,    cns 1.000,    trd 1.000,    afs 1.000,    otp 1.000,    
*wtp 1.000,    atp 1.000,    whs 1.000,    cmn 1.000,    ofi 1.000,    ins 1.000,    
*rsa 1.000,    obs 1.000,    ros 1.000,    osg 1.000,    edu 1.000,    hht 1.000,    
*dwe 1.000

Parameter GTAPimp(dist,i)	gtap level district imports,
	  GTAPexp(dist,i)	gtap level district exports;

GTAPimp(dist,i) = sum(map(hs6,i),HSimp(dist,hs6));
GTAPexp(dist,i) = sum(map(hs6,i),HSexp(dist,hs6));

totchk("imp") = sum((dist,i)$(not sameas(dist,"usa_all")), 
                      GTAPimp(dist,i)    
		    )-HSimp("usa_all","0");
totchk("exp") = sum((dist,i)$(not sameas(dist,"usa_all")), 
                      GTAPexp(dist,i)    
		    )-HSexp("usa_all","0");

Abort$totchk("imp") "Data read error: sum over GTAP-good imports does not equal total imports";
Abort$totchk("exp") "Data read error: sum over GTAP-good exports does not equal total exports";

*	Assign state-level international trade nodes by mapping districts 
*	to states.  Some districts do not have a natural state, so we map 
*	them to MO = Missouri (approximately the geographic and population
*	center of the US). 

set s US states;
$gdxin ..\core\WiNDCdatabase.gdx
$load s = r

set rmap(dist,s) /
* exclude "USA_All" = total-all-ports district
AK_Anch.AK	"Anchorage, AK (District)",		  
MD_Balt.MD	"Baltimore, MD (District)",		  
MA_Bost.MA	"Boston, MA (District)",		  
NY_Buff.NY	"Buffalo, NY (District)",		  
SC_Char.SC	"Charleston, SC (District)",		  
IL_Chic.IL	"Chicago, IL (District)",		  
OH_Clev.OH	"Cleveland, OH (District)",		  
OR_Colu.OR	"Columbia-Snake, OR (District)",	  
TX_Dall.TX	"Dallas-Fort Worth, TX (District)",	  
MI_Detr.MI	"Detroit, MI (District)",		  
MN_Dulu.MN	"Duluth, MN (District)",		  
TX_ElPa.TX	"El Paso, TX (District)",		  
MT_Grea.MT	"Great Falls, MT (District)",		  
HI_Hono.HI	"Honolulu, HI (District)",		  
TX_Hous.TX	"Houston-Galveston, TX (District)",	  
TX_Lare.TX	"Laredo, TX (District)",		  
CA_LosA.CA	"Los Angeles, CA (District)",		  
XX_LowV.MO	"Low Value (District)",			  
XX_Mail.MO	"Mail Shipments (District)",		  
FL_Miam.FL	"Miami, FL (District)",			  
WI_Milw.WI	"Milwaukee, WI (District)",		  
MN_Minn.MN	"Minneapolis, MN (District)",		  
AL_Mobi.AL	"Mobile, AL (District)",		  
LA_NewO.LA	"New Orleans, LA (District)",		  
NY_NewY.NY	"New York City, NY (District)",		  
AZ_Noga.AZ	"Nogales, AZ (District)",		  
VA_Norf.VA	"Norfolk, VA (District)",                 
*~"Norfolk/Mobile/Charleston (District)"? Ship building? (give to AL)
XX_NMC.AL	"Norfolk/Mobile/Charleston (District)",	       
NY_Ogde.NY	"Ogdensburg, NY (District)",		       
ND_Pemb.ND	"Pembina, ND (District)",		       
PA_Phil.PA	"Philadelphia, PA (District)",		       
TX_PrtA.TX	"Port Arthur, TX (District)",		       
ME_Port.ME	"Portland, ME (District)",		       
RI_Prov.RI	"Providence, RI (District)",		       
CA_SanD.CA	"San Diego, CA (District)",		       
CA_SanF.CA	"San Francisco, CA (District)",		       
XX_SanJ.MO	"San Juan, PR (District)",		       
GA_Sava.GA	"Savannah, GA (District)",		       
WA_Seat.WA	"Seattle, WA (District)",		       
VT_StAl.VT	"St. Albans, VT (District)",		       
MO_StLo.MO	"St. Louis, MO (District)",		       
FL_Tamp.FL	"Tampa, FL (District)",			       
XX_USVI.MO	"U.S. Virgin Islands (District)",	       
XX_VUOP.MO	"Vessels Under Own Power (District)",	       
DC_Wash.DC	"Washington, DC (District)",		       
NC_Wilm.NC	"Wilmington, NC (District)"                    
/;

Parameter 
	node_imp(s,i) International exports by state-level node ($B),
	node_exp(s,i) International exports by state-level node ($B);

node_imp(s,i) = sum(rmap(dist,s),GTAPimp(dist,i))*1e-9;
node_exp(s,i) = sum(rmap(dist,s),GTAPexp(dist,i))*1e-9;

totchk("imp") = sum((s,i),
                      node_imp(s,i)    
		    )-HSimp("usa_all","0")*1e-9;
totchk("exp") = sum((s,i),
                      node_exp(s,i)    
		    )-HSexp("usa_all","0")*1e-9;

Abort$round(totchk("imp"),9) "Data read error: sum over GTAP-good imports does not equal total imports",totchk;
Abort$round(totchk("exp"),9) "Data read error: sum over GTAP-good exports does not equal total exports",totchk;

parameter 
	osdrpt(*,*) report on oilseeds (mostly soybeans) nodal exports;
osdrpt(s,"$B")	    = node_exp(s,"osd")$(node_exp(s,"osd") gt 0.2);
osdrpt("rest","$B") = sum(s$(node_exp(s,"osd") le 0.2),node_exp(s,"osd"));
osdrpt("tot","$B")=sum(s,node_exp(s,"osd"));

osdrpt(s,"pct") = 100*node_exp(s,"osd")$(node_exp(s,"osd") gt 0.2)/osdrpt("tot","$B");
osdrpt("rest","pct") = 100*sum(s$(node_exp(s,"osd") le 0.2),node_exp(s,"osd"))/osdrpt("tot","$B");
osdrpt("tot","pct")=100*sum(s,node_exp(s,"osd"))/osdrpt("tot","$B");

display osdrpt;

execute_unload 'trade_data\node_trade.gdx', node_imp, node_exp;
