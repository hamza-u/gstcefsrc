FROM centos:centos7.2.1511

RUN yum -y install git vim sudo build-essential yasm libtool \
    libx264-devel libfreetype6-devel swig automake autoconf liblog4cxx-devel \
    pkg-config cmake libbz2-devel liblzma-devel zlib1g-devel libva-devel libx11-devel \
    && conda create -n py27 python=2.7 \
    && conda update conda \
    && mkdir -p /home/root/cerbero/

RUN git clone --single-branch -b 1.14 https://github.com/Gstreamer/cerbero.git cerbero \
    && cd cerbero \
    && ./cerbero-uninstalled bootstrap \
    && ./cerbero-uninstalled build glib \
    bison \
    gstreamer-1.0 \
    gst-plugins-base-1.0 \
    gst-plugins-good-1.0  \
    gst-plugins-bad-1.0 \
    gst-plugins-ugly-1.0 \
    gst-libav-1.0 \
    gst-rtsp-server-1.0 \
    json-glib
