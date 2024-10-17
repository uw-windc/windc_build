$title	Read the SAINC datasets

*	https://apps.bea.gov/regional/downloadzip.htm

parameter
*	---------------------- Labor market data -- could be useful
	d_5n	"Personal income by major component and earnings by NAICS industry",
	d_6N	"Compensation of employees by NAICS industry",
	d_7N	"Wages and salaries by industry (NAICS)",
	d_25N	"Total full-time and part-time employment by NAICS industry",
	d_27N	"Full-time and part-time wage and salary employment by NAICs industry",
*	----------------------  Summary data -- could be useful
	d_1	"State annual personal income summary: personal income, population, per capita personal income",
	d_4	"Personal income and employment by major component",
	d_30	"Economic profile",
	d_35	"Personal current transfer receipts",
	d_40	"Property income",
	d_45	"Farm income and expenses",
	d_50	"Personal current taxes",
	d_51	"State annual disposable personal income summary: disposable personal income, population, and per capita disposable personal income",
	d_5H	"Personal income by major component and earnings by industry (historical)",
	d_70	"Transactions of state and local government defined benefit pension plans",
	d_91	"Gross flow of earnings",
	d_5S	"Personal income by major component and earnings by SIC industry",
	d_6S	"Compensation of employees by SIC industry",
	d_7H	"Wages and salaries by industry (historical)",
	d_7S	"Wages and salaries by industry (SIC)",
	d_25S	"Total full-time and part-time employment by SIC industry";

set	seq /0*3000/;
set	yr /1900*2024/,	row /r1*r2000/;

set	s(*)	States (USPS codes)

set	rmap(s<,*) /
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

$onechov >%gams.scrdir%readtable.gms

$eval lc %lyr%-%fyr%+9
$call csv2gdx i=sainc\%prefix%%t%__ALL_AREAS_%fyr%_%lyr%.csv o=sainc\%t%.gdx id=v index=2,5 useheader=y values=9..%lc% >sainc\%t%.log
$call csv2gdx i=sainc\%prefix%%t%__ALL_AREAS_%fyr%_%lyr%.csv o=sainc\%t%_rows.gdx id=iv index=5,6 autorow=r text=7 useheader=y >sainc\%t%_rows.log

set	i_%t%(*), j_%t%(*), iv_%t%(row,i_%t%<,j_%t%<), k_%t%(i_%t%,j_%t%);
$gdxin sainc\%t%_rows.gdx
$load iv_%t%=iv
loop(iv_%t%(row,i_%t%,j_%t%),k_%t%(i_%t%,j_%t%) = iv_%t%(row,i_%t%,j_%t%););

set	r_%t%(*)	Regions in the dataset;

parameter	v_%t%(r_%t%<,i_%t%,yr)  "%title%";
$gdxin sainc\%t%.gdx
$onUNDF
$loaddc v_%t%=v

set	L_%t%(i_%t%);
option L_%t%<v_%t%;
L_%t%(L_%t%) = k_%t%(L_%t%,"...");

option L_%t%:0:0:1, j_%t%:0:0:1, k_%t%:0:0:1; 
display L_%t%, j_%t%, k_%t%;

parameter	d_%t%(s,i_%t%,yr)	"%title%";
d_%t%(s,i_%t%,yr) = sum(rmap(s,r_%t%),v_%t%(r_%t%,i_%t%,yr));


$offecho

$set t 25N
$set title Total full-time and part-time employment by NAICS industry
$set fyr 1998
$set lyr 2022
$set prefix SAEMP
$batinclude %gams.scrdir%readtable 

$set t      25S
$set title Total full-time and part-time employment by SIC industry
$set fyr    1969
$set lyr    2001
$set prefix SAEMP
$batinclude %gams.scrdir%readtable 

$set t      27N
$set title Full-time and part-time wage and salary employment by NAICs industry
$set fyr    1998
$set lyr    2022
$set prefix SAEMP
$batinclude %gams.scrdir%readtable 

$set t      27S
$set title Full-time and part-time wage and salary employment by SIC industry
$set fyr    1969
$set lyr    2001
$set prefix SAEMP
$batinclude %gams.scrdir%readtable 

$set t      1
$set title  State annual personal income summary: personal income, population, per capita personal income
$set fyr    1929
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      30
$set title Economic profile
$set fyr    1958
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      35
$set title  Personal current transfer receipts
$set fyr    1929
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      40
$set title  Property income
$set fyr    1958
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      45
$set title  Farm income and expenses
$set fyr    1969
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      4
$set title  Personal income and employment by major component
$set fyr    1929
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      50
$set title  Personal current taxes
$set fyr    1948
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      51
$set title  State annual disposable personal income summary: disposable personal income, population, and per capita disposable personal income
$set fyr    1948
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      5H
$set title  Personal income by major component and earnings by industry (historical)
$set fyr    1929
$set lyr    1957
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      5n
$set title  Personal income by major component and earnings by NAICS industry
$set fyr    1998
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      5S
$set title  Personal income by major component and earnings by SIC industry
$set fyr    1958
$set lyr    2001
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      6N
$set title  Compensation of employees by NAICS industry
$set fyr    1998
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      6S
$set title  Compensation of employees by SIC industry
$set fyr    1958
$set lyr    2001
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      70
$set title  Transactions of state and local government defined benefit pension plans
$set fyr    2000
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      7H
$set title  Wages and salaries by industry (historical)
$set fyr    1929
$set lyr    1957
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      7N
$set title  Wages and salaries by industry (NAICS)
$set fyr    1998
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      7S
$set title  Wages and salaries by industry (SIC)
$set fyr    1958
$set lyr    2001
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      91
$set title  Gross flow of earnings
$set fyr    1990
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

execute_unload 'sainc.gdx', d_5n, d_6N, d_7N, d_25N, d_27N, d_1, d_4,
	d_30, d_35, d_40, d_45, d_50, d_51, d_5H, d_70, d_91, d_5S, d_6S,
	d_7H, d_7S, d_25S;
