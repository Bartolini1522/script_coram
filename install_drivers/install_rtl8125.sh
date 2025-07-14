#!/bin/bash

set -e

echo "🧰 Inizio installazione driver Realtek RTL8125 (r8125) via Makefile..."

# Verifica esecuzione come root
if [[ "$EUID" -ne 0 ]]; then
  echo "❌ Devi eseguire questo script come root (usa sudo)"
  exit 1
fi

# Installa pacchetti richiesti
echo "📦 Installazione pacchetti necessari..."
apt update
apt install -y build-essential linux-headers-$(uname -r)

# Imposta la directory del driver (modifica se necessario)
DRIVER_DIR="/home/minipc/Scaricati/r8125-9.016.00/"

if [[ ! -f "$DRIVER_DIR/Makefile" ]]; then
  echo "❌ Makefile non trovato in $DRIVER_DIR"
  echo "👉 Modifica lo script e imposta la directory corretta"
  exit 1
fi

# Entra nella directory
cd "$DRIVER_DIR"

# Pulisce eventuali build precedenti
echo "🧹 Pulizia build precedenti..."
make clean || true

# Compila il driver
echo "🛠️ Compilazione modulo..."
make

# Installa il modulo
echo "📂 Installazione modulo nel kernel..."
make install

# Aggiorna dipendenze dei moduli
depmod -a

# Disabilita driver in conflitto (r8169)
echo "⚙️ Disabilitazione r8169..."
echo "blacklist r8169" > /etc/modprobe.d/blacklist-r8169.conf
modprobe -r r8169 || true

# Carica il nuovo modulo
echo "🔁 Caricamento modulo r8125..."
modprobe r8125

# Verifica
echo "✅ Verifica modulo caricato:"
lsmod | grep r8125 || echo "⚠️ Modulo non caricato"

# Riavvio consigliato
read -p "🔄 Vuoi riavviare il sistema ora? (s/n): " risposta
if [[ "$risposta" =~ ^[sS]$ ]]; then
  reboot
fi
