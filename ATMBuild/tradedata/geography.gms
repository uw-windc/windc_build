$title	Sort out geography -- distances between states and ports

set	st(*)	State FIPS  (lower 48)/
       01        ALABAMA
*.       02        ALASKA
       04        ARIZONA
       05        ARKANSAS
       06        CALIFORNIA
       08        COLORADO
       09        CONNECTICUT
       10        DELAWARE
       11        DISTRICT OF COLUMBIA
       12        FLORIDA
       13        GEORGIA
*.       15        HAWAII
       16        IDAHO
       17        ILLINOIS
       18        INDIANA
       19        IOWA
       20        KANSAS
       21        KENTUCKY
       22        LOUISIANA
       23        MAINE
       24        MARYLAND
       25        MASSACHUSETTS
       26        MICHIGAN
       27        MINNESOTA
       28        MISSISSIPPI
       29        MISSOURI
       30        MONTANA
       31        NEBRASKA
       32        NEVADA
       33        NEW HAMPSHIRE
       34        NEW JERSEY
       35        NEW MEXICO
       36        NEW YORK
       37        NORTH CAROLINA
       38        NORTH DAKOTA
       39        OHIO
       40        OKLAHOMA
       41        OREGON
       42        PENNSYLVANIA
       44        RHODE ISLAND
       45        SOUTH CAROLINA
       46        SOUTH DAKOTA
       47        TENNESSEE
       48        TEXAS
       49        UTAH
       50        VERMONT
       51        VIRGINIA
       53        WASHINGTON
       54        WEST VIRGINIA
       55        WISCONSIN
       56        WYOMING /;

set	usps	State postal IDs/
*.	AK	Alaska
	AL	Alabama
	AR	Arkansas
	AZ	Arizona
	CA	California
	CO	Colorado
	CT	Connecticut
	DC	District of Columbia
	DE	Delaware
	FL	Florida
	GA	Georgia
*.	HI	Hawaii
	IA	Iowa
	ID	Idaho
	IL	Illinois
	IN	Indiana
	KS	Kansas
	KY	Kentucky
	LA	Louisiana
	MA	Massachusetts
	MD	Maryland
	ME	Maine
	MI	Michigan
	MN	Minnesota
	MO	Missouri
	MS	Mississippi
	MT	Montana
	NC	North Carolina
	ND	North Dakota
	NE	Nebraska
	NH	New Hampshire
	NJ	New Jersey
	NM	New Mexico
	NV	Nevada
	NY	New York
	OH	Ohio
	OK	Oklahoma
	OR	Oregon
	PA	Pennsylvania
	RI	Rhode Island
	SC	South Carolina
	SD	South Dakota
	TN	Tennessee
	TX	Texas
	UT	Utah
	VA	Virginia
	VT	Vermont
	WA	Washington
	WI	Wisconsin
	WV	West Virginia
	WY	Wyoming /;

*.	PR	Puerto Rico
*.	VI	Virgin Islands

set	stmap(usps,st)	Mapping from state id to fips/
	AL.01, NE.31, NV.32, AZ.04, NH.33, AR.05, NJ.34, CA.06, NM.35,
	CO.08, NY.36, CT.09, NC.37, DE.10, ND.38, DC.11, OH.39, FL.12, OK.40,
	GA.13, OR.41, PA.42, ID.16, IL.17, RI.44, IN.18, SC.45,
	IA.19, SD.46, KS.20, TN.47, KY.21, TX.48, LA.22, UT.49, ME.23, VT.50,
	MD.24, VA.51, MA.25, MI.26, WA.53, MN.27, WV.54, MS.28, WI.55,
	MO.29, WY.56, MT.30/;

*	PR.72, VI.78, 

set	fips(*)		County (and state) FIPS codes /
    01000        Alabama
    01001        Autauga County
    01003        Baldwin County
    01005        Barbour County
    01007        Bibb County
    01009        Blount County
    01011        Bullock County
    01013        Butler County
    01015        Calhoun County
    01017        Chambers County
    01019        Cherokee County
    01021        Chilton County
    01023        Choctaw County
    01025        Clarke County
    01027        Clay County
    01029        Cleburne County
    01031        Coffee County
    01033        Colbert County
    01035        Conecuh County
    01037        Coosa County
    01039        Covington County
    01041        Crenshaw County
    01043        Cullman County
    01045        Dale County
    01047        Dallas County
    01049        DeKalb County
    01051        Elmore County
    01053        Escambia County
    01055        Etowah County
    01057        Fayette County
    01059        Franklin County
    01061        Geneva County
    01063        Greene County
    01065        Hale County
    01067        Henry County
    01069        Houston County
    01071        Jackson County
    01073        Jefferson County
    01075        Lamar County
    01077        Lauderdale County
    01079        Lawrence County
    01081        Lee County
    01083        Limestone County
    01085        Lowndes County
    01087        Macon County
    01089        Madison County
    01091        Marengo County
    01093        Marion County
    01095        Marshall County
    01097        Mobile County
    01099        Monroe County
    01101        Montgomery County
    01103        Morgan County
    01105        Perry County
    01107        Pickens County
    01109        Pike County
    01111        Randolph County
    01113        Russell County
    01115        St. Clair County
    01117        Shelby County
    01119        Sumter County
    01121        Talladega County
    01123        Tallapoosa County
    01125        Tuscaloosa County
    01127        Walker County
    01129        Washington County
    01131        Wilcox County
    01133        Winston County
*.    02000        Alaska
*.    02013        Aleutians East Borough
*.    02016        Aleutians West Census Area
*.    02020        Anchorage Borough
*.    02050        Bethel Census Area
*.    02060        Bristol Bay Borough
*.    02068        Denali Borough
*.    02070        Dillingham Census Area
*.    02090        Fairbanks North Star Borough
*.    02100        Haines Borough
*.    02110        Juneau Borough
*.    02122        Kenai Peninsula Borough
*.    02130        Ketchikan Gateway Borough
*.    02150        Kodiak Island Borough
*.    02164        Lake and Peninsula Borough
*.    02170        Matanuska-Susitna Borough
*.    02180        Nome Census Area
*.    02185        North Slope Borough
*.    02188        Northwest Arctic Borough
*.    02201        Prince of Wales-Outer Ketchikan Census Area
*.    02220        Sitka Borough
*.    02231        Skagway-Yakutat-Angoon Census Area         
*.    02232        Skagway-Hoonah-Angoon Census Area          
*.    02240        Southeast Fairbanks Census Area
*.    02261        Valdez-Cordova Census Area
*.    02270        Wade Hampton Census Area
*.    02280        Wrangell-Petersburg Census Area
*.    02282        Yakutat Borough                       
*.    02290        Yukon-Koyukuk Census Area
    04000        Arizona
    04001        Apache County
    04003        Cochise County
    04005        Coconino County
    04007        Gila County
    04009        Graham County
    04011        Greenlee County
    04012        La Paz County
    04013        Maricopa County
    04015        Mohave County
    04017        Navajo County
    04019        Pima County
    04021        Pinal County
    04023        Santa Cruz County
    04025        Yavapai County
    04027        Yuma County
    05000        Arkansas
    05001        Arkansas County
    05003        Ashley County
    05005        Baxter County
    05007        Benton County
    05009        Boone County
    05011        Bradley County
    05013        Calhoun County
    05015        Carroll County
    05017        Chicot County
    05019        Clark County
    05021        Clay County
    05023        Cleburne County
    05025        Cleveland County
    05027        Columbia County
    05029        Conway County
    05031        Craighead County
    05033        Crawford County
    05035        Crittenden County
    05037        Cross County
    05039        Dallas County
    05041        Desha County
    05043        Drew County
    05045        Faulkner County
    05047        Franklin County
    05049        Fulton County
    05051        Garland County
    05053        Grant County
    05055        Greene County
    05057        Hempstead County
    05059        Hot Spring County
    05061        Howard County
    05063        Independence County
    05065        Izard County
    05067        Jackson County
    05069        Jefferson County
    05071        Johnson County
    05073        Lafayette County
    05075        Lawrence County
    05077        Lee County
    05079        Lincoln County
    05081        Little River County
    05083        Logan County
    05085        Lonoke County
    05087        Madison County
    05089        Marion County
    05091        Miller County
    05093        Mississippi County
    05095        Monroe County
    05097        Montgomery County
    05099        Nevada County
    05101        Newton County
    05103        Ouachita County
    05105        Perry County
    05107        Phillips County
    05109        Pike County
    05111        Poinsett County
    05113        Polk County
    05115        Pope County
    05117        Prairie County
    05119        Pulaski County
    05121        Randolph County
    05123        St. Francis County
    05125        Saline County
    05127        Scott County
    05129        Searcy County
    05131        Sebastian County
    05133        Sevier County
    05135        Sharp County
    05137        Stone County
    05139        Union County
    05141        Van Buren County
    05143        Washington County
    05145        White County
    05147        Woodruff County
    05149        Yell County
    06000        California
    06001        Alameda County
    06003        Alpine County
    06005        Amador County
    06007        Butte County
    06009        Calaveras County
    06011        Colusa County
    06013        Contra Costa County
    06015        Del Norte County
    06017        El Dorado County
    06019        Fresno County
    06021        Glenn County
    06023        Humboldt County
    06025        Imperial County
    06027        Inyo County
    06029        Kern County
    06031        Kings County
    06033        Lake County
    06035        Lassen County
    06037        Los Angeles County
    06039        Madera County
    06041        Marin County
    06043        Mariposa County
    06045        Mendocino County
    06047        Merced County
    06049        Modoc County
    06051        Mono County
    06053        Monterey County
    06055        Napa County
    06057        Nevada County
    06059        Orange County
    06061        Placer County
    06063        Plumas County
    06065        Riverside County
    06067        Sacramento County
    06069        San Benito County
    06071        San Bernardino County
    06073        San Diego County
    06075        San Francisco County
    06077        San Joaquin County
    06079        San Luis Obispo County
    06081        San Mateo County
    06083        Santa Barbara County
    06085        Santa Clara County
    06087        Santa Cruz County
    06089        Shasta County
    06091        Sierra County
    06093        Siskiyou County
    06095        Solano County
    06097        Sonoma County
    06099        Stanislaus County
    06101        Sutter County
    06103        Tehama County
    06105        Trinity County
    06107        Tulare County
    06109        Tuolumne County
    06111        Ventura County
    06113        Yolo County
    06115        Yuba County
    08000        Colorado
    08001        Adams County
    08003        Alamosa County
    08005        Arapahoe County
    08007        Archuleta County
    08009        Baca County
    08011        Bent County
    08013        Boulder County
    08015        Chaffee County
    08017        Cheyenne County
    08019        Clear Creek County
    08021        Conejos County
    08023        Costilla County
    08025        Crowley County
    08027        Custer County
    08029        Delta County
    08031        Denver County
    08033        Dolores County
    08035        Douglas County
    08037        Eagle County
    08039        Elbert County
    08041        El Paso County
    08043        Fremont County
    08045        Garfield County
    08047        Gilpin County
    08049        Grand County
    08051        Gunnison County
    08053        Hinsdale County
    08055        Huerfano County
    08057        Jackson County
    08059        Jefferson County
    08061        Kiowa County
    08063        Kit Carson County
    08065        Lake County
    08067        La Plata County
    08069        Larimer County
    08071        Las Animas County
    08073        Lincoln County
    08075        Logan County
    08077        Mesa County
    08079        Mineral County
    08081        Moffat County
    08083        Montezuma County
    08085        Montrose County
    08087        Morgan County
    08089        Otero County
    08091        Ouray County
    08093        Park County
    08095        Phillips County
    08097        Pitkin County
    08099        Prowers County
    08101        Pueblo County
    08103        Rio Blanco County
    08105        Rio Grande County
    08107        Routt County
    08109        Saguache County
    08111        San Juan County
    08113        San Miguel County
    08115        Sedgwick County
    08117        Summit County
    08119        Teller County
    08121        Washington County
    08123        Weld County
    08125        Yuma County
    09000        Connecticut
    09001        Fairfield County
    09003        Hartford County
    09005        Litchfield County
    09007        Middlesex County
    09009        New Haven County
    09011        New London County
    09013        Tolland County
    09015        Windham County
    10000        Delaware
    10001        Kent County
    10003        New Castle County
    10005        Sussex County
    11000        District of Columbia
    11001        District of Columbia
    12000        Florida
    12001        Alachua County
    12003        Baker County
    12005        Bay County
    12007        Bradford County
    12009        Brevard County
    12011        Broward County
    12013        Calhoun County
    12015        Charlotte County
    12017        Citrus County
    12019        Clay County
    12021        Collier County
    12023        Columbia County
    12025        Dade County
    12027        DeSoto County
    12029        Dixie County
    12031        Duval County
    12033        Escambia County
    12035        Flagler County
    12037        Franklin County
    12039        Gadsden County
    12041        Gilchrist County
    12043        Glades County
    12045        Gulf County
    12047        Hamilton County
    12049        Hardee County
    12051        Hendry County
    12053        Hernando County
    12055        Highlands County
    12057        Hillsborough County
    12059        Holmes County
    12061        Indian River County
    12063        Jackson County
    12065        Jefferson County
    12067        Lafayette County
    12069        Lake County
    12071        Lee County
    12073        Leon County
    12075        Levy County
    12077        Liberty County
    12079        Madison County
    12081        Manatee County
    12083        Marion County
    12085        Martin County
    12087        Monroe County
    12089        Nassau County
    12091        Okaloosa County
    12093        Okeechobee County
    12095        Orange County
    12097        Osceola County
    12099        Palm Beach County
    12101        Pasco County
    12103        Pinellas County
    12105        Polk County
    12107        Putnam County
    12109        St. Johns County
    12111        St. Lucie County
    12113        Santa Rosa County
    12115        Sarasota County
    12117        Seminole County
    12119        Sumter County
    12121        Suwannee County
    12123        Taylor County
    12125        Union County
    12127        Volusia County
    12129        Wakulla County
    12131        Walton County
    12133        Washington County
    13000        Georgia
    13001        Appling County
    13003        Atkinson County
    13005        Bacon County
    13007        Baker County
    13009        Baldwin County
    13011        Banks County
    13013        Barrow County
    13015        Bartow County
    13017        Ben Hill County
    13019        Berrien County
    13021        Bibb County
    13023        Bleckley County
    13025        Brantley County
    13027        Brooks County
    13029        Bryan County
    13031        Bulloch County
    13033        Burke County
    13035        Butts County
    13037        Calhoun County
    13039        Camden County
    13043        Candler County
    13045        Carroll County
    13047        Catoosa County
    13049        Charlton County
    13051        Chatham County
    13053        Chattahoochee County
    13055        Chattooga County
    13057        Cherokee County
    13059        Clarke County
    13061        Clay County
    13063        Clayton County
    13065        Clinch County
    13067        Cobb County
    13069        Coffee County
    13071        Colquitt County
    13073        Columbia County
    13075        Cook County
    13077        Coweta County
    13079        Crawford County
    13081        Crisp County
    13083        Dade County
    13085        Dawson County
    13087        Decatur County
    13089        DeKalb County
    13091        Dodge County
    13093        Dooly County
    13095        Dougherty County
    13097        Douglas County
    13099        Early County
    13101        Echols County
    13103        Effingham County
    13105        Elbert County
    13107        Emanuel County
    13109        Evans County
    13111        Fannin County
    13113        Fayette County
    13115        Floyd County
    13117        Forsyth County
    13119        Franklin County
    13121        Fulton County
    13123        Gilmer County
    13125        Glascock County
    13127        Glynn County
    13129        Gordon County
    13131        Grady County
    13133        Greene County
    13135        Gwinnett County
    13137        Habersham County
    13139        Hall County
    13141        Hancock County
    13143        Haralson County
    13145        Harris County
    13147        Hart County
    13149        Heard County
    13151        Henry County
    13153        Houston County
    13155        Irwin County
    13157        Jackson County
    13159        Jasper County
    13161        Jeff Davis County
    13163        Jefferson County
    13165        Jenkins County
    13167        Johnson County
    13169        Jones County
    13171        Lamar County
    13173        Lanier County
    13175        Laurens County
    13177        Lee County
    13179        Liberty County
    13181        Lincoln County
    13183        Long County
    13185        Lowndes County
    13187        Lumpkin County
    13189        McDuffie County
    13191        McIntosh County
    13193        Macon County
    13195        Madison County
    13197        Marion County
    13199        Meriwether County
    13201        Miller County
    13205        Mitchell County
    13207        Monroe County
    13209        Montgomery County
    13211        Morgan County
    13213        Murray County
    13215        Muscogee County
    13217        Newton County
    13219        Oconee County
    13221        Oglethorpe County
    13223        Paulding County
    13225        Peach County
    13227        Pickens County
    13229        Pierce County
    13231        Pike County
    13233        Polk County
    13235        Pulaski County
    13237        Putnam County
    13239        Quitman County
    13241        Rabun County
    13243        Randolph County
    13245        Richmond County
    13247        Rockdale County
    13249        Schley County
    13251        Screven County
    13253        Seminole County
    13255        Spalding County
    13257        Stephens County
    13259        Stewart County
    13261        Sumter County
    13263        Talbot County
    13265        Taliaferro County
    13267        Tattnall County
    13269        Taylor County
    13271        Telfair County
    13273        Terrell County
    13275        Thomas County
    13277        Tift County
    13279        Toombs County
    13281        Towns County
    13283        Treutlen County
    13285        Troup County
    13287        Turner County
    13289        Twiggs County
    13291        Union County
    13293        Upson County
    13295        Walker County
    13297        Walton County
    13299        Ware County
    13301        Warren County
    13303        Washington County
    13305        Wayne County
    13307        Webster County
    13309        Wheeler County
    13311        White County
    13313        Whitfield County
    13315        Wilcox County
    13317        Wilkes County
    13319        Wilkinson County
    13321        Worth County
