$title	Read the ASFIN database

set	r	States /
	AL, AK, AR, AZ, CA, CO, CT, DC, DE, FL, GA, HI, IA, ID, IL, IN, KS,
	KY, LA, MA, MD, ME, MI, MN, MO, MS, MT, NC, ND, NE, NH, NJ, NM, NV,
	NY, OH, OK, OR, PA, RI, SC, SD, TN, TX, UT, VA, VT, WA, WV, WI, WY /;

set	row /r1*r100/;

set	i	Data items/
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

set	yr/2007*2022/;

parameter	data(yr,row,i,r)	State Government Finances;
$call gdxmerge asfin\data\*.gdx 
$gdxin merged.gdx
$loaddc data

set		yr_row_i(yr,row,i);
option yr_row_i<data;
option yr_row_i:0:0:1;
display yr_row_i;

parameter	asfin(yr,i,r)	State government finances;
asfin(yr,i,r) = sum(row,data(yr,row,i,r));

parameter	assigned;
loop(yr,
	assigned = no;
	loop(yr_row_i(yr,row,"Total expenditure"),
	  assigned = yes;
	  asfin(yr,"Total expenditure",r)$(not assigned) = data(yr,row,"Total expenditure",r);
	  asfin(yr,"Total expenditure*",r)$assigned = data(yr,row,"Total expenditure",r);
	);
);

set	j(i);
option j<asfin;
option j:0:0:1;
display j;

