FROM ubuntu:xenial-20180417

# Initialize the image
# Modify to pre-install dev tools and ROCm packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl && \
  curl -sL http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add - && \
  sh -c 'echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main > /etc/apt/sources.list.d/rocm.list'

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated \
    autoconf \
    autogen \
    build-essential \
    cmake \
    cmake-curses-gui \
    git \
    libnuma-dev \
    libtool \
    miopen-hip \
    python-pip \
    python3-pip \
    rocm-cmake \
    rocm-libs \
    unzip \
    wget \
    zlib1g-dev

# Install rbuild
RUN pip install https://github.com/RadeonOpenCompute/rbuild/archive/master.tar.gz

# Get cadene models
RUN pip3 install torch==1.1.0 pretrainedmodels scipy
RUN mkdir /onnx
ADD get_pretrained.py /onnx/get_pretrained.py
RUN cd /onnx/ && python3 get_pretrained.py

# Install MIGraphX
RUN mkdir /src
RUN cd /src && git clone https://github.com/ROCmSoftwarePlatform/AMDMIGraphX

# Build MIGraphX driver
RUN rbuild build --cxx /opt/rocm/bin/hcc -d /deps -B /build -S /src/AMDMIGraphX -t driver
WORKDIR /build/bin

