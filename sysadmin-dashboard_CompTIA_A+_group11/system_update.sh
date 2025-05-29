#!/bin/bash

HISTORY_FILE="$HOME/update_history.log"

detect_package_manager() {
    if command -v apt &> /dev/null; then
        PM="apt"
    elif command -v dnf &> /dev/null; then
        PM="dnf"
    elif command -v yum &> /dev/null; then
        PM="yum"
    elif command -v pacman &> /dev/null; then
        PM="pacman"
    elif command -v zypper &> /dev/null; then
        PM="zypper"
    else
        echo "❌ Unsupported package manager."
        exit 1
    fi
}

check_updates() {
    echo "🔍 Checking for updates..."
    case $PM in
        apt) sudo apt update ;;
        dnf) sudo dnf check-update ;;
        yum) sudo yum check-update ;;
        pacman) sudo pacman -Sy ;;
        zypper) sudo zypper refresh ;;
    esac
    echo "✅ Check complete."
    read -p $'\nPress enter to continue...'
}

show_package_details() {
    echo "📦 Available updates:"
    case $PM in
        apt) apt list --upgradable ;;
        dnf|yum) sudo $PM check-update ;;
        pacman) pacman -Qu ;;
        zypper) zypper lu ;;
    esac
    read -p $'\nPress enter to continue...'
}

apply_updates() {
    read -p "⚠️ Apply updates? [y/n]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "$(date): Applying updates..." >> "$HISTORY_FILE"
        case $PM in
            apt)
                sudo apt upgrade -y | tee -a "$HISTORY_FILE"
                ;;
            dnf|yum)
                sudo $PM upgrade -y | tee -a "$HISTORY_FILE"
                ;;
            pacman)
                sudo pacman -Syu --noconfirm | tee -a "$HISTORY_FILE"
                ;;
            zypper)
                sudo zypper update -y | tee -a "$HISTORY_FILE"
                ;;
        esac
        echo "✅ Updates applied."
    else
        echo "❌ Update canceled."
    fi
    read -p $'\nPress enter to continue...'
}

view_update_history() {
    echo "📜 Update History:"
    cat "$HISTORY_FILE"
    read -p $'\nPress enter to continue...'
}

toggle_auto_updates() {
    echo "⚙️  Toggle auto-updates"
    case $PM in
        apt)
            file="/etc/apt/apt.conf.d/20auto-upgrades"
            if [ -f "$file" ]; then
                sudo sed -i 's/"1"/"0"/g' "$file"
                echo "🔁 Disabled automatic updates."
            else
                echo 'APT::Periodic::Update-Package-Lists "1";' | sudo tee "$file"
                echo 'APT::Periodic::Unattended-Upgrade "1";' | sudo tee -a "$file"
                echo "✅ Enabled automatic updates."
            fi
            ;;
        *)
            echo "❌ Auto-update toggle not implemented for $PM."
            ;;
    esac
    read -p $'\nPress enter to continue...'
}

detect_package_manager

while true; do
    clear
    echo "==============================================="
    echo "         🔄 SYSTEM UPDATE MODULE"
    echo "==============================================="
    echo "1. Check for updates"
    echo "2. Show package details"
    echo "3. Apply updates"
    echo "4. View update history"
    echo "5. Enable/Disable automatic updates"
    echo "6. Return to main menu"
    echo "==============================================="
    read -p "Choose an option [1-6]: " option

    case $option in
        1) check_updates ;;
        2) show_package_details ;;
        3) apply_updates ;;
        4) view_update_history ;;
        5) toggle_auto_updates ;;
        6) break ;;
        *) echo "❌ Invalid option." && sleep 1 ;;
    esac
done
