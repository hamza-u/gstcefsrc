#!/bin/bash
set -x -e

cd build
export PATH=$PATH:/home/root/cerbero/build/dist/linux_x86_64/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/root/cerbero/build/dist/linux_x86_64/lib/gstreamer-1.0/:/home/root/cerbero/build/dist/linux_x86_64/lib:$PWD/Release
cp `which gst-launch-1.0` Release/
export GST_PLUGIN_PATH=$PWD/Release:$GST_PLUGIN_PATH
xvfb-run -s "-screen 0 720x576x24" -e /dev/stdout -a  ./Release/$1
