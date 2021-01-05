module pointers
use, intrinsic :: iso_fortran_env
use, intrinsic :: iso_c_binding
implicit none

integer(kind=int32), parameter :: MAX_ENTRIES_DEFAULT = 10
integer(kind=int32) :: max_entries
real(kind=real64), dimension(:), pointer :: real_pointers
integer(kind=int32) :: position_r = 0

contains
integer(kind=int32) function pointers_init(num_entries)
  integer(kind=int32), intent(in), optional :: num_entries

  if (present(num_entries)) then
    max_entries = num_entries
  else
    max_entries = MAX_ENTRIES_DEFAULT
  end if

  allocate(real_pointers(max_entries))
  real_pointers = -1.0

end function pointers_init

integer(kind=int32) function set_new_pointer(ptr)
  real(kind=real64), pointer :: ptr

  position_r = position_r + 1

  if (position_r > max_entries) then
    set_new_pointer = -1
  else
    ptr => real_pointers(position_r)
    set_new_pointer = position_r
  end if
end function

integer(kind=int32) function set_c_pointer(iptr)
  integer(kind=int32), intent(in) :: iptr

  interface
    function set_pointer(ptr, length, idx) bind(c)
      import :: C_INT, C_DOUBLE
      integer(kind=C_INT) :: set_pointer
      real(kind=C_DOUBLE), dimension(1:length), intent(in) :: ptr
      integer(kind=C_INT), intent(in), value :: length
      integer(kind=C_INT), intent(in), value :: idx
    end function
  end interface

  set_c_pointer = set_pointer(real_pointers, iptr-1, max_entries)

end function set_c_pointer


integer(kind=int32) function view_c_pointer()
  interface
    function show_pointer() bind(c)
      import :: C_INT
      integer(kind=C_INT) :: show_pointer
    end function
  end interface

  view_c_pointer = show_pointer()

end function view_c_pointer

end module pointers

program test
use, intrinsic :: iso_fortran_env
use pointers
implicit none

integer(kind=int32) :: idt, status
real(kind=real64), pointer :: dt

write(*,*) "Testing"

status = pointers_init(5)

idt = set_new_pointer(dt)
dt = 7.8_real64
write(*,*) dt, idt

status = set_c_pointer(idt)
status = view_c_pointer()
dt = 12.9
status = view_c_pointer()

end program test
