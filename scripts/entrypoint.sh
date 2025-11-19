#!/usr/bin/env bash
set -e

export HOME=/home/appuser

sudo chown -R appuser:appuser /app/.vscode 2>/dev/null || true
sudo chmod -R 755 /app/.vscode 2>/dev/null || true

if [ -f /tmp/gitconfig-host ] && [ ! -f "$HOME/.gitconfig" ]; then
    cp /tmp/gitconfig-host "$HOME/.gitconfig"
fi

echo "Container iniciado como $(whoami) (UID: $(id -u))"
echo "Diretório: $(pwd)"

tail -f /dev/null
