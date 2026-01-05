#!/usr/bin/env bash

set -e

IP=$(ip route get 1 2>/dev/null | awk '{print $7; exit}')

# Fallback for macOS
if [ -z "$IP" ]; then
  IP=$(ipconfig getifaddr en0 2>/dev/null || true)
fi

if [ -z "$IP" ]; then
  echo "❌ Could not determine local IP address"
  exit 1
fi

DEV_URL="http://$IP:5173/"
echo "▶ Using dev server URL: $DEV_URL"

pnpm run dev:web &
DEV_PID=$!

npx cap sync

NODE_ENV=development \
CAPACITOR_SERVER_URL="$DEV_URL" \
npx cap run android &
CAP_PID=$!

trap "kill $DEV_PID $CAP_PID" EXIT
wait
