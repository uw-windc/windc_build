$title	Read the SEDS Dataset (State-Level Electricity Dataset)

$if not exist SEDS.gdx $call gams readbulk --dataset=SEDS

$gdxin 'SEDS.gdx'

set
  t  'date/year' /1960*2023/
  id 'series_id from txt file, explanatory text has name'
  e  'error strings where we have for NA (not available)'
  errors(id,t,e<) 'could not extract a value from these';

parameter
   series(id,t) 'data for each series';

$load id 
$loaddc series errors

option id:0:0:1;
*.display id;

set	item(*)		Items /
		ABICB  Aviation gasoline blending components consumed by the industrial sector
		ABICP  Aviation gasoline blending components consumed by the industrial sector
		ARICB  Asphalt and road oil consumed by the industrial sector
		ARICD  Asphalt and road oil price in the industrial sector
		ARICP  Asphalt and road oil consumed by the industrial sector
		ARICV  Asphalt and road oil expenditures in the industrial sector
		ARTCB  Asphalt and road oil total consumption
		ARTCD  "Asphalt and road oil average price, all sectors"
		ARTCP  Asphalt and road oil total consumption
		ARTCV  Asphalt and road oil total expenditures
		ARTXB  Asphalt and road oil total end-use consumption
		ARTXD  "Asphalt and road oil average price, all end-use sectors"
		ARTXP  Asphalt and road oil total end-use consumption
		ARTXV  Asphalt and road oil total end-use expenditures
		AVACB  Aviation gasoline consumed by the transportation sector
		AVACD  Aviation gasoline price in the transportation sector
		AVACP  Aviation gasoline consumed by the transportation sector
		AVACV  Aviation gasoline expenditures in the transportation sector
		AVTCB  Aviation gasoline total consumption
		AVTCD  "Aviation gasoline average price, all sectors"
		AVTCP  Aviation gasoline total consumption
		AVTCV  Aviation gasoline total expenditures
		AVTXB  Aviation gasoline total end-use consumption
		AVTXD  "Aviation gasoline average price, all end-use sectors"
		AVTXP  Aviation gasoline total end-use consumption
		AVTXV  Aviation gasoline total end-use expenditures
		B1ACB  Renewable diesel consumed by the transportation sector
		B1ACP  Renewable diesel consumed by the transportation sector
		B1PRB  Renewable diesel production
		B1PRP  Renewable diesel production
		B1TCB  Renewable diesel total consumption
		B1TCP  Renewable diesel total consumption
		BDACB  Biodiesel consumed by the transportation sector
		BDACP  Biodiesel consumed by the transportation sector
		BDFDB  "Biodiesel production (total biomass inputs as feedstock), including liquids and losses & co-products"
		BDLCB  Energy losses and co-products from the production of biodiesel
		BDPRP  Biodiesel liquids production
		BDTCB  Biodiesel total consumption
		BDTCP  Biodiesel total consumption
		BFLCB  Energy losses and co-products from the production of biofuels
		BFPRB  "Biofuels production (total biomass inputs as feedstock), including liquids and losses & co-products"
		BFPRP  Biofuels liquid production
		BFSUB  Biofuels product supplied consumed with distillate fuel oil by the transportation sector
		BFTCB  Biofuels total consumption
		BMCAS  Biomass generating units capacity factor
		BMTCB  Biomass total consumption
		BOACB  Other biofuels consumed by the transportation sector for the United States 
		BOACP  Other biofuels consumed by the transportation sector for the United States 
		BOPRB  Other biofuels total production for the United States
		BOPRP  Other biofuels total production for the United States
		BOTCB  Other biofuels total consumption for the United States
		BOTCP  Other biofuels total consumption for the United States
		BQICB  Normal butane consumed by the industrial sector
		BQICP  Normal butane consumed by the industrial sector
		BQTCB  Normal butane total consumption
		BQTCP  Normal butane total consumption
		BTCAS  Battery storage generating units usage factor
		BTGBP  Battery storage units net summer capacity in all sectors
		BTVHN  Battery electric vehicle (BEV) light-duty stocks
		BTVHP  Electricity consumed for battery electric vehicle (BEV) use
		BYICB  Butylene from refineries consumed by the industrial sector
		BYICP  Butylene from refineries consumed by the industrial sector
		BYTCB  Butylene from refineries total consumption
		BYTCP  Butylene from refineries total consumption
		CCEXB  Coal coke exported from the United States 
		CCEXD  "Coal coke exports average price, United States"
		CCEXP  Coal coke exported from the United States 
		CCEXV  "Coal coke exports expenditures, United States"
		CCIMB  Coal coke imported into the United States
		CCIMD  "Coal coke imports average price, United States"
		CCIMP  Coal coke imported into the United States
		CCIMV  "Coal coke imports expenditures, United States"
		CCNIB  Coal coke net imports into the United States
		CCNIP  Coal coke net imports into the United States
		CCNIV  "Coal coke net imports expenditures, United States"
		CLACB  Coal consumed by the transportation sector
		CLACD  Coal price in the transportation sector
		CLACK  Factor for converting coal consumed by the transportation sector from physical units to Btu
		CLACP  Coal consumed by the transportation sector
		CLACV  Coal expenditures in the transportation sector
		CLCAS  Coal generating units capacity factor
		CLCCB  Coal consumed by the commercial sector
		CLCCD  Coal price in the commercial sector
		CLCCP  Coal consumed by the commercial sector
		CLCCV  Coal expenditures in the commercial sector
		CLEIB  Coal consumed by the electric power sector
		CLEID  Coal price in the electric power sector
		CLEIK  Factor for converting coal consumed by the electric power sector from physical units to Btu
		CLEIP  Coal consumed by the electric power sector
		CLEIV  Coal expenditures in the electric power sector
		CLGBP  Coal generating units net summer capacity in all sectors
		CLHCK  Factor for converting coal consumed by the residential and commercial sectors from physical units to Btu
		CLICB  Coal consumed by the industrial sector
		CLICD  Coal price in the industrial sector
		CLICP  Coal consumed by the industrial sector
		CLICV  Coal expenditures in the industrial sector
		CLISB  Coal consumed by the industrial sector excluding refinery fuel
		CLKCB  Coal consumed at coke plants (coking coal)
		CLKCD  Coal price at coke plants
		CLKCK  Factor for converting coal consumed at coke plants from physical units to Btu
		CLKCP  Coal consumed by coke plants (coking coal)
		CLKCV  Coal expenditures at coke plants
		CLOCB  Coal consumed by industrial users other than coke plants
		CLOCD  Coal price in the industrial sector other than coke plants
		CLOCK  Factor for converting coal consumed by industrial users other than coke plants from physical units to Btu
		CLOCP  Coal consumed by industrial users other than coke plants
		CLOCV  Coal expenditures in the industrial sector other than coke plants
		CLOSB  Coal consumed by the industrial sector other than coke plants excluding refinery fuel
		CLPRB  Coal production
		CLPRK  Factor for converting coal production from physical units to Btu
		CLPRP  Coal production
		CLRCB  Coal consumed by the residential sector
		CLRCD  Coal price in the residential sector
		CLRCP  Coal consumed by the residential sector
		CLRCV  Coal expenditures in the residential sector
		CLRFB  Coal consumed as refinery fuel
		CLSCB  Coal total consumption adjusted for process fuel
		CLTCB  Coal total consumption
		CLTCD  "Coal average price, all sectors"
		CLTCP  Coal total consumption
		CLTCV  Coal total expenditures
		CLTXB  Coal total end-use consumption
		CLTXD  "Coal average price, all end-use sectors"
		CLTXP  Coal total end-use consumption
		CLTXV  Coal total end-use expenditures
		COICB  Crude oil consumed by the industrial sector
		COICP  Crude oil consumed by the industrial sector
		COPRK  Factor for converting crude oil production from physical units to Btu for the United States
		CYCAS  Natural gas combined cycle generating units capacity factor
		DFACB  Distillate fuel oil consumed by the transportation sector
		DFACD  Distillate fuel oil price in the transportation sector
		DFACP  Distillate fuel oil consumed by the transportation sector
		DFACV  Distillate fuel oil expenditures in the transportation sector
		DFASB  Distillate fuel oil consumed by the transportation sector including biofuels product supplied
		DFCCB  Distillate fuel oil consumed by the commercial sector
		DFCCD  Distillate fuel oil price in the commercial sector
		DFCCP  Distillate fuel oil consumed by the commercial sector
		DFCCV  Distillate fuel oil expenditures in the commercial sector
		DFEIB  Distillate fuel oil consumed by the electric power sector
		DFEID  Distillate fuel oil price in the electric power sector
		DFEIP  Distillate fuel oil consumed by the electric power sector
		DFEIV  Distillate fuel oil expenditures in the electric power sector
		DFICB  Distillate fuel oil consumed by the industrial sector
		DFICD  Distillate fuel oil price in the industrial sector
		DFICP  Distillate fuel oil consumed by the industrial sector
		DFICV  Distillate fuel oil expenditures in the industrial sector
		DFISB  Distillate fuel oil consumed by the industrial sector excluding refinery fuel
		DFRCB  Distillate fuel oil consumed by the residential sector
		DFRCD  Distillate fuel oil price in the residential sector
		DFRCP  Distillate fuel oil consumed by the residential sector
		DFRCV  Distillate fuel oil expenditures in the residential sector
		DFRFB  Distillate fuel oil consumed as refinery fuel
		DFSCB  Distillate fuel oil total consumption adjusted for process fuel
		DFTCB  Distillate fuel oil total consumption
		DFTCD  "Distillate fuel oil average price, all sectors"
		DFTCK  Factor for converting distillate fuel from physical units to Btu
		DFTCP  Distillate fuel oil total consumption
		DFTCV  Distillate fuel oil total expenditures
		DFTXB  Distillate fuel oil total end-use consumption
		DFTXD  "Distillate fuel oil average price, all end-use sectors"
		DFTXP  Distillate fuel oil total end-use consumption
		DFTXV  Distillate fuel oil total end-use expenditures
		DKEIB  Distillate fuel oil (including kerosene-type jet fuel before 2001) consumed by the electric power sector
		DKEID  Distillate fuel oil (including kerosene-type jet fuel before 2001) average price in the electric power sector
		DKEIP  Distillate fuel oil (including kerosene-type jet fuel before 2001) consumed by the electric power sector
		DKEIV  Distillate fuel oil (including kerosene-type jet fuel before 2001) expenditures in the electric power sector
		DMACB  "Distillate fuel oil, excluding biodiesel and renewable diesel, consumed by the transportation sector"
		DMACP  "Distillate fuel oil, excluding biodiesel and renewable diesel, consumed by the transportation sector"
		DMTCB  "Distillate fuel oil, excluding biodiesel and renewable diesel, total consumption"
		DMTCK  "Factor for converting distillate fuel, excluding biodiesel and renewable diesel, from physical units to Btu"
		DMTCP  "Distillate fuel oil, excluding biodiesel and renewable diesel, total consumption"
		ELEXB  Electricity exported from the United States
		ELEXD  Electricity exports average price
		ELEXP  Electricity exported from the United States
		ELEXV  Electricity exports expenditures
		ELGBP  Total (all fuels) electric generating units net summer capacity in all sectors
		ELIMB  Electricity imported into the United States
		ELIMD  Electricity imports average price
		ELIMP  Electricity imported into the United States
		ELIMV  Electricity imports expenditures
		ELISB  Net interstate flow of electricity and associated losses (negative indicates flow out of state)
		ELISP  Net interstate flow of electricity (negative indicates flow out of state)
		ELNIB  Net imports of electricity into the United States
		ELNIP  Net imports of electricity into the United States
		ELVHN  Total electric vehicle (EV) light-duty stocks
		ELVHS  Electric vehicle (EV) share of total light-duty vehicles
		EMACB  "Fuel ethanol, excluding denaturant, consumed by the transportation sector   "
		EMACV  "Fuel ethanol, excluding denaturant, expenditures in the transportation sector (through 1992)"
		EMCCB  "Fuel ethanol, excluding denaturant, consumed by the commercial sector "
		EMCCV  "Fuel ethanol, excluding denaturant, expenditures in the commercial sector (through 1992)"
		EMFDB  "Fuel ethanol production (total biomass inputs as feedstock), including liquids and losses & co-products"
		EMICB  "Fuel ethanol, excluding denaturant, consumed by the industrial sector "
		EMICV  "Fuel ethanol, excluding denaturant, expenditures in the industrial sector (through 1992)"
		EMLCB  Energy losses and co-products from the production of fuel ethanol
		EMTCB  "Fuel ethanol, excluding denaturant, total consumption"
		EMTCV  "Fuel ethanol, excluding denaturant, total expenditures (through 1992)"
		ENACP  "Fuel ethanol, including denaturant, consumed by the transportation sector"
		ENCCP  "Fuel ethanol, including denaturant, consumed by the commercial sector"
		ENICP  "Fuel ethanol, including denaturant, consumed by the industrial sector"
		ENPRP  "Fuel ethanol production, including denaturant"
		ENTCK  Fuel ethanol total consumption conversion factor for the United States
		ENTCP  "Fuel ethanol, including denaturant, total consumption"
		EQICB  Ethane consumed by the industrial sector
		EQICP  Ethane consumed by the industrial sector
		EQTCB  Ethane total consumption
		EQTCP  Ethane total consumption
		ESACB  Electricity consumed by (sales to ultimate customers in) the transportation sector
		ESACD  Electricity price in the transportation sector
		ESACP  Electricity consumed by (sales to ultimate customers in) the transportation sector
		ESACV  Electricity expenditures in the transportation sector
		ESCCB  Electricity consumed by (sales to ultimate customers in) the commercial sector
		ESCCD  Electricity price in the commercial sector
		ESCCP  Electricity consumed by (sales to ultimate customers in) the commercial sector
		ESCCV  Electricity expenditures in the commercial sector
		ESICB  Electricity consumed by (sales to ultimate customers in) the industrial sector
		ESICD  Electricity price in the industrial sector
		ESICP  Electricity consumed by (sales to ultimate customers in) the industrial sector
		ESICV  Electricity expenditures in the industrial sector
		ESISB  Electricity sales to the industrial sector excluding refinery use
		ESRCB  Electricity consumed by (sales to ultimate customers in) the residential sector
		ESRCD  Electricity price in the residential sector
		ESRCP  Electricity consumed by (sales to ultimate customers in) the residential sector
		ESRCV  Electricity expenditures in the residential sector
		ESRFB  Electricity consumed by refineries
		ESRPP  Electricity consumed by (sales to ultimate customers in) the residential sector per capita
		ESSCB  Electricity total consumption adjusted for process fuel
		ESTCB  Electricity total consumption (electricity sales to ultimate customers)
		ESTCD  "Electricity average price, all sectors"
		ESTCK  Electricity conversion factor for the United States
		ESTCP  Electricity total consumption (electricity sales to ultimate customers)
		ESTCV  Electricity total expenditures
		ESTPP  Electricity total consumption (electricity sales to ultimate customers) per capita
		ESTXB  Electricity total end-use consumption (electricity sales to ultimate customers)
		ESTXD  "Electricity average price, all end-use sectors"
		ESTXP  Electricity total end-use consumption (electricity sales to ultimate customers)
		ESTXV  Electricity total end-use expenditures
		ESVHP  Electricity consumed for electric vehicle (EV) use
		EV0CN  Legacy charging ports for electric vehicles
		EV1CN  Level 1 charging ports for electric vehicles
		EV2CN  Level 2 charging ports for electric vehicles
		EV2CR  Level 2 charging ports per location
		EVCHN  Total charging ports for electric vehicles
		EVCHP  Total electric vehicle charging locations
		EVDCN  DC fast charging ports for electric vehicles
		EVDCR  DC fast charging ports per location
		EVNNP  Electric vehicle charging locations with both networked and non-networked ports
		EVNOP  Electric vehicle charging locations with non-networked ports only
		EVNTP  Electric vehicle charging locations with networked ports only
		EVPPP  Electric vehicle charging locations with both public and private ports
		EVPUP  Electric vehicle charging locations with public ports only
		EVPVP  Electric vehicle charging locations with private ports only
		EYICB  Ethylene from refineries consumed by the industrial sector
		EYICP  Ethylene from refineries consumed by the industrial sector
		EYTCB  Ethylene from refineries total consumption
		EYTCP  Ethylene from refineries total consumption
		FFETK  Fossil-fueled steam-electric power plant conversion factor
		FFGBP  Fossil fuel total generating units net summer capacity in all sectors
		FFTCB  Fossil fuels total consumption
		FSICB  "Petrochemical feedstocks, still gas, consumed by the industrial sector (through 1985)"
		FSICD  "Petrochemical feedstocks, still gas, price in the industrial sector (through 1985) "
		FSICP  "Petrochemical feedstocks, still gas, consumed by the industrial sector (through 1985)"
		FSICV  "Petrochemical feedstocks, still gas, expenditures in the industrial sector (through 1985)"
		GDPRV  Current-dollar gross domestic product (GDP)
		GDPRX  Real gross domestic product (GDP)
		GECAS  Geothermal generating units capacity factor
		GECCB  Geothermal energy consumed by the commercial sector
		GEEGB  Geothermal energy consumed for electricity generation by the electric power sector
		GEEGP  Geothermal electricity net generation in the electric power sector
		GEGBP  Geothermal generating units net summer capacity in all sectors
		GEICB  Geothermal energy consumed by the industrial sector
		GERCB  Geothermal energy consumed by the residential sector
		GETCB  Geothermal energy total consumption
		GETXB  Geothermal energy total end-use consumption
		HLACB  Hydrocarbon gas liquids consumed by the transportation sector
		HLACD  Hydrocarbon gas liquids price in the transportation sector
		HLACP  Hydrocarbon gas liquids consumed by the transportation sector
		HLACV  Hydrocarbon gas liquids expenditures in the transportation sector
		HLCCB  Hydrocarbon gas liquids consumed by the commercial sector
		HLCCD  Hydrocarbon gas liquids price in the commercial sector
		HLCCP  Hydrocarbon gas liquids consumed by the commercial sector
		HLCCV  Hydrocarbon gas liquids expenditures in the commercial sector
		HLICB  Hydrocarbon gas liquids consumed by the industrial sector
		HLICD  Hydrocarbon gas liquids price in the industrial sector
		HLICK  Average factor for converting hydrocarbon gas liquids consumed by the industrial sector from physical unit to Btu
		HLICP  Hydrocarbon gas liquids consumed by the industrial sector
		HLICV  Hydrocarbon gas liquids expenditures in the industrial sector
		HLISB  Hydrocarbon gas liquids consumed by the industrial sector adjusted for processed fuel
		HLRCB  Hydrocarbon gas liquids consumed by the residential sector
		HLRCD  Hydrocarbon gas liquids price in the residential sector
		HLRCP  Hydrocarbon gas liquids consumed by the residential sector
		HLRCV  Hydrocarbon gas liquids expenditures in the residential sector
		HLRFB  Hydrocarbon gas liquids consumed as refinery fuel and intermediate products
		HLSCB  Hydrocarbon gas liquids total consumption adjusted for processed fuel
		HLTCB  Hydrocarbon gas liquids total consumption
		HLTCD  "Hydrocarbon gas liquids average price, all sectors"
		HLTCK  Average factor for converting hydrocarbon gas liquids total consumption from physical unit to Btu
		HLTCP  Hydrocarbon gas liquids total consumption
		HLTCV  Hydrocarbon gas liquids total expenditures
		HLTXB  Hydrocarbon gas liquids total end-use consumption
		HLTXD  "Hydrocarbon gas liquids average price, all end-use sectors"
		HLTXP  Hydrocarbon gas liquids total end-use consumption
		HLTXV  Hydrocarbon gas liquids total end-use expenditures
		HPCAS  Hydroelectric pumped storage generating units usage factor
		HPGBP  Hydroelectric pumped storage generating units net summer capacity in all sectors
		HVCAS  Conventional hydroelectric generating units capacity factor
		HVGBP  Conventional hydroelectric power generating units net summer capacity in all sectors
		HYCCB  Hydropower consumed by the commercial sector
		HYCCP  Hydroelectricity net generation in the commercial sector
		HYEGB  Hydropower consumed for electricity generation by the electric power sector
		HYEGP  Hydroelectricity net generation in the electric power sector
		HYICB  Hydropower consumed by the industrial sector
		HYICP  Hydroelectricity net generation in the industrial sector
		HYTCB  Hydropower total consumption
		HYTCP  Hydroelectricity total net generation
		HYTXB  Hydropower energy total end-use consumption
		HYTXP  "Hydroelectricity, total end-use net generation"
		IQICB  Isobutane consumed by the industrial sector
		IQICP  Isobutane consumed by the industrial sector
		IQTCB  Isobutane total consumption
		IQTCP  Isobutane total consumption
		IYICB  Isobutylene from refineries consumed by the industrial sector
		IYICP  Isobutylene from refineries consumed by the industrial sector
		IYTCB  Isobutylene from refineries total consumption
		IYTCP  Isobutylene from refineries total consumption
		JFACB  Jet fuel consumed by the transportation sector
		JFACD  Jet fuel price in the transportation sector
		JFACP  Jet fuel consumed by the transportation sector
		JFACV  Jet fuel expenditures in the transportation sector
		JFTCB  Jet fuel total consumption
		JFTCD  "Jet fuel average price, all sectors"
		JFTCP  Jet fuel total consumption
		JFTCV  Jet fuel total expenditures
		JFTXB  Jet fuel total end-use consumption
		JFTXD  "Jet fuel average price, all end-use sectors"
		JFTXP  Jet fuel total end-use consumption
		JFTXV  Jet fuel total end-use expenditures
		KSCCB  Kerosene consumed by the commercial sector
		KSCCD  Kerosene price in the commercial sector
		KSCCP  Kerosene consumed by the commercial sector
		KSCCV  Kerosene expenditures in the commercial sector
		KSICB  Kerosene consumed by the industrial sector
		KSICD  Kerosene price in the industrial sector
		KSICP  Kerosene consumed by the industrial sector
		KSICV  Kerosene expenditures in the industrial sector
		KSRCB  Kerosene consumed by the residential sector
		KSRCD  Kerosene price in the residential sector
		KSRCP  Kerosene consumed by the residential sector
		KSRCV  Kerosene expenditures in the residential sector
		KSTCB  Kerosene total consumption
		KSTCD  "Kerosene average price, all sectors"
		KSTCP  Kerosene total consumption
		KSTCV  Kerosene total expenditures
		KSTXB  Kerosene total end-use consumption
		KSTXD  "Kerosene average price, all end-use sectors"
		KSTXP  Kerosene total end-use consumption
		KSTXV  Kerosene total end-use expenditures
		LDVHN  Total (all fuels) vehicle light-duty stocks
		LOACB  The transportation sector's share of electrical system energy losses
		LOCCB  The commercial sector's share of electrical system energy losses
		LOICB  The industrial sector's share of electrical system energy losses
		LORCB  The residential sector's share of electrical system energy losses
		LOTCB  Total electrical system energy losses
		LOTXB  Total electrical system energy losses allocated to the end-use sectors
		LUACB  Lubricants consumed by the transportation sector
		LUACD  Lubricants price in the transportation sector
		LUACP  Lubricants consumed by the transportation sector
		LUACV  Lubricants expenditures in the transportation sector
		LUICB  Lubricants consumed by the industrial sector
		LUICD  Lubricants price in the industrial sector
		LUICP  Lubricants consumed by the industrial sector
		LUICV  Lubricants expenditures in the industrial sector
		LUTCB  Lubricants total consumption
		LUTCD  "Lubricants average price, all sectors"
		LUTCP  Lubricants total consumption
		LUTCV  Lubricants total expenditures
		LUTXB  Lubricants total end-use consumption
		LUTXD  "Lubricants average price, all end-use sectors"
		LUTXP  Lubricants total end-use consumption
		LUTXV  Lubricants total end-use expenditures
		MBICB  Motor gasoline blending components consumed by the industrial sector
		MBICP  Motor gasoline blending components consumed by the industrial sector
		MBTCK  Factor for converting motor gasoline blending components from physical units to Btu
		MGACB  Motor gasoline consumed by the transportation sector
		MGACD  Motor gasoline price in the transportation sector
		MGACP  Motor gasoline consumed by the transportation sector
		MGACV  Motor gasoline expenditures in the transportation sector
		MGCCB  Motor gasoline consumed by the commercial sector
		MGCCD  Motor gasoline price in the commercial sector
		MGCCP  Motor gasoline consumed by the commercial sector
		MGCCV  Motor gasoline expenditures in the commercial sector
		MGICB  Motor gasoline consumed by the industrial sector
		MGICD  Motor gasoline price in the industrial sector
		MGICP  Motor gasoline consumed by the industrial sector
		MGICV  Motor gasoline expenditures in the industrial sector
		MGTCB  Motor gasoline total consumption
		MGTCD  "Motor gasoline average price, all sectors"
		MGTCK  Factor for converting motor gasoline from physical units to Btu
		MGTCP  Motor gasoline total consumption
		MGTCV  Motor gasoline total expenditures
		MGTPV  Motor gasoline expenditures per capita
		MGTXB  Motor gasoline total end-use consumption
		MGTXD  "Motor gasoline average price, all end-use sectors"
		MGTXP  Motor gasoline total end-use consumption
		MGTXV  Motor gasoline total end-use expenditures
		MMACB  "Motor gasoline, excluding fuel ethanol, consumed by the transportation sector"
		MMCCB  "Motor gasoline, excluding fuel ethanol, consumed by the commercial sector"
		MMICB  "Motor gasoline, excluding fuel ethanol, consumed by the industrial sector"
		MMTCB  "Motor gasoline, excluding fuel ethanol, total consumption"
		MSICB  Miscellaneous petroleum products consumed by the industrial sector
		MSICD  Miscellaneous petroleum products price in the industrial sector
		MSICP  Miscellaneous petroleum products consumed by the industrial sector
		MSICV  Miscellaneous petroleum products expenditures in the industrial sector
		NAICB  Natural gasoline consumed by the industrial sector (through 1983)
		NAICP  Natural gasoline consumed by the industrial sector (through 1983)
		NCPRB  Noncombustible renewable energy production
		NGACB  Natural gas consumed by the transportation sector 
		NGACD  Natural gas price in the transportation sector
		NGACP  Natural gas consumed by the transportation sector
		NGACV  Natural gas expenditures in the transportation sector
		NGASB  Natural gas consumed by the transportation sector adjusted for process fuel
		NGCCB  "Natural gas delivered to the commercial sector, used as consumption (including supplemental gaseous fuels)"
		NGCCD  Natural gas price in the commercial sector (including supplemental gaseous fuels)
		NGCCP  "Natural gas delivered to the commercial sector, used as consumption (including supplemental gaseous fuels)"
		NGCCV  Natural gas expenditures in the commercial sector (including supplemental gaseous fuels)
		NGEIB  Natural gas consumed by the electric power sector (including supplemental gaseous fuels)
		NGEID  Natural gas price in the electric power sector (including supplemental gaseous fuels)
		NGEIK  Factor for converting natural gas consumed by the electric power sector from physical units to Btu
		NGEIP  Natural gas consumed by the electric power sector (including supplemental gaseous fuels)
		NGEIV  Natural gas expenditures in the electric power sector (including supplemental gaseous fuels)
		NGGBP  Natural gas generating units net summer capacity in all sectors
		NGICB  Natural gas consumed by the industrial sector (including supplemental gaseous fuels)
		NGICD  Natural gas price in the industrial sector (including supplemental gaseous fuels)
		NGICP  Natural gas consumed by the industrial sector (including supplemental gaseous fuels)
		NGICV  Natural gas expenditures in the industrial sector (including supplemental gaseous fuels)
		NGISB  Natural gas consumed by the industrial sector excluding refinery fuel
		NGLPB  Natural gas consumed as lease and plant fuel
		NGMPB  Natural gas marketed production
		NGMPK  Factor for converting marketed natural gas production from physical units to Btu
		NGMPP  Natural gas marketed production
		NGPZB  Natural gas for pipeline and distribution use
		NGRCB  "Natural gas delivered to the residential sector, used as consumption (including supplemental gaseous fuels)"
		NGRCD  Natural gas price in the residential sector (including supplemental gaseous fuels)
		NGRCP  "Natural gas delivered to the residential sector, used as consumption (including supplemental gaseous fuels)"
		NGRCV  Natural gas expenditures in the residential sector (including supplemental gaseous fuels)
		NGRFB  Natural gas consumed as refinery fuel
		NGSCB  Natural gas total consumption adjusted for process fuel
		NGTCB  Natural gas total consumption (including supplemental gaseous fuels)
		NGTCD  "Natural gas average price, all sectors (including supplemental gaseous fuels)"
		NGTCK  Factor for converting natural gas total consumption from physical units to Btu
		NGTCP  Natural gas total consumption (including supplemental gaseous fuels)
		NGTCV  Natural gas total expenditures (including supplemental gaseous fuels)
		NGTPB  Natural gas total consumption (including supplemental gaseous fuels) per capita
		NGTPP  Natural gas total consumption (including supplemental gaseous fuels) per capita
		NGTXB  Natural gas total end-use consumption (including supplemental gaseous fuels)
		NGTXD  "Natural gas average price, all end-use sectors (including supplemental gaseous fuels)"
		NGTXK  Factor for converting natural gas used by end-use sectors from physical units to Btu
		NGTXP  Natural gas total end-use consumption (including supplemental gaseous fuels)
		NGTXV  Natural gas total end-use expenditures (including supplemental gaseous fuels)
		NNTCB  Natural gas total consumption (excluding supplemental gaseous fuels)
		NTCAS  Natural gas turbine generating units capacity factor
		NUCAS  Nuclear generating units capacity factor
		NUEGB  Nuclear energy consumed for electricity generation by the electric power sector
		NUEGD  Nuclear fuel price in the electric power sector
		NUEGP  Nuclear electricity net generation in the electric power sector
		NUEGV  Nuclear fuel expenditures in the electric power sector
		NUETB  "Nuclear energy consumed for electricity generation, total"
		NUETD  "Nuclear fuel average price, all sectors"
		NUETK  Factor for converting electricity generated from nuclear power from physical units to Btu
		NUETP  Nuclear electricity total net generation
		NUETV  Nuclear fuel total expenditures
		NUGBP  Nuclear generating units net summer capacity in all sectors
		NYCAS  Natural gas conventional steam generating units capacity factor
		OHICB  Other hydrocarbon gas liquids (other than propane) consumed by the industrial sector
		OHICD  Other hydrocarbon gas liquids (other than propane) price in the industrial sector
		OHICV  Other hydrocarbon gas liquids (other than propane) expenditures in the industrial sector
		OJGBP  Other gases generating units net summer capacity in all sectors
		OMTCB  "Other petroleum products consumption, excluding biofuels"
		OPACB  Other petroleum products consumed by the transportation sector
		OPACP  Other petroleum products consumed by the transportation sector
		OPICB  Other petroleum products consumed by the industrial sector
		OPICD  Other petroleum products average price in the industrial sector
		OPICP  Other petroleum products consumed by the industrial sector
		OPICV  Other petroleum products total expenditures in the industrial sector
		OPISB  Other petroleum products consumed by the industrial sector excluding refinery fuel and intermediate products
		OPSCB  Other petroleum products total consumption adjusted for refinery fuel and intermediate products
		OPTCB  Other petroleum products total consumption
		OPTCD  "Other petroleum products average price, all sectors"
		OPTCP  Other petroleum products total consumption
		OPTCV  Other petroleum products total expenditures
		OPTXB  Other petroleum products total end-use consumption
		OPTXD  "Other petroleum products average price, all end-use sectors"
		OPTXP  Other petroleum products total end-use consumption
		OPTXV  Other petroleum products total end-use expenditures
		OTGBP  Other generating units net summer capacity in all sectors
		P1ICB  "Asphalt and road oil, kerosene, lubricants, petroleum coke, and other petroleum products consumed by the industrial sector"
		P1ICD  "Asphalt and road oil, kerosene, lubricants, petroleum coke, and other petroleum products average price in the  industrial sector"
		P1ICP  "Asphalt and road oil, kerosene, lubricants, petroleum coke, and other petroleum products consumed by the industrial sector"
		P1ICV  "Asphalt and road oil, kerosene, lubricants, petroleum coke, and other petroleum products expenditures in the  industrial sector"
		P1ISB  "Asphalt and road oil, kerosene, lubricants, petroleum coke, and other petroleum products consumed by the industrial sector excluding refinery fuel and intermediate products"
		P1SCB  "Asphalt and road oil, kerosene, lubricants, petroleum coke, and other petroleum products total consumption adjusted for process fuel and intermediate products"
		P1TCB  "Asphalt and road oil, aviation gasoline, kerosene, lubricants, petroleum coke, and other petroleum products total consumption"
		P1TCD  "Asphalt and road oil, aviation gasoline, kerosene, lubricants, petroleum coke, and other petroleum products average price, all sectors"
		P1TCP  "Asphalt and road oil, aviation gasoline, kerosene, lubricants, petroleum coke, and other petroleum products total consumption"
		P1TCV  "Asphalt and road oil, aviation gasoline, kerosene, lubricants, petroleum coke, and other petroleum products total expenditures"
		P1TXB  "Asphalt and road oil, aviation gasoline, kerosene, lubricants, petroleum coke, and other petroleum products total end-use consumption"
		P1TXD  "Asphalt and road oil, aviation gasoline, kerosene, lubricants, petroleum coke, and other petroleum products average price, all end-use sectors"
		P1TXP  "Asphalt and road oil, aviation gasoline, kerosene, lubricants, petroleum coke, and other petroleum products total end-use consumption"
		P1TXV  "Asphalt and road oil, aviation gasoline, kerosene, lubricants, petroleum coke, and other petroleum products total end-use expenditures"
		P5RFB  Other petroleum products consumed as refinery fuel and intermediate products
		PAACB  All petroleum products consumed by the transportation sector
		PAACD  All petroleum products average price in the transportation sector
		PAACK  Factor for converting all petroleum products consumed by the transportation sector from physical units to Btu for the United States
		PAACP  All petroleum products consumed by the transportation sector
		PAACV  All petroleum products total expenditures in the transportation sector
		PAASB  All petroleum products consumed by the transportation sector excluding other biofuels product supplied for the United States
		PACAS  Petroleum generating units capacity factor
		PACCB  All petroleum products consumed by the commercial sector
		PACCD  All petroleum products average price in the commercial sector
		PACCK  Factor for converting all petroleum products consumed by the commercial sector from physical units to Btu for the United States
		PACCP  All petroleum products consumed by the commercial sector
		PACCV  All petroleum products total expenditures in the commercial sector
		PAEIB  All petroleum products consumed by the electric power sector
		PAEID  All petroleum products average price in the electric power sector
		PAEIK  Factor for converting all petroleum products consumed by the electric power sector from physical units to Btu for the United States
		PAEIP  All petroleum products consumed by the electric power sector
		PAEIV  All petroleum products total expenditures in the electric power sector
		PAGBP  Petroleum generating units net summer capacity in all sectors
		PAICB  All petroleum products consumed by the industrial sector
		PAICD  All petroleum products average price in the industrial sector
		PAICK  Factor for converting all petroleum products consumed by the industrial sector from physical units to Btu for the United States
		PAICP  All petroleum products consumed by the industrial sector
		PAICV  All petroleum products total expenditures in the industrial sector
		PAISB  All petroleum products consumed by the industrial sector excluding process fuel and intermediate products
		PAPRB  Crude oil production (including lease condensate)
		PAPRP  Crude oil production (including lease condensate)
		PARCB  All petroleum products consumed by the residential sector
		PARCD  All petroleum products average price in the residential sector
		PARCK  Factor for converting all petroleum products consumed by the residential sector from physical units to Btu for the United States
		PARCP  All petroleum products consumed by the residential sector
		PARCV  All petroleum products total expenditures in the residential sector
		PASCB  All petroleum products total consumption adjusted for process fuel and intermediate products
		PATCB  All petroleum products total consumption
		PATCD  "All petroleum products average price, all sectors"
		PATCK  Factor for converting all petroleum products consumed by all sectors from physical units to Btu for the United States
		PATCP  All petroleum products total consumption
		PATCV  All petroleum products total expenditures
		PATPB  All petroleum products total consumption per capita
		PATPP  All petroleum products total consumption per capita
		PATXB  All petroleum products total end-use consumption
		PATXD  "All petroleum products average price, all end-use sectors"
		PATXP  All petroleum products total end-use consumption
		PATXV  All petroleum products total end-use expenditures
		PCCCB  Petroleum coke consumed by the commercial sector
		PCCCD  Petroleum coke price in the commercial sector
		PCCCP  Petroleum coke consumed by the commercial sector
		PCCCV  Petroleum coke expenditures in the commercial sector
		PCCTK  "Factor for converting petroleum coke, catalyst coke from physical units to Btu"
		PCEIB  Petroleum coke consumed by the electric power sector
		PCEID  Petroleum coke price in the electric power sector
		PCEIP  Petroleum coke consumed by the electric power sector
		PCEIV  Petroleum coke expenditures in the electric power sector
		PCICB  Petroleum coke consumed in the industrial sector
		PCICD  Petroleum coke price in the industrial sector
		PCICP  Petroleum coke consumed in the industrial sector
		PCICV  Petroleum coke expenditures in the industrial sector
		PCISB  Petroleum coke consumed by the industrial sector excluding refinery fuel
		PCMKK  "Factor for converting petroleum coke, marketable coke from physical units to Btu"
		PCRFB  Petroleum coke consumed as refinery fuel
		PCSCB  Petroleum coke total consumption adjusted for process fuel
		PCTCB  Petroleum coke total consumption
		PCTCD  "Petroleum coke average price, all sectors"
		PCTCP  Petroleum coke total consumption
		PCTCV  Petroleum coke total expenditures
		PCTXB  Petroleum coke total end-use consumption
		PCTXD  "Petroleum coke average price, all end-use sectors"
		PCTXP  Petroleum coke total end-use consumption
		PCTXV  Petroleum coke total end-use expenditures
		PEACD  Primary energy average price in the transportation sector
		PEACV  Primary energy total expenditures in the transportation sector
		PEASB  "Primary energy consumed by the transportation sector, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		PECCD  Primary energy average price in the commercial sector
		PECCV  Primary energy total expenditures in the commercial sector
		PECSB  "Primary energy consumed by the commercial sector, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		PEEID  Primary energy average price in the electric power sector
		PEEIV  Primary energy total expenditures in the electric power sector
		PEICD  Primary energy average price in the industrial sector
		PEICV  Primary energy total expenditures in the industrial sector
		PEISB  "Primary energy consumed by the industrial sector, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		PERCD  Primary energy average price in the residential sector
		PERCV  Primary energy total expenditures in the residential sector
		PERSB  "Primary energy consumed by the residential sector, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		PESCB  "Primary energy total consumption, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		PETCD  "Primary energy average price, all sectors"
		PETCV  Primary energy total expenditures
		PETXD  "Primary energy average price, all end-use sectors"
		PETXV  Primary energy total end-use expenditures
		PHVHN  Plug-in hybrid electric vehicle (PHEV) light-duty stocks
		PHVHP  Electricity consumed for plug-in hybrid electric vehicle (PHEV) use
		PLICB  Plant condensate consumed by the industrial sector (through 1983)
		PLICP  Plant condensate consumed by the industrial sector (through 1983)
		PMACB  "All petroleum products, excluding biofuels, consumed by the transportation sector"
		PMCCB  "All petroleum products, excluding biofuels, consumed by the commercial sector"
		PMICB  "All petroleum products, excluding biofuels, consumed by the industrial sector"
		PMTCB  "All petroleum products, excluding biofuels, total consumption"
		PPICB  Natural gasoline (pentanes plus) consumed by the industrial sector
		PPICP  Natural gasoline (pentanes plus) consumed by the industrial sector
		PPTCB  Natural gasoline (pentanes plus) total consumption
		PPTCP  Natural gasoline (pentanes plus) total consumption
		PQACB  Propane consumed by the transportation sector
		PQACD  Propane price in the transportation sector
		PQACP  Propane consumed by the transportation sector
		PQACV  Propane expenditures in the transportation sector
		PQCCB  Propane consumed by the commercial sector
		PQCCD  Propane price in the commercial sector
		PQCCP  Propane consumed by the commercial sector
		PQCCV  Propane expenditures in the commercial sector
		PQICB  Propane consumed by the industrial sector
		PQICD  Propane price in the industrial sector
		PQICP  Propane consumed by the industrial sector
		PQICV  Propane expenditures in the industrial sector
		PQISB  Propane consumed in the industrial sector excluding refinery fuel
		PQRCB  Propane consumed by the residential sector
		PQRCD  Propane price in the residential sector
		PQRCP  Propane consumed by the residential sector
		PQRCV  Propane expenditures in the residential sector
		PQRFB  Propane consumed as refinery fuel
		PQSCB  Propane total consumption adjusted for process fuel
		PQTCB  Propane total consumption
		PQTCD  "Propane average price, all sectors"
		PQTCP  Propane total consumption
		PQTCV  Propane total expenditures
		PQTXB  Propane total end-use consumption
		PQTXD  "Propane average price, all end-use sectors"
		PQTXP  Propane total end-use consumption
		PQTXV  Propane total end-use expenditures
		PYICB  Propylene from refineries consumed by the industrial sector
		PYICP  Propylene from refineries consumed by the industrial sector
		PYTCB  Propylene from refineries total consumption
		PYTCP  Propylene from refineries total consumption
		REACB  Renewable energy sources consumed by the transportation sector
		RECCB  Renewable energy sources consumed by the commercial sector
		REEIB  Renewable energy sources consumed by the electric power sector
		REGBP  Renewable energy total generating units net summer capacity in all sectors
		REICB  Renewable energy sources consumed by the industrial sector
		REPRB  Renewable energy production
		RERCB  Renewable energy sources consumed by the residential sector
		RETCB  Renewable energy total consumption
		RFACB  Residual fuel oil consumed by the transportation sector
		RFACD  Residual fuel oil price in the transportation sector
		RFACP  Residual fuel oil consumed by the transportation sector
		RFACV  Residual fuel oil expenditures in the transportation sector
		RFCCB  Residual fuel oil consumed by the commercial sector
		RFCCD  Residual fuel oil price in the commercial sector
		RFCCP  Residual fuel oil consumed by the commercial sector
		RFCCV  Residual fuel oil expenditures in the commercial sector
		RFEIB  Residual fuel oil consumed by the electric power sector
		RFEID  Residual fuel oil price in the electric power sector
		RFEIP  Residual fuel oil consumed by the electric power sector
		RFEIV  Residual fuel oil expenditures in the electric power sector
		RFICB  Residual fuel oil consumed by the industrial sector
		RFICD  Residual fuel oil price in the industrial sector
		RFICP  Residual fuel oil consumed by the industrial sector
		RFICV  Residual fuel oil expenditures in the industrial sector
		RFISB  Residual fuel oil consumed by the industrial sector excluding refinery fuel
		RFRFB  Residual fuel oil consumed as refinery fuel
		RFSCB  Residential fuel oil total consumption excluding process fuel
		RFTCB  Residual fuel oil total consumption
		RFTCD  "Residual fuel oil average price, all sectors"
		RFTCP  Residual fuel oil total consumption
		RFTCV  Residual fuel oil total expenditures
		RFTXB  Residual fuel oil total end-use consumption
		RFTXD  "Residual fuel oil average price, all end-use sectors"
		RFTXP  Residual fuel oil total end-use consumption
		RFTXV  Residual fuel oil total end-use expenditures
		SFCCB  Supplemental gaseous fuels consumed by the commercial sector
		SFEIB  Supplemental gaseous fuels consumed by the electric power sector
		SFINB  Supplemental gaseous fuels consumed by the industrial sector
		SFRCB  Supplemental gaseous fuels consumed by the residential sector
		SFTCB  Supplemental gaseous fuels total consumption
		SGICB  Still gas consumed by the industrial sector
		SGICP  Still gas consumed by the industrial sector
		SHCAS  Solar thermal generating units capacity factor
		SNICB  Special naphthas consumed by the industrial sector
		SNICD  Special naphthas price in the industrial sector
		SNICP  Special naphthas consumed by the industrial sector
		SNICV  Special naphthas expenditures in the industrial sector
		SOCCB  Solar energy consumed by the commercial sector
		SOCCP  Solar thermal and photovoltaic electricity net generation in the commercial sector
		SOEGB  Solar energy consumed for electricity generation by the electric power sector
		SOEGP  Solar thermal and photovoltaic electricity net generation in the electric power sector
		SOGBP  Solar generating units net summer capacity in all sectors
		SOICB  Solar energy consumed by the industrial sector
		SOICP  Solar thermal and photovoltaic electricity net generation in the industrial sector
		SOR7P  Solar photovoltaic electricity generation by small-scale applications in the residential sector
		SORCB  Solar energy consumed by the residential sector
		SOTCB  Solar energy total consumption
		SOTGP  Solar thermal and photovoltaic electricity total net generation
		SOTXB  Solar energy total end-use consumption
		SPCAS  Solar photovoltaic generating units capacity factor
		TEACB  Total energy consumption in the transportation sector
		TEACD  Total energy average price in the transportation sector
		TEACV  Total energy expenditures in the transportation sector
		TEAPB  Total energy consumption per capita in the transportation sector
		TECCB  Total energy consumption in the commercial sector
		TECCD  Total energy average price in the commercial sector
		TECCV  Total energy expenditures in the commercial sector
		TECPB  Total energy consumption per capita in the commercial sector
		TEEIB  Total energy consumption in the electric power sector plus net imports of electricity into the United States
		TEGDS  Energy expenditures as percent of current-dollar GDP
		TEICB  Total energy consumption in the industrial sector
		TEICD  Total energy average price in the industrial sector
		TEICV  Total energy expenditures in the industrial sector
		TEIPB  Total energy consumption per capita in the industrial sector
		TEPFB  Total energy used as process fuel and other consumption that has no direct fuel costs
		TEPRB  Total primary energy production
		TERCB  Total energy consumption in the residential sector
		TERCD  Total energy average price in the residential sector
		TERCV  Total energy expenditures in the residential sector
		TERFB  Total energy used as refinery fuel and intermediate products
		TERPB  Total energy consumption per capita in the residential sector
		TETCB  Total energy consumption
		TETCD  Total energy average price
		TETCV  Total energy expenditures
		TETGR  Total energy consumption per dollar of real gross domestic product (GDP)
		TETPB  Total energy consumption per capita
		TETPV  Total energy expenditures per capita
		TETXB  Total end-use sector energy consumption
		TETXD  Total end-use energy average price
		TETXV  Total end-use energy expenditures
		TNACB  End-use energy consumption in the transportation sector
		TNASB  "Total net energy consumed by the transportation sector, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		TNCCB  End-use energy consumption in the commercial sector
		TNCSB  "Total net energy consumed by the commercial sector, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		TNICB  End-use energy consumption in the industrial sector
		TNISB  "Total net energy consumed by the industrial sector, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		TNRCB  End-use energy consumption in the residential sector
		TNRSB  "Total net energy consumed by the residential sector, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		TNSCB  "Total net energy consumption, adjusted for process fuel, intermediate products, and fuels with no direct cost"
		TNTCB  Total end-use energy consumption
		TPOPP  Resident population including Armed Forces
		UOICB  Unfinished oils consumed by the industrial sector
		UOICP  Unfinished oils consumed by the industrial sector
		USICB  Unfractionated streams consumed by the industrial sector (through 1983)
		USICP  Unfractionated streams consumed by the industrial sector (through 1983)
		WDCCB  Wood energy consumed by the commercial sector
		WDEIB  Wood consumed by the electric power sector
		WDEXB  Densified biomass exports (available for 2016 forward)
		WDGBP  Wood generating units net summer capacity in all sectors
		WDICB  Wood energy consumed by the industrial sector
		WDPRB  Wood energy production
		WDRCB  Wood energy consumed by the residential sector
		WDRCD  Wood price in the residential sector
		WDRCV  Wood expenditures in the residential sector
		WDRSB  Wood energy consumed in the residential sector at a cost
		WDRXB  Wood energy consumed in the residential sector at no cost
		WDTCB  Wood energy total consumption
		WSCCB  Waste energy consumed by the commercial sector
		WSEIB  Waste consumed by the electric power sector
		WSGBP  Waste generating units net summer capacity in all sectors
		WSICB  Waste energy consumed by the industrial sector
		WSTCB  Waste energy total consumption
		WWCCB  Wood and waste consumed in the commercial sector
		WWCCD  Wood and waste price in the commercial sector
		WWCCV  Wood and waste expenditures in the commercial sector
		WWCSB  Wood and waste energy consumed in the commercial sector at a cost
		WWCXB  Wood and waste energy consumed in the commercial sector at no cost
		WWEIB  Wood and waste consumed by the electric power sector
		WWEID  Wood and waste price in the electric power sector
		WWEIV  Wood and waste expenditures in the electric power sector
		WWICB  Wood and waste consumed in the industrial sector
		WWICD  Wood and waste price in the industrial sector
		WWICV  Wood and waste expenditures in the industrial sector
		WWISB  Wood and waste energy consumed in the industrial sector at a cost
		WWIXB  Wood and waste energy consumed in the industrial sector at no cost
		WWPRB  Wood and waste energy production
		WWSCB  "Wood and waste energy total consumption, adjusted for fuels with no direct cost"
		WWTCB  Wood and waste total consumption
		WWTCD  "Wood and waste average price, all sectors"
		WWTCV  Wood and waste total expenditures
		WWTXB  Wood and waste total end-use consumption
		WWTXD  Waste average price
		WWTXV  Wood and waste total end-use expenditures
		WXICB  Waxes consumed by the industrial sector
		WXICD  Waxes price in the industrial sector
		WXICP  Waxes consumed by the industrial sector
		WXICV  Waxes expenditures in the industrial sector
		WYCAS  Wind generating units capacity factor
		WYCCB  Wind energy consumed by the commercial sector
		WYCCP  Wind electricity net generation in the commercial sector
		WYEGB  Wind energy consumed for electricity generation by the electric power sector
		WYEGP  Wind electricity net generation in the electric power sector
		WYGBP  Wind generating units net summer capacity in all sectors
		WYICB  Wind energy consumed by the industrial sector
		WYICP  Wind electricity net generation in the industrial sector
		WYTCB  Wind energy total consumption
		WYTCP  Wind electricity total net generation
		WYTXB  Wind energy total end-use consumption
		WYTXP  Wind energy total end-use net generation
		ZWCDP  Cooling degree days (CDD)
		ZWHDP  Heating degree days (HDD) /;

