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

    # Convert to uppercase if user types lowercase
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

    echo -e "${YELLOW}[*] Updating system, please wait...${NC}"
    apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1

    echo -e "${YELLOW}[*] Installing essential packages...${NC}"
    apt install -y neofetch curl wget git htop ufw nano > /dev/null 2>&1

    echo ""
    echo -e "${GREEN}✓ All packages installed successfully!${NC}"
    echo -e "${BLUE}=======================================================${NC}"
    echo ""
    
    echo -e "${CYAN}Here is your system information:${NC}"
    sleep 1
    neofetch
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
            echo -e "${YELLOW}[*] Installing JTG Pannel... Please wait.${NC}"
            echo ""
            # Running the JTG Installer command
            bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Jtg/refs/heads/main/install.sh)
            echo ""
            echo -e "${GREEN}✓ JTG Pannel installation process finished!${NC}"
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
