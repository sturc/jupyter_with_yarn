#
#  Author: Christoph Sturm
#
#
#  https://github.com/sturc/jupyter_with_yarn
#
#

#FROM centos:latest
FROM quay.io/centos/centos:stream9
ARG JAVA_VERSION=11
ARG JAVA_RELEASE=JDK

ARG HADOOP_VERSION=3.3.6

ARG TAR=hadoop-$HADOOP_VERSION.tar.gz

#ARG PYTHON_VERSION=3.9.10
#ARG PYTHON_SHORT_VERSION=3.8
#ARG PYTHON_MAIN_VERSION=3
#ARG PYTHON_TAR=Python-${PYTHON_VERSION}.tgz

ENV PATH $PATH:/hadoop/bin

LABEL Description="Hadoop Node" \
      "Hadoop Version"="$HADOOP_VERSION"

WORKDIR /

RUN set -eux && \
    pkg="java-$JAVA_VERSION-openjdk" && \
    if [ "$JAVA_RELEASE" = "JDK" ]; then \
        pkg="$pkg-devel"; \
    else \
        pkg="$pkg-headless"; \
    fi; \
    yum install -y "$pkg" && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY profile.d/java.sh /etc/profile.d/

ENV JAVA_HOME=/usr

RUN set -eux && \
    yum -y update && \ 
    yum install -y openssh-server openssh-clients tar which && \
    yum install -y gcc openssl-devel bzip2-devel libffi-devel make && \
    yum install -y iputils net-tools procps 

RUN set -eux && \
    yum install -y wget hostname && \
    # --max-redirect - some apache mirrors redirect a couple times and give you the latest version instead
    #                  but this breaks stuff later because the link will not point to the right dir
    #                  (and is also the wrong version for the tag)
    wget -t 10 --max-redirect 1 --retry-connrefused -O "$TAR" "http://www.apache.org/dyn/closer.lua?filename=hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-$HADOOP_VERSION.tar.gz&action=download" || \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "$TAR" "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-$HADOOP_VERSION.tar.gz" && \
    tar zxf "$TAR" && \
    # check tarball was extracted to the right place, helps ensure it's the right version and the link will work
    test -d "hadoop-$HADOOP_VERSION" && \
    ln -sv "hadoop-$HADOOP_VERSION" hadoop && \
    mkdir /etc/hadoop && \
    ln -s /hadoop/etc/hadoop /etc/hadoop/conf && \
    rm -fv "$TAR" && \
    { rm -rf hadoop/share/doc; : ; } && \
    yum autoremove -y && \
    # gets autoremoved, ensure it's added back as Hadoop scripts need it
    yum install -y hostname && \
    yum clean all && \
    rm -rf /var/cache/yum

# install python 
COPY conf/requirements.txt /
RUN set -eux && \
    yum install python3 -y && \
    yum install python3-pip -y && \
    pip install -r /requirements.txt && \
    yum clean all && \
    rm -rf /var/cache/yum


COPY entrypoint.sh /
COPY conf/core-site.xml /hadoop/etc/hadoop/
COPY conf/hdfs-site.xml /hadoop/etc/hadoop/
COPY conf/yarn-site.xml /hadoop/etc/hadoop/
COPY conf/mapred-site.xml /hadoop/etc/hadoop/
COPY profile.d/hadoop.sh /etc/profile.d/
COPY ssh/config /root/.ssh/

RUN set -eux && \
    # Hadoop 1.x
    #/hadoop/bin/hadoop namenode -format && \
    # Hadoop 2.x
    /hadoop/bin/hdfs namenode -format && \
    groupadd hadoop && \
    useradd -g hadoop hdfs && \
    useradd -g hadoop yarn && \
    mkdir -p /dfs/name && \
    mkdir -p /dfs/data && \
    mkdir -p /hadoop/logs && \
    chown -R hdfs:hadoop /dfs/name && \
    chown -R hdfs:hadoop /dfs/data && \
    chgrp -R hadoop /hadoop/logs && \
    chmod -R 0770 /hadoop/logs && \
    mkdir -p /root/.ssh \
          /home/hdfs/.ssh \
          /home/yarn/.ssh && \
    chown hdfs /home/hdfs/.ssh && \
    chown yarn /home/yarn/.ssh && \
    chmod 0700 /root/.ssh \
               /home/hdfs/.ssh \
               /home/yarn/.ssh

ENV HDFS_NAMENODE_USER=hdfs
ENV HDFS_SECONDARYNAMENODE_USER=hdfs
ENV HDFS_DATANODE_USER=hdfs
ENV YARN_RESOURCEMANAGER_USER=yarn
ENV YARN_NODEMANAGER_USER=yarn
ENV PYSPARK_PYTHON=/usr/bin/python3
ENV PYSPARK_DRIVER_PYTHO=/usr/bin/python3
ENV SPARK_YARN_USER_ENV=/usr/bin/python3

#EXPOSE 8020 8042 8088 9000 10020 19888 50010 50020 50070 50075 50090
# Hadoop 3.0 changed ports :-(
EXPOSE 8020 8042 8088 9000 9864 9865 9868 9870 9871 10020 19888 50070 50071

CMD ["/entrypoint.sh"]
RUN chmod 0600 -R /root/.ssh/
