# gstcefsrc

## Build

```
mkdir build && cd build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..
make
```

## Run

Because of [this issue], the main executable must be located in the
same directory as the resources in the build folder. This makes things
pretty awkward with gst-launch, but can be worked around as follows:

```
cp `which gst-launch-1.0` Release/
```

The element can then be tested with:

```
GST_PLUGIN_PATH=$PWD/Release:$GST_PLUGIN_PATH Release/gst-launch-1.0 -v cefsrc url="https://webglsamples.org/aquarium/aquarium.html" ! queue ! videoconvert ! xvimagesink
```

[this issue]: https://bitbucket.org/chromiumembedded/cef/issues/1936/override-paths-dir_exe-dir_module-on-linux

## Build Docker

Clone this repo.

```
docker build .
```

### Run Gst-Cef inside docker

```
docker run -it --rm hamzaudaipur/gstcefsrc:cef_76.1.10 bash
cd build
export PATH=$PATH:/home/root/cerbero/build/dist/linux_x86_64/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/root/cerbero/build/dist/linux_x86_64/lib/gstreamer-1.0/:/home/root/cerbero/build/dist/linux_x86_64/lib:$PWD/Release
cp `which gst-launch-1.0` Release/
export GST_PLUGIN_PATH=$PWD/Release:$GST_PLUGIN_PATH
xvfb-run -s "-screen 0 720x576x24" -e /dev/stdout -a  ./Release/gst-launch-1.0 -v cefsrc url="http://www.chiptune.com/kaleidoscope/" ! queue ! fakesink
```
