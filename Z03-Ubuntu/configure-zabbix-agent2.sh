#!/usr/bin/env bash

# Ukončit skript při chybě
set -e

# Vygenerování unikátního hostname
UNIQUE_HOSTNAME="ubuntu-$(uuidgen)"
SHORT_HOSTNAME=$(echo "$UNIQUE_HOSTNAME" | cut -d'-' -f1,2)

echo "Nastavuji hostname na: $SHORT_HOSTNAME"

# Záloha původního konfiguračního souboru Zabbix agenta
CONFIG_FILE="/etc/zabbix/zabbix_agent2.conf"
BACKUP_FILE="${CONFIG_FILE}-orig"

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "Provádím zálohu původního konfiguračního souboru..."
  sudo cp -v "$CONFIG_FILE" "$BACKUP_FILE"
else
  echo "Záložní soubor již existuje, zálohu nepřepisuji."
fi

# Úprava konfiguračního souboru pomocí sed
echo "Provádím úpravy konfiguračního souboru Zabbix agenta..."

sudo sed -i "s/^Hostname=.*/Hostname=$SHORT_HOSTNAME/" "$CONFIG_FILE"
sudo sed -i "s/^Server=.*/Server=enceladus.pfsense.cz/" "$CONFIG_FILE"
sudo sed -i "s/^ServerActive=.*/ServerActive=enceladus.pfsense.cz/" "$CONFIG_FILE"
sudo sed -i "s/^# Timeout=3/Timeout=30/" "$CONFIG_FILE"
sudo sed -i "s/^# HostMetadata=.*/HostMetadata=SPOS/" "$CONFIG_FILE"

# Zobrazení rozdílů oproti originálu
echo "Rozdíly oproti původnímu konfiguračnímu souboru:"
sudo diff -u "$BACKUP_FILE" "$CONFIG_FILE" || true

# Restart služby
echo "Restartuji službu zabbix-agent2..."
sudo systemctl restart zabbix-agent2

echo "Konfigurace Zabbix agenta dokončena."

# EOF
