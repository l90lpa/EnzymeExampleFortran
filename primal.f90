module primal
    use, intrinsic :: iso_c_binding
    implicit none
contains

real(c_float) function square( x ) bind(c)
    real(c_float), intent(in), value :: x
    square = x**2
end function square

real function sub(x, y) 
    real, intent(in) :: x
    real, intent(in) :: y
    sub = x - y;
end function sub

subroutine div(x, y, result) 
    real, intent(in) :: x
    real, intent(in) :: y
    real, intent(inout) :: result
    result = x / y;
end subroutine div

end module primal