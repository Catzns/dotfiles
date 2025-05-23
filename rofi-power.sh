#!/usr/bin/env bash
# A power menu script to be used with Rofi.
# 'rofi -modes power -show power [-config power]'

set -euo pipefail

if [[ -z $@ ]]; then
    echo -en "\0prompt\x1fPower Options\n"
    echo -en "\0active\x1f1\n"
    echo -en "\0urgent\x1f2\n"
    echo ""
    echo ""
    echo ""
    exit
elif [[ $@ == "" ]]; then
    loginctl lock-session
elif [[ $@ == "" ]]; then
    systemctl reboot
elif [[ $@ == "" ]]; then
    systemctl poweroff
fi
