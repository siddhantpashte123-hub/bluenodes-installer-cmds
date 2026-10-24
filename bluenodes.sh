#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]; then
    echo "❌ Root se chalao: sudo bash bluenodes.sh"
    exit 1
fi

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${CYAN}"
echo "=================================="
echo "          BLUENODES               "
echo "=================================="
echo -e "${NC}"
echo -e "${GREEN}1${NC}. INSTALLER"
echo -e "${GREEN}2${NC}. EXIT"
echo ""
read -p "Apna option chuno (1/2): " option

case $option in
    1)
        clear
        echo -e "${YELLOW}[*] Installation shuru ho rahi hai...${NC}"
        echo ""

        echo -e "${GREEN}[1/4]${NC} System update ho raha hai..."
        apt update -y && apt upgrade -y

        echo -e "${GREEN}[2/4]${NC} Packages install ho rahe hain..."
        apt install -y neofetch curl wget git htop ufw nano

        echo -e "${GREEN}[3/4]${NC} System info:"
        neofetch

        echo ""
        echo -e "${GREEN}[4/4]${NC} ${GREEN}✓ Sab kuch install ho gaya!${NC}"
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
