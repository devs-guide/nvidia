#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# metrics.sh (macOS-safe)
# Fixes: bash printf "%{...}" issue on macOS (bash builtin printf treats %{ as format)
#
# Outputs:
#   - TTFT_client_s      (curl time_starttransfer)
#   - Total_client_s     (curl time_total)
#   - Prompt TPS (server)  prompt_eval_count / prompt_eval_duration
#   - Decode TPS (server)  eval_count / eval_duration
#   - Response preview
# 
# EXAMPLE:
# MODEL="llama3.3:70b-instruct-q8_0" NUM_CTX=512 NUM_PREDICT=128 ./ollama-metrics.sh


# ------------------------------------------------------------

#
# ---- Config (override via env vars) ----
MODEL="${MODEL:-frizynn/qwen3-think-235B-A22B-2507-2bit-UD-Q2_K_XL}"
PROMPT_FILE="${PROMPT_FILE:-./prompt.txt}"
ENDPOINT="${ENDPOINT:-http://127.0.0.1:11434/api/generate}"

NUM_CTX="${NUM_CTX:-512}"
NUM_PREDICT="${NUM_PREDICT:-256}"
TEMPERATURE="${TEMPERATURE:-0}"
NUM_GPU="${NUM_GPU:-99}"
RAW_MODE="${RAW_MODE:-true}"

# ---- Dependencies ----
need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1" >&2; exit 1; }; }
need jq
need curl
need python3

# ---- Validate prompt file ----
if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "Error: prompt file not found: $PROMPT_FILE" >&2
  exit 1
fi

STREAM_FILE="$(mktemp -t ollama_stream.XXXXXX.jsonl)"
trap 'rm -f "$STREAM_FILE"' EXIT

# ---- Build JSON safely (no escaping issues) ----
JSON_PAYLOAD="$(
  jq -n \
    --arg model "$MODEL" \
    --rawfile prompt "$PROMPT_FILE" \
    --argjson num_ctx "$NUM_CTX" \
    --argjson temperature "$TEMPERATURE" \
    --argjson num_predict "$NUM_PREDICT" \
    --argjson num_gpu "$NUM_GPU" \
    --argjson raw "$RAW_MODE" \
    '{
      model: $model,
      prompt: $prompt,
      stream: true,
      raw: $raw,
      options: {
        num_ctx: $num_ctx,
        temperature: $temperature,
        num_predict: $num_predict,
        num_gpu: $num_gpu
      }
    }'
)"

echo "------------------------------------------------"
echo "Ollama metrics run (streaming)"
echo "------------------------------------------------"
echo "Endpoint:      $ENDPOINT"
echo "Model:         $MODEL"
echo "Prompt file:   $PROMPT_FILE"
echo "num_ctx:       $NUM_CTX"
echo "num_predict:   $NUM_PREDICT"
echo "temperature:   $TEMPERATURE"
echo "------------------------------------------------"

# ---- macOS-safe curl write-out string (NO bash printf here) ----
# Use a literal string so %{time_*} is passed to curl unchanged.
CURL_WRITEOUT='TTFT_client_s=%{time_starttransfer}
Total_client_s=%{time_total}
HTTP=%{http_code}
'

# ---- Execute request ----
CURL_STATS="$(
  printf '%s' "$JSON_PAYLOAD" \
  | curl -sS -N \
      -H "Content-Type: application/json" \
      --data-binary @- \
      -o "$STREAM_FILE" \
      -w "$CURL_WRITEOUT" \
      "$ENDPOINT"
)"

# ---- Parse stream + metrics ----
python3 - <<PY
import json, sys, pathlib

stream_path = pathlib.Path("$STREAM_FILE")
curl_stats = """$CURL_STATS"""

def parse_kv(text):
    out = {}
    for line in text.splitlines():
        if "=" in line:
            k, v = line.split("=", 1)
            out[k.strip()] = v.strip()
    return out

kv = parse_kv(curl_stats)
http_code = kv.get("HTTP", "???")
try:
    ttft_client = float(kv.get("TTFT_client_s", "nan"))
except ValueError:
    ttft_client = float("nan")
try:
    total_client = float(kv.get("Total_client_s", "nan"))
except ValueError:
    total_client = float("nan")

lines = [ln for ln in stream_path.read_text(encoding="utf-8", errors="replace").splitlines() if ln.strip()]

objs = []
for ln in lines:
    try:
        objs.append(json.loads(ln))
    except Exception:
        pass

if not objs:
    print("Error: no JSON objects received from stream.", file=sys.stderr)
    print("HTTP:", http_code, file=sys.stderr)
    # Show raw output tail for debugging
    tail = "\n".join(lines[-10:])
    if tail:
        print("---- stream tail ----", file=sys.stderr)
        print(tail, file=sys.stderr)
    sys.exit(1)

# Combine response chunks
response_text = "".join(o.get("response","") for o in objs if isinstance(o, dict))

# Find final (done=true)
final = None
for o in reversed(objs):
    if isinstance(o, dict) and o.get("done") is True:
        final = o
        break
if final is None:
    final = objs[-1] if isinstance(objs[-1], dict) else {}

ns = 1e9
def tps(tok, dur_ns):
    try:
        tok = float(tok)
        dur_ns = float(dur_ns)
    except Exception:
        return 0.0
    if dur_ns <= 0:
        return 0.0
    return tok / (dur_ns / ns)

load_ns  = final.get("load_duration", 0) or 0
total_ns = final.get("total_duration", 0) or 0
pe_tok   = final.get("prompt_eval_count", 0) or 0
pe_ns    = final.get("prompt_eval_duration", 0) or 0
ev_tok   = final.get("eval_count", 0) or 0
ev_ns    = final.get("eval_duration", 0) or 0

print("------------------------------------------------")
print("METRICS (DGX Spark via Ollama)")
print("------------------------------------------------")
print(f"http_code              {http_code}")
print(f"ttft_client_s          {ttft_client:.6f}")
print(f"total_client_s         {total_client:.6f}")
print(f"load_server_s          {float(load_ns)/ns:.6f}")
print(f"prompt_eval_tokens     {int(pe_tok)}")
print(f"prompt_eval_server_s   {float(pe_ns)/ns:.6f}")
print(f"prompt_tps_server      {tps(pe_tok, pe_ns):.6f}")
print(f"decode_tokens          {int(ev_tok)}")
print(f"decode_server_s        {float(ev_ns)/ns:.6f}")
print(f"decode_tps_server       {tps(ev_tok, ev_ns):.6f}")
print(f"total_server_s         {float(total_ns)/ns:.6f}")
print("------------------------------------------------")
print("RESPONSE PREVIEW (first 15 lines)")
print("------------------------------------------------")
preview = response_text.splitlines()[:15]
print("\n".join(preview))
PY

echo "------------------------------------------------"
echo "Raw stream saved at: $STREAM_FILE"
echo "------------------------------------------------"