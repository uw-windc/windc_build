$title State disaggregation of national accounts

set	yr	/1997*2023/;

set	r	Regions /	
	USA	Nation
	AL	"Alabama",
*.	AK	"Alaska",
	AR	"Arizona",
	AZ	"Arkansas",
	CA	"California",
	CO	"Colorado",
	CT	"Connecticut",
*.	DC	"District of Columbia",
	DE	"Delaware",
	FL	"Florida",
	GA	"Georgia",
*.	HI	"Hawaii",
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

* ------------------------------------------------------------------------------
* Read in the national dataset:
* ------------------------------------------------------------------------------

$include ..\bea_IO\beadata

parameter	ke0(yr,r)	Regional capital endowment;
ke0(yr,"usa") = sum(s,kd0_(yr,"usa",s));

set	ra_(r) /usa/;

$ontext
$model:symmetric

$sectors:
	Y(r,s)$y_(yb,r,s)	! Production
	A(r,g)$a0(yb,r,g)	! Absorption
	ES(g)$vx0(yb,g)		! Export supply
	N(g)$n0(yb,g)		! National market supply
	MS(mrg)			! Margin supply
	KS			! Capital stock

$commodities:
	PA(r,g)$pa_(yb,r,g)	! Regional market (input)
	PY(r,g)$y0(yb,r,g)	! Regional market (output)
	PX(g)$vx0(yb,g)		! Export market
	PN(g)$n0(yb,g)		! National market
	PK(r,s)$kd0_(yb,r,s)	! Rental rate of capital
	PI(mrg)			! Margin price
	PNYSE			! Aggregate return to capital
	PL(r)$ra_(r)		! Wage rate
	PFX			! Foreign exchange

$consumer:
	RA(r)$ra_(r)		! Representative agent
	ROW			! Rest of world (export demand)

$auxiliary:
	ED(g)$vx0(yb,g)		! Export demand

$prod:Y(r,s)$y_(yb,r,s)  s:0 va:1
	o:PY(r,s)	q:(ys0_(yb,r,s)) a:RA(r) t:(ty_(yb,r,s)) p:(1-ty0_(yb,r,s))
	i:PA(r,g)	q:(id0_(yb,r,g,s))
	i:PL(r)		q:(ld0_(yb,r,s))	va:
	i:PK(r,s)	q:(kd0_(yb,r,s))	va:

$prod:ES(g)$vx0(yb,g)  s:0.5  y:4
	o:PX(g)		q:(sum(r,x0(yb,r,g)))
	i:PY(r,g)	q:(x0(yb,r,g)-rx0(yb,r,g))   y:
	i:PFX		q:(sum(r,rx0(yb,r,g)))

$prod:N(g)$n0(yb,g)  t:4
	o:PN(g)		q:(n0(yb,g))
	i:PY(r,g)	q:(ns0(yb,r,g))

$prod:MS(mrg)  s:0.5
	o:PI(mrg)	q:(sum((r,g),ms0(yb,r,g,mrg)))
	i:PY(r,g)	q:(ms0(yb,r,g,mrg))

$prod:A(r,g)$a0(yb,r,g)  s:0 dm:2  d(dm):4
	o:PA(r,g)	q:(a0(yb,r,g))	a:RA(r)	t:(ta(yb,r,g)) p:(1-ta0(yb,r,g))
	i:PN(g)		q:(nd0(yb,r,g))		d:
	i:PY(r,g)	q:(yd0(yb,r,g))		d:
	i:PFX		q:(m0(yb,r,g)-rx0(yb,r,g))	dm:  a:RA(r)  t:(tm(yb,r,g)) p:(1+tm0(yb,r,g))
	i:PI(mrg)	q:(md0(yb,r,mrg,g))

$prod:KS
	o:PK(r,s)	q:(kd0_(yb,r,s))
	i:PNYSE		q:(sum(r,ke0(yb,r)))

$demand:RA(r)$ra_(r)  s:1
	d:PA(r,g)	q:(cd0(yb,r,g))
	e:PFX		q:(vb(yb,r))
	e:PA(r,g)	q:(-sum(xd,fd0(yb,r,g,xd)))
	e:PL(r)		q:(sum(s,ld0(yb,r,s)))
	e:PNYSE		q:(ke0(yb,r))

$demand:ROW
	e:PFX		q:(2*sum(g,vx0(yb,g)))
	e:PX(g)		q:(-vx0(yb,g))	r:ED(g)
	d:PFX		

$constraint:ED(g)$vx0(yb,g)
	ED(g) =e= (PX(g)/PFX)**(-epsilonx(g));

