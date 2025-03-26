set BISON_PKGDATADIR=%BUILD_PREFIX%\Library\share\winflexbison\data\

:: MSVC is preferred.
set CC=cl.exe
set CXX=cl.exe

if "%mpi%"=="impi-devel" (
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_C_ADDITIONAL_INCLUDE_DIRS=%LIBRARY_PREFIX%\include"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_C_LIBRARIES=impi"
)


cmake ^
  %CMAKE_ARGS% ^
  -G "Ninja" ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -D ENABLE_TESTING=OFF ^
  -D BUILD_SHARED_LIBS=OFF ^
  -D CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
  -D INTSIZE=64 ^
  -D THREADS_PTHREADS_INCLUDE_DIR="%LIBRARY_INC%" ^
  -D THREADS_PTHREADS_WIN32_LIBRARY:FILEPATH="%LIBRARY_LIB%\pthread.lib" ^
  -D LIBSCOTCHERR=scotcherr ^
  -D LIBPTSCOTCHERR=ptscotcherr ^
  -B build ^
  %SRC_DIR%
if errorlevel 1 exit 1

cmake --build ./build --config Release
if errorlevel 1 exit 1
cmake --install ./build --component=libscotch
if errorlevel 1 exit 1
