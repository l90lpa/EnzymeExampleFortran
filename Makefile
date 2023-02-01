FORT		:= ifx
LLVMLINK	:= llvm-link
LLVMOPT		:= opt 
LLVMEnzyme	:= /path/to/LLVMEnzyme-15.so

FORTFLAGS	+= -flto

app: main.o
	@echo "\nCompiling done, now linking\n"
	$(LLVMLINK) main.o primal.o adjoint.o -o merged.o
	$(LLVMOPT) merged.o --load=$(LLVMEnzyme) --enable-new-pm=0 -enzyme -o ad.o
	$(FORT) $(FORTFLAGS) -O3 ad.o -o app

main.o: main.f90 primal.o adjoint.o
	$(FORT) $(FORTFLAGS) -c main.f90

primal.o: primal.f90
	$(FORT) $(FORTFLAGS) -c primal.f90

adjoint.o: adjoint.f90 primal.o
	$(FORT) $(FORTFLAGS) -c adjoint.f90
	
clean:
	rm -f app main.o primal.o primal.mod adjoint.o adjoint.mod merged.o ad.o
