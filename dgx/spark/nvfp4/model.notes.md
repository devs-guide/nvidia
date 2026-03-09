| Quant in Unsloth repo | Total GGUF size | Quad 3090 usability (96 GB VRAM) | Notes |
|---|---|---|---|
| UD-Q2_K_XL | ~88.1 GB (49.8 GB + 38.3 GB) | Best “fit” target | “UD” (dynamic) quants typically preserve more important layers at higher precision than plain 2-bit; good first choice when trying to stay mostly VRAM-resident. |
| Q2_K | 85.7 GB | Fits with more headroom | Slightly smaller than UD-Q2; quality may be lower than UD variants, but it’s the safest “fits in VRAM” option. |
| UD-Q3_K_XL | 104 GB | Usable only with CPU/RAM spill | Exceeds 96 GB, so expect some offload to system RAM (or failure if forcing VRAM-only). |
| Q3_K_M | ~112.5 GB (49.8 + 49.7 + 13) | Usable only with CPU/RAM spill | Bigger spill than UD-Q3_K_XL; more likely to slow down. |


- UD-Q2_K_XL: ~88.1 GB
- Q2_K: 85.7 GB
- UD-Q3_K_XL: 104 GB
- Q3_K_M: ~112.5 GB