

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

### household categories

| h   | Description   |
|:----|:--------------|
| hh1 |               |
| hh2 |               |
| hh3 |               |
| hh4 |               |
| hh5 |               |

### transfer types

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
