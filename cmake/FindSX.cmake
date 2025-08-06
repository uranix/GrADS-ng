# - Find the SX Graphics Library (libsx) with X11 dependencies
#
# This module defines:
#  SX_FOUND - system has libsx and its dependencies
#  SX_INCLUDE_DIR - the libsx include directory
#  SX_LIBRARIES - all libraries needed to use libsx (including Xt)

# First find X11 components (required by libsx)
find_package(X11 REQUIRED COMPONENTS Xt)

# Then search for libsx
find_path(SX_INCLUDE_DIR
  NAMES libsx.h
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    ${CMAKE_INSTALL_PREFIX}/include
  PATH_SUFFIXES libsx
)

find_library(SX_LIBRARY
  NAMES sx libsx
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    ${CMAKE_INSTALL_PREFIX}/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SX
  REQUIRED_VARS 
    SX_LIBRARY 
    SX_INCLUDE_DIR
    X11_Xt_LIB
  FAIL_MESSAGE "Could NOT find SX (missing: SX_LIBRARY SX_INCLUDE_DIR or Xt)"
)

if(SX_FOUND)
  # Combine all required libraries
  set(SX_LIBRARIES ${SX_LIBRARY} ${X11_Xt_LIB} ${X11_LIBRARIES})
  
  # Create imported target with all dependencies
  if(NOT TARGET SX::SX)
    add_library(SX::SX UNKNOWN IMPORTED)
    set_target_properties(SX::SX PROPERTIES
      IMPORTED_LOCATION "${SX_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${SX_INCLUDE_DIR}"
      INTERFACE_LINK_LIBRARIES "${X11_Xt_LIB};${X11_LIBRARIES}"
    )
  endif()
endif()

mark_as_advanced(
  SX_INCLUDE_DIR
  SX_LIBRARY
)
