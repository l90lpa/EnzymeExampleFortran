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

end module adjoint