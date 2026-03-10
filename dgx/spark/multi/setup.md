# Dual DGX Spark Setup
> Serialized setup steps to pair `<SPARK_ONE>` and `<SPARK_TWO>`.

1. **Prep**: confirm firmware/driver parity, note hostnames, reserve IPs for both nodes.
2. **Cable**: management + data plane (IB + Ethernet), label ends for `<SPARK_ONE>` and `<SPARK_TWO>`.
3. **Network bring-up**: set MTU, IPs, and routes on each host (see `networking.md`).
4. **Auth**: exchange SSH keys; ensure passwordless root/admin where required.
5. **Storage (optional)**: mount shared NFS/scratch or align local paths.
6. **Runtime alignment**: match Docker/NVIDIA runtime versions and configs.
7. **NCCL checks**: run IB throughput/latency and NCCL collectives (`nccl.md`).
8. **Validation**: smoke tests for storage, GPU visibility, and services (`validation.md`).
9. **Handoff**: record final IPs, MTU, test outputs, and known quirks.
