## Overview

The WiNDC household subroutine is an extension to the core WiNDC buildstream that disaggregates regional representative households in the core database on the basis of household income from 2000-2021. The subroutine leverages several additional source datasets to produce disaggregate consumer accounts, including: the [Current Population Survey (CPS)](https://www.census.gov/programs-surveys/cps.html), state-level statistics from the [Statistics of Income (SOI)](https://www.irs.gov/statistics/soi-tax-stats-statistics-of-income) database, commuting flows from the [American Community Survey](https://www.census.gov/programs-surveys/acs), Medicare and Medicaid benefits from [Centers for Medicare and Medicaid Services (CMS)](https://www.cms.gov/), [National Income and Product Accounts (NIPA)](https://www.bea.gov/itable/national-gdp-and-personal-income), average and marginal income tax rates from [TAXSIM](https://taxsim.nber.org/taxsim27/), the [Consumer Expenditure Survey (CE)](https://www.bls.gov/cex/), and several academic publications on under-reporting bias in survey data on transfer incomes. The disaggregation routine relies on an income balance condition that allows us to fully denominate incomes and expenditures without defining any ad hoc adjustment parameters to close the income balance constraint in a CGE model. The income balance condition is specified as:

$$
\sum_q WAGES_{rqh} + INTEREST_{rh} + \sum_{t}TRANS_{rht} = CONS_{rh} + TAXES_{rh} + SAVINGS_{rh}
$$

For region $r$ and household $h$, the subroutine produces micro-consistent accounts that equates labor income (including all people that live in $r$ and work in region $q$), interest income, and government transfer income (across disaggregate transfer categories $t$, see below) with aggregate commodity consumption, labor income taxes, and household savings. The [presentation on the household build](https://windc.wisc.edu/2021-windc-meeting-hh.pdf) at the WiNDC Annual Meeting 2021 offers a detailed description of a previous version of the calibration routine.

The routine is designed to be flexible. The default options produces a dataset with 5 income groups based on the Census definition of a household. Several additional options are provided depending on user preference:
 - Alternative definition of the regional representative agent denominated at the tax-filer unit level (based on SOI information).
 - Dynamic adjustments to investment/savings based on user choice of steady state parameters (depreciation, growth, and interest rates). The default option assumes a static investment closure, leaving the data to match BEA totals for investments.
 - Alternative assumptions of capital ownership. The subroutine employs a pooled national markets for savings and capital income by implicitly assume equalization of rates of return across all capital income and that the geography of savings is independent of the geography for investment demands. The default routine assumes all sectoral capital demands is owned domestically, and similarly, all investment demands are provided for by domestic savings. We have characterized an alternative option for capital income and savings where a portion of the capital stock and investment demands are owned or proved for internationally.

## Running the Household Subroutine

Before running the household build, the user must first verify that the core WiNDC database has been constructed or downloaded and is located in the `core` subdirectory. Verify that all data sources have been downloaded to the local WiNDC distribution, specifically adding household files in the `data` directory. Navigate to the household subdirectory, which contains all GAMS code needed to generate the WiNDC household datasets for the years 2000 to 2021 (for the CPS-based build). Note that the distribution contains a restricted set of years for an SOI-based build, which is included purely as a sensitivity to the initial data source information.

If you have a local version of GAMS and access to the relevant licenses, navigate in your command line to the directory household and run the GAMS file `build.gms` by typing the following command:

    gams build.gms

The code creates the directory `datasets`, generates the household datasets and saves all household datasets in this directory. Should the user like to generate household datasets based on alternative assumptions than those in the default settings, see command line options in the next section.

## File Listing

1. `build.gms` - launching program to generate WiNDC datasets with disaggregate household accounts. For many users, this is the only file that needs to be run in order to generate a dataset. All other files in household sub-directory are called from `build.gms`.

    Inputs: `data/household`

    Outputs: `datasets/WiNDC_%hhdata%_%invest%_%capital_ownership%_%year%_%smap%_%rmap%.gdx.gdx`

    Command line options:
    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
    | year | cps: 2000-2021, soi: 2014-2017 | 2017, 2021 | Years to compute data |
    | hhdata | cps, soi | cps | Primary household data source |
    | invest | static, dynamic| static| Investment calibration |
    | captial_ownership| all, partial| all | Assumption on capital ownership |
    | rmap | state, census_divisions, census_regions, national | state | Regional mapping |
    | smap | windc, gtap_32, sage, gtap_10, macro, bluenote | windc, gtap_32 | Sectoral mapping | 


2. `cps_data.gms` - Reads [Current Population Survey (CPS)](https://www.census.gov/programs-surveys/cps.html) data from the directory `data/household/cps`, processes it and saves the processed data in a GDX file in the directory `household/gdx`. Processed data includes CPS income categories, number of households, and income tax rates. Notably, should a user like to change the income thresholds for households, see the R program that leverages the CPS API to grab and reconcile income data in `data/household/cps/read_cps.r`.

    Inputs: `data/household/cps`

    Outputs: `household/gdx`

3. `soi_data.gms` - Reads [Statistics of Income (SOI)](https://www.irs.gov/statistics/soi-tax-stats-statistics-of-income) data from the directory `data/household/soi`, processes it and saves the processed data in a GDX file in the directory `household/gdx`. Processed data includes SOI income categories and number of tax filers. Notably, should a user like to change the income thresholds for tax-filer categories, see the R program that downloads and aggregates the SOI data in `data/household/cps/read_soi.r`.

    Inputs: `data/household/soi`

    Outputs: `household/gdx`

4. `hhcalib.gms` - Calibrates consumer accounts to several source datasets. The subroutine proceeds in three steps: (1) recalibrates investment demands to match steady state assumption if the user has selected the `dynamic` investment option [optional], (2) calibrates income and aggregate expenditures for each region and household type, (3) disaggregates total household expenditures by income group by defining an income expansion path for each commodity type.

    Inputs: - `household/gdx`,
            - `data/household/cps/cps_nipa_income_categories.csv`,
	    - `data/health_care/public_health_benefits_2009_2019.csv`,
	    - `data/household/cps/windc_vs_nipa_domestic_capital.csv`,
	    - `data/household/acs/acs_commuting_data.csv`,
	    - `data/household/cex/national_income_elasticities_CEX_2013_2017.csv`

    Outputs: `gdx/calibrated_hhdata_%invest%_%hhdata%_%capital_ownership%_%year%.gdx`

5. `dynamic_calib.gms` - Reads the dynamic datasets and recalibrates the rest of the commodity accounts to satisfy balanced growth requirements; saves the recalibrated parameters in a GDX file in the directory `gdx`.

6. `consolidate.gms` - Merges the household data of each type to one GDX file and saves the resulting files to the directory `datasets`. There are four files:

    <center>

    | |static|dynamic|
    |---|---|---|
    |CPS|`WiNDC_cps_static.gdx`|`WiNDC_cps_dynamic.gdx`|
    |SOI|`WiNDC_soi_static.gdx`|`WiNDC_soi_dynamic.gdx`|

    </center>
    Each dataset has household data for the years 2015 to 2017 on the US state level with WiNDC economic sectors.

7. `aggr.gms` - This aggregation routine is optional. Aggregates the four household datasets to given economic sectors and regions. The environment variable `smap` denotes the sectoral aggregation and `rmap` denotes the regional aggregation. The options for `smap` are `windc` (the 69 WiNDC sectors), `bluenote` (the sectors of the WiNDC energy-environment module), `gtap` ([GTAP](https://www.gtap.agecon.purdue.edu/) sectors) and `macro` (6 sectors). The options for `rmap` are `state` (US states) and `census` ( [9 Census regions](https://www2.census.gov/geo/docs/maps-data/maps/reg_div.txt)). The routine reads the relevant mapping from the subdirectory maps; users can easily create their own maps for customized sectoral and regional aggregations. The aggregated datasets are saved in the directory `datasets`.


## Optional R Routines

Source datasets are compiled using the R programming language. All R routines needed for generating CPS, NIPA, SOI, ACS, and CMS source datasets `CSV` files accompany the data source download. All programs are heavily documented and should be self explanatory.

## Default Dataset Dimensions

SAVE FOR MITCH.