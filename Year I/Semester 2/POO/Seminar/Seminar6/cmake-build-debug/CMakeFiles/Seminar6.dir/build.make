# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.17.1/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.17.1/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/cmake-build-debug"

# Include any dependencies generated for this target.
include CMakeFiles/Seminar6.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/Seminar6.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Seminar6.dir/flags.make

CMakeFiles/Seminar6.dir/main.cpp.o: CMakeFiles/Seminar6.dir/flags.make
CMakeFiles/Seminar6.dir/main.cpp.o: ../main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/cmake-build-debug/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/Seminar6.dir/main.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/Seminar6.dir/main.cpp.o -c "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/main.cpp"

CMakeFiles/Seminar6.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Seminar6.dir/main.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/main.cpp" > CMakeFiles/Seminar6.dir/main.cpp.i

CMakeFiles/Seminar6.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Seminar6.dir/main.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/main.cpp" -o CMakeFiles/Seminar6.dir/main.cpp.s

# Object files for target Seminar6
Seminar6_OBJECTS = \
"CMakeFiles/Seminar6.dir/main.cpp.o"

# External object files for target Seminar6
Seminar6_EXTERNAL_OBJECTS =

Seminar6: CMakeFiles/Seminar6.dir/main.cpp.o
Seminar6: CMakeFiles/Seminar6.dir/build.make
Seminar6: CMakeFiles/Seminar6.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir="/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/cmake-build-debug/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable Seminar6"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Seminar6.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Seminar6.dir/build: Seminar6

.PHONY : CMakeFiles/Seminar6.dir/build

CMakeFiles/Seminar6.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Seminar6.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Seminar6.dir/clean

CMakeFiles/Seminar6.dir/depend:
	cd "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/cmake-build-debug" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6" "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6" "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/cmake-build-debug" "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/cmake-build-debug" "/Users/dariusbuhai/Desktop/Proiecte Facultate/Semestrul 2/POO/Seminare/Seminar6/cmake-build-debug/CMakeFiles/Seminar6.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : CMakeFiles/Seminar6.dir/depend