set	r	Regions (states) /

	X3	Gulf of Mexico
	X5	Pacific
*	-----------------------
	AK	Alaska
	AL	Alabama
	AR	Arkansas
	AZ	Arizona
	CA	California
	CO	Colorado
	CT	Connecticut
	DC	District of Columbia
	DE	Delaware
	FL	Florida
	GA	Georgia
	HI	Hawaii
	IA	Iowa
	ID	Idaho
	IL	Illinois
	IN	Indiana
	KS	Kansas
	KY	Kentucky
	LA	Louisiana
	MA	Massachusetts
	MD	Maryland
	ME	Maine
	MI	Michigan
	MN	Minnesota
	MO	Missouri
	MS	Mississippi
	MT	Montana
	NC	North Carolina
	ND	North Dakota
	NE	Nebraska
	NH	New Hampshire
	NJ	New Jersey
	NM	New Mexico
	NV	Nevada
	NY	New York
	OH	Ohio
	OK	Oklahoma
	OR	Oregon
	PA	Pennsylvania
	RI	Rhode Island
	SC	South Carolina
	SD	South Dakota
	TN	Tennessee
	TX	Texas
	US	United States
	UT	Utah
	VA	Virginia
	VT	Vermont
	WA	Washington
	WI	Wisconsin
	WV	West Virginia
	WY	Wyoming /;


