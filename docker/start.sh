#!/bin/bash

XSOCK=/tmp/.X11-unix

docker run -it --rm \
  --name cam-survey \
  --network host \
  --privileged \
  --device=/dev/ttyUSB0 \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/.Xauthority:/root/.Xauthority \
  jstechschulte/moveit-camera-survey:base
