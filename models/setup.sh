#!/usr/bin/env bash
# Download and prepare the Thorsten low German TTS voice for Piper
# This script creates a directory named "thorsten_low" next to itself (if it
# doesn't already exist) and then downloads the ONNX model and its accompanying
# JSON configuration into that directory with canonical names.
#
# Usage:
#   ./setup.sh
#
# Requirements:
#   • curl (or wget – edit the script if you prefer wget)
#   • A working internet connection

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
TARGET_DIR="${SCRIPT_DIR}/thorsten_low"

MODEL_URL="https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/de/de_DE/thorsten/low/de_DE-thorsten-low.onnx?download=true"
CONFIG_URL="https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/de/de_DE/thorsten/low/de_DE-thorsten-low.onnx.json?download=true"

mkdir -p "${TARGET_DIR}"

# Download model if it does not exist or if the file size is unexpectedly small
if [[ ! -s "${TARGET_DIR}/thorsten_low.onnx" ]]; then
  echo "Downloading Thorsten low ONNX model …"
  curl -L "${MODEL_URL}" -o "${TARGET_DIR}/thorsten_low.onnx"
else
  echo "ONNX model already exists – skipping download."
fi

# Download config if it does not exist
if [[ ! -s "${TARGET_DIR}/thorsten_low.onnx.json" ]]; then
  echo "Downloading Thorsten low model config …"
  curl -L "${CONFIG_URL}" -o "${TARGET_DIR}/thorsten_low.onnx.json"
else
  echo "Config JSON already exists – skipping download."
fi

echo "Thorsten low voice is ready in: ${TARGET_DIR}"
