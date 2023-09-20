$title	Build for Bluenote Datasets based on Household Data (2000-2021)

*-----
* run after the core and household builds are complete!!
*-----

* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* set year(s) to compute data (cps: 2000-2021, soi: 2014-2017)
$if not set year $set year "2016,2021"

* set household data (cps, soi)
$if not set hhdata $set hhdata "cps"

* set investment calibration (static, dynamic)
$if not set invest $set invest "static"

* set assumption on capital ownership (all,partial)
$if not set capital_ownership $set capital_ownership "all"

* set regional mapping (state,census_divisions,census_regions,national)
$if not set rmap $set rmap "census_regions"

* set sectoral mapping (windc,gtap_32,sage,gtap_10,macro,bluenote)
$if not set smap $set smap "sage"


*------------------------------------------------------------------------------
* Create directories if necessary
*------------------------------------------------------------------------------

$if not dexist lst	$call mkdir lst
$set lstdir lst/
$if not dexist datasets $call mkdir datasets
$if not dexist gdx	$call mkdir gdx


*------------------------------------------------------------------------------
* Data dimensions
*------------------------------------------------------------------------------

set
    year 		Years of data /%year%/,
    hhdata 		Household data /%hhdata%/,
    invest 		Investment calibration options /%invest%/,
    capital_ownership	Assumption on capital ownership /%capital_ownership%/,
    smap 		Sectoral mapping /%smap%/,
    rmap 		Regional mapping /%rmap%/;

parameter myerrorlevel "For error checking when calling files.";

*------------------------------------------------------------------------------
* Bluenote build routine
*------------------------------------------------------------------------------

file kutl; kutl.lw=0; put kutl;

* Disaggregate a few sectors based on the detailed BEA io tables for 2007 and
* 2012 and QCEW data on regional heterogeneity for detailed sectors:

loop((year,hhdata,invest,capital_ownership,smap),
    put_utility 'title' /'Disaggregating ',smap.tl,' sectors for ',year.tl,', ',hhdata.tl,', ',invest.tl,', ',capital_ownership.tl;
    put_utility 'exec'/'gams sectordisagg.gms o=%lstdir%sectordisagg_',year.tl,'_',hhdata.tl,'_',invest.tl,'_',capital_ownership.tl,'_',smap.tl,'.lst',
	' --year=',year.tl,' --hhdata=',hhdata.tl,' --invest=',invest.tl,
	' --capital_ownership=',capital_ownership.tl,' --smap=',smap.tl,
	' --puttitle=no',' lo=4 lf=%lstdir%sectordisagg_',year.tl,'_',hhdata.tl,'_',invest.tl,'_',capital_ownership.tl,'_',smap.tl,'.log';

    myerrorlevel = errorlevel;
    abort$(myerrorlevel>=2) "Error in sectordisagg.gms.";
);

* Aggregate to chosen sector and region aggregation:

loop((year,hhdata,invest,capital_ownership,smap,rmap),
    put_utility 'title' /'Aggregating ',smap.tl,' sectors and ',rmap.tl,' regions for ',year.tl,', ',hhdata.tl,', ',invest.tl,', ',capital_ownership.tl;
    put_utility 'exec'/'gams aggr.gms o=%lstdir%aggr_',year.tl,'_',hhdata.tl,'_',invest.tl,'_',capital_ownership.tl,'_',smap.tl,'_',rmap.tl,'.lst',
	' --year=',year.tl,' --hhdata=',hhdata.tl,' --invest=',invest.tl,
	' --capital_ownership=',capital_ownership.tl,' --smap=',smap.tl,' --rmap=',rmap.tl,
	' --puttitle=no',' lo=4 lf=%lstdir%aggr_',year.tl,'_',hhdata.tl,'_',invest.tl,'_',capital_ownership.tl,'_',smap.tl,'_',rmap.tl,'.log';

    myerrorlevel = errorlevel;
    abort$(myerrorlevel>=2) "Error in aggr.gms.";
);


$exit
* BROKEN BELOW
* Read SEDS data and do geographic aggregation (states or census regions)

$call 'gams readseds.gms --rmap=state o=%lstdir%readsets_state.lst'
$call 'gams readseds.gms --rmap=census o=%lstdir%readsets_census.lst'

*	Impose SEDS values in input output data and recalibrate

*	Generate datasets for each of the years:

loop((bnyear,hhdata,rmap),
	put_utility 'shell' /'gams bluenote.gms qcp=cplex --hhdata=',hhdata.tl,' --rmap=',rmap.tl,'  --bnyear=',bnyear.tl,' o=%lstdir%bluenote_',hhdata.tl,'_',rmap.tl,'_',bnyear.tl,'.lst';
);

*	Test eachof the datasets:

$label test

loop((bnyear,hhdata,rmap),
	put_utility 'shell' /'gams bluenote_model.gms --ds=WINDC_bluenote_',hhdata.tl,'_',rmap.tl,'_',bnyear.tl,' o=%lstdir%bluenote_model_',hhdata.tl,'_',rmap.tl,'_',bnyear.tl,'.lst';
);
