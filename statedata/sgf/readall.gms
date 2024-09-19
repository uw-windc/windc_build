$call start https://www2.census.gov/programs-surveys/state/tables/2022/2022%20ASFIN%20State%20Totals.xlsx
$exit

set	yr /1997/;
file kput; kput.lw=0; put kput;
loop(yr,
	put_utility 'shell' /
	'start "https://www2.census.gov/programs-surveys/state/tables/',yr.tl,'/',yr.tl,'%20ASFIN%20State%20Totals.xlsx"'
);

$exit




$exit

$label xlsx2gdx

$call gdxxrw i=2022.xlsx o=2022.gdx par=ASFIN rng=2022 ASFIN State Totals!a1..az83

$exit


*.$goto xlsx2gdx

