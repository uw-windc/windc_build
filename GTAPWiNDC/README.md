- [File Listing](#file-listing)
- [GTAPWiNDC Set Listing](#gtapwindc-set-listing)
    - [Sets](#sets)
    - [Parameters](#parameters)
    - [Set Listing](#set-listing)
        - [Regions countries](#regions-countries)
        - [Sectors](#sectors)
        - [Commodities](#commodities)
        - [Factors of production](#factors-of-production)
        - [Subregions in the model](#subregions-in-the-model)
<!-- TOC -->

- [File Listing](#file-listing)
- [GTAPWiNDC Sets](#gtapwindc-sets)
    - [Sets - GTAPWiNDC](#sets---gtapwindc)
    - [Parameters - GTAPWiNDC](#parameters---gtapwindc)
    - [GTAPWiNDC Set Listing](#gtapwindc-set-listing)
        - [Regions countries](#regions-countries)
        - [Sectors](#sectors)
        - [Commodities](#commodities)
        - [Factors of production](#factors-of-production)
        - [Subregions in the model](#subregions-in-the-model)
        - [Households in the model](#households-in-the-model)
- [WiNDC Sets](#windc-sets)
    - [Sets - WiNDC](#sets---windc)
    - [Parameters - WiNDC](#parameters---windc)
        - [Parameters in both 32 and 43](#parameters-in-both-32-and-43)
        - [Parameters only in 32](#parameters-only-in-32)
    - [Set Listing - WiNDC](#set-listing---windc)
        - [States](#states)
        - [Goods and sectors from BEA](#goods-and-sectors-from-bea)
        - [Margins trade or transport](#margins-trade-or-transport)
        - [Household categories](#household-categories)
        - [Transfer types](#transfer-types)

<!-- /TOC -->


# File Listing

1. `gtapingams.gms` - This file needs to be user modified. This controls which version of GTAP to use and where the datafile is located. Explicit directions are located in this file. 


2. `build.gms` - Builds GTAP and GTAPWiNDC datasets.


    Command line options:
    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| year | gtap11/a: 2017, 2014, 2011 gtap9: 2011 | 2017 | The year to run |



3. `gtap_model.gms` - Replicates the benchmark equilibrium for the input GTAP model.

4. `write_stub.gms` - Read the GTAP dataset (20_43), add array dimensions for households (h) and subregions (s). The GTAP data is loaded for household and subregion "rest".

5. `gtapwindc_data.gms`, `gtapwindc_mge.gms`, `gtapwindc_mcp.gms` - Scripts which replicate the benchmark equilibrium for the
output GTAP_WiNDC model (GAMS/MCP and GAMS/MPSGE)

6. `windc_data.gms` - Loads the WiNDC household data

7. `windc_model.gms` - Replicates the benchmark equilibrium for the WiNDC household model.

8. `agrdisagg.gms` - We construct the disaggregate dataset in two steps. The first of these concerns only the 50 state / 250 household WiNDC model. We use state shares of agricultural receipts to disaggregate the AGR into 11 separate agricultural sectors

	The original WiNDC dataset has but one agricultural sector:

		agr  Farms and farm products (111CA)

	In this step `agr` is disaggregated into 11
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



9. `regiondisagg.gms` - Now that we have constructed a state-level national model for the US, we use these data to disaggregate states and households in the corresponding 43 sector GTAP model


# GTAPWiNDC Sets

## Sets - GTAPWiNDC

 | Set Name | Description                  |
|:---------:|:-----------------------------|
|[r](#regions-(countries))|Regions (countries)|
|[g](#sectors)|Sectors|
|[i](#commodities)|Commodities|
|[f](#factors-of-production)|Factors of production|
|[s](#subregions-in-the-model)|Subregions in the model|
|[h](#households-in-the-model)|Households in the model|
|[sf](#factors-of-production)|Specific factors|
|[mf](#factors-of-production)|Mobile factors|


## Parameters - GTAPWiNDC

|Parameter Name | Domain | Description |
|:---------|:--------|:-----------------------------------------------|
|vom|g, r, s|Total supply at market prices|
|vafm|i, g, r, s|Intermediate demand at market prices|
|vfm|f, g, r, s|Factor demand at market prices|
|yl0|i, r, s|Local supply|
|a0|i, r, s|Absorption|
|md0|i, r, s|Import absorption|
|xs0|i, r, s|Export market supply|
|nd0|i, r, s|National market domestic absorption|
|ns0|i, r, s|National market supply|
|c0|r, s, h|Total household consumption|
|cd0|i, r, s, h|Household consumption at market prices|
|evom|f, r, s|Primary factor supply|
|evomh|f, r, s, h|Household primary factor endowment|
|rtd|i, r, s|Tax rate on domestic demand|
|rtd0|i, r, s|Benchmark tax rate on domestic demand|
|rtm|i, r, s|Tax rate on import demand|
|rtm0|i, r, s|Benchmark tax rate on import demand|
|esube|g|Energy demand elasticity|
|etrndn|i|Elasticity of transformation -- local goods supply|
|hhtrn0|r, s, h, trn|Household transfers|
|sav0|r, s, h|Household saving|
|rto|g, r|Output (or income) subsidy rates|
|rtf|f, g, r|Primary factor tax rate|
|rtf0|f, g, r|Benchmark primary factor tax rate|
|vim|i, r|Aggregate imports at market prices|
|vxmd|i, r, rr|Trade - bilateral exports at market prices|
|pvxmd|i, rr, r|Import price (power of benchmark tariff)|
|pvtwr|i, rr, r|Import price for transport services (power of tariff)|
|rtxs|i, rr, r|Export subsidy rates|
|rtms|i, rr, r|Import taxes rates|
|vtw|j|Aggregate international transportation services|
|vtwr|j, i, rr, r|Trade margins on international transport|
|vst|j, r|Trade - exports for international transportation|
|vb|r|Current account balance|
|esubva|g|Elasticity of substitution between factors|
|etrae|f|Elasticity of transformation -- sluggish factors|
|esubdm|i|Elasticity of substitution (M versus D)|
|esubm|i|Intra-import elasticity of substitution|


## GTAPWiNDC Set Listing

### Regions (countries)

| r   | Description                                              |
|:----|:---------------------------------------------------------|
| CHN | China and Hong Kong                                      |
| JPN | Japan                                                    |
| KOR | Korea                                                    |
| IDN | Indonesia                                                |
| IND | India                                                    |
| CAN | Canada                                                   |
| USA | United States                                            |
| MEX | Mexico                                                   |
| ARG | Argentina                                                |
| BRA | Brazil                                                   |
| FRA | France                                                   |
| DEU | Germany                                                  |
| ITA | Italy                                                    |
| GBR | United Kingdom                                           |
| RUS | Russia                                                   |
| SAU | Saudi Arabia                                             |
| TUR | Turkey                                                   |
| ZAF | South Africa                                             |
| ANZ | Australia and New Zealand                                |
| REU | Rest of European Union (excluding FRA - DEU - GBR - ITA) |
| OEX | Other oil exporters                                      |
| LIC | Other low-income countries                               |
| MIC | Other middle-income countries                            |


### Sectors

The GTAPWiNDC provides two aggregations, one with 43 commodities, and one with 32.
This table shows both. 


| g (43)   | g (32)   | Description                                       |
|:---------|:---------|:--------------------------------------------------|
| i        | i        | Investment                                        |
| g        | g        | Public expenditure                                |
| pdr      | -        | Paddy rice                                        |
| wht      | -        | Wheat                                             |
| gro      | -        | Cereal grains nec                                 |
| v_f      | -        | Vegetables, fruit, nuts                           |
| osd      | -        | Oil seeds                                         |
| c_b      | -        | Sugar cane, sugar beet                            |
| pfb      | -        | Plant-based fibers                                |
| ocr      | -        | Crops nec                                         |
| ctl      | -        | Bovine cattle, sheep, goats and horses            |
| oap      | -        | Animal products nec                               |
| rmk      | -        | Raw milk                                          |
| wol      | -        | Wool, silk-worm cocoons                           |
| oxt      | oxt      | Coal, minining and supporting activities          |
| tex      | tex      | Textiles                                          |
| lum      | lum      | Lumber and wood products                          |
| ppp      | ppp      | Paper products, publishing                        |
| oil      | oil      | Petroleum, coal products                          |
| nmm      | nmm      | Mineral products nec                              |
| fmp      | fmp      | Metal products                                    |
| eeq      | eeq      | Electronic equipment                              |
| ome      | ome      | Machinery and equipment nec                       |
| mvh      | mvh      | Motor vehicles and parts                          |
| otn      | otn      | Transport equipment nec                           |
| omf      | omf      | Manufactures nec                                  |
| cns      | cns      | Construction                                      |
| trd      | trd      | Trade                                             |
| otp      | otp      | Transport nec                                     |
| wtp      | wtp      | Water transport                                   |
| atp      | atp      | Air transport                                     |
| cmn      | cmn      | Communication                                     |
| ofi      | ofi      | Financial services nec                            |
| obs      | obs      | Business services nec                             |
| ros      | ros      | Recreational and other services                   |
| osg      | osg      | Public Administration, Defense, Education, Health |
| dwe      | dwe      | Dwellings and real estate activities              |
| ISR      | ISR      | Insurance                                         |
| fof      | fof      | Forestry and fishing                              |
| fbp      | fbp      | Food and beverage and tobacco products (311FT)    |
| alt      | alt      | Apparel and leather and allied products (315AL)   |
| pmt      | pmt      | Primary metals (331)                              |
| ogs      | ogs      | Crude oil and natural gas                         |
| uti      | uti      | Utilities (electricity-gas-water)                 |
| CRP      | CRP      | Chemical, rubber, plastic products                |


### Commodities

The GTAPWiNDC provides two aggregations, one with 43 commodities, and one with 32.
This table shows both.

| i (43)   | i (32)   | Description                                       |
|:---------|:---------|:--------------------------------------------------|
| pdr      | -        | Paddy rice                                        |
| wht      | -        | Wheat                                             |
| gro      | -        | Cereal grains nec                                 |
| v_f      | -        | Vegetables, fruit, nuts                           |
| osd      | -        | Oil seeds                                         |
| c_b      | -        | Sugar cane, sugar beet                            |
| pfb      | -        | Plant-based fibers                                |
| ocr      | -        | Crops nec                                         |
| ctl      | -        | Bovine cattle, sheep, goats and horses            |
| oap      | -        | Animal products nec                               |
| rmk      | -        | Raw milk                                          |
| wol      | -        | Wool, silk-worm cocoons                           |
| oxt      | oxt      | Coal, minining and supporting activities          |
| tex      | tex      | Textiles                                          |
| lum      | lum      | Lumber and wood products                          |
| ppp      | ppp      | Paper products, publishing                        |
| oil      | oil      | Petroleum, coal products                          |
| nmm      | nmm      | Mineral products nec                              |
| fmp      | fmp      | Metal products                                    |
| eeq      | eeq      | Electronic equipment                              |
| ome      | ome      | Machinery and equipment nec                       |
| mvh      | mvh      | Motor vehicles and parts                          |
| otn      | otn      | Transport equipment nec                           |
| omf      | omf      | Manufactures nec                                  |
| cns      | cns      | Construction                                      |
| trd      | trd      | Trade                                             |
| otp      | otp      | Transport nec                                     |
| wtp      | wtp      | Water transport                                   |
| atp      | atp      | Air transport                                     |
| cmn      | cmn      | Communication                                     |
| ofi      | ofi      | Financial services nec                            |
| obs      | obs      | Business services nec                             |
| ros      | ros      | Recreational and other services                   |
| osg      | osg      | Public Administration, Defense, Education, Health |
| dwe      | dwe      | Dwellings and real estate activities              |
| ISR      | ISR      | Insurance                                         |
| fof      | fof      | Forestry and fishing                              |
| fbp      | fbp      | Food and beverage and tobacco products (311FT)    |
| alt      | alt      | Apparel and leather and allied products (315AL)   |
| pmt      | pmt      | Primary metals (331)                              |
| ogs      | ogs      | Crude oil and natural gas                         |
| uti      | uti      | Utilities (electricity-gas-water)                 |
| CRP      | CRP      | Chemical, rubber, plastic products                |




### Factors of production

| f   | sf   | mf   | Description                                                  |
|:----|:-----|:-----|:-------------------------------------------------------------|
| mgr | -    | mgr  | Officials and Mangers legislators (ISCO-88 Major Groups 1-2) |
| tec | -    | tec  | Technicians technicians and associate professionals          |
| clk | -    | clk  | Clerks                                                       |
| srv | -    | srv  | Service and market sales workers                             |
| lab | -    | lab  | Agricultural and unskilled workers (Major Groups 6-9)        |
| cap | cap  | -    | Capital                                                      |
| lnd | lnd  | -    | Land                                                         |
| res | res  | -    | Natural resources                                            |

### Subregions in the model

| s    | Description          | | s    | Description          |
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
|MS|Mississippi||rest||


### Households in the model

| h    | Description   |
|:-----|:--------------|
| hh1  |               |
| hh2  |               |
| hh3  |               |
| hh4  |               |
| hh5  |               |
| rest |               |



# WiNDC Sets

## Sets - WiNDC

 | Set Name | Description                  |
|:---------:|:-----------------------------|
|[r, q](#states)|States|
|[s, g](#goods-and-sectors-from-bea)|Goods and sectors from BEA|
|[gm](#goods-and-sectors-from-bea)|Margin related sectors|
|[m](#margins-(trade-or-transport))|Margins (trade or transport)|
|[h](#household-categories)|Household categories|
|[trn](#transfer-types)|Transfer types|

## Parameters - WiNDC

### Parameters in both 32 and 43

|Parameter Name | Domain | Description |
|:---------|:--------|:-----------------------------------------------|
|ys0|r, s, g|Sectoral supply|
|id0|r, g, s|Intermediate demand|
|ld0|r, s|Labor demand|
|kd0|r, s|Capital demand|
|ty0|r, s|Output tax on production|
|yh0|r, s|Household production|
|cd0|r, s|Final demand|
|c0_h|r, h|Aggregate household level expenditures|
|cd0_h|r, g, h|Household level expenditures|
|c0|r|Aggregate final demand|
|i0|r, s|Investment demand|
|g0|r, s|Government demand|
|bopdef0|r|Balance of payments|
|s0|r, s|Aggregate supply|
|xd0|r, g|Regional supply to local market|
|xn0|r, g|Regional supply to national market|
|x0|r, s|Exports of goods and services|
|rx0|r, s|Re-exports of goods and services|
|a0|r, s|Armington supply|
|nd0|r, g|Regional demand from national market|
|dd0|r, g|Regional demand from local  market|
|m0|r, s|Imports|
|ta0|r, s|Tax net subsidy rate on intermediate demand|
|tm0|r, s|Import tariff|
|md0|r, m, s|Total margin demand|
|nm0|r, g, m|Margin demand from national market|
|dm0|r, g, m|Margin supply from local market|
|le0|r, q, h|Household labor endowment|
|ke0|r, h|Household interest payments|
|tk0|r|Capital tax rate|
|tl0|r, h|Household marginal labor tax rate|
|sav0|r, h|Household saving|
|hhtrn0|r, h, trn|Disaggregate transfer payments|
|pop0|r, h|Population (households or returns in millions)|


### Parameters only in 32

|Parameter Name | Domain | Description |
|:---------|:--------|:-----------------------------------------------|
|hhadj0|r|Household adjustment|
|tl_avg0|r, h|Household average labor tax rate|
|tfica0|r, h|Household FICA labor tax rate|
|fsav0||Foreign savings|
|fint0||Foreign interest payments|
|govdef0||Government deficit|
|taxrevL|r|Tax revenue|
|taxrevK||Capital tax revenue|
|totsav0||Aggregate savings|
|trn0|r, h|Household transfer payments|
|ty|r, s|Counterfactual production tax|
|tm|r, g|Counterfactual import tariff|
|ta|r, g|Counteractual tax on intermediate demand|
|lse_inc||Labor supply income elasticity|
|lse_sub||Labor supply substitution elasticity|
|lsr0|r, h|Leisure demand|
|ls0|r, h|Labor supply (net)|
|esubL|r, h|Leisure-consumption elasticity|
|etaK||Capital transformation elasticity|
|tk|r, s|Counterfactual capital taxes|
|tfica|r, h|Counterfactual FICA labor taxes|
|tl|r, h|Counterfactual marginal labor taxes|
|MPSEPS|||
|MPSREPORT|||

## Set Listing - WiNDC

### States

In the 32 aggregation, `q` is an alias of `r`

| r    | Description          | | r    | Description          |
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

### Goods and sectors from BEA

| s (43)   | gm (43)  | s, g (32)  | gm (32)  | Description                                       |
|:-------|:-----|:-------|:-----|:--------------------------------------------------|
| fbp    | fbp  | fbp    | fbp  | Food and beverage and tobacco products (311FT)    |
| -      | -    | agr    | agr  | Farms and farm products (111CA)                   |
| tex    | tex  | tex    | tex  | Textiles                                          |
| uti    | -    | uti    | -    | Utilities (electricity-gas-water)                 |
| oil    | oil  | oil    | oil  | Petroleum, coal products                          |
| fof    | fof  | fof    | fof  | Forestry and fishing                              |
| alt    | alt  | alt    | alt  | Apparel and leather and allied products (315AL)   |
| pmt    | pmt  | pmt    | pmt  | Primary metals (331)                              |
| trd    | trd  | trd    | trd  | Trade                                             |
| oxt    | oxt  | oxt    | oxt  | Coal, minining and supporting activities          |
| ros    | -    | ros    | -    | Recreational and other services                   |
| dwe    | -    | dwe    | -    | Dwellings and real estate activities              |
| LUM    | LUM  | LUM    | LUM  | Lumber and wood products                          |
| NMM    | NMM  | NMM    | NMM  | Mineral products nec                              |
| FMP    | FMP  | FMP    | FMP  | Metal products                                    |
| MVH    | MVH  | MVH    | MVH  | Motor vehicles and parts                          |
| OTN    | OTN  | OTN    | OTN  | Transport equipment nec                           |
| OME    | OME  | OME    | OME  | Machinery and equipment nec                       |
| CNS    | -    | CNS    | -    | Construction                                      |
| WTP    | WTP  | WTP    | WTP  | Water transport                                   |
| ATP    | ATP  | ATP    | ATP  | Air transport                                     |
| ISR    | -    | ISR    | -    | Insurance                                         |
| OGS    | OGS  | OGS    | OGS  | Crude oil and natural gas                         |
| PPP    | PPP  | PPP    | PPP  | Paper products, publishing                        |
| CRP    | CRP  | CRP    | CRP  | Chemical, rubber, plastic products                |
| EEQ    | EEQ  | EEQ    | EEQ  | Electronic equipment                              |
| OMF    | OMF  | OMF    | OMF  | Manufactures nec                                  |
| OTP    | OTP  | OTP    | OTP  | Transport nec                                     |
| CMN    | CMN  | CMN    | CMN  | Communication                                     |
| OFI    | -    | OFI    | -    | Financial services nec                            |
| OBS    | -    | OBS    | -    | Business services nec                             |
| OSG    | -    | OSG    | -    | Public Administration, Defense, Education, Health |
| pdr | -  |-|-  | Paddy rice                                        |
| wht | -  |-|-  | Wheat                                             |
| gro | -  |-|-  | Cereal grains nec                                 |
| v_f | -   |-|- | Vegetables, fruit, nuts                           |
| osd | -   |-|- | Oil seeds                                         |
| c_b | -   |-|- | Sugar cane, sugar beet                            |
| pfb | -   |-|- | Plant-based fibers                                |
| ocr | -   |-|- | Crops nec                                         |
| ctl | -   |-|- | Bovine cattle, sheep, goats and horses            |
| oap | -   |-|- | Animal products nec                               |
| rmk | -   |-|- | Raw milk                                          |
| wol | -   |-|- | Wool, silk-worm cocoons  |






### Margins (trade or transport)

| m   | Description      |
|:----|:-----------------|
| trd | Retail margin    |
| trn | Transport margin |

### Household categories

| h   | Description   |
|:----|:--------------|
| hh1 |               |
| hh2 |               |
| hh3 |               |
| hh4 |               |
| hh5 |               |

### Transfer types

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