*.    15000        Hawaii
*.    15001        Hawaii County
*.    15003        Honolulu County
*.    15005        Kalawao County
*.    15007        Kauai County
*.    15009        Maui County
    16000        Idaho
    16001        Ada County
    16003        Adams County
    16005        Bannock County
    16007        Bear Lake County
    16009        Benewah County
    16011        Bingham County
    16013        Blaine County
    16015        Boise County
    16017        Bonner County
    16019        Bonneville County
    16021        Boundary County
    16023        Butte County
    16025        Camas County
    16027        Canyon County
    16029        Caribou County
    16031        Cassia County
    16033        Clark County
    16035        Clearwater County
    16037        Custer County
    16039        Elmore County
    16041        Franklin County
    16043        Fremont County
    16045        Gem County
    16047        Gooding County
    16049        Idaho County
    16051        Jefferson County
    16053        Jerome County
    16055        Kootenai County
    16057        Latah County
    16059        Lemhi County
    16061        Lewis County
    16063        Lincoln County
    16065        Madison County
    16067        Minidoka County
    16069        Nez Perce County
    16071        Oneida County
    16073        Owyhee County
    16075        Payette County
    16077        Power County
    16079        Shoshone County
    16081        Teton County
    16083        Twin Falls County
    16085        Valley County
    16087        Washington County
    17000        Illinois
    17001        Adams County
    17003        Alexander County
    17005        Bond County
    17007        Boone County
    17009        Brown County
    17011        Bureau County
    17013        Calhoun County
    17015        Carroll County
    17017        Cass County
    17019        Champaign County
    17021        Christian County
    17023        Clark County
    17025        Clay County
    17027        Clinton County
    17029        Coles County
    17031        Cook County
    17033        Crawford County
    17035        Cumberland County
    17037        DeKalb County
    17039        De Witt County
    17041        Douglas County
    17043        DuPage County
    17045        Edgar County
    17047        Edwards County
    17049        Effingham County
    17051        Fayette County
    17053        Ford County
    17055        Franklin County
    17057        Fulton County
    17059        Gallatin County
    17061        Greene County
    17063        Grundy County
    17065        Hamilton County
    17067        Hancock County
    17069        Hardin County
    17071        Henderson County
    17073        Henry County
    17075        Iroquois County
    17077        Jackson County
    17079        Jasper County
    17081        Jefferson County
    17083        Jersey County
    17085        Jo Daviess County
    17087        Johnson County
    17089        Kane County
    17091        Kankakee County
    17093        Kendall County
    17095        Knox County
    17097        Lake County
    17099        La Salle County
    17101        Lawrence County
    17103        Lee County
    17105        Livingston County
    17107        Logan County
    17109        McDonough County
    17111        McHenry County
    17113        McLean County
    17115        Macon County
    17117        Macoupin County
    17119        Madison County
    17121        Marion County
    17123        Marshall County
    17125        Mason County
    17127        Massac County
    17129        Menard County
    17131        Mercer County
    17133        Monroe County
    17135        Montgomery County
    17137        Morgan County
    17139        Moultrie County
    17141        Ogle County
    17143        Peoria County
    17145        Perry County
    17147        Piatt County
    17149        Pike County
    17151        Pope County
    17153        Pulaski County
    17155        Putnam County
    17157        Randolph County
    17159        Richland County
    17161        Rock Island County
    17163        St. Clair County
    17165        Saline County
    17167        Sangamon County
    17169        Schuyler County
    17171        Scott County
    17173        Shelby County
    17175        Stark County
    17177        Stephenson County
    17179        Tazewell County
    17181        Union County
    17183        Vermilion County
    17185        Wabash County
    17187        Warren County
    17189        Washington County
    17191        Wayne County
    17193        White County
    17195        Whiteside County
    17197        Will County
    17199        Williamson County
    17201        Winnebago County
    17203        Woodford County
    18000        Indiana
    18001        Adams County
    18003        Allen County
    18005        Bartholomew County
    18007        Benton County
    18009        Blackford County
    18011        Boone County
    18013        Brown County
    18015        Carroll County
    18017        Cass County
    18019        Clark County
    18021        Clay County
    18023        Clinton County
    18025        Crawford County
    18027        Daviess County
    18029        Dearborn County
    18031        Decatur County
    18033        De Kalb County
    18035        Delaware County
    18037        Dubois County
    18039        Elkhart County
    18041        Fayette County
    18043        Floyd County
    18045        Fountain County
    18047        Franklin County
    18049        Fulton County
    18051        Gibson County
    18053        Grant County
    18055        Greene County
    18057        Hamilton County
    18059        Hancock County
    18061        Harrison County
    18063        Hendricks County
    18065        Henry County
    18067        Howard County
    18069        Huntington County
    18071        Jackson County
    18073        Jasper County
    18075        Jay County
    18077        Jefferson County
    18079        Jennings County
    18081        Johnson County
    18083        Knox County
    18085        Kosciusko County
    18087        Lagrange County
    18089        Lake County
    18091        La Porte County
    18093        Lawrence County
    18095        Madison County
    18097        Marion County
    18099        Marshall County
    18101        Martin County
    18103        Miami County
    18105        Monroe County
    18107        Montgomery County
    18109        Morgan County
    18111        Newton County
    18113        Noble County
    18115        Ohio County
    18117        Orange County
    18119        Owen County
    18121        Parke County
    18123        Perry County
    18125        Pike County
    18127        Porter County
    18129        Posey County
    18131        Pulaski County
    18133        Putnam County
    18135        Randolph County
    18137        Ripley County
    18139        Rush County
    18141        St. Joseph County
    18143        Scott County
    18145        Shelby County
    18147        Spencer County
    18149        Starke County
    18151        Steuben County
    18153        Sullivan County
    18155        Switzerland County
    18157        Tippecanoe County
    18159        Tipton County
    18161        Union County
    18163        Vanderburgh County
    18165        Vermillion County
    18167        Vigo County
    18169        Wabash County
    18171        Warren County
    18173        Warrick County
    18175        Washington County
    18177        Wayne County
    18179        Wells County
    18181        White County
    18183        Whitley County
    19000        Iowa
    19001        Adair County
    19003        Adams County
    19005        Allamakee County
    19007        Appanoose County
    19009        Audubon County
    19011        Benton County
    19013        Black Hawk County
    19015        Boone County
    19017        Bremer County
    19019        Buchanan County
    19021        Buena Vista County
    19023        Butler County
    19025        Calhoun County
    19027        Carroll County
    19029        Cass County
    19031        Cedar County
    19033        Cerro Gordo County
    19035        Cherokee County
    19037        Chickasaw County
    19039        Clarke County
    19041        Clay County
    19043        Clayton County
    19045        Clinton County
    19047        Crawford County
    19049        Dallas County
    19051        Davis County
    19053        Decatur County
    19055        Delaware County
    19057        Des Moines County
    19059        Dickinson County
    19061        Dubuque County
    19063        Emmet County
    19065        Fayette County
    19067        Floyd County
    19069        Franklin County
    19071        Fremont County
    19073        Greene County
    19075        Grundy County
    19077        Guthrie County
    19079        Hamilton County
    19081        Hancock County
    19083        Hardin County
    19085        Harrison County
    19087        Henry County
    19089        Howard County
    19091        Humboldt County
    19093        Ida County
    19095        Iowa County
    19097        Jackson County
    19099        Jasper County
    19101        Jefferson County
    19103        Johnson County
    19105        Jones County
    19107        Keokuk County
    19109        Kossuth County
    19111        Lee County
    19113        Linn County
    19115        Louisa County
    19117        Lucas County
    19119        Lyon County
    19121        Madison County
    19123        Mahaska County
    19125        Marion County
    19127        Marshall County
    19129        Mills County
    19131        Mitchell County
    19133        Monona County
    19135        Monroe County
    19137        Montgomery County
    19139        Muscatine County
    19141        O
    19143        Osceola County
    19145        Page County
    19147        Palo Alto County
    19149        Plymouth County
    19151        Pocahontas County
    19153        Polk County
    19155        Pottawattamie County
    19157        Poweshiek County
    19159        Ringgold County
    19161        Sac County
    19163        Scott County
    19165        Shelby County
    19167        Sioux County
    19169        Story County
    19171        Tama County
    19173        Taylor County
    19175        Union County
    19177        Van Buren County
    19179        Wapello County
    19181        Warren County
    19183        Washington County
    19185        Wayne County
    19187        Webster County
    19189        Winnebago County
    19191        Winneshiek County
    19193        Woodbury County
    19195        Worth County
    19197        Wright County
    20000        Kansas
    20001        Allen County
    20003        Anderson County
    20005        Atchison County
    20007        Barber County
    20009        Barton County
    20011        Bourbon County
    20013        Brown County
    20015        Butler County
    20017        Chase County
    20019        Chautauqua County
    20021        Cherokee County
    20023        Cheyenne County
    20025        Clark County
    20027        Clay County
    20029        Cloud County
    20031        Coffey County
    20033        Comanche County
    20035        Cowley County
    20037        Crawford County
    20039        Decatur County
    20041        Dickinson County
    20043        Doniphan County
    20045        Douglas County
    20047        Edwards County
    20049        Elk County
    20051        Ellis County
    20053        Ellsworth County
    20055        Finney County
    20057        Ford County
    20059        Franklin County
    20061        Geary County
    20063        Gove County
    20065        Graham County
    20067        Grant County
    20069        Gray County
    20071        Greeley County
    20073        Greenwood County
    20075        Hamilton County
    20077        Harper County
    20079        Harvey County
    20081        Haskell County
    20083        Hodgeman County
    20085        Jackson County
    20087        Jefferson County
    20089        Jewell County
    20091        Johnson County
    20093        Kearny County
    20095        Kingman County
    20097        Kiowa County
    20099        Labette County
    20101        Lane County
    20103        Leavenworth County
    20105        Lincoln County
    20107        Linn County
    20109        Logan County
    20111        Lyon County
    20113        McPherson County
    20115        Marion County
    20117        Marshall County
    20119        Meade County
    20121        Miami County
    20123        Mitchell County
    20125        Montgomery County
    20127        Morris County
    20129        Morton County
    20131        Nemaha County
    20133        Neosho County
    20135        Ness County
    20137        Norton County
    20139        Osage County
    20141        Osborne County
    20143        Ottawa County
    20145        Pawnee County
    20147        Phillips County
    20149        Pottawatomie County
    20151        Pratt County
    20153        Rawlins County
    20155        Reno County
    20157        Republic County
    20159        Rice County
    20161        Riley County
    20163        Rooks County
    20165        Rush County
    20167        Russell County
    20169        Saline County
    20171        Scott County
    20173        Sedgwick County
    20175        Seward County
    20177        Shawnee County
    20179        Sheridan County
    20181        Sherman County
    20183        Smith County
    20185        Stafford County
    20187        Stanton County
    20189        Stevens County
    20191        Sumner County
    20193        Thomas County
    20195        Trego County
    20197        Wabaunsee County
    20199        Wallace County
    20201        Washington County
    20203        Wichita County
    20205        Wilson County
    20207        Woodson County
    20209        Wyandotte County
    21000        Kentucky
    21001        Adair County
    21003        Allen County
    21005        Anderson County
    21007        Ballard County
    21009        Barren County
    21011        Bath County
    21013        Bell County
    21015        Boone County
    21017        Bourbon County
    21019        Boyd County
    21021        Boyle County
    21023        Bracken County
    21025        Breathitt County
    21027        Breckinridge County
    21029        Bullitt County
    21031        Butler County
    21033        Caldwell County
    21035        Calloway County
    21037        Campbell County
    21039        Carlisle County
    21041        Carroll County
    21043        Carter County
    21045        Casey County
    21047        Christian County
    21049        Clark County
    21051        Clay County
    21053        Clinton County
    21055        Crittenden County
    21057        Cumberland County
    21059        Daviess County
    21061        Edmonson County
    21063        Elliott County
    21065        Estill County
    21067        Fayette County
    21069        Fleming County
    21071        Floyd County
    21073        Franklin County
    21075        Fulton County
    21077        Gallatin County
    21079        Garrard County
    21081        Grant County
    21083        Graves County
    21085        Grayson County
    21087        Green County
    21089        Greenup County
    21091        Hancock County
    21093        Hardin County
    21095        Harlan County
    21097        Harrison County
    21099        Hart County
    21101        Henderson County
    21103        Henry County
    21105        Hickman County
    21107        Hopkins County
    21109        Jackson County
    21111        Jefferson County
    21113        Jessamine County
    21115        Johnson County
    21117        Kenton County
    21119        Knott County
    21121        Knox County
    21123        Larue County
    21125        Laurel County
    21127        Lawrence County
    21129        Lee County
    21131        Leslie County
    21133        Letcher County
    21135        Lewis County
    21137        Lincoln County
    21139        Livingston County
    21141        Logan County
    21143        Lyon County
    21145        McCracken County
    21147        McCreary County
    21149        McLean County
    21151        Madison County
    21153        Magoffin County
    21155        Marion County
    21157        Marshall County
    21159        Martin County
    21161        Mason County
    21163        Meade County
    21165        Menifee County
    21167        Mercer County
    21169        Metcalfe County
    21171        Monroe County
    21173        Montgomery County
    21175        Morgan County
    21177        Muhlenberg County
    21179        Nelson County
    21181        Nicholas County
    21183        Ohio County
    21185        Oldham County
    21187        Owen County
    21189        Owsley County
    21191        Pendleton County
    21193        Perry County
    21195        Pike County
    21197        Powell County
    21199        Pulaski County
    21201        Robertson County
    21203        Rockcastle County
    21205        Rowan County
    21207        Russell County
    21209        Scott County
    21211        Shelby County
    21213        Simpson County
    21215        Spencer County
    21217        Taylor County
    21219        Todd County
    21221        Trigg County
    21223        Trimble County
    21225        Union County
    21227        Warren County
    21229        Washington County
    21231        Wayne County
    21233        Webster County
    21235        Whitley County
    21237        Wolfe County
    21239        Woodford County
    22000        Louisiana
    22001        Acadia Parish
    22003        Allen Parish
    22005        Ascension Parish
    22007        Assumption Parish
    22009        Avoyelles Parish
    22011        Beauregard Parish
    22013        Bienville Parish
    22015        Bossier Parish
    22017        Caddo Parish
    22019        Calcasieu Parish
    22021        Caldwell Parish
    22023        Cameron Parish
    22025        Catahoula Parish
    22027        Claiborne Parish
    22029        Concordia Parish
    22031        De Soto Parish
    22033        East Baton Rouge Parish
    22035        East Carroll Parish
    22037        East Feliciana Parish
    22039        Evangeline Parish
    22041        Franklin Parish
    22043        Grant Parish
    22045        Iberia Parish
    22047        Iberville Parish
    22049        Jackson Parish
    22051        Jefferson Parish
    22053        Jefferson Davis Parish
    22055        Lafayette Parish
    22057        Lafourche Parish
    22059        La Salle Parish
    22061        Lincoln Parish
    22063        Livingston Parish
    22065        Madison Parish
    22067        Morehouse Parish
    22069        Natchitoches Parish
    22071        Orleans Parish
    22073        Ouachita Parish
    22075        Plaquemines Parish
    22077        Pointe Coupee Parish
    22079        Rapides Parish
    22081        Red River Parish
    22083        Richland Parish
    22085        Sabine Parish
    22087        St. Bernard Parish
    22089        St. Charles Parish
    22091        St. Helena Parish
    22093        St. James Parish
    22095        St. John the Baptist Parish
    22097        St. Landry Parish
    22099        St. Martin Parish
    22101        St. Mary Parish
    22103        St. Tammany Parish
    22105        Tangipahoa Parish
    22107        Tensas Parish
    22109        Terrebonne Parish
    22111        Union Parish
    22113        Vermilion Parish
    22115        Vernon Parish
    22117        Washington Parish
    22119        Webster Parish
    22121        West Baton Rouge Parish
    22123        West Carroll Parish
    22125        West Feliciana Parish
    22127        Winn Parish
    23000        Maine
    23001        Androscoggin County
    23003        Aroostook County
    23005        Cumberland County
    23007        Franklin County
    23009        Hancock County
    23011        Kennebec County
    23013        Knox County
    23015        Lincoln County
    23017        Oxford County
    23019        Penobscot County
    23021        Piscataquis County
    23023        Sagadahoc County
    23025        Somerset County
    23027        Waldo County
    23029        Washington County
    23031        York County
    24000        Maryland
    24001        Allegany County
    24003        Anne Arundel County
    24005        Baltimore County
    24009        Calvert County
    24011        Caroline County
    24013        Carroll County
    24015        Cecil County
    24017        Charles County
    24019        Dorchester County
    24021        Frederick County
    24023        Garrett County
    24025        Harford County
    24027        Howard County
    24029        Kent County
    24031        Montgomery County
    24033        Prince George
    24035        Queen Anne
    24037        St. Mary
    24039        Somerset County
    24041        Talbot County
    24043        Washington County
    24045        Wicomico County
    24047        Worcester County
    24510        Baltimore city
    25000        Massachusetts
    25001        Barnstable County
    25003        Berkshire County
    25005        Bristol County
    25007        Dukes County
    25009        Essex County
    25011        Franklin County
    25013        Hampden County
    25015        Hampshire County
    25017        Middlesex County
    25019        Nantucket County
    25021        Norfolk County
    25023        Plymouth County
    25025        Suffolk County
    25027        Worcester County
    26000        Michigan
    26001        Alcona County
    26003        Alger County
    26005        Allegan County
    26007        Alpena County
    26009        Antrim County
    26011        Arenac County
    26013        Baraga County
    26015        Barry County
    26017        Bay County
    26019        Benzie County
    26021        Berrien County
    26023        Branch County
    26025        Calhoun County
    26027        Cass County
    26029        Charlevoix County
    26031        Cheboygan County
    26033        Chippewa County
    26035        Clare County
    26037        Clinton County
    26039        Crawford County
    26041        Delta County
    26043        Dickinson County
    26045        Eaton County
    26047        Emmet County
    26049        Genesee County
    26051        Gladwin County
    26053        Gogebic County
    26055        Grand Traverse County
    26057        Gratiot County
    26059        Hillsdale County
    26061        Houghton County
    26063        Huron County
    26065        Ingham County
    26067        Ionia County
    26069        Iosco County
    26071        Iron County
    26073        Isabella County
    26075        Jackson County
    26077        Kalamazoo County
    26079        Kalkaska County
    26081        Kent County
    26083        Keweenaw County
    26085        Lake County
    26087        Lapeer County
    26089        Leelanau County
    26091        Lenawee County
    26093        Livingston County
    26095        Luce County
    26097        Mackinac County
    26099        Macomb County
    26101        Manistee County
    26103        Marquette County
    26105        Mason County
    26107        Mecosta County
    26109        Menominee County
    26111        Midland County
    26113        Missaukee County
    26115        Monroe County
    26117        Montcalm County
    26119        Montmorency County
    26121        Muskegon County
    26123        Newaygo County
    26125        Oakland County
    26127        Oceana County
    26129        Ogemaw County
    26131        Ontonagon County
    26133        Osceola County
    26135        Oscoda County
    26137        Otsego County
    26139        Ottawa County
    26141        Presque Isle County
    26143        Roscommon County
    26145        Saginaw County
    26147        St. Clair County
    26149        St. Joseph County
    26151        Sanilac County
    26153        Schoolcraft County
    26155        Shiawassee County
    26157        Tuscola County
    26159        Van Buren County
    26161        Washtenaw County
    26163        Wayne County
    26165        Wexford County
    27000        Minnesota
    27001        Aitkin County
    27003        Anoka County
    27005        Becker County
    27007        Beltrami County
    27009        Benton County
    27011        Big Stone County
    27013        Blue Earth County
    27015        Brown County
    27017        Carlton County
    27019        Carver County
    27021        Cass County
    27023        Chippewa County
    27025        Chisago County
    27027        Clay County
    27029        Clearwater County
    27031        Cook County
    27033        Cottonwood County
    27035        Crow Wing County
    27037        Dakota County
    27039        Dodge County
    27041        Douglas County
    27043        Faribault County
    27045        Fillmore County
    27047        Freeborn County
    27049        Goodhue County
    27051        Grant County
    27053        Hennepin County
    27055        Houston County
    27057        Hubbard County
    27059        Isanti County
    27061        Itasca County
    27063        Jackson County
    27065        Kanabec County
    27067        Kandiyohi County
    27069        Kittson County
    27071        Koochiching County
    27073        Lac qui Parle County
    27075        Lake County
    27077        Lake of the Woods County
    27079        Le Sueur County
    27081        Lincoln County
    27083        Lyon County
    27085        McLeod County
    27087        Mahnomen County
    27089        Marshall County
    27091        Martin County
    27093        Meeker County
    27095        Mille Lacs County
    27097        Morrison County
    27099        Mower County
    27101        Murray County
    27103        Nicollet County
    27105        Nobles County
    27107        Norman County
    27109        Olmsted County
    27111        Otter Tail County
    27113        Pennington County
    27115        Pine County
    27117        Pipestone County
    27119        Polk County
    27121        Pope County
    27123        Ramsey County
    27125        Red Lake County
    27127        Redwood County
    27129        Renville County
    27131        Rice County
    27133        Rock County
    27135        Roseau County
    27137        St. Louis County
    27139        Scott County
    27141        Sherburne County
    27143        Sibley County
    27145        Stearns County
    27147        Steele County
    27149        Stevens County
    27151        Swift County
    27153        Todd County
    27155        Traverse County
    27157        Wabasha County
    27159        Wadena County
    27161        Waseca County
    27163        Washington County
    27165        Watonwan County
    27167        Wilkin County
    27169        Winona County
    27171        Wright County
    27173        Yellow Medicine County
    28000        Mississippi
    28001        Adams County
    28003        Alcorn County
    28005        Amite County
    28007        Attala County
    28009        Benton County
    28011        Bolivar County
    28013        Calhoun County
    28015        Carroll County
    28017        Chickasaw County
    28019        Choctaw County
    28021        Claiborne County
    28023        Clarke County
    28025        Clay County
    28027        Coahoma County
    28029        Copiah County
    28031        Covington County
    28033        DeSoto County
    28035        Forrest County
    28037        Franklin County
    28039        George County
    28041        Greene County
    28043        Grenada County
    28045        Hancock County
    28047        Harrison County
    28049        Hinds County
    28051        Holmes County
    28053        Humphreys County
    28055        Issaquena County
    28057        Itawamba County
    28059        Jackson County
    28061        Jasper County
    28063        Jefferson County
    28065        Jefferson Davis County
    28067        Jones County
    28069        Kemper County
    28071        Lafayette County
    28073        Lamar County
    28075        Lauderdale County
    28077        Lawrence County
    28079        Leake County
    28081        Lee County
    28083        Leflore County
    28085        Lincoln County
    28087        Lowndes County
    28089        Madison County
    28091        Marion County
    28093        Marshall County
    28095        Monroe County
    28097        Montgomery County
    28099        Neshoba County
    28101        Newton County
    28103        Noxubee County
    28105        Oktibbeha County
    28107        Panola County
    28109        Pearl River County
    28111        Perry County
    28113        Pike County
    28115        Pontotoc County
    28117        Prentiss County
    28119        Quitman County
    28121        Rankin County
    28123        Scott County
    28125        Sharkey County
    28127        Simpson County
    28129        Smith County
    28131        Stone County
    28133        Sunflower County
    28135        Tallahatchie County
    28137        Tate County
    28139        Tippah County
    28141        Tishomingo County
    28143        Tunica County
    28145        Union County
    28147        Walthall County
    28149        Warren County
    28151        Washington County
    28153        Wayne County
    28155        Webster County
    28157        Wilkinson County
    28159        Winston County
    28161        Yalobusha County
    28163        Yazoo County
    29000        Missouri
    29001        Adair County
    29003        Andrew County
    29005        Atchison County
    29007        Audrain County
    29009        Barry County
    29011        Barton County
    29013        Bates County
    29015        Benton County
    29017        Bollinger County
    29019        Boone County
    29021        Buchanan County
    29023        Butler County
    29025        Caldwell County
    29027        Callaway County
    29029        Camden County
    29031        Cape Girardeau County
    29033        Carroll County
    29035        Carter County
    29037        Cass County
    29039        Cedar County
    29041        Chariton County
    29043        Christian County
    29045        Clark County
    29047        Clay County
    29049        Clinton County
    29051        Cole County
    29053        Cooper County
    29055        Crawford County
    29057        Dade County
    29059        Dallas County
    29061        Daviess County
    29063        DeKalb County
    29065        Dent County
    29067        Douglas County
    29069        Dunklin County
    29071        Franklin County
    29073        Gasconade County
    29075        Gentry County
    29077        Greene County
    29079        Grundy County
    29081        Harrison County
    29083        Henry County
    29085        Hickory County
    29087        Holt County
    29089        Howard County
    29091        Howell County
    29093        Iron County
    29095        Jackson County
    29097        Jasper County
    29099        Jefferson County
    29101        Johnson County
    29103        Knox County
    29105        Laclede County
    29107        Lafayette County
    29109        Lawrence County
    29111        Lewis County
    29113        Lincoln County
    29115        Linn County
    29117        Livingston County
    29119        McDonald County
    29121        Macon County
    29123        Madison County
    29125        Maries County
    29127        Marion County
    29129        Mercer County
    29131        Miller County
    29133        Mississippi County
    29135        Moniteau County
    29137        Monroe County
    29139        Montgomery County
    29141        Morgan County
    29143        New Madrid County
    29145        Newton County
    29147        Nodaway County
    29149        Oregon County
    29151        Osage County
    29153        Ozark County
    29155        Pemiscot County
    29157        Perry County
    29159        Pettis County
    29161        Phelps County
    29163        Pike County
    29165        Platte County
    29167        Polk County
    29169        Pulaski County
    29171        Putnam County
    29173        Ralls County
    29175        Randolph County
    29177        Ray County
    29179        Reynolds County
    29181        Ripley County
    29183        St. Charles County
    29185        St. Clair County
    29186        Ste. Genevieve County
    29187        St. Francois County
    29189        St. Louis County
    29195        Saline County
    29197        Schuyler County
    29199        Scotland County
    29201        Scott County
    29203        Shannon County
    29205        Shelby County
    29207        Stoddard County
    29209        Stone County
    29211        Sullivan County
    29213        Taney County
    29215        Texas County
    29217        Vernon County
    29219        Warren County
    29221        Washington County
    29223        Wayne County
    29225        Webster County
    29227        Worth County
    29229        Wright County
    29510        St. Louis city
    30000        Montana
    30001        Beaverhead County
    30003        Big Horn County
    30005        Blaine County
    30007        Broadwater County
    30009        Carbon County
    30011        Carter County
    30013        Cascade County
    30015        Chouteau County
    30017        Custer County
    30019        Daniels County
    30021        Dawson County
    30023        Deer Lodge County
    30025        Fallon County
    30027        Fergus County
    30029        Flathead County
    30031        Gallatin County
    30033        Garfield County
    30035        Glacier County
    30037        Golden Valley County
    30039        Granite County
    30041        Hill County
    30043        Jefferson County
    30045        Judith Basin County
    30047        Lake County
    30049        Lewis and Clark County
    30051        Liberty County
    30053        Lincoln County
    30055        McCone County
    30057        Madison County
    30059        Meagher County
    30061        Mineral County
    30063        Missoula County
    30065        Musselshell County
    30067        Park County
    30069        Petroleum County
    30071        Phillips County
    30073        Pondera County
    30075        Powder River County
    30077        Powell County
    30079        Prairie County
    30081        Ravalli County
    30083        Richland County
    30085        Roosevelt County
    30087        Rosebud County
    30089        Sanders County
    30091        Sheridan County
    30093        Silver Bow County
    30095        Stillwater County
    30097        Sweet Grass County
    30099        Teton County
    30101        Toole County
    30103        Treasure County
    30105        Valley County
    30107        Wheatland County
    30109        Wibaux County
    30111        Yellowstone County
    30113        Yellowstone National Park
    31000        Nebraska
    31001        Adams County
    31003        Antelope County
    31005        Arthur County
    31007        Banner County
    31009        Blaine County
    31011        Boone County
    31013        Box Butte County
    31015        Boyd County
    31017        Brown County
    31019        Buffalo County
    31021        Burt County
    31023        Butler County
    31025        Cass County
    31027        Cedar County
    31029        Chase County
    31031        Cherry County
    31033        Cheyenne County
    31035        Clay County
    31037        Colfax County
    31039        Cuming County
    31041        Custer County
    31043        Dakota County
    31045        Dawes County
    31047        Dawson County
    31049        Deuel County
    31051        Dixon County
    31053        Dodge County
    31055        Douglas County
    31057        Dundy County
    31059        Fillmore County
    31061        Franklin County
    31063        Frontier County
    31065        Furnas County
    31067        Gage County
    31069        Garden County
    31071        Garfield County
    31073        Gosper County
    31075        Grant County
    31077        Greeley County
    31079        Hall County
    31081        Hamilton County
    31083        Harlan County
    31085        Hayes County
    31087        Hitchcock County
    31089        Holt County
    31091        Hooker County
    31093        Howard County
    31095        Jefferson County
    31097        Johnson County
    31099        Kearney County
    31101        Keith County
    31103        Keya Paha County
    31105        Kimball County
    31107        Knox County
    31109        Lancaster County
    31111        Lincoln County
    31113        Logan County
    31115        Loup County
    31117        McPherson County
    31119        Madison County
    31121        Merrick County
    31123        Morrill County
    31125        Nance County
    31127        Nemaha County
    31129        Nuckolls County
    31131        Otoe County
    31133        Pawnee County
    31135        Perkins County
    31137        Phelps County
    31139        Pierce County
    31141        Platte County
    31143        Polk County
    31145        Red Willow County
    31147        Richardson County
    31149        Rock County
    31151        Saline County
    31153        Sarpy County
    31155        Saunders County
    31157        Scotts Bluff County
    31159        Seward County
    31161        Sheridan County
    31163        Sherman County
    31165        Sioux County
    31167        Stanton County
    31169        Thayer County
    31171        Thomas County
    31173        Thurston County
    31175        Valley County
    31177        Washington County
    31179        Wayne County
    31181        Webster County
    31183        Wheeler County
    31185        York County
    32000        Nevada
    32001        Churchill County
    32003        Clark County
    32005        Douglas County
    32007        Elko County
    32009        Esmeralda County
    32011        Eureka County
    32013        Humboldt County
    32015        Lander County
    32017        Lincoln County
    32019        Lyon County
    32021        Mineral County
    32023        Nye County
    32027        Pershing County
    32029        Storey County
    32031        Washoe County
    32033        White Pine County
    32510        Carson City
    33000        New Hampshire
    33001        Belknap County
    33003        Carroll County
    33005        Cheshire County
    33007        Coos County
    33009        Grafton County
    33011        Hillsborough County
    33013        Merrimack County
    33015        Rockingham County
    33017        Strafford County
    33019        Sullivan County
    34000        New Jersey
    34001        Atlantic County
    34003        Bergen County
    34005        Burlington County
    34007        Camden County
    34009        Cape May County
    34011        Cumberland County
    34013        Essex County
    34015        Gloucester County
    34017        Hudson County
    34019        Hunterdon County
    34021        Mercer County
    34023        Middlesex County
    34025        Monmouth County
    34027        Morris County
    34029        Ocean County
    34031        Passaic County
    34033        Salem County
    34035        Somerset County
    34037        Sussex County
    34039        Union County
    34041        Warren County
    35000        New Mexico
    35001        Bernalillo County
    35003        Catron County
    35005        Chaves County
    35006        Cibola County
    35007        Colfax County
    35009        Curry County
    35011        DeBaca County
    35013        Dona Ana County
    35015        Eddy County
    35017        Grant County
    35019        Guadalupe County
    35021        Harding County
    35023        Hidalgo County
    35025        Lea County
    35027        Lincoln County
    35028        Los Alamos County
    35029        Luna County
    35031        McKinley County
    35033        Mora County
    35035        Otero County
    35037        Quay County
    35039        Rio Arriba County
    35041        Roosevelt County
    35043        Sandoval County
    35045        San Juan County
    35047        San Miguel County
    35049        Santa Fe County
    35051        Sierra County
    35053        Socorro County
    35055        Taos County
    35057        Torrance County
    35059        Union County
    35061        Valencia County
    36000        New York
    36001        Albany County
    36003        Allegany County
    36005        Bronx County
    36007        Broome County
    36009        Cattaraugus County
    36011        Cayuga County
    36013        Chautauqua County
    36015        Chemung County
    36017        Chenango County
    36019        Clinton County
    36021        Columbia County
    36023        Cortland County
    36025        Delaware County
    36027        Dutchess County
    36029        Erie County
    36031        Essex County
    36033        Franklin County
    36035        Fulton County
    36037        Genesee County
    36039        Greene County
    36041        Hamilton County
    36043        Herkimer County
    36045        Jefferson County
    36047        Kings County
    36049        Lewis County
    36051        Livingston County
    36053        Madison County
    36055        Monroe County
    36057        Montgomery County
    36059        Nassau County
    36061        New York County
    36063        Niagara County
    36065        Oneida County
    36067        Onondaga County
    36069        Ontario County
    36071        Orange County
    36073        Orleans County
    36075        Oswego County
    36077        Otsego County
    36079        Putnam County
    36081        Queens County
    36083        Rensselaer County
    36085        Richmond County
    36087        Rockland County
    36089        St. Lawrence County
    36091        Saratoga County
    36093        Schenectady County
    36095        Schoharie County
    36097        Schuyler County
    36099        Seneca County
    36101        Steuben County
    36103        Suffolk County
    36105        Sullivan County
    36107        Tioga County
    36109        Tompkins County
    36111        Ulster County
    36113        Warren County
    36115        Washington County
    36117        Wayne County
    36119        Westchester County
    36121        Wyoming County
    36123        Yates County
    37000        North Carolina
    37001        Alamance County
    37003        Alexander County
    37005        Alleghany County
    37007        Anson County
    37009        Ashe County
    37011        Avery County
    37013        Beaufort County
    37015        Bertie County
    37017        Bladen County
    37019        Brunswick County
    37021        Buncombe County
    37023        Burke County
    37025        Cabarrus County
    37027        Caldwell County
    37029        Camden County
    37031        Carteret County
    37033        Caswell County
    37035        Catawba County
    37037        Chatham County
    37039        Cherokee County
    37041        Chowan County
    37043        Clay County
    37045        Cleveland County
    37047        Columbus County
    37049        Craven County
    37051        Cumberland County
    37053        Currituck County
    37055        Dare County
    37057        Davidson County
    37059        Davie County
    37061        Duplin County
    37063        Durham County
    37065        Edgecombe County
    37067        Forsyth County
    37069        Franklin County
    37071        Gaston County
    37073        Gates County
    37075        Graham County
    37077        Granville County
    37079        Greene County
    37081        Guilford County
    37083        Halifax County
    37085        Harnett County
    37087        Haywood County
    37089        Henderson County
    37091        Hertford County
    37093        Hoke County
    37095        Hyde County
    37097        Iredell County
    37099        Jackson County
    37101        Johnston County
    37103        Jones County
    37105        Lee County
    37107        Lenoir County
    37109        Lincoln County
    37111        McDowell County
    37113        Macon County
    37115        Madison County
    37117        Martin County
    37119        Mecklenburg County
    37121        Mitchell County
    37123        Montgomery County
    37125        Moore County
    37127        Nash County
    37129        New Hanover County
    37131        Northampton County
    37133        Onslow County
    37135        Orange County
    37137        Pamlico County
    37139        Pasquotank County
    37141        Pender County
    37143        Perquimans County
    37145        Person County
    37147        Pitt County
    37149        Polk County
    37151        Randolph County
    37153        Richmond County
    37155        Robeson County
    37157        Rockingham County
    37159        Rowan County
    37161        Rutherford County
    37163        Sampson County
    37165        Scotland County
    37167        Stanly County
    37169        Stokes County
    37171        Surry County
    37173        Swain County
    37175        Transylvania County
    37177        Tyrrell County
    37179        Union County
    37181        Vance County
    37183        Wake County
    37185        Warren County
    37187        Washington County
    37189        Watauga County
    37191        Wayne County
    37193        Wilkes County
    37195        Wilson County
    37197        Yadkin County
    37199        Yancey County
    38000        North Dakota
    38001        Adams County
    38003        Barnes County
    38005        Benson County
    38007        Billings County
    38009        Bottineau County
    38011        Bowman County
    38013        Burke County
    38015        Burleigh County
    38017        Cass County
    38019        Cavalier County
    38021        Dickey County
    38023        Divide County
    38025        Dunn County
    38027        Eddy County
    38029        Emmons County
    38031        Foster County
    38033        Golden Valley County
    38035        Grand Forks County
    38037        Grant County
    38039        Griggs County
    38041        Hettinger County
    38043        Kidder County
    38045        LaMoure County
    38047        Logan County
    38049        McHenry County
    38051        McIntosh County
    38053        McKenzie County
    38055        McLean County
    38057        Mercer County
    38059        Morton County
    38061        Mountrail County
    38063        Nelson County
    38065        Oliver County
    38067        Pembina County
    38069        Pierce County
    38071        Ramsey County
    38073        Ransom County
    38075        Renville County
    38077        Richland County
    38079        Rolette County
    38081        Sargent County
    38083        Sheridan County
    38085        Sioux County
    38087        Slope County
    38089        Stark County
    38091        Steele County
    38093        Stutsman County
    38095        Towner County
    38097        Traill County
    38099        Walsh County
    38101        Ward County
    38103        Wells County
    38105        Williams County
    39000        Ohio
    39001        Adams County
    39003        Allen County
    39005        Ashland County
    39007        Ashtabula County
    39009        Athens County
    39011        Auglaize County
    39013        Belmont County
    39015        Brown County
    39017        Butler County
    39019        Carroll County
    39021        Champaign County
    39023        Clark County
    39025        Clermont County
    39027        Clinton County
    39029        Columbiana County
    39031        Coshocton County
    39033        Crawford County
    39035        Cuyahoga County
    39037        Darke County
    39039        Defiance County
    39041        Delaware County
    39043        Erie County
    39045        Fairfield County
    39047        Fayette County
    39049        Franklin County
    39051        Fulton County
    39053        Gallia County
    39055        Geauga County
    39057        Greene County
    39059        Guernsey County
    39061        Hamilton County
    39063        Hancock County
    39065        Hardin County
    39067        Harrison County
    39069        Henry County
    39071        Highland County
    39073        Hocking County
    39075        Holmes County
    39077        Huron County
    39079        Jackson County
    39081        Jefferson County
    39083        Knox County
    39085        Lake County
    39087        Lawrence County
    39089        Licking County
    39091        Logan County
    39093        Lorain County
    39095        Lucas County
    39097        Madison County
    39099        Mahoning County
    39101        Marion County
    39103        Medina County
    39105        Meigs County
    39107        Mercer County
    39109        Miami County
    39111        Monroe County
    39113        Montgomery County
    39115        Morgan County
    39117        Morrow County
    39119        Muskingum County
    39121        Noble County
    39123        Ottawa County
    39125        Paulding County
    39127        Perry County
    39129        Pickaway County
    39131        Pike County
    39133        Portage County
    39135        Preble County
    39137        Putnam County
    39139        Richland County
    39141        Ross County
    39143        Sandusky County
    39145        Scioto County
    39147        Seneca County
    39149        Shelby County
    39151        Stark County
    39153        Summit County
    39155        Trumbull County
    39157        Tuscarawas County
    39159        Union County
    39161        Van Wert County
    39163        Vinton County
    39165        Warren County
    39167        Washington County
    39169        Wayne County
    39171        Williams County
    39173        Wood County
    39175        Wyandot County
    40000        Oklahoma
    40001        Adair County
    40003        Alfalfa County
    40005        Atoka County
    40007        Beaver County
    40009        Beckham County
    40011        Blaine County
    40013        Bryan County
    40015        Caddo County
    40017        Canadian County
    40019        Carter County
    40021        Cherokee County
    40023        Choctaw County
    40025        Cimarron County
    40027        Cleveland County
    40029        Coal County
    40031        Comanche County
    40033        Cotton County
    40035        Craig County
    40037        Creek County
    40039        Custer County
    40041        Delaware County
    40043        Dewey County
    40045        Ellis County
    40047        Garfield County
    40049        Garvin County
    40051        Grady County
    40053        Grant County
    40055        Greer County
    40057        Harmon County
    40059        Harper County
    40061        Haskell County
    40063        Hughes County
    40065        Jackson County
    40067        Jefferson County
    40069        Johnston County
    40071        Kay County
    40073        Kingfisher County
    40075        Kiowa County
    40077        Latimer County
    40079        Le Flore County
    40081        Lincoln County
    40083        Logan County
    40085        Love County
    40087        McClain County
    40089        McCurtain County
    40091        McIntosh County
    40093        Major County
    40095        Marshall County
    40097        Mayes County
    40099        Murray County
    40101        Muskogee County
    40103        Noble County
    40105        Nowata County
    40107        Okfuskee County
    40109        Oklahoma County
    40111        Okmulgee County
    40113        Osage County
    40115        Ottawa County
    40117        Pawnee County
    40119        Payne County
    40121        Pittsburg County
    40123        Pontotoc County
    40125        Pottawatomie County
    40127        Pushmataha County
    40129        Roger Mills County
    40131        Rogers County
    40133        Seminole County
    40135        Sequoyah County
    40137        Stephens County
    40139        Texas County
    40141        Tillman County
    40143        Tulsa County
    40145        Wagoner County
    40147        Washington County
    40149        Washita County
    40151        Woods County
    40153        Woodward County
    41000        Oregon
    41001        Baker County
    41003        Benton County
    41005        Clackamas County
    41007        Clatsop County
    41009        Columbia County
    41011        Coos County
    41013        Crook County
    41015        Curry County
    41017        Deschutes County
    41019        Douglas County
    41021        Gilliam County
    41023        Grant County
    41025        Harney County
    41027        Hood River County
    41029        Jackson County
    41031        Jefferson County
    41033        Josephine County
    41035        Klamath County
    41037        Lake County
    41039        Lane County
    41041        Lincoln County
    41043        Linn County
    41045        Malheur County
    41047        Marion County
    41049        Morrow County
    41051        Multnomah County
    41053        Polk County
    41055        Sherman County
    41057        Tillamook County
    41059        Umatilla County
    41061        Union County
    41063        Wallowa County
    41065        Wasco County
    41067        Washington County
    41069        Wheeler County
    41071        Yamhill County
    42000        Pennsylvania
    42001        Adams County
    42003        Allegheny County
    42005        Armstrong County
    42007        Beaver County
    42009        Bedford County
    42011        Berks County
    42013        Blair County
    42015        Bradford County
    42017        Bucks County
    42019        Butler County
    42021        Cambria County
    42023        Cameron County
    42025        Carbon County
    42027        Centre County
    42029        Chester County
    42031        Clarion County
    42033        Clearfield County
    42035        Clinton County
    42037        Columbia County
    42039        Crawford County
    42041        Cumberland County
    42043        Dauphin County
    42045        Delaware County
    42047        Elk County
    42049        Erie County
    42051        Fayette County
    42053        Forest County
    42055        Franklin County
    42057        Fulton County
    42059        Greene County
    42061        Huntingdon County
    42063        Indiana County
    42065        Jefferson County
    42067        Juniata County
    42069        Lackawanna County
    42071        Lancaster County
    42073        Lawrence County
    42075        Lebanon County
    42077        Lehigh County
    42079        Luzerne County
    42081        Lycoming County
    42083        Mc Kean County
    42085        Mercer County
    42087        Mifflin County
    42089        Monroe County
    42091        Montgomery County
    42093        Montour County
    42095        Northampton County
    42097        Northumberland County
    42099        Perry County
    42101        Philadelphia County
    42103        Pike County
    42105        Potter County
    42107        Schuylkill County
    42109        Snyder County
    42111        Somerset County
    42113        Sullivan County
    42115        Susquehanna County
    42117        Tioga County
    42119        Union County
    42121        Venango County
    42123        Warren County
    42125        Washington County
    42127        Wayne County
    42129        Westmoreland County
    42131        Wyoming County
    42133        York County
    44000        Rhode Island
    44001        Bristol County
    44003        Kent County
    44005        Newport County
    44007        Providence County
    44009        Washington County
    45000        South Carolina
    45001        Abbeville County
    45003        Aiken County
    45005        Allendale County
    45007        Anderson County
    45009        Bamberg County
    45011        Barnwell County
    45013        Beaufort County
    45015        Berkeley County
    45017        Calhoun County
    45019        Charleston County
    45021        Cherokee County
    45023        Chester County
    45025        Chesterfield County
    45027        Clarendon County
    45029        Colleton County
    45031        Darlington County
    45033        Dillon County
    45035        Dorchester County
    45037        Edgefield County
    45039        Fairfield County
    45041        Florence County
    45043        Georgetown County
    45045        Greenville County
    45047        Greenwood County
    45049        Hampton County
    45051        Horry County
    45053        Jasper County
    45055        Kershaw County
    45057        Lancaster County
    45059        Laurens County
    45061        Lee County
    45063        Lexington County
    45065        McCormick County
    45067        Marion County
    45069        Marlboro County
    45071        Newberry County
    45073        Oconee County
    45075        Orangeburg County
    45077        Pickens County
    45079        Richland County
    45081        Saluda County
    45083        Spartanburg County
    45085        Sumter County
    45087        Union County
    45089        Williamsburg County
    45091        York County
    46000        South Dakota
    46003        Aurora County
    46005        Beadle County
    46007        Bennett County
    46009        Bon Homme County
    46011        Brookings County
    46013        Brown County
    46015        Brule County
    46017        Buffalo County
    46019        Butte County
    46021        Campbell County
    46023        Charles Mix County
    46025        Clark County
    46027        Clay County
    46029        Codington County
    46031        Corson County
    46033        Custer County
    46035        Davison County
    46037        Day County
    46039        Deuel County
    46041        Dewey County
    46043        Douglas County
    46045        Edmunds County
    46047        Fall River County
    46049        Faulk County
    46051        Grant County
    46053        Gregory County
    46055        Haakon County
    46057        Hamlin County
    46059        Hand County
    46061        Hanson County
    46063        Harding County
    46065        Hughes County
    46067        Hutchinson County
    46069        Hyde County
    46071        Jackson County
    46073        Jerauld County
    46075        Jones County
    46077        Kingsbury County
    46079        Lake County
    46081        Lawrence County
    46083        Lincoln County
    46085        Lyman County
    46087        McCook County
    46089        McPherson County
    46091        Marshall County
    46093        Meade County
    46095        Mellette County
    46097        Miner County
    46099        Minnehaha County
    46101        Moody County
    46103        Pennington County
    46105        Perkins County
    46107        Potter County
    46109        Roberts County
    46111        Sanborn County
    46113        Shannon County
    46115        Spink County
    46117        Stanley County
    46119        Sully County
    46121        Todd County
    46123        Tripp County
    46125        Turner County
    46127        Union County
    46129        Walworth County
    46135        Yankton County
    46137        Ziebach County
    47000        Tennessee
    47001        Anderson County
    47003        Bedford County
    47005        Benton County
    47007        Bledsoe County
    47009        Blount County
    47011        Bradley County
    47013        Campbell County
    47015        Cannon County
    47017        Carroll County
    47019        Carter County
    47021        Cheatham County
    47023        Chester County
    47025        Claiborne County
    47027        Clay County
    47029        Cocke County
    47031        Coffee County
    47033        Crockett County
    47035        Cumberland County
    47037        Davidson County
    47039        Decatur County
    47041        DeKalb County
    47043        Dickson County
    47045        Dyer County
    47047        Fayette County
    47049        Fentress County
    47051        Franklin County
    47053        Gibson County
    47055        Giles County
    47057        Grainger County
    47059        Greene County
    47061        Grundy County
    47063        Hamblen County
    47065        Hamilton County
    47067        Hancock County
    47069        Hardeman County
    47071        Hardin County
    47073        Hawkins County
    47075        Haywood County
    47077        Henderson County
    47079        Henry County
    47081        Hickman County
    47083        Houston County
    47085        Humphreys County
    47087        Jackson County
    47089        Jefferson County
    47091        Johnson County
    47093        Knox County
    47095        Lake County
    47097        Lauderdale County
    47099        Lawrence County
    47101        Lewis County
    47103        Lincoln County
    47105        Loudon County
    47107        McMinn County
    47109        McNairy County
    47111        Macon County
    47113        Madison County
    47115        Marion County
    47117        Marshall County
    47119        Maury County
    47121        Meigs County
    47123        Monroe County
    47125        Montgomery County
    47127        Moore County
    47129        Morgan County
    47131        Obion County
    47133        Overton County
    47135        Perry County
    47137        Pickett County
    47139        Polk County
    47141        Putnam County
    47143        Rhea County
    47145        Roane County
    47147        Robertson County
    47149        Rutherford County
    47151        Scott County
    47153        Sequatchie County
    47155        Sevier County
    47157        Shelby County
    47159        Smith County
    47161        Stewart County
    47163        Sullivan County
    47165        Sumner County
    47167        Tipton County
    47169        Trousdale County
    47171        Unicoi County
    47173        Union County
    47175        Van Buren County
    47177        Warren County
    47179        Washington County
    47181        Wayne County
    47183        Weakley County
    47185        White County
    47187        Williamson County
    47189        Wilson County
    48000        Texas
    48001        Anderson County
    48003        Andrews County
    48005        Angelina County
    48007        Aransas County
    48009        Archer County
    48011        Armstrong County
    48013        Atascosa County
    48015        Austin County
    48017        Bailey County
    48019        Bandera County
    48021        Bastrop County
    48023        Baylor County
    48025        Bee County
    48027        Bell County
    48029        Bexar County
    48031        Blanco County
    48033        Borden County
    48035        Bosque County
    48037        Bowie County
    48039        Brazoria County
    48041        Brazos County
    48043        Brewster County
    48045        Briscoe County
    48047        Brooks County
    48049        Brown County
    48051        Burleson County
    48053        Burnet County
    48055        Caldwell County
    48057        Calhoun County
    48059        Callahan County
    48061        Cameron County
    48063        Camp County
    48065        Carson County
    48067        Cass County
    48069        Castro County
    48071        Chambers County
    48073        Cherokee County
    48075        Childress County
    48077        Clay County
    48079        Cochran County
    48081        Coke County
    48083        Coleman County
    48085        Collin County
    48087        Collingsworth County
    48089        Colorado County
    48091        Comal County
    48093        Comanche County
    48095        Concho County
    48097        Cooke County
    48099        Coryell County
    48101        Cottle County
    48103        Crane County
    48105        Crockett County
    48107        Crosby County
    48109        Culberson County
    48111        Dallam County
    48113        Dallas County
    48115        Dawson County
    48117        Deaf Smith County
    48119        Delta County
    48121        Denton County
    48123        DeWitt County
    48125        Dickens County
    48127        Dimmit County
    48129        Donley County
    48131        Duval County
    48133        Eastland County
    48135        Ector County
    48137        Edwards County
    48139        Ellis County
    48141        El Paso County
    48143        Erath County
    48145        Falls County
    48147        Fannin County
    48149        Fayette County
    48151        Fisher County
    48153        Floyd County
    48155        Foard County
    48157        Fort Bend County
    48159        Franklin County
    48161        Freestone County
    48163        Frio County
    48165        Gaines County
    48167        Galveston County
    48169        Garza County
    48171        Gillespie County
    48173        Glasscock County
    48175        Goliad County
    48177        Gonzales County
    48179        Gray County
    48181        Grayson County
    48183        Gregg County
    48185        Grimes County
    48187        Guadalupe County
    48189        Hale County
    48191        Hall County
    48193        Hamilton County
    48195        Hansford County
    48197        Hardeman County
    48199        Hardin County
    48201        Harris County
    48203        Harrison County
    48205        Hartley County
    48207        Haskell County
    48209        Hays County
    48211        Hemphill County
    48213        Henderson County
    48215        Hidalgo County
    48217        Hill County
    48219        Hockley County
    48221        Hood County
    48223        Hopkins County
    48225        Houston County
    48227        Howard County
    48229        Hudspeth County
    48231        Hunt County
    48233        Hutchinson County
    48235        Irion County
    48237        Jack County
    48239        Jackson County
    48241        Jasper County
    48243        Jeff Davis County
    48245        Jefferson County
    48247        Jim Hogg County
    48249        Jim Wells County
    48251        Johnson County
    48253        Jones County
    48255        Karnes County
    48257        Kaufman County
    48259        Kendall County
    48261        Kenedy County
    48263        Kent County
    48265        Kerr County
    48267        Kimble County
    48269        King County
    48271        Kinney County
    48273        Kleberg County
    48275        Knox County
    48277        Lamar County
    48279        Lamb County
    48281        Lampasas County
    48283        La Salle County
    48285        Lavaca County
    48287        Lee County
    48289        Leon County
    48291        Liberty County
    48293        Limestone County
    48295        Lipscomb County
    48297        Live Oak County
    48299        Llano County
    48301        Loving County
    48303        Lubbock County
    48305        Lynn County
    48307        McCulloch County
    48309        McLennan County
    48311        McMullen County
    48313        Madison County
    48315        Marion County
    48317        Martin County
    48319        Mason County
    48321        Matagorda County
    48323        Maverick County
    48325        Medina County
    48327        Menard County
    48329        Midland County
    48331        Milam County
    48333        Mills County
    48335        Mitchell County
    48337        Montague County
    48339        Montgomery County
    48341        Moore County
    48343        Morris County
    48345        Motley County
    48347        Nacogdoches County
    48349        Navarro County
    48351        Newton County
    48353        Nolan County
    48355        Nueces County
    48357        Ochiltree County
    48359        Oldham County
    48361        Orange County
    48363        Palo Pinto County
    48365        Panola County
    48367        Parker County
    48369        Parmer County
    48371        Pecos County
    48373        Polk County
    48375        Potter County
    48377        Presidio County
    48379        Rains County
    48381        Randall County
    48383        Reagan County
    48385        Real County
    48387        Red River County
    48389        Reeves County
    48391        Refugio County
    48393        Roberts County
    48395        Robertson County
    48397        Rockwall County
    48399        Runnels County
    48401        Rusk County
    48403        Sabine County
    48405        San Augustine County
    48407        San Jacinto County
    48409        San Patricio County
    48411        San Saba County
    48413        Schleicher County
    48415        Scurry County
    48417        Shackelford County
    48419        Shelby County
    48421        Sherman County
    48423        Smith County
    48425        Somervell County
    48427        Starr County
    48429        Stephens County
    48431        Sterling County
    48433        Stonewall County
    48435        Sutton County
    48437        Swisher County
    48439        Tarrant County
    48441        Taylor County
    48443        Terrell County
    48445        Terry County
    48447        Throckmorton County
    48449        Titus County
    48451        Tom Green County
    48453        Travis County
    48455        Trinity County
    48457        Tyler County
    48459        Upshur County
    48461        Upton County
    48463        Uvalde County
    48465        Val Verde County
    48467        Van Zandt County
    48469        Victoria County
    48471        Walker County
    48473        Waller County
    48475        Ward County
    48477        Washington County
    48479        Webb County
    48481        Wharton County
    48483        Wheeler County
    48485        Wichita County
    48487        Wilbarger County
    48489        Willacy County
    48491        Williamson County
    48493        Wilson County
    48495        Winkler County
    48497        Wise County
    48499        Wood County
    48501        Yoakum County
    48503        Young County
    48505        Zapata County
    48507        Zavala County
    49000        Utah
    49001        Beaver County
    49003        Box Elder County
    49005        Cache County
    49007        Carbon County
    49009        Daggett County
    49011        Davis County
    49013        Duchesne County
    49015        Emery County
    49017        Garfield County
    49019        Grand County
    49021        Iron County
    49023        Juab County
    49025        Kane County
    49027        Millard County
    49029        Morgan County
    49031        Piute County
    49033        Rich County
    49035        Salt Lake County
    49037        San Juan County
    49039        Sanpete County
    49041        Sevier County
    49043        Summit County
    49045        Tooele County
    49047        Uintah County
    49049        Utah County
    49051        Wasatch County
    49053        Washington County
    49055        Wayne County
    49057        Weber County
    50000        Vermont
    50001        Addison County
    50003        Bennington County
    50005        Caledonia County
    50007        Chittenden County
    50009        Essex County
    50011        Franklin County
    50013        Grand Isle County
    50015        Lamoille County
    50017        Orange County
    50019        Orleans County
    50021        Rutland County
    50023        Washington County
    50025        Windham County
    50027        Windsor County
    51000        Virginia
    51001        Accomack County
    51003        Albemarle County
    51005        Alleghany County
    51007        Amelia County
    51009        Amherst County
    51011        Appomattox County
    51013        Arlington County
    51015        Augusta County
    51017        Bath County
    51019        Bedford County
    51021        Bland County
    51023        Botetourt County
    51025        Brunswick County
    51027        Buchanan County
    51029        Buckingham County
    51031        Campbell County
    51033        Caroline County
    51035        Carroll County
    51036        Charles City County
    51037        Charlotte County
    51041        Chesterfield County
    51043        Clarke County
    51045        Craig County
    51047        Culpeper County
    51049        Cumberland County
    51051        Dickenson County
    51053        Dinwiddie County
    51057        Essex County
    51059        Fairfax County
    51061        Fauquier County
    51063        Floyd County
    51065        Fluvanna County
    51067        Franklin County
    51069        Frederick County
    51071        Giles County
    51073        Gloucester County
    51075        Goochland County
    51077        Grayson County
    51079        Greene County
    51081        Greensville County
    51083        Halifax County
    51085        Hanover County
    51087        Henrico County
    51089        Henry County
    51091        Highland County
    51093        Isle of Wight County
    51095        James City County
    51097        King and Queen County
    51099        King George County
    51101        King William County
    51103        Lancaster County
    51105        Lee County
    51107        Loudoun County
    51109        Louisa County
    51111        Lunenburg County
    51113        Madison County
    51115        Mathews County
    51117        Mecklenburg County
    51119        Middlesex County
    51121        Montgomery County
    51125        Nelson County
    51127        New Kent County
    51131        Northampton County
    51133        Northumberland County
    51135        Nottoway County
    51137        Orange County
    51139        Page County
    51141        Patrick County
    51143        Pittsylvania County
    51145        Powhatan County
    51147        Prince Edward County
    51149        Prince George County
    51153        Prince William County
    51155        Pulaski County
    51157        Rappahannock County
    51159        Richmond County
    51161        Roanoke County
    51163        Rockbridge County
    51165        Rockingham County
    51167        Russell County
    51169        Scott County
    51171        Shenandoah County
    51173        Smyth County
    51175        Southampton County
    51177        Spotsylvania County
    51179        Stafford County
    51181        Surry County
    51183        Sussex County
    51185        Tazewell County
    51187        Warren County
    51191        Washington County
    51193        Westmoreland County
    51195        Wise County
    51197        Wythe County
    51199        York County
    51510        Alexandria city
    51515        Bedford city
    51520        Bristol city
    51530        Buena Vista city
    51540        Charlottesville city
    51550        Chesapeake city
    51560        Clifton Forge city
    51570        Colonial Heights city
    51580        Covington city
    51590        Danville city
    51595        Emporia city
    51600        Fairfax city
    51610        Falls Church city
    51620        Franklin city
    51630        Fredericksburg city
    51640        Galax city
    51650        Hampton city
    51660        Harrisonburg city
    51670        Hopewell city
    51678        Lexington city
    51680        Lynchburg city
    51683        Manassas city
    51685        Manassas Park city
    51690        Martinsville city
    51700        Newport News city
    51710        Norfolk city
    51720        Norton city
    51730        Petersburg city
    51735        Poquoson city
    51740        Portsmouth city
    51750        Radford city
    51760        Richmond city
    51770        Roanoke city
    51775        Salem city
    51780        South Boston city                
    51790        Staunton city
    51800        Suffolk city
    51810        Virginia Beach city
    51820        Waynesboro city
    51830        Williamsburg city
    51840        Winchester city
    53000        Washington
    53001        Adams County
    53003        Asotin County
    53005        Benton County
    53007        Chelan County
    53009        Clallam County
    53011        Clark County
    53013        Columbia County
    53015        Cowlitz County
    53017        Douglas County
    53019        Ferry County
    53021        Franklin County
    53023        Garfield County
    53025        Grant County
    53027        Grays Harbor County
    53029        Island County
    53031        Jefferson County
    53033        King County
    53035        Kitsap County
    53037        Kittitas County
    53039        Klickitat County
    53041        Lewis County
    53043        Lincoln County
    53045        Mason County
    53047        Okanogan County
    53049        Pacific County
    53051        Pend Oreille County
    53053        Pierce County
    53055        San Juan County
    53057        Skagit County
    53059        Skamania County
    53061        Snohomish County
    53063        Spokane County
    53065        Stevens County
    53067        Thurston County
    53069        Wahkiakum County
    53071        Walla Walla County
    53073        Whatcom County
    53075        Whitman County
    53077        Yakima County
    54000        West Virginia
    54001        Barbour County
    54003        Berkeley County
    54005        Boone County
    54007        Braxton County
    54009        Brooke County
    54011        Cabell County
    54013        Calhoun County
    54015        Clay County
    54017        Doddridge County
    54019        Fayette County
    54021        Gilmer County
    54023        Grant County
    54025        Greenbrier County
    54027        Hampshire County
    54029        Hancock County
    54031        Hardy County
    54033        Harrison County
    54035        Jackson County
    54037        Jefferson County
    54039        Kanawha County
    54041        Lewis County
    54043        Lincoln County
    54045        Logan County
    54047        McDowell County
    54049        Marion County
    54051        Marshall County
    54053        Mason County
    54055        Mercer County
    54057        Mineral County
    54059        Mingo County
    54061        Monongalia County
    54063        Monroe County
    54065        Morgan County
    54067        Nicholas County
    54069        Ohio County
    54071        Pendleton County
    54073        Pleasants County
    54075        Pocahontas County
    54077        Preston County
    54079        Putnam County
    54081        Raleigh County
    54083        Randolph County
    54085        Ritchie County
    54087        Roane County
    54089        Summers County
    54091        Taylor County
    54093        Tucker County
    54095        Tyler County
    54097        Upshur County
    54099        Wayne County
    54101        Webster County
    54103        Wetzel County
    54105        Wirt County
    54107        Wood County
    54109        Wyoming County
    55000        Wisconsin
    55001        Adams County
    55003        Ashland County
    55005        Barron County
    55007        Bayfield County
    55009        Brown County
    55011        Buffalo County
    55013        Burnett County
    55015        Calumet County
    55017        Chippewa County
    55019        Clark County
    55021        Columbia County
    55023        Crawford County
    55025        Dane County
    55027        Dodge County
    55029        Door County
    55031        Douglas County
    55033        Dunn County
    55035        Eau Claire County
    55037        Florence County
    55039        Fond du Lac County
    55041        Forest County
    55043        Grant County
    55045        Green County
    55047        Green Lake County
    55049        Iowa County
    55051        Iron County
    55053        Jackson County
    55055        Jefferson County
    55057        Juneau County
    55059        Kenosha County
    55061        Kewaunee County
    55063        La Crosse County
    55065        Lafayette County
    55067        Langlade County
    55069        Lincoln County
    55071        Manitowoc County
    55073        Marathon County
    55075        Marinette County
    55077        Marquette County
    55078        Menominee County
    55079        Milwaukee County
    55081        Monroe County
    55083        Oconto County
    55085        Oneida County
    55087        Outagamie County
    55089        Ozaukee County
    55091        Pepin County
    55093        Pierce County
    55095        Polk County
    55097        Portage County
    55099        Price County
    55101        Racine County
    55103        Richland County
    55105        Rock County
    55107        Rusk County
    55109        St. Croix County
    55111        Sauk County
    55113        Sawyer County
    55115        Shawano County
    55117        Sheboygan County
    55119        Taylor County
    55121        Trempealeau County
    55123        Vernon County
    55125        Vilas County
    55127        Walworth County
    55129        Washburn County
    55131        Washington County
    55133        Waukesha County
    55135        Waupaca County
    55137        Waushara County
    55139        Winnebago County
    55141        Wood County
    56000        Wyoming
    56001        Albany County
    56003        Big Horn County
    56005        Campbell County
    56007        Carbon County
    56009        Converse County
    56011        Crook County
    56013        Fremont County
    56015        Goshen County
    56017        Hot Springs County
    56019        Johnson County
    56021        Laramie County
    56023        Lincoln County
    56025        Natrona County
    56027        Niobrara County
    56029        Park County
    56031        Platte County
    56033        Sheridan County
    56035        Sublette County
    56037        Sweetwater County
    56039        Teton County
    56041        Uinta County
    56043        Washakie County
    56045        Weston County /;

