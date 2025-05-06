# C++ project template
This is a modified version of [msvetkins' cpp-project-template](https://github.com/msvetkin/cpp-project-template), that I try to keep updated to suit my own needs for C++ project


## Read first

### Problems
The way it works currently doesn't seem to work well with the CMake pluging in VSCode. Still trying to figure that out. One of the issues is related to finding the compiler as the location of cl.exe is not known to VSCode.

### Windows Quirks
For Windows I need to manually install these dependencies.
- Cmake 4.0+
- Ninja

For windows, Ninja, does not seem to come with the tool chains, or at least I cant get it to find it with this framework. 
Manually installing via winget is my suggestion to fix this.
```sh
winget install Ninja-build.Ninja
winget install Kitware.CMake
```

Also for Windows it seems that the cl.exe (MSVC Compiler) is not in PATH, and one has to either add it to PATH manually or use the Developer Powershell for VS 2022. At least this seems to be the case for all Windows computers that I have tried this on.

### Using Windows.MSVC toolchain file
Using this repo for setting up MSVC toolchain. 
[https://github.com/MarkSchofield/WindowsToolchain](https://github.com/MarkSchofield/WindowsToolchain)

### C++23 Minimum C++ version for the project.
On GNU and Clang compilers new enough to support it, the template will enable C++26
Otherwise it will default to C++23, MSVC only supports C++23 as of April 2025.
It will fail if compiler does not have C++23 support.

## Template Initialization

This project is a template that cannot be used before initialization. To initialize your project, you must run the following shell command:

```sh
cmake -P init.cmake --project <name> --module <name> --header <name>
```

- **Project name** will become your top-level CMake project name
  - Must be alphanumeric and begin with a character.
- **Module name** will be concatenated with your project name to determine the library's namespace (`${project}::${module}`)
- **Header name** will become the name of your library's main include header


## Building

To build the project locally, you will need to select a [CMake](https://cmake.org/) preset that matches your system configuration. Your system's configuration is described by a [triplet](https://wiki.osdev.org/Target_Triplet). This is inspired by [rust triples](https://doc.rust-lang.org/nightly/rustc/platform-support.html).

Presets for the most common system triplets are defined in [`cmake/presets/`](./cmake/presets/) and presented via [`CMakePresets.json`](./CMakePresets.json). 

Notice that each system triplet defines a preset for multiple compilers. If you have a compiler preference, you can pick the respective preset. If you do not have a preference, you can choose the following reccomendation (depending on your OS): 

 - Windows: `msvc`
 - MacOS: `clang`
 - Linux: `gcc`

Now you can configure and build your project:

```sh
cmake --workflow --preset=<PRESET>
```

This is equivalend to running the following in a step-by-step proceedure:

```sh
# Configure
cmake --preset=<PRESET>
# Build
cmake --build --preset=<PRESET>
# Test
ctest --preset=<PRESET>
```

Regardless of how you build, the `build/<PRESET>` folder will be populated with the binaries for all of your [CMake targets](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Key%20Concepts.html#targets).

## Usage

By default, this template comes with a CLI entrypoint defined in [`src/cli/src/main.cpp`](src/cli/src/main.cpp), and one module/library defined in your `src` folder. The Command Line Interface contains a very basic `main` function, and can be run after building by the `build/<PRESET>/src/cli/<Debug|Release|RelWithDebInfo>/<PROJECT_NAME>_cli` executable(s).

Tests are run with [Catch2](https://github.com/catchorg/Catch2). They can be written in the [`tests`](tests) subdirectory, and run with CTest:

```sh
ctest --preset <PRESET>
```

For usage within another C++ project, you can add the following to your CMake configuration:

```cmake
find_package(<PROJECT_NAME> CONFIG REQUIRED)
target_link_libraries(<TARGET> PUBLIC <PROJECT_NAME>::<MODULE_NAME>)
```

This will require that your library is published and installed via vcpkg or found locally by setting the `CMAKE_PREFIX_PATH` environment variable in your other project during configure.
