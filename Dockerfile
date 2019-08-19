FROM hamzaudaipur/gstcefsrc:0.0

COPY . /home/root
RUN ls -l
RUN  mkdir build && cd build \
    && export PKG_CONFIG_PATH=/home/root/cerbero/build/dist/linux_x86_64/lib/pkgconfig:$PKG_CONFIG_PATH \
    && apt -y install libnss3  libatk-bridge2.0-0 libxcursor1  xscreensaver libxss1 \
    && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release .. \
    && make
