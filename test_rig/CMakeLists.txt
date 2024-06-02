cmake_minimum_required(VERSION 3.27)

find_package(tiny-process-library CONFIG REQUIRED)

add_executable(test_rig test_rig_main.cpp)
target_link_libraries(test_rig PRIVATE tiny-process-library::tiny-process-library)