#!/usr/bin/env bash

trap 'echo ""; echo "ERRO NA LINHA $LINENO"; echo "Comando: $BASH_COMMAND"; echo "Código: $?"; echo ""; read -p "Pressione Enter para sair..." dummy; exit 1' ERR
set -euo pipefail

cd /app/frontend

if [ -f "package.json" ]; then
  echo "[init] frontend já existe."
  read -p "Pressione Enter para sair..." dummy
  exit 1
fi

echo "[init] Criando projeto React + TS + Vite..."
echo ""

echo -e "n\nn\n" | npm create vite@latest . -- --template react-ts

echo ""
echo "Projeto Vite criado!"
echo ""
echo "Instalando todas as dependências..."
echo ""

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

echo ""
echo "Frontend criado com sucesso!"
echo ""
echo "Para iniciar o servidor de desenvolvimento:"
echo "   cd /app/frontend"
echo "   npm run dev -- --host 0.0.0.0 --port 5173"
echo ""
read -p "Pressione Enter para sair..." dummy
