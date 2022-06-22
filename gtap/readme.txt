Here are the GAMS programs provided in this directory:

run.gms			GAMS script which executes these programs in sequence.

gtap_data.gms		Reads a GTAP10a dataset (GTAPinGAMS format)

windc_data.gms		Reads a WiNDC dataset (WiNDC_cps_static_gtap_10_state.gdx 
			or WiNDC_soi_static_gtap_10_state.gdx generated in the WiNDC
			household module WiNDC version 3.1)

gtap_model.gms		Canonical GTAPinGAMS model (runs with gtap_10.gdx)

windc_model.gms		Canonical WiNDC model (runs with either of the two
			WiNDC datasets).

write_stub.gms		Code which translates a GTAP dataset to a 
			GTAPWiNDC dataset with a single subregion in each 
			country.

balance.gms		Code which reconciles either of the WiNDC datasets
			with the GTAP dataset and in the process provides
			a GTAPWiNDC dataset.

gtapwindc_data.gms	Reads a dataset for the composite model (e.g., 
			gtap_10_cps_2014.gdx or gtap_10_soi_2014.gdx)

gtapwindc_mge.gms		Canonical GTAPWiNDC model (runs with gtap_10_cps_2014.gdx
			or gtap_10_soi_2014.gdx)

tqmodel.gms  Tariff Quota Simulations with the GTAP-WiNDC Model
     	(runs with gtap_10_cps_2014.gdx or gtap_10_soi_2014.gdx)

