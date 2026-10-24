#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31m❌ Root se chalao: sudo bash bn.sh\e[0m"
    exit 1
fi

# Colors
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

clear

# Bada Text
echo -e "${BLUE}"
echo "  ____  _     _   _ _____ _   _  ___  ____  _____ ____  "
echo " | __ )| |   | | | | ____| \ | |/ _ \|  _ \| ____/ ___| "
echo " |  _ \| |   | | | |  _| |  \| | | | | | | |  _| \___ \ "
echo " | |_) | |___| |_| | |___| |\  | |_| | |_| | |___ ___) |"
echo " |____/|_____|\___/|_____|_| \_|\___/|____/|_____|____/ "
echo -e "${NC}"
echo -e "${LIGHT_BLUE}=======================================================${NC}"
echo -e "${CYAN}1${NC}. INSTALLER"
echo -e "${CYAN}2${NC}. EXIT"
echo ""
read -p "Apna option chuno (1/2): " option

case $option in
    1)
        clear
        echo -e "${BLUE}=======================================================${NC}"
        echo -e "${LIGHT_BLUE}          BLUENODES INSTALLATION SHURU                    ${NC}"
        echo -e "${BLUE}=======================================================${NC}"
        echo ""

        # System update (Hiding output)
        echo -e "${CYAN}[*] System update ho raha hai, kripya pratiksha karein...${NC}"
        apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1

        # Packages install (Hiding output)
        echo -e "${CYAN}[*] Zaroori packages install ho rahe hain...${NC}"
        apt install -y neofetch curl wget git htop ufw nano > /dev/null 2>&1

        echo ""
        echo -e "${GREEN}✓ Sab kuch successfully install ho gaya!${NC}"
        echo -e "${BLUE}=======================================================${NC}"
        echo ""
        
        # System info dikhane ke liye
        echo -e "${CYAN}Yeh raha aapke system ki jaankari:${NC}"
        sleep 1
        neofetch
        echo ""
        ;;
    2)
        echo -e "${RED}Exit kar rahe hain...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Galat option! Sirf 1 ya 2 daalo.${NC}"
        exit 1
        ;;
esac
