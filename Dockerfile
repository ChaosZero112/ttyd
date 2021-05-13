FROM tsl0922/musl-cross
LABEL maintainer "Shuanglei Tao - tsl0922@gmail.com"

RUN git clone --depth=1 https://github.com/tsl0922/ttyd.git /ttyd \
    && cd /ttyd \
    && ./scripts/cross-build.sh x86_64

FROM ubuntu:20.04
COPY --from=0 /ttyd/build/ttyd /usr/bin/ttyd
COPY optional/py-build-tools.sh /root/py-build-tools.sh

ARG LSD=0.20.1
ARG TINI=0.19.0


RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y -qq -o "Dpkg::Options::=--force-confdef" dist-upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      dnsutils \
      git \
      iftop \
      iputils-ping \
      inetutils-telnet \
      lolcat \
      mosh \
      net-tools \
      screen \
      software-properties-common \
      tar \
      tcptraceroute \
      tmux \
      unzip \
      vim-common \
      zsh \
    && curl -sSL https://github.com/Peltoche/lsd/releases/download/${LSD}/lsd_${LSD}_amd64.deb -o lsd-musl_amd64.deb \
    && dpkg -i lsd-musl_amd64.deb \
    && rm -f lsd-musl_amd64.deb \
    && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | PYENV_ROOT=/root/.pyenv bash \
    && echo 'export PYENV_ROOT="/root/.pyenv"' >> /root/.profile \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.profile \
    && echo 'eval "$(pyenv init --path)"' >> /root/.profile \
    && echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> /root/.bashrc \
    && echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> /root/.zshrc \
    && curl -sSL https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | bash \
    && /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone git://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && sh -c "$(curl -fsSL https://starship.rs/install.sh)" "" -y \
    && sed -i 's/# DISABLE_UPDATE_PROMPT="true"/DISABLE_UPDATE_PROMPT="true"/g' /root/.zshrc \
    && sed -i 's/plugins=(git)/plugins=(colored-man-pages copydir copyfile cp extract git history screen systemd tmux wd zsh-autosuggestions zsh-syntax-highlighting zsh_reload)/g' /root/.zshrc \
    && echo 'EDITOR=nano' >> /root/.zshrc \
    && echo 'eval "$(starship init zsh)"' >> /root/.zshrc \
    #&& curl -sSL https://noto-website-2.storage.googleapis.com/pkgs/Noto-unhinted.zip -o Noto-unhinted.zip \
    #&& unzip Noto-unhinted.zip \
    #&& rm -f Noto-unhinted.zip \
    #&& mkdir -p /usr/share/fonts/opentype/noto \
    #&& mv *otf *otc /usr/share/fonts/opentype/noto \
    && apt-get autoremove --purge -y \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/krallin/tini/releases/download/v${TINI}/tini /sbin/tini
RUN chmod +x /sbin/tini

EXPOSE 7681

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["ttyd","zsh"]
