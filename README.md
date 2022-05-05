# Ada implementation of Protocol Buffers - Google's data interchange format

Note this repository is in beta stage.

## Prerequisites: the folowing packages installed:
* protobuf-compiler and protobuf-devel
* Or the protobuff packages installed in the GNAT-Installation.

In the case of Ubuntu (tested under 20.04), install these packages:

- libboost-dev
- libprotobuf-dev
- libprotoc-dev
- protobuf-compiler
- gprbuild
- gnat-9

## How to build and install.

```
$make all
$make install prefix=${PREFIX} # defaults to the gprinstall default.
```
