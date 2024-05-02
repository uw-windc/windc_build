$title	GAMS Script to Create GTAP-WiNDC Datasets

*	Choose a starting point if desired

$set start chkstub32

*---------------------- 
* run after the core and household builds are complete!! 
* ---------------------

*-----------------------
*   If the value of gtapingams is not set via command line,
*   then set its value. If the data for gtap11 exists, then
*   gtapingams will be set to gtap11, otherwise gtap9
*-----------------------

$include gtapingams

* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* set year(s) to compute data 
* -- gtap11a: 2017, 2014, 2011
* -- gtap11: 2017, 2014, 2011
* -- gtap9 : 2011

*	Data files exist for 2004 and 2007, but these do not have carbon
*	and energy data.  They could be used if those inputs are dropped
*	from the code.
$if not set year $set year 2017

* ------------------------------------------------------------------------
*	Use GE model replications to verify consistency of
*	dataset adjustments:

$set debug yes

*	Pause after each step?

$set pause yes
* ------------------------------------------------------------------------
*	Create all the directories for running the script
*   %system.dirsep% is necessary here because windows

$set datasets "%year%"

$if not dexist %datasets%		  $call mkdir %datasets%
$if not dexist %datasets%%system.dirsep%windc	  $call mkdir "%datasets%%system.dirsep%windc"
$if not dexist %datasets%%system.dirsep%gtapwindc $call mkdir "%datasets%%system.dirsep%gtapwindc"
$if not dexist lst		  $call mkdir lst

* ------------------------------------------------------------------------
*	Jump to a starting point:

$if set start $goto %start%


*----------------------------------------
* Test if the target aggregation exists. If not, generate the aggregation
*----------------------------------------
$ifThen not exist "%gtapingams%/%gtap_version%/%year%/g20_32.gdx"
$call gams %gtapingams%build.gms --year=%year% --aggregation=g20_32 --gtap_zip_path=%gtap_zip_path% --gtap_version=%gtap_version% o=lst/gtap.lst 
$endif


* ------------------------------------------------------------------------
*	        Verify benchmark consistency of the canonical GTAP model:
* ------------------------------------------------------------------------

$log	Ready to run gtap_model for g20_32 (no output)
$if not %pause%==no $call pause
$if not %debug%==no $call gams gtap_model --ds=g20_32 --gtapingams=%gtapingams% o=lst/gtap_model_32.lst

$if errorlevel 1 $log   "Non-zero return code from gtap_model.gms"
$if errorlevel 1 $abort "Non-zero return code from gtap_model.gms"

* ------------------------------------------------------------------------
*	Translate the GTAP dataset into a GTAPWiNDC dataset
*	with one subregion per country.
* ------------------------------------------------------------------------
$label write_stub
$log	Ready to run WRITE_STUB (datasets/gtapwindc/32_stub.gdx)
$if not %pause%==no $call pause
$call gams write_stub --ds=g20_32 o=lst/write_stub_32.lst --gtapingams=%gtapingams% --dsout=%datasets%/gtapwindc/32_stub.gdx

$if errorlevel 1 $log   "Non-zero return code from write_stub.gms"
$if errorlevel 1 $abort "Non-zero return code from write_stub.gms"

* ------------------------------------------------------------------------
*	Verify benchmark consistency of the stub dataset:
* ------------------------------------------------------------------------
$log	"Ready to check 32_stub with GTAPWINDC_MGE  (no output)"
$if not %pause%==no $call pause

$label chkstub32
$if not %debug%==no $call gams gtapwindc_mge --gtapwindc_datafile=%datasets%/gtapwindc/32_stub.gdx o=lst/gtapwindc_mge_32_stub.lst

$if errorlevel 1 $log   "Non-zero return code from gtapwindc_mge.gms"
$if errorlevel 1 $abort "Non-zero return code from gtapwindc_mge.gms"


* ------------------------------------------------------------------------
*        Generate a gdx file with the CPS household dataset:
* ------------------------------------------------------------------------
$label windc_model
$log	"Ready to run WINDC_MODEL  (datasets/windc/32.gdx)"
$if not %pause%==no $call pause
$call gams windc_model --windc_datafile=../household/datasets/WINDC_cps_static_all_%year%_gtap_32_state.gdx gdx=%datasets%/windc/32.gdx o=lst/windc_model_32.lst


$if errorlevel 1 $log   "Non-zero return code from windc_model.gms"
$if errorlevel 1 $abort "Non-zero return code from windc_model.gms"

* ------------------------------------------------------------------------
*	Reconcile the WiNDC datasets with the GTAP dataset and 
*	generate two GTAP-WiNDC datasets that are saved in 
*	directory datasets/gtapwindc.
* ------------------------------------------------------------------------
$label regiondisagg32

*	This is a regional disaggregation routine which works with two datasets
*	which have the same sectoral structure, one from WiNDC and another from
*	GTAP 

$log	"Ready to run regiondisagg (datasets/gtapwindc/32.gdx)"
$if not %pause%==no $call pause
$call gams regiondisagg --ds=32 --datasets=%datasets% o=lst/regiondisagg_32.lst 

$if errorlevel 1 $log   "Non-zero return code from regiondisagg.gms for 32.gdx"
$if errorlevel 1 $abort "Non-zero return code from regiondisagg.gms for 32.gdx"

* ---------------------------------------------------------------------------
*	Solve a GTAPWINDC model to verify consistency of the 32 sector model:
* ---------------------------------------------------------------------------

