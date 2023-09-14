$title	Build for Bluenote Datasets based on Household Data (2015-2017)

set	bnyear /2014*2017/
	hhdata /cps,soi/
	rmap /state,census/;

file kutl; kutl.lw=0; put kutl;


$set sep %system.dirsep%

$if not dexist lst	$call mkdir lst
$set lstdir lst%sep%
$if not dexist datasets $call mkdir datasets
$if not dexist gdx	$call mkdir gdx


*	Disaggregate a few sectors based on the detailed BEA io tables 
*	for 2007 and 2012:

$call 'gams sectordisagg.gms --hhdata=cps o=%lstdir%sectordisagg_cps.lst'
$call 'gams sectordisagg.gms --hhdata=soi o=%lstdir%sectordisagg_soi.lst'

*	Aggregate to bluenote sectors and either states or census regions:

$call 'gams aggregate.gms --hhdata=cps --rmap=state  o=%lstdir%aggregate_cps_state.lst'
$call 'gams aggregate.gms --hhdata=soi --rmap=state  o=%lstdir%aggregate_soi_state.lst'
$call 'gams aggregate.gms --hhdata=cps --rmap=census o=%lstdir%aggregate_cps_census.lst'
$call 'gams aggregate.gms --hhdata=soi --rmap=census o=%lstdir%aggregate_soi_census.lst'

*	Read SEDS data and do geographic aggregation (states or census regions)

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
