@echo off
echo	Processing export1
curl -o exports.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
goto :eof

echo	Processing export1
curl -o export1.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=1*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing export2
curl -o export2.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=2*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing export3
curl -o export3.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=3*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing export4
curl -o export4.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=4*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing export5
curl -o export5.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=5*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing export6
curl -o export6.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=6*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing export7
curl -o export7.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=7*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing export8
curl -o export8.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=8*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing export9
curl -o export9.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=9*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing export0
curl -o export0.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY=0*,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"