$offtext
$sysinclude mpsgeset symmetric 
*$sysinclude mpsgeset symmetric -mt=1

ED.L(g)$vx0(yb,g) = 1;

symmetric.workspace = 1024;
symmetric.iterlim = 0;
$include symmetric.gen
solve symmetric using mcp;

* ------------------------------------------------------------------------------
* Read in shares generated using state level gross product, pce, faf,
* and government expenditures:
* ------------------------------------------------------------------------------

set	sagdptbl /
	t1	State annual gross domestic product (GDP) summary
	t2	Gross domestic product (GDP) by state
	t3	Taxes on production and imports less subsidies
	t4	Compensation of employees
	t5	Subsidies
	t6	Taxes on production and imports
	t7	Gross operating surplus
	t8	Chain-type quantity indexes for real GDP by state (2017=100.0)
	t9	Real GDP by state
	t11	Contributions to percent change in real GDP /

parameter	sagdp(r,s,yr,sagdptbl)	State Annual GDP dataset;
$gdxin 'sagdp.gdx'

$onUNDF
$load sagdp

sagdp(r,s,yr,sagdptbl)$(sagdp(r,s,yr,sagdptbl) = undf) = 0;

set	sarow	Data rows in the summary table /
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

parameter	sasummary(r,sarow,yr)	Summary data;
$gdxin 'sasummary.gdx'
$load sasummary

set i_40 /  
	90  "Dividends, interest, and rent (thousands of dollars)"
	91   "Personal dividend income"
	92   "Personal interest income"
	93    "Imputed interest receipts 1/"
	94    "Monetary interest receipts"
	95   "Rental income of persons 2/"
	96    "Imputed rent"
	97 /;

parameter	d_40(r,i_40,yr)		Property income;
$gdxin 'sainc.gdx'
$load d_40

parameter	d_40tot(yr,i_40)	Income Totals;
d_40tot(yr,i_40) = sum(r,d_40(r,i_40,yr))/1e9;
*.display d_40tot; 

parameter	cr(yr,r,s)	Cash receipts for agricultural sectors;
$gdxin 'fiws.gdx'
$load cr

*	State Government Finances

set	cat /
	A	Current charges (revenue)
	B	Intergovernmental transfer from federal
	C	Intergovernmental transfer from state
	D	Intergovernmental transfer from local
	E	Current operations
	F	Construction
	G	Other capital outlay
	I	Interest payments:
	J	Welfare and cash assistance:
	L	Intergovernmental transfers to state
	M	Intergovernmental transfer to local:
	Q	Intergovernmental transfer from state to school districts:
	S	Intergovernmental transfer to fed
	T	Tax payments
	U	Other assessments,
	V	Contributions on behalf of local employees
	W	Cash and Deposits
	Y	Unemployment and workers comp,
	X	Employee contributions
	Z	Retirement system exhibit codes /,

	sgfi(*)	State and government finance items /

*	Long term debt:

	19T	"Beg LTD O/S-NG-public debt for private purpose"
	19U	"Beg LT Debt O/S NEC"

	24T	"LTD Iss-NG-public debt for private purpose"
	29U	"LTD ISS-Unsp-Other NEC"

	34T	"LTD Ret-NG-public debt for private purpose"
	39U	"LTD Ret-Unsp-Other NEC"

	44T	"LT Dbt O/S-NG-Industrial Rev"
	49U	"LTD Debt O/S-Unsp-Other NEC"

	61V	"Short Term Debt O/S-Beginning"
	64V	"Short Term Debt O/S-End of FY"

*	Current charges:

	A01	"Air Transportation Charges"
	A03	"Misc Comrcial Act NEC Charges"
	A09	"Elem Sec Ed Sch Lunch Charges"
	A10	"Elem Sec Educ Tuition and Transportation Charges"
	A12	"Elem Sec Educ NEC Charges"
	A16	"Higher Educ Auxiliary Charges"
	A18	"Higher Educ Tuition Charges"
	A21	"Education Other State Charges NEC"
	A36	"Hospital Charges"
	A44	"Regular Highway Charges"
	A45	"Toll Highway Charges"
	A50	"Housing & Comm Dev Charges"
	A59	"Nat Resources NEC Charges"
	A60	"Parking Facilities Charges"
	A61	"Parks & Recreation Charges"
	A80	"Sewerage Charges"
	A81	"Solid Waste Charges"
	A87	"Water Trans & Terminal Charges"
	A89	"All Other NEC Charges"
	A90	"Liquor Stores Revenue"
	A91	"Water Utilities Revenue"
	A92	"Electric Utilities Revenue"
	A93	"Gas Utilities Revenue"
	A94	"Transit Utilities Revenue"

