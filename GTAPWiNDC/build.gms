$title	GAMS Script to Create GTAP-WiNDC Datasets

***** run after the core and household builds are complete!! *****


*$set start windc_model

* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* set year(s) to compute data (cps: 2000-2021, soi: 2014-2017)
$if not set year $set year 2017


*-----------------------
*   If the value of gtapingams is not set via command line,
*   then set its value. If the data for gtap11 exists, then
*   gtapingams will be set to gtap11, otherwise gtap9
*-----------------------


$ifThen not set gtapingams
$ifThen exist "../data/GTAPWiNDC/gtap11/GDX_AY1017.zip" 
$set gtapingams  gtap11/
$else
$set gtapingams gtap9/
$endif
$endif

$set year 2011
$set gtapingams gtap9/

$ifThen not exist "%gtapingams%/%year%/g20_32.gdx"
$call gams %gtapingams%build.gms o=lst/gtap.lst 
$endif


$exit

* ------------------------------------------------------------------------
*	Use GE model replications to verify consistency of
*	dataset adjustments:

$set debug no

*	Pause after each step?

$set pause no
* ------------------------------------------------------------------------
*	Create all the directories for running the script

$if not dexist datasets		  $call mkdir datasets
$if not dexist datasets\windc	  $call mkdir datasets\windc
$if not dexist datasets\gtapwindc $call mkdir datasets\gtapwindc
$if not dexist lst		  $call mkdir lst

* ------------------------------------------------------------------------
*	Jump to a starting point:


$if set start $goto %start%

* ------------------------------------------------------------------------
*	        Verify benchmark consistency of the canonical GTAP model:
* ------------------------------------------------------------------------

$log	Ready to run gtap_model for g20_32 (no output)
$if not %pause%==no $call pause
$if not %debug%==no $call gams gtap_model --ds=g20_32 --gtapingams=%gtapingams% o=lst\gtap_model_32.lst

$if errorlevel 1 $log   "Non-zero return code from gtap_model.gms"
$if errorlevel 1 $abort "Non-zero return code from gtap_model.gms"

* ------------------------------------------------------------------------
*	Translate the GTAP dataset into a GTAPWiNDC dataset
*	with one subregion per country.
* ------------------------------------------------------------------------
$log	Ready to run WRITE_STUB (datasets\gtapwindc\32_stub.gdx)
$if not %pause%==no $call pause
$call gams write_stub --ds=g20_32 o=lst\write_stub_32.lst --ds=g20_32 --gtapingams=%gtapingams% --dsout=datasets\gtapwindc\32_stub.gdx

$if errorlevel 1 $log   "Non-zero return code from write_stub.gms"
$if errorlevel 1 $abort "Non-zero return code from write_stub.gms"

* ------------------------------------------------------------------------
*	Verify benchmark consistency of the stub dataset:
* ------------------------------------------------------------------------
$log	"Ready to check 32_stub with GTAPWINDC_MGE  (no output)"
$if not %pause%==no $call pause
$label chkstub32
$if not %debug%==no $call gams gtapwindc_mge --gtapwindc_datafile=datasets\gtapwindc\32_stub.gdx o=lst\gtapwindc_mge_32_stub.lst

$if errorlevel 1 $log   "Non-zero return code from gtapwindc_mge.gms"
$if errorlevel 1 $abort "Non-zero return code from gtapwindc_mge.gms"


* ------------------------------------------------------------------------
*        Generate a gdx file with the CPS household dataset:
* ------------------------------------------------------------------------
$label windc_model
$log	"Ready to run WINDC_MODEL  (datasets\windc\32.gdx)"
$if not %pause%==no $call pause
$call gams windc_model --windc_datafile=..\household\datasets\WINDC_cps_static_all_%year%_gtap_32_state.gdx gdx=datasets\windc\32.gdx o=lst\windc_model_32.lst


$if errorlevel 1 $log   "Non-zero return code from windc_model.gms"
$if errorlevel 1 $abort "Non-zero return code from windc_model.gms"

* ------------------------------------------------------------------------
*	Reconcile the WiNDC datasets with the GTAP dataset and 
*	generate two GTAP-WiNDC datasets that are saved in 
*	directory datasets\gtapwindc.
* ------------------------------------------------------------------------
$label regiondisagg32

*	This is a regional disaggregation routine which works with two datasets
*	which have the same sectoral structure, one from WiNDC and another from
*	GTAP 

$log	"Ready to run regiondisagg (datasets\gtapwindc\32.gdx)"
$if not %pause%==no $call pause
$call gams regiondisagg --windc_gdx=datasets\windc\32.gdx --gtapwindc_datafile=datasets\gtapwindc\32_stub --dsout=datasets\gtapwindc\32.gdx   o=lst\regiondisagg_32.lst 

$if errorlevel 1 $log   "Non-zero return code from regiondisagg.gms for 32.gdx"
$if errorlevel 1 $abort "Non-zero return code from regiondisagg.gms for 32.gdx"

* ---------------------------------------------------------------------------
*	Solve a GTAPWINDC model to verify consistency of the 32 sector model:
* ---------------------------------------------------------------------------

$label chk32
$log	"Ready to verify consistency of 32 sector dataset (no output)"
$if not %pause%==no $call pause
$if not %debug%==no $call gams gtapwindc_mge --gtapwindc_datafile=datasets\gtapwindc\32.gdx o=lst\gtapwindc_mge_32.lst

