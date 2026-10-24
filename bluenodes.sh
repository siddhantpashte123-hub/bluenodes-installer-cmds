#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31m❌ Please run as root: sudo bash bn.sh\e[0m"
    exit 1
fi

# Colors
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Main Menu Function
show_main_menu() {
    clear
    # Big BLUENODES ASCII Text
    echo -e "${BLUE}"
    echo " ____  _     _   _ _____ _   _  ___  ____  _____ ____  "
    echo "| __ )| |   | | | | ____| \ | |/ _ \|  _ \| ____/ ___| "
    echo "|  _ \| |   | | | |  _| |  \| | | | | | | |  _| \___ \ "
    echo "| |_) | |___| |_| | |___| |\  | |_| | |_| | |___ ___) |"
    echo "|____/|_____|\___/|_____|_| \_|\___/|____/|_____|____/ "
    echo -e "${NC}"
    
    # Made By BLUE
    echo -e "${RED}=======================================================${NC}"
    echo -e "${CYAN}                     Made By BLUE                      ${NC}"
    echo -e "${RED}=======================================================${NC}"
    
    # Menu Options (Jishnu style)
    echo -e "  ${LIGHT_BLUE}---- MAIN MENU ----${NC}"
    echo -e "${YELLOW}A)${NC} Basic Installer"
    echo -e "${YELLOW}B)${NC} Pannel"
    echo -e "${YELLOW}C)${NC} Exit"
    echo -e "${RED}-------------------------------------------------------${NC}"
    echo ""
    read -p "Select -> " option

    # Convert lowercase to uppercase for easy input
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
    echo -e "${LIGHT_BLUE}            BLUENODES INSTALLATION STARTED               ${NC}"
    echo -e "${BLUE}=======================================================${NC}"
    echo ""

    echo -e "${CYAN}[*] Updating system, please wait...${NC}"
    apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1

    echo -e "${CYAN}[*] Installing essential packages...${NC}"
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
    echo -e "${BLUE}=======================================================${NC}"
    echo -e "${LIGHT_BLUE}                 PANNEL INSTALLER                        ${NC}"
    echo -e "${BLUE}=======================================================${NC}"
    echo ""
    echo -e "  ${LIGHT_BLUE}---- PANEL MENU ----${NC}"
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

# Start the script by showing the main menu
show_main_menu
