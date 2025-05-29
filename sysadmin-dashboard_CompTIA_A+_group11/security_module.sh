#!/bin/bash

#====================#
# 🌐 Security Module #
#====================#

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

#===========================#
# 🔐 Security Function Core #
#===========================#

authenticate_user() {
    echo -ne "${CYAN}Enter admin password to proceed: ${NC}"
    read -s entered_pass
    echo

    local correct_pass="admin123"  # 🔒 Note: Replace with a secure method in production

    if [[ "$entered_pass" != "$correct_pass" ]]; then
        echo -e "${RED}❌ Authentication failed.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Authentication successful.${NC}"
}

check_permissions() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}⚠️  This operation requires root. Please run with sudo.${NC}"
        exit 1
    fi
}

harden_system() {
    echo -e "${CYAN}🔧 Applying system hardening...${NC}"

    # SSH config
    if [[ -f /etc/ssh/sshd_config ]]; then
        sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
        echo -e "${GREEN}✔ Root SSH login disabled.${NC}"
    else
        echo -e "${YELLOW}⚠️  SSH config not found. Skipping SSH hardening.${NC}"
    fi

    # Disable unnecessary services
    systemctl disable bluetooth 2>/dev/null && echo -e "${GREEN}✔ Bluetooth disabled.${NC}"
    systemctl disable cups 2>/dev/null && echo -e "${GREEN}✔ Printing service disabled.${NC}"

    # Firewall settings
    if command -v ufw &> /dev/null; then
        ufw --force enable >/dev/null 2>&1
        ufw default deny incoming
        ufw default allow outgoing
        echo -e "${GREEN}✔ Firewall configured to deny all incoming traffic.${NC}"
    else
        echo -e "${YELLOW}⚠️  UFW not installed. Skipping firewall configuration.${NC}"
    fi

    echo -e "${GREEN}✅ Basic hardening complete.${NC}"
}

security_audit() {
    echo -e "${CYAN}📋 Running security audit...${NC}"

    echo -n "1. Checking root SSH login: "
    if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
        echo -e "${GREEN}✔ Disabled${NC}"
    else
        echo -e "${RED}✘ Enabled${NC}"
    fi

    echo -e "\n2. 🔥 Firewall status:"
    if command -v ufw &> /dev/null; then
        ufw status
    else
        echo -e "${YELLOW}⚠️  UFW not found.${NC}"
    fi

    echo -e "\n3. 🌍 World-writable files (Top 10):"
    find / -type f -perm -0002 -ls 2>/dev/null | head -n 10

    echo -e "\n4. 🧑‍🤝‍🧑 Users with empty passwords:"
    awk -F: '($2 == "") { print "⚠️  " $1 }' /etc/shadow || echo "No issues found."

    echo -e "\n${GREEN}✅ Audit complete.${NC}"
}

#===========================#
# 📜 Interactive Menu Loop #
#===========================#

while true; do
    echo -e "\n🔐 ${GREEN}SECURITY MODULE${NC}"
    echo "1. 🔑 Authenticate"
    echo "2. 🛂 Check Root Permissions"
    echo "3. 🛡️  Harden System"
    echo "4. 🧾 Run Security Audit"
    echo "5. 🚪 Exit"
    read -rp "Choose an option [1-5]: " choice

    case "$choice" in
        1) authenticate_user ;;
        2) check_permissions ;;
        3) check_permissions && authenticate_user && harden_system ;;
        4) check_permissions && security_audit ;;
        5) echo -e "${CYAN}Exiting Security Module. Stay safe.${NC}"; break ;;
        *) echo -e "${RED}❌ Invalid choice. Try again.${NC}" ;;
    esac
done
