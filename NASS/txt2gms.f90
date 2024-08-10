program txt2gms
	use f90hash
	implicit none
	character(65536) :: record
	character :: tab=char(9), chr
	character(256), allocatable :: field(:), header(:)
	integer, allocatable :: indx(:),cc(:)
	logical, allocatable :: col(:)
	character(256) :: ds,dsout,fmt,txtfile,gmsfile,datfile,indices,valstr
	logical :: ondisk
	integer :: ktxt,kgms,kdat,nc,nr,ncol,ir,irlog
	integer :: ic,jc,kc,i,j,k,kcmax,value,file_size
	type hash_table_list
		type (hash_table), pointer :: h
		character(256), allocatable :: str(:)
		integer :: nstr
	end type
	integer :: item, ht_size
	integer, parameter :: primes(9)= (/50021, 99139, 333667, 524827, &
                1299877, 2000003, 4000079, 6026179, 8034709 /)
	type(hash_table_list), pointer :: hti(:)
	type(hash_table), pointer :: h

	call get_command_argument(1,ds)
	call get_command_argument(2,dsout)
	call get_command_argument(3,indices)
	call get_command_argument(4,valstr)

	write(*,'(a)') '------------------------------'
	write(*,'(a)') 'ds='//trim(ds)
	write(*,'(a)') 'dsout='//trim(dsout)
	write(*,'(a)') 'indices='//trim(indices)
	write(*,'(a)') 'value='//trim(valstr)
	write(*,'(a)') '------------------------------'

	txtfile = trim(ds)//'.txt'
	gmsfile = trim(dsout)//'.gms'
	datfile = trim(dsout)//'.dat'

	inquire(file=txtfile,size=file_size,exist=ondisk)
	if (.not.ondisk) then
	  write(*,'(a)') 'Cannot find file: '//trim(txtfile)
	  call exit(-1)
	end if

	read(valstr,*) value 

	ktxt=10
	kdat=11
	kgms=12
	open(ktxt,file=txtfile)
	open(kgms,file=gmsfile)
	open(kdat,file=datfile)
	write(kdat,'(a)') '$eolcom !','$offlisting'

!	Read one record and count columns:

	read(ktxt,'(a)') record
	nc = 1
	do i=1,len_trim(record)
	  if (record(i:i).eq.tab) nc = nc + 1
	end do

!	Estimate file size:

!	Compiler returns a negative number for file size,
!	seemingly an unsigned integer.  Ugh!  

!	Check number of characters for the first 10 
!	data records:

	j = 0
	do i=1,10
	  read(ktxt,'(a)') record
	  j = j + len_trim(record)
	end do
	file_size = iabs(file_size)
	nr = nint(file_size/(j/10.0))

!	Size the hash table:

	ht_size = 0
	do i=1,size(primes)
          if (2*nr.lt.primes(i)) then
	    ht_size = primes(i)
	    exit
	  endif
	end do
	if (ht_size==0) ht_size = primes(size(primes))

!	Allocate worksapce for data:

	allocate(field(nc),header(nc),indx(nc),hti(nc),col(nc))

!	Parse the column list:

	col(:) = .false.
	ncol = 0
	ic=1
	i = index(indices,',')
	kcmax = 0
	do while (ic.lt.len_trim(indices))
	  if (i.gt.0) then
	    jc = ic + i - 1 
	  else
	    jc = len_trim(indices)
	  end if
	  kc = kc + 1
	  read(indices(ic:jc),*) j
	  if (col(j)) then
	    write(*,'(a,i0)') 'Indices include duplicate references to ',j
	    goto 3000
	  endif 
	  col(j) = .true.
	  ncol = ncol + 1
	  kcmax = max(kcmax,j)
	  ic = jc + 1
	  i = index(indices(ic:),',') 
	end do

!	Keep a compact list of items to output:

	allocate (cc(ncol))
	kc=0
	do ic=1,nc
	  if (col(ic)) then
	    kc = kc + 1
	    cc(kc) = ic
	  end if
	end do

!	Add a value column?  This does not enter cc, as it does not add indices.

	if (value.gt.0) then
	  if (col(value)) then
	    write(*,'(a,i0)') 'Value column cannot be an index.'
	    goto 3000
	  endif 
	  col(value) = .true.
	  kcmax = max(value,kcmax)
	end if

!	Set up a hash table for each column we are reading:

	allocate(hti(nc))
	do i=1,nc
	  if (.not.col(i)) cycle
	  allocate(hti(i)%h)
	  allocate(hti(i)%str(nr))
	  h => hti(i)%h
	  allocate(h%ht(0:ht_size-1))
	  h%nstring=0
	  h%inserted=0
	end do

!	Generate format string for writing indices and value:

	write(fmt,'(a,i0,a)') '(',(ncol-1),'(i0,1h.),i0,a)'

!	Read the data:

	rewind(ktxt)
	ir = 0
	irlog = 100
	do 
	  ir = ir + 1
	  read(ktxt,'(a)',end=2000) record

