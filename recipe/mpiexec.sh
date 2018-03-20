#!/bin/bash
set -e
# pipe stdout, stderr through cat to avoid O_NONBLOCK issues
echo '' | mpiexec $@ 2>&1 | cat
