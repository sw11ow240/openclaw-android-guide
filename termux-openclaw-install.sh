#!/data/data/com.termux/files/usr/bin/bash
# OpenClaw (Clawdbot) Termux Installation Script
# https://github.com/sw11ow240/openclaw-android-guide
# Based on DroidClaw patches: https://github.com/nexty5870/DroidClaw

set -e

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           🦞 OpenClaw Termux Setup                        ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo "❌ Error: This script must be run in Termux"
    exit 1
fi

# Step 1: Update packages
echo "[1/8] Updating packages..."
pkg update -y
pkg upgrade -y
echo "  ✓ Done"

# Step 2: Install Node.js and Git
echo "[2/8] Installing Node.js and Git..."
pkg install -y nodejs-lts git
echo "  ✓ Done"

# Step 3: Install Clawdbot
echo "[3/8] Installing Clawdbot..."
npm install -g clawdbot
echo "  ✓ Done"

# Step 4: Create directories
echo "[4/8] Creating directories..."
mkdir -p ~/.clawdbot/tmp
mkdir -p ~/.clawdbot/logs
mkdir -p ~/openclaw
echo "  ✓ Done"

# Step 5: Set TMPDIR environment
echo "[5/8] Setting TMPDIR environment..."
grep -v 'TMPDIR.*clawdbot' ~/.bashrc > ~/.bashrc.tmp 2>/dev/null || touch ~/.bashrc.tmp
mv ~/.bashrc.tmp ~/.bashrc
echo 'export TMPDIR="$HOME/.clawdbot/tmp"' >> ~/.bashrc
export TMPDIR="$HOME/.clawdbot/tmp"
echo "  ✓ Done"

# Step 6: Create clipboard stub
echo "[6/8] Creating clipboard stub..."
CLIPBOARD_STUB="$PREFIX/lib/node_modules/@mariozechner/clipboard-android-arm64"
mkdir -p "$CLIPBOARD_STUB"

cat > "$CLIPBOARD_STUB/package.json" << 'EOF'
{
  "name": "@mariozechner/clipboard-android-arm64",
  "version": "0.3.2",
  "main": "index.js"
}
EOF

cat > "$CLIPBOARD_STUB/index.js" << 'EOF'
module.exports = {
  getText: async () => "",
  setText: async () => {},
  getHtml: async () => "",
  setHtml: async () => {},
  hasImage: async () => false,
  getImageBase64: async () => "",
  setImageBase64: async () => {},
  getRtf: async () => "",
  clear: async () => {},
  availableFormats: async () => []
};
EOF
echo "  ✓ Done"

# Step 7: Patch hardcoded /tmp paths
echo "[7/8] Patching /tmp paths..."
find $PREFIX/lib/node_modules/clawdbot/dist -name "*.js" -exec grep -l "/tmp/clawdbot" {} \; 2>/dev/null | while read f; do
    sed -i "s|/tmp/clawdbot|$HOME/.clawdbot/tmp|g" "$f"
    echo "  ✓ Patched: $(basename $f)"
done
echo "  ✓ Done"

# Step 8: Create claw wrapper
echo "[8/8] Creating claw wrapper..."
cat > $PREFIX/bin/claw << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
export TMPDIR="$HOME/.clawdbot/tmp"
export NODE_OPTIONS="--max-old-space-size=512"
exec clawdbot "$@"
EOF
chmod +x $PREFIX/bin/claw
echo "  ✓ Done"

# Run setup
echo ""
echo "Running clawdbot setup..."
cd ~/openclaw
clawdbot setup || true

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  ✅ Installation complete!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "IMPORTANT: Start a new terminal session, or run:"
echo "  source ~/.bashrc"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.clawdbot/clawdbot.json to add your API key"
echo "  2. Run: claw gateway"
echo ""
echo "Optional: Install Termux:API for camera/mic access"
echo "  - Download from F-Droid: https://f-droid.org/packages/com.termux.api/"
echo "  - Then run: pkg install termux-api"
echo ""
echo "📖 Full guide: https://github.com/sw11ow240/openclaw-android-guide"
echo "════════════════════════════════════════════════════════════"