parameter	gdp(*)	GDP statistics for a recent year /
 "00000"	23315081000
 "01000"	254109734
 "01001"	1862747
 "01003"	9891548
 "01005"	860027
 "01007"	511240
 "01009"	1211710
 "01011"	289132
 "01013"	809234
 "01015"	5108424
 "01017"	1003863
 "01019"	647497
 "01021"	1277386
 "01023"	586394
 "01025"	998805
 "01027"	509530
 "01029"	356069
 "01031"	1681588
 "01033"	2914003
 "01035"	456406
 "01037"	215536
 "01039"	1427931
 "01041"	486101
 "01043"	3508691
 "01045"	3147114
 "01047"	1285684
 "01049"	2292052
 "01051"	2213256
 "01053"	1370932
 "01055"	3175372
 "01057"	398732
 "01059"	1113119
 "01061"	648397
 "01063"	209573
 "01065"	290391
 "01067"	536521
 "01069"	6451197
 "01071"	1694195
 "01073"	51658141
 "01075"	390612
 "01077"	3075955
 "01079"	667584
 "01081"	7335523
 "01083"	4609337
 "01085"	435892
 "01087"	619915
 "01089"	29477135
 "01091"	875190
 "01093"	1065703
 "01095"	4131982
 "01097"	22908642
 "01099"	732608
 "01101"	15738152
 "01103"	6615103
 "01105"	209787
 "01107"	522342
 "01109"	1603499
 "01111"	563528
 "01113"	1679025
 "01115"	2446517
 "01117"	13769154
 "01119"	354979
 "01121"	3391884
 "01123"	1576636
 "01125"	11891483
 "01127"	1915181
 "01129"	967974
 "01131"	394002
 "01133"	1045869
 "02000"	57349378
 "02013"	233494
 "02016"	444798
 "02020"	24832047
 "02050"	723486
 "02060"	148048
 "02063"	2042863
 "02066"	133945
 "02068"	286296
 "02070"	267597
 "02090"	6477984
 "02100"	116205
 "02105"	97008
 "02110"	2682516
 "02122"	3070355
 "02130"	957850
 "02150"	848359
 "02158"	173275
 "02164"	114731
 "02170"	3378629
 "02180"	480920
 "02185"	6885164
 "02188"	634546
 "02195"	204797
 "02198"	275582
*. "02201"	(NA)
 "02220"	513094
 "02230"	76420
*. "02232"	(NA)
 "02240"	760172
*. "02261"	(NA)
 "02275"	91110
