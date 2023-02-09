program app
    use primal 
    use adjoint
    implicit none

    integer :: i, j, steps
    real :: div_result, alpha, beta
    real, dimension(:), allocatable :: c
    real, dimension(:), allocatable :: x
    real, dimension(:), allocatable :: y
    real, dimension(:), allocatable :: y_copy
    real, dimension(:), allocatable :: dy
    real, dimension(:,:), allocatable :: A

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
    
    allocate(c(3))
    allocate(x(3))
    
    c = [1,2,3]
    x = [2,3,4]

    print *, "c=", c
    print *, "x=", x
    print *, "dot(c,x)=", dot(c, x)
    
    print *, "grad_dot(x,c)=", grad_dot(c, x)
    print *, ""

    allocate(A(2,3))
    allocate(y(2))
    allocate(y_copy(2))
    allocate(dy(2))
    alpha = 1
    beta = 1
    A = reshape((/1,4,2,5,3,6/), shape(A))
    y = [7,8]
    y_copy = y
    dy = [0,1]
    
    print *, "alpha=", alpha
    print *, "A=", A
    print *, "x=", x
    print *, "beta=", beta
    print *, "y=", y
    print *, "dy=", dy
    call gemv(alpha, A, x, beta, y)
    print *, "gemv(alpha, A, x, beta, y) => y=", y
    print *, "grad_gemv(alpha, A, x, beta, y, dy)=", grad_gemv(alpha, A, x, beta, y, dy)

end program app