$title	read soi statistics at the state level

* allow for exclamations based comments
$eolcom !

* file separator
$set sep %system.dirsep%

* set analysis year
$if not set year $set year 2014

*	Data directory:

$set soidir  data_sources%sep%soi%sep%

$if not dexist gdx $call mkdir gdx
$set gdxdir  gdx%sep%

* ------------------------------------------------------------------------------
* read in data and needed sets
* ------------------------------------------------------------------------------

* define needed dimensions of dataset
set
    ups	        Postal codes for states /
$include '%soidir%ups.set'
/,

    agi_stub	Adjusted gross income levels /
$include '%soidir%agi_stub.set'
/,

    item	Data items /
$include '%soidir%return_info.set'
$include '%soidir%item_%year%.set'
/; 

* read in full dataset (run Rscript read_soi.r first to consolidate raw data
* files)
parameter
    soi_(*,ups,agi_stub,*)    Available years of SOI dataset,
    soi(ups,agi_stub,item)    Specified year of data;

$gdxin '%soidir%soi_data_2014-2017.gdx'
$loaddc soi_=soidata
soi(ups,agi_stub,item) = soi_("%year%",ups,agi_stub,item);

set
* generalized income categories akin to windc categories
    cat	        Income categories /
        labor		    "Labor income",
        capital		  "Capital income",
        trnsfer 	  "Govt transfer payments",
        pension		  "Pension payments",
        total		    "Total income",
	      fed_tax 	  "Total federal tax liability",
	      retirement	"Retirement contribution accounts"

* break out individual taxes where available
	      inc_tax		  "Total income tax amount",
	      slf_tax		  "Self-employment tax. Attach Schedule SE",
	      f4137		    "Unreported social security and Medicare tax: Form 4137",
	      f8919		    "Unreported social security and Medicare tax: Form 8919",
	      ira_tax		  "Additional tax on IRAs, other qualified retirement plans, etc",
	      hhe_tax		  "Household employment taxes from Schedule H",
	      hme_tax		  "First-time homebuyer credit repayment. Attach Form 5405 if required",
        hc_tax		  "Health care: individual responsibility (see instructions)",
        f8959		    "Taxes from Form 8959 (Additional Medicare tax amount)",
	      f8960		    "Taxes from Form 8960 (Net investment income tax amount)",
	      ins_tax		  "Taxes from Instructions;" /,

   main(cat)    Subset of caegories that represent aggregates /
        labor		    "Labor income",
        capital		  "Capital income",
        trnsfer 	  "Govt transfer payments",
        pension		  "Pension payments",
        total		    "Total income",
	      fed_tax 	  "Total federal tax liability" /,

   ftax(cat)    Subset of caegories that represent disaggregate federal taxes /
	      inc_tax		  "Total income tax amount",
	      slf_tax		  "Self-employment tax. Attach Schedule SE",
	      f4137		    "Unreported social security and Medicare tax: Form 4137",
	      f8919		    "Unreported social security and Medicare tax: Form 8919",
	      ira_tax		  "Additional tax on IRAs, other qualified retirement plans, etc",
	      hhe_tax		  "Household employment taxes from Schedule H",
	      hme_tax		  "First-time homebuyer credit repayment. Attach Form 5405 if required",
        hc_tax		  "Health care: individual responsibility (see instructions)",
        f8959		    "Taxes from Form 8959 (Additional Medicare tax amount)",
	      f8960		    "Taxes from Form 8960 (Net investment income tax amount)",
	      ins_tax		  "Taxes from Instructions" /

* construct mappings
   catmap(cat,item)   Mapping aggregate categories and aggregate items /

	labor.a00200	! "Salaries and wages amount	1040:7 / 1040A:7 / 1040EZ:1",

* 8b Tax-exempt interest -- missing
* 11 Alimony received -- missing
* 14 Other gains or (losses) -- missing
* a26270 includes: "Partnership/S-corp net income (less loss) amount: Schedule E:32", not rental real estate
* 18 Farm income or (loss). Attach Schedule F -- only includes number (SCHF), not amount.
* 21 Other income -- missing
	
	capital.(
		a00300	! Taxable interest amount: 1040:8a / 1040A:8a / 1040EZ:2
		a00600	! Ordinary dividends amount: 1040:9a / 1040A:9a
		a00650	! Qualified dividends amount [7]: 1040:9b / 1040A:9b
		a00900	! Business or professional net income (less loss) amount: 1040:12
		a01000	! Net capital gain (less loss) amount: 1040:13  1040A:10
		a26270	! Partnership/S-corp net income (less loss) amount: Schedule E:32
		)


* 15a IRA distributions -- missing (taxable amounts included)
* 16a Pensions and annuities -- missing (taxable amounts included)
		
	pension.(
		a01400	! Taxable individual retirement arrangements distributions amount 1040:15b / 1040:11b
		a01700	! Taxable pensions and annuities amount	1040:16b / 1040A:12b
		)

* 20a Social security benefits -- missing (taxable amounts included)

	trnsfer.(
		a02300	! Unemployment compensation amount [4]	1040:19 / 1040A:13 / 1040EZ:3
		a02500	! Taxable Social Security benefits amount 1040:20b / 1040A:14b
		a00700	! State and local income tax refunds amount 1040:10		
		)

