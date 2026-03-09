### vanilla boot:

### host:
- `hostnamectl`
- lsb_release -a
- uname -r
- apt list --upgradable
 Static hostname: aitopatom-ca9b
       Icon name: computer-server
         Chassis: server 🖳
      Machine ID: 31047621097d41a8b71b09cc5c346398
         Boot ID: 18a7e8462bb8444f864d95abe9a61f20
Operating System: Ubuntu 24.04.4 LTS              
          Kernel: Linux 6.17.0-1008-nvidia
    Architecture: arm64
 Hardware Vendor: GIGABYTE
  Hardware Model: AI TOP ATOM
Firmware Version: 5.36_0.0.3
   Firmware Date: Wed 2025-10-08
    Firmware Age: 4month 3w 6d

### update exisiting dependencies
- `sudo apt install --only-upgrade $(apt list --upgradable 2>/dev/null | awk 'NR>1 {print $1}' | cut -d/ -f1)`

### Apply the Ubuntu / DGX OS package updates.
hostnamectl
uname -r
lsb_release -a
apt list --upgradable
sudo dmidecode -t bios | sed -n '1,40p'
sudo fwupdmgr get-devices
sudo fwupdmgr get-updates
sudo apt update
sudo apt dist-upgrade -y
sudo apt autoremove --purge -y
sudo reboot


### storage on boot:
 - `df -h`
--------
Filesystem      Size  Used Avail Use% Mounted on
tmpfs            12G  2.6M   12G   1% /run
efivarfs        256K   19K  238K   8% /sys/firmware/efi/efivars
/dev/nvme0n1p2  468G   47G  399G  11% /
tmpfs            60G     0   60G   0% /dev/shm
tmpfs           5.0M  8.0K  5.0M   1% /run/lock
/dev/nvme0n1p1  511M  6.4M  505M   2% /boot/efi
tmpfs            12G  160K   12G   1% /run/user/1000
--------


### STATIC IP:
# Show link/IP status briefly
ip -br addr

# Show NetworkManager device state
nmcli device status

# Show the connection profile bound to enP7s7
ETHERNET="$(nmcli -g GENERAL.CONNECTION device show enP7s7)"

echo "Using connection profile: ${ETHERNET}"

# Show the current profile settings for reference
nmcli connection show "${ETHERNET}"

# Example values
IFACE="enP7s7"
IPV4_ADDR="<SPARK_LAN_IP>/24"
GATEWAY="<LAN_GATEWAY_IP>"
DNS_IP="<LAN_DNS_IP> 1.1.1.1"

# Discover the active profile attached to the interface
CONNECTION="$(nmcli -g GENERAL.CONNECTION device show "$IFACE")"
echo "Interface: $IFACE"
echo "Connection profile: $CONNECTION"
echo "Static IPv4: $IPV4_ADDR"
echo "Gateway: $GATEWAY"
echo "DNS: $DNS_IP"


# Save the current NetworkManager profile details to a text file
nmcli connection show "$CONNECTION" > "$HOME/$CONNECTION// /_}.default.static.ip.txt"

# Optional: also save device details
nmcli device show "$IFACE" > "$HOME/${IFACE}.device-details.txt"

# Primary-LAN static IPv4 profile
# - ipv4.method manual = static IPv4
# - ipv4.addresses     = address/prefix
# - ipv4.gateway       = default gateway for normal outbound access
# - ipv4.dns           = DNS servers in preferred order
# - ipv4.never-default no = allow this NIC to be the default route
# - connection.autoconnect yes = reconnect automatically on boot
# - ipv6.method disabled = disable IPv6 on this profile

sudo nmcli connection modify "$CONNECTION" \
  connection.autoconnect yes \
  ipv4.method manual \
  ipv4.addresses "$IPV4_ADDR" \
  ipv4.gateway "$GATEWAY" \
  ipv4.dns "$DNS_IP" \
  ipv4.never-default no \
  ipv6.method disabled

# Bounce the connection so the new profile is applied
sudo nmcli connection down "$CONNECTION" &&  sudo nmcli connection up "$CONNECTION"

# Verify the interface now has the expected static IPv4
ip -br addr show enP7s7

# Verify the route table
ip route

# Verify NetworkManager sees the profile as manual/static
nmcli -f GENERAL.CONNECTION,IP4.ADDRESS,IP4.GATEWAY,IP4.DNS device show enP7s7

# Verify the stored connection settings
nmcli -f ipv4.method,ipv4.addresses,ipv4.gateway,ipv4.dns,ipv4.never-default,ipv6.method connection show "$CONN"
### SET HOSTNAME
sudo hostnamectl set-hostname spark-one

# no command here
# connect spark-one <-> spark-two using the approved QSFP/CX7 cable

# after the cable is inserted, look for the interface that changes to UP
# then verify it directly (replace IFACE with the detected name)
IFACE=enP2p1s0f1np1
sudo ethtool "$IFACE" | egrep 'Speed|Duplex|Link detected'





- user: `nvidia`
- update to static-ip: 
# Verify GPU visibility (Should show B100/B200/Blackwell)
 - `nvidia-smi`
# Create working directory
 - `mkdir -p ~/gpt/spark/comfy`
 - `cd ~/gpt/spark/comfy`

# Install Python 3.11.9 if not present
 - `pyenv install -s 3.11.9`

# Create and activate virtualenv
 - `pyenv virtualenv 3.11.9 spark-comfy`
 - `pyenv local spark-comfy`

# Upgrade base tools
 - `pip install -U pip setuptools wheel`
 
