#!/usr/bin/env python3
"""

Reads a prompt from a text file and sends it to Ollama /api/generate.
Safely handles complex quotes, whitespace, symbols, regex backslashes,
HTML entities (as literal text), and emoji/unicode.

Usage:
  python3 ollama.py \
    --url http://127.0.0.1:11434 \
    --model deepseek-r1:70b-llama-distill-q8_0 \
    --prompt-file prompt.txt \
    --num-ctx 2048 \
    --num-predict 16 \
    --temperature 0

If prompt.txt has unknown/bad encoding bytes, either fix it to UTF-8 or run:
  python3 ollama_fileprompt.py ... --decode-errors replace
"""

import argparse
import json
import sys
import urllib.request
import urllib.error


def read_prompt_file(path: str, encoding: str, errors: str) -> str:
    # Read bytes first so we control decoding precisely.
    data = open(path, "rb").read()

    # utf-8-sig will strip UTF-8 BOM if present; otherwise behaves like utf-8.
    try:
        return data.decode(encoding, errors=errors)
    except UnicodeDecodeError as e:
        raise RuntimeError(
            f"Prompt file is not valid {encoding}. "
            f"Fix encoding to UTF-8 (recommended), or rerun with --decode-errors replace.\n"
            f"Details: {e}"
        ) from e


def post_json(url: str, payload: dict, timeout: int) -> dict:
    # ensure_ascii=False preserves unicode (emoji, symbols) directly.
    # json.dumps will escape quotes/backslashes/control chars correctly for JSON.
    body = json.dumps(payload, ensure_ascii=False).encode("utf-8")

    req = urllib.request.Request(
        url,
        data=body,
        headers={"Content-Type": "application/json; charset=utf-8"},
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            resp_body = resp.read().decode("utf-8", errors="replace")
    except urllib.error.HTTPError as e:
        err_body = e.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"HTTP {e.code} {e.reason}\n{err_body}") from e
    except urllib.error.URLError as e:
        raise RuntimeError(f"Connection error: {e}") from e

    try:
        return json.loads(resp_body)
    except json.JSONDecodeError as e:
        raise RuntimeError(f"Response was not valid JSON:\n{resp_body}") from e


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--url", default="http://127.0.0.1:11434", help="Ollama base URL")
    ap.add_argument("--model", required=True, help="Model name")
    ap.add_argument("--prompt-file", default="prompt.txt", help="Prompt file path")
    ap.add_argument("--num-ctx", type=int, default=2048)
    ap.add_argument("--num-predict", type=int, default=16)
    ap.add_argument("--temperature", type=float, default=0.0)
    ap.add_argument("--stream", action="store_true", help="Enable streaming (script expects non-stream by default)")
    ap.add_argument("--keep-alive", default=None, help='Optional keep_alive (e.g. "2h") or "0" to unload')
    ap.add_argument("--timeout", type=int, default=600)

    # Encoding controls (for “weird” prompt files)
    ap.add_argument("--encoding", default="utf-8-sig", help="Prompt file encoding (default: utf-8-sig)")
    ap.add_argument("--decode-errors", default="strict", choices=["strict", "replace", "ignore"],
                    help="How to handle bad bytes when decoding prompt (default: strict)")

    args = ap.parse_args()

    try:
        prompt = read_prompt_file(args.prompt_file, args.encoding, args.decode_errors)
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 2

    payload = {
        "model": args.model,
        "prompt": prompt,
        "stream": bool(args.stream),
        "options": {
            "num_ctx": args.num_ctx,
            "temperature": args.temperature,
            "num_predict": args.num_predict,
        },
    }

    if args.keep_alive is not None:
        ka = args.keep_alive.strip()
        payload["keep_alive"] = 0 if ka == "0" else ka

    endpoint = args.url.rstrip("/") + "/api/generate"

    try:
        result = post_json(endpoint, payload, timeout=args.timeout)
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1

    print(json.dumps(result, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())