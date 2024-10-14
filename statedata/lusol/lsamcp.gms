$title	Local Sensitivity Analysis: MCP Interface

*	Retrieve Hessian and Jacobian of an MCP Model at the Current Point

$setargs mdl extra

$hidden	Usage:

$hidden		$batinclude %incdir%LSA mdl
$hidden
$hidden	where	mdl	Model name.
$hidden

*	Define the maximum dimensions here:

$if not set lsa_dim $set lsa_dim 10000

$ifthen.undefined not defined lsa_ii

set	lsa_ii /e1*e%lsa_dim%/,
	lsa_jj /x1*x%lsa_dim%/;

set	lsa_i(lsa_ii)			Model equations,
	lsa_j(lsa_jj)			Model variables

	lsa_eq(lsa_ii)			Active equations in LSA,
	lsa_ve(lsa_jj)			Endogenous variables in LSA,
	lsa_mcpmap(lsa_ii,lsa_jj)	Complementarity mapping;

equation	lsa_e(lsa_ii)	Equation values at the point;
variable	lsa_x(lsa_jj)	Variables at the point;

parameter	lsa_jac(lsa_ii,lsa_jj)		Equation Jacobian,
		lsa_hes(lsa_ii,lsa_jj,lsa_jj)	Equation Hessian,
		lsa_decimals			Zero tolerance (decimals) /5/,
		lsa_tol(*,*)			Bound tolerance;

$endif.undefined


*	Blank declaration is provided as a means of making declarations.
*	This is required if calls to LSA are made inside a loop in the 
*	calling GAMS program:

$if "%mdl%"=="" $exit

*	Verify that we don't have too many arguments:

$if not "%extra%"=="" $abort Error in LSAmcp call: %extra%. 

$if not modtype %mdl% $abort "Error in argument to LSAmcp.  %mdl% is not a model."

*	Start with a cleanup of temporary files to avoid
*	inadvertantly reading results from a previous model:

execute 'if exist dictmap.gdx rm -f dictmap.gdx';
execute 'if exist hessian.gdx rm -f hessian.gdx';

*	Use convert to generate the Hessian, Jacobian and dictionary:

$echo dictMap  lsamcp_map.gdx >convert.opt
$echo dumpGDX  lsamcp.gdx     >>convert.opt
$echo GDXHessian yes	      >>convert.opt
option mcp = convert;
%mdl%.optfile = 1;
solve %mdl% using mcp;
option mcp = default;

abort$(%mdl%.solvestat<>1) "Error solving %mdl% with CONVERT.";

*	Check that the number of variables in the model does not exceed the 
*	dimension %lsa_dim%.  If it does, terminate the job with an error message:

abort$(max(%mdl%.numvar,%mdl%.numequ)>%lsa_dim%) 
	"Error: lsa_dim=%lsa_dim% needs to be increased.",%mdl%.numvar,%mdl%.numequ;

execute_load 'lsamcp_map.gdx', lsa_i=i, lsa_j=j;
execute_load 'lsamcp.gdx', lsa_jac=a, lsa_hes=h, LSA_E=e, LSA_X=x, lsa_mcpmap=mcpmap;

lsa_eq(lsa_i) = yes$(not round(min(LSA_E.L(lsa_i)-LSA_E.LO(lsa_i),LSA_E.UP(lsa_i)-LSA_E.L(lsa_i)),lsa_decimals));
lsa_ve(lsa_j) = yes$(round(min(LSA_X.L(lsa_j)-LSA_X.LO(lsa_j),LSA_X.UP(lsa_j)-LSA_X.L(lsa_j)),lsa_decimals));

lsa_tol(lsa_j,".L-LO") = LSA_X.L(lsa_j)-LSA_X.LO(lsa_j);
lsa_tol(lsa_j,"UP-.L") = LSA_X.UP(lsa_j)-LSA_X.L(lsa_j);
lsa_tol(lsa_i,".L-LO") = LSA_E.L(lsa_i)-LSA_E.LO(lsa_i);
lsa_tol(lsa_i,"UP-.L") = LSA_E.UP(lsa_i)-LSA_E.L(lsa_i);

