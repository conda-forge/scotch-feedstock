#!/bin/bash
set -xeuo pipefail

python3 -c "import ctypes; ctypes.CDLL('${PREFIX}/lib/libscotch${SHLIB_EXT}')"

$CC $CFLAGS $LDFLAGS test/test_scotch.c -o test_scotch -lscotch
./test_scotch

# build tests from repo
for test in test_scotch_graph_color; do
  $CC $CFLAGS $LDFLAGS src/check/${test}.c -o ${test} -lscotch -lscotcherr
done
# run tests
./test_scotch_graph_color src/check/data/m4x4.grf
