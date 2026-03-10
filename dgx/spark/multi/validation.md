# Validation (Dual DGX Spark)
> Post-setup probes for `<SPARK_ONE>` and `<SPARK_TWO>`.

## Checks
- Host parity: kernel, driver, CUDA, Docker/NVIDIA runtime versions.
- GPU visibility: `nvidia-smi` and `nvidia-smi topo -m` on both nodes.
- IB link: `ibstat`, `ibping -S`, `ibdiagnet` if available.
- MTU and routes: `ip -br link`, `ping -I ib0 -s 8972 <SPARK_PEER_IB>`.
- Storage: mount check and `fio --name=read --rw=read --bs=1M --size=1G --filename=/path`.
- NCCL: run `nccl-tests` allreduce/collectives over IB and TCP (see `nccl.md`).
- Services: confirm any agents/daemons align (logging, monitoring, etc.).

## Artifacts to Save
- Final IP map, MTU settings, and `/etc/hosts` entries.
- NCCL test outputs and IB perf numbers.
- Noted quirks or deviations between `<SPARK_ONE>` and `<SPARK_TWO>`.
