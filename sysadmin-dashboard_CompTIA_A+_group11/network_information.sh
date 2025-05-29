#!/bin/bash

# ───────────────────────────────────────────────
# 🌐 NETWORK INFORMATION MODULE — Polished Edition
# ───────────────────────────────────────────────

# Color palette
CYAN="\e[36m"
YELLOW="\e[33m"
GREEN="\e[32m"
RED="\e[31m"
BOLD="\e[1m"
RESET="\e[0m"

while true; do
    clear
    echo -e "${BOLD}${CYAN}============================================${RESET}"
    echo -e "${BOLD}${CYAN}         🌐 NETWORK INFORMATION MODULE       ${RESET}"
    echo -e "${BOLD}${CYAN}============================================${RESET}"
    echo -e "${YELLOW}1.${RESET} Show IP configuration (all interfaces)"
    echo -e "${YELLOW}2.${RESET} Display routing table"
    echo -e "${YELLOW}3.${RESET} List active connections & open ports"
    echo -e "${YELLOW}4.${RESET} Perform connectivity tests (ping/traceroute)"
    echo -e "${YELLOW}5.${RESET} Display DNS settings & perform lookup"
    echo -e "${YELLOW}6.${RESET} Monitor network traffic statistics"
    echo -e "${YELLOW}7.${RESET} Display ARP table"
    echo -e "${YELLOW}8.${RESET} Return to main menu"
    echo -e "${BOLD}${CYAN}============================================${RESET}"

    read -p "Choose an option [1-8]: " option

    case $option in
        1)
            echo -e "\n${GREEN}🧭 IP Configuration:${RESET}\n"
            ip a
            read -p $'\nPress enter to continue...'
            ;;
        2)
            echo -e "\n${GREEN}🗺 Routing Table:${RESET}\n"
            ip route
            read -p $'\nPress enter to continue...'
            ;;
        3)
            echo -e "\n${GREEN}🔓 Active Connections & Open Ports:${RESET}\n"
            sudo ss -tulnp
            read -p $'\nPress enter to continue...'
            ;;
        4)
            echo -e "\n${GREEN}📡 Connectivity Tests:${RESET}\n"
            read -p "Enter a hostname or IP to ping: " host
            ping -c 4 "$host"
            echo -e "\n${YELLOW}Now performing traceroute...${RESET}"
            traceroute "$host"
            read -p $'\nPress enter to continue...'
            ;;
        5)
            echo -e "\n${GREEN}🔍 DNS Settings:${RESET}\n"
            cat /etc/resolv.conf
            read -p "Enter a domain to lookup (e.g., google.com): " domain
            echo -e "\n${YELLOW}Performing DNS lookup...${RESET}\n"
            nslookup "$domain"
            read -p $'\nPress enter to continue...'
            ;;
        6)
            echo -e "\n${GREEN}📈 Network Traffic Statistics:${RESET}\n"
            if command -v ifstat >/dev/null; then
                ifstat 1 5
            else
                echo -e "${RED}Tool 'ifstat' not installed. Using 'ip -s link' as fallback.${RESET}\n"
                ip -s link
            fi
            read -p $'\nPress enter to continue...'
            ;;
        7)
            echo -e "\n${GREEN}🧾 ARP Table:${RESET}\n"
            ip neigh
            read -p $'\nPress enter to continue...'
            ;;
        8)
            break
            ;;
        *)
            echo -e "${RED}❌ Invalid choice. Try again.${RESET}"
            sleep 1
            ;;
    esac
done
