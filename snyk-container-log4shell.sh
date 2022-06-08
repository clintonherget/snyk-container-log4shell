#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "Usage: snyk-container-log4shell.sh [IMAGE NAME]"
    exit 0
fi

STORAGE=/tmp/snyk-container-log4shell
DOCKER=docker
SNYK=snyk

IMAGE="$1"
PWD=$(pwd)
IMAGE_TAR=$STORAGE/image.tar

mkdir -p $STORAGE
mkdir -p $STORAGE/image
mkdir -p $STORAGE/layers
mkdir -p $STORAGE/jars

echo "Pulling container image..."
$DOCKER pull $IMAGE

echo "Saving container image..."
$DOCKER save $IMAGE -o $IMAGE_TAR

echo "Extracting container image..."
tar -xf $IMAGE_TAR -C $STORAGE/image

echo "Extracting image layers..."
for i in $(cat $STORAGE/image/manifest.json | jq -r '.[]|.Layers|.[]')
do 
	tar -xf $STORAGE/image/$i -C $STORAGE/layers; 
done

echo "Finding JAR files..."
find $STORAGE/layers -name "*.jar" -exec mv {} $STORAGE/jars \;

echo "Running 'snyk log4shell'..."
cd $STORAGE/jars
$SNYK log4shell 
EXIT=$?

echo "Cleaning up..."
cd $PWD
rm -rf $STORAGE

exit $EXIT
