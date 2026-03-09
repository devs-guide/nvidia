# DGX Spark NVFP4 + TensorRT-LLM + Open WebUI Setup Guide

This guide outlines the setup process for running Open WebUI with TensorRT-LLM on a DGX Spark node, with a macOS client for access. It covers initial setup, port configuration, and troubleshooting tips based on common issues.

## Related Docs
- [`nvfp4/runtime.md`](../nvfp4/runtime.md) — serve commands and runtime flags
- [`nvfp4/load.model.md`](../nvfp4/load.model.md) — load/start flow with env vars and docker run
- [`nvfp4/models.md`](../nvfp4/models.md) — model catalog and minimum memory footprints
- [`nvfp4/model.notes.md`](../nvfp4/model.notes.md) — quantization and VRAM fit notes
- [`nvfp4/rag.models.md`](../nvfp4/rag.models.md) — RAG endpoints and sample queries
- [`nvfp4/webui.md`](../nvfp4/webui.md) — WebUI setup and SSH tunneling

## Prerequisites

-   **Spark User:** `nvidia` (or your chosen Spark user)
-   **Model:** Model files (e.g., `nvidia-llama4-scout-17b-16e-nvfp4`) already downloaded to the Spark server, typically in a directory like `~/gpt/nvfp4/nvidia-llama4-scout-17b-16e-nvfp4`.
-   **Optional Config:**  An optional configuration YAML file, such as `~/gpt/nvfp4/config/llama4-scout-spark.yaml`.
-   **Spark LAN IP:** Replace the example IP address (e.g., `<SPARK_LAN_IP>`) with the correct IP address of your Spark node.

## Port Expectations

-   **Open WebUI:**  Accessible on port `12000` (bound to Spark localhost).
-   **TRT-LLM API:** Accessible on port `8000` (bound to Spark localhost).

## Setup Steps

### 1.  Initial Boot/Migration Verification

-   Use `GET` requests (e.g., via `curl` or a web browser) for initial service checks after boot or migrations. Avoid using `curl -I` (HEAD requests) initially, as this can be misleading.

### 2.  Open WebUI Healthcheck Override (If Needed)

-   The default Open WebUI healthcheck within the Docker container might fail due to `jq` errors. Consider overriding the healthcheck to a simple HTTP probe to avoid an "unhealthy" status when the service is actually running correctly.

### 3.  Minimal In-Container Diagnostics

-   Do not rely on the `ps` command inside the Open WebUI container for diagnostics. It might not be available. Use other troubleshooting methods.

### 4.  Port Bindings (Spark)

-   Ensure the following port bindings are configured on the Spark server (localhost-only):
    *   **TRT-LLM:** `127.0.0.1:8000`
    *   **Open WebUI:** `127.0.0.1:12000`

### 5.  macOS Client Access (SSH Port Forwarding)

-   On your macOS client, use SSH port forwarding to access both services on the Spark server.  This is a common method for securely accessing services that are only bound to localhost on the server.  Example:

```bash
ssh -L 8000:localhost:8000 -L 12000:localhost:12000 nvidia@<SPARK_LAN_IP>
