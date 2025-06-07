#!/bin/bash
# 🌐 Netzwerk-Checker v4.1
# Autor: haku0x | Lizenz: MIT

set -euo pipefail
trap 'handle_error $? $LINENO' ERR

# Farben und Stile
RED='\033[1;91m'; GREEN='\033[1;92m'; YELLOW='\033[1;93m'; CYAN='\033[1;96m'
MAGENTA='\033[1;95m'; BLUE='\033[1;94m'; BOLD='\033[1m'; NC='\033[0m'
UNDERLINE='\033[4m'

# Fortschrittsbalken
function progress_bar() {
    local duration=$1
    local width=50
    local progress=0
    local step=$((100 / width))
    
    echo -ne "\r${CYAN}["
    for ((i=0; i<width; i++)); do
        echo -ne " "
    done
    echo -ne "] 0%"
    
    for ((i=0; i<width; i++)); do
        sleep $((duration / width))
        echo -ne "\r${CYAN}["
        for ((j=0; j<i; j++)); do
            echo -ne "█"
        done
        for ((j=i; j<width; j++)); do
            echo -ne " "
        done
        progress=$((progress + step))
        echo -ne "] ${progress}%"
    done
    echo -e "${NC}"
}

# Verbesserte Header-Funktion
function header() {
    clear
    echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════════╗"
    echo -e "║                  🌐 Netzwerk-Diagnose-Tool v4.1                ║"
    echo -e "║                    für Debian/Linux-Systeme                    ║"
    echo -e "╚══════════════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${YELLOW}System-Info:${NC}"
    echo -e "${BLUE}OS:${NC} $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo -e "${BLUE}Kernel:${NC} $(uname -r)"
    echo -e "${BLUE}Hostname:${NC} $(hostname)\n"
}

# Verbessertes Menü
function show_menu() {
    header
    echo -e "${BOLD}${UNDERLINE}Hauptmenü:${NC}\n"
    echo -e "${YELLOW}[1]${NC} 🌍 Netzwerk-Informationen"
    echo -e "${YELLOW}[2]${NC} 🖥️  System-Diagnose"
    echo -e "${YELLOW}[3]${NC} 📡 DNS & Routing"
    echo -e "${YELLOW}[4]${NC} 🚀 Performance-Tests"
    echo -e "${YELLOW}[5]${NC} 🔒 Sicherheits-Check"
    echo -e "${YELLOW}[6]${NC} ⚙️  Einstellungen"
    echo -e "${YELLOW}[7]${NC} 🚪 Beenden"
    
    echo -ne "\n🔢 ${CYAN}Auswahl eingeben [1-7]: ${NC}"
    read -r CHOICE
    
    case $CHOICE in
        1) network_info_menu ;;
        2) system_diagnosis_menu ;;
        3) dns_routing_menu ;;
        4) performance_menu ;;
        5) security_menu ;;
        6) settings_menu ;;
        7) exit_script ;;
        *) echo -e "\n${RED}❗ Ungültige Eingabe.${NC}"; sleep 1; show_menu ;;
    esac
}

# Neue Untermenüs
function network_info_menu() {
    header
    echo -e "${BOLD}${UNDERLINE}Netzwerk-Informationen:${NC}\n"
    echo -e "${YELLOW}[1]${NC} 🌍 Öffentliche IP anzeigen"
    echo -e "${YELLOW}[2]${NC} 🖥️  Lokale IPs & Schnittstellen"
    echo -e "${YELLOW}[3]${NC} 🔌 Aktive Verbindungen"
    echo -e "${YELLOW}[4]${NC} 📊 Netzwerk-Statistiken"
    echo -e "${YELLOW}[5]${NC} 🔙 Zurück zum Hauptmenü"
    
    echo -ne "\n🔢 ${CYAN}Auswahl eingeben [1-5]: ${NC}"
    read -r CHOICE
    
    case $CHOICE in
        1) public_ip ;;
        2) local_ips ;;
        3) active_connections ;;
        4) network_stats ;;
        5) show_menu ;;
        *) echo -e "\n${RED}❗ Ungültige Eingabe.${NC}"; sleep 1; network_info_menu ;;
    esac
}

