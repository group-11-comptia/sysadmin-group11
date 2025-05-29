#!/bin/bash

#===============#
# Color Palette #
#===============#
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

while true; do
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════╗"
    echo "║          🔧 SERVICE CONTROL CENTER         ║"
    echo "╠════════════════════════════════════════════╣"
    echo -e "${NC}${WHITE} 1${NC}. ${YELLOW}List All Services${NC}"
    echo -e "${WHITE} 2${NC}. ${YELLOW}Filter Services (Running/Stopped)${NC}"
    echo -e "${WHITE} 3${NC}. ${YELLOW}Control a Service (Start/Stop/Restart/Reload)${NC}"
    echo -e "${WHITE} 4${NC}. ${YELLOW}Enable/Disable Service at Boot${NC}"
    echo -e "${WHITE} 5${NC}. ${YELLOW}View Detailed Service Info${NC}"
    echo -e "${WHITE} 6${NC}. ${YELLOW}Display Service Dependencies${NC}"
    echo -e "${WHITE} 7${NC}. ${RED}Return to Main Menu${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
    read -p "$(echo -e "${WHITE}Choose an option [1-7]: ${NC}")" option

    case $option in
        1)
            echo -e "\n${GREEN}📋 Listing all services...${NC}\n"
            systemctl list-units --type=service --all
            read -p $'\n🔙 Press enter to return...'
            ;;
        2)
            echo -e "\n${CYAN}📂 Filter Options:${NC}"
            echo -e "${WHITE} 1${NC}. ${GREEN}Running Services${NC}"
            echo -e "${WHITE} 2${NC}. ${RED}Stopped Services${NC}"
            read -p "$(echo -e "${WHITE}Choose an option [1-2]: ${NC}")" status_choice
            if [ "$status_choice" == "1" ]; then
                echo -e "\n${GREEN}⚡ Active Services:${NC}\n"
                systemctl list-units --type=service --state=running
            elif [ "$status_choice" == "2" ]; then
                echo -e "\n${RED}🛑 Inactive Services:${NC}\n"
                systemctl list-units --type=service --state=dead
            else
                echo -e "${RED}❌ Invalid selection.${NC}"
            fi
            read -p $'\n🔙 Press enter to return...'
            ;;
        3)
            read -p "$(echo -e "${WHITE}Enter the service name: ${NC}")" svc
            echo -e "${CYAN}⚙ Available Actions:${NC}"
            echo -e "${WHITE} 1${NC}. ${GREEN}Start${NC}"
            echo -e "${WHITE} 2${NC}. ${RED}Stop${NC}"
            echo -e "${WHITE} 3${NC}. ${YELLOW}Restart${NC}"
            echo -e "${WHITE} 4${NC}. ${CYAN}Reload${NC}"
            read -p "$(echo -e "${WHITE}Select action [1-4]: ${NC}")" act
            case $act in
                1) sudo systemctl start "$svc" && echo -e "${GREEN}✅ $svc started.${NC}" ;;
                2) sudo systemctl stop "$svc" && echo -e "${RED}⛔ $svc stopped.${NC}" ;;
                3) sudo systemctl restart "$svc" && echo -e "${YELLOW}🔁 $svc restarted.${NC}" ;;
                4) sudo systemctl reload "$svc" && echo -e "${CYAN}🔄 $svc reloaded.${NC}" ;;
                *) echo -e "${RED}❌ Invalid action.${NC}" ;;
            esac
            read -p $'\n🔙 Press enter to return...'
            ;;
        4)
            read -p "$(echo -e "${WHITE}Enter the service name: ${NC}")" svc
            echo -e "${CYAN}🕓 Boot Options:${NC}"
            echo -e "${WHITE} 1${NC}. ${GREEN}Enable at Boot${NC}"
            echo -e "${WHITE} 2${NC}. ${RED}Disable at Boot${NC}"
            read -p "$(echo -e "${WHITE}Choose [1-2]: ${NC}")" bootopt
            if [ "$bootopt" == "1" ]; then
                sudo systemctl enable "$svc" && echo -e "${GREEN}✅ $svc enabled at boot.${NC}"
            elif [ "$bootopt" == "2" ]; then
                sudo systemctl disable "$svc" && echo -e "${RED}⛔ $svc disabled at boot.${NC}"
            else
                echo -e "${RED}❌ Invalid choice.${NC}"
            fi
            read -p $'\n🔙 Press enter to return...'
            ;;
        5)
            read -p "$(echo -e "${WHITE}Enter the service name: ${NC}")" svc
            echo -e "\n${CYAN}🔍 Status of ${WHITE}$svc${NC}:\n"
            systemctl status "$svc"
            read -p $'\n🔙 Press enter to return...'
            ;;
        6)
            read -p "$(echo -e "${WHITE}Enter the service name: ${NC}")" svc
            echo -e "\n${CYAN}🔗 Dependencies for ${WHITE}$svc${NC}:\n"
            systemctl list-dependencies "$svc"
            read -p $'\n🔙 Press enter to return...'
            ;;
        7)
            echo -e "${YELLOW}↩ Returning to main menu...${NC}"
            break
            ;;
        *)
            echo -e "${RED}❌ Invalid option. Please try again.${NC}"
            sleep 1
            ;;
    esac
done
