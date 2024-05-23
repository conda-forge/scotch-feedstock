set BISON_PKGDATADIR=%BUILD_PREFIX%\Library\share\winflexbison\data\

:: MSVC is preferred.
set CC=cl.exe
set CXX=cl.exe

:: IMPI doesn't make the include\mpi dir, but cmake FindMPI assumes it's there
if "%mpi%"=="impi-devel" (
  mkdir "%LIBRARY_PREFIX%\include\mpi"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_HOME=%LIBRARY_PREFIX%"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_SKIP_GUESSING=ON"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_LIBRARY_NAME=impi"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPIEXEC_EXECUTABLE=%LIBRARY_PREFIX%\bin\mpiexec.bat"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_C_COMPILER=%LIBRARY_PREFIX%\bin\mpicc.bat"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_SKIP_GUESSING=ON"
  set "CMAKE_ARGS=%CMAKE_ARGS% -D MPI_INCLUDE_PATH=%LIBRARY_PREFIX%\include"
  echo %CMAKE_ARGS%
)


cmake ^
  %CMAKE_ARGS% ^
  --debug-output ^
  -G "Ninja" ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -D BUILD_SHARED_LIBS=OFF ^
  -D CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
  -D THREADS_PTHREADS_INCLUDE_DIR="%LIBRARY_INC%" ^
  -D THREADS_PTHREADS_WIN32_LIBRARY:FILEPATH="%LIBRARY_LIB%\pthread.lib" ^
  -B build ^
  %SRC_DIR%
if errorlevel 1 exit 1

cmake --build ./build --config Release
if errorlevel 1 exit 1
cmake --install ./build --component=libscotch
if errorlevel 1 exit 1

:: remove empty directory
if "%mpi%"=="impi-devel" (
  rmdir "%LIBRARY_PREFIX%\include\mpi"
)
