# MulleObjCKVCFoundation

#### 🔑 Key-Value-Coding based on MulleObjCStandardFoundation

Adds key-value coding to the class system. This is a runtime interpretation
scheme, so that you can write `[foo valueForKey:@"bar.baz"]` as a short-cut
for `[[foo bar] baz]` for example.

This adds a lot of methods to NSObject, NSArray, NSSet et al. via categories.



| Release Version                                       | Release Notes  | AI Documentation
|-------------------------------------------------------|----------------|---------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleFoundation/MulleObjCKVCFoundation.svg) [![Build Status](https://github.com/MulleFoundation/MulleObjCKVCFoundation/workflows/CI/badge.svg)](//github.com/MulleFoundation/MulleObjCKVCFoundation/actions) | [RELEASENOTES](RELEASENOTES.md) | [DeepWiki for MulleObjCKVCFoundation](https://deepwiki.com/MulleFoundation/MulleObjCKVCFoundation)






## Requirements

|   Requirement         | Release Version  | Description
|-----------------------|------------------|---------------
| [MulleObjCStandardFoundation](https://github.com/MulleFoundation/MulleObjCStandardFoundation) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleFoundation/MulleObjCStandardFoundation.svg) [![Build Status](https://github.com/MulleFoundation/MulleObjCStandardFoundation/workflows/CI/badge.svg?branch=release)](https://github.com/MulleFoundation/MulleObjCStandardFoundation/actions/workflows/mulle-sde-ci.yml) | 🚤 Objective-C classes based on the C standard library
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/mulle-objc-list.svg) [![Build Status](https://github.com/mulle-objc/mulle-objc-list/workflows/CI/badge.svg?branch=release)](https://github.com/mulle-objc/mulle-objc-list/actions/workflows/mulle-sde-ci.yml) | 📒 Lists mulle-objc runtime information contained in executables.

### You are here

![Overview](overview.dot.svg)

## Add

**This project is a component of the [MulleFoundation](//github.com/MulleFoundation/MulleFoundation) library.
As such you usually will *not* add or install it individually, unless you
specifically do not want to link against `MulleFoundation`.**


### Add as an individual component

Use [mulle-sde](//github.com/mulle-sde) to add MulleObjCKVCFoundation to your project:

``` sh
mulle-sde add github:MulleFoundation/MulleObjCKVCFoundation
```

To only add the sources of MulleObjCKVCFoundation with dependency
sources use [clib](https://github.com/clibs/clib):


``` sh
clib install --out src/MulleFoundation MulleFoundation/MulleObjCKVCFoundation
```

Add `-isystem src/MulleFoundation` to your `CFLAGS` and compile all the sources that were downloaded with your project.


## Install

Use [mulle-sde](//github.com/mulle-sde) to build and install MulleObjCKVCFoundation and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com/MulleFoundation/MulleObjCKVCFoundation/archive/latest.tar.gz
```

### Legacy Installation

Install the requirements:

| Requirements                                 | Description
|----------------------------------------------|-----------------------
| [MulleObjCStandardFoundation](https://github.com/MulleFoundation/MulleObjCStandardFoundation)             | 🚤 Objective-C classes based on the C standard library
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list)             | 📒 Lists mulle-objc runtime information contained in executables.

Download the latest [tar](https://github.com/MulleFoundation/MulleObjCKVCFoundation/archive/refs/tags/latest.tar.gz) or [zip](https://github.com/MulleFoundation/MulleObjCKVCFoundation/archive/refs/tags/latest.zip) archive and unpack it.

Install **MulleObjCKVCFoundation** into `/usr/local` with [cmake](https://cmake.org):

``` sh
PREFIX_DIR="/usr/local"
cmake -B build                               \
      -DMULLE_SDK_PATH="${PREFIX_DIR}"       \
      -DCMAKE_INSTALL_PREFIX="${PREFIX_DIR}" \
      -DCMAKE_PREFIX_PATH="${PREFIX_DIR}"    \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```

## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK  


