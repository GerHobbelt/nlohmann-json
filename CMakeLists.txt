cmake_minimum_required(VERSION 3.1)
list(APPEND CMAKE_MODULE_PATH
	${CMAKE_CURRENT_SOURCE_DIR}/cmake
	${CMAKE_CURRENT_SOURCE_DIR}/cmake_sdk
)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

# -----------------------------------------------------------------------------
# Prepare project
# -----------------------------------------------------------------------------
include(check_standalone)

# -----------------------------------------------------------------------------
# Start project
# -----------------------------------------------------------------------------
project(nlohmann_json VERSION 3.10.3 LANGUAGES CXX)

if(PROJECT_IS_STANDALONE)
	print_standalone()
endif()

if (POLICY CMP0077)
    # Allow CMake 3.13+ to override options when using FetchContent / add_subdirectory.
    cmake_policy(SET CMP0077 NEW)
endif ()

# -----------------------------------------------------------------------------
# Project options
# -----------------------------------------------------------------------------
option(NLOHMANN_JSON_BUILD_DEMOS "Build demos" OFF)

# -----------------------------------------------------------------------------
# Project internal options
# -----------------------------------------------------------------------------
option(JSON_Diagnostics         "Use extended diagnostic messages." OFF)
option(JSON_ImplicitConversions "Enable implicit conversions." ON)
option(JSON_MultipleHeaders     "Use non-amalgamated version of the library." OFF)
option(JSON_SystemInclude       "Include as system headers (skip for clang-tidy)." OFF)

set(NLOHMANN_JSON_TARGET_NAME               "${PROJECT_NAME}")
set(NLOHMANN_JSON_INCLUDE_BUILD_DIR         "${PROJECT_SOURCE_DIR}/single_include/")

if (JSON_MultipleHeaders)
    message(FATAL_ERROR "Multiple headers not supported yet")
else()
    message(STATUS "Using the single-header code from ${NLOHMANN_JSON_INCLUDE_BUILD_DIR}")
endif()

if (NOT JSON_ImplicitConversions)
    message(STATUS "Implicit conversions are disabled")
endif()

if (JSON_Diagnostics)
    message(STATUS "Diagnostics enabled")
endif()

if (JSON_SystemInclude)
    set(NLOHMANN_JSON_SYSTEM_INCLUDE "SYSTEM")
endif()

# -----------------------------------------------------------------------------
# Compiler config - optional
# -----------------------------------------------------------------------------
if(PROJECT_IS_STANDALONE)
	include(_set_flags)
endif()

# -----------------------------------------------------------------------------
# Project library
# -----------------------------------------------------------------------------
add_library(${NLOHMANN_JSON_TARGET_NAME} INTERFACE)
add_library(${PROJECT_NAME}::${NLOHMANN_JSON_TARGET_NAME} ALIAS ${NLOHMANN_JSON_TARGET_NAME})
if (${CMAKE_VERSION} VERSION_LESS "3.8.0")
    target_compile_features(${NLOHMANN_JSON_TARGET_NAME} INTERFACE cxx_range_for)
else()
    target_compile_features(${NLOHMANN_JSON_TARGET_NAME} INTERFACE cxx_std_11)
endif()

target_compile_definitions(
    ${NLOHMANN_JSON_TARGET_NAME}
    INTERFACE
    JSON_USE_IMPLICIT_CONVERSIONS=$<BOOL:${JSON_ImplicitConversions}>
    JSON_DIAGNOSTICS=$<BOOL:${JSON_Diagnostics}>
)

target_include_directories(
    ${NLOHMANN_JSON_TARGET_NAME}
    ${NLOHMANN_JSON_SYSTEM_INCLUDE} INTERFACE
    $<BUILD_INTERFACE:${NLOHMANN_JSON_INCLUDE_BUILD_DIR}>
    $<INSTALL_INTERFACE:include>
)

if (MSVC)
    # debug view definition file for msvc (natvis) not supported yet
endif()

# -----------------------------------------------------------------------------
# Modules
# -----------------------------------------------------------------------------
if(NLOHMANN_JSON_BUILD_DEMOS)
	message(STATUS "+ demos")
	add_subdirectory(demos)
endif()
