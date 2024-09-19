program readsgf

	character :: s*2,type*1,cty*3,unit*6,item*3,amt*12,yr*4,imp*1
	open(10,file='2021FinEstDAT_06122023modp_pu.txt')
	do
	  read(10,'(a2,a1,a3,a6,a3,a12,a4,a1)',end=100) s,type,cty,unit,item,amt,yr,imp
	end do
100	close(10)

end program readsgf