$if errorlevel 1 $log   "Non-zero return code from gtapwindc_mge.gms"
$if errorlevel 1 $abort "Non-zero return code from gtapwindc_mge.gms"





$exit




* ------------------------------------------------------------------------
*	Bring together GTAP and USDA data to disaggregate AGR to
*	pdr, wht, gro, v_f, osd, c_b, pfb, ocr, ctl, oap, rmk and wol,
*	targeting US national totals from the GTAP datata and state-level
*	output shares from the USDA cash receipts for each state.
*	Demand coefficients for agricultural products are targetted using
*	the GTAP dataset.
* ---------------------------------------------------------------------------

$label verify43
*	------------------------------------------------------------------------
*	Verify that the 43 sector GTAP dataset is balanced:
*	------------------------------------------------------------------------
$log	Ready to replicate GTAP benchmark for g20_43  (no output)
$if not %pause%==no $call pause
$if not %debug%==no $call gams gtap_model --ds=g20_43 --gtapingams=%gtapingams% o=lst\gtap_model_43.lst

$if errorlevel 1 $log   "Non-zero return code from gtap_model.gms with g20_43"
$if errorlevel 1 $abort "Non-zero return code from gtap_model.gms with g20_43"

$label write_stub43
* ------------------------------------------------------------------------
*	Generate a stub dataset based on the 43 sector GTAP dataset:
* ------------------------------------------------------------------------

$log	Ready to translate GTAP data for g20_43 (datasets\gtapwindc\43_stub.gdx)
$if not %pause%==no $call pause

$call gams write_stub --ds=g20_43 o=lst\write_stub_43.lst --ds=g20_43 --dsout=datasets\gtapwindc\43_stub.gdx

$if errorlevel 1 $log   "Non-zero return code from write_stub.gms with g20_43"
$if errorlevel 1 $abort "Non-zero return code from write_stub.gms with g20_43"

$label chkstub43
* ------------------------------------------------------------------------
*	Check that the stub dataset is balanced.
* ------------------------------------------------------------------------

$log	Ready to check gtapg20_43_stub :
$if not %pause%==no $call pause

$if not %debug%==no $call gams gtapwindc_mge --gtapwindc_datafile=datasets\gtapwindc\43_stub.gdx o=lst\gtapwindc_mge_43_stub.lst

$if errorlevel 1 $log   "Non-zero return code from gtapwindc_mge.gms with g20_43_stub"
$if errorlevel 1 $abort "Non-zero return code from gtapwindc_mge.gms with g20_43_stub"



$label agrdisagg
* ------------------------------------------------------------------------
*	Disaggregate the agricultural sectors in the 32 sector WiNDC
*	dataset to produce a 43 sector WiNDC dataset (not GTAPWiNDC yet).
* ------------------------------------------------------------------------

$log	Ready to disaggreate agricultural sectors (datasets\windc\43.gdx)
$if not %pause%==no $call pause

$set windc_datafile ..\household\datasets\WINDC_cps_static_gtap_32_state.gdx
$call gams agrdisagg --windc_datafile=%windc_datafile% --gtap_agr=gtap_agr.gdx --gtapingams=%gtapingams% --dsout=datasets\windc\43.gdx o=lst\agrdisagg.lst

$if errorlevel 1 $log   "Non-zero return code from agrdisagg.gms"
$if errorlevel 1 $abort "Non-zero return code from agrdisagg.gms"



$label windc_model_43
* ------------------------------------------------------------------------
*	Verify consistency of the disaggregate dataset:
* ------------------------------------------------------------------------
$log	"Ready to check WiNDC model with datasets\windc\43.gdx (no output)"
$if not %pause%==no $call pause
$if not %debug%==no $call gams windc_model --windc_datafile=datasets\windc\43.gdx o=lst\windc_model_43.lst --oneyear=true

$if errorlevel 1 $log   "Non-zero return code from windc_model.gms for 43.gdx"
$if errorlevel 1 $abort "Non-zero return code from windc_model.gms for 43.gdx"

$label regiondisagg43
* ------------------------------------------------------------------------
*	Use the 43 sector WiNDC dataset to disaggregate the 43 sector 
*	GTAP stub data.
* ------------------------------------------------------------------------

$log	"Ready to run regiondisagg with 43 sector dataset  (datasets\gtapwindc\43.gdx)"
$if not %pause%==no $call pause
$call gams regiondisagg --dropagr=yes --windc_gdx=datasets\windc\43.gdx --gtapwindc_datafile=datasets\gtapwindc\43_stub --dsout=datasets\gtapwindc\43.gdx   o=lst\regiondisagg_43.lst 

$if errorlevel 1 $log   "Non-zero return code from regiondisagg.gms for 43.gdx"
$if errorlevel 1 $abort "Non-zero return code from regiondisagg.gms for 43.gdx"

$label chk43
* ------------------------------------------------------------------------
*	Perform a benchmark replication with the final dataset.
* ------------------------------------------------------------------------

$log	"Ready to verify consistency of datasets\gtapwindc\43.gdx "
$if not %pause%==no $call pause

$if not %debug%==no $call gams gtapwindc_mge --gtapwindc_datafile=datasets\gtapwindc\43.gdx o=lst\gtapwindc_mge_43.lst 

$if errorlevel 1 $log   "Non-zero return code from gtapwindc_mge for 43.gdx"
$if errorlevel 1 $abort "Non-zero return code from gtapwindc_mge for for 43.gdx"

