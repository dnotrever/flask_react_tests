#!/usr/bin/env bash

trap 'echo ""; echo "ERRO NA LINHA $LINENO"; echo "Comando: $BASH_COMMAND"; echo "Código: $?"; echo ""; read -p "Pressione Enter para sair..." dummy; exit 1' ERR
set -euo pipefail

cd /app/backend

if [ -f "app.py" ]; then
  echo "[init] O arquivo app.py já existe no backend."
  read -p "Pressione Enter para sair..." dummy
  exit 1
fi

echo "[init] Criando app.py do backend Flask..."
echo ""

cat > app.py << 'EOF'
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
  return jsonify({'message': 'Sucesso! API Flask está funcionando.'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
EOF

echo ""
echo "Backend criado com sucesso!"
echo ""
echo "Para iniciar o servidor Flask:"
echo "   cd /app/backend"
echo "   python3 app.py"
echo ""
read -p "Pressione Enter para sair..." dummy
