
*	Reading the BEA datasets (summary and detailed tables):

$call gams readsummary
$call gams readdetailed

*	Interpolate the detailed tables from 2007, 2012 and 2017 to produce tables 
*	for the full time period 1997-2022.  Projection is based on the summary
*	tables for those years and the concordance between summary and detailed accounts.

*	The output of this step is a time-series of target (unbalanced) supply-use tables
*	for the years 1997 to 2022

$call gams project s=project

*	Apply least squares calculation to balance the input-output tables:

$call gams iobalance r=project

*	Calculate agricultural trade multipliers in the national dataset.
*	Output is written to national.gdx.

$call gams atmcalc
