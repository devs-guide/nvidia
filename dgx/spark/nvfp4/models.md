# NVFP4


## Hugging Face Download:


hf download nvidia/Qwen3-14B-NVFP4 --local-dir ~/gpt/download/Qwen3-14B-NVFP4 --cache-dir ~/gpt/download/.cache/Phi-4-reasoning-plus-NVFP4 --token "$HF_TOKEN" --max-workers 16


## ranked list based on memory footprint (MinMem), from least to greatest, and including model names and descriptions:

 ### Phi-4-multimodal-instruct (x)
 > `nvidia/Phi-4-multimodal-instruct-NVFP4`
  - Vision+language (very small). 
  - (5.6B Params) 
  - Minimum Memory: 6.9 GiB

 ### Qwen2.5-VL-7B-Instruct (x)
 > `nvidia/Qwen2.5-VL-7B-Instruct-NVFP4`
  - Vision+language (small).
  - (7.0B Params)
  - Minimum Memory: 7.7 GiB

 ### Llama-3.1-8B-Instruct (x)
 > `nvidia/Llama-3.1-8B-Instruct-NVFP4`
  - Small general assistant.
  - (8.0B Params)
  - Minimum Memory: 8.2 GiB

 ### Qwen3-8B (x)
 > `nvidia/Qwen3-8B-NVFP4`
  - Fast general / tool use.
  - (8.0B Params)
  - Minimum Memory: 8.2 GiB

 ### NVIDIA-Nemotron-Nano-9B-v2 (x)
 > `nvidia/NVIDIA-Nemotron-Nano-9B-v2-NVFP4`
  - Small reasoning/chat.
  - (9.0B Params)
  - Minimum Memory: 8.7 GiB

 ### NVIDIA-Nemotron-Nano-12B-v2-VL-NVFP4-QAD (x)
 > `nvidia/NVIDIA-Nemotron-Nano-12B-v2-VL-NVFP4-QAD`
  - Vision+language (small).
  - (12.0B Params)
  - Minimum Memory: 14.3 GiB

 ### Qwen3-14B (x)
 > `nvidia/Qwen3-14B-NVFP4`
  - Fast general / tool use.
  - (14.0B Params)
  - Minimum Memory: 15.3 GiB

 ### Phi-4-reasoning-plus (x)
 > `nvidia/Phi-4-reasoning-plus-NVFP4`
  - Reasoning (small but strong).
  - (14.7B Params)
  - Minimum Memory: 15.7 GiB

 ### Llama-4-Scout-17B-16E-Instruct (x)
 > `nvidia/Llama-4-Scout-17B-16E-Instruct-NVFP4`
 > tested: about 80gb of unified memory
  - General assistant (MoE).
  - (56.0B Params)
  - Minimum Memory: 41.3 GiB

 ### Qwen3-Next-80B-A3B-Thinking (x)
 > `nvidia/Qwen3-Next-80B-A3B-Thinking-NVFP4`
  - Fast reasoning/planning (MoE).
  - (80.0B Params)
  - Minimum Memory: 53.9 GiB

 ### Qwen3-Next-80B-A3B-Instruct 
 > `nvidia/Qwen3-Next-80B-A3B-Instruct-NVFP4`
  - Fast instruct/chat (MoE).
  - (80.0B Params)
  - Minimum Memory: 53.9 GiB

 ### Qwen3-235B-A22B-Instruct-2507
 > `nvidia/Qwen3-235B-A22B-Instruct-2507-NVFP4`
  - General assistant.
  - (120.0B Params)
  - Minimum Memory: 74.9 GiB

 ### Qwen3-235B-A22B
 > `nvidia/Qwen3-235B-A22B-NVFP4`
  - General base (for finetune).
  - (133.0B Params)
  - Minimum Memory: 85.7 GiB

 ### Qwen3-VL-235B-A22B-Instruct-NVFP4-MLPerf-Inference-Closed-V6.0 (x)
 > `nvidia/Qwen3-VL-235B-A22B-Instruct-NVFP4-MLPerf-Inference-Closed-V6.0`
  - Vision+language (largest).
  - (133.0B Params)
  - Minimum Memory: 85.7 GiB

 ### Qwen3-235B-A22B-Thinking-2507
 > `nvidia/Qwen3-235B-A22B-Thinking-2507-NVFP4`
  - Reasoning (MoE).
  - (235.0B Params)
  - Minimum Memory: 139.1 GiB

 ### DeepSeek-R1 (multiple versions)
 > `nvidia/DeepSeek-R1-NVFP4`, `nvidia/DeepSeek-R1-NVFP4-v2`, `nvidia/DeepSeek-R1-0528-NVFP4`, `nvidia/DeepSeek-R1-0528-NVFP4-v2`, `nvidia/DeepSeek-V3-0324-NVFP4`, `nvidia/DeepSeek-V3.2-NVFP4`, `nvidia/DeepSeek-V3.1-NVFP4`
  - Reasoning (deep CoT) and General chat + tools.
  - (394-397B Params)
  - Minimum Memory: 222.4-224.0 GiB

 ### Llama-3.1-405B-Instruct
 > `nvidia/Llama-3.1-405B-Instruct-NVFP4`
  - General assistant (max size).
  - (405.0B Params)
  - Minimum Memory: 228.2 GiB

 ### Qwen3-Coder-480B-A35B-Instruct
 > `nvidia/Qwen3-Coder-480B-A35B-Instruct-NVFP4`
  - Code (largest).
  - (480.0B Params)
  - Minimum Memory: 267.3 GiB

 ### Kimi-K2-Thinking
 > `nvidia/Kimi-K2-Thinking-NVFP4`
  - Reasoning (max quality).
  - (1000.0B Params)
  - Minimum Memory: 539.2 GiB

 ### Kimi-K2.5
 > `nvidia/Kimi-K2.5-NVFP4`
  - General chat / reasoning.
  - (1000.0B Params)
  - Minimum Memory: 539.2 GiB



 ### gpt-oss-120b
 > `stepnoy/gpt-oss-120b-NVFP4`
 




