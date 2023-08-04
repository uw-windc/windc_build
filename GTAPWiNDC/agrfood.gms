set	agrfoo(i)	Agricultural and food products /
	fbp  "Food and beverage and tobacco products (311FT)",
	pdr  "Paddy rice",
	wht  "Wheat",
	gro  "Cereal grains nec",
	v_f  "Vegetables, fruit, nuts",
	osd  "Oil seeds",
	c_b  "Sugar cane, sugar beet",
	pfb  "Plant-based fibers",
	ocr  "Crops nec",
	ctl  "Bovine cattle, sheep, goats and horses",
	oap  "Animal products nec",
	rmk  "Raw milk"/;


parameter	expend(*,i,r)	Household consumption expenditures;
expend("$",agrfoo(i),r) = vdfm(i,"c",r)*(1+rtfd0(i,"c",r)) + vifm(i,"c",r)*(1+rtfi0(i,"c",r));
expend("%",agrfoo(i),r) = 100 * expend("$",i,r) / sum(i.local,
				(vdfm(i,"c",r)*(1+rtfd0(i,"c",r)) + vifm(i,"c",r)*(1+rtfi0(i,"c",r))));
option expend:1:2:1;
display expend;
