@echo off

set f=import
if exist %f%s.csv del %f%s.csv

pause

powershell -Command "(gc %f%1.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"

powershell -Command "(gc %f%2.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"

powershell -Command "(gc %f%3.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"

powershell -Command "(gc %f%4.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"

powershell -Command "(gc %f%5.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"

powershell -Command "(gc %f%6.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"

powershell -Command "(gc %f%7.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"

powershell -Command "(gc %f%8.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"

powershell -Command "(gc %f%9.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"

powershell -Command "(gc %f%0.csv) -replace '\[', '' | Out-File -encoding ASCII tmp.txt"
powershell -Command "(gc tmp.txt) -replace '\],', '' | Add-Content -encoding ASCII %f%s.csv"
