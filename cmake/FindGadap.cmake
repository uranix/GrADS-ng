# FindGadap.cmake - Locate GADAP library
#
# This module defines:
#   GADAP_FOUND          - System has GADAP
#   GADAP_INCLUDE_DIRS   - GADAP include directories
#   GADAP_LIBRARIES      - Libraries needed to use GADAP
#   GADAP::GADAP         - Imported target for GADAP

include(FindPackageHandleStandardArgs)

# Possible root paths to search
set(_GADAP_ROOT_HINTS
    ${GADAP_ROOT}
    $ENV{GADAP_ROOT}
    /usr/local
    /usr
    /opt
)

# Header search paths
find_path(GADAP_INCLUDE_DIR
    NAMES gadap.h
    HINTS ${_GADAP_ROOT_HINTS}
    PATH_SUFFIXES include include/gadap gadap
    DOC "GADAP include directory"
)

# Library search paths
find_library(GADAP_LIBRARY
    NAMES gadap
    HINTS ${_GADAP_ROOT_HINTS}
    PATH_SUFFIXES lib lib64 lib/gadap
    DOC "GADAP library"
)

# Handle standard arguments
find_package_handle_standard_args(Gadap
    REQUIRED_VARS GADAP_LIBRARY GADAP_INCLUDE_DIR
)

if(GADAP_FOUND)
    # Set standard variables
    set(GADAP_LIBRARIES ${GADAP_LIBRARY})
    set(GADAP_INCLUDE_DIRS ${GADAP_INCLUDE_DIR})

    # Create imported target if not already defined
    if(NOT TARGET GADAP::GADAP)
        add_library(GADAP::GADAP UNKNOWN IMPORTED)
        set_target_properties(GADAP::GADAP PROPERTIES
            IMPORTED_LOCATION "${GADAP_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${GADAP_INCLUDE_DIR}"
        )

        find_package(LIBDAP QUIET)
        if(LIBDAP_FOUND)
            target_link_libraries(GADAP::GADAP INTERFACE LIBDAP::LIBDAP)
        endif()
    endif()
endif()

mark_as_advanced(
    GADAP_INCLUDE_DIR
    GADAP_LIBRARY
)
