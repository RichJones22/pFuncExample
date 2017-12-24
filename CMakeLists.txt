cmake_minimum_required(VERSION 3.8)
project(pFuncExample)

set(CMAKE_C_STANDARD 90)

set(SOURCE_FILES
        formula.h
        formula.c
        main.c)
add_executable(pFuncExample ${SOURCE_FILES})