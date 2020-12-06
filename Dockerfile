FROM alpine:3.12
LABEL maintainer "me@micahrl.com"

ENV HOST_UID=1001
ENV USER_NAME="Your Name Lol"
ENV USER_EMAIL="you@example.com"
ENV TIMEZONE=UTC

VOLUME /home/builder
VOLUME /var/cache/distfiles

# Install packages

# Do this in a separate first step because it's time consuming
RUN true \
    && apk add \
        ca-certificates \
        mandoc man-pages mandoc-apropos \
    && true

# The main build packages
RUN true \
    && apk add \
        alpine-sdk abuild-doc \
        autoconf \
        automake \
        bash \
        bc \
        bison \
        build-base \
        elfutils-dev \
        flex \
        g++ \
        gcc \
        git \
        gmp-dev \
        less \
        libc-dev \
        make \
        musl-dev \
        ncurses-dev \
        openssl-dev \
        perl \
        sed \
        sudo \
    && true

# Kernel related packages
# Might should combine with build packages?
# Wanted to keep separate because unpacking these is a bit time consuming
RUN true \
    && apk add \
        installkernel \
        linux-headers \
        linux-rpi linux-rpi-dev \
        mkinitfs \
    && true

RUN apk add tzdata

# Other configuration

COPY entrypoint.sh /etc/entrypoint.sh

RUN true \
    && chmod 755 /etc/entrypoint.sh \
    && adduser -u $HOST_UID -s /bin/bash -D -H builder \
    && cp /usr/share/zoneinfo/UTC /etc/localtime \
    && touch /etc/abuild.builder.conf \
    && chown builder /etc/abuild.builder.conf /etc/localtime \
    && echo "" >> /etc/abuild.conf \
    && echo ". /etc/abuild.builder.conf" >> /etc/abuild.conf \
    && addgroup builder abuild \
    && mkdir -p /etc/sudoers.d \
    && echo 'builder ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/builder \
    && true

USER builder
WORKDIR /home/builder

CMD /bin/bash -i
ENTRYPOINT /etc/entrypoint.sh
