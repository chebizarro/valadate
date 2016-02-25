enable_testing()

set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
find_package (Threads REQUIRED)

add_executable (test-parsimony
  test.vala)

set (PARSIMONY_TESTS
  /buffer/basic
  /threads/buffer)

add_definitions(-DPARSIMONY_TEST_PLUGIN_DIR="${CMAKE_BINARY_DIR}/plugins")

set_compiler_specific_flags(
  VARIABLE extra_compiler_flags
  INTEL -wd3179)

target_add_extra_warning_flags (test-parsimony)
target_link_libraries (test-parsimony parsimony${PARSIMONY_VERSION})
target_link_libraries(test-parsimony ${CMAKE_THREAD_LIBS_INIT})
target_require_c_standard (test-parsimony "c99")
target_add_compiler_flags (test-parsimony ${extra_compiler_flags})

if (WIN32)
  add_custom_command(TARGET test-parsimony POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different "$<TARGET_FILE:parsimony${PARSIMONY_VERSION}>" "$<TARGET_FILE_DIR:test-parsimony>")
endif ()

foreach(test_name ${PARSIMONY_TESTS})
  add_test(NAME ${test_name}
    COMMAND $<TARGET_FILE:test-parsimony> ${test_name})
endforeach(test_name)
