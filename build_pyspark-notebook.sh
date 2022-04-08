#!/bin/bash
export HADOOP_CONF_DIR=/home/jovyan/hadoop-configs/
export DOCKER_BUILDKIT=0
export JUPYTER_ENABLE_LAB=yes

# creation of a new builder needed to enabel multiarch feature 
# docker buildx create --name mymultiarchbuilder --use 

docker buildx build --platform linux/amd64,linux/arm64 \
    https://github.com/jupyter/docker-stacks.git#master:pyspark-notebook \
    -t csturm/pyspark-notebook:spark3.2.1_java11 \
    --push \
    --build-arg spark_version=3.2.1 \
    --build-arg hadoop_version=2.7 \
    --build-arg spark_checksum=2EC9F1CB65AF5EE7657CA83A1ABACA805612B8B3A1D8D9BB67E317106025C81BA8D44D82AD6FDB45BBE6CAA768D449CD6A4945EC050CE9390F806F46C5CB1397 \
    --build-arg openjdk_version=11
 #   --build-arg py4j_version=0.10.9

# settings for Hadoop 3.3
 #--build-arg hadoop_version=3.3 \
 #   --build-arg spark_checksum=145ADACF189FECF05FBA3A69841D2804DD66546B11D14FC181AC49D89F3CB5E4FECD9B25F56F0AF767155419CD430838FB651992AEB37D3A6F91E7E009D1F9AE \