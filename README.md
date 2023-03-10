# Enzyme Example - Fortran
This project gives an example of using the [Enzyme](https://enzyme.mit.edu/) AD tool on a simple Fortan project using the LLVM-based [Intel Fortran Compiler](https://www.intel.com/content/www/us/en/develop/documentation/fortran-compiler-oneapi-dev-guide-and-reference/top.html).

## Dependencies
- `LLVMEnzyme-15.so`, this is the Enzyme LLVM pass plugin built against LLVM version 15
- `llvm-link`, version 15 (llvm bitcode module linker)
- `opt`, version 15 (llvm bitcode module optimizer)
- `ifx`, version 2022.2.1 (Intel Fortran Compiler)

## Setup
- If `llvm-link`, `opt`, or `ifx` aren't in your path then either add them to your path, or put their paths in the appropriate variables in `Makefile`.
- Modify the path, `/usr/local/lib/Enzyme/LLVMEnzyme-15.so`, in `Makefile` to be the actual path to the library

## Notes
- Currently Enzyme doesn't support some of the compiler intrinsics specific to the Intel Fortran Compiler, such as `llvm.intel.subscript.p0f32.i64.i64.p0f32.i64`. These compiler intrinsics don't seem to be present when compiled with optimization level `-O1`, and so for now (until a way is found to disable them, or Enzyme supports them) the Makefile currently compiles with `-O1` prior to the Enzyme pass (which is less than ideal).
- `Makefile-gfortran` was a makefile used during development for testing that the code compiled without using the intel compiler.
- Documentation for building `LLVMEnzyme-15.so` can be found at [here](https://enzyme.mit.edu/Installation/), however the process can be simplified. Instead of building LLVM manually as suggested, simply install the llvm headers/libraries and build against these. The headers/libraries can be installed using `apt install llvm-15-dev` (you might need to first [add the llvm 15 toolchain repository to apt](https://apt.llvm.org/))), and then the required cmake directory can be found using `dpkg -L llvm-15-dev | grep lib/cmake/llvm`, at which point one can then follow the Enzyme build steps. By default, this will also build the lld pass plugin, `LLDEnzyme-15.so`, but if you also in the install the headers/libraries for Clang, say using `apt install libclang-15-dev`, then the Clang pass plugin `ClangEnzyme-15.so` will also be built.