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
    echo -e "${BLUE}"
    echo "  ____  _     _   _ _____ _   _  ___  ____  _____ ____  "
    echo " | __ )| |   | | | | ____| \ | |/ _ \|  _ \| ____/ ___| "
    echo " |  _ \| |   | | | |  _| |  \| | | | | | | |  _| \___ \ "
    echo " | |_) | |___| |_| | |___| |\  | |_| | |_| | |___ ___) |"
    echo " |____/|_____|\___/|_____|_| \_|\___/|____/|_____|____/ "
    echo -e "${NC}"
    echo -e "${LIGHT_BLUE}=======================================================${NC}"
    echo -e "${CYAN}1${NC}. Installer (Basic Setup)"
    echo -e "${CYAN}2${NC}. Pannel (Game/App Panels)"
    echo -e "${CYAN}3${NC}. Exit"
    echo -e "${LIGHT_BLUE}=======================================================${NC}"
    echo ""
    read -p "Select an option (1/2/3): " option

    case $option in
        1) run_installer ;;
        2) show_panel_menu ;;
        3) echo -e "${RED}Exiting...${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid option! Please enter 1, 2 or 3.${NC}"; sleep 2; show_main_menu ;;
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
    echo -e "${CYAN}1${NC}. Install JTG Pannel"
    echo -e "${CYAN}2${NC}. Back to Main Menu"
    echo ""
    read -p "Select a panel (1/2): " panel_option

    case $panel_option in
        1)
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
        2)
            show_main_menu
            ;;
        *)
            echo -e "${RED}Invalid option! Please enter 1 or 2.${NC}"
            sleep 2
            show_panel_menu
            ;;
    esac
}

# Start the script by showing the main menu
show_main_menu
