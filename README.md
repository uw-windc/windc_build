


# WiNDC Build Stream

Primary repository for the Wisconsin National Data Consortium (WiNDC) dataset generation environment.

Before running any methods in this package, you first need to download the datasets and locate them in the correct directories. The [Data](#data) section details this process.

This repository contains 4 primary methods

1. [Core](#core)
2. [Households](#households)
3. [Bluenote](#bluenote)
4. [GTAPWiNDC](#gtapwindc)



# Data

The data required to build each of piece of the repository are located at the following link
[WiNDC downloads page](https://windc.wisc.edu/downloads.html). Extract `windc_data.zip` into 
the `data` directory.

Data is included to run `core`, `household`, `bluenote`, and `gtap9`. In order to run `gtap11` you
need to obtain a license from GTAP. The data for GTAPWiNDC for the year 2017 is propriety to GTAP and requires a GTAP license. 

The zip file should have the correct directory structure, but the following is the correct naming scheme:

```
|data
|-- core
|  |   windc_base.gdx
|-- household
|  |  |-- cex
|  |  |-- cps
|  |  |-- soi
|-- GTAPWiNDC
|  |-- gtap9
|  |  |  flexagg9aY04.zip
|  |  |  flexagg9aY07.zip
|  |  |  flexagg9aY11.zip
|  |-- gtap11
|  |  |  GDX_AY1017.zip
```


# Description of each method




## Core

If you have a local version of GAMS and have access to the relevant licenses, navigate in your command line or terminal to the directory `windc_build_3_0`, subdirectory `core` and run the GAMS file `build.gms` by simply typing the following command:

        gams build.gms

Note that this build will work in both, Windows and UNIX/LINUX 
environments. See the [WiNDC paper](https://windc.wisc.edu/windc.pdf) for a description of all subroutines within the buildstream.

Two versions of the core WiNDC database will be generated and saved in the directory core: `WiNDCdatabase.gdx` and `WiNDCdatabase_huber.gdx`. The first version is based on the least squares matrix balancing routine and the second version is based on the Huber method. Both databases contain data for all US states and 69 (summary) sectors from 1997 to 2017.

If you don't have access to a GAMS license including needed solver licenses, you can generate the databases locally using [NEOS](https://neos-server.org/neos/). To run the routines on NEOS, type the following command:

    gams build.gms --neos=yes

Once the core WiNDC database is generated, it can be loaded into a general equilibrium model in GAMS. The file `windc_coredata.gms` demonstrates how to read data from the database and extract data for a specific year. The file `replicate.gms` includes a simple general equilibrium model in MCP and MPSGE format, verifies benchmark consistency, solves a counterfactual (tariff shock) and verifies consistency at that point as well.

## Households
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


## Bluenote
The Bluenote buildstream incorporates energy-environment satellite data from the State Energy Data System (SEDS) to the WiNDC household datasets.

Navigatge to the subdirectory `bluenote`. This directory contains the GAMS code needed to generate datasets with disaggreagted consumer accounts that include energy-environment satellite data. The buildstream is based on the source data for the core WiNDC buildstream (the GDX file `windc_base.gdx` in the directory `core`) that includes data from SEDS and the WiNDC household datasets `WiNDC_cps_static.gdx` and `WiNDC_soi_static.gdx` in the directory household, subdirectory datasets. Please make sure that you run the WiNDC household build first in order to generate the necessary household datasets.

If you have a local version of GAMS and access to the relevant licenses, navigate in your command line to the directory `bluenote` and run the GAMS file build.gms by typing the following command:

    gams build.gms

The code creates the directory `datasets`, generates the Bluenote datasets for the years 2015 to 2017 and saves the datasets in this directory. The GAMS routines that generate the Bluenote datasets are described in the WiNDC paper. The following datasets are generated:

||state|census|
|---|---|---|
|CPS|`WiNDC_bluenote_cps_state_%year%.gdx` |`WiNDC_bluenote_cps_census_%year%.gdx`|
|SOI|`WiNDC_bluenote_cps_state_%year%.gdx` |`WiNDC_bluenote_cps_census_%year%.gdx`|

The values for the variable `%year%` are `2015`, `2016` and `2017`. The datasets in the first column are on the US state level and the datasets in the secod column are aggreggated to the [9 Census regions](https://www2.census.gov/geo/docs/maps-data/maps/reg_div.txt). The datasets in the first row are based on household data from the [Current Population Survey (CPS)](https://www.census.gov/programs-surveys/cps.html) and the datasets in the second row are based on household data from the [Statistics of Income (SOI)](https://www.irs.gov/statistics/soi-tax-stats-statistics-of-income).

In addition to the routines to generate the datasets, the directory `bluenote` has two models that demonstrate how the Bluenote datasets may be used in a modeling application. The energy tax model in the file `bluenote_model.gms` includes disaggregated households, while the energy tax model in the file `bluenote_model_v2_1.gms` demonstrates how the Bluenote datasets on the US state level may be read and used in a model with just a single representative household per region. This model mimics the Bluenote model from WINDC version 2.1.

## GTAPWiNDC
The GTAPWiNDC buildstream incorporates data from either the publicly available GTAP 9 release or proprietary GTAP 11 release. To inquire about obtaining a license for the GTAP 11 database, visit the [GTAP website](https://www.gtap.agecon.purdue.edu/databases/v11/). The GTAP version 9 database is included in our data distribution.

First, the file `GTAPWiNDC/gtapingams.gms` controls which version of the GTAP database you'll be using. By default this file specifies gtap9. To switch to gtap11, change this file to read:

```
$setglobal gtapingams  gtap11\
*$setglobal gtapingams  gtap9\
```
In words, delete the `*` from the beginning of line 3 and add a `*` to the beginning of line 4. 

Second, navigate to the subdirectory `GTAPWiNDC/gtapN` where N is either 9 or 11, depending on the version of the data you wish to build. Run the command:

    gams build.gms

You must run both `core` and `household` before running this command. This will build the GTAP in WiNDC dataset. 

Finally, 

