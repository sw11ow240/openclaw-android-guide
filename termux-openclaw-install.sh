#!/data/data/com.termux/files/usr/bin/bash
# OpenClaw (Clawdbot) Termux Installation Script
# https://github.com/sw11ow240/openclaw-android-guide

set -e

echo "🚀 OpenClaw Termux Setup Script"
echo "================================"
echo ""

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo "❌ Error: This script must be run in Termux"
    exit 1
fi

# Step 1: Update packages
echo "📦 Step 1: Updating packages..."
pkg update -y
pkg upgrade -y

# Step 2: Install Node.js and Git
echo "📦 Step 2: Installing Node.js and Git..."
pkg install -y nodejs-lts git

# Step 3: Install Clawdbot
echo "📦 Step 3: Installing Clawdbot..."
npm install -g clawdbot

# Step 4: Apply Android patch for clipboard module
echo "🔧 Step 4: Applying Android compatibility patch..."
CLIPBOARD_PATH="/data/data/com.termux/files/usr/lib/node_modules/clawdbot/node_modules/@mariozechner/clipboard/index.js"

if [ -f "$CLIPBOARD_PATH" ]; then
    cat > "$CLIPBOARD_PATH" << 'PATCH'
/* Dummy clipboard module for Android/Termux */
const noop = () => {}
const noopBool = () => false
const noopArr = () => []
const noopStr = () => ''
module.exports.availableFormats = noopArr
module.exports.getText = noopStr
module.exports.setText = noop
module.exports.hasText = noopBool
module.exports.getImageBinary = () => null
module.exports.getImageBase64 = noopStr
module.exports.setImageBinary = noop
module.exports.setImageBase64 = noop
module.exports.hasImage = noopBool
module.exports.getHtml = noopStr
module.exports.setHtml = noop
module.exports.hasHtml = noopBool
module.exports.getRtf = noopStr
module.exports.setRtf = noop
module.exports.hasRtf = noopBool
module.exports.clear = noop
module.exports.watch = noop
module.exports.callThreadsafeFunction = noop
PATCH
    echo "✅ Clipboard patch applied"
else
    echo "⚠️ Warning: Clipboard module not found, skipping patch"
fi

# Step 5: Create workspace
echo "📁 Step 5: Creating workspace..."
mkdir -p ~/openclaw
cd ~/openclaw

# Step 6: Run setup
echo "⚙️ Step 6: Running clawdbot setup..."
clawdbot setup || true

echo ""
echo "================================"
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Edit ~/.clawdbot/clawdbot.json to add your API key"
echo "2. Run: cd ~/openclaw && clawdbot gateway"
echo ""
echo "Optional: Install Termux:API for camera/mic access"
echo "  - Download from F-Droid: https://f-droid.org/packages/com.termux.api/"
echo "  - Then run: pkg install termux-api"
echo ""
echo "📖 Full guide: https://github.com/sw11ow240/openclaw-android-guide"
echo "================================"