set	map(item,r,id) /
$offlisting
$include sedsmap
$onlisting
/;

set	f	Fuels and energy carriers /
	AB	Aviation gasoline blending components
	AR	Asphalt and road oil
	AV	Aviation gasoline
	B1	Renewable diesel
	BD	Biodiesel
	BF	Biofuels 
	BM	Biomass
	BO	Other biofuels
	BQ	Normal butane
	BT	Batter
	BY	Butylene
	CC	Coal coke
	CL	Coal
	CO	Crude oil
	CY	Natural gas combined cycle
	DF	Distillate fuel
	DK	Distillate fuel oil (including kerosene-type jet fuel before 2001)
	DM	Distillate fuel oil (excluding biodiesel and renewable diesel)
	EL	Electricity
	EM	Fuel ethanol (excluding denaturant)
	EN	Fuel ethanol (including denaturant)
	EQ	Ethane
	ES	Electricity
	EV	Electric vehicles
	EY	Ethylene
	FF	Fossil-fuel
	FS	Petrochemical feedstocks (still gas)
	GDP	Real gross domestic product
	GE	Geothermal energy
	HL	Hydrocarbon gas liquids	
	HP	Hydroelectric pumped storage
	HV	Conventional hydroelectric
	HY	Hydropower
	IQ	Isobutane
	IY	Isobutylene
	JF	Jet fuel
	KS	Kerosene
	LD	Light-duty
	LO	Electrical system energy losses
	LU	Lubricants
	MB	Motor gasoline blending components
	MG	Motor gasoline
	MM	Motor gasoline (excluding fuel ethanol)
	MS	Miscellaneous petroleum products
	NA	Natural gasoline
	NC	Noncombustible renewable
	NG	Natural gas
	NN	Natural gas total excluding supplemental gaseous fuels
	NT	Natural gas turbine
	NU	Nuclear generating units
	NY	Natural gas conventional steam generating units
	OH	Other hydrocarbon gas liquids
	OJ	Other gases generating units
	OM	Other petroleum products
	OP	Other petroleum products 
	OT	Other generating units
	P1	Asphalt and road oil - kerosene - lubricants - petroleum coke and other petroleum products
	P5	Other petroleum products
	PA	All petroleum products
	PC	Petroleum coke
	PE	Primary energy	
	PH	Plug-in hybrid electric vehicle
	PL	Plant condensate
	PM	All petroleum products (excluding biofuels)
	PP	Natural gasoline (pentanes plus)
	PQ	Propane
	PY	Propylene
	RE	Renewable energy
	RF	Residual fuel oil
	SF	Supplemental gaseous fuels
	SG	Still gas
	SH	Solar thermal
	SN	Special naphthas
	SO	Solar energy
	SP	Solar photovoltaic
	TE	Total energy
	TN	Total net energy
	TP	Resident population	
	UO	Unfinished oils
	US	Unfractionated streams
	WD	Wood energy
	WS	Waste energy
	WW	Wood and waste
	WX	Waxes
	WY	Wind
	ZW	Degree days /

