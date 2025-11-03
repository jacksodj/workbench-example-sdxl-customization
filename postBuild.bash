#!/bin/bash
# This file contains bash commands that will be executed at the end of the container build process,
# after all system packages and programming language specific package have been installed.
#
# Note: This file may be removed if you don't need to use it

# Exit early on errors
set -euo pipefail

# Resolve the Python and pip entrypoints provided by the base image.
PYTHON_BIN=${PYTHON_BIN:-$(command -v python3)}
if [[ -z "${PYTHON_BIN}" ]]; then
    echo "python3 is required but was not found in PATH" >&2
    exit 1
fi

PIP_BIN="${PYTHON_BIN} -m pip"

TORCH_INDEX_URL=https://download.pytorch.org/whl/cu124
echo "Ensuring PyTorch 2.5.1 is installed from $TORCH_INDEX_URL"
${PIP_BIN} install --no-cache-dir --upgrade --extra-index-url "${TORCH_INDEX_URL}" torch==2.5.1

echo "Locking diffusers and Hugging Face tooling to the 2025.10 stack"
${PIP_BIN} install --no-cache-dir --upgrade \
    diffusers==0.35.2 \
    huggingface-hub==0.36.0 \
    transformers==4.57.1

sudo mkdir -p /mnt/cache/
sudo chown $NVWB_UID:$NVWB_GID /mnt/cache/
