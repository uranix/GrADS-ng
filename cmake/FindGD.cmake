# FindGD - Find the GD graphics library
#
# This module defines the following IMPORTED targets:
#   GD::GD - The GD library
#
# This module will set the following variables:
#   GD_FOUND - True if GD is found
#   GD_INCLUDE_DIRS - GD include directories
#   GD_LIBRARIES - Libraries needed to use GD
#   GD_VERSION - Version of GD found
#   GD_SUPPORTS_PNG - True if GD supports PNG
#   GD_SUPPORTS_JPEG - True if GD supports JPEG
#   GD_SUPPORTS_GIF - True if GD supports GIF

find_path(GD_INCLUDE_DIR
  NAMES gd.h
  PATH_SUFFIXES gd
)

if(WIN32 AND NOT CYGWIN)
  set(GD_NAMES bgd gd)
else()
  set(GD_NAMES gd)
endif()

find_library(GD_LIBRARY
  NAMES ${GD_NAMES}
)

if(GD_INCLUDE_DIR AND GD_LIBRARY)
  set(GD_FOUND TRUE)
  
  # Try to extract version from gd.h
  if(EXISTS "${GD_INCLUDE_DIR}/gd.h")
    file(STRINGS "${GD_INCLUDE_DIR}/gd.h" _gd_version_str
      REGEX "^#[ \t]*define[ \t]+GD_MAJOR_VERSION[ \t]+[0-9]+")
    string(REGEX REPLACE "^.*GD_MAJOR_VERSION[ \t]+([0-9]+).*$" "\\1" 
      _gd_major_version "${_gd_version_str}")
    
    file(STRINGS "${GD_INCLUDE_DIR}/gd.h" _gd_version_str
      REGEX "^#[ \t]*define[ \t]+GD_MINOR_VERSION[ \t]+[0-9]+")
    string(REGEX REPLACE "^.*GD_MINOR_VERSION[ \t]+([0-9]+).*$" "\\1" 
      _gd_minor_version "${_gd_version_str}")
    
    file(STRINGS "${GD_INCLUDE_DIR}/gd.h" _gd_version_str
      REGEX "^#[ \t]*define[ \t]+GD_RELEASE_VERSION[ \t]+[0-9]+")
    string(REGEX REPLACE "^.*GD_RELEASE_VERSION[ \t]+([0-9]+).*$" "\\1" 
      _gd_release_version "${_gd_version_str}")
    
    set(GD_VERSION "${_gd_major_version}.${_gd_minor_version}.${_gd_release_version}")
    unset(_gd_version_str)
    unset(_gd_major_version)
    unset(_gd_minor_version)
    unset(_gd_release_version)
  endif()
  
  # Check for format support
  include(CheckLibraryExists)
  get_filename_component(_gd_lib_path "${GD_LIBRARY}" DIRECTORY)
  
  if(WIN32 AND NOT CYGWIN)
    # Windows binary distributions typically support all formats
    set(GD_SUPPORTS_PNG TRUE)
    set(GD_SUPPORTS_JPEG TRUE)
    set(GD_SUPPORTS_GIF TRUE)
  else()
    check_library_exists("${GD_LIBRARY}" gdImagePng "${_gd_lib_path}" GD_SUPPORTS_PNG)
    check_library_exists("${GD_LIBRARY}" gdImageJpeg "${_gd_lib_path}" GD_SUPPORTS_JPEG)
    check_library_exists("${GD_LIBRARY}" gdImageGif "${_gd_lib_path}" GD_SUPPORTS_GIF)
  endif()
  
  # Find dependencies for supported formats
  set(GD_LIBRARIES ${GD_LIBRARY})
  set(GD_INCLUDE_DIRS ${GD_INCLUDE_DIR})
  
  if(GD_SUPPORTS_PNG)
    find_package(PNG QUIET)
    if(PNG_FOUND)
      list(APPEND GD_LIBRARIES ${PNG_LIBRARIES})
      list(APPEND GD_INCLUDE_DIRS ${PNG_INCLUDE_DIRS})
    else()
      set(GD_SUPPORTS_PNG FALSE)
    endif()
  endif()
  
  if(GD_SUPPORTS_JPEG)
    find_package(JPEG QUIET)
    if(JPEG_FOUND)
      list(APPEND GD_LIBRARIES ${JPEG_LIBRARIES})
      list(APPEND GD_INCLUDE_DIRS ${JPEG_INCLUDE_DIRS})
    else()
      set(GD_SUPPORTS_JPEG FALSE)
    endif()
  endif()
  
  # Remove duplicate include directories
  list(REMOVE_DUPLICATES GD_INCLUDE_DIRS)
  
  # Create imported target
  if(NOT TARGET GD::GD)
    add_library(GD::GD UNKNOWN IMPORTED)
    set_target_properties(GD::GD PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${GD_INCLUDE_DIRS}"
      IMPORTED_LOCATION "${GD_LIBRARY}"
    )
    
    if(GD_SUPPORTS_PNG AND PNG_FOUND)
      target_link_libraries(GD::GD INTERFACE PNG::PNG)
    endif()
    
    if(GD_SUPPORTS_JPEG AND JPEG_FOUND)
      target_link_libraries(GD::GD INTERFACE JPEG::JPEG)
    endif()
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GD
  REQUIRED_VARS GD_LIBRARY GD_INCLUDE_DIR
  VERSION_VAR GD_VERSION
)

mark_as_advanced(
  GD_INCLUDE_DIR
  GD_LIBRARY
)

if(GD_FOUND)
  if(NOT GD_FIND_QUIETLY)
    message(STATUS "Found GD: ${GD_LIBRARY} (version ${GD_VERSION})")
    message(STATUS "  Supports PNG: ${GD_SUPPORTS_PNG}")
    message(STATUS "  Supports JPEG: ${GD_SUPPORTS_JPEG}")
    message(STATUS "  Supports GIF: ${GD_SUPPORTS_GIF}")
  endif()
else()
  if(GD_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find GD library")
  endif()
endif()
