# FindUdunits.cmake - Locate the UDUNITS-2 library
#
# This module defines:
#   Udunits_FOUND - System has UDUNITS-2
#   Udunits::udunits - Imported target for UDUNITS-2 library

include(FindPackageHandleStandardArgs)

# Primary search for the library
find_library(Udunits_LIBRARY
  NAMES udunits2 udunits
  PATH_SUFFIXES lib lib64
  DOC "UDUNITS-2 library path"
)

# Search for the header
find_path(Udunits_INCLUDE_DIR
  NAMES udunits2.h
  PATH_SUFFIXES include udunits2
  DOC "UDUNITS-2 include directory"
)

# Handle standard arguments and set Udunits_FOUND
find_package_handle_standard_args(Udunits
  REQUIRED_VARS Udunits_LIBRARY Udunits_INCLUDE_DIR
)

# Create imported target if not already defined and found
if(Udunits_FOUND AND NOT TARGET Udunits::udunits)
  add_library(Udunits::udunits UNKNOWN IMPORTED)
  
  set_target_properties(Udunits::udunits PROPERTIES
    IMPORTED_LOCATION "${Udunits_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${Udunits_INCLUDE_DIR}"
    INTERFACE_COMPILE_DEFINITIONS "HAVE_UDUNITS2"
  )
  
  # Handle potential dependencies
  find_package(Threads QUIET)
  if(Threads_FOUND)
    target_link_libraries(Udunits::udunits INTERFACE Threads::Threads)
  endif()
  
  # Mark advanced variables
  mark_as_advanced(
    Udunits_LIBRARY
    Udunits_INCLUDE_DIR
  )
endif()
