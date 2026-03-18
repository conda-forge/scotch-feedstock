set BISON_PKGDATADIR=%BUILD_PREFIX%\Library\share\winflexbison\data\

:: MSVC is preferred.
set CC=cl.exe
set CXX=cl.exe

if "%mpi%"=="impi-devel" (
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_C_ADDITIONAL_INCLUDE_DIRS=%LIBRARY_PREFIX%\include"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_C_LIBRARIES=impi"
)

if "%mpi%"=="nompi" (
  set "CMAKE_ARGS=%CMAKE_ARGS% -D BUILD_PTSCOTCH=OFF"
)

:: Only set pthreads paths when not using MKL build (nomkl means pthreads-win32 is available)
if not "%mklbuild%"=="mkl" (
  set "CMAKE_ARGS=%CMAKE_ARGS% -D THREADS_PTHREADS_INCLUDE_DIR=%LIBRARY_INC%"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D THREADS_PTHREADS_WIN32_LIBRARY:FILEPATH=%LIBRARY_LIB%\pthread.lib"
)

cmake ^
  %CMAKE_ARGS% ^
  -G "Ninja" ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -D ENABLE_TESTS=OFF ^
  -D BUILD_SHARED_LIBS=OFF ^
  -D CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
  -D INTSIZE=%intsize% ^
  -D LIBSCOTCHERR=scotcherr ^
  -D LIBPTSCOTCHERR=ptscotcherr ^
  -B build ^
  %SRC_DIR%
if errorlevel 1 exit 1

cmake --build ./build --config Release --verbose
if errorlevel 1 exit 1
cmake --install ./build --component=libscotch
if errorlevel 1 exit 1
