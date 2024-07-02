@echo off
echo	Processing exports
start "exports.csv" curl -o exports.csv "https://api.census.gov/data/timeseries/intltrade/exports/porths?&get=E_COMMODITY,E_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,ALL_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"
echo	Processing import
start "imports.csv" curl -o imports.csv "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=I_COMMODITY,I_COMMODITY_SDESC,CTY_CODE,CTY_NAME,PORT,PORT_NAME,GEN_VAL_YR&key=e3b8cac7e35a4256d4eeacf6d45a5a58a5e70d5e&YEAR=2017&MONTH=12&COMM_LVL=HS6&SUMMARY_LVL"

