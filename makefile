FC = gfortran
FFLAGS = -g

CC = g++
CFLAGS = -g

source = pointers_f.o pointers_c.o

pointers: $(source)
	$(FC) $(FFLAGS) $(source) -o pointers -lstdc++

clean:
	-rm *.o
	-rm *.mod
	-rm pointers

pointers_f.o: pointers_c.o

%.o: %.cpp
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.f90
	$(FC) -c -o $@ $< $(FFLAGS)
