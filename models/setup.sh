#!/usr/bin/env bash
# Download and prepare Piper TTS voices
# This script downloads voices by name, automatically fetching all available
# qualities for both German and English languages.
#
# Usage:
#   ./setup.sh <voice_name>
#   ./setup.sh thorsten
#   ./setup.sh amy
#
# Requirements:
#   • curl (or wget – edit the script if you prefer wget)
#   • A working internet connection

set -euo pipefail

# Check if voice name was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <voice_name>"
    echo "Example: $0 thorsten"
    echo "Example: $0 amy"
    exit 1
fi

VOICE_NAME="$1"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BASE_URL="https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0"

# Define language codes to check
LANGUAGES=(
    "de:de_DE"
    "en:en_US"
    "en:en_GB"
)

# Define qualities to try
QUALITIES=(
    "x_low"
    "low"
    "medium"
    "high"
)

# Function to download a voice
download_voice() {
    local lang_short="$1"
    local lang_code="$2"
    local voice="$3"
    local quality="$4"
    
    local model_url="${BASE_URL}/${lang_short}/${lang_code}/${voice}/${quality}/${lang_code}-${voice}-${quality}.onnx?download=true"
    local config_url="${BASE_URL}/${lang_short}/${lang_code}/${voice}/${quality}/${lang_code}-${voice}-${quality}.onnx.json?download=true"
    
    local target_dir="${SCRIPT_DIR}/${voice}/${lang_code}/${quality}"
    local model_file="${target_dir}/${voice}_${quality}.onnx"
    local config_file="${target_dir}/${voice}_${quality}.onnx.json"
    
    # Create temporary files to test download
    local temp_model=$(mktemp)
    local temp_config=$(mktemp)
    
    # Try to download model
    echo "Trying ${lang_code} ${voice} ${quality}..."
    if curl -f -L "${model_url}" -o "${temp_model}" 2>/dev/null; then
        # Try to download config
        if curl -f -L "${config_url}" -o "${temp_config}" 2>/dev/null; then
            # Both downloads successful, now create directory and move files
            mkdir -p "${target_dir}"
            mv "${temp_model}" "${model_file}"
            mv "${temp_config}" "${config_file}"
            echo "✓ Downloaded ${lang_code} ${voice} ${quality}"
            return 0
        else
            echo "✗ Config not available for ${lang_code} ${voice} ${quality}"
            rm -f "${temp_model}" "${temp_config}"
            return 1
        fi
    else
        rm -f "${temp_model}" "${temp_config}"
        return 1
    fi
}

# Main download loop
echo "Downloading all available qualities for voice: ${VOICE_NAME}"
echo "Checking German and English languages..."
echo

found_any=false

for lang_pair in "${LANGUAGES[@]}"; do
    IFS=':' read -r lang_short lang_code <<< "${lang_pair}"
    
    for quality in "${QUALITIES[@]}"; do
        if download_voice "${lang_short}" "${lang_code}" "${VOICE_NAME}" "${quality}"; then
            found_any=true
        fi
    done
done

echo
if [ "${found_any}" = true ]; then
    echo "✓ Successfully downloaded voice(s) for: ${VOICE_NAME}"
    echo "Files are located in: ${SCRIPT_DIR}/${VOICE_NAME}/"
else
    echo "✗ No voices found for: ${VOICE_NAME}"
    echo "Please check the voice name and try again."
    exit 1
fi
