#!/usr/bin/env bash

echo ""
trap 'echo ""; echo "ERRO NA LINHA $LINENO"; echo "Comando: $BASH_COMMAND"; echo "Código: $?"; echo ""; read -p "Pressione Enter para sair..." dummy; exit 1' ERR
set -euo pipefail

cd /app/frontend

if [ -f "package.json" ]; then
  echo "Frontend já existe."
  read -p "Pressione Enter para sair..." dummy
  exit 1
fi

echo "Criando projeto React + TS + Vite..."

cd /tmp
rm -rf vite-tmp 2>/dev/null || true

yes "n" | npm create vite@latest vite-tmp -- --template react-ts 2>/dev/null || true

if [ ! -f "/tmp/vite-tmp/package.json" ]; then
  echo "Falha ao criar projeto Vite"
  exit 1
fi

if [ -f "/app/frontend/.gitkeep" ]; then
  cp /app/frontend/.gitkeep /tmp/.gitkeep-backup
fi

mv /tmp/vite-tmp/* /app/frontend/
mv /tmp/vite-tmp/.* /app/frontend/ 2>/dev/null || true
rm -rf /tmp/vite-tmp

if [ -f "/tmp/.gitkeep-backup" ]; then
  mv /tmp/.gitkeep-backup /app/frontend/.gitkeep
fi

cd /app/frontend

echo "Projeto Vite criado!"
echo ""
echo "Instalando todas as dependências..."

npm install
npm install -D sass tailwindcss @tailwindcss/vite
npm install bootstrap

echo ""
echo "Todas as dependências instaladas!"
echo ""

echo "Configurando Tailwind CSS..."

cat > tailwind.config.ts << 'EOF'
export default {
    content: ["./src/**/*.{html,js,jsx,ts,tsx}"],
    theme: { extend: {} },
};
EOF

echo "Configurando Vite com Tailwind..."

cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
    plugins: [react(), tailwindcss()],
})
EOF

echo "Configurando estilos globais..."

cat > src/index.css << 'EOF'
@import "tailwindcss";
EOF

cat > src/main.tsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import 'bootstrap/dist/css/bootstrap.min.css'
import './index.css'
import App from './App'

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
    <React.StrictMode>
      <App />
    </React.StrictMode>
)
EOF

echo "Frontend criado com sucesso!"
echo ""
echo "Para iniciar o servidor:"
echo "   cd /app/frontend && npm run dev -- --host 0.0.0.0 --port 5173"
echo ""
read -p "Pressione Enter para sair..." dummy
echo ""
