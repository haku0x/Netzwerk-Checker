#!/bin/bash
# 🌐 Netzwerk-Checker v2.2
# Autor: haku0x | Lizenz: MIT

set -euo pipefail
trap 'echo -e "\n\033[1;91m❌ Ein Fehler ist aufgetreten.\033[0m"; exit 1' ERR

function header() {
  clear
  echo -e "\n\033[1;96m╔══════════════════════════════════════════════════╗\033[0m"
  echo -e "\033[1;96m║             🌐 IP & Netzwerk-Checker              ║\033[0m"
  echo -e "\033[1;96m║                 für Debian/Linux                 ║\033[0m"
  echo -e "\033[1;96m╚══════════════════════════════════════════════════╝\033[0m\n"
}

function show_menu() {
  header
  echo -e "\033[1;93m[1]\033[0m 🌍 Öffentliche IP-Adresse anzeigen"
  echo -e "\033[1;93m[2]\033[0m 🖥️  Lokale IPs & Netzwerkschnittstellen"
  echo -e "\033[1;93m[3]\033[0m 📡 DNS-Konfiguration anzeigen"
  echo -e "\033[1;93m[4]\033[0m 📶 Internet Speedtest (fast.com)"
  echo -e "\033[1;93m[5]\033[0m 📤 Ping-Test zu google.de"
  echo -e "\033[1;93m[6]\033[0m 🔁 Alle Informationen auf einmal anzeigen"
  echo -e "\033[1;93m[7]\033[0m 🚪 Beenden"
  echo -ne "\n🔢 \033[1mAuswahl eingeben [1-7]: \033[0m"
  read -r CHOICE
  case $CHOICE in
    1) public_ip;;
    2) private_ips;;
    3) dns_info;;
    4) run_speedtest;;
    5) ping_test;;
    6) show_all;;
    7) echo -e "\n👋 \033[1;92mBeende Skript...\033[0m"; exit 0;;
    *) echo -e "\n❗ \033[1;91mUngültige Eingabe. Bitte erneut versuchen.\033[0m"; sleep 1; show_menu;;
  esac
}

function public_ip() {
  echo -e "\n🌍 Öffentliche IP-Adresse:"
  curl -s https://ipinfo.io/ip || echo "(Fehler bei Abfrage)"
  back_to_menu
}

function private_ips() {
  echo -e "\n🖧 Netzwerk-Schnittstellen & lokale IPs:"
  ip -brief address show | grep -v lo || echo "(Keine Schnittstellen gefunden)"
  back_to_menu
}

function dns_info() {
  echo -e "\n🔍 DNS-Server laut /etc/resolv.conf:"
  grep nameserver /etc/resolv.conf || echo "(Keine DNS-Server gefunden)"
  back_to_menu
}

function run_speedtest() {
  if ! command -v fast &> /dev/null; then
    echo -e "\n📦 Installiere fast-cli (benötigt npm)..."
    apt update && apt install -y npm
    npm install --global fast-cli
  fi
  echo -e "\n📊 Führe Speedtest via fast.com durch..."
  fast || echo "(Speedtest fehlgeschlagen)"
  back_to_menu
}

function ping_test() {
  echo -e "\n📤 Sende Ping an google.de..."
  ping -c 4 google.de || echo "(Ping fehlgeschlagen)"
  back_to_menu
}

function show_all() {
  public_ip_no_menu
  private_ips_no_menu
  dns_info_no_menu
  ping_test_no_menu
  echo -e "\n📊 Speedtest:"
  fast || echo "(Speedtest fehlgeschlagen)"
  back_to_menu
}

function public_ip_no_menu() {
  echo -e "\n🌍 Öffentliche IP-Adresse:"
  curl -s https://ipinfo.io/ip || echo "(Fehler bei Abfrage)"
}

function private_ips_no_menu() {
  echo -e "\n🖧 Netzwerk-Schnittstellen & lokale IPs:"
  ip -brief address show | grep -v lo || echo "(Keine Schnittstellen gefunden)"
}

function dns_info_no_menu() {
  echo -e "\n🔍 DNS-Server laut /etc/resolv.conf:"
  grep nameserver /etc/resolv.conf || echo "(Keine DNS-Server gefunden)"
}

function ping_test_no_menu() {
  echo -e "\n📤 Ping zu google.de:"
  ping -c 4 google.de || echo "(Ping fehlgeschlagen)"
}

function back_to_menu() {
  echo -e "\n🔁 Zurück zum Menü..."; read -n 1 -s -r -p "Taste drücken..."
  show_menu
}

show_menu
