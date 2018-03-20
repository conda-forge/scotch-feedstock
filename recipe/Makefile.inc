# -*- mode: makefile-gmake -*-

EXE         =
LIB         = .a
OBJ         = .o

AR          = ar
ARFLAGS     = -ruv
CAT         = cat
CCS        ?= ${CC}
CCP        ?= ${CCP}
CCD        ?= ${CCD}
CFLAGS     := ${CFLAGS}
CLIBFLAGS   = -fPIC
LDFLAGS    := $(filter-out -lc++,${LDFLAGS})
CP          = cp
LEX         = flex -Pscotchyy -olex.yy.c
LN          = ln
MKDIR       = mkdir
MV          = mv
RANLIB      = ranlib
YACC        = bison -pscotchyy -y -b y
