#!/usr/bin/env bash
source "$HOME/gothic/.scripts/variables.bash"

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
dir="$CONFIG/rofi"
theme='style-3_1'

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(whoami)

shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "Goodbye ${USER}" \
        -mesg "Uptime: $uptime" \
        -theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
    rofi -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme ${dir}/confirm.rasi
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
            systemctl suspend
        elif [[ $1 == '--logout' ]]; then
            if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
                openbox --exit
            elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
                bspc quit
            elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
                i3-msg exit
            elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
                qdbus org.kde.ksmserver /KSMServer logout 0 0 0
            else
                session=$(loginctl session-status | head -n 1 | awk '{print $1}')
                loginctl terminate-session $session
            fi
        fi
    else
        exit 0
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
    run_cmd --shutdown
    ;;
$reboot)
    run_cmd --reboot
    ;;
$lock)
    hyprlock -c "$CONFIG/hypr/hyprlock.conf"
    ;;
$suspend)
    run_cmd --suspend
    ;;
$logout)
    run_cmd --logout
    ;;
esac
