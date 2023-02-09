module adjoint
    use, intrinsic :: iso_c_binding
    use primal
    implicit none

    integer, bind(C, name="enzyme_dup") :: enzyme_dup
    integer, bind(C, name="enzyme_dupnoneed") :: enzyme_dupnoneed
    integer, bind(C, name="enzyme_out") :: enzyme_out
    integer, bind(C, name="enzyme_const") :: enzyme_const

    interface
    real(c_float) function square__enzyme_autodiff(fnc, x) bind(c)
        use, intrinsic :: iso_c_binding
        
        interface
            real(c_float) function f_real_real(y) bind(c)
                use, intrinsic :: iso_c_binding

                real(c_float), intent(in), value :: y
            end function f_real_real
        end interface
        
        procedure(f_real_real) :: fnc
        real(c_float), intent(in), value :: x

    end function square__enzyme_autodiff
    end interface

    interface
    subroutine div__enzyme_autodiff(fnc, x, dx, y, dy, result, dresult)
        
        interface
            subroutine f_binop(a,b,c)
                real, intent(in) :: a
                real, intent(in) :: b
                real, intent(inout) :: c
            end subroutine f_binop
        end interface
        
        procedure(f_binop)  :: fnc
        real, intent(in)    :: x
        real, intent(inout) :: dx
        real, intent(in)    :: y
        real, intent(inout) :: dy
        real, intent(in)    :: result
        real, intent(inout) :: dresult

    end subroutine div__enzyme_autodiff
    end interface

contains

real function grad_square( x )
    real(c_float), intent(in), value :: x

    grad_square = square__enzyme_autodiff(square,x);
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
    
    call div__enzyme_autodiff(div, x, grad_div(1), y, grad_div(2), result, dresult)
end function grad_div

end module adjoint