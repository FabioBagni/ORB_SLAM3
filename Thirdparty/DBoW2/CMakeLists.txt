cmake_minimum_required(VERSION 2.8)
project(DBoW2)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}    -O3 -march=native ")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}   -O3 -march=native")

set(SRCS_DBOW2
  DBoW2/BowVector.cpp
  DBoW2/FORB.cpp      
  DBoW2/FeatureVector.cpp
  DBoW2/ScoringObject.cpp
  DUtils/Random.cpp
  DUtils/Timestamp.cpp
)

add_library(DBoW2 SHARED ${SRCS_DBOW2})
target_include_directories(DBoW2 PUBLIC
  ${CMAKE_CURRENT_LIST_DIR}
)

