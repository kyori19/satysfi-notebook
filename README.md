# satysfi-notebook (experimental)

## Usage

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
sudo pip3 install jupyterlab --break-system-packages
```

Then you can run `jupyter lab` or open GitHub Codespaces using JupyterLab.
