Script which builds GTAP and GTAPWiNDC datasets:

  29-Aug-2023   2:48:04p         10,913   build.gms


Script which defines whether we are using GTAP9 or GTAP11:

  29-Aug-2023   2:45:32p            448   gtapingams.gms

Script which replicates the benchmark equilibrium for the 
input GTAP model:

  29-Aug-2023   2:46:42p            511   gtap_model.gms

Read the GTAP dataset (20_43), add array dimensions for households (h)
and subregions (s). The GTAP data is loaded for household and
subregion "rest".

  29-Aug-2023   2:47:14p          3,881   write_stub.gms

Scripts which replicate the benchmark equilibrium for the
output GTAP_WiNDC model (GAMS/MCP and GAMS/MPSGE):

  29-Aug-2023   1:56:56p          5,934   gtapwindc_data.gms
  29-Aug-2023   1:56:56p          5,973   gtapwindc_mge.gms
  29-Aug-2023   1:56:56p         13,030   gtapwindc_mcp.gms

Script which replicates the benchmark equilibrium for the WiNDC
household model:

  29-Aug-2023   1:56:56p          3,972   windc_data.gms
  29-Aug-2023   1:56:56p         20,995   windc_model.gms

We construct the disaggregate dataset in two steps.  The first of these
concerns only the 50 state / 250 household WiNDC model.  We use state shares
of agricultural receipts to disaggregate the AGR into 11 separate agricutural 
sectors:

 Disaggregate the agricultural sector 

  29-Aug-2023   2:46:16p         23,438   agrdisagg.gms


The original WiNDC dataset has but one agricultural sector:

	agr  "Farms and farm products (111CA)",

In this step agr is disaggregated into several sectors 11
sectors corresponding to agricultural sectors in GTAP:

	pdr  "Paddy rice",
	wht  "Wheat",
	gro  "Cereal grains nec",
	v_f  "Vegetables, fruit, nuts",
	osd  "Oil seeds",
	c_b  "Sugar cane, sugar beet",
	pfb  "Plant-based fibers",
	ocr  "Crops nec",
	ctl  "Bovine cattle, sheep, goats and horses",
	oap  "Animal products nec",
	rmk  "Raw milk",
	wol  "Wool, silk-worm cocoons"

Now that we have constructed a state-level national model for the US, we use these
data to disaggregate states and households in the corresponding 43 sector GTAP model:

  29-Aug-2023   1:56:56p         25,059   regiondisagg.gms



