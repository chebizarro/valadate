####
## Version information
####

# Library version
#
# This should be incremented with every release.  See semver.org.
set (PARSIMONY_VERSION_MAJOR    1)
set (PARSIMONY_VERSION_MINOR    0)
set (PARSIMONY_VERSION_REVISION 0)

# API version.
#
# This will go in the pkg-config and shared library names.  Should
# only be changed if the API breaks backwards compatibility.
set (PARSIMONY_VERSION      "1.0")

# ABI version
#
# Rules from § 11.4: Library Versioning of the autobook
# https://www.sourceware.org/autobook/autobook/autobook_61.html
#
# 1) If you have changed any of the sources for this library, the
#    revision number must be incremented. This is a new revision of
#    the current interface.
# 2) If the interface has changed, then current must be incremented,
#    and revision reset to ‘0’. This is the first revision of a new
#    interface.
# 3) If the new interface is a superset of the previous interface
#    (that is, if the previous interface has not been broken by the
#    changes in this new release), then age must be incremented. This
#    release is backwards compatible with the previous release.
# 4) If the new interface has removed elements with respect to the
#    previous interface, then you have broken backward compatibility
#    and age must be reset to ‘0’. This release has a new, but
#    backwards incompatible interface.
#
# Conveniently, this also matches semantic versioning for the most
# part (API changes are a bit more complicated since we change the
# library and pkg-config names and can reset these to whatever we
# want, but we don't *have* to.
set (PARSIMONY_SOVERSION_CURRENT  ${PARSIMONY_VERSION_MAJOR})
set (PARSIMONY_SOVERSION_REVISION ${PARSIMONY_VERSION_MINOR})
set (PARSIMONY_SOVERSION_AGE      ${PARSIMONY_VERSION_REVISION})

cmake_minimum_required (VERSION 2.8.7)

if (CMAKE_BUILD_TYPE STREQUAL "")
  set (CMAKE_BUILD_TYPE "Debug")
endif ()

if (CMAKE_VERSION VERSION_GREATER 3.1.2)
  cmake_policy (SET CMP0054 NEW)
endif ()

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

project (parmsimony)

include (GNUInstallDirs)
include (ExtraWarningFlags)
include (CheckFunctionExists)
include (CheckIncludeFile)
include (AddCompilerFlags)

enable_testing ()

if (ENABLE_COVERAGE STREQUAL "yes")
  include (CodeCoverage)
endif ()

if (MSVC)
  global_add_compiler_flags (
    /wd4996)
  add_definitions (-D_CRT_SECURE_NO_WARNINGS)
endif (MSVC)

set (PACKAGE_NAME Parsimony)
set (PARSIMONY_TOP_SRCDIR "${PROJECT_SOURCE_DIR}")
set (PARSIMONY_TOP_BUILDDIR "${PROJECT_BINARY_DIR}")

set (PARSIMONY_VERSION_MAJOR 1)
set (PARSIMONY_VERSION_MINOR 0)
set (PARSIMONY_VERSION_REVISION 0)
set (PARSIMONY_VERSION "1.0")
set (PACKAGE_VERSION ${PARSIMONY_VERSION_MAJOR}.${PARSIMONY_VERSION_MINOR}.${PARSIMONY_VERSION_REVISION})

set(CPACK_PACKAGE_VERSION_MAJOR ${PARSIMONY_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PARSIMONY_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PARSIMONY_VERSION_REVISION})
set(CPACK_SOURCE_GENERATOR "TBZ2")
set(CPACK_SOURCE_PACKAGE_FILE_NAME
  "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
set(CPACK_SOURCE_IGNORE_FILES
  "/autogen.sh;/build/;.git;.gitmodules;.gitignore;~$;${CPACK_SOURCE_IGNORE_FILES}")
include (CPack)

add_custom_target(dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)

include_directories ("${PROJECT_BINARY_DIR}")
include_directories ("${PROJECT_SOURCE_DIR}")

set (PARSIMONY_SEARCH_PATH "${SEARCH_PATH}")

configure_file (
    "${PROJECT_SOURCE_DIR}/parmsimony.pc.in"
    "${PROJECT_BINARY_DIR}/parmsimony-${PARSIMONY_VERSION}.pc"
    @ONLY)


# This only works with gcc/clang at the moment.
function (parmsimony_set_target_visibility target visibility)
  set (flag "-fvisibility=${visibility}")
  string (REGEX REPLACE "[-=]+" "_" abbrev_test_name "${flag}")

  CHECK_C_COMPILER_FLAG ("-fvisibility=${visibility}" "CFLAG_${abbrev_test_name}")
  CHECK_CXX_COMPILER_FLAG ("-fvisibility=${visibility}" "CXXFLAG_${abbrev_test_name}")

  if (CFLAG_${abbrev_test_name})
    target_add_compiler_flags (${target} ${flag})
    set_property (TARGET ${target} APPEND PROPERTY LINKER_FLAGS "${flag}")
  endif ()

  unset (flag)
  unset (abbrev_test_name)
endfunction (parmsimony_set_target_visibility)

if (CMAKE_BUILD_TYPE MATCHES "Release")
  global_add_compiler_flags (-O3 -flto -DNDEBUG)
elseif (NOT ENABLE_COVERAGE STREQUAL "yes")
  global_add_compiler_flags (-g -O2)
endif ()

####
## Compatibility with older CMake
##
## This will probably be removed when Ubuntu bumps their LTS server
## release (and Travis upgrades).
####
if (${CMAKE_VERSION} VERSION_LESS 2.8.11)
  function (target_include_directories)
    foreach (argn RANGE 2 ${ARGC})
      if (${argn} LESS ${ARGC})
        include_directories (${ARGV${argn}})
      endif ()
    endforeach ()
  endfunction ()
endif ()

if (ENABLE_COVERAGE STREQUAL "yes")
  if (CMAKE_BUILD_TYPE MATCHES "Release")
    message (WARNING "Coverage anaysis requires a debugging build")
  endif ()
endif ()

function (parmsimony_target_add_coverage target)
  if (ENABLE_COVERAGE STREQUAL "yes")
    set_property (TARGET ${target} APPEND_STRING PROPERTY COMPILE_FLAGS " -fprofile-arcs")
    set_property (TARGET ${target} APPEND_STRING PROPERTY COMPILE_FLAGS " -ftest-coverage")
    set_property (TARGET ${target} APPEND_STRING PROPERTY LINK_FLAGS " -fprofile-arcs")
    set_property (TARGET ${target} APPEND_STRING PROPERTY LINK_FLAGS " -ftest-coverage")
  endif ()
endfunction (parmsimony_target_add_coverage)

add_subdirectory (libparmsimony)
add_subdirectory (src)
add_subdirectory (tests)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/parmsimony-${PARSIMONY_VERSION}.pc
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

if (ENABLE_COVERAGE STREQUAL "yes")
  SETUP_TARGET_FOR_COVERAGE(coverage test coverage)
endif ()
