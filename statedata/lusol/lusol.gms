$title	GAMS Interface to LUSOL

*	Usage: 	
*		$set cmdline [--mode=5 or --mode=6]

*	mode=5 (default)	
*	x solves	A x = b		(rows in A = first dimension in b)

*	mode=6			
*	x solves	A^T x = b	(columns in A = first dimension in b)


*	Input file lusol_in.gdx contains

*		a(*,*)		Matrix (square) -- required
*		b(*[,k])	RHS vector or array -- optional

*	N.B.	- When matrix a is not provided, LU factors must in lufactors.bin

*		- If LU factors are found, matrix b must be provided 
*		  and the existing factorization is employed.

*	Contents of lusol_out.gdx following a factorization (no b):
*		i			Row indices of a and b
*		j			Column indices of a
*		a(i,j)			Original matrix
*		fstatus(info)		LUSOL status for factor

*	Contents of lusol_out.gdx following a factor/solve:
*		k			Column domain of b
*		b(*[,k])		RHS vector(s)
*		x(*[,k])		Solution vector 
*		sstatus(info[,k])	LUSOL status for solve 

*	In default (mode=5) the following is an identity satisfied by the LUSOL output data:

*		sum(j, a(i,j)*x(j,k)) = b(i,k);

*	In case mode=6 we have:

