$call gams mappings gdx=%gams.scrdir%mappings.gdx
set	j(*)	Commodities in the IO table;
$gdxin %gams.scrdir%mappings.gdx
$load j

set	commodities /
	1006A0	Rice
	12129A	Sugar
	180X00	Cocoa
	3104A0	Potash
	7102A0	Diamond
	76X000	Aluminium
	81100X	Antimony
	0713X0	Beans
	261000	Chromium
	270X00	Coal
	0901A0	Coffee
	52X000	Cotton
	26020X	Manganese
	8102A0	Molybdenum
	750X00	Nickel
	1202A0	Peanuts
	0902A0	Tea
	26140X	Titanium
	81019A	Tungsten
	2844X0	Uranium
	790X00	Zinc
	26151X	Zirconium
	2805X0	Barytes & Strontium
	25301X	Vermiculite
	81129A	"Gallium,indium,rhenium, thallium",
	26159X	"Niobium, tantalum, vanadium",
	260600	Bauxite
	281820	Alumina
	260500	Cobalt
	8105A0	Cobalt
	260300	Copper
	740XXX	Copper
	741XXX	Copper
	261690	Gold
	26011A	Iron & Steel
	7201X0	Iron & Steel
	721X00	Iron & Steel
	260700	Lead
	780X00	Lead
	251910	Magnesium
	8104A0	Magnesium
	270900	Crude Oil
	261610	Silver
	260900	Tin
	800X00	Tin
	0701A0	Potatoes
	070200	Tomatoes
	070310	Onions
	070320	Garlic
	070390	Leeks
	070410	Cauliflowers
	0704X0	Brussel sprouts
	0705A0	Lettuce
	070610	Carrots
	070700	Cucumbers
	070890	Legumes
	070920	Asparagus
	070930	Eggplants
	07095A	Mushrooms
	070960	Peppers
	070970	Spinach
	0709X0	"Celery, radishes",
	071320	Chickpeas
	071340	Lentils
	071350	Fava beans
	071390	Legumes nec
	071410	Cassava
	071420	Sweet potatoes
	071490	Roots
	080110	Coconuts
	080120	Brazil nuts
	080130	Cashews
	080211	Almonds
	080221	Hazelnuts
	080231	Walnuts
	080240	Chestnuts
	080250	Pistachios
	080290	Nuts nec
	080300	Bananas
	080410	Dates
	080420	Figs
	080430	Pineapples
	080440	Avocados
	080510	Oranges
	080520	Mandarins
	080530	Lemons
	080540	Grapefruit
	080590	Citruses
	080610	Grapes
	080710	Melons
	080720	Papayas
	080810	Apples
	080820	Pears
	080910	Apricots
	080920	Cherries
	080930	Peaches
	080940	Plums
	080X00	Mangoes
	081010	Strawberries
	0810X0	Berries
	090300	Mate
	09041A	Pepper
	090420	Dried peppers
	090500	Vanilla
	0906A0	Cinnamon
	090700	Cloves
	0908A0	Nutmeg
	0909A0	Seeds
	091010	Ginger
	0910X0	Spices
	1001A0	Wheat
	100200	Rye
	100300	Barley
	100400	Oats
	1005A0	Maize
	100700	Sorghum
	100810	Buckwheat
	100820	Millet
	100830	Canary seed
	100890	Other cereals
	120100	Soy beans
	120400	Linseed
	120500	Rapeseed
	120600	Sunflower seeds
	120720	Cotton seeds
	120740	Sesame seeds
	120750	Mustard seeds
	120791	Poppy seeds
	120799	Oil seeds nec
	120999	Seeds nec
	1210A0	Hops
	2401A0	Tobacco
	250100	Salt
	2504A0	Graphite
	250850	Sillimanite
	2510A0	Phosphate
	251200	Diatomite
	252010	Gypsum
	252400	Asbestos
	2525A0	Mica
	2526A0	Talc
	252910	Feldspar
	25292A	Fluorspar
	253090	Wollastonite
	2711X1	Natural Gas
	280120	Iodine
	280130	Bromine
	280450	Tellurium
	280480	Arsenic
	280490	Selenium
	280540	Mercury
	2840A0	Borates
	400110	Natural rubber
	53012A	Flax
	5303A0	Jute
	530599	Ramie
	810600	Bismuth
	8107A0	Cadmium
	81121A	Beryl
	811230	Germanium
	850650	Lithium
	2523X0	Cement
	25059X	Sand and gravel
	07131X	Peas
	71101A	Platinum
	71102A	Palladium
	71103A	Rhodium
	71104A	"Iridium, Osmium, Ruthenium",
	2846A0	Rare Earths /;

set	notj(commodities), notcommodity(j);
notj(commodities) = commodities(commodities)$(not j(commodities));
notcommodity(j) = j(j)$(not commodities(j));
option notj:0:0:1, notcommodity:0:0:1;
display notj, notcommodity;

$exit

set	hs6(*)	Mapping to HS6;

