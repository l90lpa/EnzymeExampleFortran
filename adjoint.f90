module adjoint
    use, intrinsic :: iso_c_binding
    use primal
    implicit none

    integer, bind(C, name="enzyme_dup") :: enzyme_dup
    integer, bind(C, name="enzyme_dupnoneed") :: enzyme_dupnoneed
    integer, bind(C, name="enzyme_out") :: enzyme_out
    integer, bind(C, name="enzyme_const") :: enzyme_const

    interface
    subroutine dot__enzyme_autodiff(fnc, enzyme_flag, c, x, dx)
        interface
            real function fnc_decal(a, b)
                real, dimension(:), allocatable, intent(in) :: a
                real, dimension(:), allocatable, intent(in) :: b
            end function
        end interface
        procedure(fnc_decal) :: fnc
        integer :: enzyme_flag
        real, dimension(:), allocatable, intent(in) :: c
        real, dimension(:), allocatable, intent(in) :: x
        real, dimension(:), allocatable, intent(inout) :: dx 
    end subroutine
    end interface

    interface
    subroutine gemv__enzyme_autodiff(fnc, enzyme_flag1, alpha, enzyme_flag2, A, x, dx, enzyme_flag3, beta, enzyme_flag4, y, dy)
        interface
            subroutine fnc_decal(alpha_, A_, x_, beta_, y_) 
                real, intent(in) :: alpha_
                real, dimension(:,:), allocatable, intent(in) :: A_ 
                real, dimension(:), allocatable, intent(in) :: x_ 
                real, intent(in) :: beta_
                real, dimension(:), allocatable, intent(inout) :: y_ 
            end subroutine
        end interface
        procedure(fnc_decal) :: fnc
        integer :: enzyme_flag1
        real, intent(in) :: alpha
        integer :: enzyme_flag2
        real, dimension(:,:), allocatable, intent(in) :: A 
        real, dimension(:), allocatable, intent(in) :: x 
        real, dimension(:), allocatable, intent(inout) :: dx
        integer :: enzyme_flag3 
        real, intent(in) :: beta
        integer :: enzyme_flag4
        real, dimension(:), allocatable, intent(inout) :: y 
        real, dimension(:), allocatable, intent(inout) :: dy 
    end subroutine
    end interface

contains

real function grad_square( x )
    real, intent(in) :: x

    grad_square = 0
    call square__enzyme_autodiff(square, x, grad_square);
end function grad_square


function grad_sub(x, y)
    real, intent(in) :: x
    real, intent(in) :: y
    real, dimension(2) :: grad_sub

    grad_sub = 0
    call sub__enzyme_autodiff(sub,x,grad_sub(1),y,grad_sub(2))
end function grad_sub


function grad_div(x, y)
    real, intent(in) :: x
    real, intent(in) :: y
    real, dimension(2) :: grad_div
    real :: result, dresult
    
    dresult = 1
    grad_div = 0
    
    call div__enzyme_autodiff(div, x, grad_div(1), y, grad_div(2), enzyme_dupnoneed, result, dresult)
end function grad_div

function grad_dot(c, x) result(dx)
    real, dimension(:), allocatable, intent(in) :: c
    real, dimension(:), allocatable, intent(in) :: x
    real, dimension(:), allocatable :: dx 
    allocate(dx(size(x)))
    dx = 0
    
    call dot__enzyme_autodiff(dot, enzyme_const, c, x, dx)
end function grad_dot

function grad_gemv(alpha, A, x, beta, y, dy) result(dx)
    real, intent(in) :: alpha
    real, dimension(:,:), allocatable, intent(in) :: A 
    real, dimension(:), allocatable, intent(in) :: x 
    real, intent(in) :: beta
    real, dimension(:), allocatable, intent(inout) :: y 
    real, dimension(:), allocatable :: dy 
    real, dimension(:), allocatable :: dx 
    allocate(dx(size(x)))
    dx = 0
    
    call gemv__enzyme_autodiff(gemv, enzyme_const, alpha, enzyme_const, A, x, dx, enzyme_const, beta, enzyme_dupnoneed, y, dy)
end function grad_gemv

end module adjoint