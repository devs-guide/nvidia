1.  Spark: Cleanup + Create Network

    ```bash
    # (Spark) show what is bound on the ports we will use
    sudo ss -lntp | egrep ':(8000|12000)\b' || true

    # (Spark) stop/remove prior containers if present
    docker rm -f nvfp4-gpt-oss-120b 2>/dev/null || true
    docker rm -f open-webui         2>/dev/null || true

    # (Spark) optional: remove the Open WebUI persistent volume if you want env vars to re-apply cleanly
    # NOTE: Open WebUI persists some config values after first launch. If you keep the volume,
    # you may need to update the connection in the WebUI admin UI instead of env vars.
    docker volume rm open-webui 2>/dev/null || true
    ```

    > Open WebUI persists certain settings (“PersistentConfig”) after first launch; removing the volume forces a clean config re-seed from env vars.
    ```bash
    # (Spark) create shared network
    docker network create llm-net 2>/dev/null || true
    ```

2.  Spark: Define NVFP4 Model Paths + Image

    ```bash
    # Adjust these to match your layout (you already have ~/gpt/nvfp4/...):
    # (Spark)
    export NVFP4_MODELS="$HOME/gpt/nvfp4"
    export TRTLLM_IMAGE="nvcr.io/nvidia/tensorrt-llm/release:spark-single-gpu-dev"

    # model + config file
    export MODEL_SUBDIR="gpt-oss-120b-NVFP4"
    export MODEL_DIR="$NVFP4_MODELS/$MODEL_SUBDIR"
    export EXTRA_YAML="$NVFP4_MODELS/config/nvfp4.yaml" 

    test -f "$MODEL_DIR/config.json" || { echo "Missing $MODEL_DIR/config.json"; exit 1; }
    test -f "$EXTRA_YAML" || { echo "Missing $EXTRA_YAML"; exit 1; }
    ```

3.  Spark: Start TensorRT-LLM Server (Bind to localhost only)

    ```bash
    # This binds the API to 127.0.0.1:8000 on the Spark host.
    docker run -d --name nvfp4-gpt-oss-120b \
      --network llm-net \
      --restart unless-stopped \
      --ipc=host \
      --gpus all \
      --ulimit memlock=-1 \
      --ulimit stack=67108864 \
      -p 127.0.0.1:8000:8000 \
      -v "$HOME/.cache:/root/.cache:rw" \
      -v "$NVFP4_MODELS:/models:ro" \
      -v "$EXTRA_YAML:/extra.yaml:ro" \
      "$TRTLLM_IMAGE" \
      bash -lc "trtllm-serve /models/$MODEL_SUBDIR \
        --backend pytorch \
        --host 0.0.0.0 --port 8000 \
        --max_batch_size 16 \
        --max_num_tokens 1024 \
        --trust_remote_code \
        --extra_llm_api_options /extra.yaml"
    ```

    Sanity checks:

    ```bash
    # (Spark)
    docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
    curl -s http://127.0.0.1:8000/version && echo
    curl -i http://127.0.0.1:8000/health
    ```

4.  Spark: Start Open WebUI (Bind to localhost only) and point it at TRT-LLM
    > Open WebUI can target OpenAI-compatible backends by setting OPENAI_API_BASE_URL (include /v1) and OPENAI_API_KEY (any string if your backend doesn’t enforce auth).
	- Docker DNS resolves container names on the user-defined network.
	- Use the same name as the docker container for the address 


    ```bash
    docker run -d --name open-webui \
      --network llm-net \
      --restart unless-stopped \
      -p 127.0.0.1:12000:8080 \
      -e OPENAI_API_BASE_URL="http://nvfp4-gpt-oss-120b:8000/v1" \
      -e OPENAI_API_KEY="sk-local-anything" \
      -v open-webui:/app/backend/data \
      ghcr.io/open-webui/open-webui:main
    ```

    Sanity checks:

    ```bash
    # (Spark)
    docker logs --tail=200 open-webui
    curl -I http://127.0.0.1:12000/ | head
    ```

5.  Spark: Verify OpenAI-compatible Endpoints on TRT-LLM

    > From the Spark host:

    ```bash
    # (Spark) confirm models list is reachable (Open WebUI typically relies on this)
    curl -s http://127.0.0.1:8000/v1/models | head -c 2000 && echo
    ```

    > If /v1/models errors, dump the routes to see what this build exposes:

    ```bash
    # (Spark)
    curl -s http://127.0.0.1:8000/openapi.json \
      | python3 -c 'import sys,json; d=json.load(sys.stdin); print("\n".join(sorted(d.get("paths", {}).keys())))' \
      | head -n 200
    ```