set	d	Data items /

	CCK  Conversion factor

	0CN  charging ports for electric vehicles
	1CN  Level 1 charging ports
	2CN  Level 2 charging ports
	2CR  Level 2 charging ports per location
	ACK  Factor for converting transportation sector consumption from physical units to Btu 
	APB  consumption per capita in the transportation sector
	CAS  capacity factor
	CDP  Cooling degree days (CDD)
	CHN  Total charging ports
	CHP  charging locations
	CPB  Total energy consumption per capita in the commercial sector
	CTK  Factor for converting coke coke from physical units to Btu
	CXB  Wood and waste energy consumed in the commercial sector at no cost
	DCN  DC fast charging ports for electric vehicles
	DCR  DC fast charging ports per location
	EGP  net generation in the electric power sector
	EGV  Nuclear fuel expenditures in the electric power sector
	EIK  Factor for converting energy inputs tothe electric power sector from physical units to Btu
	ETK  electric power plant conversion factor from physical units to Btu
	GBP  generating units net summer capacity
	GDS  Energy expenditures as percent of current-dollar GDP
	HCK  Conversion factor for residential and commercial sectors from physical units to Btu
	HDP  Heating degree days (HDD) 
	ICK  Conversion for energy inputs in industry from physical units to Btu 
	INB  Supplemental gaseous fuels consumed by the industrial sector
	IPB  Total energy consumption per capita in the industrial sector
	ISP  net interstate flow of electricity (negative indicates flow out of state)
	IXB  Wood and waste energy consumed in the industrial sector at no cost
	KCB  consumed at coke plants (coking coal)
	KCD  price at coke plants
	KCK  converting coal consumed at coke plants from physical units to Btu
	KCP  by coke plants (coking coal)
	KCV  expenditures at coke plants
	LCB  Energy losses and co-products from production
	LPB  Natural gas consumed as lease and plant fuel
	MKK  Factor for converting coke from physical units to Btu
	MPB  Natural gas marketed production (btu)
	MPK  Factor for converting marketed natural gas production from physical units to Btu
	MPP  Natural gas marketed production (physical units)
	NNP  charging locations with both networked and non-networked ports
	NOP  charging locations with non-networked ports only
	NTP  charging locations with networked ports only
	OCB  consumed by industrial users other than coke plants
	OCD  price in the industrial sector other than coke plants
	OCK  Factor for converting energy consumed by industrial users other than coke plants from physical units to Btu
	OCP  consumed by industrial users other than coke plants
	OCV  expenditures in the industrial sector other than coke plants
	OPP  Resident population including Armed Forces
	OSB  consumed by the industrial sector other than coke plants excluding refinery fuel
	PFB  Total energy used as process fuel and other consumption that has no direct fuel costs
	PPP  charging locations with both public and private ports
	PRK  Factor for converting production from physical units to Btu
	PRV  Current-dollar
	PRX  Real 
	PUP  charging locations with public ports only
	PVP  charging locations with private ports only
	PZB  Natural gas for pipeline and distribution use
	R7P  Solar photovoltaic electricity generation by small-scale applications in the residential sector
	RCB  Consumed by the residential sector (btu)
	RCD  Price in the residential sector
	RCK  Factor for converting residential sector inputs from physical units to Btu 
	RCP  consumed by the residential sector
	RCV  expenditures in the residential sector
	RFB  consumed as refinery fuel
	RPB  Total energy consumption per capita in the residential sector
	RPP  consumed by (sales to ultimate customers in) the residential sector per capita
	RSB  Energy consumed in the residential sector at a cost
	RXB  Wood energy consumed in the residential sector at no cost
	TCD  Average price (all sectors)
	TCK  Factor for converting from physical units to Btu
	TCV  Total expenditures
	TGP  Solar thermal and photovoltaic electricity total net generation
	TGR  Total energy consumption per dollar of real gross domestic product (GDP)
	TPB  Total consumption per capita
	TPP  Total consumption per capita
	TPV  Total energy expenditures per capita
	TXD  Average price (all end-use sectors)
	TXK  Factor for converting natural gas used by end-use sectors from physical units to Btu
	TXV  Total end-use expenditures
	VHN  Vehicle stocks
	VHP  Electric vehicle (BEV) use
	VHS  Share of total light-duty vehicles

	FDB  production
	PRB  Production (btu)
	PRP  Production (physical units)

	TXP  Total end-use consumption
	TXB  Total end-use consumption
	TCP  Total consumption (physical units)
	TCB  Total consumption (btu)
	SUB  Consumption by the transportation sector
	SCB  Total consumption adjusted for process fuel

	ACB  consumed by the transportation sector
	ACD  average price in the transportation sector
	ACP  consumed by the transportation sector
	ACV  expenditures in the transportation sector
	ASB  Energy consumed by the transportation sector (adjusted for process fuel)
	CCB  consumed by the commercial sector
	CCD  price in the commercial sector
	CCP  consumed by the commercial sector
	CCV  expenditures in the commercial sector
	CSB  Energy consumed by the commercial sector - adjusted for process fuel
	EGB  consumed for electricity generation by the electric power sector
	EGD  fuel price in the electric power sector
	EIB  consumed by the electric power sector
	EID  price in the electric power sector
	EIP  consumed by the electric power sector
	EIV  expenditures in the electric power sector
	ETB  Nuclear energy consumed for electricity generation (total)
	ETD  Nuclear fuel average price (all sectors)
	ETP  Nuclear electricity total net generation
	ETV  Nuclear fuel total expenditures

	ICB  consumed by the industrial sector 
	ICD  price in the industrial sector (through 1985) "
	ICP  consumed by the industrial sector
	ICV  expenditures in the industrial sector
	ISB  consumed by the industrial sector adjusted for processed fuel
	IMB  imports (BTU)
	IMD  import price
	IMP  imports (physical units)
	IMV  imports expenditures
	NIB  Net import (BTU)
	NIP  Net imports (physical units)
	NIV  Net imports values

	EXB  exports (energy units)
	EXD  exports average price
	EXP  exports (physical units)
	EXV  exports expenditures

	/;

