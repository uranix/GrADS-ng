#.rst:
# FindSHAPELIB
# -----------
#
# Find the SHAPELIB library (libshp)
#
# Imported Targets
# ^^^^^^^^^^^^^^^^
# This module defines the following IMPORTED target:
#   ``SHAPELIB::SHAPELIB``
#     The SHAPELIB library, if found
#
# Result Variables
# ^^^^^^^^^^^^^^^^
# This module will set the following variables in your project:
#   ``SHAPELIB_FOUND``
#     True if SHAPELIB is found
#   ``SHAPELIB_INCLUDE_DIRS``
#     Where to find shapefil.h
#   ``SHAPELIB_LIBRARIES``
#     The libraries needed to use SHAPELIB
#   ``SHAPELIB_VERSION``
#     The version of SHAPELIB found (if available)

# First check for a SHAPELIB_DIR or SHAPELIB_ROOT environment variable
if(NOT SHAPELIB_DIR AND DEFINED ENV{SHAPELIB_DIR})
  set(SHAPELIB_DIR "$ENV{SHAPELIB_DIR}" CACHE PATH "SHAPELIB installation directory")
endif()

if(NOT SHAPELIB_DIR AND DEFINED ENV{SHAPELIB_ROOT})
  set(SHAPELIB_DIR "$ENV{SHAPELIB_ROOT}" CACHE PATH "SHAPELIB installation directory")
endif()

if(SHAPELIB_DIR)
  # If SHAPELIB_DIR is specified, look there first
  find_path(SHAPELIB_INCLUDE_DIR
    NAMES shapefil.h
    PATHS "${SHAPELIB_DIR}"
    PATH_SUFFIXES include
    NO_DEFAULT_PATH
  )

  find_library(SHAPELIB_LIBRARY
    NAMES shp
    PATHS "${SHAPELIB_DIR}"
    PATH_SUFFIXES lib
    NO_DEFAULT_PATH
  )
else()
  # Standard system search
  find_path(SHAPELIB_INCLUDE_DIR
    NAMES shapefil.h
    PATH_SUFFIXES libshp
  )

  find_library(SHAPELIB_LIBRARY
    NAMES shp
  )
endif()

# Extract version if possible
if(SHAPELIB_INCLUDE_DIR AND EXISTS "${SHAPELIB_INCLUDE_DIR}/shapefil.h")
  file(STRINGS "${SHAPELIB_INCLUDE_DIR}/shapefil.h" _shapelib_version_str
    REGEX "^#define[ \t]+SHAPELIB_VERSION[ \t]+\"[0-9.]+\"")
  
  if(_shapelib_version_str)
    string(REGEX REPLACE "^#define[ \t]+SHAPELIB_VERSION[ \t]+\"([0-9.]+)\".*$" "\\1"
      SHAPELIB_VERSION "${_shapelib_version_str}")
  endif()
  unset(_shapelib_version_str)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SHAPELIB
  REQUIRED_VARS SHAPELIB_LIBRARY SHAPELIB_INCLUDE_DIR
  VERSION_VAR SHAPELIB_VERSION
)

if(SHAPELIB_FOUND)
  set(SHAPELIB_INCLUDE_DIRS "${SHAPELIB_INCLUDE_DIR}")
  set(SHAPELIB_LIBRARIES "${SHAPELIB_LIBRARY}")

  if(NOT TARGET SHAPELIB::SHAPELIB)
    add_library(SHAPELIB::SHAPELIB UNKNOWN IMPORTED)
    set_target_properties(SHAPELIB::SHAPELIB PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${SHAPELIB_INCLUDE_DIR}"
      IMPORTED_LOCATION "${SHAPELIB_LIBRARY}"
    )
  endif()
endif()

mark_as_advanced(
  SHAPELIB_INCLUDE_DIR
  SHAPELIB_LIBRARY
)
