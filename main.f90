program app
    use primal 
    use adjoint
    implicit none

    integer :: i, steps

    do i = 1, 4
        print *, "square(", i, ")=", square(real(i)), ", dsquare(", i, ")=", dsquare(real(i))
    end do
end program app