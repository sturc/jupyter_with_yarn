#!/bin/bash

# creation of a new builder needed to enabel multiarch feature 
# docker buildx create --name mymultiarchbuilder --use 

docker buildx build --platform linux/amd64,linux/arm64 \
    -t csturm/hadoop-python:h3.2-p3.9.10-j11 \
    --push \
    hadoop 
