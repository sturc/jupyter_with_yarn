#!/bin/bash

# creation of a new builder needed to enabel multiarch feature 
# docker buildx create --name mymultiarchbuilder --use 

# switching to existing builder 
# docker buildx use mymultiarchbuilder

docker buildx build --platform linux/amd64,linux/arm64 \
    -t csturm/hadoop-python:h3.3.6-p3.9.20-j11 \
    --push \
    hadoop 
