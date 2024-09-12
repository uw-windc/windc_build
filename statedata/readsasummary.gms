$title	Read the State Summary Data

set	row	Data rows /
	1	"Real GDP (millions of chained 2017 dollars) 1/"
	2	"Real personal income (millions of constant (2017) dollars) 2/"
	3	"Real PCE (millions of constant (2017) dollars) 3/"
	4	"Gross domestic product (GDP) ",
	5	"Personal income ",
	6	"Disposable personal income ",
	7	"Personal consumption expenditures ",
	8	"Real per capita personal income 4/",
	9	"Real per capita PCE 5/"
	10	"Per capita personal income 6/"
	11	"Per capita disposable personal income 7/"
	12	"Per capita personal consumption expenditures (PCE) 8/"
	13	"Regional price parities (RPPs) 9/"
	14	"Implicit regional price deflator 10/"
	15	"Total employment (number of jobs) "/;

set	r(*)	Regions;

set	yr/1997*2023/;

$call csv2gdx i=sasummary\SASUMMARY__ALL_AREAS_1998_2023.csv o=%gams.scrdir%summary.gdx id=summary values=9..34 useheader=y index=(2,5) >sasumary.log

parameter	summary(r<,row,yr)	Summary annual data for states;
$gdxin %gams.scrdir%summary.gdx

$onUNDF
$load summary

set	s	States /	
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
	WY	"Wyoming"/;

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


$ontext

Footnotes:

1/ Chained (2017) dollar series are calculated as the product of the
chain-type quantity index and the 2017 current-dollar value of the
corresponding series, divided by 100. Because the formula for the
chain-type quantity indexes uses weights of more than one period, the
corresponding chained-dollar estimates are usually not additive. The
difference between the United States and sum-of-states reflects
federal military and civilian activity located overseas, as well as
the differences in source data used to estimate GDP by industry and
the expenditures measure of real GDP.

2/ Real personal income for states is personal income divided by the
RPPs and the national PCE price index. The result is a constant dollar
(using 2017 as the base year) estimate of real personal income.
Calculations are performed on unrounded data.

3/ Real personal consumption expenditures for states are personal
consumption expenditures divided by the RPPs and the national PCE
price index. The result is a constant dollar (using 2017 as the base
year) estimate of real personal consumption expenditures. Calculations
are performed on unrounded data.

4/ Real per capita personal income for states is real personal income
divided by total midyear population. BEA produced intercensal
population statistics for 2010 to 2019 that are tied to the Census
Bureau decennial counts for 2010 and 2020 to create consistent time
series that are used to prepare per capita personal income statistics.

5/ Real per capita personal consumption expenditures for states is
real personal consumption expenditures divided by total midyear
population. BEA produced intercensal population statistics for 2010 to
2019 that are tied to the Census Bureau decennial counts for 2010 and
2020 to create consistent time series that are used to prepare per
capita personal consumption expenditure statistics. 

6/ Per capita personal income is total personal income divided by
total midyear population. BEA produced intercensal population
statistics for 2010 to 2019 that are tied to the Census Bureau
decennial counts for 2010 and 2020 to create consistent time series
that are used to prepare per capita personal income statistics. 

7/ Per capita disposable personal income is total disposable personal
income divided by total midyear population estimates of the Census
Bureau. BEA produced intercensal population statistics for 2010 to
2019 that are tied to the Census Bureau decennial counts for 2010 and
2020 to create consistent time series that are used to prepare per
capita personal income statistics. 

8/ Per capita PCE estimates are in current dollars. Per capita values
are computed from unrounded data. BEA produced intercensal population
statistics for 2010 to 2019 that are tied to the Census Bureau
decennial counts for 2010 and 2020 to create consistent time series
that are used to prepare per capita PCE statistics. 

9/ Regional price parities (RPPs) measure price level differences
across regions for one time period. Each annual set of RPPs is
estimated relative to the US average for that year and thus cannot be
compared meaningfully across years (see the IRPD for an adjustment
that enables regional time-to-time comparisons).

10/ Implicit regional price deflators (IRPDs) are derived as the
product of two terms--the regional price parity and the U.S. PCE price
index. The year to-year change in the IRPDs is an indirect measure of
regional inflation.

$offtext

parameter	sasummary(s,row,yr)	Datasets;
loop(s_r(s,r),
	sasummary(s,row,yr) = summary(r,row,yr)$(summary(r,row,yr)<>UNDF);
);

execute_unload 'sasummary.gdx',sasummary,row;