!	Debug with rapid response:

!	  if (ir.gt.10) goto 2000

!	Update the status:

	  if (ir.eq.irlog) then
	    write(*,'(a,i0)') 'Read record ',ir
	    if (irlog.lt.1000000) then
	      irlog = 10 * irlog
	    else
	      irlog = irlog + 1000000
	    endif
	  endif

!	Parse:

	  field(:) = ' '
	  ic = 1
	  kc = 0
	  i = index(record(ic:),tab)

	  do while (ic.lt.len_trim(record))
	    if (i.gt.0) then
	      jc = ic + i - 1 
	    else
	      jc = len_trim(record)
	      if (jc.lt.nc) write(*,'(3(a,i0),a)') 'Only ',(kc+1),&
		' column(s) in row ', ir,' while ',nc,' header columns.'
	    end if
	    kc = kc + 1

	    if (kc.gt.kcmax) exit

	    if (kc.gt.nc) then
	      write(*,'(2(a,i0),a)') 'Extra column(s) in row ',&
		ir,'.  Counted ',nc,' header columns.'
	      exit
	    end if

	    if (col(kc)) field(kc) = record(ic:jc-1)
	    ic = jc + 1
	    i = index(record(ic:),tab) 
	  end do

	  if (ir.eq.1) then
	    header(:) = field(:)	     
	    write(*,'(a,i0)') 'Columns in file     :   ',nc
	    write(*,'(a,i0)') 'Rows in file (est.) :   ',nr
	    write(*,'(a,i0)') 'Indices to process  :   ',ncol
	    do i=1,ncol
	      write(*,'(i0,t10,a,i0,t20,a)')  i,'Column: ',cc(i),' = '//trim(header(cc(i)))
	    end do
	    if (value.gt.0) write(*,'(a,t10,a,i0,a)') 'Value','Column: ',value,' = '//trim(header(value))
	    write(*,'(a)') 'Hit any key to continue.  Ctrl-C to abort.'
	    read(*,*)
	    cycle
	  end if

!	Hash these labels:

	  do i=1,nc
	    if (.not.col(i) .or. i.eq.value) cycle
	    h => hti(i)%h
	    indx(i) = ht_id(field(i),h)
	    if (indx(i).eq.0) then
	      indx(i) = ht_insert(field(i),h)
	      hti(i)%str(indx(i)) = field(i)
	      hti(i)%nstr = indx(i)
	    end if
	  end do

	  valstr = ' '
	  if (value.gt.0) call editvalue(field(value),valstr)

!	Output indices and value string (which is blank if value=0)

	  write(kdat,fmt) (indx(cc(i)),i=1,ncol),'  '//trim(valstr)

	end do

!	Finish up the GAMS code with set definitions:

2000	continue

	do k=1,ncol
	  i = cc(k)
	  if (.not.col(i) .or. i.eq.value) cycle
	  h=>hti(i)%h
	  write(kgms,'(a,i0,a)') 'set i',k,' "'//trim(header(i))//'" /'
	  do j=1,hti(i)%nstr
	    write(kgms,'(3x,i0,t10,a)') j, '"'//trim(hti(i)%str(j))//'"'
	  end do
	  write(kgms,'(a//)') '  /;'
	end do

	write(fmt,'(a,i0,a)') '(a,',(ncol-1),'(1hi,i0,1h,),1hi,i0,a)'
	if (value.eq.0) then
	  write(kgms,fmt) 'set indicies(',(i,i=1,ncol),' ) /'
	else
	  write(kgms,fmt) 'parameter values(',(i,i=1,ncol),' ) /'
	end if
	write(kgms,'(a)') '$include %system.fn%.dat','/;'

3000	close(ktxt)
	close(kdat)
	close(kgms)

contains

	subroutine editvalue(string,valstr)
	character(256) :: string, valstr
	logical :: numeric
	real :: value
	integer :: ic,jc,ierr
	character(18) :: numchr = '-+DEde0123456789. '
	jc = 0
	valstr = ' '

!	Remove commas:

	do ic=1,len(string)
	  if (string(ic:ic).ne.",") then
	    jc = jc + 1
	    valstr(jc:jc) = string(ic:ic)
	  end if
	end do

!	See the remaining characters are recognized:

	numeric = .true.

	do ic=1,len_trim(valstr)
	  if (index(numchr,valstr(ic:ic)).eq.0) then
	    numeric = .false.
	    exit
	  endif
	end do

!	Finally, see that we can read a value with Fortran:

	if (numeric) then
	  read(valstr,*,iostat=ierr) value
	  if (ierr.ne.0) then
	    write(*,'(a,i0)') '('//trim(string)//') has read error '//trim(valstr)//', ierr=',ierr
	    numeric = .false.
	  endif
	endif
	if (.not.numeric) valstr = 'NA'

!	Add a trailing comment if the value string has been edited:

	if (string.ne.valstr) valstr = trim(valstr)// ' ! '//trim(string)

	return
	end 

end program txt2gms
