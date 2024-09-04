$title	Read the EMISS Dataset (U.S. Carbon Emissions data)

$if not exist EMISS.gdx $call gams readbulk --dataset=EMISS

$gdxin 'EMISS.gdx'

set
  t  'date/year'
  id 'series_id from txt file, explanatory text has name'
  e  'error strings where we have for NA (not available)'
  errors(id,t,e<) 'could not extract a value from these';

parameter
   series(id,t<) 'data for each series';

$load id 
$loaddc series errors

option id:0:0:1;
display id;

$exit

$if not set action $set action partition

$if not exist sedsmap.gms $call gams seds --action=mapgen
$ifthen.mapgen %action%==mapgen
file kmap /sedsmap.gms/; kmap.lw=0; put kmap; loop(id, put id.tl,'."',id.tl,'"'/; );
$exit
$endif.mapgen

set	seds		/seds/
	annual		/a/
	item(*)		Items /
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


set	map(seds,item,r,annual,id) /
$offlisting
$include sedsmap
$onlisting
/;

