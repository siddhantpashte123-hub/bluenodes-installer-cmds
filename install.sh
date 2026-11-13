#!/bin/bash

# ==============================================================
#   BLUENODES INSTALLER  ::  One command, menu driven
#   Made By BLUE
#
#   curl -fsSL https://raw.githubusercontent.com/siddhantpashte123-hub/bluenodes-installer-cmds/main/install.sh | sudo bash
# ==============================================================

# Root check
if [ "$EUID" -ne 0 ]; then
    printf "\033[38;5;203m  ✖  Root access required.\033[0m  Run: sudo bash install.sh\n"
    exit 1
fi

if ! command -v apt-get &> /dev/null; then
    printf "\033[38;5;203m  ✖  This installer needs a Debian/Ubuntu system (apt-get not found).\033[0m\n"
    exit 1
fi

# When run through "curl | bash", stdin is the script itself.
# Read user input from the real terminal instead.
if [ ! -r /dev/tty ]; then
    printf "\033[38;5;203m  ✖  No terminal available for input. Run this in an interactive shell.\033[0m\n"
    exit 1
fi
TTY=/dev/tty

export LC_CTYPE=C.UTF-8 2>/dev/null
export DEBIAN_FRONTEND=noninteractive

# ---------- Palette ----------
NC='\033[0m'
BOLD='\033[1m'
GOLD='\033[38;5;220m'
AMBER='\033[38;5;214m'
CYAN='\033[38;5;51m'
PURPLE='\033[38;5;141m'
GREEN='\033[38;5;84m'
RED='\033[38;5;203m'
WHITE='\033[38;5;255m'
GREY='\033[38;5;245m'
BORDER='\033[38;5;39m'
BADGE_OK='\033[1;30;48;5;84m'
BADGE_RUN='\033[1;30;48;5;51m'
BADGE_WARN='\033[1;30;48;5;214m'

WIDTH=60

# ---------- Helpers ----------
rep() {
    local n=$2
    (( n <= 0 )) && return 0
    local s
    printf -v s "%*s" "$n" ""
    printf '%s' "${s// /$1}"
}

plain_len() {
    local p
    p=$(printf '%b' "$1" | sed -E 's/\x1B\[[0-9;]*m//g')
    printf '%d' "${#p}"
}

box_top()    { printf "  %b╔%s╗%b\n" "$BORDER" "$(rep '═' $WIDTH)" "$NC"; }
box_mid()    { printf "  %b╠%s╣%b\n" "$BORDER" "$(rep '═' $WIDTH)" "$NC"; }
box_bot()    { printf "  %b╚%s╝%b\n" "$BORDER" "$(rep '═' $WIDTH)" "$NC"; }
box_blank()  { printf "  %b║%s║%b\n" "$BORDER" "$(rep ' ' $WIDTH)" "$NC"; }

box_row() {
    local pad=$(( WIDTH - $(plain_len "$1") - 2 ))
    printf "  %b║%b  %b%s%b║%b\n" "$BORDER" "$NC" "$1" "$(rep ' ' $pad)" "$BORDER" "$NC"
}

box_center() {
    local total=$(( WIDTH - $(plain_len "$1") ))
    local left=$(( total / 2 )) right=$(( total - total / 2 ))
    printf "  %b║%b%s%b%s%b║%b\n" "$BORDER" "$NC" "$(rep ' ' $left)" "$1" "$(rep ' ' $right)" "$BORDER" "$NC"
}

show_banner() {
    local colors=(27 33 39 45 51 87)
    local logo=(
'  ____  _     _   _ _____ _   _  ___  ____  _____ ____  '
' | __ )| |   | | | | ____| \ | |/ _ \|  _ \| ____/ ___| '
' |  _ \| |   | | | |  _| |  \| | | | | | | |  _| \___ \ '
' | |_) | |___| |_| | |___| |\  | |_| | |_| | |___ ___) |'
' |____/|_____|\___/|_____|_| \_|\___/|____/|_____|____/ '
    )
    local i=0
    echo ""
    for line in "${logo[@]}"; do
        printf "\033[1;38;5;%sm%s\033[0m\n" "${colors[$i]}" "$line"
        i=$(( i + 1 ))
    done
    echo ""
}

show_header() {
    clear
    show_banner
    box_top
    box_center "${BOLD}${WHITE}$1${NC}"
    [ -n "$2" ] && box_center "${GREY}$2${NC}"
    box_bot
    echo ""
}

# prompt: shows ❯ and reads from the real terminal
prompt() {
    printf "  %b❯%b " "$CYAN" "$NC"
    read -r "$1" < "$TTY"
}