*	Intergovernmental transfer from federal

	B01	"Federal IG Air Transportation"
	B21	"Federal IG Education"
	B22	"Federal IG Emp Security Admin 1/"
	B30	"Federal IG General Support"
	B42	"Federal IG Health & Hospitals"
	B46	"Federal IG Highways"
	B50	"Fed IG Housing & Comm Dev"
	B59	"Fed IG Other Natural Resources"
	B79	"Fed IG Public Welfare"
	B80	"Federal IG Sewerage"
	B89	"Federal IG Other"
	B91	"Federal IG Water Utilities"
	B92	"Federal IG Electric Utilities"
	B93	"Federal IG Gas Utilities"
	B94	"Federal IG Transit Utilities"

*	Intergovernmental transfer from state:
*	
	C21	"State IG Education"
	C30	"State IG Other General Support"
	C42	"State IG Health & Hospitals"
	C46	"State IG Highways"
	C50	"State IG Housing & Comm Dev"
	C79	"State IG Public Welfare"
	C80	"State IG Sewerage"
	C89	"State IG Other"
	C91	"State IG Water Utilities"
	C92	"State IG Electric Utilities"
	C93	"State IG Gas Utilities"
	C94	"State IG Transit Utilities"

*	Intergovernmental transfer from local:

	D11	"School Intergovernmental - Interschool System"
	D21	"Local IG Education"
	D30	"Local IG General Support"
	D42	"Local IG Health & Hospitals"
	D46	"Local IG Highways"
	D50	"Local IG Housing & Comm Dev"
	D79	"Local IG Public Welfare"
	D80	"Local IG Sewerage"
	D89	"Local IG Other"
	D91	"Local IG Water Utilities"
	D92	"Local IG Electric Utilities"
	D93	"Local IG Gas Utilities"
	D94	"Local IG Transit Utilities"

*	Current operations:

	E01	"Air Trans Current Operation"
	E03	"Misc Comm Act-Current Oper"
	E04	"Correction Insts-Current Oper"
	E05	"Correction NEC-Current Oper"
	E12	"Elem Sec Educ-Current Oper"
	E16	"Higher Education-Aux-Cur Oper"
	E18	"Higher Educ Current Operation"
	E21	"State Education-NEC-Current Oper"
	E22	"Employment Sec Admin-Cur Op 1/"
	E23	"Financial Adm-Curr Operation"
	E24	"Local Fire Protection Curr Operation"
	E25	"Judicial-Current Operation"
	E29	"Central Staff-Curr Operation"
	E31	"General Public Bldg-Curr Oper"
	E32	"Health-Current Operation"
	E36	"Hospitals-Current Oper"
	E44	"Regular Highways-Current Oper"
	E45	"Toll Highways-Current Oper"
	E50	"Housing & Comm Dev-Curr Oper"
	E52	"Libraries-Current Operation"
	E59	"Natural Resources NEC-Cur Op"
	E60	"Parking-Current Operation"
	E61	"Parks & Rec-Current Operation"
	E62	"Police Protection-Current Oper"
	E66	"Protective Inspection-Curr Op"
	E74	"Welfare-Vendor Payments-Med"
	E75	"Welfare-Vendor Payments-NEC"
	E77	"Welfare Insts-Curr Operation"
	E79	"Welfare NEC-Current Operation"
	E80	"Sewerage-Current Operation"
	E81	"Solid Waste Mgt - Current Oper"
	E85	"State Veterans' Assistance-Current Op"
	E87	"Water Transport-Current Oper"
	E89	"General NEC-Current Operation"
	E90	"Liquor Stores-Current Oper"
	E91	"Water Utilities-Current Oper"
	E92	"Electric Utilities-Current Op"
	E93	"Gas Utilities-Current Oper"
	E94	"Transit Utilities-Current Op"

