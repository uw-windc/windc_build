$title Read current population survey (CPS) data


* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* allow end of line comments
$eolcom !

* data directory
$set cpsdir ../data/household/cps/

* scratch gdx file directory
$if not dexist gdx $call mkdir gdx
$set gdxdir gdx/



* ------------------------------------------------------------------------------
* Read in data and needed sets
* ------------------------------------------------------------------------------

* Translate the CPS income CSV data to GDX:

$set file "%cpsdir%cps_asec_income_totals_2000_2022.csv"
$if not exist %file% $abort "%file% does not exist. Did you place the data in the correct location?"
$call 'csv2gdx "%file%" id=cpscsv useheader=yes index="(1,2,3,4)" values=5 output="%gdxdir%cpscsv.gdx" CheckDate=yes trace=3'

* Translate the CPS population CSV data to GDX:

$set file "%cpsdir%cps_asec_numberhh_2000_2022.csv"
$if not exist %file% $abort "%file% does not exist. Did you place the data in the correct location?"
$call 'csv2gdx %file% id=popcsv useheader=yes index="(1,2,3)" values=4 output="%gdxdir%cps_households.gdx" CheckDate=yes trace=3'

* Translate labor tax rate CSV data to GDX:

$set file %cpsdir%labor_tax_rates.csv
$if not exist %file% $abort "%file% does not exist. Did you place the data in the correct location?"
* $call csv2gdx %file%  id=taxrate0 useheader=yes index=1,2 values=5 output="%gdxdir%labor_tax_rates.gdx" CheckDate=yes trace=3
$call csv2gdx %file% id=tl0 useheader=yes index="(1,2)" values=3 output="%gdxdir%labor_tax_rates_tl.gdx" CheckDate=yes trace=3
$call csv2gdx %file% id=tfica0 useheader=yes index="(1,2)" values=4 output="%gdxdir%labor_tax_rates_tfica.gdx" CheckDate=yes trace=3
$call csv2gdx %file% id=tl_avg0 useheader=yes index="(1,2)" values=5 output="%gdxdir%labor_tax_rates_tl_avg.gdx" CheckDate=yes trace=3

* Translate capital tax rate CSV data to GDX:

$set file %cpsdir%capital_tax_rates.csv
$if not exist %file% $abort "%file% does not exist. Did you place the data in the correct location?"
$call csv2gdx %file% id=tk0 useheader=yes index=1 values=2 output="%gdxdir%capital_tax_rates.gdx" CheckDate=yes trace=3

* Define needed dimensions of dataset. Note that retirement income is redefined
* in 2019 in the CPS (which is recorded as 2018 data) -- hretval = hdstval +
* hpenval + hannval.

set
    sr          Super region set (including US),
    r(sr)       States (defined from CPS data),
    yr		Years in the underlying data (defined from CPS data),
    h	      	Household categories (defined from CPS data),
    source	CPS income source categories /
		hwsval	"wages and salaries"
		hseval	"self-employment (nonfarm)"
		hfrval	"self-employment farm"
		hucval	"unemployment compensation"
		hwcval	"workers compensation"
		hssval	"social security"
		hssival	"supplemental security"
		hpawval	"public assistance or welfare"
		hvetval	"veterans benefits"
		hsurval	"survivors income"
		hdisval	"disability"
		hretval	"retirement income (available through 2017)"
		hdstval "retirement distributions (available in 2018)"
		hpenval "pension income (available in 2018)"
		hannval "annuities (available in 2018)"
		hintval	"interest"
		hdivval	"dividends"
		hrntval	"rents"
		hedval	"educational assistance"
		hcspval	"child support"
		hfinval	"financial assistance"
		hoival	"other income"
		htotval	"total household income" /,
    trn(source) Transfer sources of income /
		hucval	"unemployment compensation"
		hwcval	"workers compensation"
		hssval	"social security"
		hssival	"supplemental security"
		hpawval	"public assistance or welfare"
		hvetval	"veterans benefits"
		hsurval	"survivors income"
		hdisval	"disability"
		hedval	"educational assistance"
		hcspval	"child support"
		hfinval	"financial assistance" /;

