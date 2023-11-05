FROM        ubuntu:jammy-20231004
LABEL       Maxence Laude <maxence@laude.pro>

ARG         DEBIAN_FRONTEND=noninteractive
ARG         UEFIExtract_VERSION=A68

RUN         echo 'apt::install-recommends "false";' > /etc/apt/apt.conf.d/no-install-recommends
RUN         apt update && \
            apt install -y git ruby ruby-dev upx-ucl p7zip-full innoextract build-essential unzip curl file && \
            gem install bundler && \
            apt autoremove -y && \
            apt autoclean && \
            apt clean && \
            rm -rf /var/lib/apt/lists/*

RUN         groupadd -g 1000 app \
            && useradd -d /app -s /bin/bash -g app app \
            && chown -R app:app /app

RUN         git clone https://github.com/awilliam/rom-parser && \
            cd rom-parser && \
            make && \
            chmod +x rom-parser && \
            mv rom-parser /usr/local/bin

WORKDIR     /app

USER        app

COPY        --chown=app:app . .

# https://github.com/coderobe/VBiosFinder/issues/50
# https://github.com/coderobe/VBiosFinder/pull/51
RUN         git remote add vkhodygo https://github.com/vkhodygo/VBiosFinder.git && \
            git fetch vkhodygo && \
            git rebase

RUN         mkdir -p /app/.gem && \
            bundle config set --local path '/app/.gem' && \
            bundle install --path=vendor/bundle

ENV         PATH=$PATH:$HOME/.gem/bin

RUN         curl -LO https://github.com/LongSoft/UEFITool/releases/download/A68/UEFIExtract_NE_${UEFIExtract_VERSION}_x64_linux.zip && unzip UEFIExtract_NE_${UEFIExtract_VERSION}_x64_linux.zip && mv uefiextract ./3rdparty/UEFIExtract

RUN         mkdir ./output

ENTRYPOINT  ["./vbiosfinder", "extract"]