6.  macOS: SSH Port Forwarding (WebUI + Direct API)

    6.1 Free the local ports (macOS)

    ```bash
    # (macOS)
    lsof -i :12000 || true
    lsof -i :8000  || true

    # If needed:
    # kill -9 $(lsof -ti:12000)
    # kill -9 $(lsof -ti:8000)
    ```

    6.2 Start the tunnel (macOS)

    ```bash
    # (macOS) replace IP/host as needed
    ssh -f -N \
      -L 12000:127.0.0.1:12000 \
      -L 8000:127.0.0.1:8000 \
      nvidia@<SPARK_LAN_IP>
    ```

    > Now:
    > WebUI: http://127.0.0.1:12000
    > API: http://127.0.0.1:8000
    > Quick checks (macOS):

    ```bash
    curl -s http://127.0.0.1:8000/version && echo
    curl -i http://127.0.0.1:8000/health
    curl -s http://127.0.0.1:8000/v1/models | head -c 2000 && echo
    ```


## DEBUG ERRORS:

# (Spark) what is up, and did anything restart/crash?
docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'

# (Spark) inspect exit/OOM status (adjust name if different)
docker inspect -f 'Status={{.State.Status}} OOMKilled={{.State.OOMKilled}} ExitCode={{.State.ExitCode}} Error={{.State.Error}}' nvfp4-gpt-oss-120b 2>/dev/null || true
docker inspect -f 'Status={{.State.Status}} OOMKilled={{.State.OOMKilled}} ExitCode={{.State.ExitCode}} Error={{.State.Error}}' open-webui         2>/dev/null || true

# (Spark) stop/remove prior containers if present
docker rm -f nvfp4-gpt-oss-120b 2>/dev/null || true
docker rm -f open-webui         2>/dev/null || true







------


7.  “Verbose” TTFT/TPS while using WebUI (client-side measurement)

    > Most WebUIs won’t show TTFT/TPS directly; measure it against the same backend endpoint your WebUI uses.
    7.1 Streaming TTFT + rough throughput (macOS)

    ```bash
    cat > /tmp/ttft.py <<'PY'
    import json, time, requests

    BASE="http://127.0.0.1:8000"
    model_id = requests.get(f"{BASE}/v1/models", timeout=30).json()["data"][0]["id"]

    payload = {
      "model": model_id,
      "messages": [{"role":"user","content":"Write a concise 8-step checklist for validating a TRT-LLM deployment."}],
      "max_tokens": 256,
      "temperature": 0,
      "stream": True
    }

    t0 = time.time()
    ttft = None
    chars = 0

    with requests.post(f"{BASE}/v1/chat/completions", json=payload, stream=True, timeout=600) as r:
      r.raise_for_status()
      for line in r.iter_lines(decode_unicode=True):
        if not line:
          continue
        if line.startswith("data: "):
          data = line[6:].strip()
        else:
          data = line.strip()
        if data == "[DONE]":
          break
        try:
          evt = json.loads(data)
        except json.JSONDecodeError:
          continue
        if ttft is None:
          ttft = time.time() - t0
        delta = evt.get("choices",[{}])[0].get("delta",{})
        chunk = delta.get("content")
        if chunk:
          chars += len(chunk)

    t1 = time.time()
    print("model:", model_id)
    print("TTFT(s):", None if ttft is None else round(ttft, 3))
    print("elapsed(s):", round(t1 - t0, 3))
    print("chars:", chars)
    PY

    python3 /tmp/ttft.py
    ```

    7.2 Server logs (Spark) for request visibility

    ```bash
    # (Spark)
    docker logs -f nvfp4-llama4-scout
    ```

    Notes specific to your current state

    > Your current docker ps shows Open WebUI bound to 0.0.0.0:3000. The refactor above standardizes on 127.0.0.1:12000 to match the existing macOS SSH-forward pattern you used before.
    > If you prefer to keep 3000, just replace:
    > -p 127.0.0.1:12000:8080 with -p 127.0.0.1:3000:8080
    > and SSH forward -L 3000:127.0.0.1:3000
    > If the model dropdown in Open WebUI stays empty after this, paste the output of:

    ```bash
    curl -s http://127.0.0.1:8000/v1/models | python3 -m json.tool | head -n 120
    ```

    > …and I’ll map the exact model id / endpoint path Open WebUI should use for this TRT-LLM 1.1.0rc3 server.
