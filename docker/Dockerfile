FROM rust:latest AS build-lsp

ARG LSP_VERSION="master"
RUN <<EOF
curl -fsSL https://github.com/monaqa/satysfi-language-server/archive/${LSP_VERSION}.tar.gz | tar xzvf -
mv satysfi-language-server-${LSP_VERSION} satysfi-language-server
cd satysfi-language-server
cargo build --release
EOF

FROM kyori/satysfi:latest

RUN <<SCRIPT
sudo apt-get update
sudo apt-get install -y \
  python3-pip

sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

sudo pip3 install --break-system-packages --no-cache-dir \
  jupyterlab \
  notebook
SCRIPT

RUN <<SCRIPT
opam install -y \
  satysfi-class-slydifi
SCRIPT

COPY --chown=user:user demo.ipynb /home/user/

COPY --from=build-lsp /satysfi-language-server/target/release/satysfi-language-server /usr/local/bin/satysfi-language-server

WORKDIR /home/user/
