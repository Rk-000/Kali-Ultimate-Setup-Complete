#!/bin/bash

# =====================================================
# KALI WSL ULTIMATE SETUP SCRIPT - COMPLETE FIXED VERSION
# Developed by ROWNOK AHMED KHAN
# Cyber Security Analyst & Digital Design Specialist
# =====================================================

# =====================================================
# SAFE MODE - With proper error handling
# =====================================================
set -uo pipefail
IFS=$'\n\t'

# Trap errors and continue
trap 'error_handler $? $LINENO $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]:-})' ERR
trap 'cleanup_on_exit' EXIT

# =====================================================
# COLOR DEFINITIONS
# =====================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'
DIM='\033[2m'
REVERSE='\033[7m'
UNDERLINE='\033[4m'

# =====================================================
# GLOBAL VARIABLES
# =====================================================
LOG_FILE="$HOME/kali_setup_$(date +%Y%m%d_%H%M%S).log"
ERROR_COUNT=0
WARNING_COUNT=0
SELECTED_PACKAGE=""
INSTALLATION_STATUS=0
START_TIME=$(date +%s)
SCRIPT_VERSION="2.1.0"
USER_HOME="$HOME"
TERMINAL_WIDTH=$(tput cols 2>/dev/null || echo 80)

# Create log file with header
cat > "$LOG_FILE" << EOF
========================================
KALI WSL SETUP LOG
========================================
Date: $(date)
User: $(whoami)
Host: $(hostname)
Script Version: $SCRIPT_VERSION
Log File: $LOG_FILE
========================================

EOF

# =====================================================
# ERROR HANDLING FUNCTIONS
# =====================================================
error_handler() {
    local exit_code=$1
    local line_no=$2
    local bash_lineno=$3
    local last_command=$4
    local func_trace=$5
    
    # Temporarily disable set -e to prevent recursive errors
    set +e
    
    echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}" | tee -a "$LOG_FILE"
    echo -e "${RED}║                    ERROR DETECTED                            ║${NC}" | tee -a "$LOG_FILE"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}" | tee -a "$LOG_FILE"
    echo -e "${YELLOW}Error Details:${NC}" | tee -a "$LOG_FILE"
    echo -e "  Exit Code: $exit_code" | tee -a "$LOG_FILE"
    echo -e "  Line Number: $line_no" | tee -a "$LOG_FILE"
    echo -e "  Command: $last_command" | tee -a "$LOG_FILE"
    echo -e "  Function: ${func_trace:-main}" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    # Auto-recovery attempts
    echo -e "${BLUE}Attempting auto-recovery...${NC}" | tee -a "$LOG_FILE"
    
    # Check and fix common issues
    if [[ "$last_command" == *"apt"* ]] || [[ "$last_command" == *"dpkg"* ]]; then
        echo -e "${YELLOW}APT/DPKG error detected. Attempting fixes...${NC}" | tee -a "$LOG_FILE"
        sudo dpkg --configure -a 2>/dev/null || true
        sudo apt --fix-broken install -y 2>/dev/null || true
        sudo apt install -f -y 2>/dev/null || true
        sudo apt clean 2>/dev/null || true
        sudo apt autoclean 2>/dev/null || true
    fi
    
    if [[ "$last_command" == *"network"* ]] || [[ "$last_command" == *"ping"* ]] || [[ "$last_command" == *"curl"* ]] || [[ "$last_command" == *"wget"* ]]; then
        echo -e "${YELLOW}Network error detected. Attempting fixes...${NC}" | tee -a "$LOG_FILE"
        echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf 2>/dev/null || true
        echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf 2>/dev/null || true
        echo "nameserver 208.67.222.222" | sudo tee -a /etc/resolv.conf 2>/dev/null || true
    fi
    
    if [[ "$last_command" == *"permission"* ]] || [[ "$last_command" == *"denied"* ]]; then
        echo -e "${YELLOW}Permission error detected. Attempting fixes...${NC}" | tee -a "$LOG_FILE"
        sudo chmod +x "$0" 2>/dev/null || true
        sudo chown -R "$(whoami)":"$(whoami)" "$HOME" 2>/dev/null || true
    fi
    
    echo -e "${GREEN}Auto-recovery completed. Continuing...${NC}" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    ((ERROR_COUNT++))
    
    # Re-enable set -e
    set -e
}

cleanup_on_exit() {
    local exit_code=$?
    if [ $exit_code -ne 0 ] && [ $exit_code -ne 130 ]; then
        echo -e "${YELLOW}Script terminated with exit code: $exit_code${NC}" | tee -a "$LOG_FILE"
        echo -e "${BLUE}Check log file for details: $LOG_FILE${NC}" | tee -a "$LOG_FILE"
    fi
    return 0
}

# =====================================================
# LOGGING FUNCTIONS
# =====================================================
log() {
    echo -e "${GREEN}[✓]${NC} $1" | tee -a "$LOG_FILE"
}

error_log() {
    echo -e "${RED}[✗]${NC} $1" | tee -a "$LOG_FILE"
    ((ERROR_COUNT++))
}

warn_log() {
    echo -e "${YELLOW}[!]${NC} $1" | tee -a "$LOG_FILE"
    ((WARNING_COUNT++))
}

info_log() {
    echo -e "${BLUE}[i]${NC} $1" | tee -a "$LOG_FILE"
}

success_log() {
    echo -e "${GREEN}[✔]${NC} $1" | tee -a "$LOG_FILE"
}