*	Construction:

	F01	"Air Trans Construction"
	F03	"Misc Comm Act-Construction"
	F04	"Correction Insts-Construction"
	F05	"Correction-NEC-Construction"
	F12	"Elem Sec Educ-Construction"
	F16	"Higher Education-Aux-Constr"
	F18	"Higher Educ Construction"
	F21	"State Education-NEC-Construction"
	F22	"Employment Sec Adm-Const"
	F23	"Financial Adm-Construction"
	F24	"Local Fire Protection Construction"
	F25	"Judicial-Construction"
	F29	"Central Staff-Construction"
	F31	"General Public Bldg-Constr"
	F32	"Health-Construction"
	F36	"Hospitals-Construction"
	F44	"Regular Highways-Construction"
	F45	"Toll Highways-Construction"
	F50	"Housing & Comm Dev-Constr"
	F52	"Libraries-Construction"
	F59	"Natural Resources NEC-Constr"
	F60	"Parking-Construction"
	F61	"Parks & Rec-Construction"
	F62	"Police Protection-Construction"
	F66	"Protective Inspection-Constr"
	F77	"Welfare Insts-Construction"
	F79	"Welfare NEC-Construction"
	F80	"Sewerage-Construction"
	F81	"Solid Waste Mgt-Construction"
	F85	"State Veterans' Assistance-Construction"
	F87	"Water Transport-Construction"
	F89	"General NEC-Construction"
	F90	"Liquor Stores-Construction"
	F91	"Water Utilities-Construction"
	F92	"Electric Utilities-Constr"
	F93	"Gas Utilities-Construction"
	F94	"Transit Utilities-Construction"

*	Other capital outlay:

	G01	"Air Trans Other Capital Outlay"
	G03	"Misc Comm Act-Other Cap"
	G04	"Correction Insts-Other Cap Out"
	G05	"Correction-NEC-Other Cap Out"
	G12	"Elem Sec Educ-Other Cap Outlay"
	G16	"Higher Education-Aux-Other Cap"
	G18	"Higher Educ Other Capital Out"
	G21	"State Education-NEC-Other Cap Out"
	G22	"Employment Sec Admin-Other Cap"
	G23	"Financial Adm-Other Cap Outlay"
	G24	"Local Fire Proction Other Cap Outlay"
	G25	"Judicial-Other Capital Outlay"
	G29	"Central Staff-Other Cap Out"
	G31	"General Public Bldg-Other Cap"
	G32	"Health-Other Capital Outlay"
	G36	"Hospitals-Other Cap Out"
	G44	"Regular Highways-Other Cap Out"
	G45	"Toll Highways-Other Cap Outlay"
	G50	"Housing & Comm Dev-Other Cap"
	G52	"Libraries-Other Capital Outlay"
	G59	"Natural Resource NEC-Other Cap"
	G60	"Parking-Other Capital Outlay"
	G61	"Parks & Rec-Other Capital Out"
	G62	"Police Protection-Othr Cap Out"
	G66	"Protective Inspec-Othr Cap Out"
	G77	"Welfare Insts-Other Cap Outlay"
	G79	"Welfare NEC-Other Capital Out"
	G80	"Sewerage-Other Capital Outlay"
	G81	"Solid Waste Mgt-Other Cap Out"
	G85	"State 'Veterans' Assistance-Other Cap Out"
	G87	"Water Transport-Other Cap out"
	G89	"General NEC-Other Capital Out"
	G90	"Liquor Stores-Other Cap Out"
	G91	"Water Utilities-Other Cap Out"
	G92	"Electric Utilities-Other Cap"
	G93	"Gas Utilities-Other Cap Out"
	G94	"Transit Utilities-Othr Cap Out"

*	Interest payments:

	I89	"General Interest on Debt"
	I91	"Water Utilities-Interest"
	I92	"Electric Utilities-Interest"
	I93	"Gas Utilities-Interest on Debt"
	I94	"Transit Utilities-Interest"

*	Welfare and cash assistance:

	J19	"Scholarships & Other Subsidies"
	J67	"Welfare-Categorical Cash Asst"
	J68	"Welfare-Cash Assistance"
	J85	"Assistance and Subsidies",

*	Intergovernmental transfers to state

	L01	"Air Trans IG to State"
	L04	"Correctional Instituions IG to State"
	L05	"Correction-NEC-IG to State"
	L12	"Elem Sec Educ-IG to State"
	L18	"Higher Education IG to State"
	L23	"Financial Adm-IG to State"
	L25	"Judicial-IG to State"
	L29	"Central Staff-IG to State"
	L32	"Health-IG to State"
	L36	"Hospitals-IG to State"
	L44	"Regular Highways-IG to State"
	L50	"Housing & Comm Dev-IG to State"
	L52	"Libraries-IG to State"
	L59	"Natural Res NEC-IG to State"
	L60	"Parking-IG to State"
	L61	"Parks & Recreation-IG to State"
	L62	"Police Protection-IG to State"
	L66	"Protective Insp-IG to State"
	L67	"Welfare-Categorical-IG to St"
	L79	"Welfare NEC-IG to State"
	L80	"Sewerage-IG to State"
	L81	"Solid Waste Mgt-IG to State"
	L87	"Water Transport-IG to State"
	L89	"General NEC-IG to State"
	L91	"Water Utilities-IG to State"
	L92	"Elec Utilities-IG to State"
	L93	"Gas Utilities-IG to State"
	L94	"Transit Utilities-IG to State"

