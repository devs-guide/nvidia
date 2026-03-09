
NVFP4_MODELS=/home/nvidia/gpt/nvfp4/
# nvidia@spark:~/gpt/nvfp4$ ls
# config  nvidia-llama4-scout-17b-16e-nvfp4  nvidia-qwen3-235b-a22b-nvfp4


docker run --rm --name nvfp4-llama4-scout \
  --ipc=host \
  --gpus all \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  -p 8000:8000 \
  -v "$HOME/.cache:/root/.cache:rw" \
  -v "$NVFP4_MODELS:/models:ro" \
  -v "$NVFP4_MODELS/config/llama4-scout-spark.yaml:/config.yaml:ro" \ nvcr.io/nvidia/tensorrt-llm/release:spark-single-gpu-dev \
  bash -lc 'trtllm-serve /models --backend pytorch --host 0.0.0.0 --port 8000 --config /config.yaml'


docker run --rm --name nvfp4-llama4-scout \
  --ipc=host \
  --gpus all \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  -p 8000:8000 \
  -v "$HOME/.cache:/root/.cache:rw" \
  -v "$NVFP4_MODELS:/models:ro" \
  -v "$NVFP4_MODELS/config/llama4-scout-spark.yaml:/extra.yaml:ro" \
	  nvcr.io/nvidia/tensorrt-llm/release:spark-single-gpu-dev \
bash -lc 'trtllm-serve /models/nvidia-llama4-scout-17b-16e-nvfp4 \
  --backend pytorch \
  --host 0.0.0.0 --port 8000 \
  --trust_remote_code \
  --extra_llm_api_options /extra.yaml'



docker run --rm --name nvfp4-llama4-scout --ipc=host --gpus all --ulimit memlock=-1 --ulimit stack=67108864 -p 8000:8000 -v "$HOME/.cache:/root/.cache:rw" -v "$NVFP4_MODELS:/models:ro" -v "$NVFP4_MODELS/config/llama4-scout-spark.yaml:/extra.yaml:ro" nvcr.io/nvidia/tensorrt-llm/release:spark-single-gpu-dev bash -lc 'trtllm-serve /models/nvidia-llama4-scout-17b-16e-nvfp4 --backend pytorch --host 0.0.0.0 --port 8000 --trust_remote_code --extra_llm_api_options /extra.yaml'


docker run --rm \
  --name nvfp4-llama4-scout \
  --ipc=host \
  --gpus all \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  -p 8000:8000 \
  -v "$HOME/.cache:/root/.cache:rw" \
  -v "$NVFP4_MODELS:/models:ro" \
  -v "$NVFP4_MODELS/config/llama4-scout-spark.yaml:/extra.yaml:ro" \
  nvcr.io/nvidia/tensorrt-llm/release:spark-single-gpu-dev \
  bash -lc 'trtllm-serve /models/nvidia-llama4-scout-17b-16e-nvfp4 \
  --backend pytorch \
  --host 0.0.0.0 --port 8000 \
  --trust_remote_code \
  --extra_llm_api_options /extra.yaml'




MODEL_ID="$(curl -s http://127.0.0.1:8000/v1/models | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0]["id"])')"


curl -s http://127.0.0.1:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"${MODEL_ID}\",
    \"messages\": [{\"role\":\"user\",\"content\":\"Say hello in one sentence.\"}],
    \"max_tokens\": 64,
    \"temperature\": 0
  }" | python3 -m json.tool | head -n 120



### Qwen3-NEXT-80B-A3B-Thinking

docker run --rm \
  --name nvfp4-qwen3-next-80b-A3b-thinking \
  --ipc=host \
  --gpus all \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  -p 8000:8000 \
  -v "$HOME/.cache:/root/.cache:rw" \
  -v "$NVFP4_MODELS:/models:ro" \
  -v "$NVFP4_MODELS/config/llama4-scout-spark.yaml:/extra.yaml:ro" \
  nvcr.io/nvidia/tensorrt-llm/release:spark-single-gpu-dev \
  bash -lc 'trtllm-serve /models/nvidia-llama4-scout-17b-16e-nvfp4 \
  --backend pytorch \
  --host 0.0.0.0 --port 8000 \
  --trust_remote_code \
  --extra_llm_api_options /extra.yaml'