# Neue Funktionen
function network_stats() {
    log "INFO" "Netzwerk-Statistiken werden abgerufen"
    echo -e "\n📊 ${MAGENTA}Netzwerk-Statistiken:${NC}"
    
    echo -e "\n${BLUE}Netzwerk-Interfaces:${NC}"
    ip -s link show
    
    echo -e "\n${BLUE}Routing-Tabelle:${NC}"
    ip route show
    
    echo -e "\n${BLUE}Netzwerk-Verbindungen:${NC}"
    netstat -i
    
    return_to_menu
}

function system_diagnosis_menu() {
    header
    echo -e "${BOLD}${UNDERLINE}System-Diagnose:${NC}\n"
    echo -e "${YELLOW}[1]${NC} 💻 System-Ressourcen"
    echo -e "${YELLOW}[2]${NC} 🔍 Prozess-Überwachung"
    echo -e "${YELLOW}[3]${NC} 📈 System-Logs"
    echo -e "${YELLOW}[4]${NC} 🔙 Zurück zum Hauptmenü"
    
    echo -ne "\n🔢 ${CYAN}Auswahl eingeben [1-4]: ${NC}"
    read -r CHOICE
    
    case $CHOICE in
        1) system_resources ;;
        2) process_monitor ;;
        3) system_logs ;;
        4) show_menu ;;
        *) echo -e "\n${RED}❗ Ungültige Eingabe.${NC}"; sleep 1; system_diagnosis_menu ;;
    esac
}

function system_resources() {
    log "INFO" "System-Ressourcen werden überprüft"
    echo -e "\n💻 ${MAGENTA}System-Ressourcen:${NC}"
    
    echo -e "\n${BLUE}CPU-Auslastung:${NC}"
    top -bn1 | head -n 5
    
    echo -e "\n${BLUE}Speicher-Auslastung:${NC}"
    free -h
    
    echo -e "\n${BLUE}Festplatten-Auslastung:${NC}"
    df -h
    
    return_to_menu
}

function process_monitor() {
    log "INFO" "Prozess-Überwachung wird gestartet"
    echo -e "\n🔍 ${MAGENTA}Top-Prozesse:${NC}"
    ps aux --sort=-%cpu | head -n 10
    
    echo -e "\n${BLUE}Netzwerk-Prozesse:${NC}"
    netstat -tulpn | grep LISTEN
    
    return_to_menu
}

function system_logs() {
    log "INFO" "System-Logs werden angezeigt"
    echo -e "\n📈 ${MAGENTA}System-Logs:${NC}"
    
    echo -e "\n${BLUE}Kernel-Logs:${NC}"
    dmesg | tail -n 20
    
    echo -e "\n${BLUE}System-Logs:${NC}"
    journalctl -n 20 --no-pager
    
    return_to_menu
}

function exit_script() {
    echo -e "\n${GREEN}👋 Auf Wiedersehen!${NC}"
    log "INFO" "Programm beendet"
    exit 0
}

# Logging-Funktion
function log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "[$timestamp] [$level] $message" >> "network_checker.log"
}

# Verbesserte Fehlerbehandlung
function handle_error() {
    local exit_code=$1
    local line_number=$2
    log "ERROR" "Fehler in Zeile $line_number mit Exit-Code $exit_code"
    echo -e "\n${RED}❌ Ein Fehler ist aufgetreten (Zeile $line_number)${NC}"
    echo -e "${YELLOW}Details wurden in network_checker.log gespeichert${NC}"
    return_to_menu
}