*. "02280"	(NA)
 "02282"	43861
 "02290"	354226
 "04000"	420026672
 "04001"	2720216
 "04003"	5399087
 "04005"	8444850
 "04007"	2147803
 "04009"	1546301
 "04011"	2172860
 "04012"	877143
 "04013"	304496668
 "04015"	7037905
 "04017"	3309321
 "04019"	50231611
 "04021"	11593918
 "04023"	2274933
 "04025"	8796885
 "04027"	8977170
 "05000"	148676113
 "05001"	1248957
 "05003"	821835
 "05005"	1647490
 "05007"	18538651
 "05009"	1539051
 "05011"	420336
 "05013"	407558
 "05015"	1049964
 "05017"	319510
 "05019"	916225
 "05021"	416079
 "05023"	733576
 "05025"	159221
 "05027"	1019951
 "05029"	856383
 "05031"	5806904
 "05033"	2011103
 "05035"	1977793
 "05037"	508208
 "05039"	309609
 "05041"	596707
 "05043"	704621
 "05045"	4231942
 "05047"	496629
 "05049"	214707
 "05051"	3907112
 "05053"	526659
 "05055"	1684183
 "05057"	1158094
 "05059"	1193574
 "05061"	695633
 "05063"	2008754
 "05065"	317535
 "05067"	725487
 "05069"	3531670
 "05071"	778614
 "05073"	159515
 "05075"	494044
 "05077"	206650
 "05079"	305617
 "05081"	523159
 "05083"	546029
 "05085"	1589652
 "05087"	479132
 "05089"	620325
 "05091"	1504805
 "05093"	3332087
 "05095"	226957
 "05097"	156782
 "05099"	263629
 "05101"	117420
 "05103"	704390
 "05105"	172435
 "05107"	641692
 "05109"	299473
 "05111"	687775
 "05113"	672076
 "05115"	3347225
 "05117"	224161
 "05119"	33134697
 "05121"	601344
 "05123"	828211
 "05125"	3014597
 "05127"	361942
 "05129"	206807
 "05131"	7515124
 "05133"	539067
 "05135"	400973
 "05137"	281540
 "05139"	2866616
 "05141"	464068
 "05143"	14085162
 "05145"	2641479
 "05147"	262322
 "05149"	716807
 "06000"	3373240664
 "06001"	152982207
 "06003"	116410
 "06005"	1976931
 "06007"	10006052
 "06009"	1712179
 "06011"	1477208
 "06013"	80984498
 "06015"	907559
 "06017"	9098872
 "06019"	49987063
 "06021"	1233786
 "06023"	6456739
 "06025"	9912905
 "06027"	1437047
 "06029"	52239044
 "06031"	7258824
 "06033"	2326083
 "06035"	1332149
 "06037"	836162805
 "06039"	6907890
 "06041"	35172142
 "06043"	916395
 "06045"	4123802
 "06047"	10465518
 "06049"	545721
 "06051"	1274698
 "06053"	30712263
 "06055"	12387136
 "06057"	5036784
 "06059"	288519549
 "06061"	27665813
 "06063"	1097864
 "06065"	104504923
 "06067"	106417145
 "06069"	2933589
 "06071"	108678543
 "06073"	267973544
 "06075"	236385103
 "06077"	36790065
 "06079"	19639637
 "06081"	163153624
 "06083"	33306884
 "06085"	407484990
 "06087"	18076112
 "06089"	9419468
 "06091"	102647
 "06093"	1892676
 "06095"	33100194
 "06097"	34450601
 "06099"	26519792
 "06101"	4431816
 "06103"	2336651
 "06105"	468566
 "06107"	20580771
 "06109"	2793685
 "06111"	58332732
 "06113"	17360736
 "06115"	3672234
 "08000"	436359473
 "08001"	33769461
 "08003"	794161
 "08005"	53961953
 "08007"	631103
 "08009"	201745
 "08011"	153562
 "08013"	33182418
 "08014"	8786441
 "08015"	1013481
 "08017"	313774
 "08019"	598490
 "08021"	237289
 "08023"	94189
 "08025"	139926
 "08027"	169721
 "08029"	1040344
 "08031"	94022018
 "08033"	107817
 "08035"	22704068
 "08037"	4889858
 "08039"	910721
 "08041"	42424517
 "08043"	1663451
 "08045"	4320562
 "08047"	726224
 "08049"	1137289
 "08051"	1217610
 "08053"	41554
 "08055"	308227
 "08057"	116142
 "08059"	37372859
 "08061"	134816
 "08063"	553839
 "08065"	357844
 "08067"	3579155
 "08069"	24381467
 "08071"	631969
 "08073"	440138
 "08075"	1165381
 "08077"	7444077
 "08079"	66337
 "08081"	1208562
 "08083"	1559900
 "08085"	1908528
 "08087"	1743232
 "08089"	700722
 "08091"	337576
 "08093"	546817
 "08095"	226807
 "08097"	2639457
 "08099"	596025
 "08101"	7436671
 "08103"	679943
 "08105"	525325
 "08107"	2293491
 "08109"	241611
 "08111"	42742
 "08113"	779643
 "08115"	93821
 "08117"	3083152
 "08119"	1097579
 "08121"	204551
 "08123"	22082249
 "08125"	525068
 "09000"	298395175
 "09001"	98751750
 "09003"	89505307
 "09005"	9357182
 "09007"	10650029
 "09009"	57541201
 "09011"	20743047
 "09013"	6352285
 "09015"	5494372
 "10000"	81160011
 "10001"	9984324
 "10003"	55874458
 "10005"	15301229
 "11000"	153670489
 "11001"	153670489
 "12000"	1255558339
 "12001"	16672138
 "12003"	810732
 "12005"	10269545
 "12007"	773155
 "12009"	30589541
 "12011"	127254783
 "12013"	334464
 "12015"	6911071
 "12017"	5247686
 "12019"	6385972
 "12021"	24020049
 "12023"	2867288
 "12027"	1069168
 "12029"	386263
 "12031"	78166365
 "12033"	18538362
 "12035"	3622445
 "12037"	446179
 "12039"	1485074
 "12041"	430633
 "12043"	383959
 "12045"	527676
 "12047"	539641
 "12049"	1148716
 "12051"	1474682
 "12053"	5301331
 "12055"	2894022
 "12057"	110060883
 "12059"	472689
 "12061"	8063835
 "12063"	1622034
 "12065"	346943
 "12067"	172380
 "12069"	12557952
 "12071"	39813620
 "12073"	17499450
 "12075"	1251113
 "12077"	290489
 "12079"	477303
 "12081"	18486672
 "12083"	12907979
 "12085"	9242149
 "12086"	186265336
 "12087"	6105662
 "12089"	3426493
 "12091"	14558289
 "12093"	1945246
 "12095"	114193711
 "12097"	13790534
 "12099"	103627747
 "12101"	17157117
 "12103"	58189201
 "12105"	33144404
 "12107"	2584846
 "12109"	12577700
 "12111"	11520062
 "12113"	5770655
 "12115"	26259341
 "12117"	26737776
 "12119"	5507387
 "12121"	1413575
 "12123"	795059
 "12125"	382091
 "12127"	21893574
 "12129"	817495
 "12131"	4341108
 "12133"	737497
 "13000"	691626930
 "13001"	1907637
 "13003"	285076
 "13005"	386985
 "13007"	74630
 "13009"	1575236
 "13011"	473319
 "13013"	2789253
 "13015"	5872590
 "13017"	618613
 "13019"	418634
 "13021"	9204709
 "13023"	270342
 "13025"	300269
 "13027"	592130
 "13029"	1327077
 "13031"	2873671
 "13033"	3506549
 "13035"	857150
 "13037"	132756
 "13039"	2091947
 "13043"	321783
 "13045"	5921898
 "13047"	1793063
 "13049"	232244
 "13051"	21961700
 "13053"	1812064
 "13055"	590607
 "13057"	9248071
 "13059"	8712609
 "13061"	106748
 "13063"	16283997
 "13065"	262524
 "13067"	62965045
 "13069"	1751462
 "13071"	1736451
 "13073"	4974195
 "13075"	436702
 "13077"	5930335
 "13079"	171661
 "13081"	1036652
 "13083"	476486
 "13085"	1066531
 "13087"	994392
 "13089"	46898417
 "13091"	477589
 "13093"	413257
 "13095"	4987518
 "13097"	5578993
 "13099"	524688
 "13101"	49560
 "13103"	2392657
 "13105"	729473
 "13107"	801966
 "13109"	395593
 "13111"	927073
 "13113"	6270399
 "13115"	4539453
 "13117"	12165158
 "13119"	1036877
 "13121"	202341615
 "13123"	1003712
 "13125"	37864
 "13127"	4564040
 "13129"	2636051
 "13131"	737781
 "13133"	925687
 "13135"	57007581
 "13137"	1587584
 "13139"	13561088
 "13141"	186861
 "13143"	962127
 "13145"	611071
 "13147"	929584
 "13149"	1442640
 "13151"	8296829
 "13153"	7983297
 "13155"	242857
 "13157"	4392676
 "13159"	339442
 "13161"	496417
 "13163"	671261
 "13165"	177724
 "13167"	140591
 "13169"	516860
 "13171"	521552
 "13173"	145880
 "13175"	2051781
 "13177"	839987
 "13179"	4224101
 "13181"	150421
 "13183"	203745
 "13185"	5742182
 "13187"	1043973
 "13189"	770682
 "13191"	271892
 "13193"	437652
 "13195"	601343
 "13197"	129227
 "13199"	705514
 "13201"	249495
 "13205"	805461
 "13207"	1610697
 "13209"	156452
 "13211"	1131819
 "13213"	1543265
 "13215"	11926773
 "13217"	3325071
 "13219"	1916029
 "13221"	332573
 "13223"	3915352
 "13225"	1009827
 "13227"	1168415
 "13229"	516742
 "13231"	426347
 "13233"	1389798
 "13235"	324848
 "13237"	695518
 "13239"	39550
 "13241"	687508
 "13243"	198566
 "13245"	13676682
 "13247"	4707334
 "13249"	131506
 "13251"	366445
 "13253"	340763
 "13255"	2441123
 "13257"	1081065
 "13259"	144204
 "13261"	1132732
 "13263"	153727
 "13265"	30622
 "13267"	640365
 "13269"	240277
 "13271"	322189
 "13273"	251435
 "13275"	2525391
 "13277"	2185908
 "13279"	1134244
 "13281"	431568
 "13283"	108821
 "13285"	3983911
 "13287"	237301
 "13289"	314090
 "13291"	963261
 "13293"	794988
 "13295"	1723810
 "13297"	3242877
 "13299"	1550979
 "13301"	193875
 "13303"	681505
 "13305"	1182234
 "13307"	78078
 "13309"	122544
 "13311"	1030351
 "13313"	6406809
 "13315"	159178
 "13317"	342637
 "13319"	650827
 "13321"	383533
 "15000"	91096121
 "15001"	9186858
 "15003"	67383319
 "15007"	4169925
 "15901"	10356019
 "16000"	96282794
 "16001"	34164131
 "16003"	157014
 "16005"	3293730
 "16007"	208044
 "16009"	405698
 "16011"	1536381
 "16013"	1913887
 "16015"	222579
 "16017"	1982178
 "16019"	7506192
 "16021"	427901
 "16023"	1450010
 "16025"	92615
 "16027"	8227021
 "16029"	829846
 "16031"	1666168
 "16033"	41193
 "16035"	422262
 "16037"	199650
 "16039"	1470924
 "16041"	453653
 "16043"	404120
 "16045"	517578
 "16047"	1452518
 "16049"	578945
 "16051"	959127
 "16053"	1466757
 "16055"	8112478
 "16057"	1593277
 "16059"	303805
 "16061"	204857
 "16063"	304469
 "16065"	1515108
 "16067"	918445
 "16069"	2476212
 "16071"	167264
 "16073"	470092
 "16075"	983611
 "16077"	438279
 "16079"	777043
 "16081"	443760
 "16083"	4412128
 "16085"	614590
 "16087"	497251
 "17000"	945673819
 "17001"	3965094
 "17003"	173792
 "17005"	645380
 "17007"	1826586
 "17009"	561185
 "17011"	1467356
 "17013"	110528
 "17015"	647326
 "17017"	741330
 "17019"	12605358
 "17021"	1774770
 "17023"	637665
 "17025"	624987
 "17027"	1247469
 "17029"	2886241
 "17031"	448552133
 "17033"	1278584
 "17035"	899721
 "17037"	5005088
 "17039"	1382947
 "17041"	1239231
 "17043"	104892806
 "17045"	939293
 "17047"	307119
 "17049"	2490036
 "17051"	658581
 "17053"	812353
 "17055"	1031313
 "17057"	987353
 "17059"	177365
 "17061"	376387
 "17063"	5169453
 "17065"	369446
 "17067"	660305
 "17069"	93231
 "17071"	206179
 "17073"	1753238
 "17075"	1215234
 "17077"	2741219
 "17079"	567337
 "17081"	2093588
 "17083"	615245
 "17085"	913306
 "17087"	270589
 "17089"	31059443
 "17091"	7282382
 "17093"	4550392
 "17095"	1986664
 "17097"	69682860
 "17099"	6449865
 "17101"	589194
 "17103"	1743431
 "17105"	2297427
 "17107"	1198735
 "17109"	1264682
 "17111"	12864578
 "17113"	15140725
 "17115"	7856804
 "17117"	1356419
 "17119"	13389541
 "17121"	1479716
 "17123"	485273
 "17125"	504463
 "17127"	791806
 "17129"	296058
 "17131"	497958
 "17133"	1060931
 "17135"	1139676
 "17137"	1822508
 "17139"	953099
 "17141"	3237806
 "17143"	13895275
 "17145"	690498
 "17147"	613735
 "17149"	679667
 "17151"	71391
 "17153"	195892
 "17155"	398064
 "17157"	1743094
 "17159"	655646
 "17161"	11504428
 "17163"	13158787
 "17165"	863186
 "17167"	12723014
 "17169"	285369
 "17171"	175086
 "17173"	869419
 "17175"	279029
 "17177"	2134519
 "17179"	6535729
 "17181"	510183
 "17183"	3645245
 "17185"	390569
 "17187"	920405
 "17189"	1138778
 "17191"	528639
 "17193"	574129
 "17195"	2463878
 "17197"	39643439
 "17199"	3194762
 "17201"	15178800
 "17203"	1416984
 "18000"	412975161
 "18001"	1993204
 "18003"	23189094
 "18005"	7205692
 "18007"	577181
 "18009"	377474
 "18011"	4468773
 "18013"	314052
 "18015"	826550
 "18017"	1641121
 "18019"	6162758
 "18021"	859843
 "18023"	1688539
 "18025"	192076
 "18027"	1544074
 "18029"	2143700
 "18031"	1749984
 "18033"	2945785
 "18035"	4486204
 "18037"	2943904
 "18039"	19271838
 "18041"	629405
 "18043"	3334295
 "18045"	536365
 "18047"	596487
 "18049"	799004
 "18051"	3569406
 "18053"	2659869
 "18055"	714765
 "18057"	23338012
 "18059"	3854777
 "18061"	1315412
 "18063"	8941535
 "18065"	1606459
 "18067"	4488369
 "18069"	1665220
 "18071"	2902275
 "18073"	1709612
 "18075"	1068985
 "18077"	1794889
 "18079"	802310
 "18081"	6676447
 "18083"	2080961
 "18085"	6587398
 "18087"	2043589
 "18089"	24480668
 "18091"	4521182
 "18093"	1592241
 "18095"	4268270
 "18097"	104833855
 "18099"	1843710
 "18101"	1233551
 "18103"	1090148
 "18105"	7649573
 "18107"	1938180
 "18109"	1947639
 "18111"	422369
 "18113"	2129588
 "18115"	134285
 "18117"	713545
 "18119"	622451
 "18121"	458441
 "18123"	846720
 "18125"	836182
 "18127"	7992731
 "18129"	3785981
 "18131"	775882
 "18133"	1211016
 "18135"	958769
 "18137"	1296592
 "18139"	722542
 "18141"	15740655
 "18143"	788540
 "18145"	2208610
 "18147"	1111952
 "18149"	565659
 "18151"	1663314
 "18153"	1056536
 "18155"	238315
 "18157"	10779671
 "18159"	701043
 "18161"	167880
 "18163"	12346968
 "18165"	1032822
 "18167"	5094465
 "18169"	1408022
 "18171"	353987
 "18173"	2812334
 "18175"	736431
 "18177"	3093331
 "18179"	1274389
 "18181"	1229348
 "18183"	1967086
 "19000"	216860235
 "19001"	560525
 "19003"	249854
 "19005"	679645
 "19007"	488192
 "19009"	344505
 "19011"	1137286
 "19013"	9258520
 "19015"	1229603
 "19017"	1268341
 "19019"	925769
 "19021"	1508644
 "19023"	615243
 "19025"	493683
 "19027"	1498110
 "19029"	785045
 "19031"	772054
 "19033"	2756909
 "19035"	756444
 "19037"	742846
 "19039"	460236
 "19041"	1209330
 "19043"	965461
 "19045"	2636730
 "19047"	876888
 "19049"	6631222
 "19051"	297339
 "19053"	234102
 "19055"	1015824
 "19057"	2377828
 "19059"	1298100
 "19061"	7840579
 "19063"	461536
 "19065"	869257
 "19067"	922202
 "19069"	725681
 "19071"	425743
 "19073"	631952
 "19075"	671119
 "19077"	542596
 "19079"	869800
 "19081"	927131
 "19083"	920837
 "19085"	568516
 "19087"	1077010
 "19089"	553745
 "19091"	538062
 "19093"	756613
 "19095"	1300665
 "19097"	743673
 "19099"	1431581
 "19101"	851489
 "19103"	10758024
 "19105"	787484
 "19107"	381662
 "19109"	1080354
 "19111"	2042837
 "19113"	17868409
 "19115"	1014185
 "19117"	348393
 "19119"	974205
 "19121"	506763
 "19123"	1002980
 "19125"	2745377
 "19127"	2207984
 "19129"	656532
 "19131"	674520
 "19133"	405698
 "19135"	493594
 "19137"	511359
 "19139"	2913012
 "19141"	999178
 "19143"	400545
 "19145"	739074
 "19147"	623248
 "19149"	1636851
 "19151"	573043
 "19153"	50539505
 "19155"	4799139
 "19157"	1447407
 "19159"	201655
 "19161"	624257
 "19163"	10848177
 "19165"	839050
 "19167"	2632666
 "19169"	6353655
 "19171"	870904
 "19173"	329325
 "19175"	855885
 "19177"	275863
 "19179"	1924359
 "19181"	1519618
 "19183"	1231205
 "19185"	294730
 "19187"	2310047
 "19189"	548949
 "19191"	1195142
 "19193"	5960811
 "19195"	396713
 "19197"	811795
 "20000"	191380562
 "20001"	662348
 "20003"	394997
 "20005"	770306
 "20007"	219484
 "20009"	1368896
 "20011"	657324
 "20013"	721668
 "20015"	2786181
 "20017"	156213
 "20019"	89996
 "20021"	911625
 "20023"	157804
 "20025"	216241
 "20027"	338857
 "20029"	455721
 "20031"	867262
 "20033"	67748
 "20035"	1490933
 "20037"	1863400
 "20039"	163050
 "20041"	731462
 "20043"	308878
 "20045"	5586561
 "20047"	183766
 "20049"	89046
 "20051"	1739274
 "20053"	322697
 "20055"	2488019
 "20057"	2681232
 "20059"	1045067
 "20061"	3245740
 "20063"	185331
 "20065"	154560
 "20067"	441888
 "20069"	601541
 "20071"	159147
 "20073"	172377
 "20075"	220310
 "20077"	323005
 "20079"	1556937
 "20081"	330208
 "20083"	125192
 "20085"	479647
 "20087"	481014
 "20089"	143290
 "20091"	56329449
 "20093"	275986
 "20095"	380961
 "20097"	159397
 "20099"	956965
 "20101"	114558
 "20103"	3184028
 "20105"	144525
 "20107"	583128
 "20109"	188138
 "20111"	1610625
 "20113"	2093135
 "20115"	452470
 "20117"	625971
 "20119"	284727
 "20121"	1131142
 "20123"	557676
 "20125"	2036848
 "20127"	209165
 "20129"	165201
 "20131"	579678
 "20133"	689974
 "20135"	203047
 "20137"	272979
 "20139"	389110
 "20141"	200275
 "20143"	149018
 "20145"	312642
 "20147"	413796
 "20149"	1486655
 "20151"	641750
 "20153"	186215
 "20155"	2912477
 "20157"	255895
 "20159"	643226
 "20161"	3085684
 "20163"	232810
 "20165"	171761
 "20167"	313152
 "20169"	3109963
 "20171"	319216
 "20173"	35384658
 "20175"	1429981
 "20177"	11681498
 "20179"	158438
 "20181"	374685
 "20183"	205034
 "20185"	202946
 "20187"	240272
 "20189"	391654
 "20191"	858598
 "20193"	667325
 "20195"	193403
 "20197"	173553
 "20199"	116506
 "20201"	267127
 "20203"	210244
 "20205"	355658
 "20207"	91610
 "20209"	12167709
 "21000"	237182031
 "21001"	454838
 "21003"	519102
 "21005"	624667
 "21007"	276613
 "21009"	1570924
 "21011"	226987
 "21013"	833779
 "21015"	13757078
 "21017"	984855
 "21019"	3295692
 "21021"	1393057
 "21023"	188790
 "21025"	225755
 "21027"	473813
 "21029"	2938546
 "21031"	354811
 "21033"	480681
 "21035"	1635422
 "21037"	4180899
 "21039"	188309
 "21041"	2277885
 "21043"	559130
 "21045"	403551
 "21047"	6613306
 "21049"	1700515
 "21051"	390139
 "21053"	395338
 "21055"	223568
 "21057"	187237
 "21059"	5320748
 "21061"	207071
 "21063"	89439
 "21065"	236485
 "21067"	22833587
 "21069"	364671
 "21071"	1189100
 "21073"	3581210
 "21075"	241306
 "21077"	402435
 "21079"	295947
 "21081"	610083
 "21083"	1414736
 "21085"	833253
 "21087"	211678
 "21089"	908104
 "21091"	831107
 "21093"	5867024
 "21095"	556989
 "21097"	571986
 "21099"	646322
 "21101"	2303684
 "21103"	390289
 "21105"	196551
 "21107"	1962139
 "21109"	172659
 "21111"	63604136
 "21113"	2382849
 "21115"	487668
 "21117"	10650071
 "21119"	225611
 "21121"	698324
 "21123"	276889
 "21125"	2437453
 "21127"	398517
 "21129"	133621
 "21131"	150680
 "21133"	383666
 "21135"	240806
 "21137"	489275
 "21139"	325910
 "21141"	1280869
 "21143"	261831
 "21145"	5134761
 "21147"	307579
 "21149"	282621
 "21151"	3357707
 "21153"	176208
 "21155"	1059755
 "21157"	1640734
 "21159"	219408
 "21161"	1280768
 "21163"	675865
 "21165"	102267
 "21167"	866259
 "21169"	210776
 "21171"	349407
 "21173"	1169063
 "21175"	288071
 "21177"	1156343
 "21179"	1884459
 "21181"	105303
 "21183"	944916
 "21185"	2172902
 "21187"	197869
 "21189"	57809
 "21191"	312241
 "21193"	1011842
 "21195"	2139817
 "21197"	271370
 "21199"	2495197
 "21201"	32170
 "21203"	354288
 "21205"	843724
 "21207"	699861
 "21209"	3684088
 "21211"	1866679
 "21213"	1095448
 "21215"	344667
 "21217"	962388
 "21219"	439386
 "21221"	320996
 "21223"	613750
 "21225"	727909
 "21227"	7287264
 "21229"	361529
 "21231"	507317
 "21233"	539885
 "21235"	1217912
 "21237"	123746
 "21239"	1265641
 "22000"	258571307
 "22001"	1694121
 "22003"	822044
 "22005"	9268625
 "22007"	492391
 "22009"	997746
 "22011"	1214742
 "22013"	923681
 "22015"	6006071
 "22017"	14545600
 "22019"	14517780
 "22021"	228753
 "22023"	1274120
 "22025"	207391
 "22027"	415064
 "22029"	656810
 "22031"	3602061
 "22033"	35564943
 "22035"	186827
 "22037"	517302
 "22039"	987521
 "22041"	541970
 "22043"	444097
 "22045"	2954102
 "22047"	2176285
 "22049"	522210
 "22051"	25538378
 "22053"	912173
 "22055"	14992625
 "22057"	4072951
 "22059"	493246
 "22061"	2377522
 "22063"	3763512
 "22065"	384925
 "22067"	666386
 "22069"	1850605
 "22071"	24754130
 "22073"	7469396
 "22075"	2759977
 "22077"	932962
 "22079"	6592923
 "22081"	1165127
 "22083"	702840
 "22085"	1222553
 "22087"	1427283
 "22089"	8258236
 "22091"	230998
 "22093"	2310899
 "22095"	2878558
 "22097"	2802044
 "22099"	1456343
 "22101"	2591892
 "22103"	13902112
 "22105"	4897538
 "22107"	138740
 "22109"	5277793
 "22111"	563369
 "22113"	1553215
 "22115"	2274121
 "22117"	1234539
 "22119"	1289704
 "22121"	2051579
 "22123"	222281
 "22125"	1200620
 "22127"	594954
 "23000"	77963313
 "23001"	5614156
 "23003"	2987405
 "23005"	26734991
 "23007"	1267871
 "23009"	2984921
 "23011"	6835571
 "23013"	2204572
 "23015"	1490520
 "23017"	2018572
 "23019"	7813558
 "23021"	722188
 "23023"	2026176
 "23025"	1974881
 "23027"	1719304
 "23029"	1240586
 "23031"	10328042
 "24000"	443929939
 "24001"	3121772
 "24003"	54917192
 "24005"	60004424
 "24009"	4997617
 "24011"	1341095
 "24013"	7178424
 "24015"	5355653
 "24017"	6754767
 "24019"	1528570
 "24021"	15600244
 "24023"	1468801
 "24025"	14879740
 "24027"	30839386
 "24029"	1057688
 "24031"	100045189
 "24033"	51134518
 "24035"	2310785
 "24037"	8554244
 "24039"	973224
 "24041"	2226975
 "24043"	7882692
 "24045"	5798674
 "24047"	3120976
 "24510"	52837291
 "25000"	641332169
 "25001"	15150695
 "25003"	7682977
 "25005"	30342482
 "25007"	1767511
 "25009"	51359386
 "25011"	3315373
 "25013"	25304527
 "25015"	8569630
 "25017"	197522150
 "25019"	1649243
 "25021"	60035566
 "25023"	29466847
 "25025"	159718533
 "25027"	49447248
 "26000"	572205845
 "26001"	240322
 "26003"	286794
 "26005"	5356947
 "26007"	1259550
 "26009"	672681
 "26011"	469599
 "26013"	326601
 "26015"	1788497
 "26017"	4158772
 "26019"	606958
 "26021"	8455695
 "26023"	1722756
 "26025"	7528043
 "26027"	1291322
 "26029"	1322572
 "26031"	703509
 "26033"	1293193
 "26035"	1177596
 "26037"	2517174
 "26039"	524725
 "26041"	1382462
 "26043"	1608488
 "26045"	5823802
 "26047"	2010148
 "26049"	17234628
 "26051"	514897
 "26053"	543605
 "26055"	5884805
 "26057"	1588777
 "26059"	1777043
 "26061"	1314688
 "26063"	1666025
 "26065"	19128164
 "26067"	1865061
 "26069"	1009636
 "26071"	365696
 "26073"	2719955
 "26075"	7651976
 "26077"	15946455
 "26079"	627961
 "26081"	48054133
 "26083"	61379
 "26085"	268225
 "26087"	2739432
 "26089"	916326
 "26091"	3450312
 "26093"	8206974
 "26095"	176871
 "26097"	520652
 "26099"	43954735
 "26101"	986546
 "26103"	3302709
 "26105"	1117428
 "26107"	1449306
 "26109"	792083
 "26111"	5836461
 "26113"	475190
 "26115"	6716820
 "26117"	1832048
 "26119"	274619
 "26121"	6795782
 "26123"	1483148
 "26125"	117962375
 "26127"	671427
 "26129"	610429
 "26131"	157022
 "26133"	843129
 "26135"	219674
 "26137"	1176083
 "26139"	16650072
 "26141"	418259
 "26143"	656269
 "26145"	9363549
 "26147"	6264869
 "26149"	2425001
 "26151"	1369557
 "26153"	338158
 "26155"	1894488
 "26157"	1504709
 "26159"	3322928
 "26161"	28604834
 "26163"	104531874
 "26165"	1442385
 "27000"	412458614
 "27001"	579183
 "27003"	17680040
 "27005"	1668694
 "27007"	2141480
 "27009"	2085672
 "27011"	276092
 "27013"	4387568
 "27015"	1561254
 "27017"	1577114
 "27019"	6432296
 "27021"	1488192
 "27023"	707434
 "27025"	1951898
 "27027"	2387963
 "27029"	374177
 "27031"	296738
 "27033"	755134
 "27035"	3281719
 "27037"	29426729
 "27039"	907545
 "27041"	2335153
 "27043"	651064
 "27045"	743718
 "27047"	1533435
 "27049"	3363947
 "27051"	314679
 "27053"	153900378
 "27055"	642056
 "27057"	884325
 "27059"	1347313
 "27061"	2428918
 "27063"	730902
 "27065"	505109
 "27067"	2508597
 "27069"	262497
 "27071"	577975
 "27073"	356951
 "27075"	646688
 "27077"	230419
 "27079"	1093269
 "27081"	503285
 "27083"	1715035
 "27085"	2069875
 "27087"	224513
 "27089"	507523
 "27091"	1263544
 "27093"	1170338
 "27095"	1002588
 "27097"	1276480
 "27099"	2111978
 "27101"	582311
 "27103"	1769458
 "27105"	1453485
 "27107"	309129
 "27109"	13150981
 "27111"	2733009
 "27113"	2247725
 "27115"	879789
 "27117"	713504
 "27119"	1675808
 "27121"	678439
 "27123"	45228239
 "27125"	199929
 "27127"	1014542
 "27129"	947680
 "27131"	3164439
 "27133"	679558
 "27135"	1531630
 "27137"	11548164
 "27139"	7895952
 "27141"	4032350
 "27143"	543225
 "27145"	10117248
 "27147"	2600478
 "27149"	716634
 "27151"	582450
 "27153"	901123
 "27155"	244444
 "27157"	842607
 "27159"	637982
 "27161"	892095
 "27163"	14741264
 "27165"	569532
 "27167"	358038
 "27169"	2645621
 "27171"	6153828
 "27173"	606450
 "28000"	127307664
 "28001"	1022410
 "28003"	1450096
 "28005"	269070
 "28007"	573776
 "28009"	296879
 "28011"	1131451
 "28013"	357419
 "28015"	123153
 "28017"	583509
 "28019"	688772
 "28021"	851560
 "28023"	298283
 "28025"	591421
 "28027"	748023
 "28029"	742715
 "28031"	747483
 "28033"	7229406
 "28035"	4020568
 "28037"	201018
 "28039"	570512
 "28041"	173485
 "28043"	1062540
 "28045"	1894160
 "28047"	10053339
 "28049"	13166968
 "28051"	312159
 "28053"	212076
 "28055"	26099
 "28057"	654866
 "28059"	8754979
 "28061"	601272
 "28063"	112822
 "28065"	191789
 "28067"	2757650
 "28069"	341839
 "28071"	2448715
 "28073"	2059741
 "28075"	3877370
 "28077"	370521
 "28079"	660542
 "28081"	5493194
 "28083"	1398838
 "28085"	1326197
 "28087"	3224055
 "28089"	7331668
 "28091"	969630
 "28093"	892490
 "28095"	1087764
 "28097"	222759
 "28099"	1189901
 "28101"	573410
 "28103"	308452
 "28105"	1990440
 "28107"	1166080
 "28109"	1274678
 "28111"	353364
 "28113"	1255917
 "28115"	1080452
 "28117"	685850
 "28119"	112244
 "28121"	7786220
 "28123"	1289703
 "28125"	121764
 "28127"	696508
 "28129"	471155
 "28131"	474662
 "28133"	775913
 "28135"	319269
 "28137"	572277
 "28139"	764659
 "28141"	636036
 "28143"	555568
 "28145"	1247090
 "28147"	319708
 "28149"	2727629
 "28151"	1587436
 "28153"	694810
 "28155"	220696
 "28157"	186959
 "28159"	578667
 "28161"	364224
 "28163"	748872
 "29000"	358571975
 "29001"	887363
 "29003"	383355
 "29005"	441296
 "29007"	1026899
 "29009"	1636941
 "29011"	423027
 "29013"	533000
 "29015"	452166
 "29017"	220777
 "29019"	11309187
 "29021"	5647905
 "29023"	1693412
 "29025"	255214
 "29027"	1864860
 "29029"	1850074
 "29031"	4443552
 "29033"	371891
 "29035"	147456
 "29037"	3247220
 "29039"	332042
 "29041"	331038
 "29043"	2144362
 "29045"	173722
 "29047"	13936780
 "29049"	464465
 "29051"	6079250
 "29053"	501901
 "29055"	751005
 "29057"	211274
 "29059"	292337
 "29061"	183877
 "29063"	360232
 "29065"	440433
 "29067"	237539
 "29069"	842147
 "29071"	5412044
 "29073"	514990
 "29075"	242876
 "29077"	19642844
 "29079"	363303
 "29081"	283238
 "29083"	857899
 "29085"	160639
 "29087"	239864
 "29089"	266090
 "29091"	1391330
 "29093"	479169
 "29095"	53240292
 "29097"	5967352
 "29099"	6145926
 "29101"	2098659
 "29103"	133816
 "29105"	1414726
 "29107"	1002515
 "29109"	994443
 "29111"	268546
 "29113"	1560760
 "29115"	448894
 "29117"	658763
 "29119"	827908
 "29121"	602836
 "29123"	329330
 "29125"	209530
 "29127"	1375481
 "29129"	122991
 "29131"	793871
 "29133"	408853
 "29135"	518901
 "29137"	222517
 "29139"	442350
 "29141"	603017
 "29143"	1169123
 "29145"	2351710
 "29147"	849494
 "29149"	214893
 "29151"	493964
 "29153"	149741
 "29155"	514026
 "29157"	1234059
 "29159"	1980527
 "29161"	1744999
 "29163"	620560
 "29165"	7691214
 "29167"	900021
 "29169"	2523072
 "29171"	136218
 "29173"	775677
 "29175"	1426036
 "29177"	562736
 "29179"	283344
 "29181"	240899
 "29183"	19921247
 "29185"	185429
 "29186"	774429
 "29187"	1980742
 "29189"	88951431
 "29195"	1058877
 "29197"	112462
 "29199"	159854
 "29201"	1862508
 "29203"	160693
 "29205"	211001
 "29207"	1329497
 "29209"	812924
 "29211"	506161
 "29213"	2720124
 "29215"	560781
 "29217"	938359
 "29219"	1024257
 "29221"	470938
 "29223"	249464
 "29225"	951196
 "29227"	52100
 "29229"	381044
 "29510"	32969578
 "30000"	58699848
 "30001"	434398
 "30003"	758401
 "30005"	213699
 "30007"	209016
 "30009"	413574
 "30011"	42992
 "30013"	4150622
 "30015"	223471
 "30017"	552917
 "30019"	134331
 "30021"	480780
 "30023"	318303
 "30025"	241175
 "30027"	601714
 "30029"	5351129
 "30031"	8088790
 "30033"	42518
 "30035"	456199
 "30037"	23761
 "30039"	123396
 "30041"	782882
 "30043"	294232
 "30045"	102333
 "30047"	1017619
 "30049"	4145809
 "30051"	284824
 "30053"	675381
 "30055"	117589
 "30057"	576299
 "30059"	73401
 "30061"	127787
 "30063"	6780085
 "30065"	278152
 "30067"	781858
 "30069"	10625
 "30071"	165087
 "30073"	219466
 "30075"	201686
 "30077"	242745
 "30079"	35959
 "30081"	1420223
 "30083"	1025502
 "30085"	529540
 "30087"	763125
 "30089"	421305
 "30091"	235219
 "30093"	1771097
 "30095"	667810
 "30097"	277081
 "30099"	240636
 "30101"	340500
 "30103"	89005
 "30105"	503178
 "30107"	94483
 "30109"	56887
 "30111"	10489257
 "31000"	146285418
 "31001"	2121978
 "31003"	727013
 "31005"	19895
 "31007"	46090
 "31009"	26772
 "31011"	534233
 "31013"	653970
 "31015"	130891
 "31017"	220273
 "31019"	3418656
 "31021"	385018
 "31023"	418576
 "31025"	1012151
 "31027"	573319
 "31029"	393890
 "31031"	308890
 "31033"	567781
 "31035"	419878
 "31037"	868571
 "31039"	862942
 "31041"	814043
 "31043"	1826183
 "31045"	322974
 "31047"	1746258
 "31049"	93148
 "31051"	403655
 "31053"	2603513
 "31055"	54013181
 "31057"	219797
 "31059"	473308
 "31061"	130394
 "31063"	128274
 "31065"	327380
 "31067"	1197990
 "31069"	88938
 "31071"	92676
 "31073"	113749
 "31075"	26773
 "31077"	137860
 "31079"	4155550
 "31081"	819138
 "31083"	213931
 "31085"	110287
 "31087"	178319
 "31089"	824511
 "31091"	30011
 "31093"	268771
 "31095"	559553
 "31097"	209520
 "31099"	415198
 "31101"	454036
 "31103"	36985
 "31105"	198352
 "31107"	648022
 "31109"	21660632
 "31111"	2675646
 "31113"	32911
 "31115"	34396
 "31117"	20474
 "31119"	2782484
 "31121"	447442
 "31123"	579922
 "31125"	162643
 "31127"	969950
 "31129"	302584
 "31131"	1716903
 "31133"	146433
 "31135"	391507
 "31137"	916804
 "31139"	398579
 "31141"	2895587
 "31143"	346613
 "31145"	608962
 "31147"	438030
 "31149"	97907
 "31151"	1223061
 "31153"	10346583
 "31155"	955663
 "31157"	1888755
 "31159"	831926
 "31161"	364739
 "31163"	151621
 "31165"	78105
 "31167"	410775
 "31169"	441041
 "31171"	34534
 "31173"	510698
 "31175"	332127
 "31177"	1524747
 "31179"	638015
 "31181"	277459
 "31183"	95244
 "31185"	960851
 "32000"	194486640
 "32001"	1426586
 "32003"	136198676
 "32005"	3152558
 "32007"	3216225
 "32009"	48963
 "32011"	1810966
 "32013"	1690434
 "32015"	1094797
 "32017"	194476
 "32019"	2140013
 "32021"	261607
 "32023"	2208807
 "32027"	464448
 "32029"	2607494
 "32031"	32864416
 "32033"	880572
 "32510"	4225603
 "33000"	99673261
 "33001"	3384009
 "33003"	2577488
 "33005"	4703465
 "33007"	1437968
 "33009"	8011258
 "33011"	32729580
 "33013"	11294253
 "33015"	26782004
 "33017"	6787359
 "33019"	1965877
 "34000"	682945922
 "34001"	15313041
 "34003"	87263307
 "34005"	32907569
 "34007"	28303076
 "34009"	6279126
 "34011"	7376321
 "34013"	58118421
 "34015"	16250179
 "34017"	52228378
 "34019"	8448632
 "34021"	43633044
 "34023"	70332453
 "34025"	41531248
 "34027"	60781062
 "34029"	25576341
 "34031"	24221220
 "34033"	6801241
 "34035"	46061238
 "34037"	5579375
 "34039"	41471551
 "34041"	4469101
 "35000"	109582792
 "35001"	42573761
 "35003"	105513
 "35005"	2225971
 "35006"	683820
 "35007"	502849
 "35009"	3430979
 "35011"	91955
 "35013"	8339710
 "35015"	7449116
 "35017"	1076679
 "35019"	173673
 "35021"	54767
 "35023"	228187
 "35025"	6962294
 "35027"	703243
 "35028"	2650272
 "35029"	955305
 "35031"	2661853
 "35033"	126808
 "35035"	3122438
 "35037"	341411
 "35039"	1192287
 "35041"	748982
 "35043"	4485519
 "35045"	5698394
 "35047"	750952
 "35049"	7636186
 "35051"	347934
 "35053"	527951
 "35055"	1125814
 "35057"	547071
 "35059"	187019
 "35061"	1874079
 "36000"	1901296535
 "36001"	37245549
 "36003"	1690394
 "36005"	48761866
 "36007"	10295945
 "36009"	3235084
 "36011"	3360766
 "36013"	5356426
 "36015"	4230830
 "36017"	2489928
 "36019"	3982803
 "36021"	2678118
 "36023"	2045276
 "36025"	2334986
 "36027"	16730913
 "36029"	65473216
 "36031"	1899347
 "36033"	2214819
 "36035"	2128919
 "36037"	2867159
 "36039"	2638945
 "36041"	250340
 "36043"	2145716
 "36045"	6972539
 "36047"	115784579
 "36049"	1217236
 "36051"	2533423
 "36053"	2582995
 "36055"	52294096
 "36057"	2102595
 "36059"	111983719
 "36061"	829744222
 "36063"	11518219
 "36065"	12532854
 "36067"	35331982
 "36069"	7174109
 "36071"	22644552
 "36073"	1687475
 "36075"	8499884
 "36077"	3039450
 "36079"	4455446
 "36081"	111216007
 "36083"	10758114
 "36085"	18989811
 "36087"	19891752
 "36089"	5591461
 "36091"	14000829
 "36093"	10790386
 "36095"	1200631
 "36097"	652639
 "36099"	1784522
 "36101"	4939406
 "36103"	113310565
 "36105"	3674518
 "36107"	2018382
 "36109"	7044555
 "36111"	8622165
 "36113"	5157243
 "36115"	2289538
 "36117"	4491966
 "36119"	95440790
 "36121"	2113891
 "36123"	1160646
 "37000"	662120757
 "37001"	7440110
 "37003"	946347
 "37005"	341415
 "37007"	891371
 "37009"	934126
 "37011"	751912
 "37013"	2273793
 "37015"	761344
 "37017"	1602149
 "37019"	5660348
 "37021"	16990979
 "37023"	2921652
 "37025"	9545277
 "37027"	2691319
 "37029"	199395
 "37031"	2973074
 "37033"	381826
 "37035"	10227800
 "37037"	2074783
 "37039"	989530
 "37041"	722124
 "37043"	317135
 "37045"	4885872
 "37047"	1745683
 "37049"	5847941
 "37051"	19909190
 "37053"	944506
 "37055"	2828658
 "37057"	5635242
 "37059"	1633495
 "37061"	2475449
 "37063"	43138332
 "37065"	1864016
 "37067"	28788153
 "37069"	1966274
 "37071"	8644205
 "37073"	239610
 "37075"	269866
 "37077"	3609197
 "37079"	505196
 "37081"	37452951
 "37083"	1643032
 "37085"	3059360
 "37087"	2200122
 "37089"	4662131
 "37091"	981395
 "37093"	1285669
 "37095"	193503
 "37097"	11449464
 "37099"	1936709
 "37101"	8303143
 "37103"	247244
 "37105"	3171755
 "37107"	3264909
 "37109"	3479630
 "37111"	1788957
 "37113"	1830975
 "37115"	496810
 "37117"	746614
 "37119"	137633915
 "37121"	622544
 "37123"	1250296
 "37125"	4335683
 "37127"	5935004
 "37129"	16289515
 "37131"	640903
 "37133"	9900984
 "37135"	10238155
 "37137"	341182
 "37139"	1806245
 "37141"	1913929
 "37143"	369073
 "37145"	1754231
 "37147"	10841765
 "37149"	621346
 "37151"	4728716
 "37153"	2100099
 "37155"	4575843
 "37157"	3392553
 "37159"	6423434
 "37161"	2117759
 "37163"	2168723
 "37165"	1337997
 "37167"	2074245
 "37169"	1402290
 "37171"	2909836
 "37173"	838518
 "37175"	2022754
 "37177"	132047
 "37179"	9687405
 "37181"	1367113
 "37183"	98018699
 "37185"	346841
 "37187"	317540
 "37189"	2618767
 "37191"	5761092
 "37193"	2708961
 "37195"	4276332
 "37197"	1045604
 "37199"	489753
 "38000"	63559623
 "38001"	114059
 "38003"	719694
 "38005"	305725
 "38007"	216878
 "38009"	442361
 "38011"	268837
 "38013"	242992
 "38015"	6224594
 "38017"	15318454
 "38019"	401345
 "38021"	353147
 "38023"	210425
 "38025"	1671437
 "38027"	139506
 "38029"	235511
 "38031"	291211
 "38033"	89535
 "38035"	4550635
 "38037"	110574
 "38039"	172344
 "38041"	107635
 "38043"	156974
 "38045"	283384
 "38047"	126600
 "38049"	333706
 "38051"	193569
 "38053"	4491971
 "38055"	983445
 "38057"	977466
 "38059"	1734801
 "38061"	2253033
 "38063"	160893
 "38065"	284345
 "38067"	551945
 "38069"	308134
 "38071"	681075
 "38073"	302068
 "38075"	170848
 "38077"	973783
 "38079"	444835
 "38081"	958876
 "38083"	40894
 "38085"	141239
 "38087"	46442
 "38089"	2567775
 "38091"	179940
 "38093"	1454800
 "38095"	189228
 "38097"	503532
 "38099"	726087
 "38101"	4134106
 "38103"	328557
 "38105"	4688370
 "39000"	756617233
 "39001"	887394
 "39003"	8962374
 "39005"	2084734
 "39007"	3538144
 "39009"	2366117
 "39011"	2617260
 "39013"	3832630
 "39015"	1033193
 "39017"	24359733
 "39019"	1350131
 "39021"	1358069
 "39023"	5162330
 "39025"	10262573
 "39027"	2622579
 "39029"	3601574
 "39031"	1346916
 "39033"	1540406
 "39035"	108965112
 "39037"	2486831
 "39039"	1918455
 "39041"	14693595
 "39043"	4539350
 "39045"	5591744
 "39047"	2657698
 "39049"	113779864
 "39051"	2382875
 "39053"	2480630
 "39055"	4969494
 "39057"	11602780
 "39059"	2279884
 "39061"	88551526
 "39063"	6137834
 "39065"	1096383
 "39067"	1271367
 "39069"	1780993
 "39071"	1682705
 "39073"	750985
 "39075"	2951192
 "39077"	2701076
 "39079"	1175850
 "39081"	4338629
 "39083"	2397664
 "39085"	12896243
 "39087"	2106173
 "39089"	8451475
 "39091"	2215367
 "39093"	12301172
 "39095"	27290183
 "39097"	2356470
 "39099"	10629515
 "39101"	3088732
 "39103"	8505806
 "39105"	457425
 "39107"	2576908
 "39109"	5139737
 "39111"	1409542
 "39113"	32805693
 "39115"	424606
 "39117"	747544
 "39119"	4204612
 "39121"	523578
 "39123"	2441477
 "39125"	706402
 "39127"	805418
 "39129"	2283770
 "39131"	1306665
 "39133"	7141900
 "39135"	1435771
 "39137"	1559692
 "39139"	5251489
 "39141"	3273854
 "39143"	3501255
 "39145"	3036134
 "39147"	2425693
 "39149"	3675238
 "39151"	18816884
 "39153"	33916975
 "39155"	7954576
 "39157"	4351644
 "39159"	5048935
 "39161"	1441555
 "39163"	348662
 "39165"	14386553
 "39167"	4014902
 "39169"	7528003
 "39171"	2056244
 "39173"	8432349
 "39175"	1233738
 "40000"	215336250
 "40001"	513174
 "40003"	186366
 "40005"	369410
 "40007"	429703
 "40009"	969322
 "40011"	484408
 "40013"	1996670
 "40015"	848457
 "40017"	4575494
 "40019"	2775337
 "40021"	1563163
 "40023"	440318
 "40025"	211405
 "40027"	9594134
 "40029"	143905
 "40031"	5479046
 "40033"	157624
 "40035"	472120
 "40037"	2202945
 "40039"	1569344
 "40041"	983469
 "40043"	346313
 "40045"	240540
 "40047"	2926730
 "40049"	1241387
 "40051"	1700253
 "40053"	417214
 "40055"	109628
 "40057"	90600
 "40059"	206758
 "40061"	357933
 "40063"	559383
 "40065"	1245100
 "40067"	111978
 "40069"	460180
 "40071"	1994291
 "40073"	1238337
 "40075"	295069
 "40077"	289083
 "40079"	1397614
 "40081"	939208
 "40083"	869874
 "40085"	510823
 "40087"	1273819
 "40089"	1293660
 "40091"	430333
 "40093"	311828
 "40095"	535981
 "40097"	2133884
 "40099"	577250
 "40101"	3160057
 "40103"	707086
 "40105"	206220
 "40107"	242291
 "40109"	67709461
 "40111"	920768
 "40113"	905100
 "40115"	1172058
 "40117"	409956
 "40119"	3728445
 "40121"	1754898
 "40123"	2186541
 "40125"	2589482
 "40127"	281817
 "40129"	163341
 "40131"	3595512
 "40133"	763828
 "40135"	897299
 "40137"	1630974
 "40139"	2092923
 "40141"	190196
 "40143"	50840821
 "40145"	1517064
 "40147"	5444979
 "40149"	264332
 "40151"	712217
 "40153"	1177717
 "41000"	272190883
 "41001"	691251
 "41003"	5242566
 "41005"	24600480
 "41007"	2207543
 "41009"	1586171
 "41011"	2910041
 "41013"	1140338
 "41015"	930511
 "41017"	12618710
 "41019"	4698437
 "41021"	349458
 "41023"	294711
 "41025"	356315
 "41027"	1496557
 "41029"	10949122
 "41031"	904226
 "41033"	3666285
 "41035"	2930676
 "41037"	359405
 "41039"	18848436
 "41041"	2137145
 "41043"	5608491
 "41045"	1360960
 "41047"	19048214
 "41049"	1481042
 "41051"	75067119
 "41053"	2438964
 "41055"	672312
 "41057"	1450665
 "41059"	3901750
 "41061"	1132415
 "41063"	432799
 "41065"	1950878
 "41067"	54257512
 "41069"	37417
 "41071"	4431961
 "42000"	844496474
 "42001"	4310644
 "42003"	109962856
 "42005"	2359269
 "42007"	7951052
 "42009"	1784112
 "42011"	22055785
 "42013"	6736868
 "42015"	4534416
 "42017"	38913900
 "42019"	11973949
 "42021"	5197201
 "42023"	255541
 "42025"	2634265
 "42027"	9750456
 "42029"	50505516
 "42031"	1409435
 "42033"	3131465
 "42035"	1795663
 "42037"	2759498
 "42039"	3316715
 "42041"	18325936
 "42043"	24359624
 "42045"	36976724
 "42047"	1709568
 "42049"	12509399
 "42051"	4853902
 "42053"	274511
 "42055"	6846649
 "42057"	717425
 "42059"	3532482
 "42061"	1429274
 "42063"	4122448
 "42065"	1712320
 "42067"	944063
 "42069"	11201107
 "42071"	33048548
 "42073"	3633557
 "42075"	6911784
 "42077"	26390816
 "42079"	16953518
 "42081"	6562069
 "42083"	2215177
 "42085"	4700180
 "42087"	1938349
 "42089"	8493417
 "42091"	89418719
 "42093"	2157280
 "42095"	17465973
 "42097"	3550008
 "42099"	1181653
 "42101"	116273595
 "42103"	1587293
 "42105"	1083397
 "42107"	5521326
 "42109"	1923907
 "42111"	2689871
 "42113"	447462
 "42115"	3397472
 "42117"	2027447
 "42119"	2118220
 "42121"	2046006
 "42123"	1588619
 "42125"	14577356
 "42127"	2103803
 "42129"	16342664
 "42131"	1886096
 "42133"	23406852
 "44000"	66570874
 "44001"	2159283
 "44003"	10409426
 "44005"	7163776
 "44007"	38996997
 "44009"	7841392
 "45000"	269802468
 "45001"	674992
 "45003"	7959021
 "45005"	344623
 "45007"	8171537
 "45009"	394031
 "45011"	554503
 "45013"	10025846
 "45015"	9667948
 "45017"	696865
 "45019"	36404507
 "45021"	2016235
 "45023"	1374746
 "45025"	1690564
 "45027"	748163
 "45029"	1077140
 "45031"	3022331
 "45033"	885738
 "45035"	4631937
 "45037"	680789
 "45039"	1198603
 "45041"	7996542
 "45043"	2959452
 "45045"	36995479
 "45047"	3429155
 "45049"	527003
 "45051"	16127514
 "45053"	1471348
 "45055"	2335126
 "45057"	4065935
 "45059"	2523657
 "45061"	407129
 "45063"	15097882
 "45065"	255373
 "45067"	694412
 "45069"	889449
 "45071"	1795534
 "45073"	4174810
 "45075"	3245694
 "45077"	4638169
 "45079"	28331126
 "45081"	554847
 "45083"	17914096
 "45085"	4791415
 "45087"	851093
 "45089"	839340
 "45091"	14670768
 "46000"	61684689
 "46003"	117471
 "46005"	977731
 "46007"	103160
 "46009"	246001
 "46011"	2388083
 "46013"	2638822
 "46015"	275786
 "46017"	89907
 "46019"	356125
 "46021"	139112
 "46023"	472314
 "46025"	275493
 "46027"	720620
 "46029"	1743600
 "46031"	107436
 "46033"	262420
 "46035"	1333389
 "46037"	332313
 "46039"	396751
 "46041"	234737
 "46043"	211673
 "46045"	328910
 "46047"	244604
 "46049"	170744
 "46051"	583399
 "46053"	180929
 "46055"	138236
 "46057"	322283
 "46059"	213993
 "46061"	175101
 "46063"	70229
 "46065"	1338218
 "46067"	435742
 "46069"	142475
 "46071"	72794
 "46073"	184515
 "46075"	69695
 "46077"	295459
 "46079"	652066
 "46081"	1370156
 "46083"	4237203
 "46085"	189318
 "46087"	311972
 "46089"	153650
 "46091"	317684
 "46093"	948319
 "46095"	41923
 "46097"	128607
 "46099"	20976786
 "46101"	382900
 "46102"	385688
 "46103"	6616708
 "46105"	148672
 "46107"	202988
 "46109"	432555
 "46111"	125671
 "46115"	485178
 "46117"	151117
 "46119"	149797
 "46121"	263584
 "46123"	269601
 "46125"	537587
 "46127"	1921217
 "46129"	297995
 "46135"	1541857
 "46137"	53622
 "47000"	427125454
 "47001"	5980587
 "47003"	2190526
 "47005"	437883
 "47007"	234150
 "47009"	6907732
 "47011"	5081024
 "47013"	1142509
 "47015"	322298
 "47017"	688602
 "47019"	1214690
 "47021"	1430929
 "47023"	416790
 "47025"	961782
 "47027"	212413
 "47029"	937971
 "47031"	3320988
 "47033"	647415
 "47035"	2059872
 "47037"	86106457
 "47039"	343264
 "47041"	740707
 "47043"	2303210
 "47045"	2065608
 "47047"	1400182
 "47049"	561411
 "47051"	1371860
 "47053"	1717202
 "47055"	1267012
 "47057"	602756
 "47059"	2751541
 "47061"	266588
 "47063"	3614066
 "47065"	29165122
 "47067"	106720
 "47069"	655361
 "47071"	1088862
 "47073"	1769151
 "47075"	680030
 "47077"	861941
 "47079"	1408240
 "47081"	572795
 "47083"	169910
 "47085"	824761
 "47087"	241454
 "47089"	2001402
 "47091"	490262
 "47093"	32116447
 "47095"	165055
 "47097"	836814
 "47099"	1224658
 "47101"	355406
 "47103"	1269030
 "47105"	2482225
 "47107"	2361915
 "47109"	622630
 "47111"	608970
 "47113"	6998522
 "47115"	919470
 "47117"	1394212
 "47119"	4866176
 "47121"	296179
 "47123"	1695210
 "47125"	6748630
 "47127"	642019
 "47129"	378482
 "47131"	1460883
 "47133"	635657
 "47135"	195320
 "47137"	168751
 "47139"	342944
 "47141"	4161053
 "47143"	1798730
 "47145"	2935824
 "47147"	2883446
 "47149"	20049270
 "47151"	578153
 "47153"	347843
 "47155"	5274873
 "47157"	72396291
 "47159"	800063
 "47161"	863361
 "47163"	8976056
 "47165"	8132559
 "47167"	1469140
 "47169"	220340
 "47171"	652475
 "47173"	399452
 "47175"	117867
 "47177"	1553904
 "47179"	7352530
 "47181"	391831
 "47183"	1490631
 "47185"	850106
 "47187"	28412623
 "47189"	6895397
 "48000"	2051768556
 "48001"	2338744
 "48003"	4037848
 "48005"	3591845
 "48007"	813931
 "48009"	329561
 "48011"	51001
 "48013"	3118965
 "48015"	1817418
 "48017"	469604
 "48019"	483029
 "48021"	2884674
 "48023"	189150
 "48025"	803089
 "48027"	19447993
 "48029"	118450810
 "48031"	514806
 "48033"	523078
 "48035"	694301
 "48037"	4058241
 "48039"	18284025
 "48041"	12002546
 "48043"	468782
 "48045"	130051
 "48047"	307427
 "48049"	1611241
 "48051"	1302834
 "48053"	2061505
 "48055"	1114943
 "48057"	3575918
 "48059"	357266
 "48061"	13225538
 "48063"	419673
 "48065"	1161887
 "48067"	1021562
 "48069"	743580
 "48071"	2712178
 "48073"	1602458
 "48075"	276647
 "48077"	260824
 "48079"	301946
 "48081"	198593
 "48083"	257815
 "48085"	81760030
 "48087"	91722
 "48089"	989279
 "48091"	8070901
 "48093"	502059
 "48095"	147104
 "48097"	2358390
 "48099"	1913648
 "48101"	81113
 "48103"	774307
 "48105"	841281
 "48107"	295678
 "48109"	2110390
 "48111"	792641
 "48113"	300392599
 "48115"	762538
 "48117"	1602409
 "48119"	116936
 "48121"	44566930
 "48123"	3877949
 "48125"	121181
 "48127"	2832999
 "48129"	165602
 "48131"	371231
 "48133"	946002
 "48135"	11399343
 "48137"	82851
 "48139"	7539483
 "48141"	37314154
 "48143"	1780375
 "48145"	464192
 "48147"	1100523
 "48149"	1941219
 "48151"	356972
 "48153"	420055
 "48155"	110829
 "48157"	33897760
 "48159"	444925
 "48161"	1164310
 "48163"	1250098
 "48165"	2285466
 "48167"	18351766
 "48169"	269151
 "48171"	1378052
 "48173"	3460454
 "48175"	380735
 "48177"	3443285
 "48179"	1097837
 "48181"	5852474
 "48183"	8026139
 "48185"	1134025
 "48187"	9234876
 "48189"	1519168
 "48191"	131137
 "48193"	323380
 "48195"	548813
 "48197"	228139
 "48199"	1473568
 "48201"	420744039
 "48203"	5195409
 "48205"	815561
 "48207"	357909
 "48209"	10025735
 "48211"	578617
 "48213"	2175498
 "48215"	25508724
 "48217"	1212741
 "48219"	1717515
 "48221"	2584467
 "48223"	1825997
 "48225"	1085051
 "48227"	9156941
 "48229"	193432
 "48231"	5410798
 "48233"	4839787
 "48235"	1152829
 "48237"	489994
 "48239"	697643
 "48241"	1115835
 "48243"	99483
 "48245"	18984347
 "48247"	207078
 "48249"	1436311
 "48251"	7652401
 "48253"	540508
 "48255"	7529186
 "48257"	4819688
 "48259"	2524305
 "48261"	336339
 "48263"	199958
 "48265"	2510660
 "48267"	168737
 "48269"	104783
 "48271"	122705
 "48273"	1240176
 "48275"	221550
 "48277"	2802184
 "48279"	805985
 "48281"	606000
 "48283"	4093310
 "48285"	1329410
 "48287"	951752
 "48289"	874976
 "48291"	2529539
 "48293"	1555546
 "48295"	564924
 "48297"	1442462
 "48299"	918753
 "48301"	5851510
 "48303"	15714220
 "48305"	392103
 "48307"	372774
 "48309"	14660950
 "48311"	1703046
 "48313"	594641
 "48315"	286778
 "48317"	11139511
 "48319"	146617
 "48321"	2566425
 "48323"	1818640
 "48325"	1289910
 "48327"	54358
 "48329"	30896404
 "48331"	718641
 "48333"	235232
 "48335"	365673
 "48337"	767757
 "48339"	35416556
 "48341"	2926815
 "48343"	618148
 "48345"	34519
 "48347"	3144570
 "48349"	1820870
 "48351"	549663
 "48353"	1133422
 "48355"	21782390
 "48357"	985413
 "48359"	375611
 "48361"	3949847
 "48363"	1091080
 "48365"	3887838
 "48367"	5498500
 "48369"	1172826
 "48371"	3285913
 "48373"	1497542
 "48375"	10077695
 "48377"	299191
 "48379"	258266
 "48381"	4647125
 "48383"	4388347
 "48385"	107577
 "48387"	359909
 "48389"	10529617
 "48391"	376853
 "48393"	489614
 "48395"	2591327
 "48397"	4837322
 "48399"	373715
 "48401"	2950142
 "48403"	306043
 "48405"	1019100
 "48407"	452690
 "48409"	3155081
 "48411"	190011
 "48413"	168188
 "48415"	1943943
 "48417"	255397
 "48419"	1588491
 "48421"	539783
 "48423"	13002122
 "48425"	1487324
 "48427"	1542972
 "48429"	477215
 "48431"	273714
 "48433"	124775
 "48435"	278881
 "48437"	556719
 "48439"	132317367
 "48441"	7951019
 "48443"	124405
 "48445"	582509
 "48447"	115650
 "48449"	2112097
 "48451"	6857912
 "48453"	150371315
 "48455"	313414
 "48457"	487544
 "48459"	963243
 "48461"	6222820
 "48463"	1011488
 "48465"	1979314
 "48467"	1369204
 "48469"	4701486
 "48471"	2531349
 "48473"	3312950
 "48475"	4018726
 "48477"	2334137
 "48479"	13581543
 "48481"	2135181
 "48483"	565385
 "48485"	6506586
 "48487"	781984
 "48489"	659444
 "48491"	29376890
 "48493"	1211679
 "48495"	1988751
 "48497"	3538145
 "48499"	1754667
 "48501"	2156163
 "48503"	992841
 "48505"	734450
 "48507"	745659
 "49000"	225340301
 "49001"	489057
 "49003"	2852645
 "49005"	6971622
 "49007"	1288398
 "49009"	132753
 "49011"	17611924
 "49013"	1173057
 "49015"	1266044
 "49017"	327291
 "49019"	722690
 "49021"	2314250
 "49023"	699353
 "49025"	482127
 "49027"	1046927
 "49029"	400576
 "49031"	71595
 "49033"	160920
 "49035"	115948610
 "49037"	542515
 "49039"	1024051
 "49041"	1285963
 "49043"	4091765
 "49045"	2545926
 "49047"	1735829
 "49049"	36166707
 "49051"	1311628
 "49053"	8338042
 "49055"	131858
 "49057"	14206181
 "50000"	37103805
 "50001"	1873294
 "50003"	1900730
 "50005"	1277348
 "50007"	13147935
 "50009"	172419
 "50011"	2308008
 "50013"	213832
 "50015"	1317241
 "50017"	938555
 "50019"	1259997
 "50021"	2903823
 "50023"	4173860
 "50025"	2576769
 "50027"	3039994
 "51000"	604957550
 "51001"	2073005
 "51007"	341292
 "51009"	897148
 "51011"	344323
 "51013"	40537293
 "51017"	273036
 "51019"	2240173
 "51021"	228192
 "51023"	1458276
 "51025"	986460
 "51027"	1041375
 "51029"	576033
 "51033"	883587
 "51036"	253601
 "51037"	318592
 "51041"	18509645
 "51043"	525837
 "51045"	114472
 "51047"	2153669
 "51049"	176375
 "51051"	481216
 "51057"	422737
 "51061"	3297269
 "51063"	418689
 "51065"	960726
 "51067"	1812697
 "51071"	688451
 "51073"	1064311
 "51075"	3557774
 "51077"	324473
 "51079"	532582
 "51083"	1310820
 "51085"	6918183
 "51087"	32916998
 "51091"	79712
 "51093"	1461560
 "51097"	173445
 "51099"	2311549
 "51101"	614937
 "51103"	525800
 "51105"	459253
 "51107"	31711698
 "51109"	2651504
 "51111"	262291
 "51113"	431151
 "51115"	244876
 "51117"	1236084
 "51119"	432470
 "51125"	642691
 "51127"	755265
 "51131"	499633
 "51133"	466089
 "51135"	597234
 "51137"	1332520
 "51139"	781997
 "51141"	499506
 "51145"	974313
 "51147"	808511
 "51155"	1527603
 "51157"	323899
 "51159"	327482
 "51167"	687930
 "51169"	464161
 "51171"	2043090
 "51173"	1165259
 "51179"	6782141
 "51181"	1360338
 "51183"	427964
 "51185"	1297626
 "51187"	2078040
 "51193"	538322
 "51197"	1647964
 "51510"	15812381
 "51550"	11855494
 "51650"	7380355
 "51700"	15093647
 "51710"	21351781
 "51740"	6880873
 "51760"	26294785
 "51770"	8149276
 "51800"	4708826
 "51810"	25144399
 "51901"	13626680
 "51903"	920983
 "51907"	5865980
 "51911"	7948662
 "51913"	1052904
 "51918"	3263835
 "51919"	137690475
 "51921"	7934377
 "51923"	1814972
 "51929"	2694374
 "51931"	6492422
 "51933"	6055543
 "51939"	3957201
 "51941"	4386717
 "51942"	24714203
 "51944"	6762936
 "51945"	1473567
 "51947"	9499442
 "51949"	900307
 "51951"	7335028
 "51953"	3895060
 "51955"	1629412
 "51958"	3105437
 "53000"	677489451
 "53001"	1024886
 "53003"	798248
 "53005"	13335494
 "53007"	5279018
 "53009"	2996092
 "53011"	26301405
 "53013"	468575
 "53015"	6047768
 "53017"	2124578
 "53019"	239371
 "53021"	4501356
 "53023"	193683
 "53025"	6303546
 "53027"	2987855
 "53029"	3897482
 "53031"	1250588
 "53033"	377060810
 "53035"	14373182
 "53037"	2137584
 "53039"	1809037
 "53041"	3930937
 "53043"	581863
 "53045"	1866421
 "53047"	1589916
 "53049"	851851
 "53051"	579290
 "53053"	50955340
 "53055"	941546
 "53057"	7659302
 "53059"	325675
 "53061"	51950334
 "53063"	30891128
 "53065"	1287480
 "53067"	16245024
 "53069"	107583
 "53071"	3642288
 "53073"	16036428
 "53075"	3051659
 "53077"	11864827
 "54000"	85434221
 "54001"	443661
 "54003"	4513174
 "54005"	675946
 "54007"	361044
 "54009"	1363927
 "54011"	5375074
 "54013"	125392
 "54015"	143459
 "54017"	758122
 "54019"	1152776
 "54021"	197288
 "54023"	523658
 "54025"	1282487
 "54027"	484630
 "54029"	1263933
 "54031"	695596
 "54033"	4825520
 "54035"	969753
 "54037"	2032597
 "54039"	11490361
 "54041"	602434
 "54043"	273959
 "54045"	1391094
 "54047"	581003
 "54049"	2285049
 "54051"	3269705
 "54053"	873410
 "54055"	1895968
 "54057"	903583
 "54059"	516825
 "54061"	7738554
 "54063"	223681
 "54065"	359766
 "54067"	717569
 "54069"	4137031
 "54071"	172274
 "54073"	591069
 "54075"	313903
 "54077"	858980
 "54079"	3106759
 "54081"	3410286
 "54083"	1019359
 "54085"	714016
 "54087"	318746
 "54089"	242386
 "54091"	649255
 "54093"	341637
 "54095"	1379914
 "54097"	841902
 "54099"	1119910
 "54101"	167177
 "54103"	1064955
 "54105"	95821
 "54107"	3904517
 "54109"	673327
 "55000"	368611259
 "55001"	650172
 "55003"	824706
 "55005"	2449166
 "55007"	500893
 "55009"	19997017
 "55011"	602445
 "55013"	637786
 "55015"	1870913
 "55017"	3238002
 "55019"	1537296
 "55021"	3237035
 "55023"	809326
 "55025"	50020775
 "55027"	4235459
 "55029"	1534454
 "55031"	2133418
 "55033"	2184456
 "55035"	7070771
 "55037"	151384
 "55039"	5817790
 "55041"	343184
 "55043"	2587467
 "55045"	2062053
 "55047"	697859
 "55049"	1316851
 "55051"	205063
 "55053"	885729
 "55055"	4045505
 "55057"	1043599
 "55059"	8557656
 "55061"	832786
 "55063"	8652869
 "55065"	704114
 "55067"	842960
 "55069"	1531328
 "55071"	4433308
 "55073"	9719367
 "55075"	2186762
 "55077"	473935
 "55078"	189873
 "55079"	64131960
 "55081"	2491936
 "55083"	1161265
 "55085"	1943584
 "55087"	14331274
 "55089"	5876144
 "55091"	339491
 "55093"	1317798
 "55095"	1829420
 "55097"	4534029
 "55099"	682551
 "55101"	9100374
 "55103"	840712
 "55105"	8530214
 "55107"	681166
 "55109"	4765171
 "55111"	4376177
 "55113"	800611
 "55115"	1466082
 "55117"	7747640
 "55119"	966028
 "55121"	1474043
 "55123"	1120147
 "55125"	999332
 "55127"	5185311
 "55129"	674772
 "55131"	7601632
 "55133"	33869913
 "55135"	2181785
 "55137"	742521
 "55139"	11586606
 "55141"	4446038
 "56000"	41510213
 "56001"	1718189
 "56003"	535350
 "56005"	5290570
 "56007"	1470964
 "56009"	1537644
 "56011"	344187
 "56013"	1739407
 "56015"	519546
 "56017"	322224
 "56019"	456852
 "56021"	6608922
 "56023"	1039883
 "56025"	5887565
 "56027"	132277
 "56029"	1620713
 "56031"	613161
 "56033"	1619684
 "56035"	1425984
 "56037"	3516704
 "56039"	3522800
 "56041"	875026
 "56043"	410209
 "56045"	302354
 "91000"	1221038597
 "92000"	4107499370
 "93000"	3056083317
 "94000"	1450801115
 "95000"	5022472568
 "96000"	2796714269
 "97000"	858192629
 "98000"	4665853136 /;

