$title	Read State-Level Public Finance Data

$if set merge $goto merge
$if set ds    $goto readds

$if not dexist asfin\data $call mkdir asfin\data

$call gams readASFIN --ds="2022 ASFIN State Totals.xlsx" --yr=2022 --rf=r1 --rd=r2*r83 o=asfin\readASFIN2022.lst gdx=asfin\data\2022.gdx
$call gams readASFIN --ds="ASFIN FY2021_2020.xlsx" --yr=2021 --rf=r1 --rd=r3*r59  o=asfin\readASFIN2021.lst gdx=asfin\data\2021.gdx
$call gams readASFIN --ds="ASFIN FY2020_2019.xlsx" --yr=2020 --rf=r1 --rd=r3*r59  o=asfin\readASFIN2020.lst gdx=asfin\data\2020.gdx
$call gams readASFIN --ds="ASFIN FY2019_2018.xlsx" --yr=2019 --rf=r1 --rd=r3*r59  o=asfin\readASFIN2019.lst gdx=asfin\data\2019.gdx
$call gams readASFIN --ds="ASFIN FY2018_2017.xlsx" --yr=2018 --rf=r1 --rd=r3*r59  o=asfin\readASFIN2018.lst gdx=asfin\data\2018.gdx
$call gams readASFIN --ds="2017_ASFIN_State_Totals.xlsx" --yr=2017 --rf=r1 --rd=r2*r58 o=asfin\readASFIN2017.lst gdx=asfin\data\2017.gdx
$call gams readASFIN --ds="2016_ASFIN_State_Totals.xlsx" --yr=2016 --rf=r1 --rd=r2*r58 o=asfin\readASFIN2016.lst gdx=asfin\data\2016.gdx
$call gams readASFIN --ds="2015_ASFIN_State_Totals.xlsx" --yr=2015 --rf=r1 --rd=r2*r58 o=asfin\readASFIN2015.lst gdx=asfin\data\2015.gdx
$call gams readASFIN --ds="2014_ASFIN_State_Totals.xlsx" --yr=2014 --rf=r1 --rd=r2*r58 o=asfin\readASFIN2014.lst gdx=asfin\data\2014.gdx
$call gams readASFIN --ds="2013_ASFIN_State_Totals.xlsx" --yr=2013 --rf=r1 --rd=r2*r58 o=asfin\readASFIN2013.lst gdx=asfin\data\2013.gdx
$call gams readASFIN --ds="2012_ASFIN_State_Totals.xlsx" --yr=2012 --rf=r1 --rd=r2*r58 o=asfin\readASFIN2012.lst gdx=asfin\data\2012.gdx
$call gams readASFIN --ds="11statess.xls" --yr=2011 --rf=r6 --rd=r8*r64 o=asfin\readASFIN2011.lst gdx=asfin\data\2011.gdx
$call gams readASFIN --ds="10statess.xls" --yr=2010 --rf=r6 --rd=r8*r64 o=asfin\readASFIN2010.lst gdx=asfin\data\2010.gdx
$call gams readASFIN --ds="09statess.xls" --yr=2009 --rf=r6 --rd=r8*r64 o=asfin\readASFIN2009.lst gdx=asfin\data\2009.gdx
$call gams readASFIN --ds="08statess.xls" --yr=2008 --rf=r6 --rd=r8*r64 o=asfin\readASFIN2008.lst gdx=asfin\data\2008.gdx
$call gams readASFIN --ds="07statess.xls" --yr=2007 --rf=r6 --rd=r8*r64 o=asfin\readASFIN2007.lst gdx=asfin\data\2007.gdx

$call gams readasfin --merge=yes o=asfin\merge.lst

$exit

*	Start here reading data for a single year.

$label readds

$if not set rf  $set rf r1
$if not set yr  $set yr 2022
$if not set ds  $set ds 2022 ASFIN State Totals.xlsx
$if not set rd  $set rd r2*r83

*	NB Data sets for 2018-2021 are two-year reports.  
*	All other datasets are annual.

$set fmt annual
$eval twoyear 1$(%yr%>=2018 and %yr%<=2021)
$if %twoyear%==1  $set fmt twoyear

$call xlsdump asfin\"%ds%" asfin\%yr%.gdx
$call gdxdump asfin\%yr%.gdx  nodata output=asfin\%yr%.gms
$include asfin\%yr%.gms

set	usps(*)		USPS codes for states,
	state(*)	State names;

set	uspsmap(usps<,state<) /
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

set	rd(r)	Rows containing data /%rd%/

alias (i,*);

parameter data(r,i,usps)	State Government Finances (million dollars);

$if %fmt%==twoyear $goto twoyear

