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
1. docker run -it --rm hamzaudaipur/gstcefsrc ./run_in_docker.sh "gst-launch-1.0 -v cefsrc url=http://www.chiptune.com/kaleidoscope/ ! queue ! fakesink"

2. docker run -it --rm -v $PWD/output:/tmp/output hamzaudaipur/gstcefsrc ./run_in_docker.sh "gst-launch-1.0 -v cefsrc url=http://www.chiptune.com/kaleidoscope/ ! queue ! videoconvert ! avenc_targa ! multifilesink location=/tmp/output/img_%06d.tga"
```
