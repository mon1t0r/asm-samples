## Overview
This educational project contains miscellaneous examples in x86 NASM Assembly
language with Intel syntax for Linux, which were written while learning
assembly language.

## Projects
### arg_len
Takes one argument and determines its length. Depends on `libutils`.

Usage: `./arg_len <arg>`.

### arg_cmp
Takes two arguments and determines, if they are equal.

Usage: `./arg_cmp <arg1> <arg2>`.

### fibonacci
Prints fibonacci number sequence of desired length. Depends on `libutils`.

Usage: `./fibonacci <count>`.

### copy
Copies file from source to destination.

Usage: `./copy <src_filename> <dst_filename>`.

### radinfo
Calculates circle area, sphere surface and sphere volume from radius. Depends
on `libutils`.

Radius must be specified as `double precision floating point IEE-754` number
in `hexadecimal` form (e.g. `401C000000000000`). Useful web page for conversion
between decimal and IEEE-754:
https://baseconvert.com/ieee-754-floating-point.

Usage: `./radinfo <radius>`.

### libs/libutils
Library project, which contains miscellaneous utilities.
Consists of modules: `scan`, `print`, `string`.

## Build and run
### Requirements
```
nasm
ld
ar
make
```

### Build
```
git clone https://github.com/mon1t0r/asm-samples
cd asm-samples/<name_of_the_proejct>
make
```

### Run
```
release/<name_of_the_project> [OPTIONS]
```

## TODO
- implement FreeBSD support.
