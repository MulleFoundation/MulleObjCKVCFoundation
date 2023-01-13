# This file will be regenerated by `mulle-sourcetree-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Files.cmake
#
# Disable generation of this file with:
#
# mulle-sde environment set MULLE_SOURCETREE_TO_CMAKE_DEPENDENCIES_FILE DISABLE
#
if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# Generated from sourcetree: CD7C4BB0-69E8-44C1-A63F-84473F919E0E;MulleObjCStandardFoundation;no-singlephase;
# Disable with : `mulle-sourcetree mark MulleObjCStandardFoundation no-link`
# Disable for this platform: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-platform-${MULLE_UNAME}`
# Disable for a sdk: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-sdk-<name>`
#
if( NOT MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY)
   find_library( MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}MulleObjCStandardFoundation${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX} ${CMAKE_STATIC_LIBRARY_PREFIX}MulleObjCStandardFoundation${CMAKE_STATIC_LIBRARY_SUFFIX} MulleObjCStandardFoundation NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY is ${MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY)
      #
      # Add MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY to ALL_LOAD_DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-add`
      #
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         ${ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT "${MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-dependency`
      #
      foreach( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME "MulleObjCStandardFoundation")
         set( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT}/include/${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_OBJC_STANDARD_FOUNDATION_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}")
            #
            include( "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}/DependenciesAndLibraries.cmake")
            #
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_OBJC_STANDARD_FOUNDATION_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
      #
      # Search for "MulleObjCLoader+<name>.h" in include directory.
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-loader`
      #
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME "MulleObjCStandardFoundation")
            set( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_FILE "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT}/include/${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME}/MulleObjCLoader+${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME}.h")
            if( EXISTS "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-require-link`
      message( FATAL_ERROR "MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY was not found")
   endif()
endif()
