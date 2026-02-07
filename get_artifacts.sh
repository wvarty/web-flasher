#!/bin/bash
set -e

# TitanLRS Configuration
GITHUB_REPO="wvarty/TitanLRS"
GITHUB_BACKPACK_REPO="wvarty/TitanLRS-Backpack"

# Version to download (required; pass as argument)
VERSION="${1:?Usage: ./get_artifacts.sh <firmware-version> [backpack-version]}"
# Backpack version can be different from main firmware
BACKPACK_VERSION="${2:-${VERSION}}"

# Directories
ASSETS_DIR="public/assets"
FIRMWARE_DIR="${ASSETS_DIR}/firmware"

echo "================================================"
echo "  TitanLRS Firmware Downloader"
echo "================================================"
echo "Repository: ${GITHUB_REPO}"
echo "Version: ${VERSION}"
echo "Backpack Version: ${BACKPACK_VERSION}"
echo ""

# Create directory structure
mkdir -p "${ASSETS_DIR}"
cd "${ASSETS_DIR}"

# Remove old firmware files
echo "🧹 Cleaning old firmware..."
rm -rf firmware backpack

# Create firmware directory structure
mkdir -p firmware
cd firmware

# Construct GitHub Release URL
FIRMWARE_URL="https://github.com/${GITHUB_REPO}/releases/download/v${VERSION}/firmware-${VERSION}.zip"

echo "📥 Downloading TitanLRS firmware..."
echo "URL: ${FIRMWARE_URL}"
echo ""

# Download firmware
curl -L -f "${FIRMWARE_URL}" -o firmware.zip || {
  echo ""
  echo "❌ Error: Failed to download firmware version ${VERSION}"
  echo ""
  echo "Troubleshooting:"
  echo "1. Check version exists at: https://github.com/${GITHUB_REPO}/releases"
  echo "2. Verify version format (e.g., '4.0.0-TD' not 'v4.0.0-TD')"
  echo "3. Ensure release is published (not draft)"
  echo ""
  exit 1
}

# Extract firmware into version-specific directory
echo "📦 Extracting firmware..."
mkdir -p "${VERSION}"
cd "${VERSION}"
unzip -q ../firmware.zip

# Handle nested firmware directory if it exists
if [ -d "firmware-${VERSION}" ]; then
  echo "Moving firmware-${VERSION} contents..."
  shopt -s dotglob 2>/dev/null || true  # Enable hidden files in bash
  mv firmware-${VERSION}/* . 2>/dev/null || cp -r firmware-${VERSION}/* . && rm -rf firmware-${VERSION}
elif [ -d "firmware" ]; then
  echo "Moving firmware contents..."
  shopt -s dotglob 2>/dev/null || true
  mv firmware/* . 2>/dev/null || cp -r firmware/* . && rm -rf firmware
fi

cd ..
rm firmware.zip

# Download hardware definitions from master branch
echo "📥 Downloading hardware definitions..."
mkdir -p hardware
cd hardware
HARDWARE_URL="https://raw.githubusercontent.com/${GITHUB_REPO}/master/src/hardware/targets.json"
curl -L -f "${HARDWARE_URL}" -o targets.json || {
  echo "⚠️  Warning: Could not download targets.json from master branch"
  echo "Using targets.json from firmware archive if available..."
  if [ -f "../${VERSION}/hardware/targets.json" ]; then
    cp "../${VERSION}/hardware/targets.json" .
    echo "✓ Using targets.json from firmware ${VERSION}"
  else
    echo "❌ Error: No targets.json found"
    exit 1
  fi
}

cd ..

# Create index.json for the web flasher to discover versions
echo "📝 Creating index.json..."
cat > index.json << EOF
{
  "tags": {
    "${VERSION}": "${VERSION}"
  },
  "branches": {}
}
EOF

cd ..

# Download TitanLRS Backpack firmware
echo ""
echo "📥 Downloading TitanLRS Backpack firmware..."
BACKPACK_URL="https://github.com/${GITHUB_BACKPACK_REPO}/releases/download/v${BACKPACK_VERSION}/backpack-${BACKPACK_VERSION}.zip"
echo "URL: ${BACKPACK_URL}"

mkdir -p backpack
cd backpack

curl -L -f "${BACKPACK_URL}" -o backpack.zip && {
  echo "📦 Extracting backpack firmware..."

  # Create version-specific directory
  mkdir -p "${BACKPACK_VERSION}"
  cd "${BACKPACK_VERSION}"
  unzip -q ../backpack.zip

  # Handle nested backpack directory if it exists
  if [ -d "backpack-${BACKPACK_VERSION}" ]; then
    echo "Moving backpack-${BACKPACK_VERSION} contents..."
    shopt -s dotglob 2>/dev/null || true  # Enable hidden files in bash
    mv backpack-${BACKPACK_VERSION}/* . 2>/dev/null || cp -r backpack-${BACKPACK_VERSION}/* . && rm -rf backpack-${BACKPACK_VERSION}
  elif [ -d "backpack" ]; then
    echo "Moving backpack contents..."
    shopt -s dotglob 2>/dev/null || true
    mv backpack/* . 2>/dev/null || cp -r backpack/* . && rm -rf backpack
  fi

  cd ..
  rm backpack.zip

  # Create backpack index.json with the downloaded version
  cat > index.json << EOF
{
  "tags": {
    "${BACKPACK_VERSION}": "${BACKPACK_VERSION}"
  },
  "branches": {}
}
EOF

  echo "✅ Backpack firmware downloaded successfully!"

} || {
  echo "⚠️  Warning: Backpack firmware not available for version ${BACKPACK_VERSION}"
  echo "   This is normal if backpack hasn't been released yet."
  echo "   Continuing without backpack firmware..."

  # Create empty backpack structure as fallback
  cat > index.json << EOF
{
  "tags": {},
  "branches": {}
}
EOF
}

cd ..

echo ""
echo "✅ Firmware ${VERSION} downloaded successfully!"
echo "📂 Location: ${FIRMWARE_DIR}/"
echo ""

# Show directory structure
echo "Directory structure:"
if [ -d "${FIRMWARE_DIR}/${VERSION}" ]; then
  echo "firmware/"
  echo "├── ${VERSION}/"
  ls "${FIRMWARE_DIR}/${VERSION}" | head -10 | sed 's/^/│   ├── /'
  echo "├── hardware/"
  echo "│   └── targets.json"

  if [ -d "backpack/${BACKPACK_VERSION}" ]; then
    echo "└── backpack/"
    echo "    └── ${BACKPACK_VERSION}/"
    ls "backpack/${BACKPACK_VERSION}" | head -10 | sed 's/^/        ├── /'
  fi
fi

echo ""
echo "================================================"
echo "Ready for development!"
echo "Run: npm run dev"
echo "================================================"