*	Intergovernmental transfer to local:

	M01	"Air Trans IG to Local NEC"
	M04	"Correctional Instituions IG to Local"
	M05	"Correction-NEC-IG to Local NEC"
	M12	"Elem Sec Educ-IG to Local NEC"
	M18	"Higher Educ IG to Local NEC"
	M21	"State Education-NEC-IG to Local NEC"
	M23	"Financial Adm-IG-Local NEC"
	M24	"Fire Protect IG to Local NEC"
	M25	"Judicial-IG to Local NEC"
	M29	"Central Staff-IG to Local NEC"
	M30	"General Support-IG-Local NEC"
	M32	"Health-IG to Local NEC"
	M36	"Hospitals-IG to Local"
	M44	"Regular Highways-IG-Local Nec"
	M50	"Housing & Comm Dev-IG-Loc NEC"
	M52	"Libraries-IG to Local NEC"
	M59	"Natural Rec NEC-IG-Local NEC"
	M60	"Parking-IG to Local NEC"
	M61	"Parks & Rec-IG to Local NEC"
	M62	"Police Protect-IG to Local NEC"
	M66	"Protective Insp-IG-Local Nec"
	M67	"Welfare-Categorical-IG to Loc"
	M68	"Welfare-Cash-IG-Local NEC"
	M79	"Welfare NEC-IG to Local NEC"
	M80	"Sewerage-IG to Local NEC"
	M81	"Solid Waste Mgt-IG to Locl NEC"
	M87	"Water Transport-IG-Local NEC"
	M89	"General NEC-IG-Local NEC"
	M91	"Water Utilities-IG to Local"
	M92	"Elec Utilities-IG to Local"
	M93	"Gas Utilities-IG to Local"
	M94	"Transit Utilities-IG to Local"

*	Intergovernmental transfer from state to school districts:

	Q12	"Elem Sec Educ-State IG to Sch Dists (Was this ever decided?)"
	Q18	"Higher Educ State IG to Sch Dists"

*	Intergovernmental transfer to fed:

	S67	"Welfare-Categorical-IG to Fed"
	S89	"General NEC-IG to Federal"

*	Tax payments:

	T01	"Property Tax"
	T09	"Total General Sales Taxes"
	T10	"Alcoholic Beverage Sales Tax"
	T11	"Amusement Tax"
	T12	"Insurance Premium Tax"
	T13	"Motor Fuels Sales Tax"
	T14	"Parimutuels Tax"
	T15	"Public Utilities Tax"
	T16	"Tobacco Sales Tax"
	T19	"Other Selective Sales Taxes"
	T20	"Alcoholic Beverage License Tax"
	T21	"Amusement License Tax"
	T22	"Corporation License Tax"
	T23	"Hunting & Fishing License"
	T24	"Motor Vehicle License"
	T25	"Motor Vehicle Operators Lic"
	T27	"Public Utility License Tax"
	T28	"Occup & Business License, NEC"
	T29	"Other License Tax"
	T40	"Indiv Income Tax"
	T41	"Corporation Net Income Tax"
	T50	"Death & Gift Tax"
	T51	"Documentary & Stock Trans Tax"
	T53	"Severance Tax"
	T99	"Taxes, NEC"

*	Other assessments:

	U01	"Special Assessments"
	U11	"Sale of Property 2/"
	U20	"Interest Earnings"
	U30	"Fines & Forfeits"
	U40	"Rents"
	U41	"Royalties"
	U50	"Donations From Private Sources"
	U95	"Net Lottery Revenue"
	U99	"Misc General Revenue NEC"

	V87	"State Contributions to Own System, on Behalf of Local Employees"

	W01	"Sinking Fund-Cash & Deposits"
	W31	"Bond Fund-Cash & Deposits"
	W61	"Other Funds-Cash & Deposits"

	Y01	"Unemployment-Contribution"
	Y02	"Unemployment-Interest Revenue"
	Y04	"Unemployment-Federal Advances"
	Y05	"Unemployment-Benefit Payments"
	Y06	"Unemployment-Ext & Spec Pmts"
	Y07	"Unemployment-Bal In US Treas"
	Y08	"Unempl-Other Bal-Pos or Neg"

	Y11	"Workers Comp-Other Contribs"
	Y12	"Workers Comp-Interest Earnings"
	Y14	"Workers Comp-Benefit Pmts"
	Y21	"'Workers Comp-Cash & Assets"
	Y51	"Other In Trst-Other Ctrb"
	Y52	"Other In Trust-Interest Rev"
	Y53	"Other Ins Trst-Benefit Paymts"
	Y61	"Other Ins Trust-Cash&Deposits"

