# Household


- [Overview](#overview)
- [Running the Household Subroutine](#running-the-household-subroutine)
- [File Listing](#file-listing)
- [Canonical Static Household Model](#canonical-static-household-model)
- [Optional R Routines](#optional-r-routines)
- [Set Listing](#set-listing)
    - [Sets](#sets)
    - [Parameters](#parameters)
    - [Set Listing](#set-listing)
        - [Regions](#regions)
            - [States](#states)
            - [Census Divisions](#census-divisions)
            - [Census Regions](#census-regions)
            - [National](#national)
        - [Goods and sectors from BEA -- Margin related sectors](#goods-and-sectors-from-bea----margin-related-sectors)
            - [WiNDC Aggregation](#windc-aggregation)
            - [GTAP_32 Aggregation](#gtap_32-aggregation)
            - [GTAP 10 Aggregation](#gtap-10-aggregation)
            - [Macro](#macro)
        - [Margins trade or transport](#margins-trade-or-transport)
        - [Household Categories](#household-categories)
        - [Transfer Types](#transfer-types)


# Overview

The WiNDC household subroutine is an extension to the core WiNDC buildstream that disaggregates regional representative households in the core database on the basis of household income from 2000-2021. The subroutine leverages several additional source datasets to produce disaggregate consumer accounts, including: the [Current Population Survey (CPS)](https://www.census.gov/programs-surveys/cps.html), state-level statistics from the [Statistics of Income (SOI)](https://www.irs.gov/statistics/soi-tax-stats-statistics-of-income) database, commuting flows from the [American Community Survey](https://www.census.gov/programs-surveys/acs), Medicare and Medicaid benefits from [Centers for Medicare and Medicaid Services (CMS)](https://www.cms.gov/), [National Income and Product Accounts (NIPA)](https://www.bea.gov/itable/national-gdp-and-personal-income), average and marginal income tax rates from [TAXSIM](https://taxsim.nber.org/taxsim27/), the [Consumer Expenditure Survey (CE)](https://www.bls.gov/cex/), and several academic publications on under-reporting bias in survey data on transfer incomes. The disaggregation routine relies on an income balance condition that allows us to fully denominate incomes and expenditures without defining any ad hoc adjustment parameters to close the income balance constraint in a CGE model. The income balance condition is specified as:

$$
\sum_q WAGES_{rqh} + INTEREST_{rh} + \sum_{t}TRANS_{rht} = CONS_{rh} + TAXES_{rh} + SAVINGS_{rh}
$$

For region $r$ and household $h$, the subroutine produces micro-consistent accounts that equates labor income (including all people that live in $r$ and work in region $q$), interest income, and government transfer income (across disaggregate transfer categories $t$, see below) with aggregate commodity consumption, labor income taxes, and household savings. The [presentation on the household build](https://windc.wisc.edu/2021-windc-meeting-hh.pdf) at the WiNDC Annual Meeting 2021 offers a detailed description of a previous version of the calibration routine.

The routine is designed to be flexible. The default options produce a dataset with 5 income groups based on the Census definition of a household. Several additional options are provided depending on user preference:
 - Alternative definition of the regional representative agent denominated at the tax-filer unit level (based on SOI information).
 - Dynamic adjustments to investment/savings based on user choice of steady state parameters (depreciation, growth, and interest rates). The default option assumes a static investment closure, leaving the data to match BEA totals for investments.
 - Alternative assumptions of capital ownership. The subroutine employs a pooled national markets for savings and capital income by implicitly assume equalization of rates of return across all capital income and that the geography of savings is independent of the geography for investment demands. The default routine assumes all sectoral capital demands is owned domestically, and similarly, all investment demands are provided for by domestic savings. We have characterized an alternative option for capital income and savings where a portion of the capital stock and investment demands are owned or proved for internationally.

# Running the Household Subroutine

Before running the household build, the user must first verify that the core WiNDC database has been constructed or downloaded and is located in the `core` subdirectory. Verify that all data sources have been downloaded to the local WiNDC distribution, specifically adding household files in the `data` directory. Navigate to the household subdirectory, which contains all GAMS code needed to generate the WiNDC household datasets for the years 2000 to 2021 (for the CPS-based build). Note that the distribution contains a restricted set of years for an SOI-based build, which is included purely as a sensitivity to the initial data source information.

If you have a local version of GAMS and access to the relevant licenses, navigate in your command line to the directory household and run the GAMS file `build.gms` by typing the following command:

    gams build.gms

The code creates the directory `datasets`, generates the household datasets and saves all household datasets in this directory. Should the user like to generate household datasets based on alternative assumptions than those in the default settings, see command line options in the next section.

# File Listing

1. `build.gms` - launching program to generate WiNDC datasets with disaggregate household accounts. For many users, this is the only file that needs to be run in order to generate a dataset. All other files in household sub-directory are called from `build.gms`.

    Inputs: `data/household`

    Outputs: `datasets/WiNDC_%hhdata%_%invest%_%capital_ownership%_%year%_%smap%_%rmap%.gdx.gdx`

    Command line options:
    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
    | year | cps: 2000-2021, soi: 2014-2017 | 2017, 2021 | Years to compute data |
    | hhdata | cps, soi | cps | Primary household data source |
    | invest | static | static| Investment calibration |
    | captial_ownership| all, partial| all | Assumption on capital ownership |
    | rmap | state, census_divisions, census_regions, national | state | Regional mapping |
    | smap | windc, gtap_32, gtap_10, macro, bluenote | windc, gtap_32 | Sectoral mapping | 


    Note: The option pair (`cps`, `all`) has a calibration error in years `2006` and `2007`. If you require these two years, with the given option pair, you can modify the bounds on the household variables. We opted to leave as-is to preserve variable preciseness in other years. 
    
     All other options and years run properly.

2. `cps_data.gms` - Reads [Current Population Survey (CPS)](https://www.census.gov/programs-surveys/cps.html) data from the directory `data/household/cps`, processes it and saves the processed data in a GDX file in the directory `household/gdx`. Processed data includes CPS income categories, number of households, and income tax rates. Notably, should a user like to change the income thresholds for households, see the R program that leverages the CPS API to grab and reconcile income data in `data/household/cps/read_cps.r`.

    Inputs: `data/household/cps`

    Outputs: `household/gdx`

3. `soi_data.gms` - Reads [Statistics of Income (SOI)](https://www.irs.gov/statistics/soi-tax-stats-statistics-of-income) data from the directory `data/household/soi`, processes it and saves the processed data in a GDX file in the directory `household/gdx`. Processed data includes SOI income categories and number of tax filers. Notably, should a user like to change the income thresholds for tax-filer categories, see the R program that downloads and aggregates the SOI data in `data/household/cps/read_soi.r`.

    Inputs: `data/household/soi`

    Outputs: `household/gdx`

4. `hhcalib.gms` - Calibrates consumer accounts to several source datasets. The subroutine proceeds in three steps: (1) recalibrates investment demands to match steady state assumption if the user has selected the `dynamic` investment option [optional], (2) calibrates income and aggregate expenditures for each region and household type, (3) disaggregates total household expenditures by income group by defining an income expansion path for each commodity type.

    Inputs:
    - `household/gdx`,
    - `data/household/cps/cps_nipa_income_categories.csv`,
    - `data/health_care/public_health_benefits_2009_2019.csv`,
    - `data/household/cps/windc_vs_nipa_domestic_capital.csv`,
    - `data/household/acs/acs_commuting_data.csv`,
    - `data/household/cex/national_income_elasticities_CEX_2013_2017.csv`

    Outputs: `gdx/calibrated_hhdata_%invest%_%hhdata%_%capital_ownership%_%year%.gdx`

5. `dynamic_calib.gms` - Reads the dynamic datasets and recalibrates the rest of the commodity accounts to satisfy balanced growth requirements.

   Inputs:
   - `core/WiNDCdatabase.gdx`
   - `household/gdx`

   Outputs: `household/gdx/dynamic_parameters_%year%.gdx`

6. `consolidate.gms` - Merges the recalibrated household accounts (and adjusted dynamic parameters, if `dynamic` option is chosen) with the rest of the WiNDC accounts for a given year.

   Inputs:
   - `core/WiNDCdatabase.gdx`
   - `household/gdx`
   
   Outputs: `datasets/WiNDC_%hhdata%_%invest%_%capital_ownership%_%year%.gdx`

7. `aggr.gms` - This aggregation routine is optional. The output of `consolidate.gms` is at the state-level with a summary-level sector scheme maintained in the core WiNDC database. Should a user like to aggregate the dataset to be at a different regional and/or sectoral aggregation, this program allows for users to create mapping files to aggregate the data. Several are already provided with the distribution. See options for `rmap` and `smap` in the above table. 

# Canonical Static Household Model

The mutli-regional, multi-sectoral, multi-household CGE model accompanying this distribution can be found in `static_model.gms`.

- The model reads in the chosen household dataset using `windc_hhdata.gms`.
- We provide a method for calibrating a labor-leisure choice to exogenous labor supply income and substitution elasticities from [McClelland and Mok (2012)](https://www.cbo.gov/publication/43675) based on the calibration strategy found in the [SAGE documentation](https://www.epa.gov/environmental-economics/sage-model-documentation-version-210).
- The model verifies both the calibration of both an MPSGE and MCP version of the model and replicates an equivalent shock to a reduction in the marginal labor income tax rate.

A complete overview of the household model accompanying the disaggregated set of consumer accounts is forthcoming in a future publication.

# Optional R Routines

Source datasets are compiled using the R programming language. All R routines needed for generating CPS, NIPA, SOI, ACS, and CMS source dataset `CSV` files accompany the data source download. All programs are heavily documented and should be self explanatory.

# Set Listing



## Sets

| Set Name | Description                  |
|:---------|:-----------------------------|
| [r](#regions)        | Regions - Controlled by `rmap`                      |
| [s, gm](#goods-and-sectors-from-bea----margin-related-sectors)        | Goods and sectors from BEA  and Margin related sectors. Controlled by `smap`|
| [m](#margins-trade-or-transport)        | Margins (trade or transport) |
| [h](#household-categories)        | household categories         |
| [trn](#transfer-types)      | transfer types               |


## Parameters

|Parameter Name | Domain | Description |
|:---------|:--------|:-----------------------------------------------|
| ys0      | r, s, g | Sectoral supply                                |
| ld0      | r, s    | Labor demand                                   |
| kd0      | r, s    | Capital demand                                 |
| id0      | r, g, s | Intermediate demand                            |
| ty0      | r, s    | Production tax                                 |
| yh0      | r, g    | Household production                           |
| cd0      | r, g    | Final demand                                   |
| c0       | r       | Aggregate final demand                         |
| i0       | r, g    | Investment demand                              |
| g0       | r, g    | Government demand                              |
| bopdef0  | r       | Balance of payments                            |
| hhadj0   | r       | Household adjustment                           |
| s0       | r, g    | Aggregate supply                               |
| xd0      | r, g    | Regional supply to local market                |
| xn0      | r, g    | Regional supply to national market             |
| x0       | r, g    | Exports of goods and services                  |
| rx0      | r, g    | Re-exports of goods and services               |
| a0       | r, g    | Armington supply                               |
| nd0      | r, g    | Regional demand from national market           |
| dd0      | r, g    | Regional demand from local  market             |
| m0       | r, g    | Imports                                        |
| ta0      | r, g    | Tax net subsidy rate on intermediate demand    |
| tm0      | r, g    | Import tariff                                  |
| md0      | r, m, g | Total margin demand                            |
| nm0      | r, g, m | Margin demand from national market             |
| dm0      | r, g, m | Margin supply from local market                |
| le0      | r, q, h | Household labor endowment                      |
| ke0      | r, h    | Household interest payments                    |
| tk0      | *       | Capital tax rate                               |
| tl_avg0  | r, h    | Average tax rate on labor income               |
| tl0      | r, h    | Marginal tax rate on labor income              |
| tfica0   | r, h    | FICA tax rate on labor income                  |
| cd0_h    | r, g, h | Household level expenditures                   |
| c0_h     | r, h    | Aggregate household level expenditures         |
| sav0     | r, h    | Household saving                               |
| fsav0    |         | Foreign savings                                |
| fint0    |         | Foreign interest payments                      |
| trn0     | r, h    | Household transfer payments                    |
| hhtrn0   | r, h, trn | Disaggregate transfer payments                 |
| pop0     | r, h    | Population (households or returns in millions) |


## Set Listing

### Regions

1. [state](#states)
2. [census_divison](#census-divisions)
3. [census_regions](#census-regions)
4. [national](#national)


#### States
|r|Description| |r|Description|
|---|---|---|---|--|
|AK|Alaska| |MT|Montana|
|AL|Alabama| |NC|North Carolina|
|AR|Arkansas| |ND|North Dakota|
|AZ|Arizona| |NE|Nebraska|
|CA|California| |NH|New Hampshire|
|CO|Colorado| |NJ|New Jersey|
|CT|Connecticut| |NM|New Mexico|
|DC|District of Columbia| |NV|Nevada|
|DE|Delaware| |NY|New York|
|FL|Florida| |OH|Ohio|
|GA|Georgia| |OK|Oklahoma|
|HI|Hawaii| |OR|Oregon|
|IA|Iowa| |PA|Pennsylvania|
|ID|Idaho| |RI|Rhode Island|
|IL|Illinois| |SC|South Carolina|
|IN|Indiana| |SD|South Dakota|
|KS|Kansas| |TN|Tennessee|
|KY|Kentucky| |TX|Texas|
|LA|Louisiana| |UT|Utah|
|MA|Massachusetts| |VA|Virginia|
|MD|Maryland| |VT|Vermont|
|ME|Maine| |WA|Washington|
|MI|Michigan| |WI|Wisconsin|
|MN|Minnesota| |WV|West Virginia|
|MO|Missouri| |WY|Wyoming|
|MS|Mississippi||||


#### Census Divisions 

| uni   | element_text       |
|:------|:-------------------|
| neg   | New England        |
| mid   | Mid Atlantic       |
| enc   | East North Central |
| wnc   | West North Central |
| sac   | South Atlantic     |
| esc   | East South Central |
| wsc   | West South Central |
| mtn   | Mountain           |
| pac   | Pacific            |


#### Census Regions

| uni   | element_text   |
|:------|:---------------|
| nor   |                |
| mid   |                |
| sou   |                |
| wes   |                |


#### National

| uni   | element_text   |
|:------|:---------------|
| usa   |                |


### Goods and sectors from BEA -- Margin related sectors

1. [windc](#windc-aggregationWiNDC-Aggregation)
2. [gtap_32](#gtap_32-aggregation)
3. [gtap_10](#gtap-10-aggregation)
4. [macro](#macro)


#### WiNDC Aggregation

| s     | gm   | Description                                                                           |
|:------|:-----:|:--------------------------------------------------------------------------------------|
| agr   | agr  | Farms (111-112)                                                                       |
| fof   | fof  | Forestry, fishing, and related activities (113-115)                                   |
| oil   | oil  | Oil and gas extraction (211)                                                          |
| min   | min  | Mining, except oil and gas (212)                                                      |
| smn   | -    | Support activities for mining (213)                                                   |
| uti   | -    | Utilities (22)                                                                        |
| con   | -    | Construction (23)                                                                     |
| wpd   | wpd  | Wood products manufacturing (321)                                                     |
| nmp   | nmp  | Nonmetallic mineral products manufacturing (327)                                      |
| pmt   | pmt  | Primary metals manufacturing (331)                                                    |
| fmt   | fmt  | Fabricated metal products (332)                                                       |
| mch   | mch  | Machinery manufacturing (333)                                                         |
| cep   | cep  | Computer and electronic products manufacturing (334)                                  |
| eec   | eec  | Electrical equipment, appliance, and components manufacturing (335)                   |
| mot   | mot  | Motor vehicles, bodies and trailers, and parts manufacturing (3361-3363)              |
| ote   | ote  | Other transportation equipment manufacturing (3364-3366, 3369)                        |
| fpd   | fpd  | Furniture and related products manufacturing (337)                                    |
| mmf   | mmf  | Miscellaneous manufacturing (339)                                                     |
| fbp   | fbp  | Food and beverage and tobacco products manufacturing (311-312)                        |
| tex   | tex  | Textile mills and textile product mills (313-314)                                     |
| alt   | alt  | Apparel and leather and allied products manufacturing (315-316)                       |
| ppd   | ppd  | Paper products manufacturing (322)                                                    |
| pri   | pri  | Printing and related support activities (323)                                         |
| pet   | pet  | Petroleum and coal products manufacturing (324)                                       |
| che   | che  | Chemical products manufacturing (325)                                                 |
| pla   | pla  | Plastics and rubber products manufacturing (326)                                      |
| wht   | wht  | Wholesale trade (42)                                                                  |
| mvt   | mvt  | Motor vehicle and parts dealers (441)                                                 |
| fbt   | fbt  | Food and beverage stores (445)                                                        |
| gmt   | gmt  | General merchandise stores (452)                                                      |
| ott   | ott  | Other retail (4A0)                                                                    |
| air   | air  | Air transportation (481)                                                              |
| trn   | trn  | Rail transportation (482)                                                             |
| wtt   | wtt  | Water transportation (483)                                                            |
| trk   | trk  | Truck transportation (484)                                                            |
| grd   | -    | Transit and ground passenger transportation (485)                                     |
| pip   | pip  | Pipeline transportation (486)                                                         |
| otr   | otr  | Other transportation and support activities (487-488, 492)                            |
| wrh   | -    | Warehousing and storage (493)                                                         |
| pub   | pub  | Publishing industries, except Internet (includes software) (511)                      |
| mov   | mov  | Motion picture and sound recording industries (512)                                   |
| brd   | -    | Broadcasting and telecommunications (515, 517)                                        |
| dat   | -    | Data processing, internet publishing, and other information services (518, 519)       |
| bnk   | -    | Federal Reserve banks, credit intermediation, and related services (521-522)          |
| sec   | -    | Securities, commodity contracts, and investments (523)                                |
| ins   | -    | Insurance carriers and related activities (524)                                       |
| fin   | -    | Funds, trusts, and other financial vehicles (525)                                     |
| hou   | -    | Housing (HS)                                                                          |
| ore   | -    | Other real estate (ORE)                                                               |
| rnt   | -    | Rental and leasing services and lessors of intangible assets (532-533)                |
| leg   | -    | Legal services (5411)                                                                 |
| com   | -    | Computer systems design and related services (5415)                                   |
| tsv   | -    | Miscellaneous professional, scientific, and technical services (5412-5414, 5416-5419) |
| man   | -    | Management of companies and enterprises (55)                                          |
| adm   | -    | Administrative and support services (561)                                             |
| wst   | -    | Waste management and remediation services (562)                                       |
| edu   | -    | Educational services (61)                                                             |
| amb   | -    | Ambulatory health care services (621)                                                 |
| hos   | -    | Hospitals (622)                                                                       |
| nrs   | -    | Nursing and residential care facilities (623)                                         |
| soc   | -    | Social assistance (624)                                                               |
| art   | -    | Performing arts, spectator sports, museums, and related activities (711-712)          |
| rec   | -    | Amusements, gambling, and recreation industries (713)                                 |
| amd   | -    | Accommodation (721)                                                                   |
| res   | -    | Food services and drinking places (722)                                               |
| osv   | -    | Other services, except government (81)                                                |
| nan   | -    | nan                                                                                   |
| fdd   | -    | Federal general government (defense) (GFGD)                                           |
| fnd   | -    | Federal general government (nondefense) (GFGN)                                        |
| fen   | -    | Federal government enterprises (GFE)                                                  |
| slg   | -    | State and local general government (GSLG)                                             |
| sle   | -    | State and local government enterprises (GSLE)                                         |


#### GTAP_32 Aggregation

| s   | gm   | Description                                       |
|:----|:-----|:--------------------------------------------------|
| agr | agr  | Farms and farm products (111CA)                   |
| fof | fof  | Forestry and fishing                              |
| oil | oil  | Petroleum, coal products                          |
| uti | - | Utilities (electricity-gas-water)                 |
| pmt | pmt  | Primary metals (331)                              |
| fbp | fbp  | Food and beverage and tobacco products (311FT)    |
| tex | tex  | Textiles                                          |
| alt | alt  | Apparel and leather and allied products (315AL)   |
| trd | trd  | Trade                                             |
| oxt | oxt  | Coal, minining and supporting activities          |
| ros | - | Recreational and other services                   |
| dwe | - | Dwellings and real estate activities              |
| LUM | LUM  | Lumber and wood products                          |
| NMM | NMM  | Mineral products nec                              |
| FMP | FMP  | Metal products                                    |
| MVH | MVH  | Motor vehicles and parts                          |
| OTN | OTN  | Transport equipment nec                           |
| OME | OME  | Machinery and equipment nec                       |
| CNS | - | Construction                                      |
| WTP | WTP  | Water transport                                   |
| ATP | ATP  | Air transport                                     |
| ISR | - | Insurance                                         |
| OGS | OGS  | Crude oil and natural gas                         |
| PPP | PPP  | Paper products, publishing                        |
| CRP | CRP  | Chemical, rubber, plastic products                |
| EEQ | EEQ  | Electronic equipment                              |
| OMF | OMF  | Manufactures nec                                  |
| OTP | OTP  | Transport nec                                     |
| CMN | CMN  | Communication                                     |
| OFI | - | Financial services nec                            |
| OBS | - | Business services nec                             |
| OSG | - | Public Administration, Defense, Education, Health |


#### GTAP 10 Aggregation

| s   | gm   | Description                                                                   |
|:----|:-----|:------------------------------------------------------------------------------|
| agr | agr  | Agriculture forestry and fishing                                              |
| man | man  | Other manufacturing sectors                                                   |
| oil | oil  | Petroleum products                                                            |
| trn | trn  | Transportation                                                                |
| ele | nan  | Electric power generation, transmission, and distribution and other utilities |
| ogs | ogs  | Crude oil and natural gas extraction                                          |
| col | col  | All mining                                                                    |
| eis | eis  | Energy/Emission intensive sectors (embodied carbon > .5 kg per $)             |
| cns | nan  | Construction                                                                  |
| ser | ser  | Other services         


#### Macro

| s   | gm   | Description    |
|:----|:-----|:---------------|
| con | nan  | Construction   |
| agr | agr  | Agriculture    |
| trn | trn  | Transportation |
| mfr | mfr  | Manufacturing  |
| ser | ser  | Services       |                                                       |


### Margins (trade or transport)

| m   | Description   |
|:----|:--------------|
| trn | transport     |
| trd | trade         |

### Household Categories

Based on income thresholds. 

| h   | Description   |
|:----|:--------------|
| hh1 |   <$25k            |
| hh2 |   $25k - $50k            |
| hh3 |   $50k - $75k            |
| hh4 |   $75k - $150k            |
| hh5 |   >$150k            |

### Transfer Types

| trn      | Description                  |
|:---------|:-----------------------------|
| hucval   | unemployment compensation    |
| hwcval   | workers compensation         |
| hssval   | social security              |
| hssival  | supplemental security        |
| hpawval  | public assistance or welfare |
| hvetval  | veterans benefits            |
| hsurval  | survivors income             |
| hdisval  | disability                   |
| hedval   | educational assistance       |
| hcspval  | child support                |
| hfinval  | financial assistance         |
| medicare |                              |
| medicaid |                              |
