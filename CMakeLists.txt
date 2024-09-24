cmake_minimum_required(VERSION 3.20)

project(imgui-lib)

SET (CMAKE_CXX_STANDARD 11)
SET (CMAKE_VERBOSE_MAKEFILE ON)

set(LIB_NAME "imgui")

set(
    SRC_FILES 
    imgui_unity.cpp
)

set(
    INCLUDE_DIRS
    ${PROJECT_SOURCE_DIR}/imgui
    ${PROJECT_SOURCE_DIR}/implot
    ${PROJECT_SOURCE_DIR}/imgui/backends
)

set(
    LINK_LIB_DIRS
)

add_library(${LIB_NAME} STATIC ${SRC_FILES})
target_include_directories(${LIB_NAME} PUBLIC ${INCLUDE_DIRS})
target_link_libraries(${LIB_NAME} PUBLIC ${LINK_LIB_DIRS})