*		sum(i, a(i,j)*x(i,k) = b(j,k)

*	---------------------------------------------------------------------------------------------
*	3. Standalone batinclude utility lusol.gms begins here.
*	---------------------------------------------------------------------------------------------

set	parmset		Set of LUSOL parameters /1*30/;

alias (u,u1,u2,*);

set		i(u1)		Rows in matrix a, 
		ib(u)		Rows in b,
		noti(u)		Rows in b which are not in a,
		notj(u)		Rows in b which are not columns in a,
		j(u2)		Columns in matrix a;

set	luoptions	LU options /
	lprint		"Print level",
	maxcol		"Maximum number of columns searched",
	keepLU		"Means the numerical factors will be computed",
	Ltol1		"Max Lij allowed during factor",
	Ltol2		"Max Lij allowed during updates",
	small		"Absolute tolerance for treating reals as zero",
	Utol1		"Absolute tol for flagging small diagonals of U",
	Utol2		"Relative tol for flagging small diagonals of U",
	Uspace		"Factor limiting waste space in U",
	dens1		"Density at which the Markowitz should reach maxcol columns",
	dens2		"Density at which the Markowitz strategy search only 1 column",
	pivotscheme	"Pivoting scheme index (0=TPP)" /;
		
set	info	Information returned by the factorization routine /
	inform          "Return code from last call to any LU routine.",
	nsing           "No. of singularities marked in the output array w(*).",
	jsing           "Column index of last singularity.",
	minlen          "Minimum recommended value for lena.",
	maxlen          "?",
	nelem           "Number of nonzeros at factorization",
	nupdat          "No. of updates performed by the lu8 routines.",
	nrank           "No. of nonempty rows of U.",
	ndens1          "No. of columns remaining when the density of the factorized reached dens1.",
	ndens2          "No. of columns remaining when the density of the matrix being factorized reached dens2."
	jumin           "The column index associated with DUmin.",
	numL0           "No. of columns in initial  L.",
	lena            "Allocation for LENA at factorization",
	lenL0           "Size of initial  L  (no. of nonzeros).",
	lenU0           "Size of initial  U.",
	lenL            "Size of current  L.",
	lenU            "Size of current  U.",
	lrow            "Length of row file.",
	ncp             "No. of compressions of LU data structures.",
	mersum          "lu1fac: sum of Markowitz merit counts.",
	nUtri           "lu1fac: triangular rows in U.",
	nLtri           "lu1fac: triangular rows in L.",
	Amax            "Maximum element in  A.",
	Lmax            "Maximum multiplier in current  L."
	Umax            "Maximum element in current  U."
	DUmax           "Maximum diagonal in  U."
	DUmin           "Minimum diagonal in  U."
	Akmax           "Maximum element generated at any stage during TCP factorization."
	growth          "TPP: Umax/Amax    TRP, TCP, TSP: Akmax/Amax",
	resid		"Residual after solve with U or U" /;

parameter fstatus(info)		Information returned by LUSOL factorization;

parameter	mode	"Solution mode (5 = x solves A x = b, 6 = x solves A^T x = b)";

*	Solution mode:

$if not set mode $set mode 5
mode = %mode%;
abort$(not (mode=5 or mode=6)) "Unrecognized LU6SOL mode.  Must be 5 or 6.";

*	See that the input file exists, using the command line utility
*	test.exe:

execute 'test -e lusol_in.gdx'
abort$errorlevel  'Error in LUSOL: lusol_in.gdx missing in "%system.fp%". See lusol.lst and lusol.bat';

*	------------------------------------------------------------------------------------
*	Read the input file which includes data:

$call 'gdxdump "lusol_in.gdx" NoData NoHeader >"%gams.scrdir%lusol_in.scr"'
$include "%gams.scrdir%lusol_in.scr"

*	------------------------------------------------------------------------------------

$ifthen.a defined a

parameter	carda	Number of elements in a;
carda = card(a);

parameter	aa(u1,u2)	Matrix a;
aa(u1,u2)$a(u1,u2) = a(u1,u2);
option i<aa, j<aa;

*	Check that there are an equal number of rows and columns:

abort$(card(i)<>card(j)) "Error in LUSOL.  Matrix a is not square:",i,j;

*	Generate a set of numerical indices which can be used 
*	to define numerical indices for rows, columns and rhs vectors:

$if not set lenascale  $set lenascale 10
$if not set lena $eval lena  max( %lenascale%*card(a), 10000 )

parameter	lena            "Allocation for LENA at factorization" /%lena%/;

set		ia		Indices in the factorization /1*%lena%/,
		in(ia)		Numeric indices for rows and columns;

in(ia)$(ia.val <= card(i)) = yes;

$else.a

*	Verify that the LU factors file exists if the matrix is not defined:

execute 'test -e lufactors.bin'
abort$errorlevel  
  'Error in LUSOL: lufactors.bin missing in "%system.fp%". See lusol.lst and lusol.bat';

execute 'test -e lufactors.gdx'
abort$errorlevel  
  'Error in LUSOL: lufactors.gdx missing in "%system.fp%". See lusol.lst and lusol.bat';

set		i		Rows in matrix a, 
		j		Columns in matrix a,
		ia		Indices in the factorization,
		in(ia)		Numeric indices for rows and columns;

scalar		carda	Number of elements in a,
		lena	Nonzero allocation for a;

$gdxin 'lufactors.gdx'
$load i j ia carda lena
$loaddc in

$endif.a

alias (in,jn);

set	imap(*,ia)	Mapping from row labels to numeric indices , 
	jmap(*,ia)	Mapping from col labels to numeric indices ;

imap(i,in)$(i.pos = in.val) = yes;
jmap(j,jn)$(j.pos = jn.val) = yes;
option imap:0:0:1, jmap:0:0:1;
display imap, jmap;

$ifthen.b defined b

$set bdim 0
$if dimension 1 b $set bdim 1
$if dimension 2 b $set bdim 2
$if dimension 3 b $set bdim 3
$if dimension 4 b $set bdim 4
$if dimension 5 b $set bdim 5
$if dimension 6 b $set bdim 6
$if dimension 7 b $set bdim 7
$if dimension 8 b $set bdim 8
$if dimension 9 b $set bdim 9

$if %bdim%==0  $abort "LUSOL dimension error: parameter b dimension not between 1 and 9?"

$eval cdim %bdim%-1

$ifthen.cdim not %cdim%==0

alias (cd_1,cd_2,cd_3,cd_4,cd_5,cd_6,cd_7,*);
$if %cdim%==1 $set cd cd_1
$if %cdim%==2 $set cd cd_1,cd_2
$if %cdim%==3 $set cd cd_1,cd_2,cd_3
$if %cdim%==4 $set cd cd_1,cd_2,cd_3,cd_4
$if %cdim%==5 $set cd cd_1,cd_2,cd_3,cd_4,cd_5
$if %cdim%==6 $set cd cd_1,cd_2,cd_3,cd_4,cd_5,cd_6
$if %cdim%==7 $set cd cd_1,cd_2,cd_3,cd_4,cd_5,cd_6,cd_7

set		k(%cd%)		Dimensions of RHS vector b;
parameter	bb(u,%cd%)	Parameter used to extract domain of b;
bb(u,%cd%)$b(u,%cd%) = b(u,%cd%);
option k<bb, ib<bb;

if (mode=5,
  noti(ib) = yes$(not i(ib));
  abort$card(noti)	"LUSOL error: rows in b are not rows in A.",i,ib,noti;
else
  notj(ib) = yes$(not j(ib));
  abort$card(notj)	"LUSOL error: rows in b are not columns in a'.",j,ib,notj;
);

set	kn(ia)	Numeric indices of the RHS;
kn(ia)$(ia.val <= card(k)) = yes;

set		kmap(%cd%,ia)	Mapping from rhs vectors to numbers
parameter	kcount		Counter for rhs vectors /0/;

loop(k,	kcount = kcount + 1;
	kmap(k,kn) = yes$(kn.val = kcount););

option kmap:0:0:1;
display kmap;
	
$else.cdim

*	b is a column vector.  Check that all nonzeros are
*	from rows in matrix a (mode=5) or columns in a (mode=6):

parameter	bb(u)	Parameter used to extract domain of b;
bb(u)$b(u) = b(u);
option ib<bb;

if (mode=5,
  noti(ib) = yes$(not i(ib));
  abort$card(noti)	"LUSOL error: rows in b are not found in a.",i,ib,noti;
else
  notj(ib) = yes$(not j(ib));
  abort$card(notj)	"LUSOL error: rows in b are not found in a'.",j,ib,notj;
);

$endif.cdim

$else.b

$if set lu $abort "LU factors are provided but there is no RHS vector b.";

$endif.b

*	------------------------------------------------------------------------------------
parameter     luopt(luoptions)  LUSOL Options; 
$ifthen.luopt set luopt
$gdxin '%luopt%'
$loaddc luopt
$else.luopt
luopt(luoptions)=0;
$endif.luopt

*	Assign default LU parameters if we are factorizing:

*	Values set for ip and rp correspond to those set in lusol_precision.f90.
*	Must have ip=4.

$set rp_huge4	3.40282347E+38
$set rp_huge8	1.79769313486231571E+308
$set rp_huge16	1.18973149535723176508575932662800702E+4932

$set rp_eps4	1.19209290E-07
$set rp_eps8	2.22044604925031308E-016
$set rp_eps16	1.92592994438723585305597794258492732E-0034 

$offdigit
$set ip_huge 2147483647
$set rp_eps  %rp_eps8%
$set rp_huge %rp_huge8%

luopt("lprint")$(not luopt("lprint")) = 0;

*	Print level:
*                   <  0 suppresses output.
*                   =  0 gives error messages.
*                  >= 10 gives statistics about the LU factors.
*                  >= 50 gives debug output from lu1fac
*                        (the pivot row and column and the
*                        no. of rows and columns involved at
*                        each elimination step).

luopt("maxcol")$(not luopt("maxcol")) =  5;

*	Maximum number of columns searched:
*                        Applies for a Markowitz-type
*                        search for the next pivot element.
*                        For some of the factorization, the
*                        number of rows searched is
*                        maxrow = maxcol - 1.
 
luopt("keepLU")=  1;

*	keepLU=1	means the numerical factors will be computed if possible.
*	keepLU=0	means L and U will be discarded but other information 
*			such as the row and column permutations will be returned.

*			keepLU=0 requires less storage.

luopt("Ltol1")$(not luopt("Ltol1")) =   10;

*	Max Lij allowed during Factor:
*			TPP     10.0 or 100.0
*			TRP      4.0 or  10.0
*			TCP      5.0 or  10.0
*			TSP      4.0 or  10.0

*	With TRP and TCP (Rook and Complete Pivoting), values less than 25.0
*	may be expensive on badly scaled data.  However, values less than 10.0
*	may be needed to obtain a reliable rank-revealing factorization.

luopt("Ltol2")$(not luopt("Ltol2")) =   10;

*		Max Lij allowed during Updates.

luopt("small")$(not luopt("small")) = %rp_eps%**0.8;
*		Absolute tolerance for treating reals as zero.

luopt("Utol1")$(not luopt("Utol1")) = %rp_eps%**0.67;

*		Absolute tol for flagging small diagonals of U.

luopt("Utol2")$(not luopt("Utol2")) = %rp_eps%**0.67;

*		Relative tol for flagging small diagonals of U.

luopt("Uspace")$(not luopt("Uspace")) = 3;

*		Factor limiting waste space in  U.

*	In lu1fac, the row or column lists are compressed if their length
*	exceeds Uspace times the length of either file after the last
*	compression.

luopt("dens1")$(not luopt("dens1")) = 0.3;

*	The density at which the Markowitz should reach maxcol columns
*	Use 0.3 unless you are experimenting with the pivot strategy.)

