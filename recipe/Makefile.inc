# -*- mode: makefile-gmake -*-

EXE         =
LIB         = .a
OBJ         = .o

AR          = ar
ARFLAGS     = -ruv
CAT         = cat
CC         ?= gcc
CCS        ?= $(CC)
CCP        ?= $(CC)
CCD        := $(CC_FOR_BUILD)
CFLAGS     := $(CFLAGS) \
    -O3 -I$(PREFIX)/include \
    -DIDXSIZE64 \
    -DSCOTCH_RENAME \
    -Drestrict=__restrict \
    -DCOMMON_FILE_COMPRESS_GZ \
    -DCOMMON_RANDOM_FIXED_SEED \
    -DCOMMON_PTHREAD \
    -DSCOTCH_PTHREAD

ifeq ($(shell uname -s), Darwin)
    CFLAGS += -DCOMMON_PTHREAD_BARRIER -DCOMMON_TIMING_OLD
endif

CLIBFLAGS   = -fPIC
LDFLAGS    := $(filter-out -lc++, $(LDFLAGS)) \
    -lm \
    -lz \
    -pthread
ifeq ($(shell uname -s), Linux)
    LDFLAGS += -lrt
endif

CP          = cp
FLEX        = flex
LN          = ln
MKDIR       = mkdir
MV          = mv
RANLIB      = ranlib
BISON       = bison