press_enter() {
    echo ""
    printf "  %b↩%b  %s " "$PURPLE" "$NC" "$1"
    read -r _ < "$TTY"
}

progress() {
    local cur=$1 tot=$2 w=40
    local filled=$(( cur * w / tot ))
    printf "  %bPROGRESS%b  %b%s%b%s  %b%3d%%%b\n" \
        "$GREY" "$NC" "$GOLD" "$(rep '█' $filled)" "$GREY" "$(rep '░' $(( w - filled )))" \
        "$GOLD" $(( cur * 100 / tot )) "$NC"
}

# run_task <name> <command>  -> animated; returns 1 if the command failed
run_task() {
    local task_name=$1
    local command_to_run=$2
    local frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
    local i=0
    local pad=$(( 40 - $(plain_len "$task_name") ))
    (( pad < 2 )) && pad=2
    local dots
    dots=$(rep '·' $pad)

    eval "$command_to_run" > /dev/null 2>&1 &
    local pid=$!

    while kill -0 "$pid" 2>/dev/null; do
        printf "\r\033[K  %b%s%b  %b%s %s%b %b RUNNING %b" \
            "$CYAN" "${frames[$i]}" "$NC" "$WHITE" "$task_name" "$dots" "$NC" "$BADGE_RUN" "$NC"
        i=$(( (i + 1) % ${#frames[@]} ))
        sleep 0.1
    done

    wait "$pid"
    local status=$?

    if [ $status -eq 0 ]; then
        printf "\r\033[K  %b✔%b  %b%s %s%b %b DONE %b\n" \
            "$GREEN" "$NC" "$WHITE" "$task_name" "$dots" "$NC" "$BADGE_OK" "$NC"
        return 0
    else
        printf "\r\033[K  %b➜%b  %b%s %s%b %b SKIPPED %b\n" \
            "$AMBER" "$NC" "$GREY" "$task_name" "$dots" "$NC" "$BADGE_WARN" "$NC"
        return 1
    fi
}

# ==============================================================
# INSTALLER (option 1)
# ==============================================================
run_installer() {
    show_header "INSTALLER" "Full system setup · Made By BLUE"

    local total=5 done_steps=0
    local failed=()

    step() {  # step <name> <command>
        progress $done_steps $total
        if ! run_task "$1" "$2"; then
            failed+=("$1")
        fi
        done_steps=$(( done_steps + 1 ))
    }

    step "System Update" "apt-get update -y"
    step "System Upgrade" "apt-get upgrade -y -o Dpkg::Options::=\"--force-confold\""
    step "Installing Basic Tools" "apt-get install -y curl wget git htop nano ufw"
    step "Installing Docker Engine" "apt-get install -y docker.io"
    step "Installing Neofetch" "apt-get install -y neofetch || (curl -sL https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -o /usr/bin/neofetch && chmod +x /usr/bin/neofetch)"
    progress $total $total
    echo ""

    box_top
    box_center "${BOLD}${GOLD}SYSTEM INFORMATION${NC}"
    box_center "${GREY}Fetched by BLUENODES${NC}"
    box_bot
    echo ""

    if command -v neofetch &> /dev/null; then
        neofetch
    else
        printf "  %b⚠ Neofetch could not be installed (check your system or OS).%b\n" "$RED" "$NC"
    fi

    echo ""
    if [ ${#failed[@]} -eq 0 ]; then
        printf "  %b✦ Installer finished successfully.%b\n" "$GOLD" "$NC"
    else
        printf "  %b⚠ Some tasks were skipped:%b %s\n" "$AMBER" "$NC" "$(IFS=', '; echo "${failed[*]}")"
    fi

    press_enter "Press Enter to return to Main Menu..."
    show_main_menu
}

# ==============================================================
# PANEL MENU (option 2)
# ==============================================================
show_panel_menu() {
    show_header "PANEL INSTALLER" "Choose a control panel to deploy"

    box_top
    box_row "${PURPLE}[1]${NC}  ${BOLD}${WHITE}JTG Panel${NC}"
    box_row "     ${GREY}Full JTG panel deployment${NC}"
    box_blank
    box_row "${PURPLE}[2]${NC}  ${BOLD}${WHITE}Petro Panel${NC}"
    box_row "     ${GREY}Petro hosting suite${NC}"
    box_blank
    box_row "${PURPLE}[3]${NC}  ${BOLD}${WHITE}BLUEKVM Panel${NC}"
    box_row "     ${GREY}BLUEKVM panel by BLUE${NC}"
    box_blank
    box_row "${RED}[4]${NC}  ${BOLD}${WHITE}Back to Main Menu${NC}"
    box_bot
    echo ""
    prompt panel_option

    case $panel_option in
        1)
            show_header "JTG PANEL INSTALLATION" "Deploying JTG Panel"
            bash <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/Jtg/refs/heads/main/install.sh) < "$TTY"
            echo ""
            printf "  %b✔ JTG Panel install process finished!%b\n" "$GREEN" "$NC"
            press_enter "Press Enter to return to Main Menu..."
            show_main_menu
            ;;
        2)
            show_petro_menu
            ;;
        3)
            show_header "BLUEKVM PANEL INSTALLATION" "Made By BLUE"
            bash <(curl -fsSL https://raw.githubusercontent.com/siddhantpashte123-hub/BKUEKVM-/main/installer/install.sh) < "$TTY"
            echo ""
            printf "  %b✔ BLUEKVM Panel install process finished!%b\n" "$GREEN" "$NC"
            press_enter "Press Enter to return to Main Menu..."
            show_main_menu
            ;;
        4)
            show_main_menu
            ;;
        *)
            printf "  %b✖ Invalid option! Please enter 1, 2, 3 or 4.%b\n" "$RED" "$NC"
            sleep 1.5
            show_panel_menu
            ;;
    esac
}

