$title	Read the State Consumer Expenditure Data

*	https://apps.bea.gov/regional/downloadzip.htm

set	seq /0*99999/;


$ifthen.sapcev not exist sapcev.gdx

$call csv2gdx i=sapce\SAPCE1__ALL_AREAS_1997_2022.csv o=%gams.scrdir%sapce1.gdx id=v index=2,5 values=9..34 useheader=y >sapce.log
$call csv2gdx i=sapce\SAPCE2__ALL_AREAS_1997_2022.csv o=%gams.scrdir%sapce2.gdx id=v index=2,5 values=9..34 useheader=y >>sapce.log
$call csv2gdx i=sapce\SAPCE3__ALL_AREAS_1997_2022.csv o=%gams.scrdir%sapce3.gdx id=v index=2,5 values=9..34 useheader=y >>sapce.log
$call csv2gdx i=sapce\SAPCE4__ALL_AREAS_1997_2022.csv o=%gams.scrdir%sapce4.gdx id=v index=2,5 values=9..34 useheader=y >>sapce.log

$call gdxmerge %gams.scrdir%sapce*.gdx output=sapcev.gdx

$endif.sapcev

$ifthen.sapceh not exist sapceh.gdx
$call gams sapceHeirarchy --ds		      =1 gdx=%gams.scrdir%sapce1.gdx o=h_ds1.lst
$call gams sapceHeirarchy --ds		      =2 gdx=%gams.scrdir%sapce2.gdx o=h_ds2.lst
$call gams sapceHeirarchy --ds		      =3 gdx=%gams.scrdir%sapce3.gdx o=h_ds3.lst
$call gams sapceHeirarchy --ds		      =4 gdx=%gams.scrdir%sapce4.gdx o=h_ds4.lst

$call gdxmerge %gams.scrdir%sapce*.gdx output=sapceh.gdx id=Lm,lno

$endif.sapceh

set	tbl /
	sapce1	Personal consumption expenditures (PCE) by major type of product
	sapce2	Per capita personal consumption expenditures (PCE) by major type of product
	sapce3	Personal consumption expenditures (PCE) by state by type of product
	sapce4	Personal consumption expenditures (PCE) by state by function /,

	r(*)	States (long names),

	s	States /	
	AL	"Alabama",
	AK	"Alaska",
	AR	"Arizona",
	AZ	"Arkansas",
	CA	"California",
	CO	"Colorado",
	CT	"Connecticut",
	DC	"District of Columbia",
	DE	"Delaware",
	FL	"Florida",
	GA	"Georgia",
	HI	"Hawaii",
	IA	"Iowa",
	ID	"Idaho",
	IL	"Illinois",
	IN	"Indiana",
	KS	"Kansas",
	KY	"Kentucky",
	LA	"Louisiana",
	MA	"Massachusetts",
	MD	"Maryland",	
	ME	"Maine",
	MI	"Michigan",
	MN	"Minnesota",
	MO	"Missouri",
	MS	"Mississippi",	
	MT	"Montana",
	NC	"North Carolina",
	ND	"North Dakota",
	NE	"Nebraska",
	NH	"New Hampshire",
	NJ	"New Jersey",
	NM	"New Mexico",
	NV	"Nevada",
	NY	"New York",
	OH	"Ohio",
	OK	"Oklahoma",
	OR	"Oregon",
	PA	"Pennsylvania",
	RI	"Rhode Island",
	SC	"South Carolina",
	SD	"South Dakota",
	TN	"Tennessee",
	TX	"Texas",
	UT	"Utah",
	VA	"Virginia",
	VT	"Vermont",
	WA	"Washington",
	WV	"West Virginia",
	WI	"Wisconsin",
	WY	"Wyoming"/

	row(*)	Line numbers,

	yr	Years /1997*2022/;


parameter	v(tbl,r<,row<,yr);
$gdxin 'sapcev.gdx'
$onUNDF
$loaddc v

