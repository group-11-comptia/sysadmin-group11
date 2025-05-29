#!/bin/bash

BACKUP_PATH="$HOME/.backup_storage"
LOG_FILE="$BACKUP_PATH/history.log"
EXCLUDE_LIST="$BACKUP_PATH/exclude_list.txt"

mkdir -p "$BACKUP_PATH"

auto_schedule_backup() {
    cron_job="0 2 * * * $PWD/backup_utility.sh --auto >> $HOME/cron_backup_output.log 2>&1"
    echo "$cron_job" | crontab -
    echo "🕑 Daily auto-backup has been scheduled for 2:00 AM."
}

create_backup() {
    read -p "📁 Directory to back up: " source_dir
    if [ ! -d "$source_dir" ]; then
        echo "⚠️  Specified directory doesn't exist."
        return
    fi

    read -p "📝 Name your backup (no extension): " backup_label
    timestamp=$(date +%Y%m%d_%H%M%S)
    archive_file="$BACKUP_PATH/${backup_label}_${timestamp}.tar.gz"

    echo -e "🔄 Creating archive...\n"
    tar -czf "$archive_file" --exclude-from="$EXCLUDE_LIST" "$source_dir"

    if [ $? -eq 0 ]; then
        echo "$(date): Backup saved to $archive_file" >> "$LOG_FILE"
        echo "✅ Backup complete: $archive_file"
    else
        echo "❌ An error occurred while creating the backup."
    fi
}

extract_backup() {
    echo "📂 Available Archives:"
    ls -1 "$BACKUP_PATH"/*.tar.gz
    read -p "🗂️  Filename to restore: " archive_name
    read -p "📍 Restore location: " restore_path

    mkdir -p "$restore_path"
    tar -xzf "$BACKUP_PATH/$archive_name" -C "$restore_path"
    echo "✅ Successfully restored to: $restore_path"
}

check_integrity() {
    read -p "🔍 Enter backup file to check: " test_file
    gzip -t "$BACKUP_PATH/$test_file"
    if [ $? -eq 0 ]; then
        echo "✅ Archive integrity confirmed."
    else
        echo "❌ Corrupted or unreadable backup file."
    fi
}

prune_old_backups() {
    retain_count=5
    echo "♻️  Cleaning up... Keeping latest $retain_count backups."
    ls -tp "$BACKUP_PATH"/*.tar.gz | grep -v '/$' | tail -n +$((retain_count + 1)) | xargs -I {} rm -f -- {}
    echo "✅ Old backups removed."
}

# Interactive menu loop
while true; do
    clear
    echo "==============================================="
    echo "         📦 PERSONAL BACKUP CONSOLE"
    echo "==============================================="
    echo "1. Make a backup"
    echo "2. Recover from backup"
    echo "3. Schedule daily backup"
    echo "4. View backup log"
    echo "5. Remove older backups"
    echo "6. Check backup file integrity"
    echo "7. Configure exclusions"
    echo "8. Exit to main menu"
    echo "==============================================="

    read -p "Select an action [1-8]: " choice

    case $choice in
        1) create_backup ;;
        2) extract_backup ;;
        3) auto_schedule_backup ;;
        4) cat "$LOG_FILE"; read -p $'\nPress any key to continue...' ;;
        5) prune_old_backups ;;
        6) check_integrity ;;
        7)
            echo "🛑 Enter items to exclude (one per line). Press Ctrl+D when done:"
            cat > "$EXCLUDE_LIST"
            echo "✅ Saved to: $EXCLUDE_LIST"
            ;;
        8) break ;;
        *) echo "❌ Invalid input. Try again." && sleep 1 ;;
    esac
done

