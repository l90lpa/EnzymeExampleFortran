FORT		:= ifx
LLVMLINK	:= llvm-link
LLVMOPT		:= opt
LLVMEnzyme	:= /usr/local/lib/Enzyme/LLVMEnzyme-15.so

FORTFLAGS	+= -flto
EnzymeNoOpt	:= -no-vec -unroll=0

app: main.o
	@echo "\nCompiling done. Now linking, and AD\n"
	$(LLVMLINK) main.o primal.o adjoint.o -o merged.o
	$(LLVMOPT) merged.o --load=$(LLVMEnzyme) --enable-new-pm=0 -enzyme -o ad.o
	$(FORT) $(FORTFLAGS) -O3 ad.o -o app

main.o: main.f90 primal.o adjoint.o
	$(FORT) $(FORTFLAGS) -O1 $(EnzymeNoOpt) -c main.f90

primal.o: primal.f90
	$(FORT) $(FORTFLAGS) -O1 $(EnzymeNoOpt) -c primal.f90

adjoint.o: adjoint.f90 primal.o
	$(FORT) $(FORTFLAGS) -O1 $(EnzymeNoOpt) -c adjoint.f90
	
clean:
	rm -f app *.o *.ll *.mod
