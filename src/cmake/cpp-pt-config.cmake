# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include(CMakeFindDependencyMacro)

find_dependency(Microsoft.GSL)

include("${CMAKE_CURRENT_LIST_DIR}/@cpp_pt_name@-targets.cmake")
