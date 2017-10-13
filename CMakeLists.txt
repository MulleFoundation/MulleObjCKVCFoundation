cmake_minimum_required (VERSION 3.0)

project( MulleObjCKVCFoundation C)


set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
   ${CMAKE_SOURCE_DIR}/mulle-configuration/cmake)
message(STATUS "CMAKE_MODULE_PATH is ${CMAKE_MODULE_PATH}")
message(STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")

set( MULLE_LANGUAGE "ObjC")

if( "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  include( Debug)
else()
  include( Release)
endif()

##### CMakeSourcesAndHeaders.txt GENERATED FROM XCODE PROJECT
## MEMO: recreate this with mulle-xcode-to-cmake 0.5.2 or better
##       mulle-xcode-to-cmake -t MulleObjCStandardFoundation \
##                            -t MulleObjCArchiver \
##                            -t MulleObjCCore \
##                            -t MulleObjCKVC \
##                            -t MulleObjCLocale \
##                            -t MulleObjCNotification \
##                            -t MulleObjCPropertyList \
##                            sexport  \
##                            MulleObjCFoundation.xcodeproj > CMakeSourcesAndHeaders.txt
##### CMakeSourcesAndHeaders.txt GENERATED FROM XCODE PROJECT

set( MULLE_OBJC_KVC_FOUNDATION_LIBRARY ON)
include( CMakeDependencies.txt)
include( CMakeSourcesAndHeaders.txt)

include_directories( ${INCLUDE_DIRS})


set( PUBLIC_HEADERS
${PUBLIC_HEADERS}
"CMakeDependencies.txt"
"src/dependencies.inc"
)

add_library( MulleObjCKVCFoundation STATIC
${SOURCES}
${PUBLIC_HEADERS}
${PRIVATE_HEADERS}
CMakeSourcesAndHeaders.txt
)

set( OBJC_LIBRARY_NAME "MulleObjCKVCFoundation")

include( DependenciesIncObjC)


#
# produce a standalone dll/dylib/so for testing mainly
# though testing could go static at some point in time
# (shared is more frugal though)
#
set( STANDALONE_BASE_NAME "MulleObjCKVCFoundation")
set( STANDALONE_NAME "MulleObjCKVCFoundationStandalone")
set( STANDALONE_DEFINITIONS ${MULLE_OBJC_KVC_FOUNDATION_DEFINITIONS})
set( STANDALONE_ALL_LOAD_LIBRARIES
    $<TARGET_FILE:${STANDALONE_BASE_NAME}>
    ${OBJC_DEPENDENCY_LIBRARIES}
    ${OBJC_STARTUP_LIBRARY}
    ${C_DEPENDENCY_LIBRARIES}
)

include( Standalone)

install( TARGETS MulleObjCKVCFoundation MulleObjCKVCFoundationStandalone DESTINATION "lib")
install( FILES ${PUBLIC_HEADERS} DESTINATION "include/MulleObjCKVCFoundation")
install( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjCKVCFoundation/private")

include( MulleTest)
