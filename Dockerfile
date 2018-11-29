FROM phusion/baseimage:0.11
LABEL maintainer "Shuanglei Tao - tsl0922@gmail.com"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      cmake \
      curl \
      g++ \
      git \
      libjson-c3 \
      libjson-c-dev \
      libssl1.0.0 \
      libssl-dev \
      libwebsockets8 \
      libwebsockets-dev \
      pkg-config \
      vim-common \
      iputils-ping \
      tcptraceroute \
      inetutils-telnet \
      zsh \
      iptables \
    && git clone --depth=1 https://github.com/tsl0922/ttyd.git /tmp/ttyd \
    && cd /tmp/ttyd && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE .. \
    && make \
    && make install \
    && apt-get remove -y --purge \
        cmake \
        g++ \
        libwebsockets-dev \
        libjson-c-dev \
        libssl-dev \
        pkg-config \
    && apt-get purge -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/ttyd \
    && mkdir -p /etc/my_init.d \
    && touch /etc/my_init.d/iptables.sh \
    && chmod +x /etc/my_init.d/iptables.sh \
    && echo "#!/bin/sh" >> /etc/my_init.d/iptables.sh \
    && "iptables -I INPUT -s 127.0.0.1 -j ACCEPT" >> /etc/my_init.d/iptables.sh \
    && "iptables -I INPUT -s 155.64.138.0/21 -j ACCEPT" >> /etc/my_init.d/iptables.sh \
    && "iptables -I INPUT -s 155.64.32.0/21 -j ACCEPT" >> /etc/my_init.d/iptables.sh \
    && "iptables -I INPUT -s 174.117.48.21 -j ACCEPT" >> /etc/my_init.d/iptables.sh \
    && "iptables -I INPUT -s 23.95.225.160 -j ACCEPT" >> /etc/my_init.d/iptables.sh \
    && "iptables -I INPUT -s 10.0.0.0/24 -j ACCEPT" >> /etc/my_init.d/iptables.sh \
    && "iptables -P INPUT DROP" >> /etc/my_init.d/iptables.sh \
    && "exit 0" >> /etc/my_init.d/iptables.sh \
    && wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true 

EXPOSE 7681

ENTRYPOINT ["ttyd"]

CMD ["bash"]