set	s_r(s,r) /
	AL."Alabama",
	AK."Alaska",
	AR."Arizona",
	AZ."Arkansas",
	CA."California",
	CO."Colorado",
	CT."Connecticut",
	DC."District of Columbia",
	DE."Delaware",
	FL."Florida",
	GA."Georgia",
	HI."Hawaii",
	IA."Iowa",
	ID."Idaho",
	IL."Illinois",
	IN."Indiana",
	KS."Kansas",
	KY."Kentucky",
	LA."Louisiana",
	MA."Massachusetts",
	MD."Maryland",	
	ME."Maine",
	MI."Michigan",
	MN."Minnesota",
	MO."Missouri",
	MS."Mississippi",	
	MT."Montana",
	NC."North Carolina",
	ND."North Dakota",
	NE."Nebraska",
	NH."New Hampshire",
	NJ."New Jersey",
	NM."New Mexico",
	NV."Nevada",
	NY."New York",
	OH."Ohio",
	OK."Oklahoma",
	OR."Oregon",
	PA."Pennsylvania",
	RI."Rhode Island",
	SC."South Carolina",
	SD."South Dakota",
	TN."Tennessee",
	TX."Texas",
	UT."Utah",
	VA."Virginia",
	VT."Vermont",
	WA."Washington",
	WV."West Virginia",
	WI."Wisconsin",
	WY."Wyoming"/;


*	Convert negative values

set	negval(tbl,row)	Negative values /
	sapce1.24   Less: Receipts from sales of goods and services by nonprofit institutions
	sapce2.24   Less: Receipts from sales of goods and services by nonprofit institutions
	sapce3.110  Less: Expenditures in the United States by nonresidents
	sapce3.113  Less: Receipts from sales of goods and services by nonprofit institutions
	sapce4.130  Less: Expenditures in the United States by nonresidents
	sapce4.134  Less: Receipts from sales of goods and services by nonprofit institutions
/;
v(tbl,r,row,yr)$negval(tbl,row) = -v(tbl,r,row,yr);

alias (i,j,row);

set	lm(tbl,i,j)	Subtotals definitions,
	lno(tbl,j)	Line numbers;

$gdxin sapceh.gdx
$loaddc lm lno

option lm:0:0:1;
display lm;

set	k(*)	Commodity labels;