# ==============================================================
# PETRO PANEL SUB-MENU
# ==============================================================
show_petro_menu() {
    show_header "PETRO PANEL MENU" "Premium hosting managers"

    box_top
    box_row "${PURPLE}[1]${NC}  ${BOLD}${WHITE}Nobita Cloud${NC}  ${AMBER}(not available at this time)${NC}"
    box_row "     ${GREY}Nobita hosting panel${NC}"
    box_blank
    box_row "${PURPLE}[2]${NC}  ${BOLD}${WHITE}JTG Hosting Manager${NC}"
    box_row "     ${GREY}Hosting manager by JISHNU${NC}"
    box_blank
    box_row "${RED}[3]${NC}  ${BOLD}${WHITE}Back to Panel Menu${NC}"
    box_bot
    echo ""
    prompt petro_option

    case $petro_option in
        1)
            show_header "NOBITA CLOUD INSTALLATION" "Deploying Nobita Cloud"
            bash <(curl -s https://ptero.nobitahost.in) < "$TTY"
            echo ""
            printf "  %b✔ Nobita Cloud install process finished!%b\n" "$GREEN" "$NC"
            press_enter "Press Enter to return to Main Menu..."
            show_main_menu
            ;;
        2)
            show_header "JTG HOSTING MANAGER INSTALLATION" "Made by JISHNU"
            bash <(curl -s https://ptero.jishnu.site) < "$TTY"
            echo ""
            printf "  %b✔ JTG Hosting Manager install process finished (BLUENODES)!%b\n" "$GREEN" "$NC"
            press_enter "Press Enter to return to Main Menu..."
            show_main_menu
            ;;
        3)
            show_panel_menu
            ;;
        *)
            printf "  %b✖ Invalid option! Please enter 1, 2 or 3.%b\n" "$RED" "$NC"
            sleep 1.5
            show_petro_menu
            ;;
    esac
}

# ==============================================================
# MAIN MENU  (1 = Installer, 2 = Panel)
# ==============================================================
show_main_menu() {
    clear
    show_banner
    box_top
    box_center "${BOLD}${WHITE}◆  BLUENODES INSTALLER  ◆${NC}"
    box_center "${GREY}Premium Edition  ·  Made By BLUE${NC}"
    box_mid
    box_blank
    box_row "${GOLD}[1]${NC}  ${BOLD}${WHITE}Installer${NC}"
    box_row "     ${GREY}System update · Docker · Neofetch · Core tools${NC}"
    box_blank
    box_row "${PURPLE}[2]${NC}  ${BOLD}${WHITE}Panel${NC}"
    box_row "     ${GREY}JTG · Petro · BLUEKVM panels${NC}"
    box_blank
    box_row "${RED}[3]${NC}  ${BOLD}${WHITE}Exit${NC}"
    box_blank
    box_bot
    echo ""
    prompt main_option

    case $main_option in
        1) run_installer ;;
        2) show_panel_menu ;;
        3) echo ""; printf "  %b✦ Thank you for using BLUENODES. Goodbye!%b\n\n" "$GOLD" "$NC"; exit 0 ;;
        *) printf "  %b✖ Invalid option! Please enter 1, 2 or 3.%b\n" "$RED" "$NC"; sleep 1.5; show_main_menu ;;
    esac
}

# ==============================================================
# START
# ==============================================================
show_main_menu
