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

# Download init.lua from jarbus.net
echo "Downloading init.lua..."
curl -o ~/init.lua https://jarbus.net/init.lua || { echo "Failed to download init.lua"; exit 1; }

# Add alias to .bashrc if not already present
if ! grep -q "alias nvim='nvim -u ~/init.lua'" ~/.bashrc; then
  echo "Adding alias to ~/.bashrc..."
  echo "alias nvim='nvim -u ~/init.lua'" >> ~/.bashrc || { echo "Failed to add alias"; exit 1; }
else
  echo "Alias already exists in ~/.bashrc"
fi

# Inform user to reload .bashrc manually
echo "Please run 'source ~/.bashrc' to apply the changes."

echo "Setup complete."
