#!/bin/bash

OPENCV_VERSION=4.5.4

maj=$(cat /usr/include/cudnn_version.h | grep "#define CUDNN_MAJOR" | cut -c 21)
min=$(cat /usr/include/cudnn_version.h | grep "#define CUDNN_MINOR" | cut -c 21)
pat=$(cat /usr/include/cudnn_version.h | grep "#define CUDNN_PATCHLEVEL" | cut -c 26)
cudnnV=$maj"."$min"."$pat
cudaV=$(nvidia-smi | grep CUDA | cut -c 70-74)

if [ -z "$cudaV" ];
then echo "$(tput setaf 1)YOU DON'T HAVE CUDA INSTALLED! PLZ INSTALL IT." 
exit;
else echo "$(tput setaf 2)CUDA VERSION: "$cudaV;
fi

if [ -z "$cudnnV" ];
then echo "$(tput setaf 1)YOU DON'T HAVE CUDNN INSTALLED! PLZ INSTALL IT." 
exit;
else echo "$(tput setaf 2)CUDNN VERSION: "$cudnnV;
fi

echo "$(tput setaf 3)STARTING TO INSTALL OPENCV VERSION: "$(tput setaf 2)$OPENCV_VERSION$(tput setaf 7)
sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential cmake pkg-config unzip yasm git checkinstall
sudo apt install -y libjpeg-dev libpng-dev libtiff-dev
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev libavresample-dev
sudo apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt install -y libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev 
sudo apt install -y libfaac-dev libmp3lame-dev libvorbis-dev
sudo apt install -y libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt-get install -y libdc1394-22 libdc1394-22-dev libxine2-dev libv4l-dev v4l-utils
cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h
cd ~
sudo apt-get install -y libgtk-3-dev
sudo apt-get install -y python3-dev python3-pip
sudo -H pip3 install -y -U pip numpy
sudo apt install -y python3-testresources
sudo apt-get install -y libtbb-dev
sudo apt-get install -y libatlas-base-dev gfortran
sudo apt-get install -y libprotobuf-dev protobuf-compiler
sudo apt-get install -y libgoogle-glog-dev libgflags-dev
sudo apt-get install -y libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
echo "$(tput setaf 3)Moving to Downloads"
cd ~/Downloads
wget -O opencv.zip https://github.com/opencv/opencv/archive/refs/tags/$OPENCV_VERSION.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/refs/tags/$OPENCV_VERSION.zip
unzip opencv.zip
unzip opencv_contrib.zip
echo "$(tput setaf 3)Create a virtual environtment for the python binding module (OPTIONAL)"
sudo pip install virtualenv virtualenvwrapper
sudo rm -rf ~/.cache/pip
echo "$(tput setaf 3)Edit ~/.bashrc"
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv cv -p python3
pip install numpy
echo "$(tput setaf 3)Procced with the installation"
cd opencv-$OPENCV_VERSION
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D WITH_TBB=ON \
-D ENABLE_FAST_MATH=1 \
-D CUDA_FAST_MATH=1 \
-D WITH_CUBLAS=1 \
-D WITH_CUDA=ON \
-D BUILD_opencv_cudacodec=OFF \
-D WITH_CUDNN=ON \
-D OPENCV_DNN_CUDA=ON \
-D WITH_V4L=ON \
-D WITH_QT=OFF \
-D WITH_OPENGL=ON \
-D WITH_GSTREAMER=ON \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D OPENCV_PC_FILE_NAME=opencv4.pc \
-D OPENCV_ENABLE_NONFREE=ON \
-D OPENCV_PYTHON3_INSTALL_PATH=~/.virtualenvs/cv/lib/python3.8/site-packages \
-D PYTHON_EXECUTABLE=~/.virtualenvs/cv/bin/python \
-D OPENCV_EXTRA_MODULES_PATH=~/Downloads/opencv_contrib-$OPENCV_VERSION/modules \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D INSTALL_C_EXAMPLES=OFF \
-D BUILD_EXAMPLES=OFF ..
echo "$(tput setaf 3)Making OpenCV (This will take severl min or severl hours depending on you PC processing power) $(tput setaf 1)DO NOT SHUT DOWN PC"
make -j6
echo "$(tput setaf 3)Installing OpenCV (This will take severl min or severl hours depending on you PC processing power) $(tput setaf 1)DO NOT SHUT DOWN PC"
sudo make install