set	item_f(item,f)	Match items to fuels, 
	item_d(item,d)	Match items to data fields;

item_f(item,f) = ord(item.tl,1)=ord(f.tl,1) and 
		 ord(item.tl,2)=ord(f.tl,2);

item_d(item,d) = ord(item.tl,3)=ord(d.tl,1) and 
		 ord(item.tl,4)=ord(d.tl,2) and 
		 ord(item.tl,5)=ord(d.tl,3);


*	Which items have not been matched to fuels or data:

set	not_f(item), not_d(item);

option not_f<item_f; not_f(item) = not not_f(item);
option not_d<item_d; not_d(item) = not not_d(item);

option not_f:0:0:1, not_d:0:0:1
display not_f, not_d;

*	Transfer data from series to the data array:

parameter	data(f,d,r,t);
loop((map(item,r,id),item_f(item,f),item_d(item,d)),
  data(f,d,r,t) = series(id,t);
  series(id,t) = 0;
);

parameter	trade(*,f,r,t,*)	Trade data;
trade("btu",f,r,t,"M") = data(f,"imb",r,t); data(f,"imb",r,t) = 0;
trade("$",f,r,t,"M") = data(f,"imd",r,t); data(f,"imd",r,t) = 0;
trade("qty",f,r,t,"M") = data(f,"imp",r,t); data(f,"imp",r,t) = 0;
trade("val",f,r,t,"M") = data(f,"imv",r,t); data(f,"imv",r,t) = 0;

