#!/bin/bash

#==============#
#  🎨 Colors   #
#==============#
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RED='\033[1;31m'
NC='\033[0m' # Reset

section_header() {
  echo -e "\n${CYAN}╭──────────────────────────────────────────────╮"
  echo -e "│ 🔷  ${WHITE}$1${CYAN}"
  echo -e "╰──────────────────────────────────────────────╯${NC}"
}

divider() {
  echo -e "${YELLOW}────────────────────────────────────────────────────${NC}"
}

#===============#
# 🚀 Begin Run  #
#===============#
clear
echo -e "${GREEN}💻 SYSTEM INFORMATION DASHBOARD${NC}"
divider

# 1. OS Distribution and Version
section_header "OS Distribution and Version"
if [ -f /etc/os-release ]; then
  source /etc/os-release
  echo -e "${WHITE}Name     :${NC} $NAME"
  echo -e "${WHITE}Version  :${NC} $VERSION"
else
  echo -e "${RED}⚠ OS release info not found.${NC}"
fi

# 2. Kernel Version and Architecture
section_header "Kernel Version & Architecture"
echo -e "${WHITE}$(uname -srmo)${NC}"

# 3. Hostname and Uptime
section_header "Hostname and Uptime"
echo -e "${WHITE}Hostname :${NC} $(hostname)"
echo -e "${WHITE}Uptime   :${NC} $(uptime -p)"

# 4. CPU Information
section_header "CPU Information"
lscpu | grep -E "Model name|Socket|Core|MHz" | sed 's/^[ \t]*//' | while read -r line; do
  echo -e "${WHITE}${line}${NC}"
done

# 5. Memory Usage
section_header "Memory Usage"
free -h | awk 'NR==1 || /Mem:/ { printf "%s\n", $0 }' | sed 's/^/  /'

# 6. Swap Usage
section_header "Swap Usage"
free -h | awk '/Swap:/ { printf "%s\n", $0 }' | sed 's/^/  /'

# 7. Disk Utilization
section_header "Disk Utilization"
df -hT -x tmpfs -x devtmpfs | sed 's/^/  /'

# 8. Load Averages
section_header "System Load (1, 5, 15 min)"
uptime | awk -F'load average:' '{ print $2 }' | sed 's/^/  /'

# 9. Temperature Readings
section_header "Temperature Sensors"
if command -v sensors >/dev/null 2>&1; then
  sensors | grep -i 'temp' | sed 's/^/  /'
else
  echo -e "  ${RED}Temperature data not available. Install 'lm-sensors'.${NC}"
fi

divider
echo -e "${GREEN}✅ System Snapshot Complete.${NC}\n"
