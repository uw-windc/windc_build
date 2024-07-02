@echo off
call start "census" gams censusmaps r=alt --mkt=census	o=census.lst	gdx=census
call start "agcensus" gams censusmaps r=alt --mkt=agcensus	o=agcensus.lst	gdx=agcensus	
call start "bilateral" gams bilateral  r=alt			o=bilateral.lst	gdx=bilateral
call start "pooled" gams pooled     r=bilatgravity		o=pooled.lst	gdx=pooled
title "national" 
gams national   r=alt			o=national.lst	gdx=national