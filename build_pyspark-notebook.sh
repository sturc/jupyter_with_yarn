#!/bin/bash
export HADOOP_CONF_DIR=/home/jovyan/hadoop-configs/
export DOCKER_BUILDKIT=0
export JUPYTER_ENABLE_LAB=yes

docker build \
    https://github.com/jupyter/docker-stacks.git#master:pyspark-notebook \
    -t csturm/pyspark-notebook:winter-term-2021 \
    --build-arg spark_version=3.1.2 \
    --build-arg hadoop_version=2.7 \
    --build-arg spark_checksum=BA47E074B2A641B23EE900D4E28260BAA250E2410859D481B38F2EAD888C30DAEA3683F505608870148CF40F76C357222A2773F1471E7342C622E93BF02479B7 \
    --build-arg openjdk_version=8 \
    --build-arg py4j_version=0.10.9
