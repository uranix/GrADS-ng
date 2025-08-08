# FindHDF4.cmake - Find HDF4 installation
# This module finds an HDF4 installation (version 4.2.5 or later) that provides
# a hdf4-config.cmake package configuration file.
#
# Imported Targets:
# - HDF4::HDF        - HDF4 C library
# - HDF4::MFHDF      - HDF4 multi-file C interface library
# - HDF4::Fortran    - Fortran HDF4 library (if built)
# - HDF4::XDR        - RPC library
# - HDF4::F90CSTUB   - Fortran to C interface stubs
#
# Result Variables:
# - HDF4_FOUND          - True if HDF4 found
# - HDF4_INCLUDE_DIRS   - Directory containing HDF4 headers
# - HDF4_LIBRARIES      - All HDF4 libraries
# - HDF4_VERSION        - Full version string (e.g. "4.2.6")
# - HDF4_VERSION_MAJOR  - Major version number
# - HDF4_VERSION_MINOR  - Minor version number
#
# Example Usage:
# find_package(HDF4 REQUIRED)
# target_link_libraries(mytarget PRIVATE HDF4::MFHDF)

include(FindPackageHandleStandardArgs)
include(SelectLibraryConfigurations)
include(CMakeFindDependencyMacro)

# Separate paths for libraries and includes
set(_HDF4_BASE_PATHS
    $ENV{HDF4_ROOT}
    $ENV{HDF4_DIR}
    $ENV{HOME}/.local
    /usr
    /usr/local/hdf
    /usr/local
    /opt/hdf4
)

# Specific path suffixes for libraries
set(_HDF4_LIB_PATH_SUFFIXES
    lib
    lib64
    lib/hdf4
    lib64/hdf4
    Library
    Library/HDF4
    lib/${CMAKE_LIBRARY_ARCHITECTURE}  # For multiarch systems
)

# Specific path suffixes for includes
set(_HDF4_INCLUDE_PATH_SUFFIXES
    include
    include/hdf
    Include
    Include/HDF
)

# Find includes - using separate paths and suffixes
find_path(HDF4_INCLUDE_DIR
    NAMES hdf.h
    HINTS ${_HDF4_BASE_PATHS}
    PATH_SUFFIXES ${_HDF4_INCLUDE_PATH_SUFFIXES}
)

# For backwards compatibility
set(HDF4_INCLUDE_DIRS ${HDF4_INCLUDE_DIR})

# Try to extract version from header if not set
if(NOT HDF4_VERSION AND HDF4_INCLUDE_DIR AND EXISTS "${HDF4_INCLUDE_DIR}/h4config.h")
    file(STRINGS "${HDF4_INCLUDE_DIR}/h4config.h" _hdf_version_str
         REGEX "^#define H4_VERSION[ \t]+\"[0-9\\.]+\"")

    string(REGEX REPLACE ".*#define H4_VERSION[ \t]+\"([0-9\\.]+).*" "\\1"
           HDF4_VERSION "${_hdf_version_str}")
endif()

# Find all required libraries
set(_HDF4_LIB_NAMES
    hdf
    mfhdf
    df
    jpeg
    sz
    z
    xdr
)

# Find each library
set(HDF4_LIBRARIES)
foreach(lib IN LISTS _HDF4_LIB_NAMES)
    string(TOUPPER ${lib} LIB_UPPER)
    find_library(HDF4_${LIB_UPPER}_LIBRARY
        NAMES ${lib}
        HINTS ${_HDF4_BASE_PATHS}
        PATH_SUFFIXES ${_HDF4_LIB_PATH_SUFFIXES}
    )
    mark_as_advanced(HDF4_${LIB_UPPER}_LIBRARY)
    if(HDF4_${LIB_UPPER}_LIBRARY)
        list(APPEND HDF4_LIBRARIES ${HDF4_${LIB_UPPER}_LIBRARY})
    endif()
endforeach()

# Create imported targets
foreach(lib IN LISTS _HDF4_LIB_NAMES)
    string(TOUPPER ${lib} LIB_UPPER)
    if(HDF4_${LIB_UPPER}_LIBRARY AND NOT TARGET HDF4::${LIB_UPPER})
        add_library(HDF4::${LIB_UPPER} UNKNOWN IMPORTED)
        set_target_properties(HDF4::${LIB_UPPER} PROPERTIES
            IMPORTED_LOCATION "${HDF4_${LIB_UPPER}_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${HDF4_INCLUDE_DIRS}"
        )

        # Add dependencies
        if(LIB_UPPER STREQUAL "MFHDF")
            set_target_properties(HDF4::MFHDF PROPERTIES
                INTERFACE_LINK_LIBRARIES "HDF4::DF"
            )
        endif()
    endif()
endforeach()

# Handle standard arguments
find_package_handle_standard_args(HDF4
    REQUIRED_VARS HDF4_LIBRARIES HDF4_INCLUDE_DIRS
    VERSION_VAR HDF4_VERSION
    HANDLE_COMPONENTS
)

# Legacy variable support
if(HDF4_FOUND)
    set(HDF4_LIBRARIES)
    foreach(lib IN ITEMS HDF MFHDF Fortran XDR F90CSTUB)
        if(TARGET HDF4::${lib})
            list(APPEND HDF4_LIBRARIES HDF4::${lib})
        endif()
    endforeach()
endif()
