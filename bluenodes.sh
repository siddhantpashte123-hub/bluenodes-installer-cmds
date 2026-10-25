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

# Spinning Loader Animation Function
spinner() {
    local text=$1
    local duration=$2
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local end=$((SECONDS + duration))
    
    # Hide cursor
    tput civis
    
    while [ $SECONDS -lt $end ]; do
        for i in $(seq 0 9); do
            printf "\r${YELLOW}${spinstr:$i:1} ${text}${NC}   "
            sleep 0.1
        done
    done
    printf "\r\033[K" # Clear the line
    tput cnorm # Show cursor
}

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
        A) 
            spinner "Loading Installer" 2
            run_installer 
            ;;
        B) 
            spinner "Opening Pannel Menu" 2
            show_panel_menu 
            ;;
        C) 
            echo -e "${RED}Exiting...${NC}"; 
            sleep 1;
            exit 0 
            ;;
        *) 
            echo -e "${RED}Invalid option! Please enter A, B or C.${NC}"; 
            sleep 2; 
            show_main_menu 
            ;;
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
    spinner "Updating system (apt update)" 3
    apt-get update -y > /dev/null 2>&1
    echo -e "${GREEN}✓ apt update complete${NC}"
    echo ""

    spinner "Upgrading system (apt upgrade)" 3
    apt-get upgrade -y -o Dpkg::Options::="--force-confold" > /dev/null 2>&1
    echo -e "${GREEN}✓ apt upgrade complete${NC}"
    echo ""

    # Step 2: Basic Tools
    spinner "Installing basic tools" 3
    apt-get install -y curl wget git htop nano ufw > /dev/null 2>&1
    echo -e "${GREEN}✓ basic tools install complete${NC}"
    echo ""

    # Step 3: Docker
    spinner "Installing Docker" 4
    apt-get install -y docker.io > /dev/null 2>&1
    echo -e "${GREEN}✓ apt install docker complete${NC}"
    echo ""

    # Step 4: Neofetch (Force Download Method)
    spinner "Installing Neofetch" 3
    
    apt-get install -y neofetch > /dev/null 2>&1
    
    if ! command -v neofetch &> /dev/null; then
        curl -sL https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -o /usr/bin/neofetch
        chmod +x /usr/bin/neofetch
    fi
    
    echo -e "${GREEN}✓ neofetch install complete${NC}"
    echo ""

    echo -e "${BLUE}=======================================================${NC}"
    echo -e "${CYAN}Here is your system information:${NC}"
    
    # Matrix-style animation before neofetch
    spinner "Generating System Report" 2
    
    if command -v neofetch &> /dev/null; then
        neofetch
    else
        echo -e "${RED}⚠ Neofetch could not be installed.${NC}"
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
            spinner "Preparing JTG Pannel installation" 3
            echo ""
            bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Jtg/refs/heads/main/install.sh)
            echo ""
            echo -e "${GREEN}✓ JTG Pannel install complete!${NC}"
            read -p "Press Enter to return to Main Menu..."
            show_main_menu
            ;;
        B)
            spinner "Going back" 1
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
