# - Try to find Readline library and headers
# This will define:
#   READLINE_FOUND - System has Readline
#   Readline_INCLUDE_DIRS - The Readline include directories
#   Readline_LIBRARIES - The libraries needed to use Readline

include(FindPackageHandleStandardArgs)

# Find readline headers
find_path(Readline_INCLUDE_DIR
  NAMES readline/readline.h
  HINTS ${Readline_ROOT_DIR}/include
  PATH_SUFFIXES readline
)

# Find readline library
find_library(Readline_LIBRARY
  NAMES readline
  HINTS ${Readline_ROOT_DIR}/lib
)

# Find required Curses dependency
find_package(Curses REQUIRED)

# Set final variables
set(Readline_INCLUDE_DIRS ${Readline_INCLUDE_DIR} ${CURSES_INCLUDE_DIRS})
set(Readline_LIBRARIES ${Readline_LIBRARY} ${CURSES_LIBRARIES})

find_package_handle_standard_args(Readline
  REQUIRED_VARS 
    Readline_INCLUDE_DIR
    Readline_LIBRARY
    CURSES_FOUND
)

# Create modern target if possible
if(READLINE_FOUND AND NOT TARGET Readline::Readline)
  add_library(Readline::Readline UNKNOWN IMPORTED)
  
  set_target_properties(Readline::Readline PROPERTIES
    IMPORTED_LOCATION "${Readline_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${Readline_INCLUDE_DIRS}"
  )

  # Link Curses using the variables from your FindCurses.cmake
  # instead of non-existent targets
  set_property(TARGET Readline::Readline APPEND PROPERTY
    INTERFACE_LINK_LIBRARIES "${CURSES_LIBRARIES}"
  )
endif()

mark_as_advanced(
  Readline_INCLUDE_DIR
  Readline_LIBRARY
)
