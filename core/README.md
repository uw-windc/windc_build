<!-- TOC -->

- [Table of Contents](#table-of-contents)
- [File Listing](#file-listing)
- [Sets](#sets)
- [Parameters](#parameters)
- [Set Listing](#set-listing)
    - [Years in WiNDC Database](#years-in-windc-database)
    - [Regions in WiNDC Database](#regions-in-windc-database)
    - [BEA Goods and sectors categories & Commodities employed in margin supply](#bea-goods-and-sectors-categories--commodities-employed-in-margin-supply)
    - [Margins trade or transport](#margins-trade-or-transport)

<!-- /TOC -->

# File Listing

1. `build.gms` - Entry point into the WiNDC core buildstream. Will run each of the files in order to build the WiNDC dataset. Standard usage is to run this file.

    Inputs: `data/core`

    Outputs: `WiNDCdatabase.gdx`

    Command line options:
    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
    | neos  | no, yes | no | Use neos for calibration rather than local solvers|
    | huber | no, yes | no | Run huber calibration routine |
2. `partitionbea.gms` - Load and partition BEA Use/Supply tables.

    Inputs: `/data/core/windc_base.gdx`

    Outputs: `gdx/national_cgeparm_raw.gdx`

3. `calibrate.gms` - Calibrate BEA data.

    Inputs: `/data/core/windc_base.gdx`

    Outputs: `gdx/nationaldata_%matbal%.gdx`

    Command line options:
    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
    | matbal | ls, huber | ls | Set optimization routine for matrix balancing: least squares (ls) or huber (huber)|
    | neos | no, yes| no |Use neos for calibration rather than local solvers|


4. `nationalmodel.gms` - Run a model calibartion check for a single year.

    Inputs: `gdx/nationaldata_%matbal%.gdx`

    Command line options:
    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
    | matbal | ls, huber | ls |Set optimization method used: least squares (ls) or huber (huber)|
    | run | A single year | all years | Set a year to run|

5. `gspshare.gms` - Create two parameters, `region_shr` and `labor_shr` from the BEA GDP by state data.

    Inputs: `/data/core/windc_base.gdx`, `gdx/nationaldata_%matbal%.gdx`

    Outputs: `gdx/shares_gsp.gdx`

    Command line options:
    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
    | matbal | ls, huber | ls |Set optimization method used: least squares (ls) or huber (huber)|

6. `pceshare.gms` - Create the parameter `pce_shr` from the BEA Personal Consumptions Expenditures data.

    Inputs: `/data/core/windc_base.gdx`

    Outputs: `gdx/shares_pce.gdx`

7. `sgfshare.gms` - Create the parameter `sgf_shr` from the Census State Government Finances data

    Inputs: `/data/core/windc_base.gdx`

    Outputs: `gdx/shares_sgf.gdx`

8. `fafshare.gms` - Create the parameter `rpc` from the Freight Analysis Framework data. This replaces the Commodity Flow Survey from previous releases.

    Inputs - `/data/core/windc_base.gdx`, `/data/core/faf_data_1997_2021.csv`

    Outputs - `gdx/faf_rpcs.gdx`
    
9. `usatradeshare.gms` - Create two parameters, `usatrd_shr` and `notinc` from the US Census Trade Shares data.

    Inputs: `/data/core/windc_base.gdx'`

    Outputs: `gdx/shares_usatrd.gdx`

10. `statedisagg.gms` - Disaggregate national accounts to the state level 

    Inputs: 
    * `gdx/nationaldata_%matbal%.gdx`
    * `gdx/shares_gsp.gdx`
    * `gdx/shares_pce.gdx` 
    * `gdx/shares_sgf.gdx` 
    * `gdx/faf_rpcs.gdx`
    * `gdx/shares_usatrd.gdx`

    Outputs: `WiNDCdatabase.gdx`

    Command line options:
    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
    | matbal | ls, huber | ls |Set optimization method used: least squares (ls) or huber (huber)|
    | neos | no, yes| no |Use neos for calibration rather than local solvers|
    | year | a single year | 2017 | Check benchmark consistency in regional model for single year |

11. `windc_coredata.gms` - Loads a single year of data from the state-level dataset. A good example if you are loading the data for another purpose. 

    Inputs: `WiNDCdatabase.gdx`

    Command line options:
    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
    | year | A single year | 2017 | Load a single year of the state-level dataset|

11. `replicate.gms` - Run a model calibration check on the state-level data

    Inputs: `WiNDCdatabase.gdx`

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
    | sequence | mgemcp, mcpmge | mgemcp | Set the solve sequence|

# Sets

<center>

|Set Name|Description|
|---|---|
|[yr](#years-in-windc-database)|Years in WiNDC Database|
|[r](#regions-in-windc-database)|Regions in WiNDC Database|
|[s, g](#bea-goods-and-sectors-categories--commodities-employed-in-margin-supply) |BEA Goods and sectors categories|
|[m](#margins-trade-or-transport)|Margins (trade or transport)|
|[gm](#bea-goods-and-sectors-categories--commodities-employed-in-margin-supply)|Commodities employed in margin supply|

</center>

# Parameters

<center>

|Parameter Name|Domain|Description|
|---|---|---|
|ys0_|yr, r, s, g|Regional sectoral output|
|ld0_|yr, r, s|Labor demand|
|kd0_|yr, r, s|Capital demand|
|id0_|yr, r, g, s|Regional intermediate demand|
|ty0_|yr, r, s|Production tax rate|
|yh0_|yr, r, s|Household production|
|fe0_|yr, r|Total factor supply|
|cd0_|yr, r, s|Consumption demand|
|c0_|yr, r|Total final household consumption|
|i0_|yr, r, s|Investment demand|
|g0_|yr, r, s|Government demand|
|bopdef0_|yr, r|Balance of payments (closure parameter)|
|hhadj0_|yr, r|Household adjustment parameter|
|s0_|yr, r, g|Total supply|
|xd0_|yr, r, g|Regional supply to local market|
|xn0_|yr, r, g|Regional supply to national market|
|x0_|yr, r, g|Foreign Exports|
|rx0_|yr, r, g|Re-exports|
|a0_|yr, r, g|Domestic absorption|
|nd0_|yr, r, g|Regional demand from national marke|
|dd0_|yr, r, g|Regional demand from local market|
|m0_|yr, r, g|Foreign Imports|
|ta0_|yr, r, g|Absorption taxes|
|tm0_|yr, r, g|Import taxes|
|md0_|yr, r, m, g|Margin demand|
|nm0_|yr, r, g, m|Margin demand from the national market|
|dm0_|yr, r, g, m|Margin supply from the local market|
|gdp0_|yr, r|Aggregate GDP|

</center>




# Set Listing

## Years in WiNDC Database
<center>

|yr| |yr|
|---|---|---|
|1997| |2008|
|1998| |2009|
|1999| |2010|
|2000| |2011|
|2001| |2012|
|2002| |2013|
|2003| |2014|
|2004| |2015|
|2005| |2016|
|2006| |2017|
|2007|||

</center>

## Regions in WiNDC Database
<center>

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

</center>

## BEA Goods and sectors categories & Commodities employed in margin supply
<center>

| s, g   | gm   | Description                                                                           |
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

</center>

## Margins (trade or transport)
<center>

| m   | Description   |
|:------|:--------------|
| trn   | transport     |
| trd   | trade         |

</center>
