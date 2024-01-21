FROM ocaml/opam:debian-12-ocaml-4.14 AS build

COPY sid /etc/apt/preferences.d/sid

RUN <<SCRIPT
sudo sed -i -e 's/bookworm-updates/\0 sid/' /etc/apt/sources.list.d/debian.sources

sudo apt-get update
sudo apt-get install -y \
  autoconf \
  cmake \
  libb64-dev \
  libpoppler-cpp-dev \
  nlohmann-json3-dev=3.11.2-2 \
  pkg-config
sudo apt-get install -yt unstable xeus-zmq-dev

git clone https://github.com/kyori19/satysfi.git -b workspace --depth 1
cd satysfi

opam repository add satysfi-external https://github.com/gfngfn/satysfi-external-repo.git
opam pin satysfi .

./install-libs.sh .satysfi

cmake jupyter-ext
make
SCRIPT

FROM mcr.microsoft.com/vscode/devcontainers/base:bookworm

COPY sid /etc/apt/preferences.d/sid

RUN <<SCRIPT
sudo sed -i -e 's/bookworm-updates/\0 sid/' /etc/apt/sources.list.d/debian.sources

sudo apt-get update
sudo apt-get install -y \
  libb64-0d \
  libpoppler-cpp0v5
sudo apt-get install -yt unstable libxeus-zmq2

sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
SCRIPT

COPY --from=build /home/opam/.opam/4.14/bin/satysfi /usr/local/bin/
COPY --from=build --chown=vscode:vscode /home/opam/satysfi/.satysfi /home/vscode/.satysfi
COPY --from=build /home/opam/satysfi/libsatysfi-jupyter-ext.so /usr/local/lib/

RUN sudo ldconfig