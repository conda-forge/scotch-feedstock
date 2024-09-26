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

  MPIEXEC="${RECIPE_DIR}/mpiexec.sh"
  mpiexec() { $MPIEXEC $@; }

  # These `dg*` tools do not call MPI_Finalize() in some cases and then
  # Open MPI's mpiexec complain about that. Let them run in singleton
  # mode, outside of mpiexec's control, with a quick workaround for
  # docker images without `ssh`/`rsh` commands.
  export OMPI_MCA_plm_rsh_agent=false

  dggath -V
  dgmap -V
  dgord -V
  dgscat -V
  dgtst -V

  mpic++ $CXXFLAGS $LDFLAGS "-I$PREFIX/include" "-L$PREFIX/lib" "${RECIPE_DIR}/test/test_ptscotch.cxx" -o test_ptscotch -DSCOTCH_PTSCOTCH -lptscotch -lptscotcherr
  mpiexec -n 1 ./test_ptscotch

fi # ptscotch
