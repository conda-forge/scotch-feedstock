# -*- mode: makefile-gmake -*-

EXE         =
LIB         = .a
OBJ         = .o

AR          = ar
ARFLAGS     = -ruv
CAT         = cat
CCS         = ${CC}
CCP         = ${CCS}
CCD         = ${CCP}
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

ifeq (${PKG_NAME},ptscotch)
CCP = mpicc
endif

ifeq (${MAKELEVEL},0)

pthread ?= 1
UNAME_S ?= $(shell uname -s)

CFLAGS 	+= -O3
CFLAGS 	+= -I${PREFIX}/include
CFLAGS 	+= -DIDXSIZE64
CFLAGS 	+= -DSCOTCH_RENAME
CFLAGS 	+= -Drestrict=__restrict
CFLAGS 	+= -DCOMMON_FILE_COMPRESS_GZ
CFLAGS 	+= -DCOMMON_RANDOM_FIXED_SEED
LDFLAGS += -L${PREFIX}/lib -lz -lm

ifeq (${pthread},1)
CFLAGS  += -pthread
CFLAGS  += -DCOMMON_PTHREAD
ifeq (${PKG_NAME},scotch)
CFLAGS += -DSCOTCH_PTHREAD
endif
ifeq ($(UNAME_S),Darwin)
CFLAGS  += -DCOMMON_PTHREAD_BARRIER
endif
LDFLAGS += -pthread
endif

ifeq ($(UNAME_S),Darwin)
CFLAGS += -DCOMMON_TIMING_OLD
endif

ifeq ($(UNAME_S),Linux)
LDFLAGS += -lrt
endif

export CFLAGS
export LDFLAGS

endif #(${MAKELEVEL},0)
