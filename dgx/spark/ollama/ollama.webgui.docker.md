# show what is currently bound to the ports (should be empty after cleanup)
sudo ss -lntp | egrep ':(11434|12000)\b' || true


docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'


docker rm -f ollama 2>/dev/null || true
docker rm -f open-webui 2>/dev/null || true


docker rm -f ollama 2>/dev/null || true && docker rm -f open-webui 2>/dev/null || true

docker network create llm-net 2>/dev/null || true
export MODEL_DIR="$HOME/gpt/ollama/models"


# start ollama with debug enabled (still bound to localhost only)
docker run -d \
  --name ollama \
  --network llm-net \
  --restart unless-stopped \
  --gpus all \
  -p 127.0.0.1:11434:11434 \
  -v "$HOME/gpt/nvfp4:/root/.ollama/models" \
  -e OLLAMA_HOST=0.0.0.0:11434 \
  -e OLLAMA_DEBUG=1 \
  -e OLLAMA_MAX_QUEUE=1 \
  -e OLLAMA_NUM_PARALLEL=1 \
  -e OLLAMA_MAX_LOADED_MODELS=1 \
  -e OLLAMA_FLASH_ATTENTION=1 \
  -e OLLAMA_KV_CACHE_TYPE=q8_0 \
  -e OLLAMA_CONTEXT_LENGTH=32768 \
  -e OLLAMA_KEEP_ALIVE=-1 \
  ollama/ollama:latest


# start open-webui
docker run -d \
  --name open-webui \
  --network llm-net \
  --restart unless-stopped \
  -p 127.0.0.1:12000:8080 \
  -e OLLAMA_BASE_URL=http://ollama:11434 \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main
  
  
# sanity: ports + containers
sudo ss -lntp | egrep ':(11434|12000)\b' || true

docker exec ollama ollama list

docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'


# macOS
# From the remote machine (macOS/Linux):
# sanity check: stop ports
lsof -i :12000

kill -9 <PID>
kill -9 $(lsof -ti:12000))

# background process
ssh -f -N -L 12000:127.0.0.1:12000 -L 11434:127.0.0.1:11434 nvidia@<SPARK_LAN_IP>

http://127.0.0.1:12000

docker logs -f ollama | grep -E "stats|eval|token"


