$title Read statistics of income (SOI) data

* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* allow end of line comments
$eolcom !

* data directory
$set soidir ../data/household/soi/

* scratch gdx file directory
$if not dexist gdx $call mkdir gdx
$set gdxdir gdx/


* ------------------------------------------------------------------------------
* Read in data and needed sets
* ------------------------------------------------------------------------------

* Translate the SOI income CSV data to GDX:

$set file "%soidir%soi_income_totals_2014_2017.csv"
$if not dexist file $abort "%file% does not exist. Did you place the data in the correct location?"
$call 'csv2gdx "%file%" id=soicsv useheader=yes index=(1,2,3,4) values=5 output="%gdxdir%soicsv.gdx" CheckDate=yes trace=3'

* Define needed dimensions of dataset

set
    sr          Super region set (including US and OA),
    r(sr)       States (defined from SOI data),
    yr		Years in the underlying data (defined from SOI data),
    agi_stub	Adjusted gross income levels /
    		0	"All returns",
		1	"Under $1",
		2	"$1 under $10,000",
		3	"$10,000 under $25,000",
		4	"$25,000 under $50,000",
		5	"$50,000 under $75,000",
		6	"$75,000 under $100,000",
		7	"$100,000 under $200,000",
		8	"$200,000 under $500,000",
		9	"$500,000 under $1,000,000",
		10	"$1,000,000 or more" /,
    item	Data items (super set);

* Read in pre-processed datafile:

parameter
    soi_(yr,sr,agi_stub,item)    SOI dataset (2014-2017);

$gdxin '%gdxdir%soicsv.gdx'
$load yr=Dim1 sr=Dim2 item = Dim4
$loaddc soi_=soicsv
$gdxin

r(sr)$(not sameas(sr,'us') and not sameas(sr,'oa')) = yes;


* ------------------------------------------------------------------------------
* Define aggregate income categories
* ------------------------------------------------------------------------------

set
    cat	        All income categories /
    		labor		"Labor income",
		capital		"Capital income",
		trnsfer		"Govt transfer payments",
		pension		"Pension payments",
		total		"Total income",
		fed_tax		"Total federal tax liability",
		retirement	"Retirement contribution accounts"

* break out individual taxes where available

		inc_tax		"Total income tax amount",
		slf_tax		"Self-employment tax. Attach Schedule SE",
		f4137		"Unreported social security and Medicare tax: Form 4137",
		f8919		"Unreported social security and Medicare tax: Form 8919",
		ira_tax		"Additional tax on IRAs, other qualified retirement plans, etc",
		hhe_tax		"Household employment taxes from Schedule H",
		hme_tax		"First-time homebuyer credit repayment. Attach Form 5405 if required",
		hc_tax		"Health care: individual responsibility (see instructions)",
		f8959		"Taxes from Form 8959 (Additional Medicare tax amount)",
		f8960		"Taxes from Form 8960 (Net investment income tax amount)",
		ins_tax		"Taxes from Instructions" /,

    main(cat)	Aggregate income categories /
		labor		"Labor income",
		capital		"Capital income",
		trnsfer		"Govt transfer payments",
		pension		"Pension payments",
		total		"Total income",
		fed_tax		"Total federal tax liability" /,

    ftax(cat)	Category subset for federal tax types /
    		inc_tax		"Total income tax amount",
		slf_tax		"Self-employment tax. Attach Schedule SE",
		f4137		"Unreported social security and Medicare tax: Form 4137",
		f8919		"Unreported social security and Medicare tax: Form 8919",
		ira_tax		"Additional tax on IRAs, other qualified retirement plans, etc",
		hhe_tax		"Household employment taxes from Schedule H",
		hme_tax		"First-time homebuyer credit repayment. Attach Form 5405 if required",
		hc_tax		"Health care: individual responsibility (see instructions)",
		f8959		"Taxes from Form 8959 (Additional Medicare tax amount)",
		f8960		"Taxes from Form 8960 (Net investment income tax amount)",
		ins_tax		"Taxes from Instructions" /

* construct mappings
    catmap(cat,item)   Mapping aggregate categories and aggregate items /

    		total.a00100	! "Total",

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


* ------------------------------------------------------------------------------
* Check consistency of the mapping
* ------------------------------------------------------------------------------

* Negative numbers in capital/business gains and line 17. Zero out to compute
* shares.

soi_(yr,sr,"1",item)$catmap('capital',item) = 0;

* Construct income balance by region and household category

parameter
    income(yr,agi_stub,sr,*)	Income by category,
    fedtax(yr,agi_stub,sr,*)	Federal taxes by category;

income(yr,agi_stub,r,main) =
	sum(catmap(main,item)$(not sameas(main,"total") and not sameas(main,"fed_tax")),soi_(yr,r,agi_stub,item));
