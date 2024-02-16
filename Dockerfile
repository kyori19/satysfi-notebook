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

FROM debian:bookworm

COPY sid /etc/apt/preferences.d/sid

RUN <<SCRIPT
sed -i -e 's/bookworm-updates/\0 sid/' /etc/apt/sources.list.d/debian.sources

apt-get update
apt-get install -y \
  libb64-0d \
  libpoppler-cpp0v5 \
  python3-pip \
  sudo
apt-get install -yt unstable libxeus-zmq2

apt-get clean
rm -rf /var/lib/apt/lists/*

pip3 install --break-system-packages --no-cache-dir \
  jupyterlab \
  notebook \
  satysfi_notebook_tweaks
SCRIPT

RUN adduser --disabled-password --gecos '' --uid 1000 user
USER user

COPY --chown=user:user satysfi-slydifi /home/user/.local/share/jupyter/kernels/satysfi-slydifi

RUN <<SCRIPT
sudo apt-get update
sudo apt-get install -y git

git clone https://github.com/kyori19/slydifi.git \
  /home/user/slydifi \
  -b v0.1.0-package --depth 1
git clone https://github.com/pickoba/satysfi-figbox.git \
  /home/user/figbox \
  -b dev-0-1-0-package-system --depth 1

sudo apt-get remove -y git
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
SCRIPT

COPY --from=build /home/opam/.opam/4.14/bin/satysfi /usr/local/bin/
COPY --from=build --chown=user:user /home/opam/satysfi/.satysfi /home/user/.satysfi
COPY --from=build /home/opam/satysfi/libsatysfi-jupyter-ext.so /usr/local/lib/
COPY workspace.satyw /home/user/workspace.satyw

RUN <<SCRIPT
sudo ldconfig
satysfi solve /home/user/workspace.satyw
SCRIPT
