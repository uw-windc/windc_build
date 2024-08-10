!       module f90hash  Hashing routines
!               * funtion ht_insert(str,h)
!               * function ht_id(str,h)  
!               * subroutine ht_deallocate(h)

module f90hash
implicit none

private
public  ht_insert, ht_id, ht_deallocate, hash_table

type hash_element_type
  character (len=:), allocatable        :: str
  integer, pointer                      :: id => null()
  integer(kind=8)                       :: hash
  type(hash_element_type), pointer      :: next=>null()
end type

type hash_table
        integer      :: nstring = 0
        integer      :: inserted = 0
        type(hash_element_type), allocatable :: ht(:)
end type

contains

subroutine joaat_hash(key,h,hash,hash_index) 
  character(len=*), intent(in)  :: key
  type(hash_table)              :: h
  integer(kind=8),  intent(out) :: hash
  integer                       :: hash_index
  integer(kind=8), parameter    :: b32 = int8(2)**32-int8(1)
  integer                       :: i

  hash=int8(0)
  do i=1,len_trim(key)
     hash=iand(hash+ichar(key(i:i))                ,b32)
     hash=iand(     hash+iand(ishft(hash,10),b32)  ,b32)
     hash=iand(ieor(hash,iand(ishft(hash,-6),b32)) ,b32)
  enddo
  hash=iand(     hash+iand(ishft(hash,  3),b32)  ,b32)
  hash=iand(ieor(hash,iand(ishft(hash,-11),b32)) ,b32)
  hash=iand(     hash+iand(ishft(hash, 15),b32)  ,b32)

  ! hash is the real 32bit hash value of the string,
  ! hash_index is an index in the hash table

  hash_index=mod(hash,int8(size(h%ht)))

end subroutine joaat_hash

integer function ht_insert(str,h)
  character(len=*)  :: str
  type(hash_table), pointer :: h
  integer                                  :: index
  type(hash_element_type), pointer         :: this
  integer(kind=8)  :: hash

  h%inserted=h%inserted+1
  call joaat_hash(str,h,hash,index)
  this=>h%ht(index)
  do
     if (.not. allocated(this%str)) then
        this%str = str
        allocate(this%id)
        h%nstring=h%nstring+1
        this%id = h%nstring
        this%hash = hash
        ht_insert = h%nstring
        exit
     else
        if (this%hash==hash) then
          if (this%str==str) then
            ht_insert = this%id
            exit
          endif
        else
           if (.not. associated(this%next)) allocate(this%next)
           this=>this%next
        endif
     endif
   enddo
end function ht_insert

integer function ht_id(str,h)  
  character(len=*) :: str
  type(hash_table), pointer :: h
  integer                               :: index, nr
  type(hash_element_type), pointer      :: this
  integer(kind=8)                       :: hash

  call joaat_hash(str,h,hash,index)

  this=>h%ht(index)
  nr = 0
  do
     nr = nr + 1
     if (.not. allocated(this%str)) then
        ht_id = 0
        exit
     else
        if (this%hash==hash) then
          if (this%str==str) then
            ht_id = this%id
            exit
          endif
          this => this%next
        else
           if (.not. associated(this%next)) then
             ht_id = 0
             exit
           endif
           this=>this%next
        endif
     endif
   enddo
end function ht_id

subroutine ht_deallocate(h)
  type(hash_table), pointer :: h
  integer :: i
  if (.not.ALLOCATED(h%ht)) return
  do i=0,size(h%ht)-1
     if (allocated(h%ht(i)%str)) then
       deallocate(h%ht(i)%str)
       deallocate(h%ht(i)%id)
       if (associated(h%ht(i)%next)) deallocate(h%ht(i)%next)
     endif
  enddo
  deallocate(h%ht)
end subroutine ht_deallocate

end module f90hash


