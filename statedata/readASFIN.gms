$title	Read State-Level Public Finance Data

$if set ds $goto readds

$call gams readASFIN --ds="2022 ASFIN State Totals.xlsx" --yr=2022 --rf=r1 --rd=r2*r83 o=readASFIN2022.lst
$call gams readASFIN --ds="ASFIN FY2021_2020.xlsx" --yr=2021 --rf=r1 --rd=r3*r59  o=readASFIN2021.lst
$call gams readASFIN --ds="ASFIN FY2020_2019.xlsx" --yr=2020 --rf=r1 --rd=r3*r59  o=readASFIN2020.lst
$call gams readASFIN --ds="ASFIN FY2019_2018.xlsx" --yr=2019 --rf=r1 --rd=r3*r59  o=readASFIN2019.lst
$call gams readASFIN --ds="ASFIN FY2018_2017.xlsx" --yr=2018 --rf=r1 --rd=r3*r59  o=readASFIN2018.lst
$call gams readASFIN --ds="2017_ASFIN_State_Totals.xlsx" --yr=2017 --rf=r1 --rd=r2*r58 o=readASFIN2017.lst
$call gams readASFIN --ds="2016_ASFIN_State_Totals.xlsx" --yr=2016 --rf=r1 --rd=r2*r58 o=readASFIN2016.lst
$call gams readASFIN --ds="2015_ASFIN_State_Totals.xlsx" --yr=2015 --rf=r1 --rd=r2*r58 o=readASFIN2015.lst
$call gams readASFIN --ds="2014_ASFIN_State_Totals.xlsx" --yr=2014 --rf=r1 --rd=r2*r58 o=readASFIN2014.lst
$call gams readASFIN --ds="2013_ASFIN_State_Totals.xlsx" --yr=2013 --rf=r1 --rd=r2*r58 o=readASFIN2013.lst
$call gams readASFIN --ds="2012_ASFIN_State_Totals.xlsx" --yr=2012 --rf=r1 --rd=r2*r58 o=readASFIN2012.lst
$call gams readASFIN --ds="11statess.xls" --yr=2011 --rf=r6 --rd=r8*r64 o=readASFIN2011.lst
$call gams readASFIN --ds="10statess.xls" --yr=2010 --rf=r6 --rd=r8*r64 o=readASFIN2010.lst
$call gams readASFIN --ds="09statess.xls" --yr=2009 --rf=r6 --rd=r8*r64 o=readASFIN2009.lst
$call gams readASFIN --ds="08statess.xls" --yr=2008 --rf=r6 --rd=r8*r64 o=readASFIN2008.lst
$call gams readASFIN --ds="07statess.xls" --yr=2007 --rf=r6 --rd=r8*r64 o=readASFIN2007.lst

$call gdxmerge asfin\20*.gdx id=data output=aasfin.gdx

$exit

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

alias (u,*);

set	rd(r)	Rows containing data /%rd%/

parameter data(r,u,usps)	State Government Finances (million dollars);

$if %fmt%==twoyear $goto twoyear

$label annual
alias (vu,vur,vuc);
loop((vuc("s1","%rf%",c,state),uspsmap(usps,state)),
  loop(vur("s1",rd(r),"c1",u),
	data(r,u,usps) = 0.001 * vf("s1",r,c);
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
  loop(vur("s1",rd(r),"c1",u),
	data(r,u,usps) = vf("s1",r,c);
	vf("s1",r,c) = 0;
  );
);
option data:0:2:1;
display data;

option vf:0:0:1;
display vf;
