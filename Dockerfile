FROM conda/miniconda3-centos7

RUN  yum -y --enablerepo=extras install epel-release \
    && yum -y install git vim sudo yasm libtool \
    libx264-devel libfreetype-devel swig automake autoconf log4cxx-devel \
    pkgconfig cmake bz2-libs-devel lzma-devel zlib-devel libva-devel libX11-devel \
    && conda create -n py27 python=2.7 \
    && conda update conda \
    && mkdir -p /home/root/cerbero/ \
    && yum -y groupinstall 'Development Tools'

RUN git clone --single-branch -b 1.14 https://github.com/Gstreamer/cerbero.git cerbero \
    && cd cerbero \
    && sed -i 's/yum install/yum install -y/g' ./cerbero/bootstrap/linux.py \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/glib.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gstreamer-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-plugins-base-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-plugins-good-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-plugins-bad-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-plugins-ugly-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-libav-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/gst-rtsp-server-1.0.recipe \
    && sed -i 's/--enable-static/--disable-static/g' ./recipes/json-glib.recipe \
    && /bin/bash -c "source activate py27 && python --version \
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
    json-glib"
