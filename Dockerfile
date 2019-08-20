FROM hamzaudaipur/gstcefsrc:0.0

COPY . /home/root
RUN ls -l
RUN  mkdir build && cd build \
    && export PKG_CONFIG_PATH=/home/root/cerbero/build/dist/linux_x86_64/lib/pkgconfig:$PKG_CONFIG_PATH \
    && apt -y install libnss3  libatk-bridge2.0-0 libxcursor1  xscreensaver libxss1 ttf-freefont xvfb \
    && wget http://opensource.spotify.com/cefbuilds/cef_binary_76.1.9%2Bg2cf916e%2Bchromium-76.0.3809.87_linux64.tar.bz2 \
    && mkdir ../third_party/cef -p && cp cef_binary* ../third_party/cef && cd ../third_party/cef && tar xvf cef_binary*.tar.bz2 && cd - \
    && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release .. \
    && make
