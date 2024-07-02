@echo off
echo	Processing import
curl -o imports.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"

goto :eof

echo	Processing import1
curl -o import1.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
goto :eof
echo	Processing import2
curl -o import2.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY=2*,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing import3
curl -o import3.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY=3*,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing import4
curl -o import4.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY=4*,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing import5
curl -o import5.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY=5*,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing import6
curl -o import6.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY=6*,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing import7
curl -o import7.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY=7*,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing import8
curl -o import8.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY=8*,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing import9
curl -o import9.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY=9*,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing import0
curl -o import0.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY=0),I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
