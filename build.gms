* ------------------------------------------------------------------------------
*	 		  WiNDC Build Routine
*
* Authors: Andrew Schreiber, Thomas Rutherford, Adam Christensen
*
* ------------------------------------------------------------------------------

* NEOS Solvers: ALPHAECP, BARON, BDMLP, BONMIN, CBC, CONOPT, COUENNE, CPLEX, DICOPT,
*               GAMS-AMPL, IPOPT, KNITRO, LINDOGLOBAL, MILES, MINOS, MOSEK, NLPEC,
*               PATH, PATHNLP, SBB, SCIP, SNOPT, XPRESS

$SET sep %system.dirsep%

$IF NOT SET reldir $SET reldir ".%sep%build_files"
$IF NOT SET dsdir $SET dsdir ".%sep%built_datasets"
$IF NOT SET neos $SET neos "no"
$IF NOT SET neosserver $SET neosserver "neos-server.org:3333"
$IF NOT SET kestrel_nlp $SET kestrel_nlp "conopt"
$IF NOT SET kestrel_lp $SET kestrel_lp "cplex"
$IF NOT SET kestrel_qcp $SET kestrel_qcp "cplex"
$IF NOT SET kestrel_mcp $SET kestrel_mcp "path"

SCALAR myerrorlevel;

$onecho > cplex.opt
numericalemphasis 1
$offecho

*------------------------------------------------------------------------------
*** Create directories if necessary
*------------------------------------------------------------------------------
$IF NOT DEXIST "%reldir%%sep%temp" $CALL mkdir "%reldir%%sep%temp"
$IF NOT DEXIST "%dsdir%" $CALL mkdir "%dsdir%"
$IF NOT DEXIST "%reldir%%sep%temp%sep%gdx_temp" $CALL mkdir "%reldir%%sep%temp%sep%gdx_temp"
$IF NOT DEXIST "%reldir%%sep%temp%sep%lst" $CALL mkdir "%reldir%%sep%temp%sep%lst"
$IF NOT DEXIST "%reldir%%sep%temp%sep%loadpoint" $CALL mkdir "%reldir%%sep%temp%sep%loadpoint"

* creates an empty loadpt.gdx file to avoid an error
$ONECHO > %gams.scrdir%create_loadpt_file.gms
EXECUTE_UNLOAD '%reldir%%sep%temp%sep%loadpoint%sep%loadpt.gdx'
$OFFECHO
$CALL 'gams %gams.scrdir%create_loadpt_file.gms o="%reldir%%sep%temp%sep%lst%sep%create_loadpt_file.lst"'
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
*** Relabel sets in windc_base.gdx
*------------------------------------------------------------------------------

$CALL 'gams %reldir%%sep%relabel.gms o="%reldir%%sep%temp%sep%lst%sep%relabel.lst" --reldir="%reldir%"'
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
*** Form CGE parameters using raw input data
*------------------------------------------------------------------------------

EXECUTE 'gams %reldir%%sep%partitionbea.gms o="%reldir%%sep%temp%sep%lst%sep%partitionbea.lst" --reldir=%reldir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: partitionbea.gms did not complete correctly...";
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
*** Calibration
*------------------------------------------------------------------------------

* Use matrix balancing to enforce accounting identities and verify benchmark
* with accounting CGE model called nationalmodel.gms for year 2016.
* Optimization methods provided:
* - huber -> Hybrid huber loss function
* - ls    -> Least squares
* - ent	  -> Entropy (not included)


$IFTHENI "%neos%" == "yes"

EXECUTE 'gams %reldir%%sep%calibrate.gms solver=kestrel optfile=1 --neos=yes --neosserver=%neosserver% --kestrel_mcp=%kestrel_mcp% --kestrel_nlp=%kestrel_nlp% --kestrel_lp=%kestrel_qcp% --matbal=ls o="%reldir%%sep%temp%sep%lst%sep%calibrate.lst" > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: calibrate.gms did not complete correctly...";

$ELSE

EXECUTE 'gams %reldir%%sep%calibrate.gms qcp=cplex nlp=ipopt --matbal=ls o="%reldir%%sep%temp%sep%lst%sep%calibrate.lst" --reldir=%reldir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: calibrate.gms did not complete correctly...";

$ENDIF
*------------------------------------------------------------------------------



*------------------------------------------------------------------------------
*** Regionalization (State Level)
*------------------------------------------------------------------------------

* Regionalization is achieved through shares using GSP, CFS, GovExp, and PCE
* data. The following routines generate a set of consistent shares for use in
* disagg.gms. For a link to all regional sources:
* https://www.bea.gov/regional/downloadzip.cfm

* Produce a gams readable GSP dataset using stata. See
* Data\BEA\GDP\State\stategsp.do. Source:
* (https://www.bea.gov/newsreleases/regional/gdp_state/qgsp_newsrelease.htm)

EXECUTE 'gams %reldir%%sep%gspshare.gms o="%reldir%%sep%temp%sep%lst%sep%gspshare.lst" --reldir=%reldir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: gspshare.gms did not complete correctly...";


* Household expenditures follow the Personal Consumption Expenditure Survey
* data. Source: (https://www.bea.gov/newsreleases/regional/pce/pce_newsrelease.htm)

EXECUTE 'gams %reldir%%sep%pceshare.gms o="%reldir%%sep%temp%sep%lst%sep%pceshare.lst" --reldir=%reldir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: pceshare.gms did not complete correctly...";


* Government expenditures are assumed to follow the state government finance tables.
* Source: (https://www.census.gov/programs-surveys/state/data/tables.All.html)

EXECUTE 'gams %reldir%%sep%sgfshare.gms o="%reldir%%sep%temp%sep%lst%sep%sgfshare.lst" --reldir=%reldir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: sgfshare.gms did not complete correctly...";


* Regional purchase coefficients which determine flows within and out to other
* states are generated through the 2012 commodity flow survey data. Source:
* (https://www.census.gov/econ/cfs/).

EXECUTE 'gams %reldir%%sep%cfsshare.gms o="%reldir%%sep%temp%sep%lst%sep%cfsshare.lst" --reldir=%reldir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: cfsshare.gms did not complete correctly...";


* Shares for exports are generated using Census data from USA Trade Online. The
* data is free, though an account is required to access the data.
* Source: https://usatrade.census.gov/

EXECUTE 'gams %reldir%%sep%usatradeshare.gms o="%reldir%%sep%temp%sep%lst%sep%usatradeshr.lst" --reldir=%reldir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: usatradeshare.gms did not complete correctly...";


* Disaggregate accounts by region and output a gdx file data for all years. The
* default year is 2016 and determines the test year to verify benchmark
* consistency.


$IFTHENI %system.filesys% == MSNT
$CALL 'title Regionalizing national summary accounts'
$ENDIF

$IFTHENI "%neos%" == "yes"

EXECUTE 'gams %reldir%%sep%statedisagg.gms --neos=yes solver=kestrel optfile=1 --kestrel_mcp=%kestrel_mcp% o="%reldir%%sep%temp%sep%lst%sep%statedisagg.lst" > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: statedisagg.gms did not complete correctly...";

$ELSE

EXECUTE 'gams %reldir%%sep%statedisagg.gms o="%reldir%%sep%temp%sep%lst%sep%statedisagg.lst" --reldir=%reldir% --dsdir=%dsdir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: statedisagg.gms did not complete correctly...";

$ENDIF
