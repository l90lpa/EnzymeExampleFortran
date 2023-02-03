module adjoint
    use, intrinsic :: iso_c_binding
    use primal
    implicit none

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

contains

real function grad_square( x )
    real(c_float), intent(in), value :: x

    grad_square = square__enzyme_autodiff(square,x);
end function grad_square

end module adjoint