luopt("dens2")$(not luopt("dens2")) = 0.1;

*	the density at which the Markowitz strategy should search only 1
*	column, or (if storage is available) the density at which all
*	remaining rows and columns will be processed by a dense LU code.  For
*	example, if dens2 = 0.1 and lena is large enough, a dense LU will be
*	used once more than 10 per cent of the remaining matrix is nonzero.

luopt("PivotScheme")$(not luopt("PivotScheme")) = 0;

*		0	TPP	Threshold Partial Pivoting.
*		1	TRP	Threshold Rook Pivoting.
*		2	TCP	Threshold Complete Pivoting.
*		3	TSP	Threshold Symmetric Pivoting.
*		4	TDP	Threshold Diagonal Pivoting.

*	Note:	TDP not yet implemented.

*	TRP and TCP are more expensive than TPP but more stable and better at
*	revealing rank.  Take care with setting parmlu(1), especially with TCP.


*	NOTE: TSP and TDP are for symmetric matrices that are either definite
*	or quasi-definite.  TSP is effectively TRP for symmetric matrices.
*	TDP is effectively TCP for symmetric matrices.

*	Max Lij allowed during factor -- depends on pivoting scheme.

display luopt;

parameter	luparm(parmset), parmlu(parmset);

luparm("2")$luopt("lprint") = luopt("lprint");
luparm("8")$luopt("keepLU") = luopt("keepLU");
luparm("3")$luopt("maxcol") = luopt("maxcol");
luparm("6")$luopt("PivotScheme") = luopt("PivotScheme");
parmlu("1")$luopt("Ltol1") = luopt("Ltol1");
parmlu("2")$luopt("Ltol2") = luopt("Ltol2");
parmlu("3")$luopt("small") = luopt("small");
parmlu("4")$luopt("Utol1") = luopt("Utol1");
parmlu("5")$luopt("Utol2") = luopt("Utol2");
parmlu("6")$luopt("Uspace") = luopt("Uspace");
parmlu("7")$luopt("dens1") = luopt("dens1");
parmlu("8")$luopt("dens2") = luopt("dens2");
display luopt, parmlu;