$label annual
alias (vu,vur,vuc);
loop((vuc("s1","%rf%",c,state),uspsmap(usps,state)),
  loop(vur("s1",rd(r),"c1",i),
	data(r,i,usps) = 0.001 * vf("s1",r,c);
	vf("s1",r,c) = 0;
  );
);
option data:0:2:1;
display data;

option vf:0:0:1;
display vf;

$exit

$label twoyear

alias (vu,vur,vuc,vufy);

alias (vu,vur,vuc);
loop((vuc("s1","%rf%",c,state),uspsmap(usps,state),vufy("s1","r2",c,"FY%yr%")),
  loop(vur("s1",rd(r),"c1",i),
	data(r,i,usps) = vf("s1",r,c);
	vf("s1",r,c) = 0;
  );
);
option data:0:2:1;
display data;

option vf:0:0:1;
display vf;

$exit

$label merge

$title	Merge the ASFIN database

set	r	States /
	AL, AK, AR, AZ, CA, CO, CT, DC, DE, FL, GA, HI, IA, ID, IL, IN, KS,
	KY, LA, MA, MD, ME, MI, MN, MO, MS, MT, NC, ND, NE, NH, NJ, NM, NV,
	NY, OH, OK, OR, PA, RI, SC, SD, TN, TX, UT, VA, VT, WA, WV, WI, WY /;

set	row /r1*r100/;

set	i	Data items/
        "Total revenue"
        "  General revenue"
        "    Intergovernmental revenue"
        "    Total Taxes"
        "    Taxes",
        "      Property Taxes"
        "      Sales and Gross Receipts Taxes"
        "      General sales"
        "        General Sales and Gross Receipts Taxes"
        "        Selective Sales and Gross Receipts Taxes"
        "      Selective sales"
        "          Alcoholic Beverages Sales Tax"
        "          Amusements Sales Tax"
        "          Insurance Premiums Sales Tax"
        "          Motor Fuels Sales Tax"
        "          Pari-mutuels Sales Tax"
        "          Public Utilities Sales Tax"
        "          Tobacco Products Sales Tax"
        "          Other Selective Sales and Gross Receipts Taxes"
        "      License taxes"
        "        Alcoholic Beverages License"
        "        Amusements License"
        "        Corporations in General License"
        "        Hunting and Fishing License"
        "        Motor Vehicle License"
        "        Motor Vehicle Operators License"
        "        Public Utilities License"
        "        Occupation and Business License, NEC"
        "        Other License Taxes"
        "      Income Taxes"
        "      Individual income tax"
        "      Corporate income tax"
        "        Individual Income Taxes"
        "        Corporations Net Income Taxes"
        "      Other taxes"
        "        Death and Gift Taxes"
        "        Documentarty and Stock Transfer Taxes"
        "        Severance Taxes"
        "        Taxes, NEC"
        "    Current charge"
        "    Current charges"
        "    Miscellaneous general revenue"
        "  Utility revenue"
        "  Liquor stores revenue"
        "  Insurance trust revenue"
        "  Insurance trust revenue (1)",
        "Total expenditure"
        "  Intergovernmental expenditure"
        "  Direct expenditure"
        "    Current operation"
        "    Capital outlay"
        "    Insurance benefits and repayments"
        "    Assistance and subsidies"
        "    Interest on debt"
        "Exhibit: Salaries and wages"
        "Total expenditure*"
        " General expenditure"
        "    Intergovernmental expenditure"
        "    Direct expenditure"
        "    Education"
        "    Public welfare"
        "    Hospitals"
        "    Health"
        "    Highways"
        "    Police protection"
        "    Correction"
        "    Natural resources"
        "    Parks and recreation"
        "    Governmental administration"
        "    Interest on general debt"
        "    Other and unallocable"
        "  Utility expenditure"
        "  Liquor stores expenditure"
        "  Insurance trust expenditure"
        "Debt at end of fiscal year"
        "Cash and security holdings"/;

set	yr/2007*2022/;

parameter	data(yr,row,i,r)	State Government Finances;
$call gdxmerge asfin\data\*.gdx 
$gdxin merged.gdx
$loaddc data

set		yr_row_i(yr,row,i);
option yr_row_i<data;
option yr_row_i:0:0:1;
display yr_row_i;

parameter	asfin(yr,i,r)	State government finances;
asfin(yr,i,r) = sum(row,data(yr,row,i,r));

parameter	assigned;
loop(yr,
	assigned = no;
	loop(yr_row_i(yr,row,"Total expenditure"),
	  assigned = yes;
	  asfin(yr,"Total expenditure",r)$(not assigned) = data(yr,row,"Total expenditure",r);
	  asfin(yr,"Total expenditure*",r)$assigned = data(yr,row,"Total expenditure",r);
	);
);

set	j(i);
option j<asfin;
option j:0:0:1;
display j;

execute_unload 'asfin.gdx',asfin, i;