* Read in pre-processed datafile:

parameter
    cps0_(yr,sr,h,source)	CPS dataset (in $),
    pop0_(yr,sr,h)		CPS household populations (in millions);

$gdxin '%gdxdir%cpscsv.gdx'
$load yr=Dim1 sr=Dim2 h=Dim3
$loaddc cps0_=cpscsv
$gdxin

$gdxin '%gdxdir%cps_households.gdx'
$loaddc pop0_=popcsv
$gdxin

* Scale the data to be in billions of dollars

cps0_(yr,sr,h,source) = cps0_(yr,sr,h,source) * 1e-9;


* ------------------------------------------------------------------------------
* Aggregate into aggregate income categories
* ------------------------------------------------------------------------------

set
    catmap(*,source)	Mapping between household categories and CPS categories /
                labor.(
			hwsval	! "wages and salaries"
			),
		capital.(
			hintval	! "interest"
			hdivval	! "dividends"
			hrntval	! "rents"
			hoival	! "other income"
			hseval	! "self-employment (nonfarm)"
			hfrval	! "self-employment farm"
			),
		retirement.(
			hretval	! "retirement income (available through 2017)"
			hdstval ! "retirement distributions (available in 2018)"
			hpenval ! "pension income (available in 2018)"
			hannval ! "annuities (available in 2018)"
			),
		trnsfer.(
			hucval	! "unemployment compensation"
			hwcval	! "workers compensation"
			hssval	! "social security"
			hssival	! "supplemental security"
			hpawval	! "public assistance or welfare"
			hvetval	! "veterans benefits"
			hsurval	! "survivors income"
			hdisval	! "disability"
			hedval	! "educational assistance"
			hcspval	! "child support"
			hfinval	! "financial assistance"
			) /;

r(sr) = yes$(not sameas(sr,'us'));

parameter
    wages0_(yr,sr,h)		Wage income by region and household (in billions),
    interest0_(yr,sr,h)		Interest income by region and household (in billions),
    taxes0_(yr,sr,h)		Personal income taxes by region and household (in billions),
    trans0_(yr,sr,h)		Govt transfer payments (in billions),
    save0_(yr,sr,h)		Retirement savings by region and household (in billions),
    cons0_(yr,sr,h)		Imputed consumption (in billions),
    pccons0_(yr,sr,h)	        Per capita consumption,
    hhtrans0_(yr,sr,h,source)	Disaggregate household transfers (in billions);

wages0_(yr,r,h) = sum(catmap("labor",source), cps0_(yr,r,h,source));
interest0_(yr,r,h) = sum(catmap("capital",source), cps0_(yr,r,h,source));
trans0_(yr,r,h) = sum(catmap("trnsfer",source), cps0_(yr,r,h,source));
save0_(yr,r,h) = sum(catmap("retirement",source), cps0_(yr,r,h,source));

* Save disaggregate transfers

hhtrans0_(yr,r,h,source)$catmap("trnsfer",source) = cps0_(yr,r,h,source);

* No household tax data in CPS

taxes0_(yr,r,h) = 0;

* Calculate per capita consumption for consistency check

cons0_(yr,r,h) = wages0_(yr,r,h) + interest0_(yr,r,h) + trans0_(yr,r,h) - taxes0_(yr,r,h) - save0_(yr,r,h);
pccons0_(yr,r,h) = 1e3*cons0_(yr,r,h) / pop0_(yr,r,h);


* ------------------------------------------------------------------------------
* Output CPS dataset:
* ------------------------------------------------------------------------------

execute_unload '%gdxdir%cps_data.gdx',
    h, trn, wages0_, interest0_, taxes0_, trans0_, hhtrans0_,
    save0_, pccons0_, pop0_;


* ------------------------------------------------------------------------------
* End
* ------------------------------------------------------------------------------