section() {
    local title="$1"
    local char_count=${#title}
    local total_width=$TERMINAL_WIDTH
    local padding=$(( (total_width - char_count - 4) / 2 ))
    
    echo "" | tee -a "$LOG_FILE"
    echo -e "${PURPLE}$(printf '═%.0s' $(seq 1 $total_width))${NC}" | tee -a "$LOG_FILE"
    echo -e "${PURPLE}║${NC}$(printf ' %.0s' $(seq 1 $padding))${BOLD}${WHITE}$title${NC}${PURPLE}$(printf ' %.0s' $(seq 1 $padding))${NC}${PURPLE}║${NC}" | tee -a "$LOG_FILE"
    echo -e "${PURPLE}$(printf '═%.0s' $(seq 1 $total_width))${NC}" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
}

# =====================================================
# UTILITY FUNCTIONS
# =====================================================
check_command() {
    command -v "$1" &>/dev/null
}

get_terminal_width() {
    TERMINAL_WIDTH=$(tput cols 2>/dev/null || echo 80)
    if [ "$TERMINAL_WIDTH" -lt 60 ]; then
        TERMINAL_WIDTH=80
    fi
}

safe_mkdir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir" 2>/dev/null || {
            warn_log "Failed to create directory: $dir"
            return 1
        }
    fi
    return 0
}

safe_chmod() {
    local perm="$1"
    local file="$2"
    if [ -f "$file" ] || [ -d "$file" ]; then
        chmod "$perm" "$file" 2>/dev/null || {
            warn_log "Failed to chmod $file"
            return 1
        }
    fi
    return 0
}

retry_command() {
    local cmd="$1"
    local max_attempts=3
    local attempt=1
    local wait_time=2
    local success=0
    
    # Temporarily disable set -e for retry loop
    set +e
    
    while [ $attempt -le $max_attempts ]; do
        info_log "Attempt $attempt/$max_attempts: $cmd"
        
        if eval "$cmd" 2>>"$LOG_FILE"; then
            success=1
            break
        else
            if [ $attempt -lt $max_attempts ]; then
                warn_log "Command failed, retrying in $wait_time seconds..."
                sleep $wait_time
                auto_fix_apt 2>/dev/null || true
                ((attempt++))
            else
                error_log "Command failed after $max_attempts attempts: $cmd"
                success=0
            fi
        fi
    done
    
    # Re-enable set -e
    set -e
    return $success
}

auto_fix_apt() {
    # Disable set -e temporarily
    set +e
    info_log "Running APT auto-fix..."
    sudo dpkg --configure -a 2>/dev/null || true
    sudo apt --fix-broken install -y 2>/dev/null || true
    sudo apt install -f -y 2>/dev/null || true
    sudo apt clean 2>/dev/null || true
    sudo apt autoclean 2>/dev/null || true
    sudo apt update --fix-missing 2>/dev/null || true
    set -e
}

check_internet() {
    info_log "Checking internet connection..."
    local success=0
    
    # Try multiple DNS servers and methods
    for dns in "8.8.8.8" "1.1.1.1" "208.67.222.222"; do
        if ping -c 2 -W 2 "$dns" &>/dev/null; then
            success=1
            break
        fi
    done
    
    if [ $success -eq 0 ]; then
        if curl -s --max-time 5 https://google.com &>/dev/null; then
            success=1
        fi
    fi
    
    if [ $success -eq 0 ]; then
        warn_log "No internet connection detected"
        info_log "Attempting to fix DNS configuration..."
        echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf 2>/dev/null || true
        echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf 2>/dev/null || true
        echo "nameserver 208.67.222.222" | sudo tee -a /etc/resolv.conf 2>/dev/null || true
        
        sleep 3
        
        for dns in "8.8.8.8" "1.1.1.1"; do
            if ping -c 2 -W 2 "$dns" &>/dev/null; then
                success=1
                break
            fi
        done
    fi
    
    if [ $success -eq 1 ]; then
        log "Internet connection available"
        return 0
    else
        error_log "No internet connection. Please connect to the internet."
        return 1
    fi
}

check_sudo() {
    if ! sudo -v 2>/dev/null; then
        error_log "Sudo access required. Please ensure you have sudo privileges."
        return 1
    fi
    return 0
}

check_wsl() {
    if ! grep -qi "microsoft" /proc/version 2>/dev/null; then
        warn_log "Not running in WSL environment. Some features may not work."
    fi
    return 0
}

install_package_robust() {
    local package="$1"
    local success=0
    
    info_log "Installing package: $package"
    
    if retry_command "sudo apt install -y $package"; then
        success=1
        log "Package installed successfully: $package"
        return 0
    fi
    
    if retry_command "sudo apt install -y $package --fix-missing"; then
        success=1
        log "Package installed successfully (with --fix-missing): $package"
        return 0
    fi
    
    if retry_command "sudo apt install -y --reinstall $package"; then
        success=1
        log "Package installed successfully (with --reinstall): $package"
        return 0
    fi
    
    error_log "Failed to install package: $package"
    return 1
}

install_python_package() {
    local package="$1"
    info_log "Installing Python package: $package"
    
    if pip3 install "$package" 2>>"$LOG_FILE"; then
        log "Python package installed: $package"
        return 0
    else
        warn_log "Failed to install Python package: $package"
        return 1
    fi
}

