FROM alpine:3.12
LABEL maintainer "me@micahrl.com"

ENV USER_NAME="Your Name Lol"
ENV USER_EMAIL="you@example.com"
ENV TIMEZONE=UTC

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

# Some quality of life improvements
RUN true \
    && apk add \
        ripgrep \
        tzdata \
        vim \
    && true

# Other configuration

COPY prompt.sh /etc/profile.d/prompt.sh
COPY entrypoint.sh /etc/entrypoint.sh
COPY logcmd.sh /usr/local/bin/logcmd.sh

ARG HOST_UID=1001
RUN adduser -u $HOST_UID -s /bin/bash -D builder

# To make sure volume dirs have the right permissions whether theye're mounted or not, you have to do this.
RUN chown -R builder /home/builder /var/cache/distfiles
VOLUME /home/builder
VOLUME /var/cache/distfiles
RUN chown -R builder /home/builder /var/cache/distfiles

RUN true \
    && chmod 755 /etc/entrypoint.sh /usr/local/bin/logcmd.sh /etc/profile.d/prompt.sh \
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
