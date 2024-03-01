cmake_minimum_required(VERSION 3.12)
project(cmake_git)

include(git_version.cmake)

add_executable(main main.cpp)
