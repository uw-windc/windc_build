$title Build routine for the windc household dataset

***** run after the core build is complete!! *****

* to run individual build scripts, set %runscript% environment variable:
* $set runscript aggr

* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* system separator
$set sep %system.dirsep%

* years of household data (constrained by cps data)
$set years 2000*2017


*------------------------------------------------------------------------------
* Create directories if necessary
*------------------------------------------------------------------------------

$if not dexist datasets $call mkdir datasets
$if not dexist lst $call mkdir lst
$if not dexist gdx $call mkdir gdx
$set lstdir lst%sep%


*------------------------------------------------------------------------------
* Data dimensions
*------------------------------------------------------------------------------

set
    year 	Years of data /%years%/,
    hhdata 	Household data /cps,soi/,
    invest 	Investment calibration options /static,dynamic/,
    rmap	Regional mappings /state/,
    smap	Sectoral mappings /windc/;


*------------------------------------------------------------------------------
* Household build routine
*------------------------------------------------------------------------------

file kutl; kutl.lw=0; put kutl; kutl.nw=0; kutl.nd=0; kutl.pw=32767;

$if set runscript $goto %runscript%
$if set start $goto %start%

* run cps_data.gms and soi_data.gms
loop(hhdata,
    put_utility 'title' /'Reading household dataset from ',hhdata.tl;
    put_utility 'exec'/'gams ',hhdata.tl,'_data o=%lstdir%',hhdata.tl,'_data.lst lo=4 lf=%lstdir%',hhdata.tl,'_data.log';
);


* run hhcalib.gms for each year, cps/soi, and for static and dynamic investment:
$label hhcalib
loop((year,hhdata,invest),
    put_utility 'title' /'Calibrating ',year.tl,' with ',hhdata.tl,' with invest=',invest.tl;
    put_utility 'exec'/'gams hhcalib o=%lstdir%hhcalib_',year.tl,'_',hhdata.tl,'_',invest.tl,'.lst',
	' --year=',year.tl,' --hhdata=',hhdata.tl,' --invest=',invest.tl,' --puttitle=no',
	' lo=4 lf=%lstdir%hhcalib_',year.tl,'_',hhdata.tl,'_',invest.tl,'.log';
);

$if set runscript $exit


* impose steady-state investment demand on the model:
$label dynamic_calib
put_utility kutl, 'title' / 'Running dynamic_calib.gms';
loop(year,
    put_utility kutl, 'exec' /
	'gams dynamic_calib o=%lstdir%dynamic_calib_',year.tl,'.lst --year=',year.tl,
	' lo=4 lf=%lstdir%dynamic_calib_',year.tl,'.log';
);

$if set runscript $exit

* consolidate the datasets:
$label consolidate
loop((hhdata,invest),
    put_utility kutl, 'exec' /'gams consolidate o=%lstdir%consolidate_',hhdata.tl,'_',invest.tl,'.lst',
	' --hh_years=%years% --hhdata=',hhdata.tl,' --invest=',invest.tl,
	' lo=4 lf=%lstdir%consolidate_',hhdata.tl,'_',invest.tl,'.log';
    display $sleep(1) "Waiting one second between consolidate job submissions.";
);
$if set runscript $exit


*------------------------------------------------------------------------------
* Aggregate the datasets
*------------------------------------------------------------------------------

$label aggr

set
    ds	Source datasets /cps_static,cps_dynamic,soi_static,soi_dynamic/,
    aggregate(ds,rmap,smap) Datasets to aggregate;

file kutl; kutl.lw=0; put kutl;

aggregate(ds,rmap,smap) = yes;

* these datasets are identical to the disaggregate dataset:
aggregate(ds,"state","windc") = no;

loop(aggregate(ds,rmap,smap),
    put_utility 'exec' / 'gams aggr --ds=',ds.tl,' --smap=',smap.tl,' --rmap=',rmap.tl,
	' o=%lstdir%aggr_',ds.tl,'_',smap.tl,'_',rmap.tl,'.lst',
	' lo=4 lf=%lstdir%aggr_',ds.tl,'_',smap.tl,'_',rmap.tl,'.log';
);

$if set runscript $exit


*------------------------------------------------------------------------------
* End
*------------------------------------------------------------------------------
