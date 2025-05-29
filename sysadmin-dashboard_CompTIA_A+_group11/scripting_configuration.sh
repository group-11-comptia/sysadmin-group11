#!/bin/bash

# ────────────────────────────────
# ⚙️  CONFIGURATION & ARGUMENTS LOADER
# ────────────────────────────────

CONFIG_FILE="./config.conf"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# Environment overrides cascade like whispered secrets
: "${BACKUP_DIR:=${ENV_BACKUP_DIR:-$BACKUP_DIR}}"
: "${LOG_LEVEL:=${ENV_LOG_LEVEL:-$LOG_LEVEL}}"
: "${DEBUG_MODE:=${ENV_DEBUG_MODE:-$DEBUG_MODE}}"

# Command-line flags: subtle switches in the machine’s heart
HEADLESS=false

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --headless) HEADLESS=true ;;
        --debug)    DEBUG_MODE="true" ;;
        --backup-dir=*) BACKUP_DIR="${1#*=}" ;;
        --log-level=*)  LOG_LEVEL="${1#*=}" ;;
        *)
            echo -e "\033[0;31m⚠️  Unknown option: $1\033[0m"
            ;;
    esac
    shift
done

# Illuminate the shadows with debug whispers
debug_log() {
    if [[ "$DEBUG_MODE" == "true" ]]; then
        echo -e "\033[0;36m[DEBUG]\033[0m $1"
    fi
}

# Main pulse of the script
main() {
    debug_log "Debug Mode: $DEBUG_MODE"
    debug_log "Backup Directory: $BACKUP_DIR"
    debug_log "Log Level: $LOG_LEVEL"
    debug_log "Headless Mode: $HEADLESS"

    echo -e "\n✅ Configuration loaded successfully!"
    echo -e "🗂️  BACKUP_DIR  = ${BACKUP_DIR:-<not set>}"
    echo -e "📋 LOG_LEVEL   = ${LOG_LEVEL:-<not set>}"
    echo -e "🐞 DEBUG_MODE  = ${DEBUG_MODE:-<false>}"
    echo -e "🎭 HEADLESS MODE = $HEADLESS"
}

main
