
float fortran__enzyme_autodiff(void* fnc, float x) {
    float primal = ((float (*)(float))(fnc))(x); // just to record how to call the function
    float adjoint = 2*x;
    return adjoint;
}