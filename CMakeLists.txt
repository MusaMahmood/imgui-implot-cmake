cmake_minimum_required(VERSION 3.20)

project(imgui-lib)

set(CMAKE_CXX_STANDARD 17)
SET (CMAKE_VERBOSE_MAKEFILE ON)
SET (VERSION "0.0.1" CACHE STRING "Version")
SET (CMAKE_CXX_VISIBILITY_PRESET hidden)
SET (CMAKE_C_VISIBILITY_PRESET hidden)
SET (CMAKE_POSITION_INDEPENDENT_CODE ON)

set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-exceptions -fno-rtti -fno-threadsafe-statics -lgcc")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions -fno-rtti -fno-threadsafe-statics -lgcc")

set(LIB_NAME "imgui")

macro (configure_msvc_runtime)
    if (MSVC)
        add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING -D_CRT_NONSTDC_NO_DEPRECATE)
        # Default to statically-linked runtime.
        if ("${MSVC_RUNTIME}" STREQUAL "")
            set (MSVC_RUNTIME "static")
        endif ()
        # Set compiler options.
        set (variables
            CMAKE_C_FLAGS_DEBUG
            CMAKE_C_FLAGS_MINSIZEREL
            CMAKE_C_FLAGS_RELEASE
            CMAKE_C_FLAGS_RELWITHDEBINFO
            CMAKE_CXX_FLAGS_DEBUG
            CMAKE_CXX_FLAGS_MINSIZEREL
            CMAKE_CXX_FLAGS_RELEASE
            CMAKE_CXX_FLAGS_RELWITHDEBINFO
        )
        if (${MSVC_RUNTIME} STREQUAL "static")
            message(STATUS
                "MSVC -> forcing use of statically-linked runtime."
            )
            foreach (variable ${variables})
                if (${variable} MATCHES "/MD")
                    string (REGEX REPLACE "/MD" "/MT" ${variable} "${${variable}}")
                endif ()
            endforeach ()
        else ()
            message (STATUS
                "MSVC -> forcing use of dynamically-linked runtime."
            )
            foreach (variable ${variables})
                if (${variable} MATCHES "/MT")
                    string (REGEX REPLACE "/MT" "/MD" ${variable} "${${variable}}")
                endif ()
            endforeach ()
        endif ()
    endif ()
endmacro ()

configure_msvc_runtime ()

set(
    SRC_FILES 
    imgui.cpp
    imgui_widgets.cpp
    imgui_draw.cpp
    imgui_tables.cpp
    imgui_demo.cpp
    implot.cpp
    implot_items.cpp
    implot_demo.cpp
    backends/imgui_impl_glfw.cpp
    backends/imgui_impl_opengl3.cpp
    backends/imgui_impl_dx11.cpp
    backends/imgui_impl_win32.cpp
)

set(
    INCLUDE_DIRS
    ${PROJECT_SOURCE_DIR}
    ${PROJECT_SOURCE_DIR}/backends
    #${CMAKE_HOME_DIRECTORY}/third_party
)

set(GLFW_DIR third_party/glfw)
option(GLFW_BUILD_EXAMPLES "Build the GLFW example programs" OFF)
option(GLFW_BUILD_TESTS "Build the GLFW test programs" OFF)
option(GLFW_BUILD_DOCS "Build the GLFW documentation" OFF)
option(GLFW_INSTALL "Generate installation target" OFF)
option(GLFW_DOCUMENT_INTERNALS "Include internals in documentation" OFF)
add_subdirectory(${GLFW_DIR} binary_dir EXCLUDE_FROM_ALL)
include_directories(${GLFW_DIR}/include)
include_directories(${GLFW_DIR}/deps)

set(
    LINK_LIB_DIRS
    glfw
)

add_library(${LIB_NAME} STATIC ${SRC_FILES})
target_include_directories(${LIB_NAME} PUBLIC ${INCLUDE_DIRS})
target_link_libraries(${LIB_NAME} PUBLIC ${LINK_LIB_DIRS})

