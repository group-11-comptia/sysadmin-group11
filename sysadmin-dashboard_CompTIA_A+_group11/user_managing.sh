#!/bin/bash

# ========= Colors =========
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

VERSION="1.0"
LOG_FILE="/var/log/sysadmin_dashboard.log"

# ========= Signal Trap & Root Check =========
trap 'echo -e "\n${RED}Interrupted. Exiting...${NC}"; exit 1' SIGINT SIGTERM
if [[ "$EUID" -ne 0 ]]; then
  echo -e "${RED}This script must be run as root.${NC}"
  exit 1
fi

# ========= Utility Functions =========
log_action() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

pause() {
  read -rp "Press [Enter] to continue..."
}

print_section() {
  echo -e "${CYAN}=============================="
  echo -e "$1"
  echo -e "==============================${NC}"
}

# ========= Module: System Information =========
system_info() {
  print_section "System Information"
  echo "Hostname     : $(hostname)"
  echo "Uptime       : $(uptime -p)"
  echo "OS Release   : $(lsb_release -d | cut -f2)"
  echo "Kernel       : $(uname -r)"
  echo "Architecture : $(uname -m)"
  echo "CPU Load     : $(top -bn1 | grep 'load average' | awk '{print $10 $11 $12}')"
  echo ""
  log_action "Viewed system information"
  pause
}

# ========= Module: User Management =========
list_users() {
  print_section "All System Users"
  awk -F: '{ printf "%-20s UID: %-5s GID: %-5s HOME: %-20s SHELL: %s\n", $1, $3, $4, $6, $7 }' /etc/passwd
  echo ""
  pause
}

add_user() {
  read -rp "Enter new username: " username
  read -rp "Create home directory? (y/n): " create_home
  if id "$username" &>/dev/null; then
    echo -e "${RED}User already exists!${NC}"
  else
    if [[ "$create_home" == "y" ]]; then
      useradd -m "$username"
    else
      useradd "$username"
    fi
    echo "User '$username' created."
    passwd "$username"
    log_action "Created user: $username"
  fi
  pause
}

modify_user() {
  read -rp "Enter the username to modify: " username
  if ! id "$username" &>/dev/null; then
    echo -e "${RED}User does not exist!${NC}"
    pause
    return
  fi

  echo ""
  print_section "Modify User: $username"
  echo "1. Change password"
  echo "2. Add to group"
  echo "3. Remove from group"
  echo "4. Set account expiration"
  echo "5. Lock account"
  echo "6. Unlock account"
  read -rp "Choose an option [1-6]: " choice
  case $choice in
    1) passwd "$username" ;;
    2) read -rp "Enter group to add: " group
       usermod -aG "$group" "$username" ;;
    3) read -rp "Enter group to remove: " group
       gpasswd -d "$username" "$group" ;;
    4) read -rp "Enter expiration date (YYYY-MM-DD): " date
       chage -E "$date" "$username" ;;
    5) usermod -L "$username" ;;
    6) usermod -U "$username" ;;
    *) echo -e "${RED}Invalid option.${NC}" ;;
  esac
  log_action "Modified user: $username (Action $choice)"
  pause
}

user_info() {
  read -rp "Enter username to view: " username
  if id "$username" &>/dev/null; then
    print_section "Detailed Info for $username"
    id "$username"
    echo ""
    grep "^$username:" /etc/passwd
    chage -l "$username"
    log_action "Viewed info for user: $username"
  else
    echo -e "${RED}User not found.${NC}"
  fi
  pause
}

user_management() {
  while true; do
    clear
    echo -e "${GREEN}USER MANAGEMENT MODULE${NC}"
    echo "1. List all users"
    echo "2. Add a new user"
    echo "3. Modify user properties"
    echo "4. Display user info"
    echo "5. Return to main menu"
    echo ""
    read -rp "Choose an option [1-5]: " option
    case $option in
      1) list_users ;;
      2) add_user ;;
      3) modify_user ;;
      4) user_info ;;
      5) break ;;
      *) echo -e "${RED}Invalid choice. Try again.${NC}"; pause ;;
    esac
  done
}

# ========= Main Menu =========
while true; do
  clear
  echo -e "${CYAN}"
  echo "╔══════════════════════════════════════════╗"
  echo "║      SYSTEM ADMIN DASHBOARD v$VERSION      ║"
  echo "╚══════════════════════════════════════════╝"
  echo -e "${NC}"

  echo -e "${GREEN}Main Menu:${NC}"
  echo -e "${YELLOW}"
  echo " 1) System Information"
  echo " 2) User Management"
  echo " X) Exit"
  echo -e "${NC}"

  read -rp "Select an option: " choice

  case "$choice" in
    1) system_info ;;
    2) user_management ;;
    [Xx]) echo -e "${GREEN}Goodbye!${NC}"; log_action "Exited dashboard"; break ;;
    *) echo -e "${RED}Invalid option. Please try again.${NC}"; pause ;;
  esac
done
