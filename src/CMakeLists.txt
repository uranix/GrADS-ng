include(CheckIncludeFile)
include(CheckLibraryExists)
include(CheckFunctionExists)
include(CheckSymbolExists)

if(USEGADAP)
    set(src_gadap
        dodstn.c
    )
endif()

if(USEGUI)
    set(src_gui
        gagui.c
        gsgui.c
    )
endif()

if(CMAKE_C_BYTE_ORDER STREQUAL "BIG_ENDIAN")
  set(BYTEORDER 1)
elseif(CMAKE_C_BYTE_ORDER STREQUAL "LITTLE_ENDIAN")
  set(BYTEORDER 0)
else()
  set(BYTEORDER 0)
message(WARNING "Endianness could not be determined.")
endif()

check_include_file("dlfcn.h" HAVE_DLFCN_H)
check_include_file("inttypes.h" HAVE_INTTYPES_H)
check_include_file("malloc.h" HAVE_MALLOC_H)
check_include_file("memory.h" HAVE_MEMORY_H)
check_include_file("stdint.h" HAVE_STDINT_H)
check_include_file("strings.h" HAVE_STRINGS_H)
check_include_file("string.h" HAVE_STRING_H)
check_include_file("sys/file.h" HAVE_SYS_FILE_H)
check_include_file("sys/stat.h" HAVE_SYS_STAT_H)
check_include_file("sys/types.h" HAVE_SYS_TYPES_H)
check_include_file("unistd.h" HAVE_UNISTD_H)
check_include_file("stdlib.h" HAVE_STDLIB_H)

check_include_file("readline/history.h" HAVE_READLINE_HISTORY_H)
check_include_file("readline/readline.h" HAVE_READLINE_READLINE_H)

check_function_exists("fseeko" HAVE_FSEEKO)
check_function_exists("SimpleGetFile" HAVE_SIMPLEGETFILE)

check_library_exists("m" "sqrt" "" HAVE_LIBM)
check_library_exists("readline" "readline" "" HAVE_LIBREADLINE)

check_include_file("history.h" HAVE_HISTORY_H)
check_symbol_exists("using_history" "readline/readline.h" HAVE_READLINE_HISTORY)

add_definitions(-DHAVE_CONFIG_H=1)
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/config.h.in"
    "${CMAKE_CURRENT_BINARY_DIR}/config.h"
)
string(TIMESTAMP CURRENT_DATE "%d %b %Y")
set(BUILDINFO "Configured on ${CURRENT_DATE} for ${CMAKE_SYSTEM_PROCESSOR}")
file(GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/buildinfo.h" CONTENT
    "static char *buildinfo = \"${BUILDINFO}\";"
)
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(grads_SOURCES
    grads.c
    gxsubs.c
    gxmeta.c
    gxchpl.c
    gxcntr.c
    gxstrm.c
    gxdb.c
    gxwmap.c
    gxshad.c
    gxshad2.c
    gaexpr.c
    gafunc.c
    gautil.c
    gagx.c
    gscrpt.c
    gamach.c
    gatxt.c
    galloc.c
    gaddes.c
    gacfg.c
    gaio.c
    gauser.c
    gasdf.c
    bufrstn.c
    gabufr.c
    gabufrtbl.c
    ${src_gui}
    ${src_gadap}
)

add_executable(grads ${grads_SOURCES})
if(HAVE_LIBM)
    target_link_libraries(grads PRIVATE m)
endif()

      message(STATUS)
      message(STATUS "  +=========================================================================+")
      message(STATUS "   GrADS ${CMAKE_PROJECT_VERSION} : ${BUILDINFO}")
      message(STATUS "  +=========================================================================+")
      message(STATUS)
      message(STATUS "  +-------------------------------+")
      message(STATUS "  |                               |")
      message(STATUS "  |  GrADS will be built with:    |")
      message(STATUS "  |                               |")
if(USE_GUI)
      message(STATUS "  |  + GUI enabled                |")
else()
      message(STATUS "  |  - GUI disabled               |")
endif()
if(USE_READLINE)
      message(STATUS "  |  + READLINE enabled           |")
else()
      message(STATUS "  |  - READLINE disabled          |")
endif()
if(USE_GEOTIFF)
      message(STATUS "  |  + GEOTIFF enabled            |")
else()
      message(STATUS "  |  - GEOTIFF disabled           |")
endif()
if(USE_SHP)
      message(STATUS "  |  + SHAPEFILE enabled          |")
else()
      message(STATUS "  |  - SHAPEFILE disabled         |")
endif()
if(USE_GD)
      message(STATUS "  |  + GD enabled                 |")
else()
      message(STATUS "  |  - GD disabled                |")
endif()
if(USE_CAIRO)
      message(STATUS "  |  + CAIRO enabled              |")
else()
      message(STATUS "  |  - CAIRO disabled             |")
endif()
if(USE_GRIB2)
      message(STATUS "  |  + GRIB2 enabled              |")
else()
      message(STATUS "  |  - GRIB2 disabled             |")
endif()
if(USE_HDF)
      message(STATUS "  |  + HDF4 enabled               |")
else()
      message(STATUS "  |  - HDF4 disabled              |")
endif()
if(USE_HDF5)
      message(STATUS "  |  + HDF5 enabled               |")
else()
      message(STATUS "  |  - HDF5 disabled              |")
endif()
if(NOT USE_NC)
      message(STATUS "  |  - NETCDF disabled            |")
else()
  if(USE_NC4)
      message(STATUS "  |  + NETCDF4 enabled            |")
  else()
      message(STATUS "  |  + NETCDF3 enabled            |")
  endif()
endif()
if(USE_GADAP OR USE_DAP)
      message(STATUS "  |  + OPeNDAP enabled            |")
  if(USE_GADAP AND USE_DAP)
      message(STATUS "  |     for grids and stn data    |")
  else()
    if(USE_GADAP)
      message(STATUS "  |     for stn data only         |")
    else()
      message(STATUS "  |     for grids only            |")
    endif()
  endif()
else()
      message(STATUS "  |  - OPeNDAP disabled           |")
endif()
      message(STATUS "  |                               |")
      message(STATUS "  +-------------------------------+")
