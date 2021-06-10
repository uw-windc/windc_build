$title	read cps statistics for at the state level

*	Allow end of line comments
$eolcom !

*	Directory separator:

$set sep %system.dirsep%

*	Data directory:

$set cpsdir  data_sources%sep%cps%sep%

$if not dexist gdx $call mkdir gdx
$set gdxdir  gdx%sep%

* analysis year
$if not set year $set year 2017

* ------------------------------------------------------------------------------
* read in data and needed sets
* ------------------------------------------------------------------------------

* translate the CPS income CSV data to GDX:
$set file "%cpsdir%cps_asec_income_totals_2015_2017.csv"
$call csv2gdx "%file%" id=cpscsv useheader=yes index=1,2,3,5,6 values=4 output="%gdxdir%cpscsv.gdx" CheckDate=yes trace=3


* translate the CPS population CSV data to GDX:
$set file "%cpsdir%number_of_household_%year%.csv"
$call csv2gdx %file% id=popcsv useheader=yes index=1 values=2,3,4,5,6 output="%gdxdir%cps_household_csv_%year%.gdx" CheckDate=yes trace=3


*	Read labor tax rates:

$set file %cpsdir%labor_tax_rates.csv
$call csv2gdx %file%  id=taxrate0 useheader=yes index=1,2 values=5 output="%gdxdir%labor_tax_rates.gdx" CheckDate=yes trace=3

*	Read in tax rates from SAGE model

$set file %cpsdir%capital_tax_rates.csv
$call csv2gdx %file% id=tk0 useheader=yes index=1 values=2 output="%gdxdir%capital_tax_rates.gdx" CheckDate=yes trace=3


* define needed dimensions of dataset
set
    hc	      	Household categories /
        hh1     "Quintile 1",
        hh2     "Quintile 2",
        hh3     "Quintile 3",
        hh4     "Quintile 4",
        hh5     "Quintile 5" /,
    state	State fips,
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
	hretval	"retirement income"
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
	hfinval	"financial assistance" /,        
    year	Years in the underlying data,
    sname	State name,
    st	      	State abbreviations /
        us	"united states",
	al	"alabama",
	ak	"alaska",
	az	"arizona",
	ar	"arkansas",
	ca	"california",
	co	"colorado",
	ct	"connecticut",
	de	"delaware",
	dc	"district of columbia",
	fl	"florida",
	ga	"georgia",
	hi	"hawaii",
	id	"idaho",
	il	"illinois",
	in	"indiana",
	ia	"iowa",
	ks	"kansas",
	ky	"kentucky",
	la	"louisiana",
	me	"maine",
	md	"maryland",
	ma	"massachusetts",
	mi	"michigan",
	mn	"minnesota",
	ms	"mississippi",
	mo	"missouri",
	mt	"montana",
	ne	"nebraska",
	nv	"nevada",
	nh	"new hampshire",
	nj	"new jersey",
	nm	"new mexico",
	ny	"new york",
	nc	"north carolina",
	nd	"north dakota",
	oh	"ohio",
	ok	"oklahoma",
	or	"oregon",
	pa	"pennsylvania",
	ri	"rhode island",
	sc	"south carolina",
	sd	"south dakota",
	tn	"tennessee",
	tx	"texas",
	ut	"utah",
	vt	"vermont",
	va	"virginia",
	wa	"washington",
	wv	"west virginia",
	wi	"wisconsin",
	wy	"wyoming" /;

* read in full dataset
parameter
    cps_(hc,state,source,year,sname)    CPS dataset (in $),
    pop(st,hc)				CPS household populations (in millions);

$gdxin '%gdxdir%cpscsv.gdx'
$load state=Dim2 year=Dim4 sname=Dim5
$loaddc cps_=cpscsv

$gdxin '%gdxdir%cps_household_csv_%year%.gdx'
$loaddc pop=popcsv

* ------------------------------------------------------------------------------
* aggregate needed data
* ------------------------------------------------------------------------------

set
    maps(st,sname) 	Mapping to state abbreviations /
    		us."united states",
		al."alabama",
		ak."alaska",
		az."arizona",
		ar."arkansas",
		ca."california",
		co."colorado",
		ct."connecticut",
		de."delaware",
		dc."district of columbia",
		fl."florida",
		ga."georgia",
		hi."hawaii",
		id."idaho",
		il."illinois",
		in."indiana",
		ia."iowa",
		ks."kansas",
		ky."kentucky",
		la."louisiana",
		me."maine",
		md."maryland",
		ma."massachusetts",
		mi."michigan",
		mn."minnesota",
		ms."mississippi",
		mo."missouri",
		mt."montana",
		ne."nebraska",
		nv."nevada",
		nh."new hampshire",
		nj."new jersey",
		nm."new mexico",
		ny."new york",
		nc."north carolina",
		nd."north dakota",
		oh."ohio",
		ok."oklahoma",
		or."oregon",
		pa."pennsylvania",
		ri."rhode island",
		sc."south carolina",
		sd."south dakota",
		tn."tennessee",
		tx."texas",
		ut."utah",
		vt."vermont",
		va."virginia",
		wa."washington",
		wv."west virginia",
		wi."wisconsin",
		wy."wyoming" /,
    r(st)		State regions,
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
			hretval	! "retirement income"
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

r(st) = yes$(not sameas(st,'us'));

parameter
	cps(st,hc,source)	Aggregated cps data,
	save0(st,hc)		Retirement savings by region and household (in billions),
	wages0(st,hc)		Wage income by region and household (in billions),
	interest0(st,hc)	Interest income by region and household (in billions),
	taxes0(st,hc)		Personal income taxes by region and household (in billions),
	trans0(st,hc)		Govt transfer payments (in billions),
	cons0(st,hc)		Imputed consumption (in billions),
	pccons(st,hc)	        Per capita consumption,
	hhtrans0(st,hc,source)	Disaggregate household transfers (in billions);

cps(st,hc,source) = sum((maps(st,sname),state), cps_(hc,state,source,'%year%',sname));

wages0(r,hc)    = 1e-9 * sum(catmap("labor",source), cps(r,hc,source));
interest0(r,hc) = 1e-9 * sum(catmap("capital",source), cps(r,hc,source));
trans0(r,hc)    = 1e-9 * sum(catmap("trnsfer",source), cps(r,hc,source));
save0(r,hc)     = 1e-9 * sum(catmap("retirement",source), cps(r,hc,source));

* no household tax data in CPS
taxes0(r,hc)    = 0;

cons0(r,hc)     = wages0(r,hc) + interest0(r,hc) + trans0(r,hc) - taxes0(r,hc) - save0(r,hc);
pccons(r,hc)    = 1e3*cons0(r,hc) / pop(r,hc);

* save disaggregate transfers
hhtrans0(r,hc,source)$catmap("trnsfer",source) = 1e-9 * cps(r,hc,source);

execute_unload '%gdxdir%cps_data_%year%.gdx',
    wages0, interest0, taxes0, trans0, hhtrans0, save0, pccons, hc=h, trn, pop;