trade("btu",f,r,t,"NM") = data(f,"nib",r,t); data(f,"nib",r,t) = 0;
trade("qty",f,r,t,"NM") = data(f,"nip",r,t); data(f,"nip",r,t) = 0;
trade("val",f,r,t,"NM") = data(f,"niv",r,t); data(f,"niv",r,t) = 0;

trade("btu",f,r,t,"X") = data(f,"exb",r,t); data(f,"exb",r,t) = 0;
trade("$",f,r,t,"X") = data(f,"exd",r,t); data(f,"exd",r,t) = 0;
trade("qty",f,r,t,"X") = data(f,"exp",r,t); data(f,"exp",r,t) = 0;
trade("val",f,r,t,"X") = data(f,"exv",r,t); data(f,"exv",r,t) = 0;

trade("btu",f,r,t,"NM*") = trade("btu",f,r,t,"NM") - (trade("btu",f,r,t,"M") - trade("btu",f,r,t,"X"));
trade("qty",f,r,t,"NM*") = trade("qty",f,r,t,"NM") - (trade("qty",f,r,t,"M") - trade("qty",f,r,t,"X"));
trade("val",f,r,t,"NM*") = trade("val",f,r,t,"NM") - (trade("val",f,r,t,"M") - trade("val",f,r,t,"X"));
option trade:3:3:1; 
display trade;