*	SUB-CATEGORY: Employee Contributions

	X01	"Contributions From Local Government Employees"
	X02	"Contributions From State Government Employees"
	X04	"From Parent Local Government"
	X05	"Contributions from Other Governments"
	X06	"State Contributions To Own System, Total"
	X08	"Other earnings: total earnings on investments"
	X11	"Benefit Payments (Federal, states, and locals)",
	X12	"Withdrawals (Federal, states, and locals)",
	X21	"Total Cash and Short-Term Investments P",
	X30	"Total Federal Government Securities",
	X40	"Corporate bonds",
	X42	"Mortgages Held Directly",
	X44	"Total Other Securities",
	X47	"Other Investments",
	X50	"?",
	X62	"?",
	X71	"?",
	X80	"?",

*	Exhibit Codes Related to Public Employee Retirement Systems Receipts 

	Z00	"Total Salaries & Wages" 
	Z01	"Number of Active Members",
	Z71	"Interest Earnings"
	Z72	"Dividend Earnings"
	Z73	"Other Investment Earnings"
	Z77	"Total Corporate Bonds",
	Z78	"Corporate Stocks"
	Z91	"Losses on Investments (Realized and Unrealized)"
	Z95	"Other Receipts, NEC"
	Z96	"Gains on Investments, (Realized and Unrealized)"
	Z98	"Rentals from State Government"
	Z99	"State Contributions to Own System, on Behalf of State Employees"/,

	catmap(cat,sgfi) Mapping to categories;

catmap(cat,sgfi)$(ord(cat.tl,1)=ord(sgfi.tl,1)) = sgfi(sgfi);

parameter	sgfcat(yr,r,cat)	State and local government totals by category,
		sgf(yr,r,sgfi)		State and local government totals by item;

$gdxin 'sgf.gdx'
$load sgfcat sgf

set	asfi(*)		ASF items /
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

parameter	asfin(yr,asfi,r)	State government finances;
$gdxin 'asfin.gdx'
$load asfin


*	------------------------------------------------------------------

set	yc(yr)	Years to calibrate /2017,2022/;

set	rs(r)	Regions which are states;
rs(r) = yes$(not sameas(r,"usa"));


parameter	crtot(yr,s)	Aggregate cash receipts;
crtot(yr,s) = sum(rs(r),cr(yr,r,s));

parameter	totgdp(s,yr)		Total GDP;
totgdp(s,yc(yr)) = sum(rs(r),sagdp(r,s,yr,"t2"));
*.display totgdp;

parameter    region_shr(yr,r,*)		Regional shares based on GSP or consumption;

region_shr(yc(yr),rs(r),s)$totgdp(s,yr) = sagdp(r,s,yr,"t2")/totgdp(s,yr);
region_shr(yc(yr),rs(r),s)$crtot(yr,s) = cr(yr,r,s)/crtot(yr,s);

region_shr(yc(yr),rs(r),"c") = sasummary(r,"7",yr)/sum(r.local,sasummary(r,"7",yr));
region_shr(yc(yr),rs(r),"k") = d_40(r,"90",yr)/sum(r.local,d_40(r,"90",yr));
region_shr(yc(yr),rs(r),"gdp") = sasummary(r,"1",yr)/sum(r.local,sasummary(r,"1",yr));

parameter	ke0(yr,r)	Regional capital endowment;
ke0(yc(yr),rs(r)) = region_shr(yr,r,"k") * sum(s,kd0_(yr,"usa",s));

*	Regional shares of GDP determine shares of production.  
*	Assume common technology in all states:

ys0_(yc(yr),rs(r),s)   = region_shr(yr,r,s) * ys0_(yr,"usa",s); 
id0_(yc(yr),rs(r),g,s) = region_shr(yr,r,s) * id0_(yr,"usa",g,s); 
ld0_(yc(yr),rs(r),s)   = region_shr(yr,r,s) * ld0_(yr,"usa",s); 
kd0_(yc(yr),rs(r),s)   = region_shr(yr,r,s) * kd0_(yr,"usa",s); 
ty0_(yc(yr),rs(r),s)   = ty0_(yr,"usa",s); 

