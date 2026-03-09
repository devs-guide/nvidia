### Stop Previous Sessions:
* Sanity Check:
 - `docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'`
 - `docker rm -f open-webui 2>/dev/null || true`
 - `docker volume rm open-webui 2>/dev/null || true`
 
* Optional but recommended for a clean start (removes any partially-migrated DB)
 
* Ensure the shared network exists
 - `docker network create llm-net 2>/dev/null || true`
 
 


### Load NVFP4 Model:

export NVFP4_MODELS="$HOME/gpt/nvfp4"
export MODEL_SUBDIR="gpt-oss-120b-NVFP4"
export TRTLLM_IMAGE="nvcr.io/nvidia/tensorrt-llm/release:spark-single-gpu-dev"

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
  "$TRTLLM_IMAGE" \
  bash -lc "trtllm-serve /models/$MODEL_SUBDIR \
    --backend pytorch \
    --host 0.0.0.0 --port 8000 \
    --log_level info \
    --max_seq_len 8192 \
    --max_batch_size 4 \
    --max_num_tokens 32768 \
    --kv_cache_free_gpu_memory_fraction 0.7 \
    --trust_remote_code"

 