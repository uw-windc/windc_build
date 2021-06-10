$title Check Consistency of the WiNDC Accounting Models (MGE and MCP)

$if not set ds $set ds windcdatabase_huber.gdx

$if not set gdxdir $set gdxdir gdx%system.dirsep%

*	Solve sequence is either mcpmge or mgemcp

$if not set sequence $set sequence mgemcp

*	Read the dataset:

$include windc_coredata

*	Read the MGE model:

$include mgemodel

*	Read the MCP model:

$include mcpmodel

*	Replicate the benchmark equilibrium in both formats:

mgemodel.workspace = 100;
mgemodel.iterlim = 0;

$INCLUDE %gams.scrdir%MGEMODEL.GEN
SOLVE mgemodel using mcp;
ABORT$(mgemodel.objval > 1e-5) "Error in benchmark calibration of the MGE model.";

mcpmodel.iterlim = 0;
$INCLUDE %gams.scrdir%MCPMODEL.GEN

SOLVE mcpmodel using mcp;
ABORT$(mcpmodel.objval > 1e-5) "Error in benchmark calibration of the MCP model.";

*	Calculate a tariff shock (unilateral free trade):

display tm;
tm(r,g) = 0;

set	seqopt			Sequence options /mcpmge, mgemcp/,
	sequence(seqopt)	Chosen sequence (domain check) /%sequence%/;

$goto %sequence%

*	Solve the MCP model first and verify that the resulting point solves the MGE model.

$label mcpmge

*	Fix an income level to normalize prices in the MCP model (this is done 
*	automatically in the MGE model):

alias (r,rr);
RA.FX(r)$(RA.L(r)=smax(rr,RA.L(rr))) = RA.L(r);


mcpmodel.iterlim = 100000;
$INCLUDE %gams.scrdir%MCPMODEL.GEN
SOLVE mcpmodel using mcp;

abort$round(mgemodel.objval,3)	"Counterfactural calculation error with MCPMODEL.";

*	Save the solution to speed up subsequent runs:

mgemodel.iterlim = 0;
$INCLUDE %gams.scrdir%MGEMODEL.GEN
SOLVE mgemodel using mcp;

abort$round(mgemodel.objval,3)	"Replication error with MGEMODEL.";

display "Model replication check for mcpmge successful.";

$exit

*	Solve the MGE model first and verify that the resulting point solves the MCP model.

$label mgemcp

mgemodel.iterlim = 100000;
$INCLUDE %gams.scrdir%MGEMODEL.GEN
SOLVE mgemodel using mcp;

abort$round(mgemodel.objval,3)	"Counterfactural calculation error with MGEMODEL.";

mcpmodel.iterlim = 0;
SOLVE mcpmodel using mcp;

abort$round(mcpmodel.objval,3)	"Replication error with MCPMODEL.";

display "Model replication check for mgemcp successful.";