set	hsmap(commodities,hs6<) /
0701A0.070110	Seed potatoes
0701A0.070190	"Other potatoes, fresh or chilled",
070200.070200	"Tomatoes, fresh or chilled",
070310.070310	"Onions and shallots, fresh or chilled",
070320.070320	"Garlic, fresh or chilled",
070390.070390	"Leeks and other alliaceous vegetables, nes",
070410.070410	"Cauliflowers and headed broccoli, fresh or chil",
0704X0.070420	"Brussels sprouts, fresh or chilled",
0704X0.070490	"White and red cabbages, kohlrabi, kale...etc, f",
0705A0.070511	"Cabbage lettuce, fresh or chilled",
0705A0.070519	"Lettuce, fresh or chilled, (excl. cabbage lettu",
0705A0.070521	"Witloof chicory, fresh or chilled",
0705A0.070529	"Chicory, fresh or chilled, (excl. witloof)",
070610.070610	"Carrots and turnips, fresh or chilled",
0709X0.070690	Beetroot...radishes and other similar edible ro
070700.070700	"Cucumbers and gherkins, fresh or chilled",
07131X.070810	"Peas, fresh or chilled",
0713X0.070820	"Beans, fresh or chilled",
070890.070890	"Leguminous vegetables, fresh or chilled, nes",
070920.070920	"Asparagus, fresh or chilled",
070930.070930	"Aubergines, fresh or chilled",
0709X0.070940	"Celery, fresh or chilled",
07095A.070951	"Mushrooms, fresh or chilled",
07095A.070952	"Truffles, fresh or chilled",
070960.070960	"Fruits of genus Capiscum or Pimenta, fresh or c",
070970.070970	"Spinach, fresh or chilled",
0709X0.070990	"Other vegetables, fresh or chilled, nes",
0713X0.071021	"Shelled or unshelled peas, frozen",
07131X.071310	"Dried peas, shelled",
071320.071320	"Dried chickpeas, shelled",
0713X0.071331	"Dried beans, shelled",
0713X0.071332	"Dried adzuki beans, shelled",
0713X0.071333	"Dried kidney beans, incl. white pea beans, shel",
0713X0.071339	"Dried beans, shelled, nes",
071340.071340	"Dried lentils, shelled",
071350.071350	"Dried broad beans and horse beans, shelled",
071390.071390	"Dried leguminous vegetables, shelled, nes",
071410.071410	"Manioc, fresh or dried",
071420.071420	"Sweet potatoes, fresh or dried",
071490.071490	"Roots and tubers with high starch content, fres",
080110.080110	"Coconuts, fresh or dried",
080120.080120	"Brazil nuts, fresh or dried",
080130.080130	"Cashew nuts, fresh or dried",
080211.080211	"Almonds in shell, fresh or dried",
080221.080221	"Hazlenuts in shell, fresh or dried",
080231.080231	"Walnuts in shell, fresh or dried",
080240.080240	"Chestnuts, fresh or dried",
080250.080250	"Pistachio, fresh or dried",
080290.080290	"Other nuts, fresh or dried, nes",
080300.080300	"Bananas, including plantains, fresh or dried",
080410.080410	"Dates, fresh or dried",
080420.080420	"Figs, fresh or dried",
080430.080430	"Pineapples, fresh or dried",
080440.080440	"Avocados, fresh or dried",
080X00.080450	"Guavas, mangoes and mangosteens, fresh or dried",
080510.080510	"Oranges, fresh or dried",
080520.080520	"Mandarins, clementines, wilkings...etc, fresh o",
080530.080530	"Lemons and limes, fresh or dried",
080540.080540	"Grapefruit, fresh or dried",
080590.080590	"Citrus fruit, fresh or dried, nes",
080610.080610	Fresh grapes
080710.080710	"Melons and watermelons, fresh",
080720.080720	"Papaws (papayas), fresh",
080810.080810	"Apples, fresh",
080820.080820	"Pears and quinces, fresh",
080910.080910	"Apricots, fresh",
080920.080920	"Cherries, fresh",
080930.080930	"Peaches, including nectarines, fresh",
080940.080940	"Plums and sloes, fresh",
081010.081010	"Strawberries, fresh",
0810X0.081020	"Raspberries, blackberries, mulberries and logan",
0810X0.081040	"Cranberries, milberries...etc, fresh",
080X00.081090	"Other fruit, fresh, nes",
0901A0.090111	"Coffee, not roasted or decaffeinated",
0901A0.090112	"Decaffeinated coffee, not roasted",
0901A0.090121	"Roasted coffee, not decaffeinated",
0901A0.090122	"Roasted, decaffeinated coffee",
0901A0.090130	Coffee husks and skins
0902A0.090210	Green tea in immediate packings
0902A0.090220	"Green tea, nes",
0902A0.090230	Black tea (fermented) and partly fermented tea
0902A0.090240	"Black tea (fermented) and partly fermented tea,",
090300.090300	Mate
09041A.090411	Dried pepper (excl. crushed or ground)
09041A.090412	"Pepper, crushed or ground",
090420.090420	"Fruits of genus Capiscum or Pimenta, dried, cru",
090500.090500	Vanilla
0906A0.090610	"Cinnamon and cinnamon-tree flowers, neither cru",
0906A0.090620	"Cinnamon and cinnamon-tree flowers, crushed or",
090700.090700	"Cloves (whole fruit, cloves and stems)",
0908A0.090810	Nutmeg
0908A0.090820	Mace
0908A0.090830	Cardamoms
0909A0.090910	Seeds of anise or badian
0909A0.090920	Seeds of coriander
0909A0.090930	Seeds of cumin
0909A0.090940	Seeds of caraway
0909A0.090950	"Seeds of fennel; juniper berries",
091010.091010	Ginger
0910X0.091020	Saffron
0910X0.091030	Turmeric (curcuma)
0910X0.091091	Spice mixtures
0910X0.091099	"Other spices, nes",
1001A0.100110	Durum wheat
1001A0.100190	"Spelt, common wheat and meslin",
100200.100200	Rye
100300.100300	Barley
100400.100400	Oats
1005A0.100510	Maize seed
1005A0.100590	Maize (excl. seed)
1006A0.100610	Rice in the husk (paddy or rough)
1006A0.100620	Husked (brown) rice
100700.100700	Grain sorghum
100810.100810	Buckwheat
100820.100820	Millet
100830.100830	Canary seed
100890.100890	"Other cereal, nes",
120100.120100	Soya beans
1202A0.120210	"Ground-nuts in shell, not roasted or otherwise",
1202A0.120220	"Shelled ground-nuts, not roasted or otherwise c",
120400.120400	Linseed
120500.120500	Rape or colza seeds
120600.120600	Sunflower seeds
120720.120720	Cotton seeds
120740.120740	Sesamum seeds
120750.120750	Mustard seeds
120791.120791	Poppy seeds
120799.120799	"Other oil seeds and oleaginous fruits, nes",
120999.120999	"Other seeds, fruit and spores, of a kind used f",
1210A0.121010	"Hop cones (excl. ground, powdered or pellets),",
1210A0.121020	"Hop cones, ground, powdered or in pellets; lupu",
12129A.121291	"Sugar beet, fresh or dried",
12129A.121292	"Sugar cane, fresh or dried",
12129A.121299	Vegetable products used primarily for human con
180X00.180100	"Cocoa beans, whole or broken, raw or roasted",
180X00.180200	"Cocoa shells, husks, skins and other cocoa wast",
180X00.180310	"Cocoa paste, not defatted",
180X00.180320	"Cocoa paste, wholly or partly defatted",
180X00.180400	"Cocoa butter, fat and oil",
180X00.180500	"Cocoa powder, not containing added sugar or oth",
180X00.180610	"Cocoa powder, containing added sugar or other s",
180X00.180620	"Chocolate, etc, containing cocoa, in blocks, sl",
180X00.180631	"Chocolate, etc, containing cocoa, in blocks, sl",
180X00.180632	"Chocolate, etc, containing cocoa in blocks, sla",
180X00.180690	"Chocolate, etc, containing cocoa, not in blocks",
1202A0.200811	"Ground-nuts, preserved",
2401A0.240110	"Tobacco, not stemmed/stripped",
2401A0.240120	"Tobacco, partly or wholly stemmed/stripped",
2401A0.240130	Tobacco refuse
250100.250100	"Salt and pure sodium chloride; sea water",
2504A0.250410	Natural graphite in powder or in flakes
2504A0.250490	Other natural graphite (excl. in powder or in f
25059X.250590	"Natural sands, (excl. metal-bearing sands of Ch",
250850.250850	"Andalusite, kyanite and sillimanite",
2510A0.251010	"Unground natural calcium phosphates, aluminium",
2510A0.251020	"Ground natural calcium phosphates, aluminium ca",
2805X0.251110	Natural barium sulphate (barytes)
251200.251200	"Siliceous fossil meals (kieselguhr, tripolite,",
25059X.251710	"Pebbles, gravel, shingle and flint",
251910.251910	Natural magnesium carbonate (magnesite)
252010.252010	"Gypsum; anhydrite",
2523X0.252310	Cement clinkers
2523X0.252321	White portland cement
2523X0.252329	Portland cement (excl. white)
2523X0.252330	Aluminous cement
252400.252400	Asbestos
2525A0.252510	Crude mica and mica rifted into sheets or split
2525A0.252520	Mica powder
2525A0.252530	Mica waste
2526A0.252610	"Natural steatite, talc, not crushed or powdered",
2526A0.252620	"Natural steatite, talc, crushed or powdered",
252910.252910	Felspar
25292A.252921	Fluorspar containing by weight <=97% of calcium
25292A.252922	Fluorspar containing by weight >97% of calcium
25301X.253010	"Vermiculite, perlite and chlorites (unexpanded)",
253090.253090	"Other mineral substances, nes",
26011A.260111	Non-agglomerated iron ores and concentrates
26011A.260112	Agglomerated iron ores and concentrates
26020X.260200	"Manganese ores and concentrates, with a mangane",
260300.260300	Copper ores and concentrates
750X00.260400	Nickel ores and concentrates
260500.260500	Cobalt ores and concentrates
260600.260600	Aluminium ores and concentrates
260700.260700	Lead ores and concentrates
790X00.260800	Zinc ores and concentrates
260900.260900	Tin ores and concentrates
261000.261000	Chromium ores and concentrates
81019A.261100	Tungsten ores and concentrates
2844X0.261210	Uranium ores and concentrates
8102A0.261310	Roasted molybdenum ores and concentrates
8102A0.261390	Molybdenum ores and concentrates (excl. roasted
26140X.261400	Titanium ores and concentrates
26151X.261510	Zirconium ores and concentrates
26159X.261590	"Niobium, tantalum and vanadium ores and concent",
261610.261610	Silver ores and concentrates
261690.261690	Precious metal ores and concentrates (excl. sil
81100X.261710	Antimony ores and concentrates
26159X.262050	Ash and residues containing mainly vanadium
270X00.270111	"Anthracite, not agglomerated",
270X00.270112	"Bituminous coal, not agglomerated",
270X00.270119	"Other coal, not agglomerated, nes",
270X00.270120	"Briquettes, ovoids and similar solid fuels manu",
270X00.270210	"Lignite, not agglomerated",
270X00.270220	Agglomerated lignite
270900.270900	Petroleum oils and oils obtained from bituminou
2711X1.271111	"Natural gas, liquefied",
2711X1.271121	Natural gas in gaseous state
280120.280120	Iodine
280130.280130	"Fluorine; bromine",
280450.280450	"Boron; tellurium",
280480.280480	Arsenic
280490.280490	Selenium
2805X0.280519	Alkali metals (excl. sodium)
2805X0.280522	Strontium and barium
2846A0.280530	"Rare-earth metals, scandium and yttrium",
280540.280540	Mercury
281820.281820	"Aluminium oxide, other than artificial corundum",
2840A0.284011	Anhydrous disodium tetraborate (refined borax)
2840A0.284019	"Disodium tetraborate, not anhydrous",
2840A0.284020	"Other borates, nes",
2840A0.284030	Peroxoborates
2846A0.284610	Cerium compounds
2846A0.284690	"Compounds, inorganic or organic, of rare-earth",
3104A0.310410	"Carnallite, sylvite and other Crude natural pot",
3104A0.310420	Potassium chloride
3104A0.310430	Potassium sulphate
3104A0.310490	"Mineral or chemical fertilizers, potassic, nes",
400110.400110	"Natural rubber latex, in primary forms or in pl",
52X000.520100	"Cotton, not carded or combed",
52X000.520210	Yarn waste of cotton
52X000.520291	Garnetted stock of cotton
52X000.520299	"Cotton waste, nes",
52X000.520300	"Cotton, carded or combed",
52X000.520411	"Cotton sewing thread, with >=85% cotton, not pu",
52X000.520419	"Cotton sewing thread, with <85% cotton, not put",
52X000.520420	"Cotton sewing thread, put up for retail sale",
52X000.520511	"Uncombed single cotton yarn, with >=85% cotton,",
52X000.520512	"Uncombed single cotton yarn, with >=85% cotton,",
52X000.520513	"Uncombed single cotton yarn, with >=85% cotton,",
52X000.520514	"Uncombed single cotton yarn, with >=85% cotton,",
52X000.520515	"Uncombed single cotton yarn, with >=85% cotton,",
52X000.520521	"Combed single cotton yarn, with >=85% cotton, n",
52X000.520522	"Combed single cotton yarn, with >=85% cotton, n",
52X000.520523	"Combed single cotton yarn, with >=85% cotton, n",
52X000.520524	"Combed single cotton yarn, with >=85% cotton, n",
52X000.520525	"Combed single cotton yarn, with >=85% cotton, n",
52X000.520531	"Uncombed cabled cotton yarn, with >=85% cotton,",
52X000.520532	"Uncombed cabled cotton yarn, with >=85% cotton,",
52X000.520533	"Uncombed cabled cotton yarn, with >=85% cotton,",
52X000.520534	"Uncombed cabled cotton yarn, with >=85% cotton,",
52X000.520535	"Uncombed cabled cotton yarn, with >=85% cotton,",
52X000.520541	"Combed cabled cotton yarn, with >=85% cotton, n",
52X000.520542	"Combed cabled cotton yarn, with >=85% cotton, n",
52X000.520543	"Combed cabled cotton yarn, with >=85% cotton, n",
52X000.520544	"Combed cabled cotton yarn, with >=85% cotton, n",
52X000.520545	"Combed cabled cotton yarn, with >=85% cotton, n",
52X000.520611	"Uncombed single cotton yarn, with <85% cotton,",
52X000.520612	"Uncombed single cotton yarn, with <85% cotton,",
52X000.520613	"Uncombed single cotton yarn, with <85% cotton,",
52X000.520614	"Uncombed single cotton yarn, with <85% cotton,",
52X000.520615	"Uncombed single cotton yarn, with <85% cotton,",
52X000.520621	"Combed single cotton yarn, with <85% cotton, np",
52X000.520622	"Combed single cotton yarn, with <85% cotton, np",
52X000.520623	"Combed single cotton yarn, with <85% cotton, np",
52X000.520624	"Combed single cotton yarn, with <85% cotton, np",
52X000.520625	"Combed single cotton yarn, with <85% cotton, np",
52X000.520631	"Uncombed cabled cotton yarn, with <85% cotton,",
52X000.520632	"Uncombed cabled cotton yarn, with <85% cotton,",
52X000.520633	"Uncombed cabled cotton yarn, with <85% cotton,",
52X000.520634	"Uncombed cabled cotton yarn, with <85% cotton,",
52X000.520635	"Uncombed cabled cotton yarn, with <85% cotton,",
52X000.520641	"Combed cabled cotton yarn, with <85% cotton, np",
52X000.520642	"Combed cabled cotton yarn, with <85% cotton, np",
52X000.520643	"Combed cabled cotton yarn, with <85% cotton, np",
52X000.520644	"Combed cabled cotton yarn, with <85% cotton, np",
52X000.520645	"Combed cabled cotton yarn, with <85% cotton, np",
52X000.520710	"Cotton yarn (excl. sewing), put up for retail s",
52X000.520790	"Cotton yarn (excl. sewing), put up for retail s",
52X000.520811	"Unbleached plain cotton weave, with >=85% cotto",
52X000.520812	"Unbleached plain cotton weave, with >=85% cotto",
52X000.520813	"Unbleached 3 or 4-thread twill, with >=85% cott",
52X000.520819	"Unbleached woven cotton fabrics, nes, with >=85",
52X000.520821	"Bleached plain cotton weave, with >=85% cotton,",
52X000.520822	"Bleached plain cotton weave, with >=85% cotton,",
52X000.520823	Bleached 3 or 4-thread twill (incl. cross twill
52X000.520829	"Bleached woven cotton fabrics, nes, with >=85%",
52X000.520831	"Dyed plain cotton weave, with >=85% cotton, =<1",
52X000.520832	"Dyed plain cotton weave, with >=85% cotton, >10",
52X000.520833	"Dyed 3 or 4-thread twill (incl. cross twill), w",
52X000.520839	"Dyed woven cotton fabrics, with >=85% cotton, n",
52X000.520841	"Coloured plain cotton weave, with >=85% cotton,",
52X000.520842	"Coloured plain cotton weave, with >=85% cotton,",
52X000.520843	Coloured 3 or 4-thread twill (incl. cross twill
52X000.520849	"Coloured woven cotton fabrics, with >=85% cotto",
52X000.520851	"Printed plain cotton weave, with >=85% cotton,",
52X000.520852	"Printed plain cotton weave, with >=85% cotton,",
52X000.520853	Printed 3 or 4-thread twill (incl. cross twill)
52X000.520859	"Printed woven cotton fabrics, with >=85% cotton",
52X000.520911	"Unbleached plain cotton weave, with >=85% cotto",
52X000.520912	Unbleached 3 or 4-thread twill (incl. cross twi
52X000.520919	"Unbleached cotton fabrics, with >=85% cotton, >",
52X000.520921	"Bleached plain cotton weave, with >=85% cotton,",
52X000.520922	"Bleached 3 or 4-thread twill, >=85% cotton, >20",
52X000.520929	"Bleached woven cotton fabrics, with >=85% cotto",
52X000.520931	"Dyed plain cotton weave, with >=85% cotton, >20",
52X000.520932	"Dyed 3 or 4-thread twill (incl. cross twill), w",
52X000.520939	"Dyed woven cotton fabrics, with >=85% cotton, >",
52X000.520941	"Coloured plain cotton weave, with >=85% cotton,",
52X000.520942	"Denim, with >=85% cotton, >200g/m2",
52X000.520943	"Coloured 3 or 4-thread twill, with >=85% cotton",
52X000.520949	"Coloured woven cotton fabrics, with >=85% cotto",
52X000.520951	"Printed plain cotton weave, with >=85% cotton,",
52X000.520952	"Printed 3 or 4-thread twill, with >=85% cotton,",
52X000.520959	"Printed woven cotton fabrics, with >=85% cotton",
52X000.521011	"Unbleached plain cotton weave, with <85% cotton",
52X000.521012	"Unbleached 3 or 4-thread twill, with <85% cotto",
52X000.521019	"Unbleached woven cotton fabrics, nes, with <85%",
52X000.521021	"Bleached plain cotton weave, with <85% cotton,",
52X000.521022	"Bleached 3 or 4-thread twill, with <85% cotton,",
52X000.521029	"Bleached woven cotton fabrics, nes, with <85% c",
52X000.521031	"Dyed plain cotton weave, with <85% cotton, =<20",
52X000.521032	"Dyed 3 or 4-thread twill, with <85% cotton, =<2",
52X000.521039	"Dyed woven cotton fabrics, nes, with <85% cotto",
52X000.521041	"Coloured plain cotton weave, with <85% cotton,",
52X000.521042	"Coloured 3 or 4-thread twill, with <85% cotton,",
52X000.521049	"Coloured woven cotton fabrics, nes, with <85% c",
52X000.521051	"Printed plain cotton weave, with <85% cotton, =",
52X000.521052	"Printed 3 or 4-thread twill, with <85% cotton,",
52X000.521059	"Printed woven cotton fabrics, nes, with <85% co",
52X000.521111	"Unbleached plain cotton weave, with <85% cotton",
52X000.521112	"Unbleached 3 or 4-thread twill, with <85% cotto",
52X000.521119	"Unbleached woven cotton fabrics, nes, with <85%",
52X000.521121	"Bleached plain cotton weave, with <85% cotton,",
52X000.521122	"Bleached 3 or 4-thread twill, with <85% cotton,",
52X000.521129	"Bleached woven cotton fibres, nes, with <85% co",
52X000.521131	"Dyed plain cotton weave, with <85% cotton, >200",
52X000.521132	"Dyed 3 or 4-thread twill, with <85% cotton, >20",
52X000.521139	"Dyed woven cotton fabrics, nes, with <85% cotto",
52X000.521141	"Coloured plain cotton weave, with <85% cotton,",
52X000.521142	"Coloured denim, with <85% cotton, >200g/m2",
52X000.521143	"Coloured fabrics of 3 or 4-thread twill, with <",
52X000.521149	"Coloured woven cotton fabrics, nes, with <85% c",
52X000.521151	"Printed plain cotton weave, with <85% cotton, >",
52X000.521152	"Printed 3 or 4-thread twill, with <85% cotton,",
52X000.521159	"Printed woven cotton fabrics, nes, with <85% co",
52X000.521211	"Unbleached woven fabrics of cotton, =<200g/m2,",
52X000.521212	"Bleached woven fabrics of cotton, =<200g/m2, ne",
52X000.521213	"Dyed woven fabrics of cotton, =<200g/m2, nes",
52X000.521214	"Coloured woven fabrics of cotton, =<200g/m2, ne",
52X000.521215	"Printed woven fabrics of cotton, =<200g/m2, nes",
52X000.521221	"Unbleached woven fabrics of cotton, >200g/m2, n",
52X000.521222	"Bleached woven fabrics of cotton, >200g/m2, nes",
52X000.521223	"Dyed woven fabrics of cotton, >200g/m2, nes",
52X000.521224	"Coloured woven fabrics of cotton, >200g/m2, nes",
52X000.521225	"Printed woven fabrics of cotton, >200g/m2, nes",
53012A.530121	"Flax, broken or scutched, but not spun",
53012A.530129	"Flax, hackled or otherwise processed, but not s",
53012A.530130	Flax tow and waste (incl. yarn waste and garnet
5303A0.530310	"Jute, etc (excl. flax, true hemp and ramie), ra",
5303A0.530390	"Jute, etc (excl. flax, true hemp and ramie), ne",
530599.530599	"Processed ramie, etc, nes; tow, noils and waste",
25301X.680620	"Exfoliated vermiculite,expanded clays,foamed sl",
76X000.690220	"Refractory bricks etc >50% alumina Al2O3, silic",
7102A0.710210	Diamonds unsorted whether or not worked
7102A0.710221	"Diamonds industrial unworked or simply sawn, cl",
7102A0.710231	Diamonds non-industrial unworked or simply sawn
71101A.711011	Platinum unwrought or in powder form
71101A.711019	Platinum in other semi-manufactured forms
71102A.711021	Palladium unwrought or in powder form
71102A.711029	Palladium in other semi-manufactured forms
71103A.711031	Rhodium unwrought or in powder form
71103A.711039	Rhodium in other semi-manufactured forms
71104A.711041	"Iridium, osmium and ruthenium unwrought or in p",
71104A.711049	"Iridium, osmium and ruthenium in other semi-man",
7201X0.720110	"Pig iron,non-alloy,containing by wt.=<0.5% of p",
7201X0.720120	"Pig iron,non-alloy,containing by wt. >0.5% of p",
7201X0.720130	"Pig iron, alloy in primary forms",
26159X.720292	Ferro-vanadium
26159X.720293	Ferro-niobium
721X00.720521	"Powders, alloy steel",
721X00.720529	"Powders, iron or steel, other than alloy",
721X00.720610	"Ingots, iron or non-alloy steel, of a purity of",
721X00.720690	"Primary forms, iron or non-alloy steel, nes, of",
721X00.720712	"Semi-fin prod,iron or n-al steel,rect/ sq cross",
721X00.720719	"Semi-fin prod, iron or non-alloy steel, cntg by",
721X00.720720	"Semi-fin prod, iron or non-alloy steel, w/ carb",
721X00.720811	"Flat rlld prod, i/nas, in coil, hr,=>600mm w, >",
721X00.720812	"Flat rlld prod, i/nas, in coil, hr,=>600mm w, 4",
721X00.720813	"Flat rlld prod, i/nas, in coil, hr,=>600mm w, 3",
721X00.720814	"Flat rolled prod, i/nas, in coil, hr, =>600mm w",
721X00.720821	"Flat rolled prod, i/nas, in coil, hr, =>600mm w",
721X00.720822	"Flat rlld prod, i/nas, in coil, hr,=>600mm w, 4",
721X00.720823	"Flat rlld prod, i/nas, in coil, hr,=>600mm w, 3",
721X00.720824	"Flat rlld prod, i/nas, in coil, hr,=>600mm w, l",
721X00.720831	"Flat rolled prod, i/nas,nic,hr,=>600mm width, =",
721X00.720832	"Flat rolled prod, i/nas, nic, hr =>600mm wide,",
721X00.720833	"Flat rlld prod, i/nas, nic, hr=>600mm w, 4.75mm",
721X00.720834	"Flat rolled prod, i/nas,nic,hr=>600mm wide, 3mm",
721X00.720835	"Flat rolled prod, i/nas,nic,hr=>600mm wide, les",
721X00.720841	"Flat rolled prod, i/nas, nic, hr 600mm =<width",
721X00.720842	"Flat rolled prod, i/nas, not in coil, hr =>600m",
721X00.720843	"Flat rlld prod, i/nas, not in coil, hr=>600mm w",
721X00.720844	"Flat rolled prod, i/nas, not in coil, hr =>600m",
721X00.720845	"Flat rolled prod, i/nas, not in coil, hr =>600m",
721X00.720890	"Flat rolled prod, i/nas, not further worked tha",
721X00.720911	"Flat rolled prod, i/nas, in coil, cr, =>600mm w",
721X00.720912	"Flat rlld prod, i/nas, in coil, cr,=>600mm w, 1",
721X00.720913	"Flat rlld prod,i/nas,in coil,cr,=>600mm w,0.5mm",
721X00.720914	"Flat rlld prod, i/nas, in coil, cr,=>600mm w, <",
721X00.720921	"Flat rolled prod, i/nas, in coil, cr, =>600mm w",
721X00.720922	"Flat rolled prod, i/nas, in coil, cr, =>600mm w",
721X00.720923	"Flat rlld prod, i/nas, in coil, cr,=>600mm w, 0",
721X00.720924	"Flat rlld prod, i/nas, in coil, cr,=>600mm w, l",
721X00.720931	"Flat rlld prod, i/nas, not in coil, cr=>600mm w",
721X00.720932	"Flat rolled prod, i/nas, not in coil,cr=>600mm",
721X00.720933	"Flat rlld prod,i/nas,not in coil,cr=>600mm w,0.",
721X00.720934	"Flat rlld prod, i/nas, not in coil, cr=>600mm w",
721X00.720941	"Flat rlld prod, i/nas, not in coil, cr=>600mm w",
721X00.720942	"Flat rolled prod, i/nas, not in coil, cr =>600m",
721X00.720943	"Flat rolled prod, i/nas, not in coil, cr =>600m",
721X00.720944	"Flat rlld prod, i/nas, not in coil, cr=>600mm w",
721X00.720990	"Flat rolled prod, i/nas, not in coil, cr =>600m",
721X00.721011	"Flat rolled prod,i/nas, plated or coated with t",
721X00.721012	"Flat rlld prod, i/nas, plated or coated with ti",
721X00.721020	"Flat rlld prod,plated or coated with lead,=>600",
721X00.721031	"Flat rolled prod,steel,electro pltd/w/ zinc,<3m",
721X00.721039	"Flat rolled prod, i/nas, electro pltd or ctd w",
721X00.721041	"Flat rolled prod, i/nas, pltd or ctd w zinc, co",
721X00.721049	"Flat rolled prod, i/nas, plated or coated with",
721X00.721050	"Flat rlld prod,i/nas,pltd or ctd w chrom oxides",
721X00.721060	"Flat rolled prod, i/nas, plated or coated with",
721X00.721070	"Flat rolled prod,i/nas,painted,varnish./coated",
721X00.721090	"Flat rolled prod, i/nas, clad, plated or coated",
721X00.721111	"Flat rlld prod,i/nas,hr,rlld on 4 face,150mm <w",
721X00.721112	"Flat rolled prod, i/nas, hr, <600mm wide =>4.75",
721X00.721119	"Flat rlld prod,i/nas,hr,<600mm wide <3mm thk my",
721X00.721121	"Flat rlld prod,i/nas,hr,rlld on 4 faces,150mm <",
721X00.721122	"Flat rolled prod, i/nas, hr, <600mm wide, =>4.7",
721X00.721129	"Flat rolled prod, i/nas, hr, <600mm wide nes",
721X00.721130	"Flat rlld prod,i/nas,cr,<600mm wide<3mm thk myp",
721X00.721141	"Flat rlld prod,i/nas,cr,<600mm wide cntg by wt",
721X00.721149	"Flat rolled prod, i/nas, cold rolled or cold re",
721X00.721190	"Flat rolled prod, i/nas, <600mm wide, not clad,",
721X00.721210	"Flat rolled prod, i/nas, <600mm wide, plated or",
721X00.721221	"Flat rlld prod, steel, <600mm w, <3mm thk myp 2",
721X00.721229	"Flat rolled prod, i/nas, <600mm wide, clad, pla",
721X00.721230	"Flat rolled prod, i/nas, <600mm wide, o/w plate",
721X00.721240	"Flat rolled prod,i/nas,<600mm wide,painted,varn",
721X00.721250	"Flat rolled prod, i/nas, <600mm wide, plated or",
721X00.721260	"Flat rolled prod, i/nas, <600mm wide, clad",
721X00.721310	"Bars & rods, i/nas, hr,in irreg wound coils,cnt",
721X00.721320	"Bars & rods, i/nas, hr, in irreg wound coils, o",
721X00.721331	"Bars/rods,i/nas,hr,in irreg wnd coils of circ c",
721X00.721339	"Bars & rods, i/nas, hr, containing by weight le",
721X00.721341	"Bars&rods,i/nas,hr,of circ cross sect<14mm dia,",
721X00.721349	"Bars & rods, i/nas, hr, containing by wght 0.25",
721X00.721350	"Bars&rods,iron or non-alloy steel,hr containing",
721X00.721410	"Bars & rods, iron or non-alloy steel forged",
721X00.721420	"Bars&rods,i/nas,hr,hd or he,cntg indent,ribs,et",
721X00.721430	"Bars&rods, i/nas, hot rlld drawn or extruded of",
721X00.721440	"Bars&rods,i/nas,hot rlld,drawn/extruded,cntg by",
721X00.721450	"Bars & rods, i/nas, hr, hd or he, cntg by wght",
721X00.721460	"Bars & rods, i/nas, hr, hd or he, cntg by wght",
721X00.721510	"Bars&rods,i/nas,nfw than cold formed or finishe",
721X00.721520	"Bars & rods, i/nas, nfw than cold formed or fin",
721X00.721530	"Bars&rods,i/nas,nfw than cold formed or finishe",
721X00.721540	"Bars & rods, i/nas, nfw than cold formed or fin",
721X00.721590	"Bars & rods, i/nas, nes",
721X00.721610	"Sections, U,I or H,i/nas,nfw than hot rolled/dr",
721X00.721621	"Sections,L,i/nas,nfw than hot rlld,drawn/extrud",
721X00.721622	"Sections,T,i/nas,nfw than hot rlld,drawn/extrud",
721X00.721631	"Sections,U,i/nas,nfw than hot rlld,drawn/extrud",
721X00.721632	"Sections,I,i/nas,nfw than hot rlld,drawn/extrud",
721X00.721633	"Sections,H,i/nas,nfw than hot rlld,drawn/extrud",
721X00.721640	"Sections, L or T, i/nas, nfw than hot rlld, dra",
721X00.721650	"Angles,shapes and sect,i/nas,nfw than hot rlld/",
721X00.721660	"Angles, shapes and sections, i/nas, nfw than co",
721X00.721690	"Angles, shapes and sections, iron or non-alloy",
721X00.721711	"Wire,i/nas,polished or not,but not plated or co",
721X00.721712	"Wire,i/nas,plated or coated with zinc,containin",
721X00.721713	"Wire,i/nas,plated or coated with oth base mtls",
721X00.721719	"Wire, i/nas, containing by weight less than 0.2",
721X00.721721	"Wire, i/nas,polished or not,but not pltd or ctd",
721X00.721722	"Wire, i/nas, plated or coated with zinc contnng",
721X00.721723	"Wire,i/nas,pltd or ctd with oth base mtls nes,c",
721X00.721729	"Wire, iron or non-alloy steel, nes containing b",
721X00.721731	"Wire,i/nas,polished or not,but not pltd or ctd,",
721X00.721732	"Wire,i/nas,plated or coated with zinc containin",
721X00.721733	"Wire,i/nas,pltd or ctd with oth base mtls nes,c",
721X00.721739	"Wire, iron or non-alloy steel, nes containing b",
721X00.721810	"Ingots and other primary forms, stainless steel",
721X00.721890	"Semi-finished products, stainless steel",
721X00.721911	"Flat rlld prod,stainless steel,hr,in coil,=>600",
721X00.721912	"Flat rlld prod, stainless steel, hr, in coil,=>",
721X00.721913	"Flat rlld prod, stainless steel, hr in coil,=>6",
721X00.721914	"Flat rlld prod, stainless steel, hr in coil,=>6",
721X00.721921	"Flat rlld prod, stainless steel, hr, nic,=>600m",
721X00.721922	"Flat rlld prod, stainless steel, hr, nic, >600m",
721X00.721923	"Flat rlld prod, stainless steel, hr, nic, >600m",
721X00.721924	"Flat rlld prod, stainless steel, hr, nic, >600m",
721X00.721931	"Flat rolled prod, stainless steel, cr, >600mm w",
721X00.721932	"Flat rolled prod, stainless steel, cr, >600mm w",
721X00.721933	"Flat rolled prod, stainless steel, cr, 600mm wi",
721X00.721934	"Flat rolled prod, stainless steel, cr, >600mm w",
721X00.721935	"Flat rolled prod, stainless steel, cr, >600mm w",
721X00.721990	"Flat rolled prod, stainless steel, 600mm or mor",
721X00.722011	"Flat rolled prod, stainless steel, hr <600mm wi",
721X00.722012	"Flat rolled prod, stainless steel, hr <600mm wi",
721X00.722020	"Flat rolled prod, stainless steel, <600mm wide,",
721X00.722090	"Flat rolled prod, stainless steel, cr <600mm wi",
721X00.722100	"Bars & rods, stainless steel, hot rolled in irr",
721X00.722210	"Bars & rods, stainless steel, nfw than hot roll",
721X00.722220	"Bars & rods, stainless steel, nfw than cold for",
721X00.722230	"Bars & rods, stainless steel, nes",
721X00.722240	"Angles, shapes and sections, stainless steel",
721X00.722300	Wire of stainless steel
721X00.722410	"Ingots & other primary forms of alloy steel, o/",
721X00.722490	"Semi-finished products of alloy steel o/t stain"
721X00.722510	Flat rolled products of silicon-electrical stee
721X00.722520	Flat rolled products of high speed steel =>600m
721X00.722530	"Flat rlld prod, as, o/t stainless, in coils, nf",
721X00.722540	"Flat rolled prod, as, o/t stainless, nic nfw th",
721X00.722550	"Flat rlld prod, as, o/t stainless, nfw than col",
721X00.722590	"Flat rolled prod, as, o/t stainless, =>600mm wi",
721X00.722610	"Flat rolled prod, of silicon electrical steel,",
721X00.722620	"Flat rolled prod, of high speed steel, <600mm w",
721X00.722691	"Flat rlld prod, as, o/t stainless, nfw than hot",
721X00.722692	"Flat rolled prod, as, o/t stainless, nfw than c",
721X00.722699	"Flat rolled prod, as, o/t stainless, <600mm wid",
721X00.722710	"Bars & rods, of high speed steel, hr, in irregu",
721X00.722720	"Bars & rods, of silico-manganese steel, hr, in",
721X00.722790	"Bars&rods,alloy steel,o/t stainless hr,in irreg",
721X00.722810	"Bars and rods of high speed steel, nes",
721X00.722820	Bars and rods of silico-manganese steel nes
721X00.722830	"Bars&rods,alloy steel,o/t stainless nfw than ho",
721X00.722840	"Bars & rods, as, o/t stainless, not further wor",
721X00.722850	"Bars&rods, as, o/t stainless, not further wkd t",
721X00.722860	"Bars & rods, as, o/t stainless, nes",
721X00.722870	"Angles, shapes and sections, as, o/t stainless,",
721X00.722880	"Bars & rods, hollow drill, alloy or non-alloy s",
721X00.722910	Wire of high speed steel
721X00.722920	Wire of silico-manganese steel
721X00.722990	"Wire of alloy steel, o/t stainless",
721X00.730110	"Sheet piling,i or s whether or not drilled/punc",
721X00.730120	"Angles, shapes and sections, welded, iron or st",
721X00.730210	"Rails, iron or steel",
721X00.730220	"Sleepers (cross-ties), iron or steel",
721X00.730240	"Fish plates and sole plates, iron or steel",
721X00.730290	Rail or tramway construction material of iron o
721X00.730300	"Tubes, pipes and hollow profiles of cast iron",
721X00.730410	"Pipes, line, iron or steel, smls, of a kind use",
721X00.730420	"Casings,tubing&drill pipe,i/st,smls,for use in",
721X00.730431	"Tubes,pipe&hollow profiles,i or nas,smls,cd/cr,",
721X00.730439	"Tubes, pipe & hollow profiles, i or nas, smls,",
721X00.730441	"Tubes,pipe&hollow profiles,stain steel,smls,cd/",
721X00.730449	"Tubes, pipe & hollow profiles, stainless steel,",
721X00.730451	"Tubes,pipe&hollow profiles,as,(o/t stain) smls,",
721X00.730459	"Tubes,pipe&hollow profiles,as,(o/t stainless) s",
721X00.730490	"Tubes, pipe & hollow profiles, iron or steel, s",
721X00.730511	"Pipe,line,i or s,longitudinally subm arc wld,in",
721X00.730512	"Pipe,line,i or s,longitudinally wld w int/ext c",
721X00.730519	"Pipe, line, i or s, int/ext circ cross sect, wl",
721X00.730520	"Casings,i/s,int/ext circ c sect,wld ext dia >40",
721X00.730531	"Tubes & pipe, i or s, longitudinally welded, ex",
721X00.730539	"Tubes&pipe,i or s,welded,riveted or sim closed,",
721X00.730590	"Tubes & pipe, i or s, riveted or sim closed, ex",
721X00.730610	"Pipe,line,i or s,welded,riveted or sim closed,n",
721X00.730620	"Casing/tubing,i or s,welded,riveted or sim clsd",
721X00.730630	"Tubes,pipe&hollow profiles,iron or nas,welded,o",
721X00.730640	"Tubes,pipe&hollow profiles,stainless steel,weld",
721X00.730650	"Tubes, pipe & hollow profiles,al/s,(o/t stain)",
721X00.730660	"Tubes, pipe & hollow profiles, i/s, welded, of",
721X00.730690	"Tubes, pipe & hollow profiles, iron or steel, w",
721X00.730711	"Fittings, pipe or tube, of non-malleable cast i",
721X00.730719	"Fittings, pipe or tube, cast, of iron or steel,",
721X00.730721	"Flanges, stainless steel",
721X00.730722	"Threaded elbows, bends and sleeves of stainless",
721X00.730723	"Fittings, butt welding, stainless steel",
721X00.730729	"Fittings pipe or tube of stainless steel, nes",
721X00.730791	"Flanges, iron or steel, nes",
721X00.730792	"Threaded elbows, bend and sleeves, iron or stee",
721X00.730793	"Fittings, but welding, iron or steel, nes",
721X00.730799	"Fittings, pipe or tube, iron or steel, nes",
740XXX.740110	Copper mattes
740XXX.740120	Cement copper (precipitated copper)
740XXX.740200	"Copper unrefined, copper anodes for electrolyti",
740XXX.740311	Copper cathodes and sections of cathodes unwrou
740XXX.740312	"Wire bars, copper, unwrought",
740XXX.740313	"Billets, copper, unwrought",
740XXX.740319	"Refined copper products, unwrought, nes",
740XXX.740321	"Copper-zinc base alloys, unwrought",
740XXX.740322	"Copper-tin base alloys, unwrought",
740XXX.740323	Copper-nickel base alloys or copper-nickel-zinc
740XXX.740329	"Copper alloys, unwrought (other than master all",
740XXX.740500	Master alloys of copper
740XXX.740610	"Powders, copper, of non-lamellar structure",
740XXX.740620	"Powders, copper, of lamellar structure and flak",
740XXX.740710	"Bars, rods and profiles of refined copper",
740XXX.740721	"Bars, rods and profiles of copper-zinc base all",
740XXX.740722	"Bars,rods and profiles of copper-nickel or copp",
740XXX.740729	"Bars, rods and profiles, copper alloy nes",
740XXX.740811	Wire of refined copper of which the max cross s
740XXX.740819	Wire of refined copper of which the max cross s
740XXX.740821	"Wire, copper-zinc base alloy",
740XXX.740822	"Wire, copper-nickel base alloy or copper-nickel",
740XXX.740829	"Wire, copper alloy, nes",
740XXX.740911	"Plate, sheet & strip of refined copper, in coil",
740XXX.740919	"Plate,sheet&strip of refined copper,not in coil",
740XXX.740921	"Plate,sheet&strip of copper-zinc base alloys,in",
740XXX.740929	"Plate,sheet&strip of copper-zinc base alloys,no",
740XXX.740931	"Plate, sheet & strip of copper-tin base alloys,",
740XXX.740939	"Plate,sheet&strip of copper-tin base alloys,not",
740XXX.740940	"Plate,sheet&strip of copper-nickel or cop-nick-",
740XXX.740990	"Plate, sheet & strip of copper alloy, nes",
740XXX.741011	"Foil of refined copper, not backed",
740XXX.741012	"Foil, copper alloy, not backed",
740XXX.741021	"Foil of refined copper, backed",
740XXX.741022	"Foil, copper alloy, backed",
740XXX.741110	"Pipes and tubes, refined copper",
740XXX.741121	"Pipes and tubes, copper-zinc base alloy",
740XXX.741122	"Pipes and tubes,copper-nickel base alloy or cop",
740XXX.741129	"Pipes and tubes, copper alloy, nes",
740XXX.741210	"Fittings, pipe or tube, of refined copper",
740XXX.741220	"Fittings, pipe or tube, copper alloy",
741XXX.741300	"Stranded wire,cable,plaited bands and like of c",
741XXX.741410	Endless bands of copper wire for machinery
741XXX.741490	"Cloth, grill and netting of copper wire and exp",
741XXX.741510	"Nails, tacks, drawing pins,staples & sim art of",
741XXX.741521	"Washers, copper, including spring washers",
741XXX.741529	"Art. of copper,not threaded,nes,similar to thos",
741XXX.741531	"Screws, copper, for wood",
741XXX.741532	"Screws, bolts and nuts of copper excluding wood",
741XXX.741539	"Articles of copper threaded, nes similar to bol",
741XXX.741600	"Springs, copper",
741XXX.741810	"Table, kitchen or other household articles and",
741XXX.741820	Sanitary ware and parts thereof of copper
741XXX.741910	Chain and parts thereof of copper
741XXX.741991	"Articles of copper, not further wkd than cast,",
741XXX.741999	"Articles of copper, nes",
750X00.750110	Nickel mattes
750X00.750120	Nickel oxide sinters and other intermediate pro
750X00.750210	"Nickel unwrought, not alloyed",
750X00.750220	"Nickel unwrought, alloyed",
750X00.750300	"Waste and scrap, nickel",
750X00.750400	"Powders and flakes, nickel",
750X00.750511	"Bars, rods and profiles, nickel, not alloyed",
750X00.750512	"Bars, rods and profiles, nickel alloy",
750X00.750521	"Wire, nickel, not alloyed",
750X00.750522	"Wire, nickel alloy",
750X00.750610	"Plates, sheet, strip and foil, nickel, not allo",
750X00.750620	"Plates, sheet, strip and foil, nickel alloy",
750X00.750711	"Tubes and pipe, nickel, not alloyed",
750X00.750712	"Tubes and pipe, nickel alloy",
750X00.750720	"Fittings, pipe and tube, nickel",
76X000.760110	"Aluminium unwrought, not alloyed",
76X000.760120	"Aluminium unwrought, alloyed",
76X000.760200	"Waste and scrap, aluminium",
76X000.760310	"Powders, aluminium, of non-lamellar structure",
76X000.760320	"Powders, aluminium, of lamellar structure, incl",
76X000.760410	"Bars, rods and profiles, aluminium, not alloyed",
76X000.760421	"Profiles, hollow, aluminium, alloyed",
76X000.760429	"Bars, rods and other profiles, aluminium alloye",
76X000.760511	"Wire,aluminium,not alloyed,with a max cross sec",
76X000.760519	"Wire,aluminium,not alloyed,with a max cross sec",
76X000.760521	"Wire, aluminium alloy, with a maximum cross sec",
76X000.760529	"Wire, aluminium alloy, with a maximum cross sec",
76X000.760611	"Plate,sheet or strip,aluminium,not alloyed,rect",
76X000.760612	"Plate, sheet or strip, aluminium alloy, rect or",
76X000.760691	"Plate, sheet or strip, aluminium, not alloyed,",
76X000.760692	"Plate, sheet or strip, aluminium alloy, exceedi",
76X000.760711	"Foil, aluminium, not backed, rolled but not fur",
76X000.760719	"Foil, aluminium, not backed and not exceeding 0",
76X000.760720	"Foil, aluminium, backed, not exceeding 0.2mm th",
76X000.760810	"Tubes and pipe, aluminium, not alloyed",
76X000.760820	"Tubes and pipe, aluminium alloy",
76X000.760900	"Fittings,pipe or tube,aluminium,for example cou",
780X00.780110	Lead refined unwrought
780X00.780191	Lead unwrought containing by wt. antimony as th
780X00.780199	Lead unwrought nes
780X00.780200	Lead waste and scrap
780X00.780300	"Lead bars, rods, profiles and wire",
780X00.780411	"Lead sheets, strip and foil of a thickness (exc",
780X00.780419	"Lead plates, sheet, strip and foil nes",
780X00.780420	Lead powders and flakes
780X00.780500	"Lead pipes or tubes and fittings (for example,c",
790X00.790111	Zinc not alloyed unwrought containing by weight
790X00.790112	Zinc not alloyed unwrought containing by weight
790X00.790120	Zinc alloys unwrought
790X00.790390	Zinc powders and flakes
790X00.790400	"Zinc bars, rods, profiles and wire",
790X00.790500	"Zinc plates, sheets, strip and foil",
790X00.790600	Zinc pipes or tubes and fittings (e.g. coupling
800X00.800110	Tin not alloyed unwrought
800X00.800120	Tin alloys unwrought
800X00.800300	"Tin bars, rods, profiles and wire",
800X00.800400	"Tin plates, sheets and strip, of a thickness ex",
800X00.800510	"Tin foil (w/n printed or backed of a thickness"
800X00.800520	Tin powders and flakes
800X00.800600	"Tin pipes or tubes and fittings (for example,co",
81019A.810191	"Tungsten (wolfram) unwrought,including bars&rod",
81019A.810192	"Tungsten profiles,plate,sheet,strip and foil,in",
81019A.810193	"Wire, tungsten (wolfram)",
81019A.810199	Tungsten (wolfram) and articles thereof nes
8102A0.810210	"Powders, molybdenum",
8102A0.810291	"Molybdenum,unwrought,including bars or rods sim",
8102A0.810292	"Molybdenum profiles,plate,sheet,strip or foil,i",
8102A0.810293	"Wire, molybdenum",
8102A0.810299	Molybdenum and articles thereof nes
26159X.810310	Tantalum unwrought including bars&rods simply s
26159X.810390	Tantalum and articles thereof nes
8104A0.810411	Magnesium unwrought containing by weight at lea
8104A0.810419	Magnesium unwrought nes
8104A0.810420	Magnesium waste and scrap
8104A0.810430	"Magnesium raspings,turnings or granules graded",
8104A0.810490	Magnesium and articles thereof nes
8105A0.810510	"Cobalt,unwrought,matte and oth intermediate pro",
8105A0.810590	"Cobalt and articles thereof, nes",
810600.810600	"Bismuth and articles thereof, including waste a",
8107A0.810710	"Cadmium, unwrought; waste and scrap; powders",
8107A0.810790	"Cadmium and articles thereof, nes",
26140X.810810	"Titanium unwrought; waste and scrap; powders",
26140X.810890	"Titanium and articles thereof, nes",
26151X.810910	"Zirconium unwrought; waste and scrap; powders",
26151X.810990	"Zirconium and articles thereof, nes",
81100X.811000	"Antimony and articles thereof, including waste",
26020X.811100	"Manganese and articles thereof, including waste",
81121A.811211	"Beryllium unwrought; waste and scrap; powders",
81121A.811219	"Beryllium and articles thereof, nes",
261000.811220	"Chromium and articles thereof, including waste,",
811230.811230	"Germanium and articles thereof, including waste",
26159X.811240	"Vanadium and articles thereof, including waste,",
81129A.811291	"Gallium,hafnium,indium,niobium,rhenium or thall",
81129A.811299	"Gallium,hafnium,indium,niobium,rhenium or thall",
850650.850650	Lithium (Found in HS96+) /;

$exit

set	gtapmap(commodities,gtap) /
	0701A0.v_f
	0701A0.V_F
	070200.V_F
	070310.V_F
	070320.V_F
	070390.V_F
	070410.V_F
	0704X0.V_F
	0704X0.V_F
	0705A0.V_F
	0705A0.V_F
	0705A0.V_F
	0705A0.V_F
	070610.V_F
	0709X0.V_F
	070700.V_F
	07131X.V_F
	0713X0.V_F
	070890.V_F
	070920.V_F
	070930.V_F
	0709X0.V_F
	07095A.V_F
	07095A.V_F
	070960.V_F
	070970.V_F
	0709X0.V_F
	0713X0.OFD
	07131X.V_F
	071320.V_F
	0713X0.V_F
	0713X0.V_F
	0713X0.V_F
	0713X0.V_F
	071340.V_F
	071350.V_F
	071390.V_F
	071410.V_F
	071420.V_F
	071490.V_F
	080110.V_F
	080120.V_F
	080130.V_F
	080211.V_F
	080221.V_F
	080231.V_F
	080240.V_F
	080250.V_F
	080290.V_F
	080300.V_F
	080410.V_F
	080420.V_F
	080430.V_F
	080440.V_F
	080X00.V_F
	080510.V_F
	080520.V_F
	080530.V_F
	080540.V_F
	080590.V_F
	080610.V_F
	080710.V_F
	080720.V_F
	080810.V_F
	080820.V_F
	080910.V_F
	080920.V_F
	080930.V_F
	080940.V_F
	081010.V_F
	0810X0.V_F
	0810X0.V_F
	080X00.V_F
	0901A0.OCR
	0901A0.OFD
	0901A0.OFD
	0901A0.OFD
	0901A0.OCR
	0902A0.OFD
	0902A0.OCR
	0902A0.OFD
	0902A0.OCR
	090300.OCR
	09041A.OCR
	09041A.OCR
	090420.OCR
	090500.OCR
	0906A0.OCR
	0906A0.OCR
	090700.OCR
	0908A0.OCR
	0908A0.OCR
	0908A0.OCR
	0909A0.OCR
	0909A0.OCR
	0909A0.OCR
	0909A0.OCR
	0909A0.OCR
	091010.OCR
	0910X0.OCR
	0910X0.OCR
	0910X0.OCR
	0910X0.OCR
	1001A0.WHT
	1001A0.WHT
	100200.GRO
	100300.GRO
	100400.GRO
	1005A0.GRO
	1005A0.GRO
	1006A0.PDR
	1006A0.PDR
	100700.GRO
	100810.GRO
	100820.GRO
	100830.GRO
	100890.GRO
	120100.OSD
	1202A0.OSD
	1202A0.OSD
	120400.OSD
	120500.OSD
	120600.OSD
	120720.OSD
	120740.OSD
	120750.OSD
	120791.OSD
	120799.OSD
	120999.OCR
	1210A0.OCR
	1210A0.OCR
	12129A.C_B
	12129A.C_B
	12129A.V_F
	180X00.OCR
	180X00.OFD
	180X00.OFD
	180X00.OFD
	180X00.OFD
	180X00.OFD
	180X00.OFD
	180X00.OFD
	180X00.OFD
	180X00.OFD
	180X00.OFD
	1202A0.OFD
	2401A0.OCR
	2401A0.OCR
	2401A0.OCR
	250100.OMN
	2504A0.OMN
	2504A0.OMN
	25059X.OMN
	250850.OMN
	2510A0.OMN
	2510A0.OMN
	2805X0.OMN
	251200.OMN
	25059X.OMN
	251910.OMN
	252010.OMN
	2523X0.NMM
	2523X0.NMM
	2523X0.NMM
	2523X0.NMM
	252400.OMN
	2525A0.OMN
	2525A0.OMN
	2525A0.OMN
	2526A0.OMN
	2526A0.OMN
	252910.OMN
	25292A.OMN
	25292A.OMN
	25301X.OMN
	253090.OMN
	26011A.OMN
	26011A.OMN
	26020X.OMN
	260300.OMN
	750X00.OMN
	260500.OMN
	260600.OMN
	260700.OMN
	790X00.OMN
	260900.OMN
	261000.OMN
	81019A.OMN
	2844X0.OMN
	8102A0.OMN
	8102A0.OMN
	26140X.OMN
	26151X.OMN
	26159X.OMN
	261610.OMN
	261690.OMN
	81100X.OMN
	26159X.NFM
	270X00.COA
	270X00.COA
	270X00.COA
	270X00.COA
	270X00.COA
	270X00.COA
	270900.OIL
	2711X1.GAS
	2711X1.GAS
	280120.CRP
	280130.CRP
	280450.CRP
	280480.CRP
	280490.CRP
	2805X0.CRP
	2805X0.CRP
	2846A0.CRP
	280540.CRP
	281820.NFM
	2840A0.CRP
	2840A0.CRP
	2840A0.CRP
	2840A0.CRP
	2846A0.CRP
	2846A0.CRP
	3104A0.OMN
	3104A0.CRP
	3104A0.CRP
	3104A0.CRP
	400110.CRP
	52X000.PFB
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	52X000.TEX
	53012A.TEX
	53012A.TEX
	53012A.TEX
	5303A0.PFB
	5303A0.TEX
	530599.TEX
	25301X.NMM
	76X000.NMM
	7102A0.OMN
	7102A0.OMN
	7102A0.OMN
	71101A.NFM
	71101A.NFM
	71102A.NFM
	71102A.NFM
	71103A.NFM
	71103A.NFM
	71104A.NFM
	71104A.NFM
	7201X0.I_S
	7201X0.I_S
	7201X0.I_S
	26159X.I_S
	26159X.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	721X00.I_S
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	740XXX.NFM
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	741XXX.FMP
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	750X00.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	76X000.NFM
	780X00.NFM
	780X00.NFM
	780X00.NFM
	780X00.NFM
	780X00.NFM
	780X00.NFM
	780X00.NFM
	780X00.NFM
	780X00.NFM
	790X00.NFM
	790X00.NFM
	790X00.NFM
	790X00.NFM
	790X00.NFM
	790X00.NFM
	790X00.NFM
	800X00.NFM
	800X00.NFM
	800X00.NFM
	800X00.NFM
	800X00.NFM
	800X00.NFM
	800X00.NFM
	81019A.NFM
	81019A.NFM
	81019A.NFM
	81019A.NFM
	8102A0.NFM
	8102A0.NFM
	8102A0.NFM
	8102A0.NFM
	8102A0.NFM
	26159X.NFM
	26159X.NFM
	8104A0.NFM
	8104A0.NFM
	8104A0.NFM
	8104A0.NFM
	8104A0.NFM
	8105A0.NFM
	8105A0.NFM
	810600.NFM
	8107A0.NFM
	8107A0.NFM
	26140X.NFM
	26140X.NFM
	26151X.NFM
	26151X.NFM
	81100X.NFM
	26020X.NFM
	81121A.NFM
	81121A.NFM
	261000.NFM
	811230.NFM
	26159X.NFM
	81129A.NFM
	81129A.NFM
	850650.NFM /;
