#!/bin/bash
set -xeuo pipefail

# make sure DLLs can be loaded
if [[ "${PKG_NAME}" == "libscotch" ]]
then
  python3 -c "import ctypes; ctypes.CDLL('${PREFIX}/lib/libscotch${SHLIB_EXT}')"
fi

if [[ "${PKG_NAME}" == "libptscotch" ]]
then
  python3 -c "import ctypes; ctypes.CDLL('${PREFIX}/lib/libptscotch${SHLIB_EXT}')"

  mpic++ $CXXFLAGS $LDFLAGS "-I$PREFIX/include" "-L$PREFIX/lib" "${RECIPE_DIR}/test/test_ptscotch.cxx" -o test_ptscotch -DSCOTCH_PTSCOTCH -lptscotch -lptscotcherr
  mpiexec -n 1 ./test_ptscotch
fi


if [[ "${PKG_NAME}" == "scotch" ]]
then

  mord -V
  gmap -V
  gord -V
  gotst -V
  gscat -V

fi # scotch


if [[ "${PKG_NAME}" == "ptscotch" ]]
then

  dggath -V
  dgmap -V
  dgord -V
  dgscat -V
  dgtst -V

fi # ptscotch
