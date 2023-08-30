

1. `build.gms` - Script which builds GTAP and GTAPWiNDC datasets

2. `gtapingams.gms` - Script which defines whether we are using GTAP9 or GTAP11. If the data files for GTAP11 exist, this will default to GTAP11, 
otherwise GTAP9.
3. `gtap_model.gms` - Script which replicates the benchmark equilibrium for the input GTAP model
4. `write_stub.gms` - Read the GTAP dataset (20_43), add array dimensions for households (h)
and subregions (s). The GTAP data is loaded for household and
subregion "rest".
5. `gtapwindc_data.gms`, `gtapwindc_mge.gms`, `gtapwindc_mcp.gms` - Scripts which replicate the benchmark equilibrium for the
output GTAP_WiNDC model (GAMS/MCP and GAMS/MPSGE)
6. `windc_data.gms` - Script which loads the WiNDC household data
7. `windc_model.gms` - Script which replicates the benchmark equilibrium for the WiNDC household model.

8. `agrdisagg.gms` - Disaggregate the agricultural sector 

	We construct the disaggregate dataset in two steps.  The first of these
	concerns only the 50 state / 250 household WiNDC model.  We use state shares of agricultural receipts to disaggregate the AGR into 11 separate agricultural sectors

	The original WiNDC dataset has but one agricultural sector:

		agr  Farms and farm products (111CA)

	In this step agr is disaggregated into several sectors 11
sectors corresponding to agricultural sectors in GTAP:

	|Key|Description|
	|---|---|
	|pdr|Paddy rice|
	|wht|Wheat|
	|gro|Cereal grains nec|
	|v_f|Vegetables, fruit, nuts|
	|osd|Oil seeds|
	|c_b|Sugar cane, sugar beet|
	|pfb|Plant-based fibers|
	|ocr|Crops nec|
	|ctl|Bovine cattle, sheep, goats and horses|
	|oap|Animal products nec|
	|rmk|Raw milk|
	|wol|Wool, silk-worm cocoons|



9. `regiondisagg.gms` - Now that we have constructed a state-level national model for the US, we use these
data to disaggregate states and households in the corresponding 43 sector GTAP model



