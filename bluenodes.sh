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

# Main Menu Function
show_main_menu() {
    clear
    
    # Big Red Text (BLUENODES)
    echo -e "${RED}"
    echo "  ____  _     _   _ _____ _   _  ___  ____  _____ ____  "
    echo " | __ )| |   | | | | ____| \ | |/ _ \|  _ \| ____/ ___| "
    echo " |  _ \| |   | | | |  _| |  \| | | | | | | |  _| \___ \ "
    echo " | |_) | |___| |_| | |___| |\  | |_| | |_| | |___ ___) |"
    echo " |____/|_____|\___/|_____|_| \_|\___/|____/|_____|____/ "
    echo -e "${NC}"
    
    # Red Lines & Made By
    echo -e "${RED}=======================================================${NC}"
    echo -e "${CYAN}                     Made By BLUE                      ${NC}"
    echo -e "${RED}=======================================================${NC}"
    
    # Menu Options
    echo -e "  ${RED}---- MAIN MENU ----${NC}"
    echo -e "${YELLOW}A)${NC} Installer"
    echo -e "${YELLOW}B)${NC} Pannel"
    echo -e "${YELLOW}C)${NC} Exit"
    echo -e "${RED}-------------------------------------------------------${NC}"
    echo ""
    read -p "Select -> " option

    option=$(echo "$option" | tr '[:lower:]' '[:upper:]')

    case $option in
        A) run_installer ;;
        B) show_panel_menu ;;
        C) echo -e "${RED}Exiting...${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid option! Please enter A, B or C.${NC}"; sleep 2; show_main_menu ;;
    esac
}

# Installer Function
run_installer() {
    clear
    echo -e "${BLUE}=======================================================${NC}"
    echo -e "${CYAN}            BLUENODES INSTALLATION STARTED               ${NC}"
    echo -e "${BLUE}=======================================================${NC}"
    echo ""
    
    export DEBIAN_FRONTEND=noninteractive

    # Step 1: Update
    echo -e "${YELLOW}Updating system... Please wait.${NC}"
    apt-get update -y > /dev/null 2>&1
    echo -e "${GREEN}✓ apt update complete${NC}"
    echo ""

    echo -e "${YELLOW}Upgrading system... Please wait.${NC}"
    apt-get upgrade -y -o Dpkg::Options::="--force-confold" > /dev/null 2>&1
    echo -e "${GREEN}✓ apt upgrade complete${NC}"
    echo ""

    # Step 2: Basic Tools
    echo -e "${YELLOW}Installing basic tools (curl, wget, git, htop, nano, ufw)...${NC}"
    apt-get install -y curl wget git htop nano ufw > /dev/null 2>&1
    echo -e "${GREEN}✓ basic tools install complete${NC}"
    echo ""

    # Step 3: Docker
    echo -e "${YELLOW}Installing Docker... Please wait.${NC}"
    apt-get install -y docker.io > /dev/null 2>&1
    echo -e "${GREEN}✓ apt install docker complete${NC}"
    echo ""

    # Step 4: System Info Tools (With proper logic)
    echo -e "${YELLOW}Installing System Info Tools...${NC}"
    
    # Install neofetch
    apt-get install -y neofetch > /dev/null 2>&1
    
    # Check if neofetch installed, else try fastfetch via PPA
    if ! command -v neofetch &> /dev/null; then
        apt-get install -y software-properties-common > /dev/null 2>&1
        add-apt-repository -y ppa:zhangsongcui3371/fastfetch > /dev/null 2>&1
        apt-get update -y > /dev/null 2>&1
        apt-get install -y fastfetch > /dev/null 2>&1
    fi

    echo -e "${GREEN}✓ fetch tools install complete${NC}"
    echo ""

    echo -e "${BLUE}=======================================================${NC}"
    echo -e "${CYAN}Here is your system information:${NC}"
    sleep 1
    
    if command -v neofetch &> /dev/null; then
        neofetch
    elif command -v fastfetch &> /dev/null; then
        fastfetch
    else
        echo -e "${RED}⚠ Neither neofetch nor fastfetch could be installed.${NC}"
        echo -e "${YELLOW}This might be due to restricted permissions in Codespace. It will work on a real VPS.${NC}"
    fi
    
    echo ""
    read -p "Press Enter to return to Main Menu..." 
    show_main_menu
}

# Panel Menu Function
show_panel_menu() {
    clear
    echo -e "${RED}=======================================================${NC}"
    echo -e "${CYAN}                 PANNEL INSTALLER                        ${NC}"
    echo -e "${RED}=======================================================${NC}"
    echo ""
    echo -e "  ${RED}---- PANEL MENU ----${NC}"
    echo -e "${YELLOW}A)${NC} Install JTG Pannel"
    echo -e "${YELLOW}B)${NC} Back to Main Menu"
    echo -e "${RED}-------------------------------------------------------${NC}"
    echo ""
    read -p "Select -> " panel_option

    panel_option=$(echo "$panel_option" | tr '[:lower:]' '[:upper:]')

    case $panel_option in
        A)
            clear
            echo -e "${YELLOW}Installing JTG Pannel... Please wait.${NC}"
            echo ""
            bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Jtg/refs/heads/main/install.sh)
            echo ""
            echo -e "${GREEN}✓ JTG Pannel install complete!${NC}"
            read -p "Press Enter to return to Main Menu..."
            show_main_menu
            ;;
        B)
            show_main_menu
            ;;
        *)
            echo -e "${RED}Invalid option! Please enter A or B.${NC}"
            sleep 2
            show_panel_menu
            ;;
    esac
}

# Start the script
show_main_menu