| Model                                                                 | Params (B) | Weights (GiB) | MinMem (GiB) | Fits 1×Spark? | Max instances on 1×Spark (mem) | Sparks needed (mem) | Best for                      | Rank (category) | TPS est (tok/s)                        |
| --------------------------------------------------------------------- | ---------: | ------------: | -----------: | :-----------: | -----------------------------: | ------------------: | ----------------------------- | --------------: | -------------------------------------- |
| nvidia/DeepSeek-R1-NVFP4                                              |      397.0 |         208.0 |        224.0 |       No      |                              0 |                   2 | Reasoning (deep CoT)          |               1 | ≈2–6 (won’t fit 1×Spark)               |
| nvidia/DeepSeek-R1-NVFP4-v2                                           |      394.0 |         206.4 |        222.4 |       No      |                              0 |                   2 | Reasoning (deep CoT)          |               1 | ≈2–6 (won’t fit 1×Spark)               |
| nvidia/DeepSeek-R1-0528-NVFP4                                         |      397.0 |         208.0 |        224.0 |       No      |                              0 |                   2 | Reasoning (deep CoT)          |               1 | ≈2–6 (won’t fit 1×Spark)               |
| nvidia/DeepSeek-R1-0528-NVFP4-v2                                      |      394.0 |         206.4 |        222.4 |       No      |                              0 |                   2 | Reasoning (deep CoT)          |               1 | ≈2–6 (won’t fit 1×Spark)               |
| nvidia/DeepSeek-V3-0324-NVFP4                                         |      397.0 |         208.0 |        224.0 |       No      |                              0 |                   2 | General chat + tools          |               1 | ≈2–6 (won’t fit 1×Spark)               |
| nvidia/DeepSeek-V3.2-NVFP4                                            |      394.0 |         206.4 |        222.4 |       No      |                              0 |                   2 | General chat + tools          |               1 | ≈2–6 (won’t fit 1×Spark)               |
| nvidia/DeepSeek-V3.1-NVFP4                                            |      394.0 |         206.4 |        222.4 |       No      |                              0 |                   2 | General chat + tools          |               1 | ≈2–6 (won’t fit 1×Spark)               |
| nvidia/Qwen3.5-397B-A17B-NVFP4                                        |      397.0 |         208.0 |        224.0 |       No      |                              0 |                   2 | General chat (MoE), long-form |               2 | ≈20–60 (if it fit; MoE act 17B)        |
| nvidia/Qwen3-Coder-480B-A35B-Instruct-NVFP4                           |      480.0 |         251.3 |        267.3 |       No      |                              0 |                   3 | Code (largest)                |               1 | ≈10–30 (if it fit; MoE act 35B)        |
| nvidia/Kimi-K2-Thinking-NVFP4                                         |     1000.0 |         523.2 |        539.2 |       No      |                              0 |                   5 | Reasoning (max quality)       |               1 | N/A (far beyond 1×Spark)               |
| nvidia/Kimi-K2.5-NVFP4                                                |     1000.0 |         523.2 |        539.2 |       No      |                              0 |                   5 | General chat / reasoning      |               1 | N/A (far beyond 1×Spark)               |
| nvidia/Qwen3-Next-80B-A3B-Thinking-NVFP4                              |       80.0 |          41.9 |         53.9 |      Yes      |                              2 |                   1 | Fast reasoning/planning (MoE) |               2 | ≈60–150                                |
| nvidia/Qwen3-Next-80B-A3B-Instruct-NVFP4                              |       80.0 |          41.9 |         53.9 |      Yes      |                              2 |                   1 | Fast instruct/chat (MoE)      |               2 | ≈60–150                                |
| nvidia/Qwen3-VL-235B-A22B-Instruct-NVFP4-MLPerf-Inference-Closed-V6.0 |      133.0 |          69.7 |         85.7 |      Yes      |                              1 |                   1 | Vision+language (largest)     |               1 | ≈10–30 (text-only); slower w/ images   |
| nvidia/Qwen3-235B-A22B-Thinking-2507-NVFP4                            |      235.0 |         123.1 |        139.1 |       No      |                              0 |                   2 | Reasoning (MoE)               |               2 | ≈15–40 (likely too tight on 1×Spark)   |
| nvidia/Qwen3-235B-A22B-Instruct-2507-NVFP4                            |      120.0 |          62.9 |         74.9 |      Yes      |                              1 |                   1 | General assistant             |               2 | ≈15–40                                 |
| nvidia/Qwen3-235B-A22B-NVFP4                                          |      133.0 |          69.7 |         85.7 |      Yes      |                              1 |                   1 | General base (for finetune)   |               3 | ≈15–40                                 |
| nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B-NVFP4                           |       30.5 |          16.0 |         24.0 |      Yes      |                              4 |                   1 | Fast agent/planning (MoE)     |               1 | ≈120–250                               |
| nvidia/NVIDIA-Nemotron-Nano-9B-v2-NVFP4                               |        9.0 |           4.7 |          8.7 |      Yes      |                             13 |                   1 | Small reasoning/chat          |               1 | ≈140–280                               |
| nvidia/NVIDIA-Nemotron-Nano-12B-v2-VL-NVFP4-QAD                       |       12.0 |           6.3 |         14.3 |      Yes      |                              8 |                   1 | Vision+language (small)       |               3 | ≈90–200                                |
| nvidia/Llama-4-Scout-17B-16E-Instruct-NVFP4                           |       56.0 |          29.3 |         41.3 |      Yes      |                              2 |                   1 | General assistant (MoE)       |               3 | ≈35–90                                 |
| nvidia/Llama-3_3-Nemotron-Super-49B-v1_5-NVFP4                        |       26.0 |          13.6 |         21.6 |      Yes      |                              5 |                   1 | General assistant (efficient) |               4 | ≈70–140                                |
| nvidia/Llama-3.3-70B-Instruct-NVFP4                                   |       70.0 |          36.7 |         48.7 |      Yes      |                              2 |                   1 | General assistant (quality)   |               3 | ≈15–35                                 |
| nvidia/Llama-3.1-8B-Instruct-NVFP4                                    |        8.0 |           4.2 |          8.2 |      Yes      |                             14 |                   1 | Small general assistant       |               5 | ≈160–320                               |
| nvidia/Llama-3.1-405B-Instruct-NVFP4                                  |      405.0 |         212.2 |        228.2 |       No      |                              0 |                   2 | General assistant (max size)  |               1 | N/A (won’t fit 1×Spark)                |
| nvidia/Qwen2.5-VL-7B-Instruct-NVFP4                                   |        7.0 |           3.7 |          7.7 |      Yes      |                             15 |                   1 | Vision+language (small)       |               4 | ≈160–320 (text-only); slower w/ images |
| nvidia/Qwen3-30B-A3B-NVFP4                                            |       30.5 |          16.0 |         24.0 |      Yes      |                              4 |                   1 | Fast instruct/chat (MoE)      |               3 | ≈120–250                               |
| nvidia/Qwen3-32B-NVFP4                                                |       32.0 |          16.8 |         24.8 |      Yes      |                              4 |                   1 | Code + general (mid)          |               2 | ≈40–90                                 |
| nvidia/Qwen3-14B-NVFP4                                                |       14.0 |           7.3 |         15.3 |      Yes      |                              7 |                   1 | Fast general / tool use       |               3 | ≈80–170                                |
| nvidia/Qwen3-8B-NVFP4                                                 |        8.0 |           4.2 |          8.2 |      Yes      |                             14 |                   1 | Fast general / tool use       |               4 | ≈140–280                               |
| nvidia/Phi-4-reasoning-plus-NVFP4                                     |       14.7 |           7.7 |         15.7 |      Yes      |                              7 |                   1 | Reasoning (small but strong)  |               3 | ≈80–170                                |
| nvidia/Phi-4-multimodal-instruct-NVFP4                                |        5.6 |           2.9 |          6.9 |      Yes      |                             17 |                   1 | Vision+language (very small)  |               5 | ≈180–360 (text-only); slower w/ images |
