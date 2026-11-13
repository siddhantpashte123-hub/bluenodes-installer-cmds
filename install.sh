#!/bin/bash

# ==============================================================
#   BLUENODES ALL-IN-ONE INSTALLER  ::  Made By BLUE
#   One command. No menus. Installs everything.
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
box_bot()    { printf "  %b╚%s╝%b\n" "$BORDER" "$(rep '═' $WIDTH)" "$NC"; }
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

progress() {
    local cur=$1 tot=$2 w=40
    local filled=$(( cur * w / tot ))
    printf "  %bPROGRESS%b  %b%s%b%s  %b%3d%%%b\n" \
        "$GREY" "$NC" "$GOLD" "$(rep '█' $filled)" "$GREY" "$(rep '░' $(( w - filled )))" \
        "$GOLD" $(( cur * 100 / tot )) "$NC"
}

# run_task <name> <command>  -> animated, never aborts the whole install
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
# RUN EVERYTHING
# ==============================================================
clear
show_banner
box_top
box_center "${BOLD}${WHITE}◆  ALL-IN-ONE INSTALLER  ◆${NC}"
box_center "${GREY}One command · Everything installed · Made By BLUE${NC}"
box_bot
echo ""

TOTAL=5
DONE_STEPS=0
FAILED=()

step() {  # step <name> <command>
    progress $DONE_STEPS $TOTAL
    if ! run_task "$1" "$2"; then
        FAILED+=("$1")
    fi
    DONE_STEPS=$(( DONE_STEPS + 1 ))
}

step "System Update" "apt-get update -y"
step "System Upgrade" "apt-get upgrade -y -o Dpkg::Options::=\"--force-confold\""
step "Installing Basic Tools" "apt-get install -y curl wget git htop nano ufw"
step "Installing Docker Engine" "apt-get install -y docker.io"
step "Installing Neofetch" "apt-get install -y neofetch || (curl -sL https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -o /usr/bin/neofetch && chmod +x /usr/bin/neofetch)"
progress $TOTAL $TOTAL
echo ""

# ---------- Final report ----------
box_top
box_center "${BOLD}${GOLD}INSTALLATION COMPLETE${NC}"
box_center "${GREY}Fetched by BLUENODES${NC}"
box_bot
echo ""

if command -v neofetch &> /dev/null; then
    neofetch
else
    printf "  %b⚠ Neofetch could not be installed (check your system or OS).%b\n" "$RED" "$NC"
fi

echo ""
if [ ${#FAILED[@]} -eq 0 ]; then
    printf "  %b✦ All tasks finished successfully.%b\n\n" "$GOLD" "$NC"
else
    printf "  %b⚠ Some tasks were skipped:%b %s\n\n" "$AMBER" "$NC" "$(IFS=', '; echo "${FAILED[*]}")"
fi
