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
    list(APPEND grads_LIBS SX::SX)
    add_library(gxdX11 SHARED gxX11.c)
    target_link_libraries(gxdX11 PRIVATE X11::X11)
endif()

if(USECAIRO)
    add_library(gxdCairo SHARED gxX.c gxC.c)
    target_link_libraries(gxdCairo PRIVATE Cairo::Cairo Freetype::Freetype)
    add_library(gxpCairo SHARED gxprint.c gxC.c)
    target_link_libraries(gxpCairo PRIVATE Cairo::Cairo Freetype::Freetype)
endif()

if(USEGD)
    add_library(gxpGD SHARED gxprintGD.c gxGD.c)
    target_link_libraries(gxpGD PRIVATE GD::GD)
endif()

add_library(gxdummy SHARED gxdummy.c)

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
foreach(lib IN LISTS grads_LIBS)
  target_link_libraries(grads PRIVATE ${lib})
endforeach()
set_target_properties(grads PROPERTIES ENABLE_EXPORTS TRUE)

      message(STATUS)
      message(STATUS "  +=========================================================================+")
      message(STATUS "   GrADS ${CMAKE_PROJECT_VERSION} : ${BUILDINFO}")
      message(STATUS "  +=========================================================================+")
      message(STATUS)
      message(STATUS "  +-------------------------------+")
      message(STATUS "  |                               |")
      message(STATUS "  |  GrADS will be built with:    |")
      message(STATUS "  |                               |")
if(USEGUI)
      message(STATUS "  |  + GUI enabled                |")
else()
      message(STATUS "  |  - GUI disabled               |")
endif()
if(USEREADLINE)
      message(STATUS "  |  + READLINE enabled           |")
else()
      message(STATUS "  |  - READLINE disabled          |")
endif()
if(USEGEOTIFF)
      message(STATUS "  |  + GEOTIFF enabled            |")
else()
      message(STATUS "  |  - GEOTIFF disabled           |")
endif()
if(USESHP)
      message(STATUS "  |  + SHAPEFILE enabled          |")
else()
      message(STATUS "  |  - SHAPEFILE disabled         |")
endif()
if(USEGD)
      message(STATUS "  |  + GD enabled                 |")
else()
      message(STATUS "  |  - GD disabled                |")
endif()
if(USECAIRO)
      message(STATUS "  |  + CAIRO enabled              |")
else()
      message(STATUS "  |  - CAIRO disabled             |")
endif()
if(USEGRIB2)
      message(STATUS "  |  + GRIB2 enabled              |")
else()
      message(STATUS "  |  - GRIB2 disabled             |")
endif()
if(USEHDF)
      message(STATUS "  |  + HDF4 enabled               |")
else()
      message(STATUS "  |  - HDF4 disabled              |")
endif()
if(USEHDF5)
      message(STATUS "  |  + HDF5 enabled               |")
else()
      message(STATUS "  |  - HDF5 disabled              |")
endif()
if(NOT USENETCDF)
      message(STATUS "  |  - NETCDF disabled            |")
else()
  if(USENETCDF4)
      message(STATUS "  |  + NETCDF4 enabled            |")
  else()
      message(STATUS "  |  + NETCDF3 enabled            |")
  endif()
endif()
if(USEGADAP OR USEDAP)
      message(STATUS "  |  + OPeNDAP enabled            |")
  if(USEGADAP AND USEDAP)
      message(STATUS "  |     for grids and stn data    |")
  else()
    if(USEGADAP)
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
