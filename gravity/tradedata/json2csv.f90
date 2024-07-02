program json2csv
	implicit none
	character(len=1024) :: record
	character(len=16) :: header
	integer :: ir, ic

	call get_command_argument(1,header)

	open(10,file="export1.csv")
	open(11,file="json2csv.out")

	write(*,'(a)') 'header='//trim(header)

	ir = 0
	do
	  ir = ir + 1
	  if (.not.(trim(header).eq.'no' .and. ir.eq.1)) then
	    read(10,'(a)',end=100) record
	    ic = index(record,'[[')
	    if (ic.gt.0) record(ic:) = record(ic+2:)
	    ic = index(record,'[')
	    if (ic.gt.0) record(ic:) = record(ic+1:)
	    ic = index(record,'],')
	    if (ic.gt.0) record(ic:) = record(ic+2:)
	    ic = index(record,']]')
	    if (ic.gt.0) record(ic:) = record(ic+2:)
	    write(11,'(a)') trim(record)
	  end if
	end do
100	close(10)
	close(11)
end program json2csv	  