income(yr,agi_stub,r,"total_calc") =
    sum(main$(not sameas(main,"total") and not sameas(main,"fed_tax")), income(yr,agi_stub,r,main));
income(yr,agi_stub,r,"total") =
    sum(catmap("total",item), soi_(yr,r,agi_stub,item));
income(yr,agi_stub,r,"chksum") =
    sum(main$(not sameas(main,"total")), income(yr,agi_stub,r,main)) - income(yr,agi_stub,r,"total");
income(yr,agi_stub,r,"chksum%")$income(yr,agi_stub,r,"total") =
    100 * income(yr,agi_stub,r,"chksum")/income(yr,agi_stub,r,"total");
display income;

fedtax(yr,agi_stub,r,ftax) = sum(catmap(ftax,item), soi_(yr,r,agi_stub,item));
fedtax(yr,agi_stub,r,"total_calc") = sum(ftax, fedtax(yr,agi_stub,r,ftax));
fedtax(yr,agi_stub,r,"total") = sum(catmap("fed_tax",item), soi_(yr,r,agi_stub,item));
fedtax(yr,agi_stub,r,"chksum") = sum(ftax, fedtax(yr,agi_stub,r,ftax)) - fedtax(yr,agi_stub,r,"total");
fedtax(yr,agi_stub,r,"chksum%")$fedtax(yr,agi_stub,r,"total") =
    100 * fedtax(yr,agi_stub,r,"chksum")/fedtax(yr,agi_stub,r,"total");
display fedtax;


* ------------------------------------------------------------------------------
* Aggregate the data
* ------------------------------------------------------------------------------

set
    h		Household categories /
                hh1      "under $25,000",
		hh2      "$25,000 under $50,000",
                hh3      "$50,000 under $75,000",
                hh4      "$75,000 under $200,000",
                hh5      "over $200,000" /,
    hmap(agi_stub,h) Mapping to categories /
		(2,3).hh1, 4.hh2, 5.hh3, (6,7).hh4, (8,9,10).hh5 /;

parameter
    nr0_(yr,sr,h)	Number of returns in the data by household and state (in millions),
    save0_(yr,sr,h)	Retirement savings by region and household (in billions),
    wages0_(yr,sr,h)	Wage income by region and household (in billions),
    interest0_(yr,sr,h)	Interest income by region and household (in billions),
    taxes0_(yr,sr,h)	Personal income taxes by region and household (in billions),
    trans0_(yr,sr,h)	Govt transfer payments (in billions),
    cons0_(yr,sr,h)	Imputed consumption (in billions),
    pccons0_(yr,sr,h)	Per capita consumption,
    capgain0_(yr,sr,h)	Total capital gains (in billions);

nr0_(yr,r,h) = sum(hmap(agi_stub,h), 1e-6 * soi_(yr,r,agi_stub,"N02650"));

wages0_(yr,r,h) = 1e-6 * sum((hmap(agi_stub,h),catmap("labor",item)), soi_(yr,r,agi_stub,item));

interest0_(yr,r,h) = 1e-6 * sum((hmap(agi_stub,h),catmap("capital",item)), soi_(yr,r,agi_stub,item));

trans0_(yr,r,h) = 1e-6 * sum((hmap(agi_stub,h),catmap("trnsfer",item)), soi_(yr,r,agi_stub,item));

taxes0_(yr,r,h) = 1e-6 * sum((hmap(agi_stub,h),catmap("fed_tax",item)), soi_(yr,r,agi_stub,item));

save0_(yr,r,h) = 1e-6 * (sum((hmap(agi_stub,h),catmap("retirement",item)), soi_(yr,r,agi_stub,item)) +
                        sum((hmap(agi_stub,h),catmap("pension",item)), soi_(yr,r,agi_stub,item)));

cons0_(yr,r,h) = wages0_(yr,r,h) + interest0_(yr,r,h) + trans0_(yr,r,h) - taxes0_(yr,r,h) - save0_(yr,r,h);

pccons0_(yr,r,h) = 1e3*cons0_(yr,r,h) / nr0_(yr,r,h);

capgain0_(yr,r,h) = 1e-6 * sum((hmap(agi_stub,h)), soi_(yr,r,agi_stub,'A01000'));


* ------------------------------------------------------------------------------
* Output SOI dataset
* ------------------------------------------------------------------------------

* Output reconciled SOI data parameters

execute_unload '%gdxdir%soi_data.gdx',
    h, wages0_, interest0_, taxes0_, trans0_, save0_, pccons0_, nr0_;

* Output capital gains information

execute_unload "%gdxdir%soi_capital_gains.gdx",
    capgain0_;


* ------------------------------------------------------------------------------
* End
* ------------------------------------------------------------------------------
