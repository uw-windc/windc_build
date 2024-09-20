program translate
	character :: fips*3, code*3, yr*2
	integer :: i
	real :: r

	open(10,file='2021\21statetypepu.txt')
	open(11,file='2021\21statetypepu.gms')
	do
	  read(10,'(a3,1x,a3,i13,f12.2,1x,a2)',end=200) fips,code,i,r,yr
	  write(11,'(a,i13,f12.2)') trim(fips)//'.'//trim(code)//'.'//trim(yr), i, r
	end do

200	close(10)
	close(11)
end program translate