@echo off
set path=c:\Users\Thomas F. Rutherford\AppData\Local\quickstart_fortran\mingw64\bin;%path%

gfortran -m64  -fbacktrace -fbounds-check  -c f90hash.f90
gfortran -m64  -fbacktrace -fbounds-check  -c txt2gms.f90
gfortran -static-libgfortran txt2gms.o f90hash.o -o txt2gms.exe

pause

:	Read the data from here: https://www.nass.usda.gov/datasets/qs.census2022.txt.gz

txt2gms qs.census2022 countynames 21,22 0
pause

txt2gms qs.census2022 dataset 4,10,11,12,16,21 38

goto :eof


gfortran -m64  -c f90hash.f90
gfortran -m64  -c txt2gms.f90
gfortran -static-libgfortran txt2gms.o f90hash.o -o txt2gms.exe
