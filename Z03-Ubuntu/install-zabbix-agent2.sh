#!/usr/bin/env bash

# Ukončit skript při chybě
set -e

# Instalace balíčku net-tools (pro příkaz např. `ifconfig`)
echo "Instaluji net-tools..."
sudo apt-get update
sudo apt-get install -y net-tools

# Stažení Zabbix repozitáře
ZABBIX_DEB="zabbix-release_latest+ubuntu22.04_all.deb"
ZABBIX_URL="https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/${ZABBIX_DEB}"

echo "Stahuji Zabbix repozitář..."
wget -q "$ZABBIX_URL"

# Instalace repozitářového balíčku
echo "Instaluji Zabbix repozitář..."
sudo dpkg -i "$ZABBIX_DEB"

# Aktualizace seznamu balíčků
echo "Aktualizuji apt repozitáře..."
sudo apt-get update

# Instalace Zabbix agenta a všech pluginů
echo "Instaluji Zabbix agent2 a pluginy..."
sudo apt-get install -y zabbix-agent2 zabbix-agent2-plugin-*

# Povolení a spuštění služby Zabbix agent2
echo "Povoluji a restartuji službu zabbix-agent2..."
sudo systemctl enable zabbix-agent2
sudo systemctl restart zabbix-agent2

echo "Instalace Zabbix agenta dokončena."

# EOF
