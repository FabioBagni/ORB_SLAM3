cmake_minimum_required(VERSION 2.8)
project(ORB_SLAM3)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release)
ENDIF()

MESSAGE("Build type: " ${CMAKE_BUILD_TYPE})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-deprecated -Wno-deprecated-declarations   -O3")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated -Wno-deprecated-declarations  -O3")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -march=native")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -march=native")

# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -Wno-deprecated -O3 -march=native ")
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -Wno-deprecated -O3 -march=native")

# Check C++11 or C++0x support
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
   add_definitions(-DCOMPILEDWITHC11)
   message(STATUS "Using flag -std=c++11.")
elseif(COMPILER_SUPPORTS_CXX0X)
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
   add_definitions(-DCOMPILEDWITHC0X)
   message(STATUS "Using flag -std=c++0x.")
else()
   message(FATAL_ERROR "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()

LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake_modules)

find_package(OpenCV 4.0)
if(NOT OpenCV_FOUND)
  find_package(OpenCV 3.0)
  if(NOT OpenCV_FOUND)
    message(FATAL_ERROR "OpenCV > 3.0 not found.")
  endif()
endif()

MESSAGE("OPENCV VERSION:")
MESSAGE(${OpenCV_VERSION})

find_package(Eigen3 3.1.0 REQUIRED)
find_package(Pangolin REQUIRED)
find_package(realsense2)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)

add_library(${PROJECT_NAME} SHARED
src/System.cc
src/Tracking.cc
src/LocalMapping.cc
src/LoopClosing.cc
src/ORBextractor.cc
src/ORBmatcher.cc
src/FrameDrawer.cc
src/Converter.cc
src/MapPoint.cc
src/KeyFrame.cc
src/Atlas.cc
src/Map.cc
src/MapDrawer.cc
src/Optimizer.cc
src/Frame.cc
src/KeyFrameDatabase.cc
src/Sim3Solver.cc
src/Initializer.cc
src/Viewer.cc
src/ImuTypes.cc
src/G2oTypes.cc
src/CameraModels/Pinhole.cpp
src/CameraModels/KannalaBrandt8.cpp
src/OptimizableTypes.cpp
src/MLPnPsolver.cpp
src/TwoViewReconstruction.cc
)

add_subdirectory(Thirdparty/g2o)
add_subdirectory(Thirdparty/DBoW2)

target_link_libraries(${PROJECT_NAME}
${OpenCV_LIBS}
${EIGEN3_LIBS}
${Pangolin_LIBRARIES}
DBoW2
g2o
-lboost_serialization
-lcrypto
)

target_include_directories(${PROJECT_NAME} PUBLIC
  ${PROJECT_SOURCE_DIR}/include
  ${PROJECT_SOURCE_DIR}/include/CameraModels
  ${EIGEN3_INCLUDE_DIR}
  ${Pangolin_INCLUDE_DIRS}
  )
  
  
### Build examples
  
if(NOT DEFINED BUILD_EXAMPLES)
  set(BUILD_EXAMPLES True)
endif()

if(BUILD_EXAMPLES)

  string(ASCII 27 Esc)
  message("${Esc}[1;32m" "-- Building examples" "${Esc}[m" )

  # RGB-D examples

  add_executable(rgbd_tum
  Examples/RGB-D/rgbd_tum.cc)
  target_link_libraries(rgbd_tum ${PROJECT_NAME})


  # Stereo examples

  add_executable(stereo_kitti
  Examples/Stereo/stereo_kitti.cc)
  target_link_libraries(stereo_kitti ${PROJECT_NAME})

  add_executable(stereo_euroc
  Examples/Stereo/stereo_euroc.cc)
  target_link_libraries(stereo_euroc ${PROJECT_NAME})

  add_executable(stereo_tum_vi
  Examples/Stereo/stereo_tum_vi.cc)
  target_link_libraries(stereo_tum_vi ${PROJECT_NAME})

  # Monocular examples

  add_executable(mono_tum
  Examples/Monocular/mono_tum.cc)
  target_link_libraries(mono_tum ${PROJECT_NAME})

  add_executable(mono_kitti
  Examples/Monocular/mono_kitti.cc)
  target_link_libraries(mono_kitti ${PROJECT_NAME})

  add_executable(mono_euroc
  Examples/Monocular/mono_euroc.cc)
  target_link_libraries(mono_euroc ${PROJECT_NAME})

  add_executable(mono_tum_vi
  Examples/Monocular/mono_tum_vi.cc)
  target_link_libraries(mono_tum_vi ${PROJECT_NAME})

  # Monocular-Inertial examples

  add_executable(mono_inertial_euroc
  Examples/Monocular-Inertial/mono_inertial_euroc.cc)
  target_link_libraries(mono_inertial_euroc ${PROJECT_NAME})

  add_executable(mono_inertial_tum_vi
  Examples/Monocular-Inertial/mono_inertial_tum_vi.cc)
  target_link_libraries(mono_inertial_tum_vi ${PROJECT_NAME})

  # Stereo-Inertial examples

  add_executable(stereo_inertial_euroc
  Examples/Stereo-Inertial/stereo_inertial_euroc.cc)
  target_link_libraries(stereo_inertial_euroc ${PROJECT_NAME})

  add_executable(stereo_inertial_tum_vi
  Examples/Stereo-Inertial/stereo_inertial_tum_vi.cc)
  target_link_libraries(stereo_inertial_tum_vi ${PROJECT_NAME})

  find_package(roscpp REQUIRED)

  if(roscpp_FOUND AND DEFINED ENV{ORB_SLAM_DIR})
    add_subdirectory(Examples/ROS/ORB_SLAM3)
  endif()

endif()