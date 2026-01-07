### Run Flask
```
cd backend/
python3 app.py
```

### Run Vite
```
cd frontend/
npm run dev -- --host 0.0.0.0 --port 5173
```

### Permissão Arquivo .vsocde

```
docker exec -it -u root <container_name> chown appuser:appuser /app/.vscode
```
