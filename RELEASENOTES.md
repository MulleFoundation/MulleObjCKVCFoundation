## 0.21.0


feature: add `add_subdirectory` and multi-reflect support to CMake build

* dependencies can now resolve to existing cmake targets before falling back to `find_library,` enabling `add_subdirectory` consumption
* usage requirements (include dirs, definitions, build order) of cmake-target dependencies are inherited by compile targets
* ordinary, framework, startup and all-load dependency targets are exported through the INTERFACE so downstream consumers need only link the library
* keep whole-archive semantics for all-load dependencies on CMake >= 3.24
* HEADERS.cmake filters header/include lists to the active reflect tree when multi-reflect is enabled
* reflect output directories and `_Dependencies/_Libraries` locations are now configurable via `MULLE_SRE_REFLECT_DIR`
* build consumers no longer receive a phantom source-tree include when no include/ directory is shipped
