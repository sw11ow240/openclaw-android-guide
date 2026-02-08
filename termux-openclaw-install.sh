#!/data/data/com.termux/files/usr/bin/bash
# OpenClaw Termux One-Line Installer
# Usage: curl -sL https://example.com/termux-openclaw-install.sh | bash
#
# 注意: 実行前に必ずスクリプトの中身を確認してください

set -euo pipefail

echo "OpenClaw Termux Installer"
echo "========================="
echo ""

# Termux環境チェック
if ! command -v pkg >/dev/null 2>&1; then
    echo "[エラー] このスクリプトはTermux環境で実行してください。"
    echo "Termuxは F-Droid からインストールできます："
    echo "  https://f-droid.org/packages/com.termux/"
    exit 1
fi

# 追加チェック: Termuxのprefixを確認
if [[ ! -d "/data/data/com.termux/files/usr" ]]; then
    echo "[警告] Termux環境ではない可能性があります。続行しますか？ (y/N)"
    read -r confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "中断しました。"
        exit 1
    fi
fi

# Update packages
echo "[1/4] パッケージを更新しています..."
pkg update -y && pkg upgrade -y

# Install dependencies
echo "[2/4] Node.js と Git をインストールしています..."
pkg install -y nodejs-lts git

# Install OpenClaw
echo "[3/4] Clawdbot（OpenClaw）をインストールしています..."
npm install -g clawdbot

# Create workspace directory
echo "[4/4] 作業ディレクトリを作成しています..."
mkdir -p ~/openclaw

echo ""
echo "========================================"
echo "インストール完了"
echo "========================================"
echo ""
echo "次のステップ:"
echo "  1. cd ~/openclaw"
echo "  2. clawdbot init    # APIキーを設定"
echo "  3. clawdbot gateway start"
echo ""
echo "便利な追加設定:"
echo "  - Termux:API をインストール → カメラ・マイクが使えます"
echo "  - Termux:Boot をインストール → 自動起動が可能になります"
echo "  - バッテリー最適化から除外 → バックグラウンドで安定動作します"
echo ""
echo "詳細は公式ドキュメントをご覧ください: https://docs.clawd.bot"