*	------------------------------------------------------------------------------------
*	Only a is defined -- factorization and save in lufactors.bin:

$if not defined b $goto factor

*	Only b is defined -- perform a solve using lufactors.bin:

$if not defined a $goto solve

*	Both a and b are in the input file.  Perform a factor / solve:

$goto factorsolve

*	------------------------------------------------------------------------------------
*	Factorize the linear system (no rhs vector provided):

$label factor

*	FACTOR: compute LU factors 

file kdat /"lusol_factor.dat"/; 
put kdat; 
kdat.lw=0; kdat.nz = 0;
kdat.nw=0; kdat.nd=0;
put 'factor'/;
put card(i)/;
put carda/;
put lena/;
kdat.nr=2; kdat.nw=20; kdat.nd=12; kdat.nz=0;
loop((i,j)$a(i,j), loop((imap(i,in),jmap(j,jn)),
		put in.tl,' ',jn.tl,a(i,j)/;));
loop(parmset,
	kdat.nr=0; kdat.nw=0;  kdat.nd=0;	kdat.nz=0; put luparm(parmset);
	kdat.nr=2; kdat.nw=20; kdat.nd=12;	kdat.nz=0; put parmlu(parmset)/;);
putclose;

*	Generate the factorization:

execute	'=lusol lusol_factor.dat lusol_factor.out';
abort$errorlevel 'Error executing "lusol lusol_factor.dat" in "%system.fp%".';

