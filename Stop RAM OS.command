#!/bin/bash
# Double-click in Finder to stop RAM OS.
cd "$(dirname "$0")" || exit 1
bash "bin/ram-stop.sh"
echo ""
echo "You can close this window."
