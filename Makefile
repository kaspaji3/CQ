CC := gcc
CPP := g++


#CFLAGS := -ggdb3 -O3 -D__DEBUG
#CFLAGS := -g -O3 -DM5_PROFILING

CFLAGS := -msse2 -DDEBUG
#CFLAGS := -msse2 -D__USE_GNU
#CPPFLAGS := $(CFLAGS)
LFLAGS := -pthread -lrt 
M5LFLAGS := -static ~/gem5/m5threads/pthread.o -lrt

ALL := CQtest CQtestM CQtestM4 primes_serial primes_trivial

default: $(ALL)

clean: 
	$(RM) $(ALL) *.o

# Link program for GEM5 execution
%.m5: %.o
	@echo '$(CC) $(M5LFLAGS)  $< -o $@'
	@$(CC) $< $(M5LFLAGS) -o $@
# Assembly listing
%.s: %.c
	@echo '$(CC) $(CFLAGS) -S -fverbose-asm $< -o $@'
	@$(CC)  $(CFLAGS) -fverbose-asm -S $< -o $@

# Compile & Link program for normal execution
#%: %.o CQ.o CQmain.o Makefile
#	@echo '$(CC)  $(CFLAGS) $< CQ.o CQmain.o $(LFLAGS)  -o $@'
#	@$(CC) $(CFLAGS) $< CQ.o CQmain.o $(LFLAGS) -o $@
%: %.c CQ.h Makefile
	@echo '$(CC) $(CFLAGS) $< CQ.o CQmain.o $(LFLAGS) -o $@'
	@$(CC) $(CFLAGS)  $< CQ.o CQmain.o $(LFLAGS) -o $@

# C Compilation
%.o: %.c CQ.h Makefile
	@echo '$(CC) $(CFLAGS) -c $< -o $@'
	@$(CC)  $(CFLAGS) -c $< -o $@

CQtestM: CQtest.o CQmutex.o CQmain.o
	@echo '$(CC)  CQtest.o CQmutex.o CQmain.o $(LFLAGS)  -o $@'
	@$(CC) CQtest.o CQmutex.o CQmain.o $(LFLAGS) -o $@

CQtestM4: CQtest.o CQmutex4.o CQmain.o
	@echo '$(CC)  CQtest.o CQmutex4.o CQmain.o $(LFLAGS)  -o $@'
	@$(CC) CQtest.o CQmutex4.o CQmain.o $(LFLAGS) -o $@

#primes_serial: primes_serial.o CQmain.o
#	@echo '$(CC) $< -o $@'
#	@$(CC)  $< -o $@

CQtestM.o: CQtest.c CQ.h Makefile
	@echo '$(CC) $(CFLAGS) -DMUTEX -c CQtest.c -o $@'
	@$(CC)  $(CFLAGS) -DMUTEX -c CQtest.c -o $@

CQmutex.o: CQmutex.c CQ.h Makefile
	@echo '$(CC) $(CFLAGS) -DMUTEX -c $< -o $@'
	@$(CC)  $(CFLAGS) -DMUTEX -c $< -o $@

CQmutex4.o: CQmutex4.c CQ.h Makefile
	@echo '$(CC) $(CFLAGS) -DMUTEX -c $< -o $@'
	@$(CC)  $(CFLAGS) -DMUTEX -c $< -o $@

# primes_trivial.o: primes_trivial.c CQ.h
# CQmain.o: CQmain.c CQ.h Makefile
# CQtest.o: CQtest.c CQ.h Makefile
# CQ.o: CQ.c CQ.h Makefile

