$title	Generate GDP Shares for Regional Disaggreation

set	yr		Years /1997*2023/,
	d(*)		Detailed sectors,
	s(*)		Summary sectors,
	sgdp(*)		Sectors with GDP data,
	st(*)		States,
	mrg		Margins /trd,trn/
	sd(s,d)		Summmary to detail sector
	sgdp_s(sgdp,s)	GDP sector to summary sector;

$call 'gams mappings gdx=%gams.scrdir%mappings.gdx'
$gdxin '%gams.scrdir%mappings.gdx'
$load s d st sgdp
$loaddc sd sgdp_s

set	item	Data items /
	txms	"Taxes on production and imports (TOPI) less subsides (millions of dollars) ",
	cgdp	"Current-dollar GDP (millions of current dollars) ",

	wage	"Compensation (millions of dollars) ",
	srpl	"Gross operating surplus (millions of dollars) ",
	subs	"Subsidies (millions of dollars) " ,
	topi	"Taxes on production and imports (TOPI) (millions of dollars) ",

	indx	"Chain-type quantity indexes for real GDP (Quantity index)",
	rgdp	"Real GDP (millions of chained 2017 dollars) 1/",
	cntr	"Contributions to percent change in real GDP 1."/;

parameter	gdp(item,st,sgdp,yr)	GDP data;
$onundf
$gdxin ..\sagdp\sagdp
$loaddc gdp

set taxsbd(item)	Tax and subsidy columns /txms,subs,topi/;
parameter	taxes(st,*);

taxes(st,taxsbd) = sum(sgdp,gdp(taxsbd,st,sgdp,"2017"));

*	Verify that txms = topi + subs

taxes(st,"chk") = taxes(st,"txms") - (taxes(st,"topi") + taxes(st,"subs"));
display taxes;

set	gdpitems(item)	Components of GDP /cgdp,topi,subs,wage,srpl/;

set  defined(st,sgdp,yr)	Which sectors are covered;
defined(st,sgdp,yr) = yes$(sum(gdpitems$(gdp(gdpitems,st,sgdp,yr)=undf),1)=0);

parameter	gdpshare	What are average GDP shares;
gdpshare(sgdp,gdpitems) = 1e-3 * sum(defined(st,sgdp,"2017"),gdp(gdpitems,defined)) /
			  sum(defined(st,sgdp,"2017"),gdp("cgdp",defined));

*	Only need GDP shares for taxes, wage income and surplus:

gdpshare(sgdp,"cgdp") = 0;
display gdpshare;

set	gdpfactor(item) /topi,subs,wage,srpl/;

gdp(gdpfactor,st,sgdp,yr)$(gdp(gdpfactor,st,sgdp,yr)=undf) = gdp("cgdp",st,sgdp,yr) * gdpshare(sgdp,gdpfactor);

parameter	valshr	Value shares of GDP;

valshr(gdpfactor,st,sgdp,yr)$sum(gdpfactor.local,gdp(gdpfactor,st,sgdp,yr))
	= gdp(gdpfactor,st,sgdp,yr)/sum(gdpfactor.local,gdp(gdpfactor,st,sgdp,yr));
execute_unload 'valshr.gdx',valshr;
execute 'gdxxrw i=valshr.gdx o=valshr.xlsx par=valshr rng=PivotData!a1 cdim=0 intastext=no';

$exit


parameter wigdp;
wigdp(sgdp,gdpitems) = gdp(gdpitems,"wi",sgdp,"2017")/1e6;
wigdp(sgdp,"cgdp") = 1e3*wigdp(sgdp,"cgdp");
wigdp(sgdp,"chk") = wigdp(sgdp,"cgdp") - wigdp(sgdp,"topi") - wigdp(sgdp,"subs") - wigdp(sgdp,"wage") - wigdp(sgdp,"srpl");
display wigdp;

$exit

gdp(gdpitems,st,sgdp,yr)$(gdp(gdpitems,st,sgdp,yr)=undf) = 0;
parameter	gdptot;
gdptot(st,gdpitems) = sum(sgdp,gdp(gdpitems,st,sgdp,"2017"));
gdptot(st,"cgdp") = gdptot(st,"cgdp") * 1e3;

gdptot(st,"chk") = 2*gdptot(st,"cgdp") - sum(gdpitems,gdptot(st,gdpitems));
display gdptot;


$exit
set	undefined(item,st,sgdp,yr)	Entries with undefined values;
undefined(item,st,sgdp,yr) = item(item)$(gdp(item,st,sgdp,yr) = undf);
option undefined:0:0:1;
display undefined;

set	usst /us, (set.st)/;

parameter	agshare(usst,yr,d)	State shares of agricultural output;

$gdxin ..\farmincome\readfiws.gdx
$loaddc agshare


parameter	theta_gdp(


parameter	theta(yr,st,d)		Fractions of GDP;

theta(yr,st,d) = sum((sgdp_s(sgdp,s),sd(s,d)),
