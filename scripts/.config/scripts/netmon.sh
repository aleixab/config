#!/bin/bash
# Network monitor — logs latency and packet loss to detect when things break.
# Usage: netmon.sh [logfile]
# Default log: ~/netmon.log

LOG="${1:-$HOME/netmon.log}"
PROXIMUS="192.168.128.1"
FRITZBOX="192.168.128.50"
INTERNET="8.8.8.8"
INTERVAL=10  # seconds between checks

ping_target() {
  local host=$1
  local result
  result=$(ping -c 3 -W 2 "$host" 2>&1)
  local loss=$(echo "$result" | grep -oP '\d+(?=% packet loss)')
  local avg=$(echo "$result" | grep -oP 'rtt.*= [0-9.]+/\K[0-9.]+' )
  echo "${loss:-100}% ${avg:-TIMEOUT}ms"
}

echo "Starting network monitor → $LOG"
echo "Targets: Proximus=$PROXIMUS  FritzBox=$FRITZBOX  Internet=$INTERNET"
echo "Press Ctrl+C to stop."
echo ""

mkdir -p "$(dirname "$LOG")"
echo "# netmon started $(date)" >> "$LOG"

while true; do
  ts=$(date '+%Y-%m-%d %H:%M:%S')

  prox=$(ping_target "$PROXIMUS")
  fritz=$(ping_target "$FRITZBOX")
  inet=$(ping_target "$INTERNET")

  prox_loss=$(echo "$prox" | awk '{print $1}')
  fritz_loss=$(echo "$fritz" | awk '{print $1}')
  inet_loss=$(echo "$inet" | awk '{print $1}')

  line="$ts | Proximus: $prox | FritzBox: $fritz | Internet: $inet"

  echo "$line" >> "$LOG"

  # Print to stdout — highlight issues in red
  if [[ "$prox_loss" != "0%" || "$fritz_loss" != "0%" || "$inet_loss" != "0%" ]]; then
    echo -e "\033[0;31m⚠  $line\033[0m"
  else
    echo "✓  $line"
  fi

  sleep "$INTERVAL"
done
