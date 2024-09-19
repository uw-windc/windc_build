program readsgf

	character :: fn*64,s*2,type*1,cty*3,unit*6,item*3,amt*12,yr*4,imp*1
	fn = '2021FinEstDAT_06122023modp_pu'
	open(10,file=trim(fn)//'.txt')
	open(11,file=trim(fn)//'.gms')
	do
	  read(10,'(a2,a1,a3,a6,a3,a12,a4,a1)',end=100) s,type,cty,unit,item,amt,yr,imp
	  write(11,'(a)') s//'.'//type//'.'//cty//'.'//unit//'.'//item//'.'//yr//'.'//imp//' '//trim(amt)
	end do
100	close(10)
	close(11)

end program readsgf