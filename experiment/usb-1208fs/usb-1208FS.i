%module usb1208FS

%{
#include <linux/hiddev.h>
#include "pmd.h"
%}

%typemap(out) int* PMD_Find {
    int i;
    $result = PyList_New (4);
    for (i = 0; i < 4; i++) {
        PyObject *o = PyInt_FromLong($1 [i]);
        PyList_SetItem ($result, i, o);
    }
}

%typemap(in) __u8 {
    $1 = PyInt_AsLong($input);
}

%include "pmd.h"
%include "usb-1208FS.h"
