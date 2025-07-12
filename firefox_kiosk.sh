#!/bin/bash

# Configurazione
URL="https://coram.it//slider"
LOGFILE="$HOME/firefox_kiosk.log"

# Loop infinito per monitoraggio
while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Avvio Firefox in kiosk mode..." >> "$LOGFILE"
    
    # Avvio Firefox in kiosk mode
    firefox --kiosk "$URL" &

    # Cattura il PID di Firefox
    PID=$!

    # Aspetta che il processo Firefox termini
    wait $PID

    # Se siamo qui, Firefox si è chiuso o crashato
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Firefox terminato (PID: $PID). Riavvio fra 5 secondi..." >> "$LOGFILE"
    sleep 5
done
