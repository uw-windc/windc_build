$title	LUFACTOR: LUSOL Wrapper to Factor a Matrix

*	Usage: 	

*		$set cmdline [--mode=(5 or 6)] [debug=(no or yes)]

*		$batinclude lufactor a

*	Required arguments:
*		a(*,*)		Matrix (square)

*	Contents of lusol_out.gdx following a factor/solve:
*		fstatus(info[,k])	LUSOL status for factorization

$hidden	N.B.	When an error is encountered, we generate a zip archive of the 
$hidden		lusol directory in "lufactor_debug.zip"


$hidden		Create a temporary directory as needed:

$setnames %system.incparent% parent_fp parent_fn parent_fa
$ifthen.wdir not "%system.fp%"=="%parent_fp%" 
$set wdir "%gams.scrdir%inclib"
$if not dexist "%wdir%" $call mkdir "%wdir%"
$ifthen.lusolexist not exist "%wdir%%system.dirsep%lusol.gms"
$call cp "%system.fp%lusol.exe" "%wdir%"
$call cp "%system.fp%lusol.gms" "%wdir%"
$endif.lusolexist
$set wdir "%wdir%%system.dirsep%"
$else.wdir
$set wdir ".%system.dirsep%"
$endif.wdir

$setargs a extra

*	Verify that there are not too many arguments (at most 1):

$if not "%extra%"=="" $abort Error in LUFACTOR call.  Extra argument found: %extra%. 

*	Missing argument:

$if "%a%"=="" $abort Error in lusolve call: missing first argument (a).

*	Verify that lusol.gms and lusol.exe are in the same directory:

$if not exist %wdir%lusol.gms	$abort	System installation error: lusol.gms is not in same directory as lusolve.gms.
$if not exist %wdir%lusol.exe	$abort	System installation error: lusol.exe is not in same directory as lusolve.gms.

*	Wrong type of argument:

$if not partype %a%     $abort Error in lusol: a=%a% is not 2-dimensional parameter

*	Wrong dimension argument:

$if not dimension 2 %a% $abort Error in lusol: a=%a% is not 2-dimensional parameter

execute_unload '%wdir%lusol_in.gdx', %a%=a;

$if not set cmdline $set cmdline 

$log --- Executing 'gams lusol cdir="%wdir%" %cmdline%'

execute 'echo gams lusol %cmdline% >"%wdir%lusol.bat';

execute '=gams lusol lf=lusol.log lo=2 cdir="%wdir%"  %cmdline%';

if (errorlevel,
	execute 'gmszip -j "lufactor_debug.zip" "%wdir%*.*"';
	abort 'Error in LUFACTOR.  In lufactor_debug.zip see lusol.lst and lusol.bat';
);

