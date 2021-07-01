#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo $SCRIPT_DIR/Examples/ROS
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:$SCRIPT_DIR/Examples/ROS
export ORB_SLAM_DIR=$SCRIPT_DIR
