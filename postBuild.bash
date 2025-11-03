#!/bin/bash
# This file contains bash commands that will be executed at the end of the container build process,
# after all system packages and programming language specific package have been installed.
#
# Note: This file may be removed if you don't need to use it

# Exit early on errors
set -euo pipefail

# Get the machine architecture
ARCH=$(uname -m)
PIP_BIN=/opt/conda/bin/pip

cd /workspace
if [[ ! -d diffusers ]]; then
    git clone https://github.com/huggingface/diffusers
fi
cd diffusers
$PIP_BIN install -e .
cd - >/dev/null

TORCH_INDEX_URL=https://download.pytorch.org/whl/cu124
echo "Installing PyTorch 2.5.1 from $TORCH_INDEX_URL for architecture $ARCH"
$PIP_BIN install --upgrade --extra-index-url ${TORCH_INDEX_URL} torch==2.5.1

echo "Aligning huggingface-hub and transformers versions with diffusers requirements"
$PIP_BIN install --upgrade huggingface-hub==0.32.4 transformers==4.49.0

sudo mkdir -p /mnt/cache/
sudo chown $NVWB_UID:$NVWB_GID /mnt/cache/
