cmake_minimum_required(VERSION 4.3)
project(bzip2 VERSION 1.0.8 LANGUAGES C)
set(lib_name bz2)
set(exe_name bzip2exe)
########################################
add_definitions(-D_FILE_OFFEST_BITS=64)
########################################
set(${lib_name}_libsrcs
  blocksort.c
  huffman.c
  crctable.c
  randtable.c
  compress.c
  decompress.c
  bzlib.c
  bzlib.h
  bzlib_private.h
  )
########################################
add_library(${lib_name} STATIC ${${lib_name}_libsrcs})
target_include_directories(${lib_name} PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
  PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
  )
########################################
add_executable(${exe_name} bzip2.c)
set_target_properties(${exe_name} PROPERTIES
  OUTPUT_NAME "bzip2"
  DEBUG_POSTFIX "${CMAKE_DEBUG_POSTFIX}"
  )
target_link_libraries(${exe_name} PRIVATE ${lib_name})
########################################
add_executable(bzip2recover bzip2recover.c)
set_target_properties(bzip2recover PROPERTIES DEBUG_POSTFIX "${CMAKE_DEBUG_POSTFIX}")
########################################
include(CTest)
add_test(NAME bzip2_check
  COMMAND ${CMAKE_COMMAND}
    -DCMD=$<TARGET_FILE:${exe_name}>
    -DSRC_DIR=${CMAKE_CURRENT_SOURCE_DIR}
    -DBIN_DIR=${CMAKE_CURRENT_BINARY_DIR}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/run_bzip2_test.cmake
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )
########################################
set(targetsFile ${PROJECT_NAME}-targets)
install(TARGETS ${lib_name} EXPORT ${targetsFile}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  )
install(TARGETS ${exe_name} bzip2recover EXPORT ${targetsFile}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  CONFIGURATIONS Release
  )
install(PROGRAMS $<TARGET_FILE:${exe_name}> DESTINATION ${CMAKE_INSTALL_BINDIR} CONFIGURATIONS Release RENAME bunzip2${CMAKE_EXECUTABLE_SUFFIX})
install(PROGRAMS $<TARGET_FILE:${exe_name}> DESTINATION ${CMAKE_INSTALL_BINDIR} CONFIGURATIONS Release RENAME bzcat${CMAKE_EXECUTABLE_SUFFIX})
install(FILES bzlib.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})
if(COMMAND xpExternPackage)
  string(JOIN "\n" ALIASES
    "if(NOT TARGET BZip2::BZip2)"
    "  add_library(BZip2::BZip2 ALIAS ${CMAKE_PROJECT_NAME}::${lib_name})"
    "endif()"
    ""
    )
  xpExternPackage(TARGETS_FILE ${targetsFile}
    FIND_XPRO_CMAKE PKG_CMAKE_USEXT CREATE_ALIASES
    LIBRARIES ${lib_name} EXE ${exe_name} DEFAULT_TARGETS ${lib_name}
    BASE ${CMAKE_PROJECT_NAME}-${CMAKE_PROJECT_VERSION} XPDIFF "intro"
    WEB "https://sourceware.org/bzip2/" UPSTREAM "github.com/opencor/bzip2"
    DESC "lossless block-sorting data compression library"
    LICENSE "[bzip2-1.0.6](https://spdx.org/licenses/bzip2-1.0.6.html 'BSD-like, modified zlib license')"
    )
  install(EXPORT ${targetsFile} DESTINATION ${CMAKE_INSTALL_CMAKEDIR} NAMESPACE ${CMAKE_PROJECT_NAME}::)
endif()
