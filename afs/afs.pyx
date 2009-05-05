"""
General PyAFS utilities, such as error handling
"""

import sys

# otherwise certain headers are unhappy
cdef import from "netinet/in.h": pass
cdef import from "afs/vice.h": pass

cdef int _init = 0

# pioctl convenience wrappers

cdef extern int pioctl_read(char *dir, afs_int32 op, void *buffer, unsigned short size, afs_int32 follow) except -1:
    cdef ViceIoctl blob
    cdef afs_int32 code
    blob.in_size  = 0
    blob.out_size = size
    blob.out = buffer
    code = pioctl(dir, op, &blob, follow)
    pyafs_error(code)
    return code

# Error handling

class AFSException(Exception):
    def __init__(self, errno):
        self.errno = errno
        self.strerror = afs_error_message(errno)

    def __repr__(self):
        return "AFSException(%s)" % (self.errno)

    def __str__(self):
        return "[%s] %s" % (self.errno, self.strerror)

def pyafs_error(code):
    if not _init:
        initialize_ACFG_error_table()
        initialize_KTC_error_table()
        initialize_PT_error_table()
        initialize_RXK_error_table()
        initialize_U_error_table()

        _init = 1

    if code != 0:
        raise AFSException(code)