Execute '=gams lusol_factor.out lf=lusol_factor.log lo=2 gdx=lusol_factor.gdx  o=lusol_factor.lst';
abort$errorlevel 'Error processing LUSOL output.  See "%system.fp%lusol_factor.lst".';

execute_load   'lusol_factor.gdx',fstatus;
execute_unload 'lusol_out.gdx',i,j,fstatus;
execute_unload 'lufactors.gdx',i,j,ia,in,a,carda,lena;
$exit

*	------------------------------------------------------------------------------------
$label factorsolve

*	FACTORSOLVE: factor the linear system and solve:

file kdat /"lusol_factorsolve.dat"/; 
put kdat; 
kdat.lw=0; kdat.nz = 0;
kdat.nw=0; kdat.nd=0;
put 'factorsolve'/;
put card(i)/;
put carda/;
put lena/;
$if     defined k put card(kn)/;
$if not defined k put '1'/;
put card(b)/;
put mode/;
kdat.nr=2; kdat.nw=20; kdat.nd=12; kdat.nz=0;
loop((i,j)$a(i,j), loop((imap(i,in),jmap(j,jn)),
		put in.tl,' ',jn.tl,a(i,j)/;));
loop(parmset,
	kdat.nr=0; kdat.nw=0;  kdat.nd=0;	kdat.nz=0;	put luparm(parmset);
	kdat.nr=2; kdat.nw=20; kdat.nd=12;	kdat.nz=0;	put parmlu(parmset)/;);
$ifthen defined k
  if (mode=5,
    loop((imap(i,in),kmap(k,kn))$b(i,k), put in.tl,' ',kn.tl, b(i,k)/;); 
  else
    loop((jmap(j,jn),kmap(k,kn))$b(j,k), put jn.tl,' ',kn.tl, b(j,k)/;); 
  );
$else
  if (mode=5,
    loop(imap(i,in)$b(i), put in.tl,' 1', b(i)/;); 
  else
    loop(jmap(j,jn)$b(j), put jn.tl,' 1', b(j)/;); 
  );
$endif
putclose;

execute '=lusol lusol_factorsolve.dat lusol_factorsolve.out';
abort$errorlevel 'Error executing "lusol lusol_factorsolve.dat" in "%system.fp%".';

execute '=gams lusol_factorsolve.out lf=lusol_factorsolve.log lo=2 gdx=lusol_factorsolve.gdx o=lusol_factorsolve.lst';
abort$errorlevel 'Error processing LUSOL output.  See "%system.fp%lusol_factorsolve.lst".';