set	latlon /lat,lon/;

table loc(*,latlon) 

		lon		lat
01059	-87.843283	34.44238135
13111	-84.31929617	34.86412558
19109	-94.20689787	43.20413984
40115	-94.81058917	36.83587796
42115	-75.80090451	41.82127676
40053	-97.78493404	36.79651364
31029	-101.6979407	40.52371008
29213	-93.04127586	36.65473646
32510	-119.7473502	39.15108405
12049	-81.80953792	27.49319733
05023	-92.02725586	35.53853919
48017	-102.8298267	34.06860316
49037	-109.8043936	37.62607487
31143	-97.56825226	41.18687055
42075	-76.45759104	40.36716938
35028	-106.3065081	35.86926339
40137	-97.85148899	34.48542286
40081	-96.88123961	35.7027284
19031	-91.13246684	41.77233777
19069	-93.26256925	42.73270384
20151	-98.73915959	37.6478469
28099	-89.11732685	32.7532893
29167	-93.40034649	37.61649452
27101	-95.76328482	44.02216709
29121	-92.56453089	39.83049768
55039	-88.48885325	43.75354908
47169	-86.15630295	36.39236244
51683	-77.48515474	38.7478445
48329	-102.0315682	31.86904128
48251	-97.36618817	32.3788142
48171	-98.94676915	30.31824095
55137	-89.24316913	44.11328215
04015	-113.7581706	35.70456821
12015	-81.91185513	26.90579274
20039	-100.4593928	39.78469039
21057	-85.38857248	36.78661047
46097	-97.60992207	44.02197882
41033	-123.5552595	42.36551155
41015	-124.1560919	42.45776177
35006	-107.9992972	34.91240949
26001	-83.59385271	44.68477825
06105	-123.1126773	40.65059444
01103	-86.85325062	34.45331009
31159	-97.13966029	40.8724014
40153	-99.26427063	36.42251383
39063	-83.66630827	41.00178146
36057	-74.43985937	42.90217659
18139	-85.46543335	39.62002576
29139	-91.47020839	38.94128519
20097	-99.28576492	37.55841651
28117	-88.51976883	34.61811436
17189	-89.41050166	38.35241923
72029	-65.88710242	18.33030521
31171	-100.5556632	41.91358968
29017	-90.02562128	37.3219182
13149	-85.12848262	33.296853
48085	-96.57266803	33.18822716
48107	-101.3000364	33.61431553
48081	-100.5295971	31.88933528
21171	-85.71679611	36.71217333
12003	-82.28452499	30.3309289
20089	-98.21822331	39.7847206
26017	-83.99005144	43.70716549
37153	-79.74711644	35.00590629
29023	-90.40672985	36.71638784
27105	-95.75326093	43.67428858
23001	-70.20524042	44.16543634
51735	-76.35566972	37.1307115
01013	-86.68040924	31.75252432
37003	-81.17692946	35.92074753
37063	-78.87606872	36.03605321
38027	-98.90182925	47.71748723
36093	-74.05833636	42.81832249
27079	-93.72984216	44.37144158
29055	-91.30516204	37.97649081
28107	-89.95079634	34.3639856
72093	-66.94265627	18.1724996
72075	-66.49544792	18.05157356
19027	-94.86032705	42.03617207
19075	-92.7914653	42.40195716
28131	-89.11764244	30.7900413
46003	-98.56175096	43.7180875
29173	-91.52194283	39.5275593
48433	-100.2538401	33.17906744
04005	-111.7705493	35.83875351
08081	-108.2075581	40.61858161
18141	-86.29001543	41.61670349
05095	-91.20394825	34.67772323
39037	-84.61945793	40.13381861
28003	-88.57997736	34.88083218
02105	-135.6386611	58.28575804
12067	-83.18086561	29.98555842
02290	-151.3897031	65.50922918
51590	-79.40912354	36.58309677
40063	-96.25062134	35.04854478
38047	-99.47712748	46.45733694
39077	-82.59842269	41.14651716
39021	-83.76966912	40.13766698
31053	-96.6539044	41.57781563
31097	-96.26520163	40.39252282
19165	-95.31015553	41.6850066
19197	-93.73515113	42.73305373
21061	-86.23847919	37.20904677
26057	-84.60482908	43.29296993
72045	-66.22191082	18.223828
56025	-106.7988764	42.96194049
20163	-99.3248686	39.35022485
48153	-101.3031546	34.07227468
48227	-101.4356444	32.30621324
48319	-99.22629725	30.7177995
51600	-77.29836489	38.8534472
51530	-79.35459481	37.73052263
72119	-65.81320794	18.34790658
12099	-80.46503899	26.64741122
18171	-87.35336964	40.34704622
20187	-101.7842716	37.56304856
02180	-164.0315808	64.91040617
39085	-81.23712921	41.69689265
37181	-78.40836693	36.36465914
30089	-115.1333094	47.67490166
28039	-88.64422567	30.86260363
31083	-99.40436605	40.17656663
02122	-151.5611779	60.2537748
13003	-82.88008089	31.29704319
51081	-77.55962422	36.67571583
55065	-90.13189524	42.66021077
39121	-81.45612561	39.7660752
27057	-94.91640615	47.10785166
18101	-86.80307723	38.7079435
15009	-156.5692176	20.86402572
19025	-94.64046046	42.38521079
19187	-94.18176099	42.42794934
20067	-101.3079758	37.56227336
28129	-89.50664426	32.01792861
17005	-89.43566372	38.88688243
72153	-66.8582991	18.08109137
29059	-93.02340823	37.68065861
31183	-98.52795068	41.91485543
26075	-84.42251355	42.24852059
48269	-100.2558057	33.61643847
48497	-97.65458625	33.215766
51678	-79.44575305	37.78179822
36015	-76.75989461	42.14122122
48279	-102.3516289	34.06859623
51790	-79.05960219	38.15909322
01003	-87.72274477	30.72782468
05113	-94.2279123	34.48595315
06079	-120.4042917	35.38707354
18047	-85.06053013	39.41429175
21191	-84.36004407	38.69570469
40129	-99.69538847	35.68852706
38017	-97.24822334	46.93292237
37157	-79.77527984	36.39621434
35015	-104.3041733	32.47155056
27109	-92.40209709	44.00380771
06089	-122.0409443	40.76391106
18013	-86.22810056	39.19645662
05065	-91.91279069	36.09526565
55075	-88.03335785	45.38289899
31141	-97.52073009	41.57115154
31005	-101.6959559	41.56896142
35057	-105.8505392	34.64043207
26129	-84.12710722	44.33486043
19087	-91.54434433	40.98760854
19175	-94.24234847	41.0277278
27007	-94.93765473	47.97364569
27085	-94.27237288	44.82372142
72054	-66.5598922	18.37330319
31081	-98.02280046	40.87318318
19067	-92.78940097	43.0600053
20205	-95.74323255	37.55937174
55035	-91.28609183	44.726614
48135	-102.5429428	31.86898877
48507	-99.76049166	28.86623446
72099	-67.08090202	18.37783653
46043	-98.36606932	43.38705519
08125	-102.4246098	40.00284508
13119	-83.2291908	34.37559112
20189	-101.3119048	37.19230822
21083	-88.65114084	36.72303717
42001	-77.21807609	39.87146641
46013	-98.35163367	45.58993475
28095	-88.48037059	33.8922846
29209	-93.45602697	36.74710976
27043	-93.94781493	43.67387282
02050	-159.8255997	60.91342739
19137	-95.15642896	41.03018714
01021	-86.71887934	32.84771004
31009	-99.97677845	41.91311716
39113	-84.29037841	39.75442102
39047	-83.4560853	39.56023827
40073	-97.94153042	35.94535722
18117	-86.49522904	38.5412136
19147	-94.67824621	43.08193849
19047	-95.3819718	42.03718237
17107	-89.36775244	40.12467469
26035	-84.84810751	43.9879198
18081	-86.10174496	39.4899568
27083	-95.83918761	44.41338502
26165	-85.5781774	44.33841768
55027	-88.70770995	43.41581374
18137	-85.2624907	39.10311351
18041	-85.17841116	39.63983379
72115	-66.92632992	18.44045509
48021	-97.31201625	30.10367452
51580	-79.98671944	37.77830014
51540	-78.48233004	38.03742163
48149	-96.91986981	29.87663549
48159	-95.21903806	33.17532732
46045	-99.21540939	45.41847898
04012	-113.981207	33.7291609
16009	-116.6586207	47.21772961
24510	-76.61440436	39.30522045
42105	-77.89566563	41.74480517
47069	-88.99308826	35.2067611
26023	-85.05923475	41.91588904
13173	-83.06330638	31.03799605
19081	-93.73454884	43.08178477
13169	-83.56057299	33.0254599
36109	-76.47381763	42.45222263
36053	-75.66993538	42.91279676
19019	-91.83745828	42.47108244
19123	-92.64083907	41.33521502
20031	-95.73407587	38.23677253
19125	-93.09934783	41.33445101
17095	-90.2133034	40.93148779
29211	-93.11159068	40.21033053
27095	-93.62993103	45.9373852
12119	-82.08128977	28.70520781
19179	-92.40954728	41.03064984
16085	-115.5662454	44.76650867
28035	-89.25794407	31.18899065
17079	-88.15377894	39.01061641
46073	-98.62965972	44.06637798
55141	-90.0416185	44.45535331
48233	-101.3546643	35.84006574
72059	-66.79209227	18.03985751
48265	-99.34928454	30.06116361
38031	-98.88279923	47.4571084
48425	-97.77458843	32.22235362
48205	-102.6029352	35.84008345
48079	-102.8285179	33.60426094
48131	-98.50873333	27.68142846
48145	-96.93634455	31.25354356
27019	-93.8027205	44.82089558
46125	-97.14865776	43.3109081
28081	-88.68047663	34.28973933
31149	-99.44982378	42.42142393
51595	-77.53622483	36.69543863
18045	-87.24192118	40.12120145
72069	-65.81103116	18.14521821
38013	-102.5181759	48.79096757
48375	-101.893964	35.40133773
18099	-86.26180055	41.3248735
47015	-86.06179619	35.80842943
18113	-85.41741162	41.39835527
48069	-102.2617081	34.53004051
37007	-80.10243931	34.97378348
19135	-92.8690667	41.02988815
06005	-120.651296	38.44638702
16059	-113.9335998	44.9436279
19141	-95.62474725	43.0836202
16075	-116.7604309	44.00714137
17115	-88.96174804	39.85999062
17117	-89.92459485	39.26136043
37195	-77.9189122	35.70531169
17123	-89.34481931	41.03327407
19003	-94.69932645	41.02903567
54077	-79.6682145	39.46929522
19011	-92.06463573	42.08011739
47023	-88.61425832	35.42206909
56027	-104.4755961	43.05616954
51089	-79.87418576	36.68267428
55131	-88.23041319	43.36887792
30069	-108.2504732	47.11768458
27117	-96.258643	44.02300689
51099	-77.15723124	38.27358126
27031	-90.53150846	47.90304185
42047	-78.64916765	41.42548728
27147	-93.22627088	44.02240351
27153	-94.89728962	46.07014445
29057	-93.8503345	37.431814
42053	-79.23591856	41.51230258
47001	-84.19904346	36.11862903
16039	-115.4691486	43.35417471
20057	-99.88814767	37.69182131
20093	-101.3203923	38.00024973
13247	-84.02657025	33.65414105
31045	-103.1354423	42.72007965
41047	-122.5849114	44.90322354
48111	-102.6021107	36.27789187
18145	-85.79146519	39.52312646
42079	-75.98893638	41.17686973
29117	-93.54864835	39.78202789
29125	-91.92492582	38.16167922
27161	-93.58720505	44.0220714
01111	-85.45918107	33.29354361
26143	-84.61141537	44.33547916
36005	-73.8615688	40.85091824
31085	-101.0616334	40.52447865
31119	-97.60078361	41.9166434
38021	-98.50488391	46.11017237
29109	-93.83291444	37.10627971
26015	-85.30834519	42.59513984
55059	-88.04209555	42.57659172
29141	-92.88597122	38.42350791
26073	-84.84664923	43.64060976
05031	-90.63270647	35.8310138
02195	-132.9333517	57.11988808
02275	-132.0310434	56.32537949
31167	-97.19394708	41.9169835
35047	-104.8156292	35.48004639
42113	-76.51238042	41.44598276
26109	-87.55660994	45.58036988
39083	-82.42287375	40.39902351
39089	-82.48290477	40.09170112
38073	-97.65742504	46.45621782
31011	-98.06703102	41.7067951
38103	-99.66092922	47.58750012
31069	-102.3353283	41.61911486
48191	-100.6813647	34.53073368
48193	-98.11083887	31.70470573
38043	-99.78013842	46.98013909
19033	-93.2612239	43.08177563
21033	-87.86831993	37.14556161
46025	-97.72949102	44.8584651
46039	-96.66802862	44.76015949
46067	-97.75456287	43.33466314
46079	-97.12926365	44.02193107
42021	-78.71388554	40.49518786
48023	-99.21352901	33.61640794
46047	-103.5274481	43.23917478
46061	-97.78704306	43.67458361
45037	-81.9661657	33.77224819
46099	-96.7914546	43.67413367
53001	-118.5603559	46.98352425
42037	-76.4051503	41.04903639
29085	-93.32051495	37.94153217
55069	-89.73474025	45.33724242
51003	-78.55661903	38.02273165
31003	-98.06660249	42.17696571
55089	-87.95138777	43.38375913
29009	-93.82898627	36.70980207
55097	-89.50154548	44.47561378
48047	-98.21866528	27.03154713
55033	-91.89653391	44.94674851
55117	-87.94566398	43.72108736
37151	-79.8058818	35.71023333
20199	-101.7637347	38.91690628
20011	-94.84924767	37.85500237
48093	-98.55874953	31.94854859
48103	-102.5151699	31.4287137
26037	-84.60138451	42.9439517
17029	-88.22141023	39.52086003
19077	-94.50111014	41.68378965
17037	-88.76979995	41.8933691
17041	-88.21756136	39.7695478
20115	-97.09712874	38.35899873
21129	-83.71573518	37.59456493
48123	-97.35694033	29.08147376
26077	-85.53044157	42.24536002
21157	-88.32927113	36.88327592
26081	-85.54918115	43.03204611
21173	-83.91291351	38.03256472
26107	-85.32464875	43.64070731
26117	-85.15230226	43.31058414
21181	-84.01542795	38.33536589
27047	-93.3488462	43.67383179
26133	-85.32556471	43.98998373
17049	-88.58969703	39.05935691
17053	-88.22313426	40.59686492
17047	-88.05369238	38.41619684
21233	-87.68319621	37.51850288
48303	-101.8204789	33.61008596
40043	-99.00647121	35.98768882
48349	-96.47280759	32.04696933
19035	-95.62389402	42.73538914
19017	-92.31795937	42.77461496
27093	-94.52871063	45.12332877
48219	-102.3431676	33.60771256
40105	-95.61735986	36.79844119
39003	-84.10584177	40.77151716
27059	-93.29470209	45.56125565
48413	-100.5384877	30.89734895
27165	-94.61413846	43.97823903
48429	-98.83631615	32.73553157
36021	-73.63186276	42.25016297
34023	-74.41108832	40.43949114
27121	-95.44454861	45.58611957
48345	-100.779722	34.07408766
29115	-93.10705251	39.870461
06071	-116.1783784	34.84157876
13175	-82.92233434	32.46355824
13133	-83.16678441	33.57887215
05123	-90.74840472	35.02180511
55085	-89.52161421	45.70521979
55113	-91.14489019	45.87995292
02261	-144.5019516	61.54964404
46035	-98.14543668	43.67475843
27137	-92.46951183	47.60334656
12041	-82.80043459	29.72600841
39133	-81.19736816	41.16790847
29061	-93.98514508	39.96169076
29079	-93.56516333	40.1140924
48049	-98.99881071	31.77417703
48209	-98.03105783	30.05810528
48235	-100.982439	31.30375559
48281	-98.2416756	31.19624807
53047	-119.7406032	48.54862984
13017	-83.22027638	31.75972075
13277	-83.52652261	31.45751029
13065	-82.7064204	30.91504263
51570	-77.39716266	37.26480119
37081	-79.78852575	36.07964464
29177	-93.98990821	39.35287295
51640	-80.91646065	36.66735897
51670	-77.2969381	37.29122918
51685	-77.44401094	38.7704423
20173	-97.46083703	37.68448116
06053	-121.2387503	36.21711865
19013	-92.30867416	42.47009403
20023	-101.7318625	39.78580547
12027	-81.80959835	27.18691656
17137	-90.20121837	39.71580417
08045	-107.9036205	39.59941978
48237	-98.17283469	33.23377248
29229	-92.4694931	37.27078998
12111	-80.47111892	27.377528
20099	-95.29765463	37.19127872
40041	-94.80256963	36.4089821
01087	-85.69260703	32.38585029
08057	-106.3427076	40.66623861
01061	-85.83932953	31.09486905
13023	-83.32769512	32.43444176
20121	-94.83822279	38.56363954
17109	-90.67775541	40.45674722
48283	-99.0992434	28.34445432
13029	-81.44364706	32.0140721
20109	-101.148475	38.91735806
17121	-88.91900564	38.64962591
48311	-98.567849	28.35261097
39119	-81.94452332	39.96581387
08095	-102.3573987	40.59394842
20193	-101.0553705	39.35107575
48367	-97.80496943	32.77760907
08103	-108.2172628	39.97993245
08105	-106.3829289	37.58223621
39137	-84.13168547	41.02216769
17175	-89.79757636	41.09327074
39139	-82.53676639	40.77482478
48393	-100.813175	35.83809685
48399	-99.97616148	31.8314342
21227	-86.42358976	36.9932296
48421	-101.8933684	36.27765456
13109	-81.88687929	32.1569194
19107	-92.1785067	41.33649833
17199	-88.93009646	37.73040742
12011	-80.48723143	26.15220703
13171	-84.13960587	33.07619286
39033	-82.91997484	40.85061678
13195	-83.20833143	34.12798628
39073	-82.47907934	39.49712923
39027	-83.80825529	39.41489655
39031	-81.91980212	40.30215268
48011	-101.3574874	34.96507426
39041	-83.00450275	40.27841348
48031	-98.3999852	30.26640707
51720	-82.62648895	36.9310873
51830	-76.70721344	37.26927809
29067	-92.49898814	36.93253661
48317	-101.9513518	32.30600051
29093	-90.77398853	37.5553541
48301	-103.5798367	31.8491553
48033	-101.4316509	32.74363984
40031	-98.47164344	34.6620099
08025	-103.7838298	38.32685938
29203	-91.39993659	37.15713986
48431	-101.0500746	31.82781912
48461	-102.0428877	31.36864453
48495	-103.048449	31.85000039
48253	-99.87871324	32.7400927
48441	-99.88996827	32.30175703
08119	-105.1619203	38.88227296
48335	-100.9212058	32.30623474
48059	-99.37326312	32.29760619
40083	-97.44308101	35.91913897
40001	-94.65863245	35.88406262
36043	-74.96255405	43.41936241
48467	-95.83674215	32.56379892
40109	-97.4075036	35.55141319
48213	-95.85377795	32.21224151
36007	-75.8198592	42.16037158
40005	-96.03794859	34.37367259
48471	-95.57247928	30.73883544
40029	-96.29798747	34.58840127
48185	-95.98558082	30.5437066
40127	-95.37595261	34.41635817
01091	-87.78920946	32.24794915
01075	-88.09715315	33.77909349
05003	-91.76814114	33.19120398
29063	-94.40452876	39.89285656
51750	-80.55838396	37.12313924
54047	-81.65416089	37.378572
31099	-98.94803186	40.50675437
54033	-80.37983086	39.28363307
29049	-94.40468366	39.60124265
54007	-80.71925498	38.70024736
72007	-66.12607813	18.25129795
72027	-66.86018176	18.41919751
72039	-66.51671207	18.29014773
28031	-89.55267845	31.6331285
50015	-72.641331	44.60594136
28069	-88.64097868	32.75459457
55127	-88.54158045	42.66848551
32027	-118.4047657	40.43952288
32021	-118.4346446	38.53880917
72137	-66.21551546	18.4313626
72139	-65.9995301	18.33693881
39015	-83.86741596	38.93410315
27017	-92.67716012	46.592321
12019	-81.85783045	29.98317912
28015	-89.92031051	33.44884455
38101	-101.541865	48.22179884
02188	-159.724644	67.05555844
38087	-103.4602876	46.4473194
20185	-98.71763136	38.03102509
41021	-120.210458	45.37780558
26051	-84.38860114	43.99062122
38049	-100.6362783	48.23439818
19177	-91.95043301	40.75308722
20105	-98.20749	39.04547506
13021	-83.69682554	32.80691473
26125	-83.38594391	42.66090645
19009	-94.90581859	41.6844628
18015	-86.5635188	40.58306044
26135	-84.12938765	44.68170135
47047	-89.41493045	35.19709994
20167	-98.76247878	38.91467637
72125	-67.03910309	18.11192588
26087	-83.22153148	43.09052506
51550	-76.30244008	36.67787032
72009	-66.26454838	18.13045854
60050	-170.7703365	-14.3247379
18179	-85.22119115	40.72931843
20085	-95.79433878	39.41641542
02240	-143.2069204	63.87695823
19171	-92.53266945	42.07991767
06103	-122.2338547	40.12559985
18103	-86.04523681	40.76954805
06109	-119.9551317	38.02748982
18133	-86.84503425	39.66633516
49043	-110.9558542	40.86838131
17141	-89.32021067	42.04257451
06057	-120.7682923	39.30150048
20027	-97.16512523	39.34944765
55077	-89.39896563	43.81971333
55115	-88.76489325	44.78886999
16049	-115.4671964	45.84388002
16061	-116.4267621	46.2366682
20101	-100.4660754	38.48119447
38079	-99.84096449	48.77247566
20143	-97.65020313	39.13237408
22007	-91.06263132	29.90081675
36049	-75.44886742	43.78465035
37029	-76.20583468	36.38675278
17101	-87.72698819	38.72048612
20119	-100.3655617	37.23826363
42007	-80.34928676	40.68241496
30081	-114.120145	46.08166896
31133	-96.23706382	40.13139323
31095	-97.14261379	40.17580816
13009	-83.24970322	33.06940962
02130	-130.9369511	55.58672276
48501	-102.8279472	33.1730387
31163	-98.97588642	41.22045983
31037	-97.086359	41.57404386
42025	-75.70851105	40.91846484
39149	-84.20440063	40.33212183
40037	-96.37089402	35.90233119
18057	-86.05184193	40.07229856
19091	-94.20722537	42.7764426
20127	-96.64983521	38.68742242
20195	-99.87284448	38.91467218
19015	-93.93139995	42.0366177
28077	-90.10693379	31.54996744
17135	-89.4790156	39.23097041
29103	-92.14789043	40.12754125
18085	-85.86064998	41.24435723
72011	-67.12171471	18.28872155
26021	-86.41252941	41.95468812
26067	-85.07413319	42.94502238
48129	-100.8140093	34.96517499
46087	-97.36854569	43.67426214
48297	-98.12498408	28.35137771
47113	-88.83867386	35.60806385
39045	-82.63064275	39.75164711
38083	-100.3455585	47.5754264
39023	-83.78354054	39.91660044
04023	-110.8466869	31.52598116
13177	-84.14092773	31.77942972
20175	-100.850601	37.19327656
22017	-93.88236667	32.5802177
23009	-68.35862848	44.64373173
24011	-75.83180727	38.87198968
39039	-84.49071987	41.3239854
30025	-104.417515	46.3343054
27063	-95.15400031	43.67418723
28123	-89.53789439	32.4067041
08003	-105.788359	37.57261807
12091	-86.59219666	30.69101554
12117	-81.23634611	28.71682625
13083	-85.50458952	34.85458429
28005	-90.80453378	31.17425244
28023	-88.68928948	32.04139674
46049	-99.14535601	45.07082625
13131	-84.23475065	30.87476853
72117	-67.23189285	18.33498528
27111	-95.70748857	46.4090783
28057	-88.36140611	34.27995113
17059	-88.23082016	37.76253711
21141	-86.87901935	36.8597188
44001	-71.28385194	41.71169465
26059	-84.59305475	41.88768696
08041	-104.5257538	38.83242336
01057	-87.73924331	33.72117266
54089	-80.85840283	37.65596695
31139	-97.60122773	42.26434853
29169	-92.20749866	37.82458658
39169	-81.88780787	40.82926705
26111	-84.38804837	43.64674881
19113	-91.59809485	42.07923082
16015	-115.730321	43.98909247
27041	-95.45422901	45.93372693
17055	-88.9239703	37.99202257
29215	-91.96523434	37.3167567
29025	-93.98309623	39.65668445
55081	-90.61820195	43.94576215
55025	-89.41786325	43.06746565
47131	-89.1487146	36.35824874
13143	-85.21085788	33.79399282
20191	-97.476759	37.2369258
22027	-92.99565971	32.82277025
30051	-111.0252038	48.56122467
28103	-88.56962273	33.1101406
28075	-88.66247435	32.40429857
13227	-84.46567239	34.46423209
48117	-102.6052738	34.96515022
42109	-77.06984318	40.76993359
40103	-97.23050054	36.3884853
20111	-96.15280427	38.45580918
17093	-88.42879892	41.59088826
26045	-84.83740035	42.59599185
17039	-88.90408529	40.17434051
29001	-92.6007527	40.19054871
19029	-94.92806328	41.33152905
28115	-89.03719509	34.22521097
48463	-99.76229172	29.35739637
51690	-79.86345947	36.68207476
40015	-98.37502407	35.17437642
27131	-93.2965986	44.35432778
27151	-95.68142474	45.28288933
26085	-85.80209274	43.99041242
55129	-91.79131495	45.89909725
18003	-85.06652248	41.0912565
31001	-98.50117804	40.5244942
60030	-168.1521132	-14.54212416
20203	-101.3471509	38.48178252
55087	-88.46565023	44.41578887
48435	-100.5382117	30.4985468
48127	-99.75646833	28.42276169
48139	-96.79470819	32.34880007
48437	-101.7349174	34.53028891
36017	-75.61144344	42.49352629
38041	-102.4607133	46.43276791
39071	-83.60078719	39.18468334
13275	-83.91853341	30.86359281
18007	-87.31082597	40.60631635
20147	-99.34669372	39.78462799
26095	-85.54389048	46.4704998
46101	-96.67091097	44.02224521
37041	-76.60802425	36.14854015
39171	-84.58816167	41.56027968
40147	-95.90449238	36.71527849
37169	-80.23912302	36.40186627
29091	-91.88649829	36.77371722
33009	-71.82064764	43.94073661
26127	-86.26734566	43.64097781
08047	-105.5221395	39.85721134
05141	-92.51610324	35.58054667
53007	-120.6188281	47.86921949
54069	-80.61888538	40.09682683
31185	-97.59710186	40.87272618
31019	-99.07510068	40.85504881
39143	-83.14419942	41.35730372
40039	-99.0014123	35.63856198
18095	-85.71947571	40.16126825
20133	-95.30682401	37.5582728
20083	-99.89821264	38.08784693
28161	-89.70745642	34.02831011
28159	-89.03430894	33.0883872
29205	-92.07658198	39.7979959
21073	-84.87704049	38.23894371
72105	-66.25362073	18.28716348
31135	-101.6502998	40.85082266
18023	-86.475326	40.30214562
19049	-94.03970701	41.68489264
29119	-94.34823345	36.6286562
46005	-98.27883711	44.41467039
46115	-98.34623659	44.93824835
55047	-89.04505121	43.80037233
51775	-80.05325441	37.28655753
51630	-77.48619454	38.29892214
38039	-98.23703207	47.4570984
01081	-85.35522451	32.60106116
04007	-110.8119677	33.79996932
06061	-120.717846	39.06347097
06017	-120.5247066	38.77888901
02164	-156.1888735	58.63664843
02150	-153.7750279	57.66653702
05111	-90.66282507	35.57408383
13097	-84.76851394	33.7021135
02230	-135.3374592	59.55833766
01133	-87.37341176	34.14959585
48483	-100.2699514	35.40114335
37069	-78.2853416	36.08251637
39159	-83.37130174	40.29926661
38045	-98.53552136	46.45686514
39165	-84.16728624	39.42735056
39065	-83.65939867	40.66129428
13139	-83.819838	34.31734176
18067	-86.1167092	40.48362355
20009	-98.75632156	38.478934
28037	-90.89833873	31.47675129
17011	-89.52841534	41.40406966
27039	-92.86236786	44.02229546
55053	-90.80515334	44.31927005
26025	-85.00508394	42.24636617
20135	-99.91547333	38.47974157
60040	-171.0781094	-11.05493121
20015	-96.83878537	37.78134351
46069	-99.48692012	44.54709825
46017	-99.20485567	44.07640555
48065	-101.3542669	35.40365929
47053	-88.93264081	35.99666265
48173	-101.5207776	31.86942909
48295	-100.2732972	36.27778375
48381	-101.8971322	34.96585996
46037	-97.60737593	45.36728275
01107	-88.08923504	33.28058298
17197	-87.97829555	41.44485087
19063	-94.67861391	43.37782281
19185	-93.32744042	40.73965649
23003	-68.5987449	46.65913528
38095	-99.24564463	48.68566015
38009	-100.8333086	48.792102
37149	-82.17008141	35.27959223
27091	-94.55099667	43.67430059
32013	-118.1118195	41.4063802
13243	-84.75379101	31.7621807
13283	-82.56783271	32.40331611
01011	-85.71572943	32.10045868
48359	-102.6027421	35.40425708
37109	-81.22393811	35.48589556
38069	-99.97174953	48.24958064
36035	-74.42194258	43.11377432
31077	-98.52144222	41.56747021
18157	-86.89407624	40.38871167
18093	-86.48322849	38.84095382
29221	-90.8786674	37.96173417
19121	-94.01554631	41.33081904
27087	-95.8091992	47.32558784
17171	-90.47455118	39.64403604
28085	-90.45417438	31.53240135
28097	-89.61664559	33.49402718
50009	-71.736327	44.7283185
55071	-87.80948518	44.11990639
48087	-100.2700105	34.96489439
39151	-81.36571811	40.8138382
27159	-94.9700148	46.5856535
29039	-93.85592541	37.72350148
19023	-92.79015971	42.73172833
20059	-95.28621552	38.56442768
28101	-89.11871108	32.40013897
17187	-90.61478203	40.84888704
26039	-84.61024859	44.68323123
18181	-86.8655579	40.74977914
17051	-89.02441763	39.0000587
27067	-95.00576302	45.15252304
18035	-85.39732772	40.22787247
29225	-92.87591692	37.28085752
31059	-97.59646937	40.52458567
20207	-95.74071995	37.88668091
19073	-94.39658081	42.03614551
18049	-86.26356168	41.04713247
20159	-98.20053402	38.34721983
20003	-95.29324204	38.21396508
46059	-99.00538393	44.54798838
55055	-88.77532763	43.02053192
51610	-77.17519332	38.88441803
36097	-76.8749143	42.39369114
46029	-97.18860384	44.97790512
72145	-66.39731281	18.42873078
46085	-99.84735699	43.89597621
28067	-89.168969	31.62257767
37077	-78.65301	36.30365992
51730	-77.3926205	37.20404153
39103	-81.8998621	41.11770589
20153	-101.07618	39.78524494
16081	-111.2078712	43.7599238
20155	-98.08586348	37.95303921
20197	-96.20480435	38.95324678
17153	-89.12738626	37.22269456
41055	-120.6892687	45.4052255
13101	-82.89413878	30.70991003
42009	-78.49051194	40.00670558
19021	-95.15100162	42.73545875
19079	-93.70672502	42.38395377
39127	-82.23618289	39.73723959
17035	-88.24032182	39.27402319
17023	-87.7878617	39.33402321
19145	-95.15010031	40.73917437
26131	-89.31491201	46.66430808
40077	-95.25098995	34.87639948
48003	-102.6376348	32.30470528
47067	-83.2217117	36.52355034
35029	-107.7498996	32.18233304
31061	-98.95299529	40.17637323
13189	-82.4818329	33.48313346
02270	-163.3844205	62.15704475
02198	-133.0585096	55.81638031
06069	-121.0752215	36.60559815
18097	-86.13826325	39.78163624
13081	-83.76727919	31.92287244
51710	-76.25967731	36.89479704
51065	-78.27765024	37.84216441
48075	-100.2077744	34.52929885
41043	-122.5341835	44.48880768
37001	-79.39913194	36.04378576
35011	-104.4120813	34.34266
39129	-83.02450193	39.64185964
27149	-96.00022786	45.58615985
27125	-96.09561104	47.87197525
19037	-92.31766909	43.06009652
22061	-92.66473671	32.60149394
28017	-88.94784369	33.92084863
29101	-93.80588795	38.74399152
27051	-96.01216405	45.93402352
72089	-65.72588384	18.34258508
28111	-88.9925273	31.17209382
69110	145.7509098	15.18953726
28079	-89.52402041	32.7536828
48125	-100.7788855	33.61616822
48099	-97.79936155	31.39078397
48189	-101.8268114	34.07044901
48445	-102.3354521	33.17402785
40025	-102.5178111	36.74826632
39125	-84.58018842	41.11674251
08017	-102.6036365	38.82780723
17163	-89.92848248	38.4703223
20137	-99.90284946	39.78448106
23029	-67.62910779	45.02177186
26153	-86.19985664	46.19666734
39043	-82.63799692	41.37421463
39107	-84.62929783	40.54030771
31109	-96.68776297	40.78416865
31157	-103.7084612	41.85095717
33011	-71.71602867	42.9153307
30001	-112.899016	45.13261641
06019	-119.6506833	36.75807672
12055	-81.34078347	27.3428855
56029	-109.5885953	44.52053528
48385	-99.82222259	29.8324893
13179	-81.49463778	31.82777126
13239	-85.01684071	31.86629277
08011	-103.0720227	37.95492416
48305	-101.8162849	33.17657705
48169	-101.2984114	33.17969345
51137	-78.01298345	38.24635826
54017	-80.70721363	39.26936104
72041	-66.16028438	18.17423695
38007	-103.3762965	47.02366884
02185	-153.4702536	69.31507516
72103	-65.75412933	18.23111172
20051	-99.31751551	38.91458712
18011	-86.46866856	40.05117643
20117	-96.52279918	39.78357355
55005	-91.84833604	45.42372695
29015	-93.28827876	38.2951634
13201	-84.73106803	31.16479534
28061	-89.11866575	32.01901366
18135	-85.0114051	40.15748383
29071	-91.07489027	38.4111314
31179	-97.11926964	42.20934475
02220	-135.3151746	57.23393263
31113	-100.482244	41.56652317
72047	-66.32896683	18.3041008
34011	-75.11135485	39.37323951
18107	-86.89342256	40.04037231
48343	-94.73282508	33.11284956
13135	-84.02400746	33.9614268
20081	-100.8710456	37.56200432
30033	-106.9928862	47.27767106
48223	-95.56432257	33.14945662
21221	-87.87327174	36.80638303
01037	-86.24789409	32.9362956
55139	-88.64477096	44.06886922
38071	-98.72015658	48.2690641
16037	-114.2816427	44.24147306
40003	-98.32176345	36.73091839
28009	-89.18844118	34.8172204
42019	-79.91342345	40.91176277
55073	-89.75863384	44.89792533
46007	-101.6641253	43.19506714
36091	-73.86394518	43.10743063
20139	-95.72707998	38.65235984
48163	-99.10804207	28.86751206
28137	-89.94520436	34.65069529
55078	-88.70957298	45.00428348
17147	-88.59111102	40.01024723
31013	-103.0860173	42.22084585
29077	-93.34188307	37.25758647
22055	-92.0636004	30.20738593
33007	-71.30563958	44.68948989
05051	-93.15048723	34.57659951
47071	-88.1845967	35.19856007
56031	-104.9661319	42.13239072
17097	-88.00373142	42.32318039
37107	-77.64152691	35.23892735
72081	-66.86725626	18.26903434
13215	-84.87620281	32.51001825
42077	-75.59214444	40.61280627
26161	-83.83879891	42.25344402
19055	-91.36741055	42.4713865
72143	-66.33676656	18.41003729
38075	-101.6577138	48.71910481
13089	-84.22665212	33.77122192
19169	-93.46499005	42.03621213
18005	-85.89789136	39.20574386
01067	-85.24094152	31.51487991
05075	-91.1070497	36.04103952
22005	-90.91101939	30.20335229
51183	-77.26234107	36.92136549
48195	-101.3545796	36.27743284
40097	-95.23132466	36.30176119
40011	-98.432652	35.87536168
30029	-114.0497122	48.29520088
46129	-100.0313401	45.42998641
20077	-98.07579639	37.1917471
31123	-103.0105871	41.7164533
20061	-96.75251853	39.00227253
51840	-78.17299993	39.17278399
20037	-94.85185156	37.50702733
31087	-101.0419762	40.17616691
39055	-81.17872133	41.49972479
26137	-84.59972828	45.02079452
19095	-92.06369553	41.68621637
48009	-98.68754589	33.61569967
37093	-79.23678619	35.01716668
22089	-90.35781296	29.90559494
31063	-100.3936643	40.53024724
48325	-99.11033508	29.35546127
19103	-91.58679259	41.67150873
18131	-86.69890683	41.04166107
19159	-94.24367465	40.7351498
47111	-86.00775763	36.53211833
27133	-96.25305709	43.67485346
16051	-112.3114205	43.82027224
42083	-78.56888029	41.80786813
39069	-84.06830637	41.3339642
38003	-98.07170952	46.93593125
48179	-100.8129222	35.40081878
38091	-97.72479507	47.45618207
46081	-103.7921498	44.35866653
45061	-80.25465278	34.16360573
19041	-95.15096481	43.08247182
20049	-96.24370891	37.45338324
27033	-95.18136404	44.00720878
26123	-85.80070154	43.5544124
48397	-96.40769484	32.89785884
40111	-95.96434123	35.64662667
41065	-121.1678419	45.16003768
27113	-96.03627453	48.0666771
22113	-92.32457583	29.84621938
22123	-91.45664676	32.78885847
26115	-83.53769332	41.92832154
48391	-97.16001089	28.32554745
41027	-121.6512892	45.51931999
45051	-78.99657939	33.92139357
37031	-76.65336214	34.8275267
45005	-81.35758839	32.98833364
37039	-84.06424533	35.13376757
26019	-86.01505847	44.63910932
29037	-94.35504883	38.64793026
31153	-96.11218009	41.11287068
29081	-93.99193402	40.35497608
36027	-73.74303603	41.76513375
13223	-84.86736714	33.92082846
13117	-84.12468922	34.2256545
35025	-103.4124539	32.79215735
48263	-100.7780898	33.18104889
20019	-96.24531969	37.14997344
05043	-91.71972855	33.58957425
28105	-88.8794268	33.42493738
72015	-66.05744329	17.9984593
40149	-98.99166621	35.29031759
26145	-84.0526996	43.33526107
06031	-119.8151995	36.07520008
20123	-98.20900663	39.39334518
27119	-96.40222842	47.77395991
27123	-93.09987304	45.01747232
55017	-91.28017125	45.06921882
26079	-85.0904614	44.68488514
28113	-90.40396978	31.17495895
72071	-67.00476317	18.44963632
39135	-84.64804448	39.74220535
31175	-98.98208511	41.56723462
12125	-82.37209886	30.04340869
31151	-97.14080062	40.52415215
48231	-96.08560239	33.12356693
49009	-109.5076481	40.88725861
20095	-98.13639393	37.55911415
48151	-100.4019302	32.74281316
42131	-76.01693959	41.51833347
19093	-95.51355387	42.38696136
30041	-110.1111845	48.62840165
48211	-100.2703577	35.83764858
39109	-84.22868895	40.05414393
29187	-90.47255556	37.81055607
06091	-120.5162324	39.58019892
38081	-97.63059676	46.1078458
31035	-98.05126296	40.52439441
20063	-100.4829436	38.91587321
48115	-101.9477242	32.74255572
06083	-120.0150919	34.67142103
54075	-80.00762338	38.33190977
08009	-102.5601186	37.31923997
09001	-73.38919037	41.26973285
13053	-84.78680953	32.34694534
18087	-85.42669106	41.64234778
18173	-87.2717425	38.09237205
18019	-85.70765032	38.47743705
19163	-90.62318822	41.63706131
21041	-85.12373313	38.66814643
21117	-84.53313887	38.93368118
26013	-88.36559186	46.66237725
31165	-103.7588138	42.48797315
54019	-81.08105939	38.02876546
47085	-87.77571312	36.04110957
48221	-97.83219383	32.43002712
47033	-89.13938582	35.81376271
47031	-86.07559709	35.49021487
54101	-80.4218655	38.49472856
47079	-88.30116646	36.33178059
40051	-97.88360671	35.01633237
41067	-123.0985728	45.55989124
37185	-78.10671227	36.39674307
01053	-87.16176056	31.12613571
05127	-94.06315729	34.86103868
05035	-90.30924635	35.20762172
13191	-81.40719089	31.49489855
18153	-87.41401466	39.08909886
19089	-92.31710205	43.35677003
19115	-91.25958262	41.21843405
19097	-90.57403934	42.17178419
21015	-84.72794553	38.96984373
22109	-90.86454347	29.40922061
21159	-82.51414497	37.80090718
22011	-93.3436646	30.64776149
08065	-106.344854	39.20226223
12013	-85.19679907	30.40604523
08035	-104.92921	39.32970828
13311	-83.74657149	34.64590613
56023	-110.656067	42.26409375
51153	-77.48028729	38.70276099
49003	-113.0821456	41.52095018
49045	-113.1311648	40.44875267
37085	-78.86964365	35.368729
31125	-97.99248173	41.3972847
31017	-99.92949608	42.43016331
45067	-79.36252998	34.08038363
38037	-101.6397779	46.35813751
30095	-109.394534	45.66951507
30017	-105.5718948	46.25264388
35061	-106.8090108	34.71536166
36123	-77.10558958	42.63362823
13267	-82.05794341	32.04578293
29105	-92.59043082	37.65865829
13321	-83.8509648	31.55124636
20001	-95.30115478	37.88555459
17169	-90.61538755	40.15816304
21189	-83.68320054	37.41974744
20079	-97.42729333	38.04321442
18119	-86.83782352	39.31262962
27003	-93.24708307	45.27314304
29043	-93.18847844	36.96906632
20007	-98.68457457	37.22893536
01047	-87.10649231	32.32606741
55095	-92.44123483	45.4615393
45035	-80.40502258	33.07948049
30099	-112.2407056	47.83722455
33001	-71.4226598	43.51832231
41023	-119.0074917	44.4907455
36069	-77.29986178	42.85304122
31101	-101.6614388	41.19906619
13057	-84.47621286	34.24473392
13161	-82.63685771	31.8053696
21067	-84.4589719	38.04287124
21087	-85.55273508	37.26369627
28071	-89.48471446	34.35673647
21229	-85.17499676	37.75352228
21081	-84.62407384	38.64914531
13069	-82.84967311	31.54918005
18059	-85.77325696	39.82296118
27009	-93.9984359	45.69827623
72065	-66.79574437	18.40992471
49039	-111.5763852	39.37372605
22041	-91.67348178	32.13329548
29003	-94.80140498	39.98335111
19083	-93.24040527	42.38393029
18105	-86.52334305	39.16100464
23017	-70.75611419	44.49924446
25005	-71.11419448	41.79709525
48201	-95.39302715	29.85748873
40071	-97.1438723	36.81795089
38033	-103.8465777	46.94026181
30101	-111.6959501	48.65534485
31015	-98.76608585	42.89966872
36073	-78.23141929	43.25158537
36101	-77.3834881	42.26788874
28001	-91.35355624	31.48172857
34021	-74.70164497	40.28339139
13255	-84.28381621	33.26065533
02110	-134.1764399	58.45091866
05109	-93.65621	34.16356461
55023	-90.93068567	43.23966087
48229	-105.3871487	31.4564022
54051	-80.66340417	39.86038842
54029	-80.57390126	40.52189394
21037	-84.3791722	38.94658952
22107	-91.34006167	32.00026867
23027	-69.14427892	44.50136648
46091	-97.59865421	45.75863325
38023	-103.4871163	48.81486205
46127	-96.65571268	42.83182818
42133	-76.72634152	39.92001283
47157	-89.89620223	35.18412715
39081	-80.76113054	40.38470042
37115	-82.70612535	35.85793329
28139	-88.90883067	34.76830318
31057	-101.6878043	40.17625316
37133	-77.42736897	34.72975141
35007	-104.6468731	36.60619925
27049	-92.72266089	44.40972913
27169	-91.77934467	43.98683746
32023	-116.47176	38.04212846
28049	-90.44251629	32.26628404
20157	-97.65034285	39.8279368
48493	-98.08694449	29.17420221
54013	-81.11738243	38.84382602
55067	-89.07193609	45.26219987
55111	-89.94819801	43.42667177
47061	-85.72237029	35.3884299
51125	-78.88692463	37.7874546
48373	-94.82986499	30.79270853
41037	-120.3873864	42.79350818
51680	-79.19044951	37.40023149
12005	-85.62005473	30.26520819
01097	-88.20659057	30.77909854
06037	-118.224703	34.32134579
08023	-105.4278551	37.27823118
06035	-120.5947447	40.6733613
12063	-85.21596518	30.79547704
13281	-83.73739141	34.91666684
01023	-88.26305322	32.02019311
20025	-99.8196146	37.23547247
20043	-95.14683558	39.78796644
21177	-87.1426872	37.21592449
72005	-67.12067807	18.46028414
17045	-87.74546531	39.67865165
13225	-83.82790492	32.56840679
72151	-65.89622001	18.07018602
29181	-90.86381088	36.65269053
15005	-156.9493744	21.17295672
55021	-89.33408259	43.4669904
35051	-107.1925539	33.13025321
21021	-84.86612061	37.62427782
47055	-87.03541784	35.20194268
48327	-99.8204794	30.88990665
47083	-87.71768095	36.28616631
49017	-111.4425093	37.85511631
48005	-94.61100866	31.25457834
48175	-97.42628751	28.65724851
51063	-80.36184172	36.93162812
48477	-96.40341594	30.21441875
48379	-95.79355891	32.87032705
04027	-113.9058099	32.76933672
05049	-91.81767336	36.3818346
12021	-81.34769003	26.11069361
36029	-78.73230753	42.76409998
29199	-92.1472444	40.45201091
27173	-95.86888348	44.71626059
13151	-84.15307775	33.45278905
12051	-81.16511547	26.55374425
18031	-85.50090226	39.30715055
08019	-105.6447627	39.68922182
51520	-82.1590697	36.61826378
56003	-107.9948912	44.52636084
54065	-78.25701555	39.5606152
49023	-112.7847328	39.70284831
01079	-87.31085381	34.52223687
48369	-102.7844494	34.52993922
51103	-76.46151665	37.73239182
31079	-98.50212614	40.87261328
39009	-82.0451808	39.3340326
39091	-83.76526991	40.3883971
39141	-83.0569591	39.33753008
30097	-109.939664	45.813756
36121	-78.2237766	42.70226414
40125	-96.94828061	35.20684527
42081	-77.06520269	41.34394419
29159	-93.28474912	38.72825898
18069	-85.48831237	40.82907594
15007	-159.5957496	22.03978487
30055	-105.7952945	47.64515532
28065	-89.82311087	31.56973198
21103	-85.11897835	38.44849046
17009	-90.75018804	39.96180493
17043	-88.08563421	41.85173736
21009	-85.93377067	36.96546022
51017	-79.74123354	38.05836054
01015	-85.82574705	33.77141549
01121	-86.16587666	33.37992421
51131	-75.87764606	37.34305358
37057	-80.21253309	35.79311799
41069	-120.0273912	44.72584844
37155	-79.10352623	34.64028878
42097	-76.70893391	40.85142483
35033	-104.944561	36.00972846
40027	-97.3267069	35.20346872
42121	-79.75792032	41.40101962
18065	-85.39654344	39.93112507
18143	-85.74696726	38.68627244
20145	-99.23682021	38.18106307
12081	-82.31571914	27.47189899
21113	-84.58031888	37.87235886
17017	-90.24761202	39.97376092
12033	-87.36273986	30.66830369
72133	-66.38861781	17.99547652
18037	-86.87970258	38.36427783
18115	-84.96502468	38.94996711
28053	-90.52684783	33.12856998
17063	-88.41891328	41.2856038
69120	145.6261608	15.00074124
46077	-97.4913945	44.36956169
55135	-88.96532599	44.47070734
47081	-87.47317001	35.80374486
47043	-87.35658415	36.14932156
49035	-111.9241028	40.66728813
51197	-81.07803317	36.91686677
54045	-81.9351906	37.8319353
48333	-98.59562176	31.49516229
12129	-84.40005301	30.16603091
13213	-84.74799528	34.78861644
17201	-89.16084223	42.33630888
17007	-88.82348512	42.32294195
18083	-87.41778158	38.68954718
19119	-96.2102221	43.38111289
21147	-84.48377645	36.73699245
21093	-85.96366674	37.69820941
01119	-88.19904039	32.59104949
02016	-110.2449123	52.79430361
46051	-96.76789112	45.17218979
39013	-80.98861998	40.01576203
37013	-76.85887749	35.49296573
37113	-83.42232408	35.15057533
30075	-105.6300238	45.39499878
32017	-114.8771351	37.64342469
36009	-78.67903202	42.24856064
33015	-71.12556353	42.98749699
36055	-77.69595887	43.14694904
34015	-75.14071747	39.71694144
08037	-106.6953848	39.62801893
08073	-103.5137335	38.98742236
05037	-90.77181286	35.29547453
13037	-84.62376804	31.52887387
01085	-86.65002353	32.1550404
28145	-89.00393228	34.49025133
21005	-84.99140593	38.00378449
54039	-81.52827161	38.33643035
72135	-66.2462674	18.36223592
29027	-91.92616939	38.83570509
19105	-91.13139641	42.12118609
16043	-111.4821032	44.22898675
20047	-99.31204845	37.88763961
48113	-96.77788947	32.76665041
06025	-115.3657218	33.03935669
06003	-119.8206263	38.59721624
11001	-77.01629654	38.90478149
12075	-82.74249558	29.31952768
45085	-80.38227873	33.91600797
51043	-77.99656139	39.11236047
44005	-71.23906841	41.55667416
53013	-117.9078252	46.29796069
49055	-110.9033351	38.32442333
53021	-118.8984754	46.5350455
26053	-89.69437271	46.40885281
05001	-91.37520643	34.29076839
08013	-105.3574574	40.09241482
54021	-80.85664593	38.92492424
34033	-75.34910669	39.58787069
13193	-84.04282299	32.35871148
13263	-84.53322383	32.69944401
13093	-83.79901736	32.15728777
01055	-86.03476854	34.04518886
02020	-149.1118883	61.15068906
17001	-91.18842478	39.98808185
31147	-95.71768995	40.12499676
19151	-94.67862564	42.73420133
17103	-89.29939757	41.74622905
72033	-66.13939837	18.44436903
46071	-101.6282752	43.69419796
46015	-99.08125406	43.71816719
48055	-97.61976797	29.83714515
47005	-88.06869913	36.06961024
53023	-117.5446476	46.43130985
27107	-96.45566228	47.32618622
50021	-73.03669897	43.57983752
27129	-94.94679511	44.72672673
04021	-111.34488	32.90415087
06077	-121.2712102	37.9345275
53073	-121.7209525	48.82595321
51133	-76.41950915	37.8876167
01127	-87.29727889	33.80316281
01051	-86.14884036	32.59724126
37105	-79.17158398	35.47515626
45027	-80.21662078	33.66542745
38025	-102.6182871	47.35663619
41061	-118.0093556	45.31039084
37127	-77.9861842	35.96771851
51620	-76.93848875	36.68306879
48457	-94.37649281	30.77118478
51049	-78.24455011	37.51182231
48013	-98.52716292	28.89331115
48133	-98.83243566	32.32743996
51037	-78.66167401	37.0117581
47137	-85.07476517	36.55818853
40035	-95.20866115	36.76178038
41031	-121.176431	44.62935891
29041	-92.96305582	39.51548794
53071	-118.4785331	46.22968278
51115	-76.34148682	37.43639888
29131	-92.42809571	38.21438575
51119	-76.56869484	37.62970349
41025	-118.9679625	43.06361843
51015	-79.13408568	38.16483645
54003	-78.0274399	39.46408048
55029	-87.31112969	44.95030522
39173	-83.62311366	41.36160162
37163	-78.37163083	34.99203592
27005	-95.67483556	46.93523736
18027	-87.07197336	38.70229994
29007	-91.84163742	39.21595536
23011	-69.76757384	44.40901704
28019	-89.24846009	33.34764715
21137	-84.66076388	37.45485594
26113	-85.09471001	44.33770935
21205	-83.42085187	38.19625131
51117	-78.3626113	36.68047202
40123	-96.68450952	34.72795889
37035	-81.21481079	35.66260115
21011	-83.74265272	38.14480167
21013	-83.67369514	36.73094679
23005	-70.37661287	43.83897334
55037	-88.39761751	45.8480979
25027	-71.90780992	42.35111931
13049	-82.13757286	30.7815722
37191	-78.00407767	35.36389637
41013	-120.3567062	44.14229491
36023	-76.07049311	42.59514578
30111	-108.2742553	45.93715306
39157	-81.47450488	40.44131431
18159	-86.05195096	40.31121117
22093	-90.79581459	30.02623427
22079	-92.53365886	31.19810087
21001	-85.28062533	37.1039252
08113	-108.405806	38.00399367
72017	-66.55881898	18.44638293
30107	-109.8444012	46.46630385
37059	-80.54428142	35.92957297
31137	-99.41426701	40.51115428
31047	-99.81946635	40.86987625
55133	-88.30430125	43.01833546
13291	-83.99038243	34.83375049
20053	-98.20501891	38.6967292
36037	-78.19407819	43.00056703
27013	-94.06697737	44.03450234
21019	-82.68775539	38.35908957
21027	-86.42936466	37.7732385
25019	-70.07344074	41.28422779
21007	-88.99943791	37.05854425
28029	-90.44883293	31.86883689
21169	-85.62919821	36.99052063
51159	-76.7268014	37.94301072
48157	-95.77093789	29.52747353
21069	-83.69658812	38.37035302
28055	-90.98899611	32.74139849
13115	-85.21440801	34.26315113
22099	-91.60785079	30.12930997
20069	-100.4379698	37.73851836
17173	-88.80591091	39.39127226
28133	-90.58875506	33.60184158
29053	-92.80985416	38.84333073
26155	-84.14662058	42.95402135
18175	-86.10543054	38.59978187
27139	-93.53696693	44.64850008
31181	-98.50021623	40.17643706
78020	-64.74657958	18.34029903
48073	-95.16565693	31.83752856
47135	-87.85894071	35.64313951
47037	-86.78502875	36.16932462
48267	-99.74856473	30.48678918
45009	-81.05432857	33.21508217
72051	-66.27788236	18.43643896
42023	-78.20384508	41.43674888
06081	-122.328899	37.42298018
72079	-67.03992341	18.01204007
21187	-84.82790284	38.52025251
04025	-112.5538467	34.59969928
21239	-84.74341301	38.04257558
18051	-87.58518363	38.31161078
47117	-86.76591028	35.46843385
17111	-88.45263983	42.32444631
18161	-84.9249309	39.62515829
18043	-85.90699249	38.31902045
20035	-96.83732848	37.23777562
20075	-101.7915769	37.9991797
24009	-76.56882392	38.5437742
26097	-85.07704103	46.07858665
17061	-90.39051245	39.3563746
31111	-100.7452801	41.04750134
56035	-109.9148412	42.76688453
21017	-84.21645396	38.20656118
72031	-65.95606154	18.37503034
51127	-76.9971687	37.50499104
46119	-100.131855	44.71542851
55107	-91.1333376	45.47489408
09015	-71.98737539	41.83006633
13055	-85.34522718	34.47504069
13241	-83.40264155	34.88165754
17157	-89.82565532	38.05214985
16027	-116.7092162	43.6251769
18111	-87.39778904	40.95571121
47129	-84.64901358	36.13501561
40045	-99.75451143	36.21835085
18165	-87.46414164	39.85409324
08083	-108.5964924	37.33893986
47189	-86.29778739	36.15428192
55015	-88.21780273	44.0816316
25021	-71.20690516	42.1624614
48321	-96.01140809	28.82108792
42117	-77.25438714	41.77283534
47109	-88.56332928	35.17583563
45021	-81.62012099	35.04837373
47185	-85.45476978	35.92662264
49007	-110.5891155	39.64773138
51149	-77.22446275	37.18648609
45089	-79.72785637	33.62020834
48371	-102.7234229	30.78076842
46053	-99.18590693	43.19247936
19005	-91.37915589	43.28400613
21231	-84.8286438	36.80107637
21029	-85.69808753	37.97000785
26033	-84.56284345	46.30032406
40151	-98.86351819	36.76674112
40133	-96.61546183	35.1672074
35027	-105.4585461	33.74510826
38057	-101.8317306	47.30905996
35043	-106.8658272	35.68909544
16021	-116.4627525	48.766998
18091	-86.74045399	41.5459356
47019	-82.12769739	36.29228876
47097	-89.63135139	35.76118851
45003	-81.63493042	33.544095
56041	-110.5474049	41.28749663
72109	-66.01187172	18.03150854
48199	-94.3902703	30.33224472
01033	-87.80463371	34.70085284
05133	-94.24072249	33.9971421
04013	-112.4908888	33.34875974
13145	-84.9082899	32.73613817
25001	-70.2898624	41.7232979
40017	-97.98241218	35.54233821
46009	-97.88493814	42.98827986
42049	-80.03257439	41.9921752
35055	-105.630976	36.57834262
36067	-76.19460186	43.0061269
38085	-101.0403323	46.11262812
21055	-88.09694438	37.35257485
37131	-77.39657442	36.41780769
27081	-96.26720134	44.4123209
29510	-90.24484413	38.63654694
29005	-95.42832663	40.430839
29155	-89.78539961	36.21131565
16055	-116.7000308	47.6744641
18075	-85.00574703	40.43780769
18123	-86.6380062	38.07971276
18147	-87.00784468	38.01429111
20071	-101.8060294	38.48078179
21145	-88.71249008	37.05384925
38067	-97.55156514	48.76726978
47045	-89.4139363	36.05918296
41003	-123.428743	44.49161157
31131	-96.1350641	40.64856103
51036	-77.06179476	37.35669644
19007	-92.86861174	40.74323979
22013	-93.05594858	32.34717134
17019	-88.19947606	40.13984863
53053	-122.1122121	47.02680625
46121	-100.7186033	43.1933652
51067	-79.88106371	36.99189661
53059	-121.9148915	46.02280969
04003	-109.7510129	31.87959362
05143	-94.21571712	35.97899668
09005	-73.24526767	41.79242134
22125	-91.42038292	30.88038848
23015	-69.54198777	44.06333351
25025	-71.07033478	42.33340065
40067	-97.83608709	34.11052408
47051	-86.09233522	35.15504791
31127	-95.84990553	40.38784773
29095	-94.34603332	39.00926211
35041	-103.4801987	34.02127232
27011	-96.41134505	45.42651259
34019	-74.91261058	40.56697742
13159	-83.68792053	33.31633785
22015	-93.60428557	32.67882745
21065	-83.96441737	37.6925357
06013	-121.9281273	37.91933375
35031	-108.2616781	35.58040415
16073	-116.1698327	42.58161924
18177	-85.00991888	39.86440062
18155	-85.03658909	38.82631081
19139	-91.11279575	41.48388139
19191	-91.84475831	43.29085957
47027	-85.5429723	36.55111287
37173	-83.4921876	35.48677176
28087	-88.4432447	33.47293459
31025	-96.14069252	40.90976087
37187	-76.57653423	35.82268131
18125	-87.2323432	38.39848154
13015	-84.84068937	34.23786814
51071	-80.70422242	37.31404444
51740	-76.35396761	36.84646209
48387	-95.04966416	33.62099176
24005	-76.63603021	39.4596552
22081	-93.33992874	32.09302665
16079	-115.8911361	47.35176251
24015	-75.94133759	39.57067423
37079	-77.67650726	35.48563343
18061	-86.11124563	38.19522174
21053	-85.13646367	36.7275894
23013	-69.15278458	44.12441708
38099	-97.72134503	48.36930301
29087	-95.21504754	40.0944922
29129	-93.56850616	40.42251333
27069	-96.78256113	48.77698427
55003	-90.67745058	46.33463725
01063	-87.95276818	32.853304
53067	-122.8330654	46.92672896
38059	-101.2808428	46.71620349
47065	-85.1644476	35.18133492
47121	-84.8129419	35.51294836
47143	-84.92418399	35.60911854
24019	-76.02355952	38.46896686
48039	-95.45158629	29.18949785
30031	-111.1703288	45.54097041
35013	-106.8330858	32.35265229
12093	-80.88873614	27.3866315
08043	-105.4399703	38.47306423
05149	-93.41105962	35.00270728
55123	-90.83463661	43.59402052
38015	-100.4687948	46.97733689
37111	-82.04845774	35.68110614
13163	-82.41823729	33.05432827
13289	-83.42729345	32.66724559
19039	-93.78516215	41.02892087
22003	-92.82796914	30.65238675
20065	-99.88334471	39.34986711
16001	-116.241035	43.45084054
17159	-88.08560224	38.71228739
28073	-89.50870961	31.20573333
17131	-90.74108384	41.20543704
06085	-121.6951016	37.23169965
51107	-77.63575211	39.09048044
46023	-98.58785039	43.20792726
46123	-99.88408568	43.34592545
37139	-76.28360001	36.29472462
39087	-82.53675197	38.59849502
37005	-81.1277104	36.49135989
55091	-92.00178921	44.58302681
54009	-80.57654665	40.27385743
01073	-86.89657084	33.5543433
37067	-80.25626566	36.13057844
31121	-98.03760529	41.16916952
45063	-81.27229853	33.90217281
38061	-102.3557043	48.20129569
21167	-84.87436107	37.81116654
29047	-94.42122576	39.31045251
18079	-85.62737915	38.99757081
72073	-66.58853781	18.20981011
72123	-66.25486537	18.00693567
10001	-75.56844621	39.08639126
55049	-90.13523894	43.00020828
30103	-107.2718156	46.21135847
31041	-99.72614484	41.39416503
24027	-76.93099926	39.25078653
24029	-76.0404081	39.25416924
46055	-101.5397482	44.29463659
24031	-77.20428439	39.13634899
37091	-76.98162611	36.35892018
26047	-84.89116957	45.51996676
29227	-94.42191277	40.47867651
35023	-108.7148057	31.91398466
36003	-78.02730689	42.25731952
28059	-88.6353787	30.53467952
37061	-77.93295681	34.93627171
28025	-88.78154439	33.65579797
31071	-98.99111827	41.91428955
13121	-84.46714878	33.79038574
20141	-98.76753828	39.3503437
16053	-114.2642648	42.68974614
27029	-95.37844018	47.57848837
22083	-91.76336368	32.41758531
22127	-92.63657688	31.94438827
17191	-88.42586459	38.42955355
54001	-80.00360456	39.13281051
47075	-89.28418692	35.58313405
51111	-78.24084587	36.94606214
48449	-94.96656946	33.21673924
38065	-101.3403504	47.115508
51169	-82.60311478	36.7143081
06111	-119.0848457	34.45474678
06095	-121.9331593	38.27025048
24037	-76.60613989	38.3016848
45077	-82.72522047	34.88795956
45087	-81.61926683	34.68978386
45083	-81.99110742	34.93148726
56033	-106.8799546	44.79068012
56013	-108.6304217	43.04055711
56017	-108.4422853	43.71897841
27115	-92.74140502	46.12071071
30023	-113.0672423	46.06059035
30093	-112.6566556	45.90234114
29031	-89.68444987	37.38402006
25013	-72.63119338	42.13509064
21079	-84.53826255	37.63999075
25023	-70.81296132	41.95331777
45013	-80.73004378	32.3853684
45053	-81.03177638	32.43633197
27045	-92.08990525	43.6739576
49011	-112.1116607	40.99072955
49057	-111.9127797	41.27005573
37051	-78.82718356	35.04887721
26083	-88.43593439	47.62662557
05103	-92.88191217	33.59337533
10003	-75.64791441	39.58150592
08029	-107.8629449	38.86135647
08033	-108.5173886	37.75208472
13077	-84.76342787	33.35346702
17027	-89.4229686	38.60632268
48161	-96.14897872	31.7044343
21123	-85.69858421	37.54557718
13233	-85.18805562	34.00190077
31031	-101.1185272	42.54499866
24003	-76.60335105	39.0057724
46135	-97.39494039	43.00895493
37087	-82.98251028	35.55576195
47029	-83.12121537	35.92555143
21161	-83.82396293	38.59510651
49049	-111.670284	40.11980262
26105	-86.25017381	43.99535369
21175	-83.25778159	37.92214018
54087	-81.34822568	38.71393058
09007	-72.5354823	41.46358412
37197	-80.66532457	36.1604416
10005	-75.38998106	38.66089142
01027	-85.8607443	33.26966941
37089	-82.48021492	35.33655768
13157	-83.56602206	34.1338612
37161	-81.92041527	35.4018617
16063	-114.1383193	43.00232711
51141	-80.28481637	36.67809987
31089	-98.78376243	42.45557846
72057	-66.13696252	18.00377727
72023	-67.15457364	18.03901469
42067	-77.40277415	40.5308105
18089	-87.38221633	41.41685156
42071	-76.24786695	40.04261494
45019	-79.95226654	32.83417041
48015	-96.27800561	29.88707804
47057	-83.51084097	36.2754882
47063	-83.26632471	36.2171435
46033	-103.4514908	43.67736837
37193	-81.16305367	36.20617699
06093	-122.5405164	41.59272613
27025	-92.90829767	45.5024111
26121	-86.1519783	43.2913812
17075	-87.82452537	40.74732578
18121	-87.20678147	39.77360728
06087	-122.0017742	37.0561908
13141	-83.00098883	33.27020552
48271	-100.4179055	29.35014052
16019	-111.6147928	43.38792191
13011	-83.49753835	34.35397657
37177	-76.20702207	35.81805644
42085	-80.25773634	41.30228665
29107	-93.7855705	39.06555761
29113	-90.96009523	39.05829936
42087	-77.6170294	40.61051314
22117	-90.04035989	30.85339081
42027	-77.81986792	40.91933775
47073	-82.94554982	36.4410474
47077	-88.38771258	35.65381663
42029	-75.74843926	39.97329798
45033	-79.37858369	34.39138915
42031	-79.42093979	41.19261355
45039	-81.12125577	34.39533447
21183	-86.84842961	37.47818665
05125	-92.67655329	34.64661779
21193	-83.22147321	37.24414459
21195	-82.39537783	37.46909859
21197	-83.82298076	37.83036747
08079	-106.9241901	37.66954135
48273	-97.72430027	27.43132443
06115	-121.3508296	39.26930746
20091	-94.82256945	38.88370015
13013	-83.71288108	33.99268452
16031	-113.6013217	42.28381567
51147	-78.44090565	37.22409267
29127	-91.62231175	39.8059363
22053	-92.8140461	30.26796744
38029	-100.2386194	46.28495441
42093	-76.65904667	41.02752391
29135	-92.58303239	38.63234724
42095	-75.30735363	40.75446063
47089	-83.44652522	36.0513409
41057	-123.7127608	45.46343846
49021	-113.2894426	37.85935379
30009	-109.0283184	45.22736746
44003	-71.59305645	41.6720081
21201	-84.0518799	38.51778393
27053	-93.47715121	45.00479678
47165	-86.46074089	36.46938867
21225	-87.94548669	37.65840762
17065	-88.53883373	38.08163641
17067	-91.16472529	40.40370799
48365	-94.30558387	32.16239924
37175	-82.79867801	35.20208661
17099	-88.88623869	41.34406943
48277	-95.57108168	33.6672152
51077	-81.22507847	36.65661781
12071	-81.84068841	26.57801557
24033	-76.84739072	38.8299677
32011	-116.2694709	39.98327398
22111	-92.3748342	32.83186286
34007	-74.96012063	39.80401748
37199	-82.30812844	35.8984235
05011	-92.16229542	33.46613806
50001	-73.14089327	44.03090072
49005	-111.743741	41.72255404
48245	-94.16307113	29.88337578
47101	-87.49365286	35.52726999
48351	-93.74533244	30.78564527
13245	-82.07386121	33.35950332
13265	-82.87900052	33.566347
40055	-99.56059648	34.93429868
40057	-99.84630188	34.74409289
13279	-82.33096121	32.12156708
12031	-81.67063889	30.33214142
39093	-82.1511144	41.29557931
39115	-81.85284727	39.62071306
39131	-83.06678951	39.07705515
28135	-90.17334129	33.95061391
36013	-79.36664149	42.22817594
46109	-96.94614272	45.62977349
46113	-102.5516416	43.3357008
29011	-94.34736796	37.50205562
48045	-101.2084947	34.53026962
29069	-90.09071406	36.2722822
37171	-80.68725838	36.41459623
42043	-76.77925448	40.41555232
30039	-113.4401981	46.40415824
31033	-102.9949509	41.21970871
48255	-97.85944813	28.90564205
56001	-105.7236684	41.65453797
56007	-106.9303916	41.69413999
56021	-104.6892193	41.30709358
51011	-78.81172877	37.37242345
30037	-109.1749672	46.38114583
56005	-105.5484733	44.24806602
26151	-82.82063341	43.4237632
12069	-81.71135257	28.76121706
01117	-86.66137476	33.26405258
17091	-87.86189197	41.13747976
18163	-87.58559945	38.02551429
39049	-83.0091231	39.96927249
29021	-94.80618288	39.65989328
29165	-94.77380125	39.38073683
39061	-84.54309843	39.19557749
30021	-104.899515	47.26636057
37009	-81.50052459	36.43415234
27167	-96.46820682	46.35705832
38051	-99.4414601	46.11180534
35017	-108.3823282	32.73885662
30043	-112.0940513	46.14859974
47161	-87.83755715	36.50150068
48035	-97.63435711	31.90035901
51033	-77.34662195	38.02701807
56009	-105.5077277	42.9722826
16003	-116.4539483	44.88931492
27075	-91.44445826	47.64037177
08091	-107.7693048	38.15498465
30071	-107.9138518	48.25942665
48337	-97.72439946	33.67539964
49015	-110.7004925	38.99637448
48029	-98.52016013	29.44911665
35021	-103.820322	35.85799759
36047	-73.93708255	40.63562226
26041	-86.92347486	45.91736311
05029	-92.70098811	35.26227905
51173	-81.53692387	36.84393147
05091	-93.89142003	33.31200171
45059	-82.00535135	34.48372258
56011	-104.5703226	44.58843934
47181	-87.78755065	35.24027258
55109	-92.4529513	45.03345626
05121	-91.02752205	36.34154412
08107	-106.9915083	40.48549841
16023	-113.1719663	43.72266581
05145	-91.74548804	35.25612459
49027	-113.1003083	39.07403971
12121	-82.99147597	30.19562156
48027	-97.47823134	31.03762665
12123	-83.60328684	30.04712958
51101	-77.08804071	37.70635361
48147	-96.10669521	33.59387579
35005	-104.4668372	33.36323485
39075	-81.93067102	40.5614819
48155	-99.77794293	33.97478308
26089	-85.81220561	44.93943424
38063	-98.19212605	47.92171706
45075	-80.80086358	33.43921301
56039	-110.5896979	43.93456366
51059	-77.27651017	38.83620791
40107	-96.3228392	35.46544123
48409	-97.51888305	28.00978811
06043	-119.9053183	37.58143472
39067	-81.09149874	40.29356193
35009	-103.3468992	34.57414777
53019	-118.5163244	48.47039666
53065	-117.8550713	48.39899156
55009	-88.00366602	44.452501
37023	-81.70505869	35.74914733
27097	-94.26690418	46.01207437
51177	-77.65615344	38.18453467
29149	-91.40332146	36.68672248
26103	-87.64138782	46.43139896
48167	-94.95985195	29.3895025
24041	-76.10341962	38.77026257
47139	-84.52298798	35.11993556
42057	-78.11276349	39.92545432
37159	-80.52501519	35.64030608
19045	-90.53221937	41.89809865
37117	-77.10604281	35.84087616
28147	-90.10601376	31.14823915
27171	-93.96334763	45.1738141
13293	-84.29964447	32.88096475
33005	-72.25111371	42.91955278
31155	-96.63733984	41.22629371
13313	-84.96674982	34.80650119
49029	-111.5734451	41.08889094
50003	-73.09291531	43.03531126
29186	-90.1946731	37.89454581
51179	-77.45796206	38.4206167
37027	-81.5469666	35.95288519
31007	-103.7109624	41.54616353
05053	-92.42371463	34.29002049
42119	-77.06213019	40.9633376
05055	-90.55895377	36.11773282
36083	-73.50952678	42.71103722
37045	-81.55570623	35.33410942
20149	-96.34276557	39.37903349
24045	-75.62218411	38.37287229
23023	-69.85358192	43.95888365
48089	-96.52613796	29.62080587
06023	-123.8755258	40.69940115
30065	-108.3975013	46.49659376
37119	-80.83268027	35.24675454
13297	-83.73367264	33.78121226
48275	-99.74139253	33.60611596
53017	-119.6917069	47.73589576
38097	-97.16169937	47.45400419
06021	-122.3921982	39.59788378
05057	-93.66809039	33.73564268
42123	-79.2740453	41.81377056
38035	-97.45708074	47.92166578
31023	-97.13156172	41.22599383
34039	-74.30721513	40.65928966
05061	-93.99344494	34.08897983
48097	-97.21276751	33.63940669
48105	-101.4121116	30.72293884
48109	-104.5179143	31.44657839
17139	-88.61929657	39.64136794
19059	-95.15099401	43.37782493
23007	-70.44421037	44.97424486
30007	-111.4961534	46.33259261
48363	-98.31319001	32.75310985
13307	-84.55001221	32.04630599
13309	-82.72430717	32.11657577
31027	-97.25275919	42.59931244
29161	-91.79238502	37.87731447
42003	-79.9817588	40.46880438
06027	-117.4113187	36.51173415
05119	-92.31191414	34.76993891
06011	-122.2363987	39.17719198
42129	-79.46732917	40.31090839
31055	-96.15494428	41.29533784
20107	-94.84299061	38.21238797
26003	-86.60408109	46.40902031
21109	-84.00617165	37.41979135
26043	-87.87011459	46.00907005
47149	-86.41692683	35.84260355
47151	-84.50369331	36.42885328
47153	-85.4102441	35.37103725
06065	-115.9939021	33.74329781
13085	-84.17073385	34.44409815
13063	-84.35751271	33.54043935
41063	-117.1810198	45.57979758
20013	-95.56422358	39.8265096
05099	-93.30697684	33.66338522
05105	-92.93150636	34.947251
40009	-99.68042577	35.26792649
37141	-77.90598182	34.52447523
29163	-91.17165493	39.34397231
48217	-97.13216715	31.99059876
37129	-77.88474375	34.2322858
17185	-87.84368093	38.44634379
24039	-75.75887041	38.11381821
21119	-82.95432904	37.35406197
21125	-84.1176508	37.11047425
47159	-85.95654414	36.25023609
47167	-89.75925274	35.49692909
20125	-95.74280727	37.19252895
48119	-95.67114037	33.38664358
13167	-82.66017474	32.70148912
55041	-88.7705944	45.66756253
05077	-90.78211015	34.78064921
05117	-91.55194184	34.83010091
02013	-161.9642606	55.36032516
55079	-87.96698811	43.00700658
36117	-77.02965084	43.15652579
34005	-74.6680045	39.87782133
06001	-121.888612	37.64642367
21075	-89.18729157	36.55403726
47105	-84.31125324	35.73514674
21095	-83.21750489	36.85707442
46103	-102.8239659	44.00397449
48007	-96.99699873	28.11898396
47021	-87.08648326	36.26140435
21131	-83.38100797	37.0939886
21133	-82.85515105	37.12125569
26071	-88.53028044	46.20865908
27023	-95.56698141	45.0223965
02068	-150.0094238	63.67343339
02070	-158.2141634	59.79832305
02170	-149.5691006	62.31571716
55125	-89.51508258	46.05275508
37053	-76.00390334	36.40311519
29143	-89.65190483	36.59439853
30003	-107.4892228	45.42332459
45091	-81.18407852	34.9746458
45065	-82.30961363	33.89941841
35003	-108.4054839	33.91502948
29133	-89.29117001	36.82805484
39117	-82.79458938	40.52405935
40021	-94.99948708	35.90664273
45081	-81.72732002	34.00631213
37123	-79.90576665	35.3323375
39079	-82.61832518	39.01971543
30015	-110.4356833	47.88028152
30077	-112.936294	46.85654866
36039	-74.12279549	42.27638026
45073	-83.06576373	34.75329772
48423	-95.26908279	32.37521162
02282	-140.349186	59.88824845
48377	-104.2408125	29.99962168
34041	-74.99647914	40.85746195
31065	-99.91249504	40.17646227
40007	-100.4765456	36.74966893
27089	-96.3692954	48.35830232
42005	-79.46505466	40.81298372
42035	-77.63798759	41.23402092
18073	-87.11611118	41.02296853
13095	-84.21604918	31.53329476
21199	-84.57709045	37.10380837
23019	-68.64952115	45.40038149
22069	-93.09649471	31.72373065
29175	-92.49714212	39.44009232
40013	-96.26246372	33.96278604
36115	-73.430748	43.31320642
16025	-114.8053772	43.46356926
49051	-111.169609	40.33064897
27163	-92.88374367	45.03911139
05147	-91.24302721	35.18620495
13269	-84.25102911	32.55610793
13067	-84.57652963	33.94183776
08101	-104.5124892	38.17377693
72055	-66.91907543	17.98089603
18077	-85.43830308	38.78558559
18149	-86.6477887	41.28077022
27027	-96.49066248	46.89214202
20113	-97.64761598	38.39187087
16067	-113.6374976	42.85441649
40089	-94.77145458	34.1162239
39105	-82.02295352	39.08233336
01065	-87.62930576	32.7625948
48499	-95.38204393	32.78643978
05017	-91.29365079	33.2673446
05063	-91.56991638	35.74143554
48427	-98.73826312	26.56223662
54037	-77.86242458	39.30849565
51035	-80.73317673	36.73130704
53051	-117.2738324	48.53235595
13251	-81.61169117	32.75107817
36033	-74.30395769	44.59274379
36051	-77.77517835	42.72855751
72147	-65.43923326	18.12244435
48249	-98.08997801	27.73123346
46041	-100.8716993	45.15658384
46111	-98.09105658	44.02345807
54099	-82.42685819	38.14585251
51027	-82.03580207	37.26641332
06045	-123.3914743	39.44027921
22087	-89.53768188	29.8750922
22101	-91.44469375	29.70500764
45031	-79.95766082	34.33234414
45079	-80.90384361	34.02226754
41071	-123.3078799	45.23269019
35053	-106.9307263	34.00682919
22095	-90.47063317	30.12694792
47119	-87.0771147	35.6177569
48299	-98.68429358	30.70581617
51061	-77.80950815	38.7387071
48309	-97.20199931	31.5524976
53037	-120.679712	47.12448572
54057	-78.94327353	39.41464251
54059	-82.13519084	37.72729194
54109	-81.54940333	37.60951977
01007	-87.12681433	32.99837607
01039	-86.45142629	31.24861005
06059	-117.760976	33.70311134
09003	-72.73301048	41.80669859
20129	-101.7992367	37.19140392
21003	-86.19069857	36.75097491
15001	-155.5211676	19.60123507
22009	-92.001673	31.07634786
40075	-98.98054865	34.91625162
18009	-85.32478758	40.47378705
72121	-66.94446564	18.08307024
18055	-86.96223202	39.03630547
05093	-90.05430077	35.76420127
12035	-81.31358003	29.46163468
12039	-84.61383904	30.57930999
12053	-82.42535431	28.55404893
12133	-85.66575949	30.61054912
28143	-90.37532903	34.65198616
30085	-105.0162772	48.29447097
20021	-94.84624572	37.16921917
24047	-75.33389427	38.212837
25007	-70.65382633	41.39790643
46089	-99.221197	45.7662597
45069	-79.67845191	34.60180925
40059	-99.66696611	36.78871253
09013	-72.33642171	41.85510643
20169	-97.65012272	38.78394989
47039	-88.10830091	35.60350601
48415	-100.9162656	32.74614567
53043	-118.4186556	47.57605403
51075	-77.91594304	37.72200089
51135	-78.05127364	37.14201365
48067	-94.34317524	33.07772099
39147	-83.12759613	41.12378254
12065	-83.89500601	30.43779668
41009	-123.0888664	45.94376691
53035	-122.6734022	47.61342417
12127	-81.18197434	29.05852431
12131	-86.17009489	30.64341925
53069	-123.4247601	46.292422
30105	-106.6682222	48.3648329
54031	-78.85797558	39.00759684
47059	-82.84564638	36.17587226
37143	-76.4395049	36.20508496
35059	-103.4710696	36.48166105
32003	-115.0146087	36.21511541
01049	-85.80378574	34.46023769
01083	-86.98207203	34.81013487
08075	-103.1101132	40.72463929
12009	-80.73218698	28.29324349
45045	-82.37063974	34.89387815
13087	-84.5795682	30.87807864
13205	-84.19466894	31.22513235
13235	-83.47580638	32.23213302
28157	-91.3114768	31.16072415
28013	-89.33648515	33.9364711
28021	-90.91182829	31.9736924
54027	-78.61389875	39.31712105
47123	-84.25271451	35.44293343
30061	-114.9981923	47.1472918
54055	-81.11147554	37.40564762
08051	-107.0316959	38.66684745
08053	-107.3003579	37.82131615
23025	-69.95882156	45.51360259
06051	-118.8872447	37.93940061
50019	-72.24360335	44.82900254
54063	-80.55052779	37.5604155
47099	-87.39523632	35.21729152
28041	-88.63921416	31.21420839
28047	-89.11140872	30.50439082
54067	-80.79999513	38.2918799
72083	-66.98385766	18.2371973
72085	-65.86959716	18.18839957
54079	-81.90915525	38.5085024
53033	-121.8063614	47.49034831
53029	-122.5493921	48.16376089
48361	-93.89437408	30.12099964
51193	-76.80178124	38.11166934
51005	-80.00761323	37.78778327
49053	-113.5045338	37.28047916
38093	-98.95894925	46.97927215
34013	-74.24718209	40.78746195
35049	-105.9759986	35.50670942
13033	-82.00066679	33.0611801
46083	-96.7217084	43.27884092
47155	-83.52376973	35.78475751
01017	-85.39168915	32.91366622
19065	-91.84419994	42.8627134
51001	-75.63628772	37.76647217
48289	-95.9957025	31.29628413
17113	-88.84769482	40.49061752
16007	-111.3294847	42.28476453
13031	-81.74304725	32.39689006
32001	-118.3362581	39.58048345
02090	-146.5623662	64.8083752
40101	-95.37949187	35.61612948
40047	-97.78263254	36.3791609
13165	-81.96350449	32.79247176
21217	-85.32791474	37.36660665
28127	-89.9199315	31.9133629
17143	-89.75986508	40.78797055
37101	-78.36537336	35.51761602
19181	-93.56121354	41.33431116
48287	-96.96605425	30.31077667
30063	-113.9237814	47.03651185
06107	-118.8004216	36.22081997
51105	-83.12815503	36.70548431
06075	-122.4396708	37.75668116
08077	-108.4664844	39.01825229
06039	-119.7624357	37.21825802
36103	-72.84423227	40.87024178
27071	-93.78362729	48.24510754
46075	-100.6897488	43.96077423
51019	-79.52391814	37.31502696
50023	-72.61502314	44.27309445
51047	-77.95541958	38.48620048
48043	-103.2522656	29.81174561
53055	-122.9534631	48.57856326
06063	-120.8382348	40.00422172
13103	-81.34134143	32.3672031
28027	-90.60273114	34.22906962
19111	-91.47949968	40.64219925
55051	-90.24265966	46.26247657
54083	-79.87549565	38.77500824
51085	-77.49131526	37.76033617
39167	-81.49547648	39.45557887
53077	-120.7387387	46.45687521
53049	-123.7057228	46.55547971
16013	-113.980642	43.41242641
48479	-99.33173804	27.76103224
06015	-123.8971513	41.74323775
16069	-116.7498104	46.32729495
27077	-94.90489792	48.77043756
48095	-99.86428507	31.32686635
01019	-85.60387066	34.17588713
08021	-106.1911108	37.20059578
17151	-88.56128333	37.41325351
19053	-93.78630885	40.73762219
21039	-88.97055515	36.85297172
21091	-86.77804483	37.84153525
51069	-78.26241473	39.2045848
05041	-91.2539449	33.83346926
51195	-82.62118772	36.97556152
22065	-91.24181996	32.36512426
27135	-95.81112475	48.77485638
55013	-92.36769812	45.86286431
22115	-93.18373375	31.10800615
22031	-93.73783029	32.05510725
24017	-76.9921999	38.50706766
46063	-103.4943846	45.58027156
41059	-118.736681	45.59148273
28151	-90.94787195	33.28374517
04009	-109.8875198	32.93295414
40065	-99.41545292	34.58800041
08117	-106.1163363	39.63420352
36031	-73.77248171	44.11702035
55043	-90.70630534	42.86757481
22035	-91.2350757	32.73239582
41029	-122.728377	42.43216537
38001	-102.5285391	46.09690164
46019	-103.507491	44.905694
47091	-81.85180572	36.45484107
47163	-82.30419555	36.51291546
50017	-72.37674987	44.00552167
53009	-123.9277111	48.04911666
53005	-119.5113335	46.23976031
31091	-101.1354293	41.91586243
40131	-95.60476511	36.37196654
51145	-77.915315	37.55029696
51760	-77.47493293	37.53041663
53025	-119.4513964	47.20582642
53041	-122.3933441	46.57770709
48347	-94.61593169	31.6162358
36099	-76.82362358	42.78068586
39161	-84.58607604	40.8555416
13045	-85.07980892	33.58246933
12097	-81.14924253	28.06245875
51073	-76.54142204	37.41403941
13059	-83.36755873	33.95097841
51083	-78.93659955	36.76689258
13061	-84.97811756	31.62573219
08111	-107.6759098	37.7637698
48407	-95.1671992	30.57936685
66010	144.7724429	13.44160435
06067	-121.3445212	38.44881725
01125	-87.52558359	33.28952146
42125	-80.24855447	40.18935898
45055	-80.5903514	34.33859234
20161	-96.7350396	39.29629774
16011	-112.3976535	43.21643996
31021	-96.32857388	41.85154682
55001	-89.77038616	43.96955395
04019	-111.7896381	32.09723099
23021	-69.28442666	45.83789196
20171	-100.9066618	38.48220778
34009	-74.80053334	39.14901203
72107	-66.4354442	18.21446774
48469	-96.97135956	28.7960712
48293	-96.58095444	31.5454767
54081	-81.24873953	37.77126746
48121	-97.11685878	33.20528167
19149	-96.21424951	42.73735704
13073	-82.26371951	33.54404762
08115	-102.3519638	40.87598057
19157	-92.53097077	41.68657418
19129	-95.62136125	41.03348848
13091	-83.16860598	32.17208946
54053	-82.02651429	38.7698088
37075	-83.83311406	35.35024285
01131	-87.30786547	31.98928301
01099	-87.36529615	31.57107175
42051	-79.64746996	39.91984935
30011	-104.5359622	45.51700775
20179	-100.4418259	39.35018161
20201	-97.08751558	39.78417855
55031	-91.91618868	46.43292074
22021	-92.11667519	32.09226466
06097	-122.8872965	38.52842052
51041	-77.58654268	37.37880418
51139	-78.48428212	38.61983485
48401	-94.76183346	32.10819843
47035	-84.9986148	35.95070017
51161	-80.067514	37.26938285
48357	-100.8158413	36.27830534
19167	-96.17809424	43.08294203
48083	-99.45287706	31.77319682
08085	-108.2688129	38.4024194
48403	-93.85288661	31.34269549
12105	-81.69711072	27.94872638
13099	-84.90423978	31.32317406
51155	-80.71348404	37.0632927
54073	-81.1606194	39.37099538
01129	-88.20819419	31.40759248
51171	-78.57113544	38.85827071
28043	-89.80171673	33.76997916
22037	-91.04553925	30.8451603
48215	-98.18144326	26.39667226
19043	-91.34106377	42.84452651
27157	-92.23023021	44.28428259
22045	-91.73103405	29.89484111
47171	-82.43228458	36.11077416
37167	-80.25088954	35.31173842
51185	-81.56046571	37.12490124
05073	-93.60684679	33.24091819
08123	-104.3930144	40.55487277
48447	-99.21226795	33.17751417
39153	-81.53219101	41.12587569
48451	-100.4624522	31.40455473
17069	-88.26669526	37.51807977
13187	-84.00327535	34.57241644
13147	-82.96402556	34.35058893
48453	-97.78169164	30.33471479
29045	-91.73823977	40.41027674
29197	-92.5207783	40.47023216
30019	-105.5486488	48.78377804
30079	-105.3780231	46.86049013
54107	-81.51490057	39.21127634
54041	-80.50213826	38.99603963
12007	-82.16822073	29.94967764
51175	-77.10566044	36.72019409
29013	-94.34015625	38.25742352
22047	-91.3485086	30.25819586
17015	-89.93380816	42.06794659
19061	-90.88262627	42.46858503
19189	-93.73407175	43.3775066
12037	-84.82018866	29.8613762
12085	-80.43133534	27.07737178
08007	-107.0481757	37.19365584
13027	-83.57966245	30.84191162
13127	-81.53985797	31.23071711
05013	-92.50253376	33.55786388
05039	-92.65420664	33.96953994
13153	-83.66625831	32.45919716
12043	-81.1889838	26.95642237
39175	-83.3042663	40.84236699
13181	-82.451183	33.79324552
48465	-101.1521556	29.89249412
12057	-82.30867294	27.92948052
39051	-84.12943991	41.60183312
12023	-82.62162029	30.22445638
72001	-66.75351639	18.1796595
72019	-66.31070199	18.20096897
72021	-66.16878808	18.34837659
54005	-81.71114668	38.02264875
54035	-81.674543	38.83443006
72037	-65.65638154	18.25141544
21163	-86.21698223	37.96966338
21059	-87.08762263	37.73176143
24023	-79.27376451	39.52849306
46105	-102.4744037	45.49024355
39155	-80.76110735	41.31734436
12001	-82.35823348	29.67497355
05083	-93.71630518	35.21550403
53003	-117.2027907	46.19177089
56015	-104.353338	42.08772579
48485	-98.7035838	33.98806865
01035	-86.9938237	31.42899352
13207	-83.91905929	33.0139317
39059	-81.49400106	40.05191963
13219	-83.43706988	33.83506881
13221	-83.08144741	33.88064398
39017	-84.57607723	39.43897921
12086	-80.55914415	25.61511557
48503	-98.68790885	33.17659707
13319	-83.17090856	32.80234579
72043	-66.36025819	18.09702641
72049	-65.28334116	18.31378498
28091	-89.8225233	31.23086459
50005	-72.10243367	44.46487758
54023	-79.19584305	39.10496268
54093	-79.56567428	39.11375036
55101	-88.06111861	42.74731284
30073	-112.2266404	48.22793502
47147	-86.87047841	36.52536378
47013	-84.14937651	36.40334413
35039	-106.6929637	36.50984697
36059	-73.58622623	40.73761782
36075	-76.14177407	43.42718293
09011	-72.10232387	41.48708483
13259	-84.83395276	32.07839601
16071	-112.5395749	42.19490877
19195	-93.26085274	43.37747964
20131	-96.01393095	39.78343169
20103	-95.03795118	39.19957457
48505	-99.16858655	27.00076857
39035	-81.6587538	41.42426021
48239	-96.5775562	28.95369067
37073	-76.70046305	36.44475497
29035	-90.96231959	36.94111292
06113	-121.9015118	38.68648941
51199	-76.56191748	37.24271166
36079	-73.74940843	41.42650368
31173	-96.54400362	42.15819496
51820	-78.90109101	38.06830271
55045	-89.60216504	42.67994609
48491	-97.60120361	30.64812769
35001	-106.6705759	35.05121905
72129	-65.97552597	18.14792462
19127	-92.9990819	42.03586837
72127	-66.06170394	18.39080346
19131	-92.78887576	43.35639379
17057	-90.20749434	40.47248529
36063	-78.7453209	43.20013175
05079	-91.73333878	33.95753882
13007	-84.44486551	31.32631349
01101	-86.20787706	32.22089414
50007	-73.08101275	44.46109238
55093	-92.42212486	44.71909741
21135	-83.37804652	38.53155019
21047	-87.49033769	36.89391023
22119	-93.33431354	32.71375647
24021	-77.3978074	39.4720692
26029	-85.12921505	45.30562797
55011	-91.75475095	44.38005523
36089	-75.06907698	44.49647794
26141	-83.91721501	45.34035915
06055	-122.3306328	38.5065458
05089	-92.68397295	36.26842934
16029	-111.5621762	42.77049766
13271	-82.93880265	31.92997221
12047	-82.94763284	30.49612932
30109	-104.2490289	46.96556514
13229	-82.2134274	31.35837358
45041	-79.70224581	34.02447241
32029	-119.5289865	39.44660847
41005	-122.2205544	45.18820387
37125	-79.48151986	35.31080558
42065	-78.99967226	41.12829657
40049	-97.30937006	34.7044021
05015	-93.53832319	36.34107901
21107	-87.54131507	37.30862563
29123	-90.34465099	37.47823462
20017	-96.59423335	38.30203945
25009	-70.9515844	42.67174524
48057	-96.60474134	28.50349599
46011	-96.79064836	44.36981684
48443	-102.0764353	30.22490816
08031	-104.8760248	39.76129114
22067	-91.80211171	32.82009241
34027	-74.54440839	40.86163004
22071	-89.92833674	30.06918821
40033	-98.37225719	34.2900592
29065	-91.50772249	37.60643508
41051	-122.4157429	45.54693681
37019	-78.23791614	34.07037851
46093	-102.7166458	44.56667531
37083	-77.65158415	36.25737352
13075	-83.43069759	31.15408665
27143	-94.23165958	44.5793954
27061	-93.63162349	47.50907819
21207	-85.05838705	36.99115809
28125	-90.81343618	32.88000015
29029	-92.76600464	38.02703414
21099	-85.88446619	37.29970852
21025	-83.32358216	37.5214728
26065	-84.37346607	42.59737278
21203	-84.31621513	37.36491193
45029	-80.66691164	32.86353032
45043	-79.33242281	33.43337482
37033	-79.33355984	36.39327555
37049	-77.09255683	35.12343918
40113	-96.3983805	36.62910128
08027	-105.3670379	38.10882281
22073	-92.15486108	32.47822702
29153	-92.44469447	36.64922253
08005	-104.3385011	39.649919
29185	-93.77593289	38.03729132
30047	-114.0894823	47.64593461
48475	-103.1024815	31.50920785
30087	-106.7307531	46.22979285
13211	-83.49227858	33.5909479
42101	-75.13324284	40.00806441
38005	-99.36573478	48.06933808
47115	-85.62192494	35.1294263
20005	-95.31456305	39.53158751
26031	-84.50065611	45.44701265
21127	-82.73464321	38.06766833
27099	-92.75235164	43.67138759
27065	-93.29290464	45.94534057
29083	-93.7928174	38.38506942
31145	-100.477247	40.17604429
26069	-83.63669002	44.35578542
31043	-96.56465437	42.39108493
69100	145.2094218	14.15511852
72077	-65.90991264	18.22462653
40139	-101.4901113	36.74789073
05081	-94.2339787	33.70228691
31169	-97.59506372	40.17621044
31051	-96.86826909	42.49349461
29111	-91.72178943	40.09673548
36085	-74.15390987	40.58183643
34003	-74.07441147	40.96008351
08061	-102.7389041	38.43263854
48487	-99.24098891	34.08084256
36011	-76.55468471	42.91811235
08089	-103.7166632	37.90245342
48261	-97.69810806	26.92975017
40135	-94.75507825	35.49549888
26063	-83.03116796	43.83293286
37145	-78.9715773	36.38999755
18001	-84.93658249	40.7457744
47173	-83.83725225	36.28814616
17183	-87.73292603	40.18371674
48181	-96.67774905	33.62702927
08099	-102.3932762	37.95519022
46057	-97.18829593	44.67385954
49041	-111.8045988	38.74769427
51007	-77.9752747	37.33550025
51660	-78.87397667	38.43833151
48395	-96.51322902	31.02665136
40119	-96.97542338	36.07716359
54097	-80.23353247	38.8978057
29201	-89.56865798	37.05301351
36025	-74.96687059	42.19791446
29171	-93.01666575	40.47877624
30067	-110.5249953	45.48913245
28153	-88.69588404	31.64077954
34017	-74.07753388	40.73476975
13305	-81.91710568	31.55172562
08093	-105.7172304	39.11969049
41011	-124.0595871	43.17396579
48417	-99.35401337	32.73587756
48259	-98.7114161	29.94473189
05009	-93.09137415	36.30874792
48257	-96.2877972	32.59905385
48315	-94.3574341	32.79813996
05007	-94.25598718	36.33873798
34029	-74.28147189	39.88494891
22063	-90.72765311	30.44023061
01001	-86.64289976	32.53514228
01005	-85.39106787	31.87009042
26007	-83.62606894	45.03457851
26119	-84.12740152	45.02758285
32009	-117.632191	37.78456446
56043	-107.6823145	43.90437841
72035	-66.14868913	18.10378828
48207	-99.73037359	33.17823584
21219	-87.17903216	36.8358203
04011	-109.2401561	33.21537146
12115	-82.33141981	27.18432942
17033	-87.75932466	39.00382453
16083	-114.6681729	42.35608428
16041	-111.8131009	42.18121994
18151	-85.00106921	41.64408329
06029	-118.72959	35.34292819
05025	-92.18489948	33.89823609
51181	-76.90027517	37.10963661
51191	-81.95959909	36.72455999
49047	-109.517996	40.12501568
48419	-94.14557404	31.79223785
31117	-101.0603939	41.56796544
48183	-94.81675582	32.4801034
37043	-83.75018218	35.05771746
05033	-94.24296995	35.588841
05047	-93.89070916	35.51229968
36077	-75.03243898	42.63374775
42089	-75.33930212	41.05812363
36041	-74.49745908	43.66134129
48459	-94.94114818	32.73670474
26163	-83.28221321	42.28172038
26099	-82.93255517	42.69584067
20165	-99.30863983	38.52275276
72097	-67.33290558	18.18018788
20183	-98.78566877	39.78517466
60010	-170.657123	-14.27429395
72131	-66.97161064	18.32854209
17089	-88.42861217	41.93895003
19133	-95.95997093	42.05236881
18167	-87.38969715	39.43073114
19155	-95.54290277	41.33661346
21111	-85.65772828	38.18834895
21023	-84.08972896	38.68873502
37147	-77.37489067	35.59325583
39011	-84.22168058	40.56085701
27001	-93.4156134	46.60787445
40143	-95.94143178	36.12121947
13019	-83.22972091	31.27569067
29179	-90.96899002	37.36244864
22001	-92.41163568	30.29064732
22025	-91.84692484	31.66623485
31073	-99.83020279	40.51481965
48063	-94.97868645	32.97374349
22097	-92.00579532	30.59908084
36071	-74.30558896	41.40198158
40117	-96.69954973	36.31680135
36001	-73.97341306	42.59987237
28063	-91.03631739	31.73403632
47103	-86.58840969	35.14053022
69085	145.706722	17.86407261
72113	-66.613128	18.05756903
30005	-108.9584002	48.43208097
72095	-65.92250967	18.01814338
72091	-66.48979972	18.4199957
38019	-98.46469965	48.77240346
38011	-103.5205091	46.1127569
47025	-83.66072369	36.48575666
12077	-84.88318825	30.24145856
16017	-116.6009928	48.2996896
16035	-115.656021	46.67349275
17125	-89.91665526	40.23934407
28089	-90.03327096	32.63533895
28119	-90.28933634	34.25120737
17025	-88.49033998	38.75410733
21211	-85.19489586	38.21556092
17021	-89.27760111	39.54582799
13303	-82.79573433	32.96958544
31067	-96.68942195	40.26183622
17073	-90.13161776	41.35314875
25003	-73.2062907	42.37045737
48313	-95.92738963	30.96540306
51113	-78.27950884	38.41366284
48041	-96.30208322	30.66074221
48051	-96.62105771	30.49219576
51187	-78.20860922	38.90870136
48473	-95.98754906	30.01059467
38053	-103.3954265	47.74027674
18169	-85.79427017	40.84573494
20045	-95.29263542	38.88451412
20177	-95.75652721	39.04138192
32007	-115.3578839	41.14601583
18033	-84.99898798	41.39806132
22105	-90.40542519	30.62688036
22019	-93.35798129	30.22942198
55083	-88.26895246	45.02616558
72101	-66.42009023	18.31742228
37065	-77.59635385	35.91303781
78030	-64.94020272	18.34520973
13051	-81.13247732	32.00445256
12061	-80.60559316	27.69396994
16065	-111.6592182	43.78411982
51053	-77.63238876	37.07597757
17129	-89.80172848	40.02711636
06101	-121.6946189	39.03464654
20181	-101.7197684	39.35147377
17133	-90.17743157	38.27853951
13043	-82.07387018	32.40345007
08097	-106.9159345	39.21732141
51009	-79.14517223	37.60543548
40069	-96.66080537	34.31652004
48339	-95.50331613	30.30019889
40091	-95.66695805	35.37351598
40095	-96.76917298	34.02458841
40099	-97.06798798	34.48236468
40121	-95.74895216	34.92386502
01071	-85.99947584	34.77954231
18109	-86.44647098	39.48166964
29019	-92.30983436	38.99091068
51770	-79.95759159	37.27905915
37179	-80.53061478	34.98836835
06073	-116.7353982	33.03386576
37189	-81.69605652	36.23087329
18039	-85.85885682	41.59771704
60020	-169.5128067	-14.21923235
21179	-85.46601953	37.80489242
51157	-78.15943614	38.68461794
54085	-81.06312621	39.17806062
48383	-101.5232659	31.36607041
48177	-97.49248742	29.45652075
48247	-98.69730012	27.04354651
49031	-112.1276059	38.336223
17149	-90.88665915	39.62260409
51013	-77.10098204	38.87844605
48091	-98.2785174	29.80840142
47145	-84.52335538	35.84762955
21121	-83.8543202	36.89050509
21165	-83.59900123	37.94154655
48439	-97.29099289	32.77145377
26139	-85.9964531	42.95990607
46117	-100.7360867	44.41245198
05085	-91.88791683	34.75441172
17083	-90.3567923	39.0855748
39101	-83.1598587	40.58744702
19051	-92.41006563	40.74775139
13285	-85.02873581	33.03346388
06041	-122.7234103	38.07351203
08087	-103.8102221	40.26279879
38077	-96.94827807	46.26461801
13039	-81.67060271	30.93041791
33017	-71.02927319	43.29717653
36019	-73.67828248	44.74606721
30083	-104.5616375	47.78794828
21237	-83.49332409	37.73906786
39095	-83.65545282	41.62064794
45011	-81.43543848	33.26610854
45057	-80.7054154	34.68642517
47095	-89.49340328	36.33529914
37011	-81.92267092	36.07667708
19161	-95.10547892	42.38624071
24001	-78.69871136	39.62117263
48355	-97.61091925	27.72543779
46031	-101.1967817	45.7085132
06009	-120.554132	38.20478056
53031	-123.5935915	47.7490129
08015	-106.1940269	38.74728839
06033	-122.7532352	39.0996887
12083	-82.05662463	29.21028272
37165	-79.48032175	34.84114162
28011	-90.8802491	33.79549267
28141	-88.23908046	34.74037117
32019	-119.1886954	39.01991047
42073	-80.33434051	40.99133874
42039	-80.10676906	41.68442887
41045	-117.6231067	43.19355699
47183	-88.71817942	36.29822836
42015	-76.515651	41.78867556
41001	-117.6755473	44.70919815
30035	-112.9959167	48.70514099
08109	-106.2809773	38.08034572
08055	-104.9607082	37.68484082
13035	-83.95691187	33.28698774
13001	-82.28874491	31.749434
32005	-119.6162086	38.91213378
36107	-76.3061895	42.17034639
30053	-115.4051151	48.54246989
37121	-82.16391398	36.01324162
45001	-82.45872709	34.22269468
28093	-89.50306303	34.76229047
31105	-103.7149939	41.19760039
35037	-103.5493944	35.10459783
23031	-70.7143165	43.47829059
50025	-72.71377523	42.99053464
53057	-121.7319234	48.47967845
54095	-80.88510513	39.46568
01045	-85.611081	31.43204363
53015	-122.6802732	46.19321499
51800	-76.63944938	36.69549937
45023	-81.15923162	34.69173842
28109	-89.58952146	30.76882496
13317	-82.74345686	33.78219274
12095	-81.32311592	28.51429239
05097	-93.65944523	34.53888136
08121	-103.2015041	39.97109881
13155	-83.2762524	31.60235727
29157	-89.82456269	37.70718892
36045	-75.93125006	44.04796973
32033	-114.9015438	39.44238145
34001	-74.66040811	39.47790545
42017	-75.10684724	40.33694355
30059	-110.8856024	46.59797522
37037	-79.25545829	35.70266277
37097	-80.87332588	35.8068797
42061	-77.98140696	40.41688617
37017	-78.56283195	34.61418037
30013	-111.3474099	47.30823753
13025	-81.98175207	31.19714296
13315	-83.43204775	31.97280479
51700	-76.5199628	37.10553608
51091	-79.56866954	38.36239367
51810	-76.04367462	36.73349545
51165	-78.87581609	38.51221007
28149	-90.8514399	32.35637859
05045	-92.33201857	35.14732521
13183	-81.7454462	31.75246506
13231	-84.38908484	33.09206899
13113	-84.49428463	33.41303536
55063	-91.11543876	43.9066398
17119	-89.90510951	38.83016798
16057	-116.7117113	46.81645625
19143	-95.62422758	43.37868127
19057	-91.18142629	40.92294179
29033	-93.50521161	39.42694823
22049	-92.55780791	32.30210344
19101	-91.94862204	41.03165465
29223	-90.46144508	37.11262197
19153	-93.57365396	41.68547042
16077	-112.8410539	42.69368252
13005	-82.45269728	31.55377644
17081	-88.92397205	38.30019275
21155	-85.26954479	37.55262162
21143	-88.0827506	37.01910678
49025	-111.8879757	37.28527775
55105	-89.0712802	42.67118649
55061	-87.61509441	44.51638089
37183	-78.65050164	35.78982367
45071	-81.59990705	34.28974754
33013	-71.68059329	43.2975734
08049	-106.1184564	40.10246658
06007	-121.6008508	39.66681952
13071	-83.76886209	31.18832547
13199	-84.68849214	33.04118311
20209	-94.76482929	39.11438143
21235	-84.14488393	36.75824851
21035	-88.27216962	36.62088413
22051	-90.11275154	29.74131251
05069	-91.93189159	34.26882203
24025	-76.31717004	39.56126248
28051	-90.09171669	33.12367405
28007	-89.58086337	33.08676427
01123	-85.79746538	32.86280802
51051	-82.35094586	37.12613493
31115	-99.45440415	41.91371961
32015	-117.0390723	39.93361994
34035	-74.61645904	40.56375707
30045	-110.2659877	47.04516111
36113	-73.84603737	43.56091887
42107	-76.21642765	40.70586881
42041	-77.26523042	40.16350914
21151	-84.27808893	37.71989076
19183	-91.71758189	41.33548743
16047	-114.8116615	42.97094353
05071	-93.46000035	35.57001766
48141	-106.2352418	31.76884214
54071	-79.35069018	38.68040465
51021	-81.13059253	37.13389662
24043	-77.81329014	39.60413752
26011	-83.89498203	44.0651223
41053	-123.4132525	44.90338514
41017	-121.227881	43.91469217
30049	-112.3904537	47.12259745
27127	-95.25398841	44.40365018
16005	-112.2247491	42.6686619
17155	-89.28578933	41.2041567
21115	-82.831038	37.84737334
29075	-94.4096279	40.21170604
13079	-83.98612506	32.71431882
21153	-83.06414674	37.7063116
72149	-66.47175368	18.12824636
72061	-66.11368632	18.3439498
31161	-102.4088866	42.50454159
54025	-80.45282888	37.94721189
48411	-98.81731955	31.15502115
41019	-123.1658435	43.2796987
41035	-121.6500072	42.68605026
42045	-75.39915513	39.9166501
46021	-100.0517394	45.77126363
27103	-94.24751207	44.34987456
29195	-93.20185128	39.13696633
22033	-91.0956724	30.53801719
22077	-91.60044956	30.70893573
13273	-84.43693855	31.77710794
21097	-84.33134658	38.44203171
17105	-88.55786997	40.89167342
17167	-89.65883945	39.75818327
17203	-89.21080819	40.78829846
29219	-91.16024978	38.76446133
27155	-96.47144652	45.77230328
19085	-95.81703481	41.68336174
21063	-83.09731571	38.11810953
55099	-90.36154528	45.68054246
48101	-100.2787087	34.07767347
48019	-99.24640517	29.74699689
42127	-75.30318879	41.64851654
22029	-91.63992436	31.44577009
72141	-66.70280065	18.27147584
48307	-99.34743941	31.1988896
51031	-79.09657032	37.20561193
26159	-86.01839482	42.25166438
17087	-88.88074567	37.45959866
46065	-99.99599706	44.38906584
05135	-91.47928351	36.16124847
05131	-94.27397371	35.19943145
29073	-91.50783063	38.44075158
21051	-83.71435179	37.15962402
18021	-87.11576766	39.39291835
13129	-84.87632767	34.50374908
55019	-90.61207484	44.73483376
55057	-90.11372082	43.92432055
78010	-64.76357572	17.7334672
12107	-81.7442726	29.60884076
17165	-88.54119706	37.75332999
19001	-94.47105874	41.33075609
48137	-100.3050897	29.98273014
47107	-84.61781822	35.4243615
48405	-94.16790044	31.39477071
47041	-85.83288678	35.98021146
51121	-80.38642559	37.17483569
51029	-78.52851211	37.57196671
37055	-75.78245555	35.7632084
40141	-98.92460698	34.37312737
08069	-105.4615545	40.6665145
12073	-84.27761309	30.45806493
12045	-85.23056011	29.95068747
18025	-86.45126977	38.29202088
17013	-90.66743491	39.16895789
20033	-99.27105698	37.19121917
13137	-83.53054815	34.63090057
26049	-83.70652806	43.02216976
35045	-108.3206012	36.50824605
28045	-89.48847814	30.41595395
48341	-101.8930281	35.83769242
54043	-82.07055835	38.17536985
55103	-90.42949677	43.37567167
48203	-94.37105127	32.54840734
38089	-102.6550438	46.81078851
42033	-78.4740474	41.00013648
39097	-83.40012747	39.89429692
01089	-86.55056927	34.76292257
05139	-92.59770646	33.17125929
12101	-82.3964731	28.30833195
36105	-74.7681497	41.71624399
49019	-109.5698239	38.98190066
22103	-89.95737111	30.40987792
48071	-94.60850621	29.73846857
42111	-79.02838302	39.9723843
47093	-83.93759106	35.99332876
47127	-86.35914773	35.28548298
47187	-86.89830897	35.89405608
51023	-79.8119662	37.5570231
51109	-77.96275853	37.97807843
72067	-67.11577339	18.13495788
48143	-98.21770884	32.23614282
42055	-77.72158008	39.92745705
39005	-82.27061922	40.84592901
12059	-85.81424864	30.86794622
13253	-84.86850436	30.93897842
12089	-81.80190989	30.61062054
50027	-72.58619896	43.57967872
37095	-76.24647047	35.51917533
42103	-75.03337176	41.33189163
48323	-100.3147083	28.74262555
41041	-123.8682744	44.64147054
44007	-71.58004041	41.8721229
53075	-117.5229774	46.90119074
19071	-95.60475618	40.74556682
46137	-101.6659766	44.98058236
30027	-109.224376	47.2633104
13105	-82.83992664	34.11635114
17195	-89.91362191	41.75598396
18029	-84.97334479	39.14487647
17181	-89.25435617	37.47114082
21089	-82.92215371	38.5461641
22091	-90.71045886	30.82171866
41039	-122.8473327	43.93889441
05067	-91.21423884	35.59923757
47009	-83.92484736	35.68735498
41049	-119.5837591	45.41897957
39053	-82.31692618	38.82476088
45007	-82.63793115	34.5189668
30091	-104.5046932	48.72121163
15003	-157.9746934	21.45879706
29217	-94.34168569	37.84998285
18129	-87.86874523	38.02193911
22057	-90.41865517	29.55797842
25011	-72.59174125	42.58309231
48241	-94.02607231	30.74482946
02100	-135.5024208	59.11793896
30057	-111.9213142	45.30105558
28033	-89.99140222	34.8756938
31129	-98.04739392	40.17636285
27037	-93.06556878	44.67245057
27055	-91.49277553	43.67146528
29183	-90.67411979	38.78248212
08063	-102.60233	39.30507096
01031	-85.98828821	31.40188396
12087	-81.12021765	25.27277607
22023	-93.19458209	29.87556075
28121	-89.94594839	32.26422272
29089	-92.69630819	39.1425032
05107	-90.84810681	34.42853288
36061	-73.97166722	40.7721053
53061	-121.6977603	48.04772437
48001	-95.65255946	31.81341571
53063	-117.4039405	47.62077953
25015	-72.66378659	42.34022511
49013	-110.4255449	40.29770877
53027	-123.773048	47.14971004
41007	-123.6560294	45.99500314
08039	-104.1351629	39.2863996
31075	-101.740701	41.91528587
36095	-74.44200509	42.58814833
28083	-90.30095715	33.55070467
48025	-97.74102624	28.41736711
47007	-85.20533487	35.59663055
56019	-106.5849297	44.03996832
05129	-92.69933958	35.91115674
48165	-102.6353739	32.74057746
26009	-85.14135875	44.99904124
13301	-82.67696672	33.40868082
32031	-119.6643222	40.66566815
22121	-91.3125095	30.46264338
05115	-93.03400145	35.4476948
13261	-84.19615662	32.04008071
39099	-80.7763711	41.01467607
49033	-111.2445372	41.63204523
08067	-107.843327	37.28655123
48481	-96.22242975	29.2778845
48243	-104.1401726	30.71489092
55121	-91.35874906	44.30390193
08014	-105.0532651	39.95343909
08071	-104.0385309	37.31577175
08001	-104.3375808	39.87357077
51045	-80.21218409	37.48141832
27145	-94.61299658	45.55199481
13107	-82.30173104	32.58963191
47179	-82.49711101	36.293414
01093	-87.88740606	34.13691856
40061	-95.11606392	35.22501645
54015	-81.07502287	38.46270857
01029	-85.51786948	33.67495934
19173	-94.69599224	40.73748072
42059	-80.22298108	39.85389048
36081	-73.81734511	40.70829859
36065	-75.4358883	43.24167426
40087	-97.44298086	35.00888538
01095	-86.30615623	34.36690867
48291	-94.81225285	30.15161146
51079	-78.46704277	38.29731238
54011	-82.24144949	38.42049789
54061	-80.04558938	39.63024065
28163	-90.39655652	32.78007214
17003	-89.33759146	37.19162505
35035	-105.7417441	32.61323163
29097	-94.34047486	37.20351967
51510	-77.08548989	38.8171835
31093	-98.5166499	41.2200529
42063	-79.08763255	40.65207806
24013	-77.02256972	39.56320174
20055	-100.7376459	38.04405338
12113	-87.02194752	30.70016907
06099	-120.9979524	37.55851635
19117	-93.32780803	41.02958964
47175	-85.45359622	35.6961661
12109	-81.4405388	29.90168542
54103	-80.63834457	39.60550303
72025	-66.05078088	18.21191794
50013	-73.29488547	44.79689986
56045	-104.5674037	43.84031497
26027	-85.99403741	41.91545547
13299	-82.42364479	31.05375667
27021	-94.32573065	46.94877115
54091	-80.04598163	39.33588922
37103	-77.35562096	35.02185042
17071	-90.92497453	40.81804873
38105	-103.4801272	48.34373147
45049	-81.14110731	32.7764169
51650	-76.36333533	37.05573241
44009	-71.62328128	41.46943509
40093	-98.53456924	36.31174656
21071	-82.74545562	37.55729538
46107	-99.9571321	45.06449392
09009	-72.93235204	41.41072833
29189	-90.44344187	38.64048457
18183	-85.50505208	41.13932767
31039	-96.78730772	41.91637624
26157	-83.41747147	43.46515989
20087	-95.38360115	39.23530705
39029	-80.77709087	40.76853311
51095	-76.77717182	37.32794596
01115	-86.31476905	33.71540022
42069	-75.60919397	41.43666224
42013	-78.34882696	40.48075545
29137	-92.00087572	39.49588453
47177	-85.77914118	35.67900378
13257	-83.29303308	34.55397748
19193	-96.04432637	42.38966116
39025	-84.15193439	39.04742036
37047	-78.65514472	34.26573301
46095	-100.7598474	43.58135895
05027	-93.22737493	33.2142428
12103	-82.73164012	27.92895178
72111	-66.7212463	18.05966556
26147	-82.68083292	42.93188855
37071	-81.18014844	35.29432138
06047	-120.7175058	37.19189197
01009	-86.5670064	33.98087061
27073	-96.1738058	44.99583443
21085	-86.34376166	37.46094872
20041	-97.15266036	38.86611825
21223	-85.33714572	38.61269613
48331	-96.97728156	30.7861553
45025	-80.15867356	34.63979804
12017	-82.47793438	28.84873662
22075	-89.62329285	29.43435182
39145	-82.99326888	38.80404083
40085	-97.24422829	33.95005271
36111	-74.25878826	41.888126
21149	-87.26331417	37.52904105
48285	-96.93033343	29.38395052
17031	-87.81698762	41.84005007
37021	-82.53035424	35.6112775
21031	-86.68145677	37.20710749
47133	-85.28818727	36.34428251
37015	-76.9766892	36.0658315
34031	-74.30115633	41.03446344
01041	-86.31341907	31.73169775
01043	-86.86718877	34.13183982
28155	-89.28510404	33.61326385
31049	-102.3338627	41.111546
45017	-80.78101991	33.67482869
33003	-71.20268868	43.87378859
35019	-104.7904138	34.86315461
36087	-74.02389861	41.15225744
39163	-82.48545415	39.25106486
16087	-116.7847747	44.45250794
51057	-76.9520416	37.94303646
06049	-120.7251192	41.58969344
21139	-88.35351775	37.20997298
48061	-97.51397873	26.13427178
01025	-87.83077181	31.67695451
37135	-79.12071407	36.06127743
05005	-92.33686558	36.28715062
47011	-84.85962176	35.15369028
34037	-74.69082533	41.13935722
22059	-92.16043106	31.67707521
13123	-84.45574304	34.6914172
48353	-100.4060382	32.30390399
13295	-85.30084531	34.73561638
45047	-82.12646941	34.15414545
18053	-85.65468702	40.51587228
51097	-76.8965089	37.71951331
47003	-86.4596155	35.51388628
17177	-89.66268151	42.35166558
21209	-84.58344665	38.29156708
29151	-91.86178101	38.46015852
04017	-110.3213121	35.39960537
18127	-87.06793187	41.46066332
53045	-123.1920342	47.34793175
42099	-77.2618726	40.39865716
21185	-85.44866529	38.39974783
13047	-85.13865749	34.90377849
21077	-84.85966506	38.7573309
37099	-83.14111074	35.28733908
48077	-98.20837415	33.78558981
19099	-93.05376026	41.6860352
18071	-86.03756074	38.90634215
72053	-65.65965429	18.32347339
47049	-84.9326155	36.3805182
17161	-90.56755378	41.46753509
39111	-81.08267492	39.72753365
13209	-82.53452747	32.17325981
27035	-94.07070376	46.48265818
22039	-92.40566294	30.72890813
17179	-89.51334003	40.50758831
29207	-89.94436038	36.85565464
39123	-83.10923872	41.5370554
29147	-94.88335354	40.36098014
05087	-93.72465597	36.01103565
13237	-83.37315585	33.32175332
17145	-89.36728052	38.08436666
48455	-95.13547749	31.08828397
12079	-83.46989512	30.44431386
21213	-86.58284235	36.74196569
51163	-79.44774612	37.81505482
21043	-83.0504524	38.31813851
22043	-92.55919242	31.59947973
37137	-76.72927678	35.14691784
21049	-84.14820158	37.97054025
38055	-101.3219684	47.60697344
17127	-88.70754316	37.21923954
04001	-109.488754	35.39559896
29145	-94.33946172	36.90518568
13197	-84.52462573	32.35300898
48037	-94.42378182	33.44693757
18063	-86.50994544	39.76986908
21045	-84.92860405	37.32208002
40023	-95.55375412	34.0255707
34025	-74.22051128	40.2606812
13217	-83.85005873	33.55492575
13249	-84.31547114	32.26331654
01077	-87.65411658	34.9015002
47087	-85.67355848	36.35953777
56037	-108.8793882	41.6597625
48053	-98.18244138	30.78852336
29051	-92.28161601	38.50579587
20029	-97.64919278	39.48027303
51143	-79.39718973	36.82128716
26093	-83.9117077	42.60389287
39007	-80.74863402	41.70753004
01113	-85.18428296	32.28806204
26055	-85.56013503	44.66916098
26101	-86.05635345	44.33345321
16033	-112.3520136	44.28409003
08059	-105.2504738	39.58646067
21215	-85.32910919	38.03276996
47141	-85.49633518	36.14080321
01069	-85.30251402	31.15295179
17077	-89.38232705	37.78505462
05019	-93.17667235	34.05108285
51167	-82.09596509	36.93361023
33019	-72.22243767	43.36150987
05059	-92.94560125	34.31751189
47017	-88.45060499	35.97307462
46027	-96.97560307	42.91461976
49001	-113.2353778	38.35770202
48197	-99.74572968	34.29029034
13287	-83.62479675	31.7164981
48187	-97.9484645	29.58321407
54105	-81.37885705	39.02235059
27015	-94.727558	44.24201356
72087	-65.9002482	18.42701557
17085	-90.21246462	42.36542788
31177	-96.22188779	41.53110052
47125	-87.38247263	36.49650951
55119	-90.50164471	45.21158608
20073	-96.23264864	37.87744513
21105	-88.97605071	36.67806433
26061	-88.68742993	46.89801075
51025	-77.85881453	36.76457633
26149	-85.52810068	41.91439741
40145	-95.52115154	35.96138606
16045	-116.3979457	44.0602805
26005	-85.88845897	42.59147142
51093	-76.72465523	36.89191765
50011	-72.9120833	44.85745972
25017	-71.39262102	42.48584344
29099	-90.53780688	38.26079127
24035	-76.0237387	39.06631908
21101	-87.57345471	37.79602818
27141	-93.77496918	45.44403172
13125	-82.61046209	33.22935427
02060	-156.7026695	58.74220214
39057	-83.88969073	39.69132786
05137	-92.15689859	35.86003074
42091	-75.36722689	40.21085251
39019	-81.08973346	40.579572
05021	-90.41718919	36.36822542
37025	-80.55133048	35.38756942
01109	-85.94087373	31.80232564
42011	-75.92604322	40.41644424
45015	-79.95087397	33.19764043
48389	-103.6930786	31.32283311
48489	-97.65724482	26.47040624
05101	-93.2178649	35.91979049
40019	-97.28589218	34.25090173
48225	-95.42200282	31.31764204
01105	-87.29424703	32.63859284
54049	-80.24323834	39.51008055
72063	-65.97856259	18.26586955
51087	-77.40505652	37.53796421
17193	-88.18016372	38.08714445
40079	-94.70338293	34.90011477
36119	-73.75591281	41.16176335
55007	-91.20077484	46.52418284
53039	-120.7895031	45.87361546
53011	-122.4823115	45.77919832
22085	-93.55521453	31.56283023
39001	-83.47239908	38.84544021
31103	-99.71213247	42.87883323
31107	-97.89176183	42.63684531
13185	-83.26738819	30.83391096
12029	-83.15870461	29.60806814
18017	-86.34620721	40.76165964
26091	-84.06641246	41.89469406
72003	-67.17524655	18.36039221
72013	-66.6740025	18.40653954;

