## Overview
This educational project contains miscellaneous examples in x86 NASM Assembly
language with Intel syntax for Linux.

## Projects
### arg_len
Takes one argument and determines its length. Depends on `libs/libutils`.

Usage: `./arg_len <arg>`.

### arg_cmp
Takes two arguments and determines, if they are equal.

Usage: `./arg_cmp <arg1> <arg2>`.

### fibonacci
Prints fibonacci number sequence of desired length. Depends on `libs/libutils`.

Usage: `./fibonacci <count>`.

### copy
Copies file from source to destination.

Usage: `./copy <src_filename> <dst_filename>`.

### radinfo
Calculates circle area, sphere surface and sphere volume from radius.

Radius must be specified as single precision floating point IEEE-754 number
in `hexadecimal` form (e.g. `42f60000`). Useful web page for conversion between
decimal and IEEE-754: https://www.h-schmidt.net/FloatConverter/IEEE754.html.

Usage: `./radinfo <radius>`.

### libs/libutils
Library project, which contains miscellaneous utilities.

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
