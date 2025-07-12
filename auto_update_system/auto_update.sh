#!/bin/bash

LOGFILE="$HOME/auto_update.log"

echo "----------" >> "$LOGFILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Avvio aggiornamento automatico..." >> "$LOGFILE"

# Aggiorna lista pacchetti
sudo apt-get update >> "$LOGFILE" 2>&1

# Aggiorna pacchetti installati
sudo apt-get -y upgrade >> "$LOGFILE" 2>&1

# Aggiorna eventuali pacchetti con cambiamenti nelle dipendenze
sudo apt-get -y dist-upgrade >> "$LOGFILE" 2>&1

# Rimuove pacchetti non più necessari
sudo apt-get -y autoremove >> "$LOGFILE" 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S') - Aggiornamento completato, riavvio tra 30 secondi..." >> "$LOGFILE"

sleep 30

# Riavvia il sistema
sudo reboot
