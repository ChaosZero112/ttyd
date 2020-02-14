FROM tsl0922/musl-cross
LABEL maintainer "Shuanglei Tao - tsl0922@gmail.com"

RUN git clone --depth=1 https://github.com/tsl0922/ttyd.git /ttyd \
    && cd /ttyd \
    && ./scripts/cross-build.sh x86_64

FROM ubuntu:18.04
COPY --from=0 /ttyd/build/ttyd /usr/bin/ttyd

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      cmake \
      curl \
      g++ \
      git \
      libjson-c2 \
      libjson-c-dev \
      libssl1.0.0 \
      libssl-dev \
      libwebsockets7 \
      libwebsockets-dev \
      pkg-config \
      vim-common \
      iputils-ping \
      tcptraceroute \
      inetutils-telnet \
      zsh \
      dnsutils \
      lolcat \
      iftop \
      mosh \
    && /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch \
    && apt-get remove -y --purge \
        cmake \
        g++ \
        libwebsockets-dev \
        libjson-c-dev \
        libssl-dev \
        pkg-config \
    && apt-get purge -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

EXPOSE 7681

ENTRYPOINT ["/tini", "--"]

CMD ["ttyd","zsh"]
