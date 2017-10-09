#!/bin/bash

cp $RECIPE_DIR/Makefile.inc src/Makefile.inc

export CFLAGS="${CFLAGS} -O3 -I${PREFIX}/include -DIDXSIZE64 -DSCOTCH_RENAME -Drestrict=__restrict -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_RANDOM_FIXED_SEED -DCOMMON_PTHREAD"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -lz -lm -pthread"

if [[ $(uname) == "Darwin" ]]; then
    export CFLAGS="${CFLAGS} -DCOMMON_PTHREAD_BARRIER -DCOMMON_TIMING_OLD"
else
    export LDFLAGS="${LDFLAGS} -lrt"
fi

if [[ "$PKG_NAME" == "scotch" ]]; then
    # allow non-mpi scotch to use threads
    export CFLAGS="${CFLAGS} -DSCOTCH_PTHREAD"
fi

# build
cd src/
make esmumps 2>&1 | tee -a make.log
make check
cd ..

# install
mkdir -p $PREFIX/lib/
cp lib/* $PREFIX/lib/
mkdir -p $PREFIX/bin/
cp bin/* $PREFIX/bin/
mkdir -p $PREFIX/include/
cp include/* $PREFIX/include/

if [[ "$PKG_NAME" == "ptscotch" ]]; then

    export HYDRA_LAUNCHER=fork
    export MPIEXEC="bash ${RECIPE_DIR}/mpiexec.sh"

    if [[ "$(uname)" == "Linux" ]]; then
      # skip mpiexec tests on Linux due to conda-forge bug:
      # https://github.com/conda-forge/conda-smithy/pull/337
      export MPIEXEC="echo SKIPPING $MPIEXEC"
    fi

    # build
    cd src/
    make ptesmumps 2>&1 | tee -a make.log
    make ptcheck EXECP="$MPIEXEC -n 4"
    cd ..

    # install
    mkdir -p $PREFIX/lib/
    cp lib/libpt* $PREFIX/lib/
    mkdir -p $PREFIX/bin/
    cp bin/dg* $PREFIX/bin/
    mkdir -p $PREFIX/include/
    cp include/ptscotch*.h $PREFIX/include/
    cp include/parmetis.h  $PREFIX/include/
fi
