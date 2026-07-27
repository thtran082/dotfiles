#!/bin/bash

# Base directories
DOT_CONFIG="/Users/yuhnart/Documents/dotfiles/dot_config"
HOME_DIR="/Users/yuhnart"
CONFIG_DIR="/Users/yuhnart/.config"

# Helper to migrate a file or directory
migrate() {
    local src="$1"
    local dest_dir="$2"
    local dest_name="$3"
    
    local dest_path="${DOT_CONFIG}/${dest_dir}/${dest_name}"
    
    echo "Processing ${src}..."
    
    if [ ! -e "${src}" ]; then
        echo "  [SKIPPED] Source ${src} does not exist."
        return
    fi
    
    if [ -L "${src}" ]; then
        echo "  [SKIPPED] ${src} is already a symlink."
        return
    fi
    
    # Create destination directory
    mkdir -p "${DOT_CONFIG}/${dest_dir}"
    
    # Sync to repo
    if [ -d "${src}" ]; then
        echo "  Moving directory to repo..."
        cp -a "${src}/." "${dest_path}/" 2>/dev/null || mkdir -p "${dest_path}" && cp -a "${src}/." "${dest_path}/"
    else
        echo "  Moving file to repo..."
        cp -a "${src}" "${dest_path}"
    fi
    
    # Backup original just in case (optional, but safer)
    # mv "${src}" "${src}.bak"
    
    # Remove original and symlink
    rm -rf "${src}"
    ln -s "${dest_path}" "${src}"
    
    echo "  [DONE] Migrated ${src} -> ${dest_path}"
}

echo "Starting migration of configurations to ${DOT_CONFIG}..."

# 1. ZSH configurations
migrate "${HOME_DIR}/.zshrc" "zsh" "zshrc"
migrate "${HOME_DIR}/.zprofile" "zsh" "zprofile"
migrate "${HOME_DIR}/.p10k.zsh" "zsh" "p10k.zsh"

# 2. Git configurations
migrate "${HOME_DIR}/.gitconfig" "git" "gitconfig"
migrate "${CONFIG_DIR}/git" "git" "config"

# 3. Vim / IDE configurations
migrate "${HOME_DIR}/.ideavimrc" "webstorm" "dot_ideavimrc"

# 4. .config directories
migrate "${CONFIG_DIR}/nvim" "nvim" "nvim" # Wait, the repo has nvim/ directly containing files
# Let's adjust nvim migration to merge properly
if [ -d "${CONFIG_DIR}/nvim" ] && [ ! -L "${CONFIG_DIR}/nvim" ]; then
    echo "Processing ${CONFIG_DIR}/nvim..."
    cp -a "${CONFIG_DIR}/nvim/." "${DOT_CONFIG}/nvim/"
    rm -rf "${CONFIG_DIR}/nvim"
    ln -s "${DOT_CONFIG}/nvim" "${CONFIG_DIR}/nvim"
    echo "  [DONE] Migrated ${CONFIG_DIR}/nvim -> ${DOT_CONFIG}/nvim"
fi

migrate "${CONFIG_DIR}/karabiner" "karabiner" "karabiner"
# Adjust karabiner if it's already in repo as karabiner/karabiner.json
if [ -d "${CONFIG_DIR}/karabiner" ] && [ ! -L "${CONFIG_DIR}/karabiner" ]; then
    # If the repo already has karabiner/karabiner.json, just symlink the whole dir if needed, 
    # but the repo structure seems to be karabiner/karabiner.json
    # Usually ~/.config/karabiner/karabiner.json is the file.
    # Let's check.
    if [ -f "${CONFIG_DIR}/karabiner/karabiner.json" ]; then
        echo "Processing ${CONFIG_DIR}/karabiner/karabiner.json..."
        cp -a "${CONFIG_DIR}/karabiner/karabiner.json" "${DOT_CONFIG}/karabiner/karabiner.json"
        # We can symlink the whole directory if we want, or just the file.
        # Most people symlink the file if they only care about it, but let's do the dir if it's cleaner.
    fi
fi

migrate "${CONFIG_DIR}/lazygit" "lazygit" "lazygit"
migrate "${CONFIG_DIR}/raycast" "raycast" "raycast"

# 5. Cursor settings
CURSOR_SETTINGS="${HOME_DIR}/Library/Application Support/Cursor/User/settings.json"
if [ -f "${CURSOR_SETTINGS}" ] && [ ! -L "${CURSOR_SETTINGS}" ]; then
    echo "Processing Cursor settings..."
    mkdir -p "${DOT_CONFIG}/cursor"
    cp -a "${CURSOR_SETTINGS}" "${DOT_CONFIG}/cursor/setting.json"
    rm -f "${CURSOR_SETTINGS}"
    ln -s "${DOT_CONFIG}/cursor/setting.json" "${CURSOR_SETTINGS}"
    echo "  [DONE] Migrated Cursor settings."
fi

echo "Migration complete!"
