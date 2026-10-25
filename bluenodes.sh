#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31m❌ Please run as root: sudo bash bn.sh\e[0m"
    exit 1
fi

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Boxed Task Runner
run_task() {
    local task_name=$1
    local command_to_run=$2
    
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    # Start command in background
    eval "$command_to_run" > /dev/null 2>&1 &
    local pid=$!
    
    # Animate while running
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 10 ))
        printf "\r  ${CYAN}%-35s${NC} [${YELLOW}${spinstr:$i:1}${NC}]" "$task_name"
        sleep 0.1
    done
    
    wait $pid
    local status=$?
    
    if [ $status -eq 0 ]; then
        printf "\r  ${GREEN}✓ %-35s [DONE]${NC}\n" "$task_name"
    else
        printf "\r  ${YELLOW}➜ %-35s [SKIPPED]${NC}\n" "$task_name"
    fi
}

# Main Menu Function
show_main_menu() {
    clear
    echo -e "${RED}"
    echo "  ____  _     _   _ _____ _   _  ___  ____  _____ ____  "
    echo " | __ )| |   | | | | ____| \ | |/ _ \|  _ \| ____/ ___| "
    echo " |  _ \| |   | | | |  _| |  \| | | | | | | |  _| \___ \ "
    echo " | |_) | |___| |_| | |___| |\  | |_| | |_| | |___ ___) |"
    echo " |____/|_____|\___/|_____|_| \_|\___/|____/|_____|____/ "
    echo -e "${NC}"
    
    echo -e "${BLUE}  ┌─────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}  │${CYAN}                     Made By BLUE                      ${BLUE}│${NC}"
    echo -e "${BLUE}  ├─────────────────────────────────────────────────────┤${NC}"
    echo -e "${BLUE}  │${YELLOW}  A)${NC} Installer                                       ${BLUE}│${NC}"
    echo -e "${BLUE}  │${YELLOW}  B)${NC} Pannel                                          ${BLUE}│${NC}"
    echo -e "${BLUE}  │${YELLOW}  C)${NC} Exit                                            ${BLUE}│${NC}"
    echo -e "${BLUE}  └─────────────────────────────────────────────────────┘${NC}"
    echo ""
    read -p "  Select -> " option

    option=$(echo "$option" | tr '[:lower:]' '[:upper:]')

    case $option in
        A) run_installer ;;
        B) show_panel_menu ;;
        C) echo -e "${RED}  Exiting...${NC}"; exit 0 ;;
        *) echo -e "${RED}  Invalid option! Please enter A, B or C.${NC}"; sleep 2; show_main_menu ;;
    esac
}

# Installer Function
run_installer() {
    clear
    echo -e "${CYAN}"
    echo "  ┌─────────────────────────────────────────────────────┐"
    echo "  │           BLUENODES INSTALLATION STARTED            │"
    echo "  └─────────────────────────────────────────────────────┘"
    echo -e "${NC}"
    
    export DEBIAN_FRONTEND=noninteractive

    run_task "System Update" "apt-get update -y"
    run_task "System Upgrade" "apt-get upgrade -y -o Dpkg::Options::=\"--force-confold\""
    run_task "Installing Basic Tools" "apt-get install -y curl wget git htop nano ufw"
    run_task "Installing Docker Engine" "apt-get install -y docker.io"
    run_task "Installing Neofetch" "apt-get install -y neofetch || (curl -sL https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -o /usr/bin/neofetch && chmod +x /usr/bin/neofetch)"
    
    echo ""
    echo -e "${BLUE}  ─────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}   Here is your system information:${NC}"
    echo ""
    
    if command -v neofetch &> /dev/null; then
        neofetch
    else
        echo -e "${RED}  ⚠ Neofetch could not be installed.${NC}"
    fi
    
    echo ""
    read -p "  Press Enter to return to Main Menu..." 
    show_main_menu
}

# Panel Menu Function
show_panel_menu() {
    clear
    echo -e "${CYAN}"
    echo "  ┌─────────────────────────────────────────────────────┐"
    echo "  │                  PANNEL INSTALLER                   │"
    echo "  ├─────────────────────────────────────────────────────┤"
    echo -e "${CYAN}  │${YELLOW}  A)${NC} Install JTG Pannel                              ${CYAN}│${NC}"
    echo -e "${CYAN}  │${YELLOW}  B)${NC} Back to Main Menu                               ${CYAN}│${NC}"
    echo "  └─────────────────────────────────────────────────────┘"
    echo -e "${NC}"
    echo ""
    read -p "  Select -> " panel_option

    panel_option=$(echo "$panel_option" | tr '[:lower:]' '[:upper:]')

    case $panel_option in
        A)
            clear
            echo -e "${CYAN}"
            echo "  ┌─────────────────────────────────────────────────────┐"
            echo "  │              JTG PANNEL INSTALLATION                │"
            echo "  └─────────────────────────────────────────────────────┘"
            echo -e "${NC}"
            
            bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Jtg/refs/heads/main/install.sh)
            
            echo ""
            echo -e "${GREEN}  ✓ JTG Pannel install process finished!${NC}"
            read -p "  Press Enter to return to Main Menu..."
            show_main_menu
            ;;
        B)
            show_main_menu
            ;;
        *)
            echo -e "${RED}  Invalid option! Please enter A or B.${NC}"
            sleep 2
            show_panel_menu
            ;;
    esac
}

# Start
show_main_menu
