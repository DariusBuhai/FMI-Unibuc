cmake_minimum_required(VERSION 3.15)
project(Tema2)

set(CMAKE_CXX_STANDARD 14)

add_executable(Tema2 main.cpp src/nfa.h include/nfa.cpp src/dfa.h include/dfa.cpp include/regram.cpp src/regram.h src/state.h)