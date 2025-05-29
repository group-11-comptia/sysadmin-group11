#!/bin/bash

# ==== Verify Required Tools ====
check_tools() {
    local tools=()
    for tool in "$@"; do
        command -v "$tool" >/dev/null 2>&1 || tools+=("$tool")
    done

    if [ ${#tools[@]} -gt 0 ]; then
        echo "❌ The following tools are missing: ${tools[*]}"
        echo "➡ Please install them and retry."
        exit 1
    fi
}

# Example use: check_tools curl grep awk

# ==== Ensure Root Privileges ====
ensure_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "🔒 Administrator access is required."
        echo "💡 Tip: Use sudo to run this script."
        exit 1
    fi
}

# ==== Validate Numeric Input ====
is_numeric() {
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "🚫 Invalid entry: '$1' is not a number."
        return 1
    fi
    return 0
}

# ==== Confirm User Exists ====
check_user_exists() {
    if ! id "$1" >/dev/null 2>&1; then
        echo "👤 Error: User '$1' not found."
        return 1
    fi
    return 0
}

# ==== Execute with Timeout Limit ====
exec_with_timeout() {
    local limit="$1"
    shift
    timeout "$limit" "$@" 2>/dev/null || echo "⏳ Timeout: Task exceeded $limit seconds."
}

# ==== Catch Unexpected Failures ====
handle_failure() {
    echo "❗ Unexpected failure encountered."
    echo "🔍 Investigate your inputs, permissions, or logic."
    exit 1
}

# Trigger the trap on error
trap handle_failure ERR
