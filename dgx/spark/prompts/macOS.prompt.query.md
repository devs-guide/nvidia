# Optimized for DGX Spark (128GB Unified Memory)
MODEL="frizynn/qwen3-think-235B-A22B-2507-2bit-UD-Q2_K_XL"
PROMPT="Explain the architectural advantages of Blackwell GB10 for LLM inference."

# Generate Payload
PAYLOAD=$(jq -n \
  --arg m "$MODEL" \
  --arg p "$PROMPT" \
  '{model: $m, prompt: $p, stream: false, options: {num_ctx: 512, num_gpu: 99, main_gpu: 0}}')
