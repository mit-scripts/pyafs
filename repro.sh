#!/bin/sh
python2.7 setup.py build
(cd build/ && PYTHONPATH=lib.linux-x86_64-2.7/ gdb --args python2.7 ../repro/repro.py)