* 58a Unreported social security and Medicare tax: Form 4137 -- missing
* 58b Unreported social security and Medicare tax: Form 8919 -- missing
* 59 Additional tax on IRAs, other qualified retirement plans, etc -- missing
* 60a Household employment taxes from Schedule H -- missing
* 60b First-time homebuyer credit repayment. Attach Form 5405 if required -- missing
* 62c Taxes from Instructions -- missing
		
	fed_tax.a10300 ! Total tax liability amount [8] 1040:63 / 1040A:39 / 1040EZ: 10"

	retirement.(
		a03300	! Self-employment retirement plans amount 1040:28
		a03150	! IRA payments amount 1040:32 / 1040A:17
		)
	inc_tax.A06500	! Income tax amount [11]: 1040:56 / 1040A:37 / 1040EZ:10
	slf_tax.A09400	! Self-employment tax amount: 1040:57
        f8959.A85530	! Additional Medicare tax amount: 1040:62a
	f8960.A85300	! Net investment income tax amount: 1040:62b
	/;

* many of these negative numbers in capital/business gains and line 17 are
* probably outliers. zero out to compute shares.
soi(ups,"1",item)$catmap('capital',item) = 0;

* construct income balance by region and household category
parameter
    income(agi_stub,ups,*)	Income by category (in billions),
    fedtax(agi_stub,ups,*)	Federal taxes by category;

income(agi_stub,ups,main) = 1e-6 * 
	sum(catmap(main,item)$(not sameas(main,"total") and not sameas(main,"fed_tax")),soi(ups,agi_stub,item));
income(agi_stub,ups,"total_calc") = sum(main$(not sameas(main,"total") and not sameas(main,"fed_tax")), income(agi_stub,ups,main));
income(agi_stub,ups,"total") = 1e-6 * sum(catmap("total",item), soi(ups,agi_stub,item));

fedtax(agi_stub,ups,ftax) = 1e-6 * sum(catmap(ftax,item), soi(ups,agi_stub,item));
fedtax(agi_stub,ups,"total_calc") = sum(ftax, fedtax(agi_stub,ups,ftax));
fedtax(agi_stub,ups,"total") = 1e-6 * sum(catmap("fed_tax",item), soi(ups,agi_stub,item));

* not all tax payments are included
income(agi_stub,ups,"chksum") = sum(main$(not sameas(main,"total")), income(agi_stub,ups,main)) - income(agi_stub,ups,"total");
income(agi_stub,ups,"chksum%")$income(agi_stub,ups,"total") = 100 * income(agi_stub,ups,"chksum")/income(agi_stub,ups,"total");
fedtax(agi_stub,ups,"chksum") = sum(ftax, fedtax(agi_stub,ups,ftax)) - fedtax(agi_stub,ups,"total");
fedtax(agi_stub,ups,"chksum%")$fedtax(agi_stub,ups,"total") = 100 * fedtax(agi_stub,ups,"chksum")/fedtax(agi_stub,ups,"total");
display income, fedtax;


* ------------------------------------------------------------------------------
* aggregate needed data
* ------------------------------------------------------------------------------

set
    st(ups)     States,
    hc	        Household categories /
                hh1      "under $25,000",
		            hh2      "$25,000 under $50,000",
                hh3      "$50,000 under $75,000",
                hh4      "$75,000 under $200,000",
                hh5      "over $200,000" /,
    hcmap(agi_stub,hc) Mapping to categories /
		(2,3).hh1, 4.hh2, 5.hh3, (6,7).hh4, (8,9,10).hh5 /;

* postal codes which are states:
st(ups) = yes$(not (sameas(ups,"us") or sameas(ups,"oa")));

parameter
	nr(ups,hc)		    Number of returns in the data by household and state (in millions),
	save0(ups,hc)		  Retirement savings by region and household (in billions),
	wages0(ups,hc)		Wage income by region and household (in billions),
	interest0(ups,hc)	Interest income by region and household (in billions),
	taxes0(ups,hc)		Personal income taxes by region and household (in billions),
	trans0(ups,hc)		Govt transfer payments (in billions),
	cons0(ups,hc)		  Imputed consumption (in billions),
	pccons(ups,hc)	  Per capita consumption,
	capgain0(ups,hc)  Total capital gains (in billions);


nr(st,hc) = sum(hcmap(agi_stub,hc), 1e-6 * soi(st,agi_stub,"N02650"));

wages0(st,hc) = 1e-6 * sum((hcmap(agi_stub,hc),catmap("labor",item)), soi(st,agi_stub,item));

interest0(st,hc) = 1e-6 * (
		sum((hcmap(agi_stub,hc),catmap("capital",item)), soi(st,agi_stub,item)) +
		sum((hcmap(agi_stub,hc),catmap("pension",item)), soi(st,agi_stub,item)) );

trans0(st,hc) = 1e-6 * sum((hcmap(agi_stub,hc),catmap("trnsfer",item)), soi(st,agi_stub,item));

taxes0(st,hc) = 1e-6 * (
		sum((hcmap(agi_stub,hc),catmap("fed_tax",item)), soi(st,agi_stub,item)) );

save0(st,hc) = 1e-6 * sum((hcmap(agi_stub,hc),catmap("retirement",item)), soi(st,agi_stub,item));

cons0(st,hc) = wages0(st,hc) + interest0(st,hc) + trans0(st,hc) - taxes0(st,hc) - save0(st,hc);

pccons(st,hc) = 1e3*cons0(st,hc) / nr(st,hc);

execute_unload '%gdxdir%soi_data_%year%.gdx', wages0, interest0, taxes0, trans0, save0, pccons, hc=h, nr;

* calculate capital gains totals for use with CPS data
capgain0(st,hc) = 1e-6 * sum((hcmap(agi_stub,hc)), soi(st,agi_stub,'A01000'));
execute_unload "%gdxdir%capital_gains_%year%.gdx" capgain0;