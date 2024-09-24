cmake_minimum_required(VERSION 3.20)

project(imgui-lib)

SET (CMAKE_CXX_STANDARD 11)

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
    imgui/imgui.cpp
    imgui/imgui_widgets.cpp
    imgui/imgui_draw.cpp
    imgui/imgui_tables.cpp
    imgui/imgui_demo.cpp
    implot/implot.cpp
    implot/implot_items.cpp
    implot/implot_demo.cpp
    imgui/backends/imgui_impl_dx11.cpp
    imgui/backends/imgui_impl_win32.cpp
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

