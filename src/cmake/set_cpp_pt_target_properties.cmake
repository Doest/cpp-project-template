# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

find_package(fmt CONFIG REQUIRED)
find_package(Microsoft.GSL CONFIG REQUIRED)
find_package(range-v3 CONFIG REQUIRED)

# sets default target properties
function(set_@cpp_pt_cmake@_target_properties target type)
  if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 14.0) 
        target_compile_features(${target} ${type} cxx_std_26)
    else()
        target_compile_features(${target} ${type} cxx_std_23)
    endif()
  elseif (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
      if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 18.0) 
          target_compile_features(${target} ${type} cxx_std_26)
      else()
          target_compile_features(${target} ${type} cxx_std_23)
      endif()
  else()
      target_compile_features(${target} ${type} cxx_std_23)
  endif()
  
  set_target_properties(${target}
    PROPERTIES
      CXX_STANDARD_REQUIRED ON
      CXX_VISIBILITY_PRESET hidden
      VISIBILITY_INLINES_HIDDEN ON
  )

  target_compile_options(${target}
    ${type}
      $<$<AND:$<CXX_COMPILER_ID:Clang>,$<PLATFORM_ID:Linux>>:-stdlib=libc++>
  )

  target_link_options(${target}
    ${type}
      $<$<AND:$<CXX_COMPILER_ID:Clang>,$<PLATFORM_ID:Linux>>:-stdlib=libc++ -lc++abi>
  )

  if (NOT CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
    target_compile_options(${target} ${type}
      $<$<CXX_COMPILER_ID:MSVC>:/W4>
      $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wall -Wextra -Wpedantic>
    )
  endif()

  target_link_libraries(${target}
    ${type}
      Microsoft.GSL::GSL
  )
endfunction()
