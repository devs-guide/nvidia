# Troubleshooting (Dual DGX Spark)
> Quick fixes when `<SPARK_ONE>` and `<SPARK_TWO>` misbehave.

## Link/MTU
- Verify MTU matches: `ip -br link` and `ip -d link show ib0`
- Jumbo ping: `ping -I ib0 -s 8972 <SPARK_PEER_IB>`
- Reload interface if flapping: `ip link set ib0 down && ip link set ib0 up`

## NCCL/IB
- Force IB: `export NCCL_SOCKET_IFNAME=ib0`
- Disable IB to isolate TCP: `export NCCL_IB_DISABLE=1`
- Check HCA state: `ibstat`, `dmesg | grep mlx5`
- Reset nv_peer_mem if needed: `systemctl restart nv_peer_mem` (if present)

## DNS/Hosts
- Ensure `/etc/hosts` entries exist for `<SPARK_ONE>` and `<SPARK_TWO>`.
- Confirm reverse DNS if relying on host-based ACLs.

## Storage
- Remount NFS with correct options: `mount -o remount,noatime <mount>`
- Check permissions/uid mapping if paths differ between hosts.

## When Stuck
- Capture logs: `dmesg`, `journalctl -u nv_peer_mem`, NIC/HCA logs.
- Re-run perf: `ib_write_bw`, `nccl-tests` to confirm regressions.