# =====================================================
# BANNER DISPLAY
# =====================================================
display_banner() {
    clear
    get_terminal_width
    
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║  ██╗  ██╗ █████╗ ██╗     ██╗    ██╗███████╗██╗             ║"
    echo "║  ██║ ██╔╝██╔══██╗██║     ██║    ██║██╔════╝██║             ║"
    echo "║  █████╔╝ ███████║██║     ██║ █╗ ██║███████╗██║             ║"
    echo "║  ██╔═██╗ ██╔══██║██║     ██║███╗██║╚════██║██║             ║"
    echo "║  ██║  ██╗██║  ██║███████╗╚███╔███╔╝███████║███████╗        ║"
    echo "║  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚══════╝        ║"
    echo "║                                                              ║"
    echo "║         ███████╗███████╗████████╗██╗   ██╗██████╗          ║"
    echo "║         ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗         ║"
    echo "║         ███████╗█████╗     ██║   ██║   ██║██████╔╝         ║"
    echo "║         ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝          ║"
    echo "║         ███████║███████╗   ██║   ╚██████╔╝██║              ║"
    echo "║         ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝              ║"
    echo "║                                                              ║"
    echo "║           ${WHITE}CYBER SECURITY & NETWORKING TOOLKIT${CYAN}             ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${BOLD}${GREEN}          Developed by ROWNOK AHMED KHAN${NC}"
    echo -e "${BOLD}${BLUE}     Cyber Security Analyst & Digital Design Specialist${NC}"
    echo -e "${BOLD}${PURPLE}     Version: $SCRIPT_VERSION | $(date '+%B %d, %Y')${NC}"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${DIM}System Information:${NC}"
    echo -e "${DIM}  User: $(whoami) | Host: $(hostname) | OS: $(uname -s) $(uname -r)${NC}"
    echo -e "${DIM}  Memory: $(free -h | grep Mem | awk '{print $2}') | Disk: $(df -h / | awk 'NR==2{print $4}') free${NC}"
    echo ""
}

# =====================================================
# PACKAGE SELECTION MENU
# =====================================================
show_package_menu() {
    display_banner
    
    echo -e "${BOLD}${WHITE}┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}${WHITE}│          SELECT YOUR PACKAGE TYPE                           │${NC}"
    echo -e "${BOLD}${WHITE}├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${BOLD}${WHITE}│                                                              │${NC}"
    echo -e "${BOLD}${WHITE}│  ${CYAN}1.${NC} ${GREEN}LIGHTNING CORE${NC}        - Essential tools for quick start     │${NC}"
    echo -e "${BOLD}${WHITE}│  ${CYAN}2.${NC} ${BLUE}PROFESSIONAL BASE${NC}      - Recommended for daily use            │${NC}"
    echo -e "${BOLD}${WHITE}│  ${CYAN}3.${NC} ${YELLOW}SECURITY ANALYST${NC}     - Medium level with web tools          │${NC}"
    echo -e "${BOLD}${WHITE}│  ${CYAN}4.${NC} ${RED}PENTESTER PRO${NC}           - Full attack & exploitation tools     │${NC}"
    echo -e "${BOLD}${WHITE}│  ${CYAN}5.${NC} ${PURPLE}CYBER WARRIOR${NC}        - Complete arsenal for all needs       │${NC}"
    echo -e "${BOLD}${WHITE}│                                                              │${NC}"
    echo -e "${BOLD}${WHITE}├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${BOLD}${WHITE}│  Package Details:                                            │${NC}"
    echo -e "${BOLD}${WHITE}│  ${DIM}1: ${WHITE}Basic networking, scanning, and packet analysis${NC}             │"
    echo -e "${BOLD}${WHITE}│  ${DIM}2: ${WHITE}All of 1 + web tools, and automation${NC}                      │"
    echo -e "${BOLD}${WHITE}│  ${DIM}3: ${WHITE}All of 2 + enumeration, and Python tools${NC}                   │"
    echo -e "${BOLD}${WHITE}│  ${DIM}4: ${WHITE}All of 3 + exploitation, and Metasploit${NC}                    │"
    echo -e "${BOLD}${WHITE}│  ${DIM}5: ${WHITE}All tools + forensics, GUI, and advanced tools${NC}             │"
    echo -e "${BOLD}${WHITE}└──────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    local choice=""
    while true; do
        echo -e "${BOLD}${WHITE}Enter your choice (1-5):${NC} "
        read -r choice
        
        if [[ "$choice" =~ ^[1-5]$ ]]; then
            case $choice in
                1) SELECTED_PACKAGE="LIGHTNING CORE" ;;
                2) SELECTED_PACKAGE="PROFESSIONAL BASE" ;;
                3) SELECTED_PACKAGE="SECURITY ANALYST" ;;
                4) SELECTED_PACKAGE="PENTESTER PRO" ;;
                5) SELECTED_PACKAGE="CYBER WARRIOR" ;;
            esac
            break
        else
            echo -e "${RED}Invalid choice. Please select a number between 1 and 5.${NC}"
        fi
    done
    
    echo ""
    echo -e "${GREEN}✓ Selected: ${BOLD}${WHITE}$SELECTED_PACKAGE${NC}"
    echo ""
    echo -e "${YELLOW}Package Contents:${NC}"
    
    case $SELECTED_PACKAGE in
        "LIGHTNING CORE")
            echo -e "${GREEN}  • Nmap, Tcpdump, Net-tools, IPRoute2${NC}"
            echo -e "${GREEN}  • Netcat, Curl, Wget, Iputils-ping${NC}"
            echo -e "${DIM}  • Estimated packages: ~8 | Size: ~50MB${NC}"
            ;;
        "PROFESSIONAL BASE")
            echo -e "${GREEN}  • All Lightning Core packages${NC}"
            echo -e "${GREEN}  • Wireshark, Gobuster, WhatWeb, Nikto${NC}"
            echo -e "${GREEN}  • FFUF, Python3-pip, Python3-venv${NC}"
            echo -e "${GREEN}  • DNSUtils, Whois, Traceroute${NC}"
            echo -e "${DIM}  • Estimated packages: ~15 | Size: ~200MB${NC}"
            ;;
        "SECURITY ANALYST")
            echo -e "${GREEN}  • All Professional Base packages${NC}"
            echo -e "${GREEN}  • Feroxbuster, SQLMap, Hydra${NC}"
            echo -e "${GREEN}  • Enum4linux, DNSRecon, SSLScan${NC}"
            echo -e "${GREEN}  • Python: Requests, BeautifulSoup, Python-Nmap${NC}"
            echo -e "${DIM}  • Estimated packages: ~25 | Size: ~400MB${NC}"
            ;;
        "PENTESTER PRO")
            echo -e "${GREEN}  • All Security Analyst packages${NC}"
            echo -e "${GREEN}  • Metasploit-Framework, John, Hashcat${NC}"
            echo -e "${GREEN}  • Dsniff, ExploitDB, Aircrack-ng${NC}"
            echo -e "${GREEN}  • Reaver, Bully${NC}"
            echo -e "${DIM}  • Estimated packages: ~35 | Size: ~1.2GB${NC}"
            ;;
        "CYBER WARRIOR")
            echo -e "${GREEN}  • All Pentester Pro packages${NC}"
            echo -e "${GREEN}  • WPScan, ZAPProxy, Beef-XSS${NC}"
            echo -e "${GREEN}  • Nmap-common, Masscan${NC}"
            echo -e "${GREEN}  • Foremost, TestDisk, Autopsy${NC}"
            echo -e "${GREEN}  • Kali-Win-Kex (GUI), Scapy, Impacket${NC}"
            echo -e "${DIM}  • Estimated packages: ~50+ | Size: ~3GB+${NC}"
            ;;
    esac
    
    echo ""
    echo -e "${BLUE}Starting installation in 3 seconds...${NC}"
    sleep 3
}

