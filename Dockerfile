FROM ruby:2.5.3-slim

MAINTAINER Micros <micros@atlassian.com>

COPY .gemrc /root/

# Temporary pin google-protobuf to 3.0.0.alpha.4.0
# There are some concerns on the performance of the latest version
RUN apt-get update -y && apt-get install -yy \
      build-essential \
      zlib1g-dev \
      libjemalloc1 && \
    gem install fluentd:1.3.3 && \
    gem install google-protobuf --pre && \
      fluent-gem install \
      fluent-plugin-ec2-metadata \
      fluent-plugin-hostname \
      fluent-plugin-retag \
      fluent-plugin-kinesis \
      fluent-plugin-elasticsearch \
      fluent-plugin-record-modifier \
      fluent-plugin-multi-format-parser \
      fluent-plugin-kinesis-aggregation \
      fluent-plugin-concat \
      fluent-plugin-parser \
      fluent-plugin-statsd-event && \
      fluent-plugin-grok-parser && \
      fluent-plugin-gelf-hs && \
      fluent-plugin-cloudwatch-logs && \
    apt-get purge -y build-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/log/fluent

# port monitor forward debug
EXPOSE 24220   24224   24230 9292

ENV LD_PRELOAD "/usr/lib/x86_64-linux-gnu/libjemalloc.so.1"
CMD ["fluentd", "-c", "/etc/fluent/fluentd.conf"]