$label chk32
$log	"Ready to verify consistency of 32 sector dataset (no output)"
$if not %pause%==no $call pause
$if not %debug%==no $call gams gtapwindc_mge --gtapwindc_datafile=%datasets%/gtapwindc/32.gdx o=lst/gtapwindc_mge_32.lst

$if errorlevel 1 $log   "Non-zero return code from gtapwindc_mge.gms"
$if errorlevel 1 $abort "Non-zero return code from gtapwindc_mge.gms"


$label g20_43
*----------------------------------------
* Test if the target aggregation exists. If not, generate the aggregation
*----------------------------------------
$ifthen not exist "%gtapingams%/%gtap_version%/%year%/g20_43.gdx"
$call gams %gtapingams%build.gms --year=%year% --aggregation=g20_43 --gtap_zip_path=%gtap_zip_path% --gtap_version=%gtap_version% o=lst/gtap.lst 
$endif

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
$if not %debug%==no $call gams gtap_model --ds=g20_43 --gtapingams=%gtapingams% o=lst/gtap_model_43.lst

$if errorlevel 1 $log   "Non-zero return code from gtap_model.gms with g20_43"
$if errorlevel 1 $abort "Non-zero return code from gtap_model.gms with g20_43"

$label write_stub43
* ------------------------------------------------------------------------
*	Generate a stub dataset based on the 43 sector GTAP dataset:
* ------------------------------------------------------------------------

$log	Ready to translate GTAP data for g20_43 (datasets/gtapwindc/43_stub.gdx)
$if not %pause%==no $call pause

$call gams write_stub --ds=g20_43 o=lst/write_stub_43.lst --dsout=%datasets%/gtapwindc/43_stub.gdx

$if errorlevel 1 $log   "Non-zero return code from write_stub.gms with g20_43"
$if errorlevel 1 $abort "Non-zero return code from write_stub.gms with g20_43"

$label chkstub43
* ------------------------------------------------------------------------
*	Check that the stub dataset is balanced.
* ------------------------------------------------------------------------

$log	Ready to check gtapg20_43_stub :
$if not %pause%==no $call pause

$if not %debug%==no $call gams gtapwindc_mge --gtapwindc_datafile=%datasets%/gtapwindc/43_stub.gdx o=lst/gtapwindc_mge_43_stub.lst

$if errorlevel 1 $log   "Non-zero return code from gtapwindc_mge.gms with g20_43_stub"
$if errorlevel 1 $abort "Non-zero return code from gtapwindc_mge.gms with g20_43_stub"



$label agrdisagg
* ------------------------------------------------------------------------
*	Disaggregate the agricultural sectors in the 32 sector WiNDC
*	dataset to produce a 43 sector WiNDC dataset (not GTAPWiNDC yet).
* ------------------------------------------------------------------------

$log	Ready to disaggreate agricultural sectors (%datasets%/windc/43.gdx)
$if not %pause%==no $call pause

$set windc_datafile ../household/datasets/WINDC_cps_static_all_%year%_gtap_32_state.gdx
$call gams agrdisagg --datafile=%windc_datafile% --gtap_agr=gtap_agr.gdx --gtapingams=%gtapingams% --dsout=%datasets%/windc/43.gdx o=lst/agrdisagg.lst

$if errorlevel 1 $log   "Non-zero return code from agrdisagg.gms"
$if errorlevel 1 $abort "Non-zero return code from agrdisagg.gms"

$label windc_model_43
* ------------------------------------------------------------------------
*	Verify consistency of the disaggregate dataset:
* ------------------------------------------------------------------------
$log	"Ready to check WiNDC model with datasets/windc/43.gdx (no output)"
$if not %pause%==no $call pause
$if not %debug%==no $call gams windc_model --windc_datafile=%datasets%/windc/43.gdx o=lst/windc_model_43.lst --oneyear=true

$if errorlevel 1 $log   "Non-zero return code from windc_model.gms for 43.gdx"
$if errorlevel 1 $abort "Non-zero return code from windc_model.gms for 43.gdx"

$label regiondisagg43
* ------------------------------------------------------------------------
*	Use the 43 sector WiNDC dataset to disaggregate the 43 sector 
*	GTAP stub data.
* ------------------------------------------------------------------------

$log	"Ready to run regiondisagg with 43 sector dataset  (datasets/gtapwindc/43.gdx)"
$if not %pause%==no $call pause
$call gams regiondisagg  --ds=43 --dropagr=yes  o=lst/regiondisagg_43.lst 

$if errorlevel 1 $log   "Non-zero return code from regiondisagg.gms for 43.gdx"
$if errorlevel 1 $abort "Non-zero return code from regiondisagg.gms for 43.gdx"

$label chk43
* ------------------------------------------------------------------------
*	Perform a benchmark replication with the final dataset.
* ------------------------------------------------------------------------

$log	"Ready to verify consistency of datasets/gtapwindc/43.gdx "
$if not %pause%==no $call pause

$if not %debug%==no $call gams gtapwindc_mge --gtapwindc_datafile=%datasets%/gtapwindc/43.gdx o=lst/gtapwindc_mge_43.lst 

$if errorlevel 1 $log   "Non-zero return code from gtapwindc_mge for 43.gdx"
$if errorlevel 1 $abort "Non-zero return code from gtapwindc_mge for for 43.gdx"

