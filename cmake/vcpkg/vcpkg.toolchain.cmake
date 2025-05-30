# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

cmake_minimum_required(VERSION 4.0)

get_property(IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE)

if(IN_TRY_COMPILE)
  return()
endif()

unset(IN_TRY_COMPILE)

include(${CMAKE_CURRENT_LIST_DIR}/bootstrap/vcpkg-config.cmake)

vcpkg_configure(
  CACHE_DIR_NAME @cpp_pt_name@
  REPO https://github.com/microsoft/vcpkg.git
  REF ce613c41372b23b1f51333815feb3edd87ef8a8b # release 2025.04.09
)

include($CACHE{_VCPKG_TOOLCHAIN_FILE})