set	smap(tbl,row,k<)  Mapping from row number to sectors (Tables 1 and 2) /
$eolcom !
  (sapce1,sapce2).(
	4.mvp    ! Motor vehicles and parts
	5.dhe    ! Furnishings and durable household equipment
	6.rgv    ! Recreational goods and vehicles
	7.odg    ! Other durable goods
	9.fbv    ! Food and beverages purchased for off-premises consumption
	10.clo   ! Clothing and footwear
	11.gas   ! Gasoline and other energy goods
	12.ong   ! Other nondurable goods
	15.hou   ! Housing and utilities
	16.hea   ! Health care
	17.trn   ! Transportation services
	18.rec   ! Recreation services
	19.rst   ! Food services and accommodations
	20.fin   ! Financial services and insurance
	21.ser   ! Other services
	23.npf   ! Gross output of nonprofit institutions
	24.nps   ! Less: Receipts from sales of goods and services by nonprofit institutions
  )
  (sapce3).(
	5.nmv    ! New motor vehicles
	6.umv    ! Net purchases of used motor vehicles
	7.mvp    ! Motor vehicle parts and accessories
	9.frn    ! Furniture and furnishings
	10.app   ! Household appliances
	11.gls   ! Glassware, tableware, and household utensils
	12.eqp   ! Tools and equipment for house and garden
	14.med   ! Video, audio, photographic, and information processing equipment and media
	15.spt   ! Sporting equipment, supplies, guns, and ammunition
	16.rvs   ! Sports and recreational vehicles
	17.rbk   ! Recreational books
	18.mus   ! Musical instruments
	20.jwl   ! Jewelry and watches
	21.thr   ! Therapeutic appliances and equipment
	22.ebk   ! Educational books
	23.lug   ! Luggage and similar personal items
	24.eqp   ! Telephone and related communication equipment
	27.fbv   ! Food and nonalcoholic beverages purchased for off-premises consumption
	28.alc   ! Alcoholic beverages purchased for off-premises consumption
	29.frm   ! Food produced and consumed on farms
	32.wcl   ! Women's and girls' clothing
	33.mcl   ! Men's and boys' clothing
	34.ccl   ! Children's and infants' clothing
	35.ocl   ! Other clothing materials and footwear
	37.mvf   ! Motor vehicle fuels, lubricants, and fluids
	38.oil   ! Fuel oil and other fuels
	40.med   ! Pharmaceutical and other medical products
	41.rgd   ! Recreational items
	42.hsp   ! Household supplies
	43.pcp   ! Personal care products
	44.tob   ! Tobacco
	45.mag   ! Magazines, newspapers, and stationery
	46.nea   ! Net expenditures abroad by U.S. residents
	51.rnt   ! Rental of tenant-occupied nonfarm housing
	52.imp   ! Imputed rental of owner-occupied nonfarm housing
	53.frm   ! Rental value of farm dwellings
	54.grp   ! Group housing
	56.wtr   ! Water supply and sanitation
	58.ele   ! Electricity
	59.gas   ! Natural gas
	62.phy   ! Physician services
	63.dnt   ! Dental services
	64.pms   ! Paramedical services
	66.hsp   ! Hospitals
	67.nrs   ! Nursing homes
	70.mvm   ! Motor vehicle maintenance and repair
	71.omv   ! Other motor vehicle services
	73.grd   ! Ground transportation
	74.air   ! Air transportation
	75.wtr   ! Water transportation
	77.clb   ! Membership clubs, sports centers, parks, theaters, and museums
	78.avs   ! Audio-video, photographic, and information processing equipment services
	79.gam   ! Gambling
	80.ors   ! Other recreational services
	83.rst   ! Purchased meals and beverages
	84.caf   ! Food furnished to employees (including military)
	85.acc   ! Accommodations
	88.fsr   ! Financial services furnished without payment
	89.fsc   ! Financial service charges, fees, and commissions
	91.lin   ! Life insurance
	92.hdi   ! Net household insurance
	93.hin   ! Net health insurance
	94.min   ! Net motor vehicle and other transportation insurance
	97.tel   ! Telecommunication services
	98.pst   ! Postal and delivery services
	99.int   ! Internet access
	101.uni  ! Higher education
	102.sch  ! Nursery, elementary, and secondary schools
	103.voc  ! Commercial and vocational schools
	104.prf  ! Professional and other services
	105.pcr  ! Personal care and clothing services
	106.srs  ! Social services and religious activities
	107.hmc  ! Household maintenance
	109.ftr  ! Foreign travel by U.S. residents
	110.nrs  ! Less: Expenditures in the United States by nonresidents
	112.npf  ! Gross output of nonprofit institutions
	113.nps  ! Less: Receipts from sales of goods and services by nonprofit institutions 
  ),
  (sapce4).(
	4.fbv    ! Food and nonalcoholic beverages purchased for off-premises consumption
	5.alc    ! Alcoholic beverages purchased for off-premises consumption
	6.frm    ! Food produced and consumed on farms
	10.wcl   ! Women's and girls' clothing
	11.mcl   ! Men's and boys' clothing
	12.ccl   ! Children's and infants' clothing
	13.ocl   ! Other clothing materials
	15.ldc   ! Laundry and dry cleaning services
	16.cra   ! Clothing repair, rental, and alterations
	17.sho   ! Footwear
	20.rnt   ! Rental of tenant-occupied nonfarm housing
	21.imp   ! Imputed rental of owner-occupied nonfarm housing
	22.frm   ! Rental value of farm dwellings
	23.grp   ! Group housing
	25.wtr   ! Water supply and sanitation
	27.ele   ! Electricity
	28.gas   ! Natural gas
	29.oil   ! Fuel oil and other fuels
	31.frn   ! Furniture, furnishings, and floor coverings
	32.htx   ! Household textiles
	33.app   ! Household appliances
	34.gls   ! Glassware, tableware, and household utensils
	35.eqp   ! Tools and equipment for house and garden
	36.hgs   ! Other household goods and services
	40.phm   ! Pharmaceutical products
	41.omp   ! Other medical products
	42.thr   ! Therapeutic appliances and equipment
	44.phy   ! Physician services
	45.dnt   ! Dental services
	47.hhc   ! Home health care
	48.lab   ! Medical laboratories
	49.ops   ! Other professional medical services
	51.hsp   ! Hospitals
	52.nrs   ! Nursing homes
	55.nmv   ! New motor vehicles
	56.umv   ! Net purchases of used motor vehicles
	58.mvp   ! Motor vehicle parts and accessories
	59.mvf   ! Motor vehicle fuels, lubricants, and fluids
	60.mvm   ! Motor vehicle maintenance and repair
	61.omv   ! Other motor vehicle services
	63.grd   ! Ground transportation
	64.air   ! Air transportation
	65.wtr   ! Water transportation
	67.eqp   ! Telephone and related communication equipment
	69.usp   ! First-class postal service by U.S. Postal Service (USPS)
	70.ods   ! Other delivery services (by non-USPS facilities)
	71.tel   ! Telecommunication services
	72.int   ! Internet access
	75.vae   ! Video and audio equipment
	76.cmp   ! Information processing equipment
	77.vsr   ! Services related to video and audio goods and computers
	79.rvs   ! Sports and recreational vehicles
	80.spt   ! Other sporting and recreational goods
	81.mvm   ! Maintenance and repair of recreational vehicles and sports equipment
	83.clb   ! Membership clubs and participant sports centers
	84.amu   ! Amusements parks, campgrounds, and related recreational services
	86.mov   ! Motion picture theaters
	87.liv   ! Live entertainment, excluding sports
	88.spt   ! Spectator sports
	89.lib   ! Museums and libraries
	90.mag   ! Magazines, newspapers, books, and stationery
	91.gam   ! Gambling
	92.pet   ! Pets, pet products, and related services
	93.pho   ! Photographic goods and services
	94.ptr   ! Package tours
	96.ebk   ! Educational books
	97.uni   ! Higher education
	98.sch   ! Nursery, elementary, and secondary schools
	99.voc   ! Commercial and vocational schools
	102.rst  ! Purchased meals and beverages
	103.caf  ! Food furnished to employees (including military)
	104.acc  ! Accommodations
	107.fsr  ! Financial services furnished without payment
	108.fsc  ! Financial service charges, fees, and commissions
	110.lin  ! Life insurance
	111.hdi  ! Net household insurance
	113.hin  ! Medical care and hospitalization
	114.los  ! Income loss
	115.wcm  ! Workers' compensation
	116.min  ! Net motor vehicle and other transportation insurance
	118.pcr  ! Personal care
	119.itm  ! Personal items
	120.srs  ! Social services and religious activities
	122.lgl  ! Legal services
	123.bsr  ! Accounting and other business services
	124.lod  ! Labor organization dues
	125.pad  ! Professional association dues
	126.fun  ! Funeral and burial services
	127.tob  ! Tobacco
	129.ftr  ! Foreign travel by U.S. residents
	130.nrs  ! Less: Expenditures in the United States by nonresidents
	131.nea  ! Net expenditures abroad by U.S. residents
	133.npf  ! Gross output of nonprofit institutions
	134.nps  ! Less: Receipts from sales of goods and services by nonprofit institutions
  ) /;

