#!/bin/bash

# ===== Color codes =====
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

VERSION="1.0"
SCRIPT_DIR="$(dirname "$0")"

# ===== Fancy Banner =====
clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════╗"
echo "║      SYSTEM ADMIN DASHBOARD v$VERSION      ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# ===== Main Menu Loop =====
while true; do
  echo -e "${GREEN}Main Menu:${NC}"
  echo -e "${YELLOW}"
  echo " 1) System Information"
  echo " 2) User Management"
  echo " 3) Process Management"
  echo " 4) Service Management"
  echo " 5) Network Information"
  echo " 6) Log Analysis"
  echo " 7) Backup Utility"
  echo " 8) System Update"
  echo " 9) Error Handling & Input Validation"
  echo "10) Logging & Auditing"
  echo "11) Script Configuration"
  echo "12) Security Module"
  echo " H) Help"
  echo " X) Exit"
  echo -e "${NC}"

  read -p "Select an option: " choice

  case "$choice" in
    1) bash "$SCRIPT_DIR/system_info.sh" ;;
    2) bash "$SCRIPT_DIR/user_management.sh" ;;
    3) bash "$SCRIPT_DIR/process_management.sh" ;;
    4) bash "$SCRIPT_DIR/service_management.sh" ;;
    5) bash "$SCRIPT_DIR/network_info.sh" ;;
    6) bash "$SCRIPT_DIR/log_analysis.sh" ;;
    7) bash "$SCRIPT_DIR/backup_utility.sh" ;;
    8) bash "$SCRIPT_DIR/system_update.sh" ;;
    9) bash "$SCRIPT_DIR/error_handling.sh" ;;
    10) bash "$SCRIPT_DIR/logging_auditing.sh" ;;
    11) bash "$SCRIPT_DIR/script_config.sh" ;;
    12) bash "$SCRIPT_DIR/security_module.sh" ;;
    [Hh])
      echo -e "\n${CYAN}Help:${NC}"
      echo " Choose a number (1–12) to run a module."
      echo " 'X' to exit. Ensure each module exists and is executable."
      echo " All modules must be in the same directory as this script."
      echo ""
      ;;
    [Xx]) echo -e "${GREEN}Goodbye!${NC}"; break ;;
    *) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
  esac

  echo -e "\nPress [Enter] to return to the menu..."
  read
  clear
  echo -e "${CYAN}Welcome back to SYSTEM ADMIN DASHBOARD v$VERSION${NC}"
done
