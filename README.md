# MulleObjCKVCFoundation

#### 🔑 Key-Value-Coding based on MulleObjCStandardFoundation

Adds key-value coding to the class system. This is a runtime interpretation
scheme, so that you can write `[foo valueForKey:@"bar.baz"]` as a short-cut
for `[[foo bar] baz]` for example.

This adds a lot of methods to NSObject, NSArray, NSSet et al. via categories.



| Release Version                                       | Release Notes
|-------------------------------------------------------|--------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleFoundation/MulleObjCKVCFoundation.svg?branch=release) [![Build Status](https://github.com/MulleFoundation/MulleObjCKVCFoundation/workflows/CI/badge.svg?branch=release)](//github.com/MulleFoundation/MulleObjCKVCFoundation/actions) | [RELEASENOTES](RELEASENOTES.md) |






## Requirements

|   Requirement         | Release Version  | Description
|-----------------------|------------------|---------------
| [MulleObjCStandardFoundation](https://github.com/MulleFoundation/MulleObjCStandardFoundation) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag//.svg) [![Build Status](https://github.com///workflows/CI/badge.svg?branch=release)](https://github.com///actions/workflows/mulle-sde-ci.yml) | 🚤 Objective-C classes based on the C standard library
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag//.svg) [![Build Status](https://github.com///workflows/CI/badge.svg?branch=release)](https://github.com///actions/workflows/mulle-sde-ci.yml) | 📒 Lists mulle-objc runtime information contained in executables.

### You are here

![Overview](overview.dot.svg)

## Add

Use [mulle-sde](//github.com/mulle-sde) to add MulleObjCKVCFoundation to your project:

``` sh
mulle-sde add github:MulleFoundation/MulleObjCKVCFoundation
```

## Install

### Install with mulle-sde

Use [mulle-sde](//github.com/mulle-sde) to build and install MulleObjCKVCFoundation and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com/MulleFoundation/MulleObjCKVCFoundation/archive/latest.tar.gz
```

### Manual Installation

Install the requirements:

| Requirements                                 | Description
|----------------------------------------------|-----------------------
| [MulleObjCStandardFoundation](https://github.com/MulleFoundation/MulleObjCStandardFoundation)             | 🚤 Objective-C classes based on the C standard library
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list)             | 📒 Lists mulle-objc runtime information contained in executables.

Download the latest [tar](https://github.com/MulleFoundation/MulleObjCKVCFoundation/archive/refs/tags/latest.tar.gz) or [zip](https://github.com/MulleFoundation/MulleObjCKVCFoundation/archive/refs/tags/latest.zip) archive and unpack it.

Install **MulleObjCKVCFoundation** into `/usr/local` with [cmake](https://cmake.org):

``` sh
cmake -B build \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_PREFIX_PATH=/usr/local \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```

## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK  


