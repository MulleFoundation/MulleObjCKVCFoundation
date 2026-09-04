### 0.21.0

* feature: add add_subdirectory and multi-reflect support to CMake build
* dependencies can now resolve to existing cmake targets before falling back to find_library, enabling add_subdirectory consumption
* usage requirements of cmake-target dependencies are inherited by compile targets
* keep whole-archive semantics for all-load dependencies on CMake >= 3.24
* reflected header/include lists, reflect output directories and _Dependencies/_Libraries locations are now configurable
* README API table of contents relocated to asset/dox/api/toc

### 0.20.10

Various small improvements