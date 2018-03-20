#!/bin/sh

cp $RECIPE_DIR/Makefile.inc src/Makefile.inc

export CFLAGS="${CFLAGS} -O3 -I${PREFIX}/include -DIDXSIZE64 -DSCOTCH_RENAME -Drestrict=__restrict -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_RANDOM_FIXED_SEED -DCOMMON_PTHREAD"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -lz -lm -pthread"

if [[ $(uname) == "Darwin" ]]; then
  export CFLAGS="${CFLAGS} -DCOMMON_PTHREAD_BARRIER -DCOMMON_TIMING_OLD"
else
  export LDFLAGS="${LDFLAGS} -lrt"
fi

if [ "$PKG_NAME" == "scotch" ]
then

export CFLAGS="${CFLAGS} -DSCOTCH_PTHREAD"
export CCD=${CC}

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
# avoid conflicts with the real metis.h
mkdir -p include/scotch
mv include/metis.h include/scotch/
cp -rv include/* $PREFIX/include/

fi # scotch


if [ "$PKG_NAME" == "ptscotch" ]
then

export CCP=mpicc
export CCD=${CCP}

export HYDRA_LAUNCHER=fork
export MPIEXEC="${RECIPE_DIR}/mpiexec.sh"

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
# avoid conflicts with the real parmetis.h
mkdir -p $PREFIX/include/scotch
cp include/parmetis.h  $PREFIX/include/scotch/

fi # ptscotch
