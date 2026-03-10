# SPARK
> DGX Spark scratchpad: setup/run notes before promotion to the main docs site.

## __Repository Structure:__
- [`ops/`](ops/) — host baselines, debugging snippets, automation TODOs
- [`nvfp4/`](nvfp4/) — NVFP4 runtime bring-up, model catalog, web UI, sizing notes
- [`models/`](models/) — model acquisition and simple query tests
- [`ollama/`](ollama/) — Ollama helpers and WebUI docker flow
- [`comfyui/`](comfyui/) — ComfyUI setup
- [`prompts/`](prompts/) — prompts, demos, AppleScripts
- [`logs/`](logs/) — raw logs and metrics helper
- [`multi/`](multi/) — dual-DGX pairing for `<SPARK_ONE>` and `<SPARK_TWO>`
- [`archive/`](archive/) — scratch/old snapshots pending curation

## __URL Paths:__
- [devs.guide/to/nvidia/dgx/spark/](./)

## Table of Contents
1. [Overview](#overview)
2. [Guides](#guides)
   - [Setup & Ops](#setup--ops)
   - [Multi-Host](#multi-host)
   - [NVFP4 Workflows](#nvfp4-workflows)
   - [Models & Downloads](#models--downloads)
   - [Tools & UI](#tools--ui)
   - [Prompts & Demos](#prompts--demos)
   - [Logs & Metrics](#logs--metrics)

---

## Overview
Runbooks for bringing up DGX Spark, validating networking/storage, and iterating on NVFP4/LLM workflows with supporting scripts, prompts, and logs.

---

## Guides

### Setup & Ops
- Baselines, debug notes, automation TODOs: [`ops/readme.md`](ops/readme.md)

### Multi-Host
- Dual-DGX pairing, networking, and NCCL validation: [`multi/readme.md`](multi/readme.md)

### NVFP4 Workflows
- Runtime bring-up and configs: [`nvfp4/runtime.md`](nvfp4/runtime.md), [`nvfp4/load.model.md`](nvfp4/load.model.md)
- Model layouts and variants: [`nvfp4/models.md`](nvfp4/models.md), [`nvfp4/rag.models.md`](nvfp4/rag.models.md), [`nvfp4/model.notes.md`](nvfp4/model.notes.md)
- Web UI and end-to-end guide: [`nvfp4/webui.md`](nvfp4/webui.md), [`nvfp4/readme.md`](nvfp4/readme.md)

### Models & Downloads
- HF downloads and data pulls: [`models/hugging.face.download.md`](models/hugging.face.download.md)
- Simple queries/tests: [`models/query.model.md`](models/query.model.md)

### Tools & UI
- Ollama helpers and web UI: [`ollama/ollama.py`](ollama/ollama.py), [`ollama/ollama.webgui.docker.md`](ollama/ollama.webgui.docker.md)
- Additional UI setup: [`comfyui/setup.comfyui.md`](comfyui/setup.comfyui.md)

### Prompts & Demos
- Prompt snippets and macOS helpers: [`prompts/prompt.txt`](prompts/prompt.txt), [`prompts/prompt.applescript.txt`](prompts/prompt.applescript.txt), [`prompts/macOS.prompt.query.md`](prompts/macOS.prompt.query.md)
- Game/demo prompts: [`prompts/tic.tac.toe.prompt`](prompts/tic.tac.toe.prompt), [`prompts/tic.tac.toe.applescript`](prompts/tic.tac.toe.applescript), [`prompts/openai.tic.tac.toe.applescript`](prompts/openai.tic.tac.toe.applescript)
- Additional logs/examples: [`logs/log.qwq:32b.Q8.txt`](logs/log.qwq:32b.Q8.txt)

### Logs & Metrics
- Session logs and quick metrics runner: [`logs/log.txt`](logs/log.txt), [`ops/metrics.sh`](ops/metrics.sh)
