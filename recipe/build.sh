#!/bin/sh

set -ex

cp $RECIPE_DIR/Makefile.inc src/Makefile.inc

export CCD=$CC_FOR_BUILD

# remove --as-needed, which removes librt
# even though libscotch requires clock_gettime from librt
export LDFLAGS="${LDFLAGS/-Wl,--as-needed/}"

if [[ $(uname) == "Darwin" ]]; then
  export SONAME="-Wl,-install_name,@rpath/"
else
  export SONAME="-Wl,-soname,"
fi
# VERSION used in dylib versions in debian makefile patches
export VERSION=$PKG_VERSION

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  cp $RECIPE_DIR/ptscotch_osx-arm64-$VERSION.h ./src/libscotch/ptscotch.h
  cp $RECIPE_DIR/ptscotchf_osx-arm64-$VERSION.h ./src/libscotch/ptscotchf.h
  cp $RECIPE_DIR/scotch_osx-arm64-$VERSION.h ./src/libscotch/scotch.h
  cp $RECIPE_DIR/scotchf_osx-arm64-$VERSION.h ./src/libscotch/scotchf.h
  cp $RECIPE_DIR/metis_osx-arm64-$VERSION.h ./src/libscotchmetis/metis.h
  cp $RECIPE_DIR/parmetis_osx-arm64-$VERSION.h ./src/libscotchmetis/parmetis.h
fi

if [[ "$PKG_NAME" == "scotch" ]]; then

  # build
  cd src/
  make esmumps
  cd ..

  # install
  mkdir -p $PREFIX/lib/
  cp -v lib/*${SHLIB_EXT}* $PREFIX/lib/
  mkdir -p $PREFIX/bin/
  cp -v bin/* $PREFIX/bin/
  mkdir -p $PREFIX/include/
  # avoid conflicts with the real metis.h
  mkdir -p include/scotch
  mv include/metis.h include/scotch/
  cp -rv include/* $PREFIX/include/

elif [[ "$PKG_NAME" == "ptscotch" ]]; then

  export CCP=mpicc
  export CCD=${CCP}
  export CC=mpicc

  # build
  cd src/
  echo "===========> env before make ptesmumps"
  env
  echo "===========> cat ./Makefile before make ptesmumps"
  cat ./Makefile
  echo "===========> cat ./libscotch/Makefile before make ptesmumps"
  cat ./libscotch/Makefile
  echo "===========> running which make" 
  which make
  echo "===========> running make -d -j1 ptesmumps" 
  make -d -j1 ptesmumps
  echo "===========> make ptesmumps completed" 
  cd ..

  # install
  mkdir -p $PREFIX/lib/
  cp -v lib/libpt*${SHLIB_EXT}* $PREFIX/lib/
  mkdir -p $PREFIX/bin/
  cp -v bin/dg* $PREFIX/bin/
  mkdir -p $PREFIX/include/
  cp -v include/ptscotch*.h $PREFIX/include/
  # avoid conflicts with the real parmetis.h
  mkdir -p $PREFIX/include/scotch
  cp -v include/parmetis.h  $PREFIX/include/scotch/

fi # ptscotch
