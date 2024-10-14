$title	LUSOLVE: LUSOL Wrapper to Factorize and Solve a Linear System

*	Usage: 	

*		$set cmdline [--mode=(5 or 6) ...]
*		$batinclude lusolve a b x

*	mode=5 (default)	x solves	A x = b		(rows in A = first dimension in b)
*	mode=6			x solves	A^T x = b	(columns in A = first dimension in b)

*	Required arguments:
*		a(*,*)		Matrix (square)
*		b(*[,k])	RHS vector or array (1 or more dimensional parameter)

*	Contents of lusol_out.gdx following a factor/solve:
*		k			Column domain of b
*		x(*[,k])		Solution vector 
*		sstatus(info[,k])	LUSOL status for solve 

*	In default (mode=5) the following is an identity satisfied by the LUSOL output data:

*			sum(j, a(i,j)*x(j,k)) = b(i,k);

*	In case mode=6 we have:

*			sum(i, a(i,j)*x(i,k) = b(j,k)

$hidden	N.B.	When an error is encountered, we generate a zip archive of the 
$hidden		lusol directory in "lufactorsolve_debug.zip"


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

$setargs a b x extra

$if not "%extra%"=="" $abort Error in LUFACTORSOLVE call.  Fourth argument found: %extra%. 

*	Missing argument:

$if "%a%"=="" $abort Error in LUFACTORSOLVE call: missing first argument (a).
$if "%b%"=="" $abort Error in LUFACTORSOLVE call: missing second argument (b).
$if "%x%"=="" $abort Error in LUFACTORSOLVE call: missing third argument (x).

*	Verify that lusol.gms and lusol.exe are in the same directory:

$if not exist %wdir%lusol.gms	$abort	System installation error: lusol.gms is not in same directory as lufactorsolve.gms.
$if not exist %wdir%lusol.exe	$abort	System installation error: lusol.exe is not in same directory as lufactorsolve.gms.

*	Wrong type of argument:

$if not partype %a%  $abort Error in lusol: a=%a% is not 2-dimensional parameter
$if not partype %b%  $abort Error in lusol: b=%b% is not a parameter
$if not partype %x%  $abort Error in lusol: x=%x% is not a parameter

*	Wrong dimension argument:

$if not dimension 2 %a% $abort Error in lusol: a=%a% is not 2-dimensional parameter
$if dimension 0     %b% $abort Error in lusol: b=%b% is a scalar.
$if dimension 0     %b% $abort Error in lusol: x=%x% is a scalar.

execute_unload '%wdir%lusol_in.gdx', %a%=a, %b%=b;

$if not set cmdline $set cmdline 

$log --- Executing '=gams lusol cdir="%wdir%" %cmdline%'

execute 'echo gams lusol lf=lusol.log lo=2 %cmdline% >"%wdir%lusol.bat';

execute '=gams lusol.gms cdir="%wdir%" %cmdline%';
if (errorlevel,
 execute 'gmszip -j "lufactorsolve_debug.zip" "%wdir%*.*"';
 abort$errorlevel 'Error in LUFACTORSOLVE.  In lufactorsolve_debug.zip see lusol.lst and lusol.bat';
);

execute 'test -e "%wdir%lusol_out.gdx"'

if (errorlevel,
 execute 'gmszip -j "lufactorsolve_debug.zip" "%wdir%*.*"';
  abort 'Error in LUFACTORSOLVE: lusol_out.gdx missing.  In lufactorsolve_debug.zip see lusol.lst and lusol.bat';
);

execute_load '%wdir%lusol_out.gdx',%x%=x;
