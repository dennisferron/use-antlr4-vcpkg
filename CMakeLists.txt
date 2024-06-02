cmake_minimum_required(VERSION 3.27)
project(use_antlr4_vcpkg)
set(CMAKE_CXX_STANDARD 17)

message(STATUS "toolchain: ${CMAKE_TOOLCHAIN_FILE}")

add_subdirectory(test_rig)

find_package(antlr4-runtime CONFIG REQUIRED)
find_package(antlr4-generator CONFIG REQUIRED)

include(FetchContent)
FetchContent_Declare(
        antlr4_jar
        URL https://www.antlr.org/download/antlr-4.13.1-complete.jar
        SOURCE_DIR ${PROJECT_SOURCE_DIR}/download
        DOWNLOAD_NO_EXTRACT TRUE
)
FetchContent_MakeAvailable(antlr4_jar)
set(ANTLR4_JAR_LOCATION ${PROJECT_SOURCE_DIR}/download/antlr-4.13.1-complete.jar)

antlr4_generate(
        LangLexer
        ${CMAKE_CURRENT_SOURCE_DIR}/LangLexer.g4
        LEXER
        FALSE
        FALSE
        "Lang"
)

antlr4_generate(
        LangParser
        ${CMAKE_CURRENT_SOURCE_DIR}/LangParser.g4
        PARSER
        FALSE
        FALSE
        "Lang"
        "${ANTLR4_TOKEN_FILES_LangLexer}"
        "${ANTLR4_TOKEN_DIRECTORY_LangLexer}"
)

add_executable(use_antlr4_vcpkg main.cpp
        test_rig/test_rig_main.cpp)
target_link_libraries(use_antlr4_vcpkg antlr4_static)

target_include_directories(use_antlr4_vcpkg PRIVATE "${ANTLR4_INCLUDE_DIR_LangLexer}" "${ANTLR4_INCLUDE_DIR_LangParser}")
target_sources(use_antlr4_vcpkg PRIVATE ${ANTLR4_SRC_FILES_LangLexer} ${ANTLR4_SRC_FILES_LangParser})
target_include_directories(use_antlr4_vcpkg PRIVATE "${ANTLR4_INCLUDE_DIR}")
#add_dependencies(use_antlr4_vcpkg antlr4_shared)
#target_link_libraries(use_antlr4_vcpkg PRIVATE antlr4_shared)
#target_compile_features(use_antlr4_vcpkg PUBLIC cxx_std_17)

# add_custom_command and add_custom_target can be used
# to do additional things with the parser such as
# displaying the grammar graphically with a tool.

#[[
# TODO: Does this depend on the java files or the class files?
# Or should there be one target for generating the code and
# another target for compiling the code and another target
# for grun ??
add_custom_target(
    LangParserInJava
    DEPENDS
        LangParser.java
        LangLexer.java
)


add_custom_command(
        COMMAND echo "Hello from custom command"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT  dummyfile.txt
        COMMENT "Running custom command..."
)
add_custom_target(
        ExampleCustomTarget # not in ALL
        DEPENDS dummyfile.txt
)
add_dependencies(ExampleCustomTarget use_antlr4_vcpkg)
]]
