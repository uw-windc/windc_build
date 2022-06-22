$title	GAMS Script to Create Two GTAP-WiNDC Datasets

* Model dimension - (default is 10)
$if not set dim $set dim 10

* File separator: 
$set fs %system.dirsep%

*	Create all the directories for running the script

*  Intermediate and output datasets are saved in the directory
*  "datastes"
$if not dexist datasets $call mkdir datasets
$if not dexist datasets%fs%windc $call mkdir datasets%fs%windc
$if not dexist datasets%fs%gtapwindc $call mkdir datasets%fs%gtapwindc
$if not dexist lst $call mkdir lst


* ------------------------------------------------------------------------
*	        Verify benchmark consistency of the canonical GTAP model:
* ------------------------------------------------------------------------

$call gams gtap_model --ds=gtap_%dim% o=lst%fs%gtap_model_gtap_%dim%.lst


* ------------------------------------------------------------------------
*	        Create data structures with a stub (rest) household and 
*	        subregion in each region:
* ------------------------------------------------------------------------

$call gams write_stub o=lst%fs%write_stub.lst --ds=gtap_%dim%


* ------------------------------------------------------------------------
*	        Verify benchmark consistency of the stub dataset:
* ------------------------------------------------------------------------

$set ds gtap_%dim%_stub
$call gams gtapwindc_mge --ds=%ds% o=lst%fs%gtapwindc_mge_%ds%.lst


* ------------------------------------------------------------------------
*        Generate gdx files for 2014 with the CPS and SOI household data:
* ------------------------------------------------------------------------

$label windc_model

* CPS
$set ds   cps_static_gtap_%dim%_state
$set year 2014
$call gams windc_model --ds=%ds% --year=%year% gdx=datasets%fs%windc%fs%%ds%_%year%.gdx o=lst%fs%windc_model%ds%_%year%.lst

* SOI
$set ds   soi_static_gtap_%dim%_state
$set year 2014
$call gams windc_model --ds=%ds% --year=%year% gdx=datasets%fs%windc%fs%%ds%_%year%.gdx o=lst%fs%windc_model%ds%_%year%.lst

* ------------------------------------------------------------------------
*         Reconcile the WiNDC datasets with the GTAP dataset and 
*         generate two GTAP-WiNDC datasets that are saved in 
*         directory datasets%fs%gtapwindc:
* ------------------------------------------------------------------------

$label balance

* CPS
$set windc_data   cps_static_gtap_%dim%_state_2014
$set gtap_data    gtap_%dim%_stub
$set dsout        gtap_%dim%_cps_2014
$call gams balance --windc_data=%windc_data% --dsout=%dsout% o=lst%fs%balance_%dsout%.lst --gtap_data=%gtap_data%


* SOI
$set windc_data   soi_static_gtap_%dim%_state_2014
$set dsout        gtap_%dim%_soi_2014
$set gtap_data    gtap_%dim%_stub
$call gams balance --windc_data=%windc_data% --dsout=%dsout% o=lst%fs%balance_%dsout%.lst --gtap_data=%gtap_data%

* ------------------------------------------------------------------------
*         Canonical GTAP-WiNDC model
* ------------------------------------------------------------------------

$label bmkchk

* CPS
$set ds gtap_%dim%_cps_2014
$call gams gtapwindc_mge --ds=%ds% o=lst%fs%gtapwindc_mge_%ds%.lst

* SOI
$set ds gtap_%dim%_soi_2014
$call gams gtapwindc_mge --ds=%ds% o=lst%fs%gtapwindc_mge_%ds%.lst

* ------------------------------------------------------------------------
*        Tariff Quota Simulations with the GTAP-WiNDC Model
* ------------------------------------------------------------------------

$label tqmodel

$set ds gtap_%dim%_cps_2014
$call gams tqmodel o=lst%fs%tqmodel.lst --ds=%ds% 

