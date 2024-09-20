$title		Read State and Local Government Dataset

*	https://www.census.gov/programs-surveys/gov-finances.html

set	lvl	Level of estimate code /
	1	"State and local government total",
	2	"State government total",
	3	"Local government total",
	5	"County government total",
	6	"City/municipality government total",
	7	"Township government total",
	8	"Special district government total",
	9	"School district government total" /;

set	fips /
	03	American Samoa
	07	Canal Zone
	14	Guam
	43	Puerto Rico

	00	United states
	01	Alabama
	02	Alaska
	04	Arizona
	05	Arkansas
	06	California
	08	Colorado
	09	Connecticut
	10	Delaware
	11	District of Columbia
	12	Florida
	13	Georgia
	15	Hawaii
	16	Idaho
	17	Illinois
	18	Indiana
	19	Iowa
	20	Kansas
	21	Kentucky
	22	Louisiana
	23	Maine
	24	Maryland
	25	Massachusetts
	26	Michigan
	27	Minnesota
	28	Mississippi
	29	Missouri
	30	Montana
	31	Nebraska
	32	Nevada
	33	New Hampshire
	34	New Jersey
	35	New Mexico
	36	New York
	37	North Carolina
	38	North Dakota
	39	Ohio
	40	Oklahoma
	41	Oregon
	42	Pennsylvania
	44	Rhode Island
	45	South Carolina
	46	South Dakota
	47	Tennessee
	48	Texas
	49	Utah
	50	Vermont
	51	Virginia
	53	Washington
	54	West Virginia
	55	Wisconsin
	56	Wyoming /;

set	usps(*);

set	smap(usps<,fips) /
AL.01, AK.02, AZ.04, AR.05, CA.06, CO.08, CT.09, DE.10, DC.11,
FL.12, GA.13, HI.15, ID.16, IL.17, IN.18, IA.19, KS.20, KY.21, LA.22,
ME.23, MD.24, MA.25, MI.26, MN.27, MS.28, MO.29, MT.30, NE.31, NV.32,
NH.33, NJ.34, NM.35, NY.36, NC.37, ND.38, OH.39, OK.40, OR.41, PA.42,
RI.44, SC.45, SD.46, TN.47, TX.48, UT.49, VT.50, VA.51, WA.53, WV.54,
WI.55, WY.56 /

$ontext

Below are item codes and their titles, as included in the Census of
Governments Finance survey data files. Additional information about
these codes, as well as descriptions and definitions, can be found in
the

https://www2.census.gov/govs/pubs/classification/2006_classification_manual.pdf

$offtext

set	code Item Codes and Short Descriptions /

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
	Z99	"State Contributions to Own System, on Behalf of State Employees"/;


set	yr /12*21/;

$include sgf\data

set	yrs /2012*2021/;

parameter	sgf(yrs,usps,code)	State and local government totals;

loop((smap(usps,fips),yr,yrs)$(yrs.val=2000+yr.val),

*	Only read lvl=1 (State and local government total)

	sgf(yrs,usps,code) = data(yr,fips,"1",code,"amount")/1e6;
);

set	codes(code)	Financial categories -- state and local government;

option codes<sgf;
codes(codes)$code(codes) = code(codes);

option codes:0:0:1;
display codes;

set	dropped(code)	Dropped codes;
dropped(code) = code(code)$(not codes(code));
option dropped:0:0:1;
display dropped;

set	cat			/
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

	catmap(cat,code)	Category map;

catmap(cat,codes)$(ord(cat.tl,1)=ord(codes.tl,1)) = codes(codes);

option catmap:0:0:1;
display catmap;

parameter	sgfcat(yrs,usps,cat)	State and local government totals by category;
sgfcat(yrs,usps,cat) = sum(catmap(cat,codes),sgf(yrs,usps,codes));
option sgfcat:1:2:1;
display sgfcat;

execute_unload 'sgf.gdx', sgf, sgfcat, yrs, codes, cat;
