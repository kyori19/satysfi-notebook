# SATySFi Notebook

## Usage

### On Binder

> [!WARNING]
>
> Any changes made on Binder will not be persisted.
> You should try other options below if you want to write something.

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/kyori19/satysfi-notebook/binder?urlpath=lab)

### On VSCode or GitHub Codespaces

Create `.devcontainer.json` with following content and start/recreate DevContainer:

```json
{
  "image": "ghcr.io/kyori19/devcontainers/images/satysfi-notebook",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-toolsai.jupyter"
      ]
    }
  }
}
```

Opening any `.ipynb` file will automatically starts SATySFi Notebook environment.

### On JupyterLab

You have to create DevContainer once using VSCode (or DevContainer CLI).
In the container, run:

```sh
sudo apt update
sudo apt install python3-pip
sudo pip3 install jupyterlab satysfi_notebook_tweaks --break-system-packages
```

Then you can run `jupyter lab` or open GitHub Codespaces using JupyterLab.
