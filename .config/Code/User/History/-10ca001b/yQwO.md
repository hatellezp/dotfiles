# Local LLM Platform

[![](https://img.shields.io/badge/View-DOC-blue)](https://signal.pages.multitel.be/nlp/local_llm_poc)

<div align="center">
  <img src="logo.png" alt="Logo" width="200">
  <p><b>Multitool</b></p>
  <p><b>Modular Unified Language Transformer for Information, Tooling, Organization, and Operational Logic</b></p>
</div>

*A self-hosted AI assistant for chat & coding — with multi-user access, interchangeable models, monitoring, and VS Code integration.*

For a global overview of the project and setup, please refer to the [Setup Guide](docs/setup.md).

## Overview

This project (will, should, ...) provides a complete, modular platform for running **local Large Language Models** with:

- **Chat Web UI** (Open WebUI)  
- **Code Assistant for VS Code** (Continue vs code extension)  
- **Monitoring & analytics** (Prometheus + Grafana)  
- **Interchangeable chat + code models**  
- **Multi-user API keys**

Everything runs locally — **no external API**.

## Repository structure

The repository is organized as follows:
```
.
├── docs
├── mkdocs.yml
├── notes
├── poc_files
├── README.md
├── ressources
```

- `docs/`: Documentation source files.
- `mkdocs.yml`: Configuration file for MkDocs, the documentation generator.
- `notes/`: Personal notes and ideas related to the project.
- `poc_files/`: Proof of concept files and experiments. This includes docker compose files, configuration for model serving and web UI setup.
- `ressources/`: Additional resources such as database for custom authentication, ...

## Quick start

This project is currently running as a proof of concept (PoC) on athena3. Both GPUs are used to serve models.
Before doing anything, ensure that you are not on athena3 to avoid restarting services already in use. Please contact Horacio or Bertrand if you want to setup your own instance.

To quickly get started with the Multitool project, follow these steps:
1. Clone the repository
2. Navigate to the `poc_files` directory
3. Copy the `.env.example` file to `.env` and adjust environment variables as needed. In theory, you should simply need to provide your HuggingFace token (if required for specific model downloads such as Llama).
4. Review and adjust the `docker-compose.yaml` file if necessary. Look at the model served and ajust depending on what you have defined in the `.env` file. Be carreful about the GPU used (index).
5. Run `docker compose up -d` to start all services.

The current implementation relies on:
- **vLLM for model serving**. It provides high-troughput and low-latency inference for large language models. Especially it relies on Paged Attention to decrease inference latency.
- **Open WebUI for the chat interface**. It is an open-source web-based user interface for interacting with large language models. If you want to test it and need a user account, please contact Horacio or Bertrand.
- **Docker Compose deployment**.  Everything is containerized using Docker, and Docker Compose is used to orchestrate the different services. It ensures easy setup and management of the entire stack.

## Features

### Multi-Model Support
- Chat model (Llama, Smollm3, DeepSeek)
- Code model (Qwen3Coder)
- Autocomplete model (Qwen2.5Coder)

### OpenAI-Compatible API
- Model serving via vllm with OpenAI API compatibility

### Monitoring
- vllm metrics (GPU usage, latency, throughput)
- Open WebUI telemetry (Grafana LGTM integration)

### VS Code Integration
- Works with Continue extension  
- Inline autocomplete  
- Code chat  
- Code editing assistance

## Access components

Currently, the following ports are used to access the different services. If you encounter any issues, please check the `.env` file and the `docker-compose.yaml` for the exact port configuration. If you still have issues, contact Horacio or Bertrand.

| Service | URL |
|--------|-----|
| Documentation | http://athena3:8081 |
| Web UI | http://athena3:8098 |
| Code Autocomplete Model API | http://athena3:8095 |
| Chat Model API | http://athena3:8096 |
| Code Model API | http://athena3:8097 |


---

## Notes

- [document extraction](./notes/document_extraction.md)

---

## Acknowledgements

- vLLM  
- Open WebUI  
- Continue.dev  
- Prometheus & Grafana  

### Contributors

Dr. Horacio Tellez\
Dr. Bertrand Braeckeveldt