# =====================================================
# INSTALLATION FUNCTIONS
# =====================================================
update_system_first() {
    section "SYSTEM UPDATE"
    
    info_log "Updating package lists..."
    retry_command "sudo apt update -y" || {
        warn_log "Initial apt update failed, retrying with fixes..."
        auto_fix_apt
        retry_command "sudo apt update -y" || {
            error_log "Failed to update package lists"
            return 1
        }
    }
    
    info_log "Upgrading packages..."
    retry_command "sudo apt upgrade -y" || {
        warn_log "Upgrade failed, trying with --fix-missing..."
        retry_command "sudo apt upgrade -y --fix-missing" || {
            error_log "Failed to upgrade packages"
            return 1
        }
    }
    
    info_log "Installing essential tools..."
    retry_command "sudo apt install -y curl wget git vim nano htop net-tools" || {
        error_log "Failed to install essential tools"
        return 1
    }
    
    log "System update completed successfully"
    return 0
}

install_lightning_core() {
    section "LIGHTNING CORE - Essential Tools"
    
    local packages=(
        "nmap"
        "tcpdump"
        "net-tools"
        "iproute2"
        "netcat-openbsd"
        "curl"
        "wget"
        "iputils-ping"
    )
    
    local success_count=0
    local total_count=${#packages[@]}
    
    for pkg in "${packages[@]}"; do
        if install_package_robust "$pkg"; then
            ((success_count++))
        fi
    done
    
    log "Lightning Core: $success_count/$total_count packages installed"
    
    if [ $success_count -lt $total_count ]; then
        warn_log "Some packages failed to install. Check log for details."
    fi
    
    return 0
}

install_professional_base() {
    section "PROFESSIONAL BASE - Recommended Tools"
    
    install_lightning_core
    
    local packages=(
        "wireshark"
        "gobuster"
        "whatweb"
        "nikto"
        "ffuf"
        "python3-pip"
        "python3-venv"
        "dnsutils"
        "whois"
        "traceroute"
    )
    
    local success_count=0
    local total_count=${#packages[@]}
    
    # Debconf pre-selection to prevent interactive prompts
    echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections 2>/dev/null || true
    
    for pkg in "${packages[@]}"; do
        if install_package_robust "$pkg"; then
            ((success_count++))
        fi
    done
    
    sudo usermod -aG wireshark "$USER" 2>/dev/null || true
    
    if check_command pip3; then
        install_python_package "requests" || true
        install_python_package "beautifulsoup4" || true
    fi
    
    log "Professional Base: $success_count/$total_count packages installed"
    
    if [ $success_count -lt $total_count ]; then
        warn_log "Some packages failed to install. Check log for details."
    fi
    
    return 0
}

install_security_analyst() {
    section "SECURITY ANALYST - Medium Level Tools"
    
    install_professional_base
    
    local packages=(
        "feroxbuster"
        "sqlmap"
        "hydra"
        "enum4linux"
        "dnsrecon"
        "sslscan"
    )
    
    local success_count=0
    local total_count=${#packages[@]}
    
    for pkg in "${packages[@]}"; do
        if install_package_robust "$pkg"; then
            ((success_count++))
        fi
    done
    
    if check_command pip3; then
        install_python_package "python-nmap" || true
        install_python_package "scapy" || true
    fi
    
    log "Security Analyst: $success_count/$total_count packages installed"
    
    if [ $success_count -lt $total_count ]; then
        warn_log "Some packages failed to install. Check log for details."
    fi
    
    return 0
}

install_pentester_pro() {
    section "PENTESTER PRO - Attack & Exploitation Tools"
    
    install_security_analyst
    
    local packages=(
        "metasploit-framework"
        "john"
        "hashcat"
        "dsniff"
        "exploitdb"
        "aircrack-ng"
        "reaver"
        "bully"
    )
    
    local success_count=0
    local total_count=${#packages[@]}
    
    for pkg in "${packages[@]}"; do
        if install_package_robust "$pkg"; then
            ((success_count++))
        fi
    done
    
    if check_command msfdb; then
        info_log "Initializing Metasploit database..."
        sudo msfdb init 2>>"$LOG_FILE" || {
            warn_log "Metasploit DB initialization failed"
            sudo msfdb --use-defaults init 2>>"$LOG_FILE" || true
        }
    fi
    
    if check_command pip3; then
        install_python_package "impacket" || true
        install_python_package "crackmapexec" || true
    fi
    
    log "Pentester Pro: $success_count/$total_count packages installed"
    
    if [ $success_count -lt $total_count ]; then
        warn_log "Some packages failed to install. Check log for details."
    fi
    
    return 0
}

install_cyber_warrior() {
    section "CYBER WARRIOR - Complete Toolkit"
    
    install_pentester_pro
    
    local packages=(
        "wpscan"
        "zaproxy"
        "beef-xss"
        "nmap-common"
        "masscan"
        "foremost"
        "testdisk"
        "autopsy"
        "kali-win-kex"
    )
    
    local success_count=0
    local total_count=${#packages[@]}
    
    for pkg in "${packages[@]}"; do
        if install_package_robust "$pkg"; then
            ((success_count++))
        fi
    done
    
    if check_command pip3; then
        install_python_package "scapy" || true
        install_python_package "impacket" || true
        install_python_package "crackmapexec" || true
    fi
    
    log "Cyber Warrior: $success_count/$total_count packages installed"
    
    if [ $success_count -lt $total_count ]; then
        warn_log "Some packages failed to install. Check log for details."
    fi
    
    return 0
}

# =====================================================
# SETUP AUTOMATION
# =====================================================
setup_automation() {
    section "AUTOMATION & ORGANIZATION SETUP"
    
    info_log "Creating directory structure..."
    local directories=(
        "$HOME/scans"
        "$HOME/loot"
        "$HOME/reports"
        "$HOME/scripts"
        "$HOME/wordlists"
        "$HOME/tools"
        "$HOME/projects"
        "$HOME/notes"
        "$HOME/backups"
    )
    
    for dir in "${directories[@]}"; do
        safe_mkdir "$dir" && log "Created: $dir"
    done
    
    info_log "Setting up bash aliases..."
    
    if ! grep -q "CYBER_WARRIOR_ALIASES" "$HOME/.bashrc" 2>/dev/null; then
        cat >> "$HOME/.bashrc" << ALIASES

# ============================================
# CYBER_WARRIOR_ALIASES - Auto-generated
# Generated on: $(date)
# Package: ${SELECTED_PACKAGE}
# ============================================

# Scanning Aliases
alias scan='nmap -sV -sC -O'
alias scanall='nmap -p- -sV -sC -O'
alias scanudp='nmap -sU -sV'
alias pingsweep='nmap -sn'
alias quick='nmap -T4 -F'
alias fastscan='nmap -T4 -F -sV'

# Web Testing
alias dirsearch='gobuster dir -w /usr/share/wordlists/dirb/common.txt'
alias webscan='whatweb -a 3'
alias sqltest='sqlmap --batch --random-agent --level=2'
alias nikto-scan='nikto -h'

# Packet Analysis
alias tcpdump='sudo tcpdump -i any'
alias wireshark='sudo wireshark'
alias tailcap='sudo tcpdump -i any -n'

# System Info
alias myip='curl -s ifconfig.me && echo ""'
alias localip='ip addr show | grep "inet " | grep -v 127.0.0.1'
alias ports='sudo netstat -tulpn | grep LISTEN'
alias processes='ps aux --sort=-%cpu | head -20'
alias memory='free -h'
alias disk='df -h'

# Quick Scan Function
function quick_scan() {
    echo -e "\${GREEN}[+] Quick scanning \${1}...\${NC}"
    nmap -sV -sC -O -T4 --min-rate=1000 "\${1}"
}

# Full Recon Function
function full_recon() {
    if [ -z "\${1}" ]; then
        echo -e "\${RED}Usage: full_recon <target>\${NC}"
        return 1
    fi
    echo -e "\${GREEN}[+] Starting full recon on \${1}...\${NC}"
    mkdir -p "\$HOME/scans/\${1}"
    echo -e "\${YELLOW}[*] Running Nmap full scan...\${NC}"
    nmap -sV -sC -O -p- -T4 "\${1}" -oA "\$HOME/scans/\${1}/full_scan"
    echo -e "\${YELLOW}[*] Running Gobuster...\${NC}"
    gobuster dir -u http://\${1} -w /usr/share/wordlists/dirb/common.txt -o "\$HOME/scans/\${1}/gobuster.txt" 2>/dev/null
    echo -e "\${YELLOW}[*] Running WhatWeb...\${NC}"
    whatweb http://\${1} > "\$HOME/scans/\${1}/whatweb.txt" 2>/dev/null
    echo -e "\${GREEN}[+] Recon completed! Results in \$HOME/scans/\${1}/\${NC}"
}

# Project Management
function new_project() {
    if [ -z "\${1}" ]; then
        echo -e "\${RED}Usage: new_project <project_name>\${NC}"
        return 1
    fi
    mkdir -p "\$HOME/projects/\${1}"/{scans,loot,reports,notes,backups}
    echo -e "\${GREEN}[+] Project '\${1}' created in \$HOME/projects/\${1}/\${NC}"
    echo -e "\${BLUE}Project structure:\${NC}"
    tree "\$HOME/projects/\${1}" 2>/dev/null || ls -la "\$HOME/projects/\${1}"
}

# Help Function
function help_me() {
    echo -e "\${CYAN}╔════════════════════════════════════════════════════╗\${NC}"
    echo -e "\${CYAN}║       KALI WSL CYBERSECURITY COMMANDS            ║\${NC}"
    echo -e "\${CYAN}╚════════════════════════════════════════════════════╝\${NC}"
    echo ""
    echo -e "\${GREEN}SCANNING:\${NC}"
    echo "  scan <target>        - Quick Nmap scan (sV,sC,O)"
    echo "  scanall <target>     - Full port scan with service detection"
    echo "  pingsweep <target>   - Ping sweep network"
    echo "  quick_scan <target>  - Quick aggressive scan"
    echo ""
    echo -e "\${GREEN}RECONNAISSANCE:\${NC}"
    echo "  full_recon <target>  - Complete automated reconnaissance"
    echo "  dirsearch <target>   - Directory enumeration"
    echo "  webscan <target>     - Web technology fingerprinting"
    echo "  sqltest <target>     - SQLMap automated testing"
    echo ""
    echo -e "\${GREEN}SYSTEM:\${NC}"
    echo "  myip                 - Show public IP"
    echo "  localip              - Show local IP"
    echo "  ports                - Show open ports"
    echo "  processes            - Show top processes"
    echo "  memory               - Show memory usage"
    echo "  disk                 - Show disk usage"
    echo ""
    echo -e "\${GREEN}PROJECTS:\${NC}"
    echo "  new_project <name>   - Create new project structure"
    echo "  show_aliases         - List all aliases"
    echo ""
    echo -e "\${GREEN}GUI:\${NC}"
    echo "  kex --win -s         - Start Win-Kex windowed"
    echo "  kex --sl             - Start Win-Kex seamless"
    echo ""
}

# Show aliases
alias show_aliases='grep "^alias" ~/.bashrc | grep -v "grep" | sort'
alias show_commands='help_me'
alias ll='ls -la'
alias la='ls -a'
alias l='ls -l'

ALIASES
        
        log "Aliases added to .bashrc"
    else
        info_log "Aliases already exist, skipping..."
    fi
    
    info_log "Creating automation scripts..."
    
    cat > "$HOME/scripts/full_recon.sh" << 'RECON'
#!/bin/bash
if [ -z "$1" ]; then
    echo -e "${RED}Usage: ./full_recon.sh <target>${NC}"
    exit 1
fi

TARGET="$1"
OUTPUT_DIR="$HOME/scans/$TARGET"
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}[+] Starting full reconnaissance on $TARGET${NC}"
echo -e "${BLUE}[+] Results will be saved in $OUTPUT_DIR${NC}"
echo -e "${BLUE}[+] Started at: $(date)${NC}"

echo -e "${YELLOW}[*] Running Nmap full scan...${NC}"
nmap -sV -sC -O -p- -T4 "$TARGET" -oA "$OUTPUT_DIR/nmap_full"

echo -e "${YELLOW}[*] Running WhatWeb...${NC}"
whatweb http://"$TARGET" > "$OUTPUT_DIR/whatweb.txt" 2>/dev/null

echo -e "${YELLOW}[*] Running Gobuster...${NC}"
gobuster dir -u http://"$TARGET" -w /usr/share/wordlists/dirb/common.txt -o "$OUTPUT_DIR/gobuster.txt" 2>/dev/null

echo -e "${YELLOW}[*] Running SSLScan...${NC}"
sslscan "$TARGET" > "$OUTPUT_DIR/sslscan.txt" 2>/dev/null

echo -e "${GREEN}[+] Recon complete! Check $OUTPUT_DIR for results${NC}"
echo -e "${BLUE}[+] Completed at: $(date)${NC}"
RECON
    
    safe_chmod 755 "$HOME/scripts/full_recon.sh"
    
    cat > "$HOME/scripts/update_tools.sh" << 'UPDATE'
#!/bin/bash
echo -e "${GREEN}[+] Updating Kali tools...${NC}"
echo -e "${BLUE}[+] Started at: $(date)${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
echo -e "${GREEN}[+] Update complete!${NC}"
echo -e "${BLUE}[+] Completed at: $(date)${NC}"
UPDATE
    
    safe_chmod 755 "$HOME/scripts/update_tools.sh"
    
    cat > "$HOME/scripts/check_status.sh" << 'STATUS'
#!/bin/bash
echo -e "${CYAN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║            KALI WSL STATUS CHECK                  ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}Installed Tools:${NC}"
tools=("nmap" "wireshark" "msfconsole" "gobuster" "nikto" "john" "hashcat" "sqlmap" "hydra" "whatweb")
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} $tool ($(which "$tool" 2>/dev/null))"
    else
        echo -e "  ${RED}✗${NC} $tool (not found)"
    fi
done

echo ""
echo -e "${GREEN}Directories:${NC}"
for dir in scans loot reports scripts wordlists tools projects notes backups; do
    if [ -d "$HOME/$dir" ]; then
        echo -e "  ${GREEN}✓${NC} ~/$dir"
    else
        echo -e "  ${RED}✗${NC} ~/$dir"
    fi
done

echo ""
echo -e "${GREEN}Aliases Loaded:${NC}"
alias | grep -E "scan|recon|myip|ports" | head -5

echo ""
echo -e "${GREEN}System Info:${NC}"
echo -e "  Memory: $(free -h | grep Mem | awk '{print $3"/"$2}')"
echo -e "  Disk: $(df -h / | awk 'NR==2{print $3"/"$2 " ("$5" used)"}')"
echo -e "  Load: $(uptime | awk -F'load average:' '{print $2}')"
echo ""
STATUS
    
    safe_chmod 755 "$HOME/scripts/check_status.sh"
    
    # Create README file - properly closed heredoc
    cat > "$HOME/README_KALI_SETUP.txt" << README
========================================
KALI WSL SETUP - USER GUIDE
========================================

Setup Date: $(date)
Package: ${SELECTED_PACKAGE}

========================================
DIRECTORY STRUCTURE
========================================
~/scans/        - Scan output and target recon results
~/loot/         - Extracted credentials, files, and evidence
~/reports/      - Penetration testing & audit reports
~/scripts/      - Custom bash & automation scripts
~/wordlists/    - Wordlists for fuzzing & brute forcing
~/tools/        - Custom compiled tools & repos
~/projects/     - Organized project directories
~/notes/        - CTF notes, methodology & findings
~/backups/      - Configuration & data backups

========================================
QUICK START COMMANDS
========================================
- Run 'help_me' to view all customized aliases and helper functions.
- Run 'new_project <name>' to create an isolated directory layout for a target.
- Run 'full_recon <target>' for automated basic Nmap, Gobuster, and WhatWeb scans.
- Run '~/scripts/check_status.sh' to verify installed tools and setup integrity.

========================================
INSTALLED PACKAGE: ${SELECTED_PACKAGE}
========================================
For detailed package information, refer to the installation log:
${LOG_FILE}

========================================
CONTACT & SUPPORT
========================================
Developed by: ROWNOK AHMED KHAN
Role: Cyber Security Analyst & Digital Design Specialist
LinkedIn: https://www.linkedin.com/in/rowonk-ahmed-khan-184671352/
Website: https://sites.google.com/view/rownokahmedkhan

========================================
VERSION INFORMATION
========================================
Script Version: ${SCRIPT_VERSION}
Installation Date: $(date)
Kali Version: $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")
Kernel: $(uname -r)

========================================
END OF README
========================================
README
    
    safe_chmod 644 "$HOME/README_KALI_SETUP.txt"
    log "User guide generated at ~/README_KALI_SETUP.txt"
    
    return 0
}

# =====================================================
# VERIFICATION
# =====================================================
verify_installation() {
    section "INSTALLATION VERIFICATION"
    
    echo -e "${BOLD}${WHITE}You selected: ${GREEN}$SELECTED_PACKAGE${NC}"
    echo -e "${YELLOW}Do you want to verify the installation?${NC}"
    echo -e "${BOLD}${WHITE}1. Yes, run full verification${NC}"
    echo -e "${BOLD}${WHITE}2. Quick verification${NC}"
    echo -e "${BOLD}${WHITE}3. Skip verification${NC}"
    echo ""
    
    local verify_choice=""
    while true; do
        echo -e -n "${BOLD}${WHITE}Enter your choice (1-3): ${NC}"
        read -r verify_choice
        
        if [[ "$verify_choice" =~ ^[1-3]$ ]]; then
            break
        else
            echo -e "${RED}Invalid choice. Please select 1, 2, or 3.${NC}"
        fi
    done
    
    case $verify_choice in
        1)
            info_log "Running full verification..."
            if [ -f "$HOME/scripts/check_status.sh" ]; then
                bash "$HOME/scripts/check_status.sh"
            else
                warn_log "Status script not found. Running manual verification..."
                echo ""
                echo -e "${BLUE}Verifying installed packages:${NC}"
                
                local packages=("nmap" "wireshark" "gobuster" "nikto" "whatweb" "sqlmap" "john" "hashcat")
                for pkg in "${packages[@]}"; do
                    if command -v "$pkg" &>/dev/null; then
                        echo -e "  ${GREEN}✓${NC} $pkg installed"
                    else
                        echo -e "  ${RED}✗${NC} $pkg not found"
                    fi
                done
                
                echo ""
                echo -e "${BLUE}Directory structure:${NC}"
                for dir in scans loot reports scripts wordlists tools projects notes backups; do
                    if [ -d "$HOME/$dir" ]; then
                        echo -e "  ${GREEN}✓${NC} ~/$dir"
                    else
                        echo -e "  ${RED}✗${NC} ~/$dir"
                    fi
                done
            fi
            echo ""
            log "Verification completed"
            ;;
        2)
            info_log "Running quick verification..."
            echo ""
            echo -e "${GREEN}Quick status:${NC}"
            echo -e "  Package: $SELECTED_PACKAGE"
            echo -e "  Errors: $ERROR_COUNT"
            echo -e "  Warnings: $WARNING_COUNT"
            echo -e "  Log: $LOG_FILE"
            
            echo -e "\n${BLUE}Key tools:${NC}"
            for tool in nmap wireshark gobuster; do
                if command -v "$tool" &>/dev/null; then
                    echo -e "  ${GREEN}✓${NC} $tool"
                else
                    echo -e "  ${RED}✗${NC} $tool"
                fi
            done
            echo ""
            log "Quick verification completed"
            ;;
        3)
            info_log "Skipping verification"
            ;;
    esac
}

