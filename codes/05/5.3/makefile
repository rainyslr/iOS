test:test.o power.o
	clang++ -g test.o power.o -o test  
test.o:test.cc power.h
	clang++ -g -c test.cc 
power.o:power.cc power.h
	clang++ -g -c power.cc 
clean:
	rm *.o
