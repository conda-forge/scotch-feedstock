#!/bin/bash

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


if [[ "$PKG_NAME" == "scotch" ]]; then

  echo "**** Building scotch"

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

  echo "**** Building ptscotch"

  export CCP=mpicc
  # This is only used by open-mpi's mpicc
  # ignored in other cases
  export OMPI_CC=$CC
  export OPAL_PREFIX=$PREFIX

  # build
  cd src/
  make ptesmumps
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
