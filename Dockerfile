# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ARG VERSION=2.1.0
#
ENV \
    UBOOQUITY_HOME=/opt/ubooquity \
    UBOOQUITY_VERSION=${VERSION}
#
RUN set -xe \
    && apk add -uU --no-cache \
        curl \
        ca-certificates \
        tzdata \
        unzip \
    && mkdir -p \
        ${UBOOQUITY_HOME}/fonts \
    && curl \
        -o /tmp/ubooquity.zip \
        -jSLN "http://vaemendis.net/ubooquity/downloads/Ubooquity-${VERSION}.zip" \
    && unzip /tmp/ubooquity.zip -d ${UBOOQUITY_HOME} \
    && apk del --purge \
        curl \
        unzip \
        .deps-devel \
    && rm -rf /var/cache/apk/* /tmp/*
#
COPY root/ /
#
VOLUME /config/ /books/ /comics/ /files/
#
EXPOSE 2202 2203
#
HEALTHCHECK \
    --interval=2m \
    --retries=5 \
    --start-period=5m \
    --timeout=10s \
    CMD \
    wget --quiet --tries=1 --no-check-certificate --spider ${HEALTHCHECK_URL:-"http://localhost:2202/ubooquity/"} || exit 1
#
ENTRYPOINT ["/init"]
