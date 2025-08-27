cmake_minimum_required(VERSION 3.31)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/.devcontainer/cmake)
set(CMAKE_PROJECT_TOP_LEVEL_INCLUDES xproinc)
project(bzip2 VERSION 1.0.8 LANGUAGES C)
include(flags)
include(GNUInstallDirs)
set(lib_name bz2)
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
add_executable(bzip2 bzip2.c)
target_link_libraries(bzip2 ${lib_name})
set_target_properties(bzip2 PROPERTIES DEBUG_POSTFIX "${CMAKE_DEBUG_POSTFIX}")
########################################
add_executable(bzip2recover bzip2recover.c)
set_target_properties(bzip2recover PROPERTIES DEBUG_POSTFIX "${CMAKE_DEBUG_POSTFIX}")
########################################
include(CTest)
add_test(NAME bzip2_check
  COMMAND ${CMAKE_COMMAND}
    -DCMD=$<TARGET_FILE:bzip2>
    -DSRC_DIR=${CMAKE_CURRENT_SOURCE_DIR}
    -DBIN_DIR=${CMAKE_CURRENT_BINARY_DIR}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/run_bzip2_test.cmake
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )
########################################
set(targetsFile ${PROJECT_NAME}-targets)
set(exe bzip2)
set(lib ${lib_name})
if(DEFINED XP_NAMESPACE)
  string(PREPEND exe "${XP_NAMESPACE}::")
  string(PREPEND lib "${XP_NAMESPACE}::")
endif()
xpPackageDevel(TARGETS_FILE ${targetsFile} LIBRARIES ${lib} EXE ${exe})
install(TARGETS ${lib_name} EXPORT ${targetsFile}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  )
install(TARGETS bzip2 bzip2recover EXPORT ${targetsFile}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  CONFIGURATIONS Release
  )
install(PROGRAMS $<TARGET_FILE:bzip2> DESTINATION ${CMAKE_INSTALL_BINDIR} CONFIGURATIONS Release RENAME bunzip2${CMAKE_EXECUTABLE_SUFFIX})
install(PROGRAMS $<TARGET_FILE:bzip2> DESTINATION ${CMAKE_INSTALL_BINDIR} CONFIGURATIONS Release RENAME bzcat${CMAKE_EXECUTABLE_SUFFIX})
install(FILES bzlib.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})
if(DEFINED XP_NAMESPACE)
  set(nameSpace NAMESPACE ${XP_NAMESPACE}::)
endif()
if(NOT DEFINED XP_INSTALL_CMAKEDIR)
  set(XP_INSTALL_CMAKEDIR ${CMAKE_INSTALL_DATADIR}/cmake)
endif()
install(EXPORT ${targetsFile} DESTINATION ${XP_INSTALL_CMAKEDIR} ${nameSpace})
