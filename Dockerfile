FROM hamzaudaipur/gstcefsrc:0.0

COPY . /home/root

RUN apt -y install libnss3  libatk-bridge2.0-0 libxcursor1  xscreensaver libxss1 ttf-freefont xvfb

RUN  mkdir build && cd build \
    && export PKG_CONFIG_PATH=/home/root/cerbero/build/dist/linux_x86_64/lib/pkgconfig:$PKG_CONFIG_PATH \
    && wget http://opensource.spotify.com/cefbuilds/cef_binary_78.3.9%2Bgc7345f2%2Bchromium-78.0.3904.108_linux64.tar.bz2 \
    && mkdir ../third_party/cef -p && cp cef_binary* ../third_party/cef && cd ../third_party/cef && tar xvf cef_binary*.tar.bz2 && cd - \
    #&& mkdir ../third_party/cef -p \
    && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release .. \
    && make \
    && cd .. && find . -name "*.bz2" | xargs rm
