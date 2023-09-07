# syntax=docker/dockerfile:1

ARG FLINK_VERSION=1.17.1
ARG JAVA_VERSION=11
ARG APP_DIR

FROM flink:${FLINK_VERSION}-java${JAVA_VERSION}
ARG FLINK_VERSION

COPY . /app

ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip /usr/src/awscli.zip
ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-438.0.0-linux-x86_64.tar.gz /usr/src/google-cloud-cli.tar.gz

RUN apt-get update \
    && apt-get install -y unzip apt-transport-https ca-certificates gnupg curl hping3 kafkacat netcat less \
    && unzip /usr/src/awscli.zip -d /usr/src/ \
    && /usr/src/aws/install \
    && tar -xf /usr/src/google-cloud-cli.tar.gz -C /usr/src/ \
    && /usr/src/google-cloud-sdk/install.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
  $FLINK_HOME/usrlib \
  $FLINK_HOME/tmp \
  $FLINK_HOME/checkpoints \
  $FLINK_HOME/savepoints \
  $FLINK_HOME/plugins/s3-fs-hadoop \
  $FLINK_HOME/plugins/s3-fs-presto

RUN cp -av opt/flink-s3-fs-presto-${FLINK_VERSION}.jar plugins/s3-fs-presto/flink-s3-fs-presto-${FLINK_VERSION}.jar
RUN cp -av opt/flink-s3-fs-hadoop-${FLINK_VERSION}.jar plugins/s3-fs-hadoop/flink-s3-fs-hadoop-${FLINK_VERSION}.jar