# =====================================================
# FINAL SUMMARY
# =====================================================
show_summary() {
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    
    section "SETUP COMPLETE"
    
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                              ║${NC}"
    echo -e "${GREEN}║     ${BOLD}✓ KALI WSL SETUP SUCCESSFULLY COMPLETED${NC}${GREEN}             ║${NC}"
    echo -e "${GREEN}║                                                              ║${NC}"
    echo -e "${GREEN}║     ${BOLD}Package Installed:${NC} ${WHITE}$SELECTED_PACKAGE${NC}${GREEN}                     ║${NC}"
    echo -e "${GREEN}║                                                              ║${NC}"
    echo -e "${GREEN}║     ${BOLD}Errors:${NC} ${RED}$ERROR_COUNT${NC}${GREEN}  |  ${BOLD}Warnings:${NC} ${YELLOW}$WARNING_COUNT${NC}${GREEN}          ║${NC}"
    echo -e "${GREEN}║                                                              ║${NC}"
    echo -e "${GREEN}║     ${BOLD}Duration:${NC} ${CYAN}${minutes}m ${seconds}s${NC}${GREEN}                         ║${NC}"
    echo -e "${GREEN}║                                                              ║${NC}"
    echo -e "${GREEN}║     ${BOLD}Log File:${NC} ${DIM}$LOG_FILE${NC}${GREEN}               ║${NC}"
    echo -e "${GREEN}║                                                              ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    
    echo ""
    echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${WHITE}QUICK START COMMANDS${NC}"
    echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${GREEN}▶ Network Scanning:${NC}"
    echo "  scan 192.168.1.1     - Quick port scan"
    echo "  scanall 192.168.1.1  - Full port scan"
    echo "  pingsweep 192.168.1.0/24 - Ping sweep"
    echo ""
    
    if [[ "$SELECTED_PACKAGE" != "LIGHTNING CORE" ]]; then
        echo -e "${GREEN}▶ Reconnaissance:${NC}"
        echo "  full_recon example.com - Automated recon"
        echo "  dirsearch example.com  - Directory enumeration"
        echo "  webscan example.com    - Web fingerprinting"
        echo ""
    fi
    
    if [[ "$SELECTED_PACKAGE" == "PENTESTER PRO" ]] || [[ "$SELECTED_PACKAGE" == "CYBER WARRIOR" ]]; then
        echo -e "${GREEN}▶ Exploitation:${NC}"
        echo "  msfconsole          - Start Metasploit"
        echo "  john                - Password cracking"
        echo "  hashcat             - Advanced password recovery"
        echo ""
    fi
    
    if [[ "$SELECTED_PACKAGE" == "CYBER WARRIOR" ]]; then
        echo -e "${GREEN}▶ Forensics:${NC}"
        echo "  foremost            - File recovery"
        echo "  testdisk            - Disk recovery"
        echo "  autopsy             - Digital forensics"
        echo ""
        echo -e "${GREEN}▶ GUI:${NC}"
        echo "  kex --win -s        - Start Win-Kex windowed"
        echo "  kex --sl            - Start Win-Kex seamless"
        echo ""
    fi
    
    echo -e "${GREEN}▶ System:${NC}"
    echo "  myip                - Show public IP"
    echo "  localip             - Show local IP"
    echo "  ports               - Show open ports"
    echo "  help_me             - Show all commands"
    echo "  ~/scripts/check_status.sh - Check status"
    echo ""
    
    echo -e "${GREEN}▶ Projects:${NC}"
    echo "  new_project client_x - Create new project"
    echo "  show_aliases        - List all aliases"
    echo ""
    
    echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ $ERROR_COUNT -gt 0 ]; then
        echo -e "${YELLOW}⚠ $ERROR_COUNT error(s) occurred during installation.${NC}"
        echo -e "${YELLOW}Check the log file for details: $LOG_FILE${NC}"
        echo ""
        echo -e "${BLUE}Common fixes:${NC}"
        echo "  sudo apt --fix-broken install"
        echo "  sudo apt update --fix-missing"
        echo "  sudo dpkg --configure -a"
        echo ""
    else
        echo -e "${GREEN}✓ All installations completed successfully!${NC}"
        echo -e "${GREEN}✓ Your Kali WSL is ready for cybersecurity work${NC}"
        echo ""
    fi
    
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${WHITE}           Developed by ROWNOK AHMED KHAN${NC}"
    echo -e "${BOLD}${BLUE}     Cyber Security Analyst & Digital Design Specialist${NC}"
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    echo -e "${DIM}Directory structure created:${NC}"
    if command -v tree &>/dev/null; then
        tree -L 1 "$HOME" 2>/dev/null | head -20 || true
    else
        echo -e "${DIM}  ~/scans/ ~/loot/ ~/reports/ ~/scripts/ ~/wordlists/ ~/tools/ ~/projects/${NC}"
    fi
    echo ""
    
    echo -e "${BLUE}Next Steps:${NC}"
    echo "  1. Run: source ~/.bashrc  (to load aliases)"
    echo "  2. Run: help_me           (to see all commands)"
    echo "  3. Run: ~/scripts/check_status.sh (to verify setup)"
    echo "  4. Start using your tools!"
    echo ""
}

