FROM rust:latest AS build-lsp

ARG LSP_VERSION="master"
RUN <<EOF
curl -fsSL https://github.com/monaqa/satysfi-language-server/archive/${LSP_VERSION}.tar.gz | tar xzvf -
mv satysfi-language-server-${LSP_VERSION} satysfi-language-server
cd satysfi-language-server
cargo build --release
EOF

FROM ghcr.io/kyori19/satysfi-notebook/binder AS kernel

FROM kyori/satysfi:latest

RUN <<SCRIPT
sudo apt-get update
sudo apt-get install -y \
  python3-pip

sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

sudo pip3 install --break-system-packages --no-cache-dir \
  jupyterlab \
  jupyterlab-lsp \
  notebook
SCRIPT

RUN <<SCRIPT
opam install -y \
  satysfi-class-slydifi
SCRIPT

COPY --chown=opam:opam satysfi /home/opam/.local/share/jupyter/kernels/satysfi
COPY --chown=opam:opam demo.ipynb /home/opam/

COPY --from=build-lsp /satysfi-language-server/target/release/satysfi-language-server /usr/local/bin/satysfi-language-server
COPY --from=kernel --chown=opam:opam /usr/local/bin/satysfi /home/opam/.local/share/jupyter/kernels/satysfi/satysfi
COPY --from=kernel --chown=opam:opam /home/user/.satysfi/satysfi-library-root.yaml /home/opam/.satysfi/
COPY --from=kernel /usr/local/lib/libsatysfi-jupyter-ext.so /usr/local/lib/

RUN <<SCRIPT
sudo ldconfig
/home/opam/.local/share/jupyter/kernels/satysfi/satysfi solve /home/opam/.local/share/jupyter/kernels/satysfi/workspace.satyw
SCRIPT

WORKDIR /home/opam/
