cmake_minimum_required(VERSION 2.8.12.1)

set(CMAKE_CONFIGURATION_TYPES Debug Release)

project(gstcef)

set_property(GLOBAL PROPERTY OS_FOLDERS ON)

#set(CEF_VERSION "76.1.9+g2cf916e+chromium-76.0.3809.87")
#set(CEF_VERSION "3.3440.1806.g65046b7")
set(CEF_VERSION "78.3.9+gc7345f2+chromium-78.0.3904.108")

# Determine the platform.
if("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
  set(CEF_PLATFORM "macosx64")
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
  if(CMAKE_SIZEOF_VOID_P MATCHES 8)
    set(CEF_PLATFORM "linux64")
  else()
    set(CEF_PLATFORM "linux32")
  endif()
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  if(CMAKE_SIZEOF_VOID_P MATCHES 8)
    set(CEF_PLATFORM "windows64")
  else()
    set(CEF_PLATFORM "windows32")
  endif()
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(DownloadCEF)
DownloadCEF("${CEF_PLATFORM}" "${CEF_VERSION}" "${CMAKE_SOURCE_DIR}/third_party/cef")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CEF_ROOT}/cmake")

find_package(CEF REQUIRED)
add_subdirectory(${CEF_LIBCEF_DLL_WRAPPER_PATH} libcef_dll_wrapper)

set(GSTCEF_SRCS
  gstcef.cc
)

set(GSTCEFSUBPROCESS_SRCS
  gstcefsubprocess.cc
)

find_package(PkgConfig)

pkg_check_modules(GST REQUIRED gstreamer-1.0
                  gstreamer-video-1.0
		  gio-2.0)

ADD_LOGICAL_TARGET("libcef_lib" "${CEF_LIB_DEBUG}" "${CEF_LIB_RELEASE}")

SET_CEF_TARGET_OUT_DIR()

if(OS_LINUX)
  link_directories(${GST_LIBRARY_DIRS})

  add_executable("gstcefsubprocess" ${GSTCEFSUBPROCESS_SRCS})
  SET_EXECUTABLE_TARGET_PROPERTIES("gstcefsubprocess")
  target_link_libraries("gstcefsubprocess" libcef_lib libcef_dll_wrapper ${CEF_STANDARD_LIBS})
  set_target_properties("gstcefsubprocess" PROPERTIES INSTALL_RPATH "$ORIGIN")
  set_target_properties("gstcefsubprocess" PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
  set_target_properties("gstcefsubprocess" PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CEF_TARGET_OUT_DIR})

  add_library("gstcef" SHARED ${GSTCEF_SRCS})
  SET_LIBRARY_TARGET_PROPERTIES("gstcef")
  add_dependencies("gstcef" libcef_dll_wrapper)
  target_link_libraries("gstcef" libcef_lib libcef_dll_wrapper ${CEF_STANDARD_LIBS} ${GST_LIBRARIES})
  target_include_directories("gstcef" PUBLIC ${GST_INCLUDE_DIRS})
  target_compile_definitions("gstcef" PUBLIC "-DCEF_SUBPROCESS_PATH=\"$<TARGET_FILE:gstcefsubprocess>\"")
  set_target_properties("gstcef" PROPERTIES INSTALL_RPATH "$ORIGIN")
  set_target_properties("gstcef" PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
  set_target_properties("gstcef" PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CEF_TARGET_OUT_DIR})


  COPY_FILES("gstcef" "${CEF_BINARY_FILES}" "${CEF_BINARY_DIR}" "${CEF_TARGET_OUT_DIR}")
  COPY_FILES("gstcef" "${CEF_RESOURCE_FILES}" "${CEF_RESOURCE_DIR}" "${CEF_TARGET_OUT_DIR}")
endif()
