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

## Run Gst-Cef inside docker

### Testing using Fakesink
```
docker run -it --rm hamzaudaipur/gstcefsrc ./run_in_docker.sh "gst-launch-1.0 -v cefsrc url=http://www.chiptune.com/kaleidoscope/ ! queue ! fakesink"
```
### Writing to TARGA files.
```
docker run -it --rm -v $PWD/output:/tmp/output hamzaudaipur/gstcefsrc ./run_in_docker.sh "gst-launch-1.0 -v cefsrc url=http://www.chiptune.com/kaleidoscope/ ! queue ! videoconvert ! avenc_targa ! multifilesink location=/tmp/output/img_%06d.tga"
```

### Streaming to YouTube
```
docker run -it  --shm-size=512m --rm --network=host hamzaudaipur/gstcefsrc ./run_in_docker.sh "gst-launch-1.0 -v cefsrc url=http://www.chiptune.com/kaleidoscope/ ! videoconvert ! queue ! avenc_flv bitrate=5000000 ! queue ! flvmux name=mux streamable=true ! queue ! rtmpsink sync=true async=true location=rtmp://a.rtmp.youtube.com/live2/key  audiotestsrc samplesperbuffer=44100 wave=silence ! avenc_aac ! queue ! mux."
```
