#!/bin/sh

cp $RECIPE_DIR/Makefile.inc src/Makefile.inc

if [ "$PKG_NAME" == "scotch" ]
then

# build
cd src/
make esmumps 2>&1 | tee make.log
make check 2>&1 | tee check.log
cd ..
# install
mkdir -p $PREFIX/lib/
cp lib/* $PREFIX/lib/
mkdir -p $PREFIX/bin/
cp bin/* $PREFIX/bin/
mkdir -p $PREFIX/include/
cp include/* $PREFIX/include/

fi # scotch


if [ "$PKG_NAME" == "ptscotch" ]
then

export HYDRA_LAUNCHER=fork
export MPIEXEC=mpiexec
if [[ "$(uname)" == "Linux" ]]; then
  # skip mpiexec tests on Linux due to conda-forge bug:
  # https://github.com/conda-forge/conda-smithy/pull/337
  export MPIEXEC="echo SKIPPING $MPIEXEC"
fi
if [[ "$(uname)" == "Darwin" ]]; then
  # the following test fails with "write error"
  # on Travis-CI during 'make ptcheck'
  # $ mpiexec -n 4 ./test_scotch_dgraph_redist data/bump.grf
  export MPIEXEC="echo SKIPPING $MPIEXEC"
fi

# build
cd src/
make ptesmumps 2>&1 | tee make.log
make ptcheck EXECP="$MPIEXEC -n 4" 2>&1 | tee check.log
cd ..
# install
mkdir -p $PREFIX/lib/
cp lib/libpt* $PREFIX/lib/
mkdir -p $PREFIX/bin/
cp bin/dg* $PREFIX/bin/
mkdir -p $PREFIX/include/
cp include/ptscotch*.h $PREFIX/include/
cp include/parmetis.h  $PREFIX/include/

fi # ptscotch
