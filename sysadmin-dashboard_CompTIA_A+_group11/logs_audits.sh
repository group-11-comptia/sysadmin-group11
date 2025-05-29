#!/bin/bash

# ─────────────────────────────────────────────────────────────
# ✨ LOGGING & AUDITING MODULE (Improved Appearance)
# ─────────────────────────────────────────────────────────────

LOG_FILE="./logs/script_actions.log"
MAX_LOG_SIZE=102400  # 100 KB
VERBOSITY=1          # 0 = Silent, 1 = Normal, 2 = Verbose

# 🎨 Color Codes
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
RESET="\e[0m"
BOLD="\e[1m"

# 📂 Ensure logs directory exists
mkdir -p ./logs

# 🔁 Rotate logs if size exceeds limit
rotate_logs() {
    if [ -f "$LOG_FILE" ] && [ "$(stat -c%s "$LOG_FILE")" -ge "$MAX_LOG_SIZE" ]; then
        mv "$LOG_FILE" "${LOG_FILE}_$(date +%Y%m%d%H%M%S)"
        touch "$LOG_FILE"
    fi
}

# 🪵 Write to log file with optional colored output
log_action() {
    local status="$1"
    local action="$2"
    local user=$(whoami)
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[$timestamp] [$user] [$status] $action"
    
    echo "$message" >> "$LOG_FILE"

    if [ "$VERBOSITY" -ge 1 ]; then
        case "$status" in
            SUCCESS) echo -e "${GREEN}${message}${RESET}" ;;
            ERROR) echo -e "${RED}${message}${RESET}" ;;
            INFO) echo -e "${BLUE}${message}${RESET}" ;;
            *) echo "$message" ;;
        esac
    fi
}

# 🗣 Verbose log (only if VERBOSITY=2)
log_verbose() {
    if [ "$VERBOSITY" -ge 2 ]; then
        log_action "INFO" "$1"
    fi
}

# 👁 View logs
view_logs() {
    echo -e "${YELLOW}\n────────────── SCRIPT LOGS ──────────────${RESET}"
    less "$LOG_FILE"
}

# 🔘 Menu interface
logging_menu() {
    while true; do
        clear
        echo -e "${BOLD}${BLUE}╔═════════════════════════════════════════════════╗"
        echo -e "║            📝 LOGGING & AUDITING MODULE         ║"
        echo -e "╚═════════════════════════════════════════════════╝${RESET}"
        echo -e "${YELLOW}1.${RESET} View script logs"
        echo -e "${YELLOW}2.${RESET} Set verbosity level (${GREEN}0${RESET}: Silent, ${YELLOW}1${RESET}: Normal, ${BLUE}2${RESET}: Verbose)"
        echo -e "${YELLOW}3.${RESET} Back to main menu"
        echo
        read -p "Choose an option [1-3]: " choice

        case "$choice" in
            1)
                view_logs
                ;;
            2)
                read -p "Enter verbosity level (0/1/2): " level
                if [[ "$level" =~ ^[012]$ ]]; then
                    VERBOSITY="$level"
                    echo -e "${GREEN}✔ Verbosity set to $VERBOSITY${RESET}"
                else
                    echo -e "${RED}✖ Invalid input. Please enter 0, 1, or 2.${RESET}"
                fi
                sleep 1
                ;;
            3)
                break
                ;;
            *)
                echo -e "${RED}✖ Invalid option. Please try again.${RESET}"
                sleep 1
                ;;
        esac
    done
}

# 🔗 Example Usage
# log_action "SUCCESS" "User added to system"
# log_action "ERROR" "Failed to restart nginx"

# Optional auto-rotate on start
rotate_logs
