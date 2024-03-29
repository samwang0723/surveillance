!/bin/bash

echo -e "\n\
@edgemain http://nl.alpinelinux.org/alpine/edge/main\n\
@edgecomm http://nl.alpinelinux.org/alpine/edge/community\n\
@edgetest http://nl.alpinelinux.org/alpine/edge/testing"\
  >> /etc/apk/repositories

apk --no-cache add bash build-base ca-certificates clang-dev clang cmake coreutils curl freetype-dev ffmpeg-dev ffmpeg-libs gcc g++ git gettext lcms2-dev libavc1394-dev libc-dev libffi-dev libjpeg-turbo-dev libpng-dev libressl-dev libtbb@edgetest libtbb-dev@edgetest libwebp-dev linux-headers make musl openblas@edgecomm openblas-dev@edgecomm openjpeg-dev openssl python3 python3-dev tiff-dev unzip zlib-dev

ln -s /usr/bin/python3 /usr/local/bin/python
ln -s /usr/bin/pip3 /usr/local/bin/pip
apk add py3-pip
pip install --upgrade pip

ln -s /usr/include/locale.h /usr/include/xlocale.h
pip install numpy

mkdir /opt && cd /opt && \
  wget https://github.com/opencv/opencv/archive/3.2.0.zip && \
  unzip 3.2.0.zip && rm 3.2.0.zip && \
  wget https://github.com/opencv/opencv_contrib/archive/3.2.0.zip && \
  unzip 3.2.0.zip && rm 3.2.0.zip \
  && \
  cd /opt/opencv-3.2.0 && mkdir build && cd build && \
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_C_COMPILER=/usr/bin/clang \
    -D CMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D WITH_FFMPEG=ON \
    -D WITH_TBB=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-3.2.0/modules \
    -D PYTHON_EXECUTABLE=/usr/local/bin/python \
    .. \
  && \
  make -j$(nproc) && make install && cd .. && rm -rf build \
  && \
  cp -p $(find /usr/local/lib/python3.5/site-packages -name cv2.*.so) \
   /usr/lib/python3.5/site-packages/cv2.so && \
   python -c 'import cv2; print("Python: import cv2 - SUCCESS")'