# Überprüfung der erforderlichen Pakete
function check_dependencies() {
    local missing_packages=()
    local required_packages=("curl" "ip" "ping" "traceroute")
    
    for package in "${required_packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            missing_packages+=("$package")
        fi
    done
    
    if [ ${#missing_packages[@]} -ne 0 ]; then
        echo -e "\n${YELLOW}📦 Installiere fehlende Pakete: ${missing_packages[*]}${NC}"
        apt update && apt install -y "${missing_packages[@]}"
    fi
}

function public_ip() {
    log "INFO" "Öffentliche IP wird abgefragt"
    echo -e "\n🌍 ${MAGENTA}Öffentliche IP-Adresse:${NC}"
    local ip=$(curl -s --max-time 10 https://ipinfo.io/ip)
    if [ -n "$ip" ]; then
        echo "$ip"
        log "INFO" "Öffentliche IP erfolgreich abgerufen: $ip"
    else
        echo "${RED}(Fehler bei Abfrage)${NC}"
        log "ERROR" "Fehler beim Abrufen der öffentlichen IP"
    fi
    return_to_menu
}

function local_ips() {
  echo -e "\n🖧 ${MAGENTA}Netzwerkschnittstellen:${NC}"
  ip -brief address show | grep -v lo || echo "${RED}(Keine Schnittstellen gefunden)${NC}"
  return_to_menu
}

function dns_info() {
  echo -e "\n📡 ${MAGENTA}DNS-Server laut /etc/resolv.conf:${NC}"
  grep nameserver /etc/resolv.conf || echo "${RED}(Keine DNS-Einträge gefunden)${NC}"
  return_to_menu
}

function run_speedtest() {
    log "INFO" "Speedtest wird gestartet"
    if ! command -v speedtest &> /dev/null; then
        log "INFO" "Installiere speedtest-cli"
        echo -e "\n📦 ${YELLOW}Installiere speedtest-cli...${NC}"
        apt update && apt install -y speedtest-cli
    fi
    echo -e "\n🚀 ${MAGENTA}Führe Speedtest durch:${NC}"
    local speedtest_result=$(speedtest --simple 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "$speedtest_result"
        log "INFO" "Speedtest erfolgreich durchgeführt"
    else
        echo "${RED}(Speedtest fehlgeschlagen)${NC}"
        log "ERROR" "Speedtest fehlgeschlagen"
    fi
    return_to_menu
}

function ping_test() {
  echo -e "\n📤 ${MAGENTA}Ping-Test zu google.de:${NC}"
  ping -c 4 google.de || echo "${RED}(Ping fehlgeschlagen)${NC}"
  return_to_menu
}

function show_all() {
  public_ip_summary
  local_ips_summary
  dns_info_summary
  ping_test_summary
  echo -e "\n📊 ${MAGENTA}Speedtest:${NC}"
  speedtest --simple || echo "${RED}(Speedtest fehlgeschlagen)${NC}"
  return_to_menu
}

function active_connections() {
  echo -e "\n🔌 ${MAGENTA}Aktive Netzwerkverbindungen:${NC}"
  ss -tulnp | grep -v "State" || echo "${RED}(Keine aktiven Verbindungen gefunden)${NC}"
  return_to_menu
}

function traceroute_check() {
  echo -ne "\n🌐 Domain eingeben (z.B. google.de): "
  read -r domain
  echo -e "\n🛰 ${MAGENTA}Traceroute zu $domain:${NC}"
  traceroute "$domain" || echo "${RED}(Traceroute fehlgeschlagen)${NC}"
  return_to_menu
}

function port_scan() {
    log "INFO" "Port-Scan wird gestartet"
    if ! command -v nmap &> /dev/null; then
        log "INFO" "Installiere nmap"
        echo -e "\n📦 ${YELLOW}Installiere nmap...${NC}"
        apt update && apt install -y nmap
    fi
    echo -e "\n🔒 ${MAGENTA}Offene Ports auf localhost:${NC}"
    local scan_result=$(nmap -Pn 127.0.0.1 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "$scan_result"
        log "INFO" "Port-Scan erfolgreich durchgeführt"
    else
        echo "${RED}(Scan fehlgeschlagen)${NC}"
        log "ERROR" "Port-Scan fehlgeschlagen"
    fi
    return_to_menu
}

# === "Nur Ausgabe" Funktionen ===
function public_ip_summary() {
  echo -e "\n🌍 Öffentliche IP:"
  curl -s https://ipinfo.io/ip || echo "(Fehler)"
}

function local_ips_summary() {
  echo -e "\n🖧 Netzwerkschnittstellen:"
  ip -brief address show | grep -v lo || echo "(Keine gefunden)"
}

function dns_info_summary() {
  echo -e "\n📡 DNS-Server:"
  grep nameserver /etc/resolv.conf || echo "(Keine DNS gefunden)"
}

function ping_test_summary() {
  echo -e "\n📤 Ping-Test:"
  ping -c 4 google.de || echo "(Fehlgeschlagen)"
}

function return_to_menu() {
  echo -e "\n🔁 ${CYAN}Zurück zum Menü...${NC}"
  read -n 1 -s -r -p "Taste drücken..."
  show_menu
}

# Hauptprogramm
function main() {
    check_dependencies
    show_menu
}

main
