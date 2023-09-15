

# Sets

| Set Name | Description                  |
|:---------|:-----------------------------|
| [r](#states)        | States                       |
| [s](#goods-and-sectors-from-bea)        | Goods and sectors from BEA   |
| [gm](#margin-related-sectors)       | Margin related sectors       |
| [m](#margins-trade-or-transport)        | Margins (trade or transport) |
| [h](#household-categories)        | household categories         |
| [trn](#transfer-types)      | transfer types               |


# Parameters

| Set Name | Domain  | Description                                    |
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
| hhtrn0   | r, h, * | Disaggregate transfer payments                 |
| pop0     | r, h    | Population (households or returns in millions) |


# Set Listing

## States

| r   | Description          |
|:----|:---------------------|
| AL  | Alabama              |
| AK  | Alaska               |
| AR  | Arizona              |
| AZ  | Arkansas             |
| CA  | California           |
| CO  | Colorado             |
| CT  | Connecticut          |
| DE  | Delaware             |
| DC  | District of Columbia |
| FL  | Florida              |
| GA  | Georgia              |
| HI  | Hawaii               |
| ID  | Idaho                |
| IL  | Illinois             |
| IN  | Indiana              |
| IA  | Iowa                 |
| KS  | Kansas               |
| KY  | Kentucky             |
| LA  | Louisiana            |
| ME  | Maine                |
| MD  | Maryland             |
| MA  | Massachusetts        |
| MI  | Michigan             |
| MN  | Minnesota            |
| MS  | Mississippi          |
| MO  | Missouri             |
| MT  | Montana              |
| NE  | Nebraska             |
| NV  | Nevada               |
| NH  | New Hampshire        |
| NJ  | New Jersey           |
| NM  | New Mexico           |
| NY  | New York             |
| NC  | North Carolina       |
| ND  | North Dakota         |
| OH  | Ohio                 |
| OK  | Oklahoma             |
| OR  | Oregon               |
| PA  | Pennsylvania         |
| RI  | Rhode Island         |
| SC  | South Carolina       |
| SD  | South Dakota         |
| TN  | Tennessee            |
| TX  | Texas                |
| UT  | Utah                 |
| VT  | Vermont              |
| VA  | Virginia             |
| WA  | Washington           |
| WV  | West Virginia        |
| WI  | Wisconsin            |
| WY  | Wyoming              |

## Goods and sectors from BEA

| s   | Description                                                                           |
|:----|:--------------------------------------------------------------------------------------|
| ppd | Paper products manufacturing (322)                                                    |
| res | Food services and drinking places (722)                                               |
| com | Computer systems design and related services (5415)                                   |
| amb | Ambulatory health care services (621)                                                 |
| fbp | Food and beverage and tobacco products manufacturing (311-312)                        |
| rec | Amusements, gambling, and recreation industries (713)                                 |
| con | Construction (23)                                                                     |
| agr | Farms (111-112)                                                                       |
| eec | Electrical equipment, appliance, and components manufacturing (335)                   |
| fnd | Federal general government (nondefense) (GFGN)                                        |
| pub | Publishing industries, except Internet (includes software) (511)                      |
| hou | Housing (HS)                                                                          |
| fbt | Food and beverage stores (445)                                                        |
| ins | Insurance carriers and related activities (524)                                       |
| tex | Textile mills and textile product mills (313-314)                                     |
| leg | Legal services (5411)                                                                 |
| fen | Federal government enterprises (GFE)                                                  |
| uti | Utilities (22)                                                                        |
| nmp | Nonmetallic mineral products manufacturing (327)                                      |
| brd | Broadcasting and telecommunications (515, 517)                                        |
| bnk | Federal Reserve banks, credit intermediation, and related services (521-522)          |
| ore | Other real estate (ORE)                                                               |
| edu | Educational services (61)                                                             |
| ote | Other transportation equipment manufacturing (3364-3366, 3369)                        |
| man | Management of companies and enterprises (55)                                          |
| mch | Machinery manufacturing (333)                                                         |
| dat | Data processing, internet publishing, and other information services (518, 519)       |
| amd | Accommodation (721)                                                                   |
| oil | Oil and gas extraction (211)                                                          |
| hos | Hospitals (622)                                                                       |
| rnt | Rental and leasing services and lessors of intangible assets (532-533)                |
| pla | Plastics and rubber products manufacturing (326)                                      |
| fof | Forestry, fishing, and related activities (113-115)                                   |
| fin | Funds, trusts, and other financial vehicles (525)                                     |
| tsv | Miscellaneous professional, scientific, and technical services (5412-5414, 5416-5419) |
| nrs | Nursing and residential care facilities (623)                                         |
| sec | Securities, commodity contracts, and investments (523)                                |
| art | Performing arts, spectator sports, museums, and related activities (711-712)          |
| mov | Motion picture and sound recording industries (512)                                   |
| fpd | Furniture and related products manufacturing (337)                                    |
| slg | State and local general government (GSLG)                                             |
| pri | Printing and related support activities (323)                                         |
| grd | Transit and ground passenger transportation (485)                                     |
| pip | Pipeline transportation (486)                                                         |
| sle | State and local government enterprises (GSLE)                                         |
| osv | Other services, except government (81)                                                |
| trn | Rail transportation (482)                                                             |
| smn | Support activities for mining (213)                                                   |
| fmt | Fabricated metal products (332)                                                       |
| pet | Petroleum and coal products manufacturing (324)                                       |
| mvt | Motor vehicle and parts dealers (441)                                                 |
| cep | Computer and electronic products manufacturing (334)                                  |
| wst | Waste management and remediation services (562)                                       |
| mot | Motor vehicles, bodies and trailers, and parts manufacturing (3361-3363)              |
| adm | Administrative and support services (561)                                             |
| soc | Social assistance (624)                                                               |
| alt | Apparel and leather and allied products manufacturing (315-316)                       |
| pmt | Primary metals manufacturing (331)                                                    |
| trk | Truck transportation (484)                                                            |
| fdd | Federal general government (defense) (GFGD)                                           |
| gmt | General merchandise stores (452)                                                      |
| wtt | Water transportation (483)                                                            |
| wpd | Wood products manufacturing (321)                                                     |
| wht | Wholesale trade (42)                                                                  |
| wrh | Warehousing and storage (493)                                                         |
| ott | Other retail (4A0)                                                                    |
| che | Chemical products manufacturing (325)                                                 |
| air | Air transportation (481)                                                              |
| mmf | Miscellaneous manufacturing (339)                                                     |
| otr | Other transportation and support activities (487-488, 492)                            |
| min | Mining, except oil and gas (212)                                                      |

## Margin related sectors

| gm   | Description   |
|:-----|:--------------|
| ppd  |               |
| fbp  |               |
| agr  |               |
| eec  |               |
| pub  |               |
| fbt  |               |
| tex  |               |
| nmp  |               |
| ote  |               |
| mch  |               |
| oil  |               |
| pla  |               |
| fof  |               |
| mov  |               |
| fpd  |               |
| pri  |               |
| pip  |               |
| trn  |               |
| fmt  |               |
| pet  |               |
| mvt  |               |
| cep  |               |
| mot  |               |
| alt  |               |
| pmt  |               |
| trk  |               |
| gmt  |               |
| wtt  |               |
| wpd  |               |
| wht  |               |
| ott  |               |
| che  |               |
| air  |               |
| mmf  |               |
| otr  |               |
| min  |               |

## Margins (trade or transport)

| m   | Description   |
|:----|:--------------|
| trn | transport     |
| trd | trade         |

## household categories

| h   | Description   |
|:----|:--------------|
| hh1 |               |
| hh2 |               |
| hh3 |               |
| hh4 |               |
| hh5 |               |

## transfer types

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

