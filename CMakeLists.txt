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


add_library( MulleObjCKVCFoundation STATIC
${SOURCES}
${PUBLIC_HEADERS}
${PRIVATE_HEADERS}
CMakeDependencies.txt
CMakeSourcesAndHeaders.txt
)

target_link_libraries( MulleObjCKVCFoundation
)

add_library( MulleObjCKVCFoundationStandalone SHARED
src/MulleObjCKVCFoundationStandalone.m
)

add_dependencies( MulleObjCKVCFoundationStandalone MulleObjCKVCFoundation)


target_link_libraries( MulleObjCKVCFoundationStandalone
${BEGIN_ALL_LOAD}
MulleObjCKVCFoundation
${OBJC_DEPENDENCY_LIBRARIES}
${C_DEPENDENCY_LIBRARIES}
${END_ALL_LOAD}
${OS_SPECIFIC_LIBRARIES}
)

message( STATUS "OBJC_DEPENDENCY_NAMES is ${OBJC_DEPENDENCY_NAMES}")

# runs in build dir
add_custom_command( TARGET MulleObjCKVCFoundationStandalone
   POST_BUILD
   COMMAND ${DEPENDENCIES_DIR}/bin/mulle-objc-create-dependencies-inc -v -o ${CMAKE_SOURCE_DIR}/src/dependencies.inc MulleObjCKVCFoundation ${OBJC_DEPENDENCY_NAMES}
)

set( PUBLIC_HEADERS
${PUBLIC_HEADERS}
"CMakeDependencies.txt"
"src/dependencies.inc"
)

install( TARGETS MulleObjCKVCFoundation MulleObjCKVCFoundationStandalone DESTINATION "lib")
install( FILES ${PUBLIC_HEADERS} DESTINATION "include/MulleObjCKVCFoundation")
install( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjCKVCFoundation/private")

