
- **Sanity Check:** `curl -s http://127.0.0.1:12000/health ; echo`
- **What Models:** `curl -s http://127.0.0.1:8000/v1/models | head`
- **Response**
{
  "object": "list",
  "data": [
    {
      "id": "nvidia-llama4-scout-17b-16e-nvfp4",
      "object": "model",
      "created": 1772525903,
      "owned_by": "tensorrt_llm"
    }
  ]
}

- **QUERY:**
```sh
 MODEL_TO_QUERY="nvidia-llama4-scout-17b-16e-nvfp4"

 curl -s http://127.0.0.1:8000/v1/chat/completions \
   -H "Content-Type: application/json" \
   -d '{
     "model": "'"${MODEL_TO_QUERY}"'",
     "temperature": 0,
     "messages": [
       {
         "role": "system",
         "content": "You are an AppleScript assistant. Output AppleScript in a fenced code block labeled applescript."
       },
       {
         "role": "user",
         "content": "Write an AppleScript handler that returns true if a given string contains only digits."
       }
     ]
   }'

```

- **Query Response**
```json
{
  "id": "chatcmpl-82581bfab9fc48ca9521d46228821569",
  "object": "chat.completion",
  "created": 1772526124,
  "model": "nvidia-llama4-scout-17b-16e-nvfp4",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "```applescript\ncontainsOnlyDigits(handlerString)\n    set theString to handlerString as string\n    if theString is \"\" then return false\n    repeat with i from 1 to the length of theString\n        if character i of theString is not a digit then return false\n    end repeat\n    return true\nend containsOnlyDigits\n```\n\nYou can call this handler with a string argument like so:\n\n```applescript\ncontainsOnlyDigits(\"12345\")  -- returns true\ncontainsOnlyDigits(\"123abc\")  -- returns false\n```",
        "reasoning_content": null,
        "reasoning": null,
        "tool_calls": []
      },
      "logprobs": null,
      "finish_reason": "stop",
      "stop_reason": null,
      "mm_embedding_handle": null,
      "disaggregated_params": null,
      "avg_decoded_tokens_per_iter": 1.0
    }
  ],
  "usage": {
    "prompt_tokens": 51,
    "total_tokens": 168,
    "completion_tokens": 117
  },
  "prompt_token_ids": null
}
```