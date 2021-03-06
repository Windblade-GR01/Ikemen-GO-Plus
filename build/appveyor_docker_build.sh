#!/bin/bash

###############################################################################
# Simple script that uses a docker image to build the binaries of Ikemen_GO for 
# Windows/Linux/OSX plataforms
# the only dependencies are the source code of Ikemen_GO_plus and docker.
#
# @author Daniel Porto 
# https://github.com/danielporto
###############################################################################

# Parameters explained:
#  run  : download and execute the docker container with the building tools
#  --rm : discard the container after using it. It saves disk space
#  -e   : set environment variables used by the scripts called inside the container 
#         these variables select the cross-compiling parameters invoked. 
#         Look inside the get.sh and build.sh for details. 
#  -v   : maps a volume (folder) inside the  container (makes the current source code accessible inside the container)
#       $(pwd):/code is source:destination and $(pwd) maps to current directory where the script is called.
#  -i   : interactive. 
#  -t   : allocate a pseudo terminal
#  windblade/ikemen-dev-gacel:latest        : docker image configured with the tooling required to build the binaries.
#  bash -c 'cd /code && bash -x get.sh' : command called when the container launches. In changes to the code directory
#  then execute both get and build scripts 

cd ..

echo "Building linux binary..."
docker run --rm -e OS=linux -v $(pwd):/code -i windblade/ikemen-dev-gacel:latest bash -c 'cd /code/build && bash -x get.sh' 
docker run --rm -e OS=linux -v $(pwd):/code -i windblade/ikemen-dev-gacel:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 

echo "Building mac binary..."
docker run --rm -e OS=mac -v $(pwd):/code -i windblade/ikemen-dev-gacel:latest bash -c 'cd /code/build && bash -x get.sh' 
docker run --rm -e OS=mac -v $(pwd):/code -i windblade/ikemen-dev-gacel:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 

echo "Building windows x86 binary..."
docker run --rm -e OS=windows32 -v $(pwd):/code -i windblade/ikemen-dev-gacel:latest bash -c 'cd /code/build && bash -x get.sh' 
docker run --rm -e OS=windows32 -v $(pwd):/code -i windblade/ikemen-dev-gacel:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 

# We copy the Windres files so we can have a icon files
cp 'windres/Ikemen_Cylia_x64.syso' 'src/Ikemen_Cylia_x64.syso'

echo "Building windows x64 binary..."
docker run --rm -e OS=windows -v $(pwd):/code -i windblade/ikemen-dev-gacel:latest bash -c 'cd /code/build && bash -x get.sh' 
docker run --rm -e OS=windows -v $(pwd):/code -i windblade/ikemen-dev-gacel:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 