set	pd		Port districts /
	NJ_Newk		"Newark, NJ",
	NC_Char		"Charlotte, NC",
	NY_Jama		"Jamaica, NY"
	MD_Balt	  	"Baltimore, MD",
	MA_Bost	  	"Boston, MA",
	NY_Buff	  	"Buffalo, NY",
	SC_Char	  	"Charleston, SC",
	IL_Chic	  	"Chicago, IL",
	OH_Clev	  	"Cleveland, OH",
	OR_Colu	  	"Columbia-Snake, OR",
	TX_Dall	  	"Dallas-Fort Worth, TX",
	MI_Detr	  	"Detroit, MI",
	MN_Dulu	  	"Duluth, MN",
	TX_ElPa	  	"El Paso, TX",
	MT_Grea	  	"Great Falls, MT",
	TX_Hous	  	"Houston-Galveston, TX",
	TX_Lare	  	"Laredo, TX",
	CA_LosA	  	"Los Angeles, CA",
	FL_Miam	  	"Miami, FL",
	WI_Milw	  	"Milwaukee, WI",
	MN_Minn	  	"Minneapolis, MN",
	AL_Mobi	  	"Mobile, AL",
	LA_NewO	  	"New Orleans, LA",
	NY_NewY	  	"New York City, NY",
	AZ_Noga	  	"Nogales, AZ",
	VA_Norf	  	"Norfolk, VA",
	NY_Ogde	  	"Ogdensburg, NY",
	ND_Pemb	  	"Pembina, ND",
	PA_Phil	  	"Philadelphia, PA",
	TX_PrtA	  	"Port Arthur, TX",
	ME_Port	  	"Portland, ME",
	RI_Prov	  	"Providence, RI",
	CA_SanD	  	"San Diego, CA",
	CA_SanF	  	"San Francisco, CA",
	GA_Sava	  	"Savannah, GA",
	WA_Seat	  	"Seattle, WA",
	VT_StAl	  	"St. Albans, VT",
	MO_StLo	  	"St. Louis, MO",
	FL_Tamp	  	"Tampa, FL",
	DC_Wash	  	"Washington, DC",
	NC_Wilm	  	"Wilmington, NC"/;

