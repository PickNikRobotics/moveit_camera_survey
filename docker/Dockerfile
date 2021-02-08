FROM osrf/ros:noetic-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
  cmake-curses-gui \
  git \
  libopencv-dev \
  libpcl-dev \
  python3-catkin-tools \
  python3-pip \
  tmux \
  vim \
  && pip3 install osrf-pycommon

COPY tmux.conf /root/.tmux.conf

# Install GPD
WORKDIR /root
RUN git clone https://github.com/atenpas/gpd && \
  mkdir -p gpd/build && \
  cd gpd/build && \
  cmake .. && make -j 4 && \
  make install

# Get MTC, deep grasp demo, MoveIt Calibration, and UR drivers
RUN mkdir -p ~/ws_cam_survey/src && cd ~/ws_cam_survey/src && \
  wstool init . && \
  wstool merge -t . https://raw.githubusercontent.com/ros-planning/moveit/master/moveit.rosinstall && \
  wstool merge -t . https://raw.githubusercontent.com/ros-planning/moveit_task_constructor/master/.rosinstall && \
  wstool merge -r -y -t . https://raw.githubusercontent.com/PickNikRobotics/deep_grasp_demo/master/.rosinstall && \
  wstool update

# Set up MoveIt Cal, UR, Robotiq, this repo
WORKDIR /root/ws_cam_sruvey/src
RUN git clone https://github.com/ros-planning/moveit_calibration && \
  git clone https://github.com/UniversalRobots/Universal_Robots_ROS_Driver && \
  git clone -b calibration_devel https://github.com/JStech/universal_robot universal_robot && \
  git clone https://github.com/JStech/robotiq_85_gripper && \
  git clone https://github.com/PickNikRobotics/moveit_camera_survey

# Get the right branches
WORKDIR /root/ws_cam_survey/src/deep_grasp_demo
RUN touch moveit_task_constructor_dexnet/CATKIN_IGNORE && \
  git remote add jstech https://github.com/JStech/deep_grasp_demo.git && git fetch jstech && \
  git checkout fix-opencv-cmakelists
WORKDIR /root/ws_cam_survey/src/moveit_task_constructor
RUN git remote add jstech https://github.com/JStech/moveit_task_constructor.git && git fetch jstech && \
  git checkout jstech/pr-deep_grasp_stage

# Get everything else from rosdep
RUN rosdep update && rosdep install -y --from-paths . --ignore-src --rosdistro noetic

RUN apt install ros-noetic-rviz

RUN cd ~/ws_cam_survey && catkin config --extend /opt/ros/noetic --cmake-args -DCMAKE_BUILD_TYPE=Release \
  -DOpenCV_DIR=/usr/lib/x86_64-linux-gnu/cmake && \
  catkin build

COPY ur5e_cal.yaml /root/ur5e_cal.yaml
