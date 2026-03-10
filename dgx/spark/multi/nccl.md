# NCCL (Dual DGX Spark)
> IB/TCP collective validation and tuning between `<SPARK_ONE>` and `<SPARK_TWO>`.

## Env and Interfaces
- Prefer IB: `export NCCL_SOCKET_IFNAME=ib0`
- Fallback TCP: set to data-plane Ethernet (e.g., `ethX`)
- Optional: `NCCL_DEBUG=INFO`, `NCCL_IB_HCA=mlx5_0`

## Sanity Tests
- Visibility: `nvidia-smi topo -m`
- IB reachability: `ibstat` and `ibping -S`
- NCCL allreduce (IB): `nccl-tests/build/all_reduce_perf -b 8 -e 1G -f 2 -g 8 -n 20`
- NCCL allreduce (TCP): add `NCCL_IB_DISABLE=1` and rerun for baseline

## Throughput/Latency Checks
- IB bandwidth: `ib_write_bw -d mlx5_0 -F`
- IB latency: `ib_send_lat -d mlx5_0 -F`
- Compare against expected line rate; note any outliers per host.

## Tuning Notes
- Ensure IRQ pinning and NUMA locality match GPU/IB pairs.
- Keep driver/FW versions matched across `<SPARK_ONE>` and `<SPARK_TWO>`.
- Avoid mixed MTU; confirm 9000 on IB and data Ethernet if enabled.
