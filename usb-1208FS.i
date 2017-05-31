/*
 *  Copyright (c) 2017 Rafael Laboissière <rafael@laboissiere.net>
 *
 *  This program is free software: you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by the
 *  Free Software Foundation, either version 3 of the License, or (at your
 *  option) any later version.
 *
 *  This program is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
