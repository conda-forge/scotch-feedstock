#!/bin/bash
mpiexec $@
ec=$?

# fix O_NONBLOCK
python $(dirname "$0")/no-nonblock.py
exit $ec
