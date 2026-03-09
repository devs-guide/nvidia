# NOTES: _DGX SPARK_ 


### Vanilla Factor Instal: First Boot Login
> Brand: `MSI`

- `nvtop` wasn't installed!

| Nominal drive size | Expected `/` size shown (approx.) | Est. used at first boot (approx.) | Expected `Usage of /` |
| -----------------: | --------------------------------: | --------------------------------: | --------------------: |
|               1 TB |                         0.9175 TB |                          0.356 TB |     38.8% of 0.9175TB |
|               2 TB |                          1.835 TB |                          0.356 TB |      19.4% of 1.835TB |
|               4 TB |                           3.67 TB |                          0.356 TB |        9.7% of 3.67TB |
|               8 TB |                           7.34 TB |                          0.356 TB |       4.85% of 7.34TB |

``
nvidia@spark:~/scripts$ df -h ~
Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme0n1p2  3.7T  365G  3.2T  11% /

``

- `hostnamectl`:
```
nvidia@edgexpert-7f05:~$ hostnamectl
 Static hostname: spark
       Icon name: computer-desktop
         Chassis: desktop 🖥️
      Machine ID: 295f5139615f4bbaa29921a29574c7a3
         Boot ID: 18159d36f6034814aadcd70fabdd4b4d
Operating System: Ubuntu 24.04.4 LTS              
          Kernel: Linux 6.17.0-1008-nvidia
    Architecture: arm64
 Hardware Vendor: MSI
  Hardware Model: MS-C931
Firmware Version: 5.36_1.0.0
   Firmware Date: Thu 2025-09-25
    Firmware Age: 5month 4d
```

```
Welcome to NVIDIA DGX Spark Version 7.4.0 (GNU/Linux 6.17.0-1008-nvidia aarch64)

 System information as of Sun Mar  1 02:57:02 AM UTC 2026

  System load:  1.0              Temperature:             51.7 C
  Usage of /:   9.7% of 3.67TB   Processes:               514
  Memory usage: 3%               Users logged in:         1
  Swap usage:   0%               IPv4 address for enP7s7: <SPARK_LAN_IP>

2 devices have a firmware upgrade available.
Run `fwupdmgr get-upgrades` for more information.

Last login: Sun Mar  1 02:38:21 2026 from <SPARK_LAN_IP>
```
- `ip -br addr`: 
```
lo               UNKNOWN        127.0.0.1/8 ::1/128 
enP7s7           UP             <SPARK_LAN_IP>/24 fe80::bd2c:fc4e:a224:b1d5/64 
enp1s0f0np0      DOWN           
enp1s0f1np1      DOWN           
enP2p1s0f0np0    DOWN           
enP2p1s0f1np1    DOWN           
wlP9s9           DOWN           
docker0          DOWN           172.17.0.1/16 

```

- `systemctl is-active NetworkManager && echo "NetworkManager active"`:
- `nmcli device status`:
	
```
nvidia@spark:~$ nmcli device status
DEVICE          TYPE      STATE                   CONNECTION         
enP7s7          ethernet  connected               Wired connection 3 
lo              loopback  connected (externally)  lo                 
docker0         bridge    connected (externally)  docker0            
wlP9s9          wifi      disconnected            --                 
p2p-dev-wlP9s9  wifi-p2p  disconnected            --                 
enP2p1s0f0np0   ethernet  unavailable             --                 
enP2p1s0f1np1   ethernet  unavailable             --                 
enp1s0f0np0     ethernet  unavailable             --                 
enp1s0f1np1     ethernet  unavailable             --                 
nvidia@spark:~$ nmcli connection show
NAME                UUID                                  TYPE      DEVICE  
Wired connection 3  da5e4064-6734-3ab6-b068-998ea5cfacfd  ethernet  enP7s7  
lo                  62736b51-a089-40f1-873d-c5b334d7a9f4  loopback  lo      
docker0             7f71530f-c0dc-4429-a615-e1379a029927  bridge    docker0 
Wired connection 1  ae2eda54-1101-3643-b58e-c491e2c699a2  ethernet  --      
Wired connection 2  5f7e0f13-a3ba-3b58-b381-6f07b011f942  ethernet  --      
Wired connection 4  384ff088-7b68-3ae3-92b2-3a61da140a05  ethernet  --      
Wired connection 5  e6cefd12-14f3-37da-b030-4a1a477dd4bf  ethernet  --      ```


### Set Static IP:
	
```
Option A (preferred): NetworkManager (nmcli) persistent config
# Identify the NetworkManager connection profile bound to enP7s7
CONN="$(nmcli -g GENERAL.CONNECTION device show enP7s7)"
echo "$CONN"
# Set static IPv4 on that connection (no gateway; avoids stealing default route)
CONN="$(nmcli -g GENERAL.CONNECTION device show enP7s7)"
echo "Using connection: $CONN"

# Set static IP + gateway + DNS (adjust gateway/DNS for your LAN)
sudo nmcli connection modify "$CONN" \
  ipv4.addresses "<SPARK_LAN_IP>/24" \
  ipv4.gateway "<LAN_GATEWAY_IP>" \
  ipv4.dns "<LAN_DNS_IP> 1.1.1.1" \
  ipv4.method manual \
  ipv4.never-default no \
  ipv6.method disabled

sudo nmcli connection down "$CONN"
sudo nmcli connection up "$CONN"
Verify
# Apply changes
sudo nmcli connection down "$CONN"
sudo nmcli connection up "$CONN"
# Verify
ip -br addr show enP7s7
ping -c 3 <PEER_LAN_IP>
```




### 10GBE Transfer Test

- `sudo ethtool enP7s7 | egrep -i 'Speed:|Duplex:|Link detected:'`
- `ip -br addr show enP7s7`
- `ip route get <PEER_LAN_IP>`
- `sudo apt-get install -y iperf3sudo apt-get install -y iperf3
- iperf3 -s -p 8080
- iperf3 -c <SPARK_LAN_IP> -p 8080


### 10gbe Sanity Check:
- ip route show default
- resolvectl status
- getent hosts ports.ubuntu.com
- sudo apt-get update

sudo iftop enP7s7


### RSYNC
``
rsync \
  --dry-run \
  --archive \
  --hard-links \
  --acls \
  --xattrs \
  --human-readable \
  --whole-file \
  --partial \
  --partial-dir=.rsync-partial \
  --delay-updates \
  --info=NAME,STATS2,PROGRESS2,SKIP2 \
  --itemize-changes \
  --stats \
  --rsh='ssh -T -o Compression=no -c aes128-gcm@openssh.com' \
  /media/gpt/ \
  nvidia@<SPARK_LAN_IP>:~/gpt/
``


### 

docker exec -it ollama ollama list
docker exec -it ollama ollama ps
docker stats


###

sudo apt install -y npm python3-venv python3-full


### Create VENV correctly (permissions)
# check who owns pip
# while (venv) is shown in the prompt, confirm PATH is correct
command -v python3
command -v python
command -v pip
python3 -c "import sys; print('executable:', sys.executable); print('prefix:', sys.prefix)"


sudo apt update
sudo apt install -y python3-venv python3-full
deactivate 2>/dev/null || true
rm -rf ./venv
python3 -m venv ./venv
source ./venv/bin/activate


# ensure pip exists inside the venv
python -m ensurepip --upgrade

# now upgrade pip (and commonly-needed build tooling) inside the venv
python -m pip install --upgrade pip setuptools wheel
