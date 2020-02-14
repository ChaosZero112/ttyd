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
      curl \
      git \
      vim-common \
      iputils-ping \
      tcptraceroute \
      inetutils-telnet \
      zsh \
      dnsutils \
      lolcat \
      iftop \
      mosh \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

EXPOSE 7681

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["ttyd","zsh"]
