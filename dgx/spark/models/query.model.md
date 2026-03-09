llama3.3:70b-instruct-q8_0

curl -s http://127.0.0.1:11434/api/generate \
  -H 'Content-Type: application/json' \
  -d "{
    \"model\": \"${DEEPSEEK}\",
    \"prompt\": \"Say OK.\",
    \"stream\": false,
    \"options\": { \"num_ctx\": 2048, \"temperature\": 0, \"num_predict\": 16 }
  }" | python3 -m json.tool | head -n 60
x@xs-Mac-mini ~ % META="llama3.3:70b-instruct-q8_0"
x@xs-Mac-mini ~ % curl -s http://127.0.0.1:11434/api/generate \
  -H 'Content-Type: application/json' \
  -d "{
    \"model\": \"${META}\",    
    \"prompt\": \"Say OK.\",
    \"stream\": false,
    \"options\": { \"num_ctx\": 2048, \"temperature\": 0, \"num_predict\": 16 }
  }" | python3 -m json.tool | head -n 60



 curl -s http://127.0.0.1:11434/api/generate \
  -H 'Content-Type: application/json' \
  -d "{
    \"model\": \"${DEEPSEEK}\",
    \"prompt\": \"Say OK.\",
    \"stream\": false,
    \"options\": { \"num_ctx\": 2048, \"temperature\": 0, \"num_predict\": 16 }
  }" | python3 -m json.tool | head -n 60
  
{
    "model": "deepseek-r1:70b-llama-distill-q8_0",
    "created_at": "2026-03-01T08:11:06.662581335Z",
    "response": "<think>\n\n</think>\n\nOK",
    "done": true,
    "done_reason": "stop",
    "context": [
        128011,
        46864,
        10619,
        13,
        128012,
        128013,
        271,
        128014,
        271,
        4012
    ],
    "total_duration": 254177638790,
    "load_duration": 246110431028,
    "prompt_eval_count": 6,
    "prompt_eval_duration": 6230117418,
    "eval_count": 6,
    "eval_duration": 1722951415
}


