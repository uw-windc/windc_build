@echo off
gfortran -c json2csv.f90
gfortran -static-libgfortran json2csv.o -o json2csv.exe

