program app
    use primal 
    use adjoint
    implicit none

    integer :: i, j, steps
    real :: div_result

    do i = 1, 3
        print *, "square(", i, ")=", square(real(i))
        print *, "grad_square(", i, ")=", grad_square(real(i))
    end do
    print *, ""
    
    do i = 1, 3
        j = i + 1
        print *, "sub(", i, ", ", j, ")=", sub(real(i), real(j))
        print *, "grad_sub(", i, ", ", j, ")=", grad_sub(real(i), real(j))
    end do
    print *, ""

    do i = 1, 3
        j = i + 1
        call div(real(i), real(j), div_result)
        print *, "div(", i, ", ", j, ")=", div_result 
        print *, "grad_div(", i, ", ", j, ")=", grad_div(real(i),real(j))
    end do
    print *, ""


end program app