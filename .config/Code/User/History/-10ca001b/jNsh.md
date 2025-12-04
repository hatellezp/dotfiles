# Local LLM Platform  

*A self-hosted AI assistant for chat & coding — with multi-user access, interchangeable models, monitoring, and VS Code integration.*

---

## Overview

This project (will, should, ...) provides a complete, modular platform for running **local Large Language Models** with:

- **Chat Web UI** (Open WebUI)  
- **Code Assistant for VS Code** (Continue extension)  
- **Interchangeable chat + code models**  
- **Multi-user API keys**  
- **Monitoring & analytics** (Prometheus + Grafana)  
- **vLLM for high-throughput inference**  
- **Secure API gateway**  
- **Docker Compose deployment**

Everything runs locally — **no external API**.

---

## Features

### Multi-Model Support
- Chat model (Llama, Qwen, etc.)
- Code model (DeepSeek-Coder, StarCoder2)
- Hot‑swap via model registry

### Multi-User API Keys
- Key generation  
- Key hashing  
- Per-user usage logs  
- Optional token quotas  

### API Gateway (OpenAI-Compatible)
- `/v1/chat/completions`  
- Model routing  
- Authentication  
- Logging  
- Rate limiting  

### Monitoring
- Prometheus  
- Grafana dashboards  
- vLLM metrics  
- GPU metrics (DCGM exporter)  
- Gateway metrics  

### VS Code Integration
- Works with Continue extension  
- Inline autocomplete  
- Code chat  
- Model-specific routing  

---

## Architecture

```
Browser (Open WebUI)
        │
        ▼
   API Gateway ──────── VS Code (Continue)
        │
   ┌───────────────┐
   │ Model Router  │
   └─────┬─────┬───┘
         │     │
         ▼     ▼
  vLLM Chat   vLLM Code

Monitoring:
Prometheus ─ Grafana ─ Exporters
```

---

## Repository Structure

```
.
├── docker-compose.yml
├── gateway/
│   ├── Dockerfile
│   └── gateway_main.py
├── db/
│   └── db_schema.sql
├── monitoring/
│   ├── prometheus.yml
│   └── grafana/
└── docs/
    ├── roadmap.md
    └── system_blueprint.md
```

---

## Quick Start (MVP)

### 1. Install Ollama
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

### 2. Pull Models
```bash
ollama pull llama3.1:8b-instruct
ollama pull deepseek-coder:6.7b-instruct
```

### 3. Run Open WebUI
```bash
docker run -d -p 3000:8080   -e OLLAMA_BASE_URL=http://host.docker.internal:11434   ghcr.io/open-webui/open-webui:latest
```

### 4. VS Code Setup
Use the **Continue** extension and configure:
```
Provider: OpenAI-Compatible
Base URL: http://<some address>:<some port>/v1
Model: deepseek-coder
```

---

## Production Deployment

### 1. Clone Repo
```bash
git clone <your-gitlab-url>
cd <repo>
```

### 2. Start Full Stack
```bash
docker compose up -d
```

### 3. Access Components

| Service | URL |
|--------|-----|
| Web UI | http://localhost:3000 |
| Gateway | http://localhost:8000/v1 |
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3001 |

---

## API Keys

Generate a key:
```sql
INSERT INTO api_keys (id, user_id, key_hash)
VALUES (gen_random_uuid(), '<USER_ID>', sha256('<RAW_KEY>'));
```

Use in requests:
```
Authorization: Bearer <RAW_KEY>
```

---

## Monitoring

Includes:
- Token usage  
- Per-user usage  
- GPU/CPU/RAM  
- Latency  
- Bandwidth  

Dashboards provided for Grafana.

---

## Development Workflow

- Use feature branches  
- PR review in GitLab  
- Gateway code in `/gateway`  
- DB migrations in `/db`  
- Monitoring configs in `/monitoring`  

---

## Contributions

Merge requests welcome.  
Follow:
- Black formatting  
- Pydantic conventions  
- Conventional commits  

---

## License

MIT License.

---

## Acknowledgements

- vLLM  
- Open WebUI  
- Continue.dev  
- FastAPI  
- Prometheus & Grafana  
