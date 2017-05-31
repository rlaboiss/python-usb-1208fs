# Description

This repository contains the Python binding for accessing the DAQ device
[USB-208FS](https://www.mccdaq.com/usb-data-acquisition/USB-1208FS.aspx),
produced by Measurement Computing Corp.  This is intended solely for
GNU/Linux systems and has been tested in a [Debian](https://www.debian.org)
system.

# Design

The binding is built as a Python extension module by using
the [SWIG](http://www.swig.org/) development tool.  It uses a former
version of the a [linux driver](https://github.com/wjasper/Linux_Drivers)
written in C by Warren Jasper.

# Compilation

## Dependencies

Package `linux-libc-dev` is needed for compilation.  In Debian GNU/Linux
systems, do:

```shell
aptitude install linux-libc-dev
```

## Makefile

A Makefile is provided for building the extension module.  Run it simply
as:

```shell
make
```

# Installation

This package is not yet released as a proper Python module, but this will
eventually be done in the future.  For now, after running the `make`
command as above, files `usb1208FS.py` and `_usb1208FS.so` are generated
and must be copied to a place where your Python script will find them:

```shell
make INSTALL_DIR=some/path/you/choose install
```

The udev rules file `50-1208fs.rules`, which sets the device's read/write
access mode for any user, should be installed in appropriate system's
directory (as root):

```shell
sudo make udev-install
```

# Usage example

```python
from usb1208FS import *
import time

class ProcessInterface:

    def __init__ (self):
        'Initialize the USB interface for the 1208FS device'
        self.fd = PMD_Find (MCC_VID, USB1208FS_PID)
        self.channel = 0;
        self.gain = BP_5_00V;

    def run (self):
        'Sample the USB interface for the joysticks'
        state = 0

        while True:
            ## Detect a 1208FS event
            time.sleep (0.01)
            svalue = usbAIn_USB1208FS (self.fd [0], self.channel, self.gain)
            state_new = -1 if svalue < -1000 else 1 if svalue > 1000 else 0
            if state_new != state:
                tstamp = time.time ()
                state = state_new
                if state != 0:
                    out_queue.put (('right' if state == 1 else 'left', tstamp))
```

# Copyright

The files `pmd.c` and `pmd.h` are copyrighted by Warren Jasper and are
released under the terms of the GNU General Public License, version 2 or
later.

The other files are copyrighted by Rafael Laboissière and are released
under the terms of the GNU General Public License, version 3 or later.
