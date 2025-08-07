#.rst:
# FindGrib2C
# ----------
#
# Find the Grib2C library (g2c)
#
# Imported Targets
# ^^^^^^^^^^^^^^^^
# This module defines the following IMPORTED target:
#   ``Grib2C::Grib2C``
#     The Grib2C library, if found
#
# Result Variables
# ^^^^^^^^^^^^^^^^
# This module will set the following variables in your project:
#   ``Grib2C_FOUND``
#     True if Grib2C is found
#   ``Grib2C_INCLUDE_DIRS``
#     Where to find grib2.h
#   ``Grib2C_LIBRARIES``
#     The libraries needed to use Grib2C
#   ``Grib2C_VERSION``
#     The version of Grib2C found (if available)
#
# Hints
# ^^^^^
# Users may set the following variables to guide the search:
#   ``Grib2C_ROOT``
#     Root directory of Grib2C installation
#   ``Grib2C_INCLUDEDIR``
#     Directory containing Grib2C headers
#   ``Grib2C_LIBRARYDIR``
#     Directory containing Grib2C libraries

# Support both environment variables and CMake variables
if(NOT Grib2C_ROOT AND DEFINED ENV{Grib2C_ROOT})
  set(Grib2C_ROOT "$ENV{Grib2C_ROOT}" CACHE PATH "Grib2C installation root")
endif()

if(NOT Grib2C_INCLUDEDIR AND DEFINED ENV{Grib2C_INCLUDEDIR})
  set(Grib2C_INCLUDEDIR "$ENV{Grib2C_INCLUDEDIR}" CACHE PATH "Grib2C include directory")
endif()

if(NOT Grib2C_LIBRARYDIR AND DEFINED ENV{Grib2C_LIBRARYDIR})
  set(Grib2C_LIBRARYDIR "$ENV{Grib2C_LIBRARYDIR}" CACHE PATH "Grib2C library directory")
endif()

# Set up search paths with priority:
# 1. Explicitly specified directories
# 2. Grib2C_ROOT
# 3. System paths
set(_Grib2C_INCLUDE_PATHS)
set(_Grib2C_LIBRARY_PATHS)

if(Grib2C_INCLUDEDIR)
  list(APPEND _Grib2C_INCLUDE_PATHS "${Grib2C_INCLUDEDIR}")
endif()

if(Grib2C_LIBRARYDIR)
  list(APPEND _Grib2C_LIBRARY_PATHS "${Grib2C_LIBRARYDIR}")
endif()

if(Grib2C_ROOT)
  list(APPEND _Grib2C_INCLUDE_PATHS "${Grib2C_ROOT}/include")
  list(APPEND _Grib2C_LIBRARY_PATHS "${Grib2C_ROOT}/lib")
endif()

list(APPEND _Grib2C_INCLUDE_PATHS
  ${CUSTOM_THIRDDIR}/include
  /usr/include
  /usr/local/include
)

list(APPEND _Grib2C_LIBRARY_PATHS
  ${CUSTOM_THIRDDIR}/lib
  /usr/lib64
  /usr/lib
  /usr/local/lib
  /usr/local/lib64
)

# Only search for standard library names
set(_Grib2C_LIB_NAMES grib2c g2c)

find_path(Grib2C_INCLUDE_DIR
  NAMES grib2.h
  PATHS ${_Grib2C_INCLUDE_PATHS}
  PATH_SUFFIXES grib2
)

find_library(Grib2C_LIBRARY
  NAMES ${_Grib2C_LIB_NAMES}
  PATHS ${_Grib2C_LIBRARY_PATHS}
)

# Try to extract version from header if found
if(Grib2C_INCLUDE_DIR AND EXISTS "${Grib2C_INCLUDE_DIR}/grib2.h")
  file(STRINGS "${Grib2C_INCLUDE_DIR}/grib2.h" _Grib2C_version_str
    REGEX "#define[ \t]+G2_VERSION[ \t]+\"[0-9.]+\"")
  
  if(_Grib2C_version_str)
    string(REGEX REPLACE "^.*G2_VERSION[ \t]+\"([0-9.]+)\".*$" "\\1"
      Grib2C_VERSION "${_Grib2C_version_str}")
  endif()
  unset(_Grib2C_version_str)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Grib2C
  REQUIRED_VARS Grib2C_LIBRARY Grib2C_INCLUDE_DIR
  VERSION_VAR Grib2C_VERSION
)

if(Grib2C_FOUND)
  set(Grib2C_INCLUDE_DIRS "${Grib2C_INCLUDE_DIR}")
  set(Grib2C_LIBRARIES "${Grib2C_LIBRARY}")

  if(NOT TARGET Grib2C::Grib2C)
    add_library(Grib2C::Grib2C UNKNOWN IMPORTED)
    set_target_properties(Grib2C::Grib2C PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${Grib2C_INCLUDE_DIR}"
      IMPORTED_LOCATION "${Grib2C_LIBRARY}"
    )
  endif()
endif()

mark_as_advanced(
  Grib2C_INCLUDE_DIR
  Grib2C_LIBRARY
)
