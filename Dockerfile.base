FROM continuumio/miniconda3:4.5.11

# sudo is needed by cerbero
# Git config is needed so that cerbero can cleanly fetch some git repos
# cerbero for gstreamer 1.14 needs python==2.7.*
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo build-essential yasm libtool \
    libx264-dev libfreetype6-dev swig automake autoconf liblog4cxx-dev \
    pkg-config cmake libbz2-dev liblzma-dev zlib1g-dev libva-dev libx11-dev vim\
    && conda create -n py27 python=2.7 \
    && conda update conda \
    && mkdir -p /home/root/cerbero/

WORKDIR /home/root/
RUN git clone --single-branch -b 1.14 https://github.com/Gstreamer/cerbero.git cerbero \
    && cd cerbero \
    && sed -i 's/apt-get install/apt-get install -y/g' ./cerbero/bootstrap/linux.py \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/glib.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gstreamer-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-plugins-base-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-plugins-good-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-plugins-bad-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-plugins-ugly-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-libav-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-rtsp-server-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/json-glib.recipe \
    &&/bin/bash -c "source activate py27 && python --version &&\
    ./cerbero-uninstalled bootstrap \
    && ./cerbero-uninstalled build glib \
    bison \
    gstreamer-1.0 \
    gst-plugins-base-1.0 \
    gst-plugins-good-1.0  \
    gst-plugins-bad-1.0 \
    gst-plugins-ugly-1.0 \
    gst-libav-1.0 \
    gst-rtsp-server-1.0 \
    json-glib \
    && rm -rf ./build/sources/*"

CMD ./cerbero-uninstalled shell