parameter	xn(ia,ia)		Solution values returned by LUSOL,
		sstatusn(info,ia)	Solution status returned by LUSOL;

execute_load   'lusol_factorsolve.gdx',fstatus,sstatusn,xn;

$ifthen defined k

parameter	x(*,%cd%)		Indexed solution value
		sstatus(info,%cd%)	Indexed solution status;

if (mode=5,
  loop((jmap(j,jn),kmap(k,kn)), x(j,k)= xn(jn,kn));
else
  loop((imap(i,in),kmap(k,kn)), x(i,k)= xn(in,kn)); );

loop(kmap(k,kn), sstatus(info,k) = sstatusn(info,kn););
execute_unload 'lusol_out.gdx',a,b,i,j,k,fstatus,sstatus,x;
$else

parameter	x(*)		Indexed solution value
		sstatus(info)	Indexed solution status;

if (mode=5,
  loop(jmap(j,jn), x(j) = xn(jn,"1"););
else
  loop(imap(i,in), x(i) = xn(in,"1");); );
sstatus(info) = sstatusn(info,"1");
execute_unload 'lusol_out.gdx',i,j,fstatus,sstatus,x;
$endif
execute_unload 'lufactors.gdx',i,j,ia,in,a,carda,lena;


$exit

*	------------------------------------------------------------------------------------
$label solve

*	SOLVE from existing factors.

file kdat /"lusol_solve.dat"/;
put kdat; 
kdat.lw=0; kdat.nz = 0;
kdat.nw=0; kdat.nd=0;
put	'solve'/;
put	card(i)/;
put	carda/;
put	lena/;
$if     defined k put card(kn)/;
$if not defined k put '1'/;
put	card(b)/;
put	mode/;
kdat.nr=2; kdat.nw=20; kdat.nd=12; kdat.nz=0;
$ifthen defined k
  if (mode=5,
    loop((imap(i,in),kmap(k,kn))$b(i,k), put in.tl,' ',kn.tl, b(i,k)/;); 
  else
    loop((jmap(j,jn),kmap(k,kn))$b(j,k), put jn.tl,' ',kn.tl, b(j,k)/;); 
  );
$else
  if (mode=5,
    loop(imap(i,in)$b(i), put in.tl,' 1', b(i)/;); 
  else
    loop(jmap(j,jn)$b(j), put jn.tl,' 1', b(j)/;); 
  );
$endif
putclose;

execute '=lusol lusol_solve.dat lusol_solve.out';
abort$errorlevel 'Error executing "lusol lusol_solve.dat" in "%system.fp%".';

execute '=gams lusol_solve.out lf=lusol_solve.log lo=2 gdx=lusol_solve.gdx o=lusol_solve.lst';
abort$errorlevel 'Error processing LUSOL output.  See "%system.fp%lusol_solve.lst".';

parameter	xn(ia,ia)		Solution values returned by LUSOL,
		sstatusn(info,ia)	Solution status returned by LUSOL;

execute_load   'lusol_solve.gdx',sstatusn,xn;

$ifthen defined k

parameter	x(*,%cd%)		Indexed solution value
		sstatus(info,%cd%)	Indexed solution status;

if (mode=5,
  loop((jmap(j,jn),kmap(k,kn)), x(j,k)= xn(jn,kn));
else
  loop((imap(i,in),kmap(k,kn)), x(i,k)= xn(in,kn)); );

loop(kmap(k,kn), sstatus(info,k) = sstatusn(info,kn););
execute_unload 'lusol_out.gdx',i,j,k,sstatus,x;

$else

parameter	x(*)		Indexed solution value
		sstatus(info)	Indexed solution status;

if (mode=5,
  loop(jmap(j,jn), x(j) = xn(jn,"1"););
else
  loop(imap(i,in), x(i) = xn(in,"1");); );

sstatus(info) = sstatusn(info,"1");
execute_unload 'lusol_out.gdx',i,j,sstatus,x;

$endif

