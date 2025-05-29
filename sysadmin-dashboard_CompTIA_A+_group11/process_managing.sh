#!/bin/bash

# ──────────────────────────────
# 🎭 PROCESS MANAGEMENT MODULE
# ──────────────────────────────

# Color definitions
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

while true; do
    clear
    echo -e "${BOLD}${CYAN}───────────── PROCESS MANAGEMENT MODULE ─────────────${NC}"
    echo -e "${YELLOW}1.${NC} Display top processes by CPU usage"
    echo -e "${YELLOW}2.${NC} Display top processes by Memory usage"
    echo -e "${YELLOW}3.${NC} Show process details for specific PID"
    echo -e "${YELLOW}4.${NC} Search for processes by name"
    echo -e "${YELLOW}5.${NC} Kill process by PID"
    echo -e "${YELLOW}6.${NC} Kill process by name"
    echo -e "${YELLOW}7.${NC} Monitor specific process in real-time"
    echo -e "${YELLOW}8.${NC} Show process tree"
    echo -e "${YELLOW}9.${NC} Return to Main Menu"
    echo -e "${BOLD}${CYAN}─────────────────────────────────────────────────────${NC}"
    read -rp "Choose an option [1-9]: " option

    case $option in
        1)
            echo -e "\n${GREEN}🌟 Top Processes by CPU Usage:${NC}\n"
            ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 15
            read -rp "Press Enter to continue..."
            ;;
        2)
            echo -e "\n${GREEN}🌟 Top Processes by Memory Usage:${NC}\n"
            ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 15
            read -rp "Press Enter to continue..."
            ;;
        3)
            read -rp "🔍 Enter PID: " pid
            if [[ $pid =~ ^[0-9]+$ ]]; then
                echo -e "\n${GREEN}Process details for PID $pid:${NC}"
                ps -p "$pid" -o pid,ppid,cmd,%cpu,%mem,etime
            else
                echo -e "${RED}Invalid PID.${NC}"
            fi
            read -rp "Press Enter to continue..."
            ;;
        4)
            read -rp "🔍 Enter process name to search: " name
            echo -e "\n${GREEN}Search results for \"$name\":${NC}"
            pgrep -af "$name"
            read -rp "Press Enter to continue..."
            ;;
        5)
            read -rp "🛑 Enter PID to kill: " pid
            read -rp "Enter signal (default is SIGTERM): " signal
            signal=${signal:-TERM}
            if kill "-$signal" "$pid" 2>/dev/null; then
                echo -e "${GREEN}Process $pid terminated with signal $signal.${NC}"
            else
                echo -e "${RED}Failed to kill process $pid.${NC}"
            fi
            read -rp "Press Enter to continue..."
            ;;
        6)
            read -rp "🛑 Enter process name to kill: " pname
            if pkill "$pname" 2>/dev/null; then
                echo -e "${GREEN}Processes named '$pname' terminated.${NC}"
            else
                echo -e "${RED}No such processes found for '$pname'.${NC}"
            fi
            read -rp "Press Enter to continue..."
            ;;
        7)
            read -rp "👁 Enter PID to monitor: " pid
            if [[ $pid =~ ^[0-9]+$ ]]; then
                echo -e "${YELLOW}Monitoring process $pid. Press Ctrl+C to stop.${NC}"
                watch -n 1 "ps -p $pid -o pid,ppid,cmd,%cpu,%mem,etime"
            else
                echo -e "${RED}Invalid PID.${NC}"
                read -rp "Press Enter to continue..."
            fi
            ;;
        8)
            echo -e "\n${GREEN}🌳 Process Tree:${NC}\n"
            pstree -p
            read -rp "Press Enter to continue..."
            ;;
        9)
            echo -e "${CYAN}Returning to main menu...${NC}"
            break
            ;;
        *)
            echo -e "${RED}❌ Invalid option. Try again.${NC}"
            read -rp "Press Enter to continue..."
            ;;
    esac
done
