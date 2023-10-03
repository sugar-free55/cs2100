cmake_minimum_required(VERSION 3.26)
project(CS2100Assig1 C)

set(CMAKE_C_STANDARD 11)

include_directories(.)

add_executable(CS2100Assig1
        parity.c
        parity.h
        q1.c
        test.c)
