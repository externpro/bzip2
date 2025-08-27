set(commands
  # Compress sample files
  "${CMD} -1 < ${SRC_DIR}/sample1.ref > ${BIN_DIR}/sample1.rb2"
  "${CMD} -2 < ${SRC_DIR}/sample2.ref > ${BIN_DIR}/sample2.rb2"
  "${CMD} -3 < ${SRC_DIR}/sample3.ref > ${BIN_DIR}/sample3.rb2"
  # Decompress sample files
  "${CMD} -d < ${SRC_DIR}/sample1.bz2 > ${BIN_DIR}/sample1.tst"
  "${CMD} -d < ${SRC_DIR}/sample2.bz2 > ${BIN_DIR}/sample2.tst"
  "${CMD} -ds < ${SRC_DIR}/sample3.bz2 > ${BIN_DIR}/sample3.tst"
  # Verify compressed files
  "${CMAKE_COMMAND} -E compare_files ${SRC_DIR}/sample1.bz2 ${BIN_DIR}/sample1.rb2"
  "${CMAKE_COMMAND} -E compare_files ${SRC_DIR}/sample2.bz2 ${BIN_DIR}/sample2.rb2"
  "${CMAKE_COMMAND} -E compare_files ${SRC_DIR}/sample3.bz2 ${BIN_DIR}/sample3.rb2"
  # Verify decompressed files
  "${CMAKE_COMMAND} -E compare_files ${BIN_DIR}/sample1.tst ${SRC_DIR}/sample1.ref"
  "${CMAKE_COMMAND} -E compare_files ${BIN_DIR}/sample2.tst ${SRC_DIR}/sample2.ref"
  "${CMAKE_COMMAND} -E compare_files ${BIN_DIR}/sample3.tst ${SRC_DIR}/sample3.ref"
  )
# Execute each command
foreach(cmd IN LISTS commands)
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E echo "Running: ${cmd}"
    COMMAND bash -c "${cmd}" RESULT_VARIABLE result
  )
  if(NOT result EQUAL 0)
    message(FATAL_ERROR "Command failed: ${cmd}\nExit code: ${result}")
  endif()
endforeach()
