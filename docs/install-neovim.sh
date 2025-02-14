#!/bin/bash

# Create ~/bin directory if it doesn't exist
if [ ! -d "$HOME/bin" ]; then
  echo "Creating ~/bin directory..."
  mkdir -p "$HOME/bin" || { echo "Failed to create ~/bin directory"; exit 1; }
fi

# Add ~/bin to PATH if not already present
if ! grep -q "export PATH=\$HOME/bin:\$PATH" ~/.bashrc; then
  echo "Adding ~/bin to PATH in ~/.bashrc..."
  echo "export PATH=\$HOME/bin:\$PATH" >> ~/.bashrc || { echo "Failed to add ~/bin to PATH"; exit 1; }
  export PATH="$HOME/bin:$PATH"
else
  echo "~/bin is already in PATH."
fi

# Check if Neovim is running and warn the user
if pgrep nvim > /dev/null; then
  echo "Warning: Neovim is running. Please close it before proceeding."
  exit 1
fi

# Download the latest Neovim AppImage to a temporary file
echo "Downloading latest Neovim AppImage..."
curl -L -o nvim.appimage.tmp https://github.com/neovim/neovim/releases/latest/download/nvim.appimage || { echo "Failed to download Neovim"; exit 1; }
chmod u+x nvim.appimage.tmp

# Rename temporary file to nvim.appimage
mv -f nvim.appimage.tmp "$HOME/bin/nvim" || { echo "Failed to move Neovim to ~/bin"; exit 1; }

# Make config directory if it doesn't exist
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "Creating ~/.config/nvim directory..."
  mkdir -p "$HOME/.config/nvim" || { echo "Failed to create ~/.config/nvim directory"; exit 1; }
fi

echo "Downloading init.lua..."
curl -L -o "$HOME/.config/nvim/init.lua" https://jarbus.net/init.lua || { echo "Failed to download init.lua"; exit 1; }

echo "Downloading tmux.conf..."
curl -L -o "$HOME/.tmux.conf" https://jarbus.net/tmux.conf || { echo "Failed to download tmux.conf"; exit 1; }

echo "Downloading latest lf binary..."
curl -L -o "$HOME/bin/lf" https://jarbus.net/lf || { echo "Failed to download lf"; exit 1; }

echo "Downloading lfrc..."
curl -L -o "$HOME/.config/lf/lfrc" https://jarbus.net/lfrc || { echo "Failed to download lfrc"; exit 1; }
echo "Downloading lfcd... to .config"
curl -L -o "$HOME/.config/lf/lfcd" https://jarbus.net/lfcd || { echo "Failed to download lfcd"; exit 1; }

# Source lfcd to bashrc
if ! grep -q "source ~/.config/lf/lfcd" ~/.bashrc; then
  echo "Adding lfcd to ~/.bashrc..."
  echo "source ~/.config/lf/lfcd" >> ~/.bashrc || { echo "Failed to add lfcd to .bashrc"; exit 1; }
else
  echo "lfcd is already sourced in .bashrc."
fi

# Inform user to reload .bashrc manually
echo "Please run 'source ~/.bashrc' to apply the changes."

echo "Setup complete."
