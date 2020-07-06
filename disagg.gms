* ------------------------------------------------------------------------------
*	 		  WiNDC Build Routine
*
* Authors: Andrew Schreiber, Thomas Rutherford, Adam Christensen
*
* ------------------------------------------------------------------------------

* NEOS Solvers: ALPHAECP, BARON, BDMLP, BONMIN, CBC, CONOPT, COUENNE, CPLEX, DICOPT,
*               GAMS-AMPL, IPOPT, KNITRO, LINDOGLOBAL, MILES, MINOS, MOSEK, NLPEC,
*               PATH, PATHNLP, SBB, SCIP, SNOPT, XPRESS

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

$IF NOT SET reldir $SET reldir ".%sep%build_files"
$IF NOT SET dsdir $SET dsdir ".%sep%built_datasets"

$IF NOT SET neos $SET neos "no"
$IF NOT SET neosserver $SET neosserver "neos-server.org:3333"
$IF NOT SET kestrel_nlp $SET kestrel_nlp "conopt"
$IF NOT SET kestrel_lp $SET kestrel_lp "cplex"
$IF NOT SET kestrel_qcp $SET kestrel_qcp "cplex"
$IF NOT SET kestrel_mcp $SET kestrel_mcp "path"

$IF NOT SET year $SET year 2016
$IF NOT SET aggr $SET aggr bluenote



SCALAR myerrorlevel;

*------------------------------------------------------------------------------
*** Check to make sure that core WiNDC database exists
*------------------------------------------------------------------------------
$IF NOT EXIST %dsdir%%sep%WiNDCdatabase.gdx $ERROR WiNDC core database does not exist, run 'gams build.gms' first to create this database
*------------------------------------------------------------------------------


*------------------------------------------------------------------------------
*** Build options and input checks
*------------------------------------------------------------------------------
$IFTHENI %system.filesys% == UNIX
$IF EXIST %dsdir%%sep%WiNDC_cal_%year%_%aggr%.gdx $CALL 'rm %dsdir%%sep%WiNDC_cal_%year%_%aggr%.gdx'
$ENDIF

$IFTHENI %system.filesys% == MSNT
$IF EXIST %dsdir%%sep%WiNDC_cal_%year%_%aggr%.gdx $CALL 'del %dsdir%%sep%WiNDC_cal_%year%_%aggr%.gdx'
$ENDIF
*------------------------------------------------------------------------------


* ------------------------------------------------------------------------------
*** Core data sector/region (dis)aggregation
* ------------------------------------------------------------------------------
* Provide a mapping file of desired sectors from the 389 list, then the routine
* takes that list and disaggregates (or aggregates) the core 71 sector accounts
* accordingly.

* Examples are provided in two files:
* %reldir%%sep%%wdir%defines%sep%secaggregations%sep%example.map
* %reldir%%sep%%wdir%defines%sep%aggregations%sep%example.map

EXECUTE 'gams %reldir%%sep%sectordisagg.gms o="%reldir%%sep%temp%sep%lst%sep%sectordisagg.lst" --year=%year% --aggr=%aggr% --reldir=%reldir% --dsdir=%dsdir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: sectordisagg.gms did not complete successfully...";


* Option for aggregating sectors of lesser importance to analysis.
EXECUTE 'gams %reldir%%sep%aggregate.gms o="%reldir%%sep%temp%sep%lst%sep%aggregate.lst" --year=%year% --sdisagg=yes --aggr=%aggr% --reldir=%reldir% --dsdir=%dsdir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: aggregate.gms did not complete successfully...";



$IFTHENI "%neos%" == "yes"

* Use aggchk.gms to verify robustness of aggregation in an accounting model.
EXECUTE 'gams %reldir%%sep%%wdir%%sep%aggchk.gms --neos=yes solver=kestrel optfile=1 o="%reldir%%sep%temp%sep%lst%sep%aggchk.lst" --neosserver=%neosserver% --kestrel_mcp=%kestrel_mcp% --kestrel_nlp=%kestrel_nlp% --kestrel_lp=%kestrel_qcp% --year=%year% --aggr=%aggr% --reldir=%reldir% --dsdir=%dsdir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: aggchk.gms did not complete successfully...";

$ELSE

EXECUTE 'gams %reldir%%sep%aggchk.gms o="%reldir%%sep%temp%sep%lst%sep%aggchk.lst" --year=%year% --aggr=%aggr% --reldir=%reldir% --dsdir=%dsdir% > %system.nullfile%';
myerrorlevel = errorlevel;
ABORT$(myerrorlevel <> 0) "ERROR: aggchk.gms did not complete successfully...";

$ENDIF
