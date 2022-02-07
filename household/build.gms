$title		Build Routine for the WiNDC Household Dataset

*	Run after the core build is complete.

*	To run a single script assign hhcalib, dynamic_calib or consolidate

*$set runscript aggr

*	Create all the directories we need for building the household datasets:

$set sep %system.dirsep%
$if not dexist datasets $call mkdir datasets
$if not dexist lst $call mkdir lst
$if not dexist gdx $call mkdir gdx


$set lstdir lst%sep%

$set years 2014*2017

set	year /%years%/
	hhdata /cps,soi/
	invest /static,dynamic/;

file kutl; kutl.lw=0; put kutl; kutl.nw=0; kutl.nd=0; kutl.pw=32767;

$if set runscript $goto %runscript%
$if set start $goto %start%

*	Run cps_data.gms and soi_data.gms for each of the years:

loop((year,hhdata),
	put_utility 'title' /'Running ',year.tl,' with household dataset from ',hhdata.tl;
	put_utility 'exec'/'gams ',hhdata.tl,'_data o=%lstdir%',hhdata.tl,'_data_',year.tl,'.lst --year=',year.tl,
		' lo=4 lf=%lstdir%',hhdata.tl,'_data_',year.tl,'.log';
);


$label hhcalib

*	Run hhcalib.gms for each year, cps/soi, and for static and dynamic investment:

loop((year,hhdata,invest),
	put_utility 'title' /'Calibrating ',year.tl,' with ',hhdata.tl,' with invest=',invest.tl;
	put_utility 'exec'/'gams hhcalib o=%lstdir%hhcalib_',year.tl,'_',hhdata.tl,'_',invest.tl,'.lst',
		' --year=',year.tl,' --hhdata=',hhdata.tl,' --invest=',invest.tl,' --puttitle=no',
		' lo=4 lf=%lstdir%hhcalib_',year.tl,'_',hhdata.tl,'_',invest.tl,'.log';
);

$if set runscript $exit

$label dynamic_calib

*	Impose steady-state investment demand on the model:

put_utility kutl, 'title' / 'Running dynamic_calib.gms';
loop(year,
	put_utility kutl, 'exec' /
	  'gams dynamic_calib o=%lstdir%dynamic_calib_',year.tl,'.lst --year=',year.tl,
	  ' lo=4 lf=%lstdir%dynamic_calib_',year.tl,'.log';
);

$if set runscript $exit

*	Consolidate the datasets:

$label consolidate
loop((hhdata,invest),
	put_utility kutl, 'exec' /'gams consolidate o=%lstdir%consolidate_',hhdata.tl,'_',invest.tl,'.lst',
		' --hh_years=%years% --hhdata=',hhdata.tl,' --invest=',invest.tl,
		' lo=4 lf=%lstdir%consolidate_',hhdata.tl,'_',invest.tl,'.log';
	display $sleep(1) "Waiting one second between consolidate job submissions.";
);
$if set runscript $exit

$label aggr

*	Aggregate all the datasets:

set	ds				Source datasets
					/cps_static,cps_dynamic,soi_static,soi_dynamic/,
	rmap				Regional mappings /census,state/,
	smap				Sectoral mappings /windc,gtap,bluenote,macro/,
	aggregate(ds,rmap,smap)		Datasets to aggregate;

file kutl; kutl.lw=0; put kutl;

aggregate(ds,rmap,smap) = yes;

*	These datasets are identical to the disaggregate dataset:

aggregate(ds,"state","windc") = no;

loop(aggregate(ds,rmap,smap),
	put_utility 'exec' / 'gams aggr --ds=',ds.tl,' --smap=',smap.tl,' --rmap=',rmap.tl,
		' o=%lstdir%aggr_',ds.tl,'_',smap.tl,'_',rmap.tl,'.lst',
		' lo=4 lf=%lstdir%aggr_',ds.tl,'_',smap.tl,'_',rmap.tl,'.log';
);

$if set runscript $exit