option series:0:0:1;
display "Data which have not been relabelled:", series;

set	fd(f,d)	How are fuels and data items connected; 
option fd<data; 
fd(fd(f,d)) = d(d);
option fd:0:0:1; display fd;

set s	Sectors /
		ALL	Demand in all sector
		PRD	Production
		END	Total end use
		COM	Commercial
		IND	Industrial
		"IND*"  Industrial sector other than coke plants
		COK	Coke plants
		RES	Residential
		TRA	Transportation

		"ALL^"	Demand in all sectors adjusted for process fuel
		"COM^"	Commercial adjusted for process fuel
		"IND^"	Industrial adjusted for process fuel
		"TRA^"	Transportation adjusted for process fuel

		ELE	Electricity /;
*.		OTH	Other 


parameter	btu(f,s,r,t)		Sectoral energy use (btu)
		quant(f,s,r,t)		Sectoral inputs (quantity)
		expend(f,s,r,t)		Expenditures
		price(f,s,r,t)		Average price
		convert(f,s,r,t)	Conversion factor (phys to btu);
		

btu(f,"ind*",r,t) = data(f,"ocb",r,t); data(f,"ocb",r,t) = 0;
*	OCB  consumed by industrial users other than coke plants

quant(f,"ind*",r,t) = data(f,"ocp",r,t); data(f,"ocp",r,t) = 0;
*	OCP  consumed by industrial users other than coke plants

btu(f,"cok",r,t) =  data(f,"kcb",r,t); data(f,"kcb",r,t) = 0;
*	KCB  consumed at coke plants (coking coal)

btu(f,"prd",r,t) =  data(f,"prb",r,t); data(f,"prb",r,t) = 0;
*	PRB  Production (btu)

btu(f,"ind",r,t) = data(f,"icb",r,t); data(f,"icb",r,t) = 0;
*	ICB  consumed by the industrial sector

quant(f,"ind",r,t) = data(f,"icp",r,t); data(f,"icp",r,t) = 0;
*	ICP  consumed by the industrial sector

btu(f,"res",r,t) = data(f,"rcb",r,t); data(f,"rcb",r,t) = 0;
*	RCB  Consumed by the residential sector (btu)

quant(f,"res",r,t) = data(f,"rcp",r,t); data(f,"rcp",r,t) = 0;
*	RCP  consumed by the residential sector

btu(f,"tra",r,t) = data(f,"acb",r,t); data(f,"acb",r,t) = 0;
*	ACB  consumed by the transportation sector

quant(f,"tra",r,t) = data(f,"acp",r,t); data(f,"acp",r,t) = 0;
*	ACP  consumed by the transportation sector

btu(f,"com",r,t) = data(f,"ccb",r,t); data(f,"ccb",r,t) = 0;
*	CCB  consumed by the commercial sector

quant(f,"cok",r,t) = data(f,"kcp",r,t); data(f,"kcp",r,t) = 0;
*	KCP  by coke plants (coking coal)

quant(f,"prd",r,t) = data(f,"prp",r,t); data(f,"prp",r,t) = 0;
*	PRP  Production (physical units)

quant(f,"com",r,t) = data(f,"ccp",r,t); data(f,"ccp",r,t) = 0;
*	CCP  consumed by the commercial sector

btu(f,"ele",r,t) = data(f,"eib",r,t); data(f,"eib",r,t) = 0;
*	EIB  consumed by the electric power sector

quant(f,"ele",r,t) = data(f,"eip",r,t); data(f,"eip",r,t) = 0;
*	EIP  consumed by the electric power sector

btu(f,"end",r,t) = data(f,"txb",r,t); data(f,"txb",r,t) = 0;
*	TXB  Total end-use consumption

quant(f,"end",r,t) = data(f,"txp",r,t); data(f,"txp",r,t) = 0;
*	TXP  Total end-use consumption

