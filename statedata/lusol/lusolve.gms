$title	LUSOLVE: Wrapper to Solve a Linear System with Existing Factorization

*	Usage: 	

*		$set cmdline [--mode=(5 or 6) ..]
*		$batinclude lusolve  b x lu 

*	where lu refers to the LU factors of a square matrix A. We then have:

*	mode=5 (default)	x solves	A x = b		(rows in A = first dimension in b)
*	mode=6			x solves	A^T x = b	(columns in A = first dimension in b)

*	Required arguments:
*		b(*[,k])	RHS vector or array (1 or more dimensional parameter)
*		x(*[,k])	Parameter to hold the solution vector 

*	Contents of lusol_out.gdx following a factor/solve:
*		k			Column domain of b
*		x(*[,k])		Solution vector 
*		sstatus(info[,k])	LUSOL status for solve 

*	In default (mode=5) the following is an identity satisfied by the LUSOL output data:

*			sum(j, a(i,j)*x(j,k)) = b(i,k);

*	In case mode=6 we have:

*			sum(i, a(i,j)*x(i,k) = b(j,k)

$hidden	N.B.	When an error is encountered, we generate a zip archive of the 
$hidden		lusol directory in "lusolve_debug.zip"


$hidden		Create a temporary directory as needed and copy files there:

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

$setargs b x lu extra

*	Verify that there are not too many arguments (at most 3):

$if not "%extra%"=="" $abort Error in LUSOLVE call.  Fourth argument found: %extra%. 

*	Missing argument:

$if "%b%"=="" $abort Error in lusolve call: missing first argument (b).
$if "%x%"=="" $abort Error in lusolve call: missing second argument (x).

*	Verify that lusol.gms and lusol.exe are in the same directory:

$if not exist %wdir%lusol.gms	$abort	System installation error: lusol.gms is not in same directory as lusolve.gms.
$if not exist %wdir%lusol.exe	$abort	System installation error: lusol.exe is not in same directory as lusolve.gms.

*	Wrong type of argument:

$if not partype %b%  $abort Error in lusol: b=%b% is not a parameter
$if not partype %x%  $abort Error in lusol: x=%x% is not a parameter

*	Wrong dimension argument:

$if dimension 0     %b% $abort Error in lusol: b=%b% is a scalar.
$if dimension 0     %b% $abort Error in lusol: x=%x% is a scalar.

execute 'test -e "%wdir%lufactors.bin"';
abort$errorlevel  'Error in LUSOLVE: LU factors file "%wdir%lufactors.bin" not found.';

execute 'test -e "%wdir%lufactors.gdx"';
abort$errorlevel  'Error in LUSOLVE: LU factors file "%wdir%lufactors.gdx" not found.';

execute_unload '%wdir%lusol_in.gdx', %b%=b;

$if not set cmdline $set cmdline 

$log --- Executing '=gams lusol cdir="%wdir%" %cmdline%'

execute 'echo gams lusol lf=lusol.log lo=2 %cmdline% >"%wdir%lusol.bat';

execute '=gams lusol lf=lusol.log lo=2 cdir="%wdir%" %cmdline%';

if (errorlevel,
	execute 'gmszip -j lusolve_debug.zip "%wdir%*.*"';
	abort 'Error in LUSOLVE.  In lusolve_debug.zip see lusol.lst and lusol.bat';
);
execute 'test -e "%wdir%lusol_out.gdx"'

if (errorlevel,
	execute 'gmszip -j lusolve_debug.zip "%wdir%*.*"';
	abort 'Error in LUSOLVE: lusol_out.gdx missing. In lusolve_debug.zip see lusol.lst and lusol.bat';
);
execute_load '%wdir%lusol_out.gdx',%x%=x;
