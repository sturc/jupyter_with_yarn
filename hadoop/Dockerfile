#
#  Author: Hari Sekhon
#  Date: 2016-04-24 21:18:57 +0100 (Sun, 24 Apr 2016)
#
#  vim:ts=4:sts=4:sw=4:et
#
#  https://github.com/harisekhon/Dockerfiles
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback
#
#  https://www.linkedin.com/in/harisekhon
#

FROM harisekhon/centos-java:latest

ARG HADOOP_VERSION=2.8.2

ARG TAR=hadoop-$HADOOP_VERSION.tar.gz

ARG PYTHON_VERSION=3.8.6
ARG PYTHON_SHORT_VERSION=3.8
ARG PYTHON_MAIN_VERSION=3

ARG PYTHON_TAR=Python-${PYTHON_VERSION}.tgz

ENV PATH $PATH:/hadoop/bin

LABEL Description="Hadoop Dev" \
      "Hadoop Version"="$HADOOP_VERSION"

WORKDIR /

RUN set -eux && \
    yum -y update && \ 
    yum install -y openssh-server openssh-clients tar which && \
    yum install -y gcc openssl-devel bzip2-devel libffi-devel make

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
    wget -t 10 --max-redirect 1 --retry-connrefused -O "${PYTHON_TAR}" "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz" && \
    tar xvf "$PYTHON_TAR" && \
    rm "$PYTHON_TAR" && \
    cd "Python-${PYTHON_VERSION}" && \
    ./configure --enable-optimizations && \
    make altinstall && \
    rm -r "../Python-${PYTHON_VERSION}" && \
    cd /usr/local/bin && \
    ln -s "idle${PYTHON_SHORT_VERSION}" "idle${PYTHON_MAIN_VERSION}" && \
	ln -s "pydoc${PYTHON_SHORT_VERSION}" "pydoc${PYTHON_MAIN_VERSION}" && \
	ln -s "python${PYTHON_SHORT_VERSION}" "python${PYTHON_MAIN_VERSION}" && \
	ln -s "python${PYTHON_SHORT_VERSION}-config" "python${PYTHON_MAIN_VERSION}-config" &&\
    ln -s "pip${PYTHON_SHORT_VERSION}" "pip${PYTHON_MAIN_VERSION}" && \
	ln -s "idle${PYTHON_MAIN_VERSION}" idle && \
	ln -s "pydoc${PYTHON_MAIN_VERSION}" pydoc && \
	ln -s "python${PYTHON_MAIN_VERSION}" python && \
	ln -s "python${PYTHON_MAIN_VERSION}-config" python-config && \
    ln -s "pip${PYTHON_MAIN_VERSION}" pip && \
    pip install -r /requirements.txt


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
    mkdir -p /hadoop/logs && \
    chown -R hdfs:hadoop /dfs/name && \
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
ENV PYSPARK_PYTHON=/usr/local/bin/python3.8
ENV PYSPARK_DRIVER_PYTHO=/usr/local/bin/python3.8
ENV SPARK_YARN_USER_ENV=/usr/local/bin/python3.8

#EXPOSE 8020 8042 8088 9000 10020 19888 50010 50020 50070 50075 50090
# Hadoop 3.0 changed ports :-(
EXPOSE 8020 8042 8088 9000 9868 9870 10020 19888 50010 50020 50090

CMD ["/entrypoint.sh"]
