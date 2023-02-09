module primal
    use, intrinsic :: iso_c_binding
    implicit none
contains

real function square( x )
    real, intent(in) :: x
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

function dot(c, x) result(y)
    real, dimension(:), allocatable, intent(in) :: c 
    real, dimension(:), allocatable, intent(in) :: x 
    real :: y
    integer :: i
    y = 0
    do i = 1, size(x)
        y = y + (c(i) * x(i))
    end do
end function dot

subroutine gemv(alpha, A, x, beta, y) 
    real, intent(in) :: alpha
    real, dimension(:,:), allocatable, intent(in) :: A 
    real, dimension(:), allocatable, intent(in) :: x 
    real, intent(in) :: beta
    real, dimension(:), allocatable, intent(inout) :: y 
    real, dimension(size(y)) :: temp 
    integer :: i

    temp = 0
    do i = 1, size(A, 2)
        temp(:) = temp(:) + (x(i) * A(:,i))
    end do
    y(:) = alpha * temp(:) + beta * y(:)
end subroutine gemv

end module primal