*	Flag for production in individual states:

y_(yc(yr),rs(r),s) = yes$ys0_(yb,r,s);

fd0(yr,rs(r),g,xd) = region_shr(yr,r,"gdp")*fd0(yr,"usa",g,xd); 

*	Note to self: need to be sure we are dropping values for USA, 
*	and make sure the aggregate value does not affect shares.

*	Regional shares of consumption:

cd0(yc(yr),rs(r),g) = region_shr(yr,r,"c") * cd0(yr,"usa",g); 

ta(yc(yr),rs(r),g)  = ta(yr,"usa",g); 
ta0(yc(yr),rs(r),g) = ta0(yr,"usa",g); 
tm(yc(yr),rs(r),g)  = tm(yr,"usa",g); 
tm0(yc(yr),rs(r),g) = tm0(yr,"usa",g); 

*	Use market clearance to determine absorption:

a0(yc(yr),rs(r),g) = max(0,sum(s,id0_(yr,r,g,s)) + cd0(yr,r,g) + sum(xd,fd0(yr,r,g,xd)));
pa_(yr,rs(r),g) = a0(yr,r,g);

parameter	ashr(yr,r,g)	Regional share of absorption;

ashr(yc(yr),rs(r),g)$sum(r.local$rs(r),a0(yr,r,g)) = a0(yr,r,g)/sum(r.local$rs(r),a0(yr,r,g));
option ashr:3:0:1;
display ashr;

md0(yc(yr),rs(r),mrg,g) = ashr(yr,r,g) * md0(yr,"usa",mrg,g); 
m0(yc(yr),rs(r),g)      = ashr(yr,r,g) * m0(yr,"usa",g);	  
ms0(yc(yr),rs(r),g,mrg) = ms0(yr,"usa",g,mrg)/sum(g.local,ms0(yr,"usa",g,mrg)) * md0(yr,r,mrg,g);
ns0(yc(yr),rs(r),g) = 0.5 * (ys0_(yr,r,g)-x0(yr,r,g));
yd0(yc(yr),rs(r),g) = 0.5 * (ys0_(yr,r,g)-x0(yr,r,g));
rx0(yc(yr),rs(r),g)     = ashr(yr,r,g) * rx0(yr,"usa",g);     
x0(yc(yr),rs(r),g)      = region_shr(yr,r,g) * (x0(yr,"usa",g) - rx0(yr,"usa",g)) + rx0(yr,r,g);
display md0, m0, ms0, ns0, yd0, rx0, x0;

*	Code for calibration:

variables	OBJ		Objective (targetting);

nonnegative
variables	x0_b(r,g)	Exports
		rx0_b(r,g)	Re-exports
		m0_b(r,g)	Imports
		ms0_b(r,g,mrg)	Margin supply
		ns0_b(r,g)	Supply to the national market
		nd0_b(r,g)	Demand from the national market
		yd0_b(r,g)	Domestic supply;

equations	objdef, margins, supply, national, demand, imports, exports, reexports;

objdef..	OBJ =E=   sum(rs(r),
		  sum(g$x0(yb,r,g),		x0(yb,r,g) *      (sqr(x0_b(r,g)/x0(yb,r,g)-1)))
		+ sum(g$rx0(yb,r,g),		rx0(yb,r,g) *     (sqr(rx0_b(r,g)/rx0(yb,r,g)-1)))
		+ sum((g,mrg)$ms0(yb,r,g,mrg),	ms0(yb,r,g,mrg) * (sqr(ms0_b(r,g,mrg)/ms0(yb,r,g,mrg))-1))
		+ sum(g$ns0(yb,r,g),		ns0(yb,r,g) *     (sqr(ns0_b(r,g)/ns0(yb,r,g))-1))
		+ sum(g$yd0(yb,r,g),		yd0(yb,r,g) *     (sqr(yd0_b(r,g)/yd0(yb,r,g))-1)) ) 

		+ 10 * sum(rs(r),
		  sum(g$(not x0(yb,r,g)),		x0_b(r,g))
		+ sum(g$(not rx0(yb,r,g)),		rx0_b(r,g))
		+ sum((g,mrg)$(not ms0(yb,r,g,mrg)),	ms0_b(r,g,mrg))
		+ sum(g$(not ns0(yb,r,g)),		ns0_b(r,g))
		+ sum(g$(not yd0(yb,r,g)),		yd0_b(r,g)));

