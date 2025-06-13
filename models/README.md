# Piper TTS Voice Models

This directory contains scripts and voice models for the Piper text-to-speech system.

## Quick Start

Download a voice by name:
```bash
./setup.sh amy        # Downloads all qualities of Amy (English)
./setup.sh thorsten   # Downloads all qualities of Thorsten (German/English if available)
./setup.sh lessac     # Downloads all qualities of Lessac (English)
```

## How it Works

The `setup.sh` script:
1. Takes a voice name as an argument
2. Automatically checks for that voice in:
   - German (de_DE)
   - US English (en_US)
   - British English (en_GB)
3. Downloads all available quality levels:
   - x_low (extra low quality, smallest size)
   - low
   - medium
   - high (highest quality, largest size)
4. Organizes files in a structured directory:
   ```
   models/
   ├── thorsten/
   │   ├── de_DE/
   │   │   ├── low/
   │   │   │   ├── thorsten_low.onnx
   │   │   │   └── thorsten_low.onnx.json
   │   │   ├── medium/
   │   │   └── high/
   │   └── en_US/
   │       └── ...
   └── amy/
       └── en_US/
           ├── low/
           └── medium/
   ```

## Available Voices

Check `../VOICES.md` for a complete list of available voices. Popular choices include:

### German Voices
- thorsten (low, medium, high)
- eva_k (x_low)
- karlsson (low)
- kerstin (low)
- ramona (low)

### English Voices (US)
- amy (low, medium)
- lessac (low, medium, high)
- ryan (low, medium, high)
- libritts (high)

### English Voices (GB)
- alan (low, medium)
- cori (medium, high)
- alba (medium)

## Notes

- Not all voices have all quality levels
- Higher quality = better sound but larger file size
- The script will only download what's actually available
- Already downloaded files will not be re-downloaded
