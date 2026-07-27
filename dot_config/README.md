# 🛠️ Dot Config

Personal configuration files (dotfiles) for macOS, managed via symlinks to this repository.

## 🚀 Quick Start / Tutorial

Follow these steps to synchronize your system with this repository:

### 1. Clone the repository
Ensure this repository is located at `~/Documents/dotfiles/dot_config`.

### 2. Run the Migration Script
If you are setting up a new machine or have fresh configurations, use the provided migration script:
```bash
cd ~/Documents/dotfiles/dot_config
chmod +x migrate.sh
./migrate.sh
```
This script will:
- Back up your existing configs.
- Move them into this repository.
- Create symlinks from the original locations back to this folder.

### 3. Manual Symlinking (One-by-One)
If you prefer manual control, use the `ln -s` command:
```bash
# Example: Symlink Zsh config
ln -sf ~/Documents/dotfiles/dot_config/zsh/zshrc ~/.zshrc
```

---

## 📂 Repository Structure

| Application | Repo Path | System Path |
| :--- | :--- | :--- |
| **Zsh** | `zsh/zshrc`, `zprofile`, `p10k.zsh` | `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh` |
| **Neovim** | `nvim/` | `~/.config/nvim` |
| **Git** | `git/gitconfig`, `git/config/` | `~/.gitconfig`, `~/.config/git` |
| **Karabiner** | `karabiner/` | `~/.config/karabiner` |
| **Cursor** | `cursor/setting.json` | `~/Library/Application Support/Cursor/User/settings.json` |
| **Lazygit** | `lazygit/` | `~/.config/lazygit` |
| **Raycast** | `raycast/` | `~/.config/raycast` |
| **WebStorm** | `webstorm/dot_ideavimrc` | `~/.ideavimrc` |
| **Alacritty** | `alacritty/alacritty.yml` | `~/.config/alacritty/alacritty.yml` |

---

## 🤖 AI Agent Instructions

This repository is designed to be **AI-friendly**. If you are an AI agent assisting with configuration:

1.  **Context**: All configuration files are stored here but active on the system via **absolute symlinks**.
2.  **Editing**: When asked to modify a configuration (e.g., "Add an alias"), edit the file **inside this directory**. The changes will reflect immediately on the system.
3.  **Migration**: If a new configuration folder is discovered in `~/.config/` that isn't here, use the `migrate.sh` logic to move it into the repo and symlink it back.
4.  **No Nested Folders**: Ensure migration does not create redundant nesting (e.g., `nvim/nvim/init.lua`). The repo folder should be the direct replacement for the `~/.config/` counterpart.
5.  **Validation**: After editing, always check if the corresponding application needs a reload (e.g., `source ~/.zshrc`).
