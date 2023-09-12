The WiNDC household buildstream is an extension to the core WiNDC buildstream. The household buildstream generates disaggregated consumer accounts based on the core WiNDC database, CPS and SOI data. The key challenges were denominating reasonable transfer income and understanding income tax liabilities, savings, capital ownership versus demands, salaries and wages. We provide a static and a dynamic calibration and use income elasticities to separate household level commodity expenditures. The [presentation on the household build](https://windc.wisc.edu/2021-windc-meeting-hh.pdf) at the WiNDC Annual Meeting 2021 offers a detailed description of the calibration routine.

Navigate to the subdirectory household. This directory contains the necessary input data (subdirectory `data_sources`) and all GAMS code needed to generate the WiNDC household datasets for the years 2015 to 2017. In addition to the data in the subdirectory `data_sources`, the WiNDC household buildstream takes as input the core WiNDC database, so make sure that the GDX file `WiNDCdatabase.gdx` is in the directory `core`.

If you have a local version of GAMS and access to the relevant licenses, navigate in your command line to the directory household and run the GAMS file `build.gms` by typing the following command:

    gams build.gms

The code creates the directory `datasets`, generates the household datasets and saves all household datasets in this directory. The code in the file `build.gms` runs the following routines for the years 2015, 2016 and 2017.

1. `cps_data.gms`
Reads [Current Population Survey (CPS)](https://www.census.gov/programs-surveys/cps.html) data from the directory `data_sources`, subdirectory `cps`, processes it and saves the processed data in a GDX file in the directory `gdx`.

2. `soi_data.gms`
Reads [Statistics of Income (SOI)](https://www.irs.gov/statistics/soi-tax-stats-statistics-of-income) data from the directory `data_sources`, subdirectory `soi`, processes it and saves the processed data in a GDX file in the directory `gdx`. The routine also computes and saves data on capital gains that will be used to construct the CPS dataset.

3. `hhcalib.gms`
Reads a household dataset (CPS or SOI) and recalibrates it to match the core WiNDC database. There are two calibration options: `static` and `dynamic`. The `dynamic` option forces investment to line up with reported capital demands for a balanced growth path. This impacts the calibration of the household accounts since total savings need to equal total investment. The calibration routine uses income elasticities (estimated on the national level) based on the [Consumer Expenditure Survey (CEX)](https://www.bls.gov/cex/) from the Bureau of Labor Statistic (BLS). The resulting parameters are saved in a GDX file in the directory `gdx`. The capital tax rate is saved in its own file and is used in the next routine.

4. `dynamic_calib.gms`
Reads the dynamic datasets and recalibrates the rest of the commodity accounts to satisfy balanced growth requirements; saves the recalibrated parameters in a GDX file in the directory `gdx`.

5. `consolidate.gms`
Merges the household data of each type to one GDX file and saves the resulting files to the directory `datasets`. There are four files:

    <center>

    | |static|dynamic|
    |---|---|---|
    |CPS|`WiNDC_cps_static.gdx`|`WiNDC_cps_dynamic.gdx`|
    |SOI|`WiNDC_soi_static.gdx`|`WiNDC_soi_dynamic.gdx`|

    </center>
    Each dataset has household data for the years 2015 to 2017 on the US state level with WiNDC economic sectors.

6. `aggr.gms`
This aggregation routine is optional.
Aggregates the four household datasets to given economic sectors and regions. The environment variable `smap` denotes the sectoral aggregation and `rmap` denotes the regional aggregation. The options for `smap` are `windc` (the 69 WiNDC sectors), `bluenote` (the sectors of the WiNDC energy-environment module), `gtap` ([GTAP](https://www.gtap.agecon.purdue.edu/) sectors) and `macro` (6 sectors). The options for `rmap` are `state` (US states) and `census` ( [9 Census regions](https://www2.census.gov/geo/docs/maps-data/maps/reg_div.txt)). The routine reads the relevant mapping from the subdirectory maps; users can easily create their own maps for customized sectoral and regional aggregations. The aggregated datasets are saved in the directory `datasets`.