*	Add descriptive text:

smap(tbl,row,k)$smap(tbl,row,k) = lno(tbl,row);
option smap:0:0:1;
display smap;

set	g(tbl,j)	Goods;
option g<lm;

parameter	sapce(s,k,yr,tbl)	State Annual GDP dataset;

*	Convert to USPS state labels s:

loop(smap(g(tbl,row),k),
  sapce(s,k,yr,tbl) = sum(s_r(s,r),v(tbl,r,row,yr));
);
option sapce:1:3:1;
display sapce;

parameter	chk	Totals which do not add up;

chk(tbl,s,yr,k,"$") = sum((s_r(s,r),smap(tbl,row,k)),v(tbl,r,row,yr)) - sapce(s,k,yr,tbl);

chk(tbl,s,yr,k,"%")$sapce(s,k,yr,tbl) = 
    100 * (1 - sum((s_r(s,r),smap(tbl,row,k)),v(tbl,r,row,yr)) / sapce(s,k,yr,tbl));

option chk:1:4:1;
display chk;

set drop(tbl,s,yr,row);
drop(tbl,s,yr,row) = (	(not round(chk(tbl,s,yr,row,"%"))) or
			(not round(chk(tbl,s,yr,row,"$"))) );
chk(drop,"$") = 0;
chk(drop,"%") = 0;

option chk:1:4:1;
display chk;

execute_unload 'sapce.gdx',sapce, smap, lm;