margins(rs(r),mrg)..	sum(g,ms0_b(r,g,mrg)) =e= sum(g,md0(yb,r,mrg,g));

supply(rs(r),g)..	ys0_(yb,r,g) =e= x0_b(r,g) - rx0_b(r,g) + 
						sum(mrg,ms0_b(r,g,mrg)) +
						ns0_b(r,g) + yd0_b(r,g);

national(g)..		sum(rs(r),ns0_b(r,g)) =e= sum(rs(r),nd0_b(r,g));

demand(rs(r),g)..	nd0_b(r,g) + yd0_b(r,g) =e= a0(yb,r,g)*(1-ta(yb,r,g)) 
					- (m0_b(r,g)-rx0_b(r,g))*(1+tm(yb,r,g)) 
					- sum(mrg,md0(yb,r,mrg,g));

imports(g)..		sum(rs(r),m0_b(r,g)) =e= m0(yb,"usa",g); 

exports(g)..		sum(rs(r),x0_b(r,g)) =e= x0(yb,"usa",g);

*	We have to permit some degree of freedom in the output market, as we 
*	have fixed ys0, m0 and x0:

reexports(g)$no..	sum(rs(r),rx0_b(r,g)) =e= rx0(yb,"usa",g);


model calib /objdef, margins, supply, national, demand, imports, exports, reexports/;

loop(yc,
	yb(yc) = yes;

	x0_b.UP(rs(r),g)      = inf;
	m0_b.UP(rs(r),g)      = inf;
	rx0_b.UP(rs(r),g)     = inf;
	ms0_b.UP(rs(r),g,mrg) = inf;
	ns0_b.UP(rs(r),g)     = inf;
	nd0_b.UP(rs(r),g)     = inf;
	yd0_b.UP(rs(r),g)     = inf;

	x0_b.L(rs(r),g) = x0(yb,r,g);
	rx0_b.L(rs(r),g) = rx0(yb,r,g);
	ms0_b.L(rs(r),g,mrg) = ms0(yb,r,g,mrg);
	ns0_b.L(rs(r),g) = ns0(yb,r,g);
	yd0_b.L(rs(r),g) = yd0(yb,r,g);

	option qcp = cplex;
	solve calib using qcp minimizing OBJ;

	x0(yb,rs(r),g) = x0_b.L(r,g);
	vx0(yc(yr),g) = sum(r,x0(yr,r,g));
	rx0(yb,rs(r),g) = rx0_b.L(r,g);
	ms0(yb,rs(r),g,mrg) = ms0_b.L(r,g,mrg);
	ns0(yb,rs(r),g) = ns0_b.L(r,g);
	yd0(yb,rs(r),g) = yd0_b.L(r,g);
	vb(yc(yr),r) = sum(g,cd0(yr,r,g)) + sum((g,xd),fd0(yr,r,g,xd)) 
	- sum(s,ld0(yr,r,s)+kd0(yr,r,s))
	- sum(g$a0(yr,r,g), 
		(m0(yr,r,g)-rx0(yr,r,g))*tm(yr,r,g) 
		+ a0(yr,r,g)*ta(yr,r,g))
	- sum(y_(yr,r,s),sum(g,ys0(yr,r,s,g))*ty(yr,r,s));
);

$exit

loop(yc,
	yb(yc) = yes;
	ED.L(g)$vx0(yb,g) = 1;
	y_(yc,r,s) = yes$ys0_(yc,r,s)$rs(r);
	pa_(yc,r,g) = a0(yc,r,g)$rs(r);
	ra_(r) = rs(r);
	id0_(yc,r,g)$(not pa_(yc,r,g)) = 0;

$include symmetric.gen
	solve symmetric using mcp;
);

		
$exit

*	We shouldn't need to delete the single region dataset, but here is
*	what would do it.

ys0_(yr,"usa",s) = 0;
id0_(yr,"usa",g,s) = 0;
a0(yr,"usa",g) = 0;
ld0_(yr,"usa",s) = 0;
kd0_(yr,"usa",s) = 0;
ty0_(yr,"usa",s) = 0;
fd0(yr,"usa",g,xd) = 0;
cd0(yr,"usa",g) = 0;
ta(yr,"usa",g) = 0;
ta0(yr,"usa",g) = 0;
tm(yr,"usa",g) = 0;
tm0(yr,"usa",g) = 0;
md0(yr,"usa",mrg,g) = 0;
m0(yr,"usa",g) = 0;
rx0(yr,"usa",g) = 0;
x0(yr,"usa",g) = 0;
vb(yr,"usa") = 0;