table pdloc(pd,latlon) 

		lat	lon
	NJ_Newk 40.7357 -74.1724
	NC_Char	35.2271 -80.8431
	NY_Jama	40.7037 -73.7992 
	MD_Balt	39.2833	-76.6167
	MA_Bost	42.3581	-71.0636
	NY_Buff	42.8877	-78.8794
	SC_Char	32.7831	-79.9344
	IL_Chic	41.8832	-87.6324
	OH_Clev	41.4822	-81.6697
	OR_Colu	45.8919	-122.8133
	TX_Dall	32.7630	-97.0326
	MI_Detr	42.3329	-83.0478
	MN_Dulu	46.8000	-92.1000
	TX_ElPa	31.7903	-106.4233
	MT_Grea	47.5036	-111.2864
	TX_Hous	29.2811	-94.8258
	TX_Lare	27.5244	-99.4906
	CA_LosA	34.0522	-118.2433
	FL_Miam	25.7751	-80.1947
	WI_Milw	43.0500	-87.9500
	MN_Minn	44.9833	-93.2667
	AL_Mobi	30.6889	-88.0448
	LA_NewO	29.9518	-90.0746
	NY_NewY	40.7130	-74.0072
	AZ_Noga	31.3419	-110.934
	VA_Norf	36.8508	-76.2858
	NY_Ogde	44.7000	-75.4833
	ND_Pemb	48.9664	-97.2453
	PA_Phil	39.9500	-75.1667
	TX_PrtA	29.8850	-93.9400
	ME_Port	43.6592	-70.2565
	RI_Prov	41.8245	-71.4127
	CA_SanD	32.7150	-117.1625
	CA_SanF	37.7749 -122.4194
	GA_Sava	32.0167	-81.1167
	WA_Seat	47.6032	-122.3303
	VT_StAl	44.8108	-73.0835
	MO_StLo	38.6167	-90.1333
	FL_Tamp	27.9474	-82.4588
	DC_Wash	38.9072 -77.0369
	NC_Wilm	34.2233	-77.9122;


