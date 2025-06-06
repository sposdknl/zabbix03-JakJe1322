# Automatizovaná instalace Zabbix Agent2 na Ubuntu (SPOS DK)

Tento repozitář obsahuje nástroje pro automatizované nasazení Zabbix Agent2 na virtuální stroj s Ubuntu 22.04 pomocí Vagrant a VirtualBoxu. Projekt je určen pro výuku v rámci předmětu SPOS DK.

## Obsah repozitáře

- `Vagrantfile` – definice virtuálního stroje, port forwarding, SSH přístup a provisioning skriptů.
- `install-zabbix-agent2.sh` – skript pro instalaci Zabbix agenta a všech potřebných balíčků.
- `configure-zabbix-agent2.sh` – skript pro konfiguraci agenta, včetně generování unikátního hostname.
- `id_rsa.pub` – veřejný SSH klíč, který je během provisioningu zkopírován do virtuálního stroje.

## Požadavky

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- Linux/macOS nebo WSL s bash prostředím

## Rychlý start

1. Klonujte repozitář:

   ```bash
   git clone https://github.com/your-org/spos-zabbix-vagrant.git
   cd spos-zabbix-vagrant
   ```

2. Spusťte virtuální stroj:

   ```bash
   vagrant up
   ```

   Tímto dojde ke:
   - stažení boxu `ubuntu/jammy64`
   - vytvoření VM s 2 CPU a 2 GB RAM
   - instalaci Zabbix Agent2 a pluginů
   - nastavení unikátního hostname (pomocí `uuidgen`)
   - konfiguraci agenta pro připojení k serveru `enceladus.pfsense.cz`

## Výsledná konfigurace agenta

Po provisioningu bude soubor `/etc/zabbix/zabbix_agent2.conf` obsahovat například následující nastavení:

```ini
Hostname=ubuntu-8e714c18
Server=enceladus.pfsense.cz
ServerActive=enceladus.pfsense.cz
Timeout=30
HostMetadata=SPOS
```

Hostname je generován náhodně při prvním spuštění, aby bylo možné identifikovat jednotlivé stroje v rámci Zabbix serveru bez konfliktu.

## Přístup a testování

Po spuštění VM je možné se připojit přes SSH:

- Host IP: `127.0.0.1`
- Port: `2202`
- Uživatelské jméno: `vagrant`

Test funkčnosti agenta:

```bash
zabbix_agent2 -t agent.ping
```

## Volitelné skripty

Ve `Vagrantfile` jsou připravené (zakomentované) řádky pro ruční spouštění instalačních a konfiguračních skriptů, pokud je potřeba je spustit mimo základní provisioning:

```ruby
# config.vm.provision "shell", path: "install-zabbix-agent2.sh"
# config.vm.provision "shell", path: "configure-zabbix-agent2.sh"
```

## Použití ve výuce

Repozitář je určen pro výukové účely. Umožňuje studentům seznámit se s:

- nástrojem Vagrant a provisioningem
- instalací a konfigurací monitorovacích nástrojů
- automatizací správy systémů

## Licence

Tento projekt je určen pro interní použití v rámci výuky předmětu SPOS DK. Distribuce mimo výukové prostředí je možná pouze se souhlasem vyučujícího.
