LIBRARY_LIST=$(BUILD_LIB)
SHELL=/QOpenSys/usr/bin/qsh

all: depts.pgm.sqlrpgle employees.pgm.sqlrpgle

## Targets
depts.pgm.sqlrpgle: depts.dspf department.table
employees.pgm.sqlrpgle: emps.dspf employee.table

## Rules
%.pgm.sqlrpgle: qrpglesrc/%.pgm.sqlrpgle
	system -s "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1252)"
	liblist -a $(LIBRARY_LIST);\
	system "CRTSQLRPGI OBJ($(BUILD_LIB)/$*) SRCSTMF('$<') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) COMPILEOPT('INCDIR(''qrpgleref'')')"

%.dspf:
	-system -qi "CRTSRCPF FILE($(BUILD_LIB)/QDDSSRC) RCDLEN(112)"
	system "CPYFRMSTMF FROMSTMF('./qddssrc/$*.dspf') TOMBR('/QSYS.lib/$(BUILD_LIB).lib/QDDSSRC.file/$*.mbr') MBROPT(*REPLACE)"
	system -s "CRTDSPF FILE($(BUILD_LIB)/$*) SRCFILE($(BUILD_LIB)/QDDSSRC) SRCMBR($*)"
	system -qi "DLTF FILE($(BUILD_LIB)/QDDSSRC)"

%.table: qsqlsrc/%.table
	liblist -c $(BUILD_LIB);\
	system "RUNSQLSTM SRCSTMF('$<') COMMIT(*NONE)"