set	c(fips)		Counties for which we have both coordinate and GDP;
c(fips) = yes$min(round(gdp(fips)),round(loc(fips,"lon")),round(loc(fips,"lat")));

set	missing(fips)	Missing counties;
missing(fips) = fips(fips)$(not c(fips));

*	Don't worry about the locations which are not counties:

missing(fips)$( (ord(fips.tl,3)=ord("0",1)) and 
		(ord(fips.tl,4)=ord("0",1)) and 
		(ord(fips.tl,5)=ord("0",1)) )  = no;

option missing:0:0:1;
display missing;

set	cmap(fips,st)	Mapping from county to state;
cmap(c,st) = fips(c)$((ord(c.tl,1)=ord(st.tl,1)) and (ord(c.tl,2)=ord(st.tl,2)));
option cmap:0:0:1;
display cmap;

parameter	stategdp(st)	State GDP;
stategdp(st) = sum(cmap(c,st),gdp(c));
option stategdp:0:0:1;
display stategdp;

parameter	theta(fips,st)	County share of state GDP;
theta(cmap(c,st)) = gdp(c)/stategdp(st);

parameter	r			Radius of the earth (miles) /3949/
		dist(usps,*)		Distance state to port and state to state;

$macro lamda(c)		(pi * loc(c,"lon") / 180)
$macro phi(c)		(pi * loc(c,"lat") / 180)

$macro lamda1(c)	(pi * loc(c,"lon") / 180)
$macro phi1(c)		(pi * loc(c,"lat") / 180)

$macro lamda2(pd)	(pi * pdloc(pd,"lon") / 180)
$macro phi2(pd)		(pi * pdloc(pd,"lat") / 180)

alias (c,c1,c2), (usps,s1,s2), (st,st1,st2),(cmap,c1map,c2map),(stmap,stmap1,stmap2);

loop((usps,pd),
  dist(usps,pd) = sum((stmap(usps,st),cmap(c,st)), theta(c,st) * 
	r*arccos(sin(phi1(c))*sin(phi2(pd)) +
		 cos(phi1(c))*cos(phi2(pd)) * cos(abs(lamda1(c)-lamda2(pd)))));
);

file kcon /"con:"/; kcon.lw=0; put kcon /;

loop(s1,
  putclose 'Calculating distances for ',s1.tl/;
  loop(s2,
    dist(s1,s2) = sum((stmap1(s1,st1),stmap2(s2,st2),c1map(c1,st1),c2map(c2,st2))$(not sameas(c1,c2)), 
	theta(c1,st1) * theta(c2,st2) * 
	r*arccos(sin(phi(c1))*sin(phi(c2)) +
		 cos(phi(c1))*cos(phi(c2)) * cos(abs(lamda(c1)-lamda(c2)))));
));
option dist:0:0:1;
display dist;

parameter	stloc(usps,latlon)	State locations (based on GDP-weighted county locations);
stloc(usps,latlon) = sum((stmap(usps,st),cmap(c,st)),theta(c,st)*loc(c,latlon));

execute_unload 'geography.gdx',stloc,dist;
