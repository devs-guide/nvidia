# Networking (Dual DGX Spark)
> Interfaces, MTU, routes, and link checks for `<SPARK_ONE>` and `<SPARK_TWO>`.

## Interfaces & IPs
- `ib0`: data plane (NCCL), jumbo MTU (e.g., 9000), static IPs `/24` per host.
- `ethX` (data): fallback TCP plane, MTU 9000 if supported.
- `mgmt`: management network, MTU 1500.

## Baseline Commands
- Show links/MTU: `ip -br link`
- Apply MTU: `ip link set dev ib0 mtu 9000`
- Assign IPs: `ip addr add <SPARK_ONE_IB>/24 dev ib0` on `<SPARK_ONE>`, `<SPARK_TWO_IB>/24` on `<SPARK_TWO>`
- Routes: `ip route add <SPARK_IB_SUBNET>/24 dev ib0`

## Link Tests
- Ping MTU: `ping -I ib0 -s 8972 <SPARK_TWO_IB>` (from `<SPARK_ONE>` to `<SPARK_TWO>`)
- IB perf: `ib_write_bw -d mlx5_0 -F` / `ib_read_bw -d mlx5_0 -F`
- TCP perf: `iperf3 -c <SPARK_TWO_IB> -B <SPARK_ONE_IB> -P 4 -t 10`

## Notes
- Keep hostnames consistent with `NCCL_SOCKET_IFNAME`.
- Align `/etc/hosts` or DNS entries for `<SPARK_ONE>` and `<SPARK_TWO>`.
- Persist settings via netplan/systemd-networkd as appropriate.
