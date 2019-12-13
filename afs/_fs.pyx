# cython: c_string_type=str, c_string_encoding=ascii
from afs._util cimport *
from afs._util import path_to_bytes

def whichcell(path):
    """Determine which AFS cell a particular path is in."""
    cdef char cell[MAXCELLCHARS]

    pioctl_read(path_to_bytes(path), VIOC_FILE_CELL_NAME, cell, sizeof(cell), 1)
    return cell
