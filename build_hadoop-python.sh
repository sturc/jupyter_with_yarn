#!/bin/bash

# creation of a new builder needed to enabel multiarch feature 
# docker buildx create --name mymultiarchbuilder --use 

docker buildx build --platform linux/amd64,linux/arm64 \
    -t csturm/hadoop-python:h2.10-p3.8.12-j11 \
    --push \
    hadoop 
