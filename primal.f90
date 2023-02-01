module primal
    use, intrinsic :: iso_c_binding
    implicit none
contains

real(c_float) function square( x ) bind(c)
    real(c_float), intent(in), value :: x
    square = x**2
end function square

end module primal