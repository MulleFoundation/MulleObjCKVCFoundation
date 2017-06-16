cmake_minimum_required (VERSION 3.0)

project (MulleObjCKVCFoundation)

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
##       mulle-xcode-to-cmake -t MulleObjCFoundation \
##                            -t MulleObjCArchiver \
##                            -t MulleObjCCore \
##                            -t MulleObjCKVC \
##                            -t MulleObjCLocale \
##                            -t MulleObjCNotification \
##                            -t MulleObjCPropertyList \
##                            sexport  \
##                            MulleObjCFoundation.xcodeproj > CMakeSourcesAndHeaders.txt
##### CMakeSourcesAndHeaders.txt GENERATED FROM XCODE PROJECT

include( CMakeSourcesAndHeaders.txt)

find_library( MULLE_ABA_LIBRARY             NAMES mulle_aba)
find_library( MULLE_ALLOCATOR_LIBRARY       NAMES mulle_allocator)
find_library( MULLE_BUFFER_LIBRARY          NAMES mulle_buffer)
find_library( MULLE_CONCURRENT_LIBRARY      NAMES mulle_concurrent)
find_library( MULLE_CONTAINER_LIBRARY       NAMES mulle_container)
find_library( MULLE_OBJC_FOUNDATION_LIBRARY NAMES MulleObjCFoundation)
find_library( MULLE_OBJC_LIBRARY            NAMES MulleObjC)
find_library( MULLE_OBJC_RUNTIME_LIBRARY    NAMES mulle_objc)
find_library( MULLE_SPRINTF_LIBRARY         NAMES mulle_sprintf)
find_library( MULLE_TEST_ALLOCATOR_LIBRARY  NAMES mulle_test_allocator)
find_library( MULLE_THREAD_LIBRARY          NAMES mulle_thread)
find_library( MULLE_UTF_LIBRARY             NAMES mulle_utf)


message(STATUS "MULLE_ABA_LIBRARY is ${MULLE_ABA_LIBRARY}")
message(STATUS "MULLE_ALLOCATOR_LIBRARY is ${MULLE_ALLOCATOR_LIBRARY}")
message(STATUS "MULLE_BUFFER_LIBRARY is ${MULLE_BUFFER_LIBRARY}")
message(STATUS "MULLE_CONCURRENT_LIBRARY is ${MULLE_CONCURRENT_LIBRARY}")
message(STATUS "MULLE_CONTAINER_LIBRARY is ${MULLE_CONTAINER_LIBRARY}")
message(STATUS "MULLE_OBJC_FOUNDATION_LIBRARY is ${MULLE_OBJC_FOUNDATION_LIBRARY}")
message(STATUS "MULLE_OBJC_LIBRARY is ${MULLE_OBJC_LIBRARY}")
message(STATUS "MULLE_OBJC_RUNTIME_LIBRARY is ${MULLE_OBJC_RUNTIME_LIBRARY}")
message(STATUS "MULLE_SPRINTF_LIBRARY is ${MULLE_SPRINTF_LIBRARY}")
message(STATUS "MULLE_TEST_ALLOCATOR_LIBRARY is ${MULLE_TEST_ALLOCATOR_LIBRARY}")
message(STATUS "MULLE_THREAD_LIBRARY is ${MULLE_THREAD_LIBRARY}")
message(STATUS "MULLE_UTF_LIBRARY is ${MULLE_UTF_LIBRARY}")


set( C_DEPENDENCY_LIBRARIES
${MULLE_ABA_LIBRARY}
${MULLE_ALLOCATOR_LIBRARY}
${MULLE_BUFFER_LIBRARY}
${MULLE_CONCURRENT_LIBRARY}
${MULLE_CONTAINER_LIBRARY}
${MULLE_OBJC_RUNTIME_LIBRARY}
${MULLE_SPRINTF_LIBRARY}
${MULLE_TEST_ALLOCATOR_LIBRARY}
${MULLE_THREAD_LIBRARY}
${MULLE_UTF_LIBRARY}
)

set( OBJC_DEPENDENCY_LIBRARIES
${MULLE_OBJC_FOUNDATION_LIBRARY}
${MULLE_OBJC_LIBRARY}
)

set( DEPENDENCY_LIBRARIES
${C_DEPENDENCY_LIBRARIES}
${OBJC_DEPENDENCY_LIBRARIES}
)


add_library( MulleObjCKVCFoundation STATIC
${SOURCES}
# for IDEs
${HEADERS}
${PRIVATE_HEADERS}
)

add_library( MulleObjCKVCFoundationStandalone SHARED
src/MulleObjCKVCFoundationStandalone.m
)

add_dependencies( MulleObjCKVCFoundationStandalone MulleObjCKVCFoundation)


TARGET_LINK_LIBRARIES( MulleObjCKVCFoundationStandalone
${BEGIN_ALL_LOAD}
MulleObjCKVCFoundation
${DEPENDENCY_LIBRARIES}
${END_ALL_LOAD}
)

INSTALL( TARGETS MulleObjCKVCFoundation MulleObjCKVCFoundationStandalone DESTINATION "lib")
INSTALL( FILES ${HEADERS} DESTINATION "include/MulleObjCKVCFoundation")
# INSTALL( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjCKVCFoundation/Private")