# =====================================================
# MAIN EXECUTION FLOW
# =====================================================
main() {
    # Check if running as root
    if [ "$(whoami)" = "root" ]; then
        echo -e "${RED}Do not run this script as root! Use a regular user with sudo privileges.${NC}"
        exit 1
    fi
    
    # Display banner
    display_banner
    
    # Run pre-installation checks
    info_log "Running pre-installation checks..."
    check_wsl
    check_sudo || exit 1
    check_internet || exit 1
    
    # Show package menu and get user selection
    show_package_menu
    
    # Update system first
    if ! update_system_first; then
        error_log "System update failed. Continuing with installation anyway..."
    fi
    
    # Install selected package
    case "$SELECTED_PACKAGE" in
        "LIGHTNING CORE")
            install_lightning_core
            ;;
        "PROFESSIONAL BASE")
            install_professional_base
            ;;
        "SECURITY ANALYST")
            install_security_analyst
            ;;
        "PENTESTER PRO")
            install_pentester_pro
            ;;
        "CYBER WARRIOR")
            install_cyber_warrior
            ;;
        *)
            error_log "Invalid package selection"
            exit 1
            ;;
    esac
    
    # Setup automation and organization
    setup_automation
    
    # Final cleanup
    section "FINAL CLEANUP"
    info_log "Performing final cleanup..."
    sudo apt autoremove -y 2>>"$LOG_FILE" || true
    sudo apt autoclean -y 2>>"$LOG_FILE" || true
    
    # Reload bashrc
    source "$HOME/.bashrc" 2>/dev/null || {
        warn_log "Could not source .bashrc. Please run: source ~/.bashrc"
    }
    
    # Verification
    verify_installation
    
    # Show summary
    show_summary
    
    # Success message
    success_log "Setup completed successfully!"
    
    # Save final log entry
    echo "" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
    echo "Setup completed at: $(date)" >> "$LOG_FILE"
    echo "Total errors: $ERROR_COUNT" >> "$LOG_FILE"
    echo "Total warnings: $WARNING_COUNT" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
    
    # Exit with appropriate status
    if [ $ERROR_COUNT -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Execute main function
main "$@"