$title Build routine for the windc household dataset

*-----
* run after the core build is complete!! 
*-----

* to run individual build scripts, set %runscript% environment variable:
* $set runscript aggr


* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* set year(s) to compute data (cps: 2000-2023, soi: 2014-2017)
$if not set year $set year "2023"

* set household data (cps, soi)
$if not set hhdata $set hhdata "cps"

* set investment calibration (static, dynamic)
$if not set invest $set invest "static"

* set assumption on capital ownership (all,partial)
$if not set capital_ownership $set capital_ownership "all"

* set regional mapping (state,census_divisions,census_regions,national)
$if not set rmap $set rmap "state"

* set sectoral mapping (windc,gtap_32,sage,gtap_10,macro,bluenote)
$if not set smap $set smap "windc,gtap_32"


* ------------------------------------------------------------------------------
* Set steady-state parameter values (ignore if building static model)
* ------------------------------------------------------------------------------

* set economy-wide growth rate
$set gr 0.02

* set interest rate
$set ir 0.04

* set economy-wide depreciation rate
$set delta 0.05


*------------------------------------------------------------------------------
* Create directories if necessary
*------------------------------------------------------------------------------

$if not dexist datasets $call mkdir datasets
$if not dexist lst $call mkdir lst
$if not dexist gdx $call mkdir gdx
$set lstdir lst/


*------------------------------------------------------------------------------
* Data dimensions
*------------------------------------------------------------------------------

set
    year 		Years of data /%year%/,
    hhdata 		Household data /%hhdata%/,
    invest 		Investment calibration options /%invest%/,
    capital_ownership	Assumption on capital ownership /%capital_ownership%/,
    rmap		Regional mappings /%rmap%/,
    smap		Sectoral mappings /%smap%/;

parameter myerrorlevel "For error checking when calling files.";

*------------------------------------------------------------------------------
* Household build routine
*------------------------------------------------------------------------------

file kutl; kutl.lw=0; put kutl; kutl.nw=0; kutl.nd=0; kutl.pw=32767;

$if set runscript $goto %runscript%
$if set start $goto %start%

* Run cps_data.gms and soi_data.gms

loop(hhdata,
    put_utility 'title' /'Reading household dataset from ',hhdata.tl;
    put_utility 'exec'/'gams ',hhdata.tl,'_data o=%lstdir%',hhdata.tl,'_data.lst lo=4 lf=%lstdir%',hhdata.tl,'_data.log';

    myerrorlevel = errorlevel;
    abort$(myerrorlevel>=2) "There was an error loading the data.  Did you place the data in the correct location?";
);


* Calibrate household accounts to match %hhdata%:

$label hhcalib

loop((year,hhdata,invest,capital_ownership),

    put_utility 'title' /'Calibrating ',year.tl,' with ',hhdata.tl,' with invest=',invest.tl,
	' with capital_ownership=',capital_ownership.tl;

    put_utility 'exec'/'gams hhcalib o=%lstdir%hhcalib_',year.tl,'_',hhdata.tl,'_',invest.tl,'.lst',
	' --year=',year.tl,' --hhdata=',hhdata.tl,' --invest=',invest.tl,
	' --capital_ownership=',capital_ownership.tl,' --gr=%gr% --ir=%ir% --delta=%delta%',
	' --puttitle=no',' lo=4 lf=%lstdir%hhcalib_',year.tl,'_',hhdata.tl,'_',invest.tl,'.log';

    myerrorlevel = errorlevel;
    abort$(myerrorlevel>=2) "There was an error in hhcalib.";

*Only verified the calibration for 2016 and 2017. The bounds on the variables
*are likely driving the infeasibilities in other years. You may need to change
*constraints placed on household variables in hhcalib."
 
);

$if set runscript $exit

* Impose steady-state investment demand on the model if invest=="dynamic":

$label dynamic_calib

put_utility kutl, 'title' / 'Running dynamic_calib.gms';
loop((year,invest),
    put_utility kutl, 'exec' /
	'gams dynamic_calib o=%lstdir%dynamic_calib_',year.tl,'.lst --year=',year.tl,
	' --invest=',invest.tl,' lo=4 lf=%lstdir%dynamic_calib_',year.tl,'.log';
);

$if set runscript $exit

* Consolidate the datasets:

$label consolidate
loop((year,hhdata,invest,capital_ownership),

    put_utility kutl, 'title' / 'Running consolidate.gms';
    put_utility kutl, 'exec' /'gams consolidate o=%lstdir%consolidate_',invest.tl,'_',hhdata.tl,'_',capital_ownership.tl,'_',year.tl,'.lst',
	' --year=',year.tl,' --hhdata=',hhdata.tl,' --invest=',invest.tl,' --capital_ownership=',capital_ownership.tl,
	' lo=4 lf=%lstdir%consolidate_',invest.tl,'_',hhdata.tl,'_',capital_ownership.tl,'_',year.tl,'.log';
    display $sleep(1) "Waiting one second between consolidate job submissions.";
    
);
$if set runscript $exit


*------------------------------------------------------------------------------
* Aggregate the dataset
*------------------------------------------------------------------------------

$label aggr

* Define aggregation list

set
    aggregate(hhdata,invest,capital_ownership,year,*,*);

file kutl; kutl.lw=0; put kutl;

aggregate(hhdata,invest,capital_ownership,year,rmap,smap) = yes;

* these datasets are identical to the disaggregate dataset:
aggregate(hhdata,invest,capital_ownership,year,"state","windc") = no;

loop(aggregate(hhdata,invest,capital_ownership,year,rmap,smap),
    put_utility kutl, 'title' / 'Running aggr.gms';
    put_utility 'exec' / 'gams aggr --hhdata=',hhdata.tl,' --invest=',invest.tl,
	' --capital_ownership=',capital_ownership.tl,' --year=',year.tl,
	' --smap=',smap.tl,' --rmap=',rmap.tl,
	' o=%lstdir%aggr_',hhdata.tl,'_',invest.tl,'_',capital_ownership.tl,'_',year.tl,
	'_',smap.tl,'_',rmap.tl,'.lst',
	' lo=4 lf=%lstdir%aggr_',hhdata.tl,'_',invest.tl,'_',capital_ownership.tl,'_',
	year.tl,'_',smap.tl,'_',rmap.tl,'.log';

    myerrorlevel = errorlevel;
    abort$(myerrorlevel>=2) "There was an error in aggr.";

);

$if set runscript $exit


*------------------------------------------------------------------------------
* End
*------------------------------------------------------------------------------