btu(f,"all",r,t) = data(f,"tcb",r,t); data(f,"tcb",r,t) = 0;
*	TCB  Total consumption (btu)

*	Energy inputs adjusted for process fuels:

btu(f,"all^",r,t) = data(f,"scb",r,t); data(f,"scb",r,t) = 0;
btu(f,"tra^",r,t) = data(f,"asb",r,t); data(f,"asb",r,t) = 0;
btu(f,"com^",r,t) = data(f,"csb",r,t); data(f,"csb",r,t) = 0;
btu(f,"ind^",r,t) = data(f,"isb",r,t); data(f,"isb",r,t) = 0;


quant(f,"all",r,t) = data(f,"tcp",r,t); data(f,"tcp",r,t) = 0;
*	TCP  Total consumption (physical units)

expend(f,"ind",r,t) = data(f,"icv",r,t); data(f,"icv",r,t) = 0;
*	ICV  expenditures in the industrial sector

expend(f,"res",r,t) = data(f,"rcv",r,t); data(f,"rcv",r,t) = 0;
*	RCV  expenditures in the residential sector

expend(f,"all",r,t) = data(f,"tcv",r,t); data(f,"tcv",r,t) = 0;
*	TCV  Total expenditures

expend(f,"end",r,t) = data(f,"txv",r,t); data(f,"txv",r,t) = 0;
*	TXV  Total end-use expenditures

expend(f,"com",r,t) = data(f,"ccv",r,t); data(f,"ccv",r,t) = 0;
*	CCV  expenditures in the commercial sector

expend(f,"ele",r,t) = data(f,"eiv",r,t); data(f,"eiv",r,t) = 0;
*	EIV  expenditures in the electric power sector

price(f,"cok",r,t)$data(f,"kcd",r,t) = data(f,"kcd",r,t); data(f,"kcd",r,t) = 0;
*	KCD  price at coke plants

price(f,"ind",r,t) = data(f,"icd",r,t); data(f,"icd",r,t) = 0;
*	ICD   price in the industrial sector

price(f,"ind*",r,t) = data(f,"ocd",r,t); data(f,"ocd",r,t) = 0;
*	OCD  price in the industrial sector other than coke plants

price(f,"res",r,t) = data(f,"rcd",r,t); data(f,"rcd",r,t) = 0;
*	RCD  Price in the residential sector

price(f,"all",r,t) = data(f,"tcd",r,t); data(f,"tcd",r,t) = 0;
*	TCD  Average price (all sectors)

price(f,"end",r,t) = data(f,"txd",r,t); data(f,"txd",r,t) = 0;
*	TXD  Average price (all end-use sectors)

price(f,"tra",r,t) = data(f,"acd",r,t); data(f,"acd",r,t) = 0;
*	ACD  average price in the transportation sector

price(f,"com",r,t) = data(f,"ccd",r,t); data(f,"ccd",r,t) = 0;
*	CCD  price in the commercial sector


price(f,"ele",r,t) = data(f,"eid",r,t); data(f,"eid",r,t) = 0;
*	EID  price in the electric power sector

price(f,"ele",r,t)$data(f,"etd",r,t) = data(f,"etd",r,t); data(f,"etd",r,t) = 0;
*	EGD  nuclear fuel price in the electric power sector

parameter	cvrt(f,s,r,t)	Conversion factor from physical units to Btu;

*	Default conversion factor:

cvrt(f,s,r,t) = data(f,"tck",r,t); data(f,"tck",r,t) = 0;

set cvrtd(d) /
	CCK  Factor for converting commercial sector inputs from physical units to Btu for the United States
	CTK  "Factor for converting petroleum coke, catalyst coke from physical units to Btu"
	MKK  "Factor for converting petroleum coke, marketable coke from physical units to Btu"
	MPK  Factor for converting marketed natural gas production from physical units to Btu
	RCK  Factor for converting residential sector inputs from physical units to Btu
	KCK  Converting coal consumed at coke plants from physical units to Btu
	ETK  Electric power plant conversion factor from physical units to Btu
	ICK  Conversion for energy inputs in industry from physical units to Btu
	ACK  Factor for converting transportation sector consumption from physical units to Btu
	EIK  Factor for converting energy inputs tothe electric power sector from physical units to Btu
	HCK  Conversion factor for residential and commercial sectors from physical units to Btu
	OCK  Factor for converting energy consumed by industrial users other than coke plants from physical units to Btu
	PRK  Factor for converting production from physical units to Btu
	TXK  Factor for converting natural gas used by end-use sectors from physical units to Btu /;

set cvrtd_s(d,s) /
	CCK.COM  Factor for converting commercial sector inputs from physical units to Btu for the United States
	CTK.IND  "Factor for converting petroleum coke, catalyst coke from physical units to Btu"
	MKK.IND  "Factor for converting petroleum coke, marketable coke from physical units to Btu"
	MPK.PRD  Factor for converting marketed natural gas production from physical units to Btu
	RCK.RES  Factor for converting residential sector inputs from physical units to Btu
	KCK.COK  Converting coal consumed at coke plants from physical units to Btu
	ETK.ELE  Electric power plant conversion factor from physical units to Btu
	ICK.IND  Conversion for energy inputs in industry from physical units to Btu
	ACK.TRA  Factor for converting transportation sector consumption from physical units to Btu
	EIK.ELE  Factor for converting energy inputs to the electric power sector from physical units to Btu
	HCK.(RES,COM)  Conversion factor for residential and commercial sectors from physical units to Btu
	OCK.IND  Factor for converting energy consumed by industrial users other than coke plants from physical units to Btu
	PRK.PRD  Factor for converting production from physical units to Btu
	TXK.(RES,COM,IND)  Factor for converting natural gas used by end-use sectors from physical units to Btu /;

loop(cvrtd_s(d,s),
   cvrt(f,s,r,t)$data(f,d,r,t) = data(f,d,r,t); 
);
loop(cvrtd_s(d,s),
  data(f,d,r,t) = 0;
);

parameter	percap(*,f,s,r,t)	Per capital consumption and expenditure;

*	Per-capital consumptioN:

percap("exp", f,"all",r,t)$data(f,"tpv",r,t) = data(f,"tpv",r,t); data(f,"tpv",r,t)=0;
percap("btu", f,"all",r,t)$data(f,"tpb",r,t) = data(f,"tpb",r,t); data(f,"tpb",r,t)=0;
percap("phy", f,"all",r,t)$data(f,"tpp",r,t) = data(f,"tpp",r,t); data(f,"tpp",r,t)=0;
percap("btu", f,"tra",r,t)$data(f,"apb",r,t) = data(f,"apb",r,t); data(f,"apb",r,t)=0;
percap("phy", f,"res",r,t)$data(f,"rpp",r,t) = data(f,"rpp",r,t); data(f,"rpp",r,t)=0;
percap("btu", f,"res",r,t)$data(f,"rpb",r,t) = data(f,"rpb",r,t); data(f,"rpb",r,t)=0;
percap("btu", f,"ind",r,t)$data(f,"ipb",r,t) = data(f,"ipb",r,t); data(f,"ipb",r,t)=0;
percap("btu", f,"com",r,t)$data(f,"cpb",r,t) = data(f,"cpb",r,t); data(f,"cpb",r,t)=0;

set	evd(d) /
	0CN  charging ports for electric vehicles
	1CN  Level 1 charging ports
	2CN  Level 2 charging ports
	2CR  Level 2 charging ports per location
	CHN  Total charging ports
	CHP  charging locations
	DCN  DC fast charging ports for electric vehicles
	DCR  DC fast charging ports per location
	NNP  charging locations with both networked and non-networked ports
	NOP  charging locations with non-networked ports only
	NTP  charging locations with networked ports only
	PPP  charging locations with both public and private ports
	PUP  charging locations with public ports only
	PVP  charging locations with private ports only /;

parameter	evdata		EV data;
evdata(evd,r,t) = data("ev",evd,r,t); data("ev",evd,r,t) = 0;

set	dpd/cdp,hdp/;
parameter	degday(*,r,t)	Degree days;
degday(dpd(d),r,t) = data("zw",d,r,t); data("zw",d,r,t) = 0;

parameter	expend(f,s,r,t)	Fuel expenditures;
expend(f,"ele",r,t)$data(f,"egv",r,t) = data(f,"egv",r,t); data(f,"acv",r,t) = 0;
expend(f,"tra",r,t)$data(f,"acv",r,t) = data(f,"acv",r,t); data(f,"acv",r,t) = 0;
expend(f,"ind",r,t)$data(f,"ocv",r,t) = data(f,"ocv",r,t); data(f,"ocv",r,t) = 0;
expend(f,"cok",r,t)$data(f,"kcv",r,t) = data(f,"kcv",r,t); data(f,"kcv",r,t) = 0;
expend(f,"ele",r,t)$data(f,"egv",r,t) = data(f,"egv",r,t); data(f,"egv",r,t) = 0;
expend(f,"all",r,t)$data(f,"etv",r,t) = data(f,"etv",r,t); data(f,"etv",r,t) = 0;


set	unread(d)	Data items which have not been read;
option unread<data;
unread(unread(d)) = d(d);

option unread:0:0:1;
display unread;

$exit

quant(f,"osb",r,t) = data(f,"osb",r,t); data(f,"osb",r,t) = 0;
*	CL .OSB  consumed by the industrial sector other than coke plants excluding refinery fuel
quant(f,"isb",r,t) = data(f,"isb",r,t); data(f,"isb",r,t) = 0;
*	CL .ISB  consumed by the industrial sector adjusted for processed fuel

expend(f,"ocv",r,t) = data(f,"ocv",r,t); data(f,"ocv",r,t) = 0;
*	CL .OCV  expenditures in the industrial sector other than coke plants

price(f,"icd",r,t) = data(f,"icd",r,t); data(f,"icd",r,t) = 0;

