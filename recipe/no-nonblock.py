#!/usr/bin/env python
import os, sys, fcntl
for name in ('stdout', 'stderr', 'stdin'):
    fd = getattr(sys, name).fileno()
    flags = fcntl.fcntl(fd, fcntl.F_GETFL)
    if flags & os.O_NONBLOCK:
        fcntl.fcntl(fd, fcntl.F_SETFL, flags ^ os.O_NONBLOCK)
        print("fixing %s" % name)
