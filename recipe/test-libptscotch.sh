#!/bin/bash
set -xeuo pipefail

python3 -c "import ctypes; ctypes.CDLL('${PREFIX}/lib/libptscotch${SHLIB_EXT}')"

export CXXFLAGS="${CXXFLAGS} -DSCOTCH_PTSCOTCH"
export CFLAGS="${CFLAGS} -DSCOTCH_PTSCOTCH"

# specifically test without ptscotcherr
mpic++ $CXXFLAGS $LDFLAGS "test/test_ptscotch.cxx" -o test_ptscotch -lptscotch
mpiexec -n 1 ./test_ptscotch

# build tests from repo
mpicc $CFLAGS $LDFLAGS test/test_scotch_dgraph_check.c -o test_scotch_dgraph_check -lptscotch -lptscotcherr
mpiexec -n 2 ./test_scotch_dgraph_check src/check/data/m4x4.grf
