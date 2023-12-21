$title	Canonical Template GTAP-WINDC Model (MGE format)

*	Read the data:

$if not set ds $set ds 43
$include ..\gtapwindc\gtapwindc_data

set	iag(i)			Agricultural sectors/ 
		pdr 	Paddy rice
		wht 	Wheat
		gro 	Cereal grains nec
		v_f 	"Vegetables, fruit, nuts"
		osd 	Oil seeds
		c_b 	"Sugar cane, sugar beet"
		pfb 	Plant-based fibers
		ocr 	Crops nec
		ctl 	"Bovine cattle, sheep, goats and horses"
		oap 	Animal products nec
		rmk 	Raw milk
		wol 	"Wool, silk-worm cocoons" /;

parameter	atm_(i,s,iag)		Export content
		atm(*,*,i,s,iag)	Export content across models and metrics;

$set	metric output
$set	model pooled
execute_load '%metric%_%model%.gdx',atm_=atm;
atm("%model%","%metric%",i,s,iag) = atm_(i,s,iag);

$title	MERGE THE ATM MODEL CALCULATIONS

*	Do the ATM calculations in parallel

$call start "output_pooled"	 call gams atmcalc o=output_pooled.lst gdx=output_pooled.gdx --model=pooled --metric=output 
$call start "output_bilateral" call gams atmcalc o=output_bilateral.lst gdx=output_bilateral.gdx --model=bilateral --metric=output
$call start "gdp_pooled"	 call gams atmcalc o=gdp_pooled.lst gdx=gdp_pooled.gdx --model=pooled --metric=gdp
$call call gams atmcalc o=gdp_bilateral.lst gdx=gdp_bilateral.gdx --model=bilateral --metric=gdp

$log	Wait for all the ATMCALC jobs to complete!
$call pause

$set	metric gdp
$set	model pooled
execute_load '%metric%_%model%.gdx',atm_=atm;
atm("%model%","%metric%",i,s,iag) = atm_(i,s,iag);

$set	metric output
$set	model bilateral
execute_load '%metric%_%model%.gdx',atm_=atm;
atm("%model%","%metric%",i,s,iag) = atm_(i,s,iag);

$set	metric gdp
$set	model bilateral
execute_load '%metric%_%model%.gdx',atm_=atm;
atm("%model%","%metric%",i,s,iag) = atm_(i,s,iag);

execute_unload 'atm.gdx',atm;
execute 'gdxxrw i=atm.gdx o=atm.xlsx par=atm rng=PivotData!a2 cdim=0';

