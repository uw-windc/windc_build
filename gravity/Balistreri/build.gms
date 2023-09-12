$title	GAMS Script to Create GTAP-WiNDC Datasets with bilateral state trade

* ------------------------------------------------------------------------

*	Pause after each step?

$set pause no

$goto startwork
* ------------------------------------------------------------------------
*	Create the output directories

$if not dexist bilat_data	  $call mkdir bilat_data
$if not dexist lst		  $call mkdir lst

$ontext

The subdirectory trade_data must include the Census data and various
domain and mapping files.  It also includes the processed (converted to
gdx) state-state distance data from Julian Hinz. Direct questions to 
"edward.balistreri@unl.edu":

...\windc_build-WiNDC3.2\bilat\trade_data
  20-Jul-2023  10:29:16a        <DIR>     .
  20-Jul-2023  10:29:16a        <DIR>     ..
  21-Jul-2023  11:28:38a         27,257   dist.gdx
  18-Jul-2023   9:46:32a        343,645   HS6_domain.txt
  17-Jul-2023   2:47:14p        421,299   HS_domain.txt
  18-Jul-2023  12:33:44p      1,226,724   HS_GTAP.map
  18-Jul-2023   2:01:28p      2,675,309   Port_Dist_Exp_2017_HS.xlsx
  18-Jul-2023   2:03:44p      2,323,892   Port_Dist_Imp_2017_HS.xlsx
  18-Jul-2023   2:32:54p          2,061   port_district_domain.txt

$offtext


* ------------------------------------------------------------------------
*	Extract the HS6 port-district level data into state-indexed arrays 
*	aggregated to GTAPinGAMS commodities, and write to the file:
*	"trade_data\node_trade.gdx".  The source is Census.   
* ------------------------------------------------------------------------

$call gams read_HS_trade o=lst\read_HS_trade.lst

$if not %pause%==no $call pause

$if errorlevel 1 $log   "Non-zero return code from read_HS_trade"
$if errorlevel 1 $abort "Non-zero return code from read_HS_trade"

* ------------------------------------------------------------------------
*	Aggregate to a given GTAPinGAMS commodity mapping.
* ------------------------------------------------------------------------

$call gams aggregate_node --imap=43 o=lst\aggregate_node.lst

$if not %pause%==no $call pause

$if errorlevel 1 $log   "Non-zero return code from aggregate_node"
$if errorlevel 1 $abort "Non-zero return code from aggregate_node"

* ------------------------------------------------------------------------

$call gams bilat_mge.gms s=temp o=lst\bilat_mge.lst
$if not %pause%==no $call pause

$call gams recalib.gms r=temp s=temp2 o=lst\recalib.lst
$if not %pause%==no $call pause

$label startwork

*	Generate the gravity assignments one commodity at a time
$call gams gravity.gms r=temp2 --r=usa --i=osd o=lst\gravity.lst
$call gams gravity.gms r=temp2 --r=usa --i=pdr o=lst\gravity.lst

*	Currently we just test for osd and pdr but these commodity
*	coefficients will eventually need to be written to a gdx
*	and merged into a new altered GTAPWiNDC data file. 

