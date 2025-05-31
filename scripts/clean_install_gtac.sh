#!/bin/bash

# GTA Connected Server - Install/Update Script for AMD64 Version (as root)
# Author - voidfnc
# This script will:
# 1. Ensure /root/gtac_server_files directory exists.
# 2. Download the specified GTA Connected server version into it.
# 3. Extract and prepare the server.
# 
# Note: This version DOES NOT delete the /root/gtac_server_files directory.
# Existing files from the archive will be overwritten during extraction.
#

echo "GTA Connected Server - Install/Update Script (AMD64 Version)"
echo "-----------------------------------------------------------"

# Ensure script is run as root
if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run as root." >&2
   exit 1
fi

# --- Configuration ---
# This is the direct link for GTAC-Server-Linux-1.7.0.tar.gz (AMD64 version) , modify if using different link or source.
GTAC_DOWNLOAD_URL="https://gtaconnected.com/downloads/server/GTAC-Server-Linux-1.7.0.tar.gz"
# Presumed server binary name after extraction. Verify this if server doesn't run.
GTAC_SERVER_BINARY_NAME="GTACServer"

SERVER_BASE_DIR="/root/gtac_server_files"
DOWNLOAD_FILENAME="GTAC-Server-Linux-1.7.0.tar.gz" # Filename for the downloaded archive, can be modified

# Default ports used by GTA Connected, can be modified
DEFAULT_GAME_PORT="22000"
DEFAULT_HTTP_PORT="22001"
# --- End Configuration ---

echo ""
echo "Step 1: Updating system packages..."
apt update && apt upgrade -y
echo "System update complete."
echo ""

echo "Step 2: Installing/ensuring essential 64-bit dependencies..."
# screen (for backgrounding), wget (downloader), tar (extractor), nano (editor)
# Common 64-bit runtime libraries.
apt install -y screen wget tar nano libstdc++6 libgcc-s1 zlib1g libcurl4 # Using libcurl4 as a common modern version
echo "Dependencies installation complete."
echo ""

echo "Step 3: Ensuring server directory exists..."
mkdir -p "$SERVER_BASE_DIR"
cd "$SERVER_BASE_DIR" || { echo "Failed to create or change to server directory. Exiting."; exit 1; }
echo "Server directory is $SERVER_BASE_DIR"
echo ""

echo "Step 4: Downloading GTA Connected server (AMD64 version)..."
echo "This will overwrite $DOWNLOAD_FILENAME if it already exists."
wget -O "$DOWNLOAD_FILENAME" "$GTAC_DOWNLOAD_URL"

if [ ! -f "$DOWNLOAD_FILENAME" ]; then
    echo "ERROR: Download failed. Please check the URL and your internet connection."
    cd /root # Go back to a safe directory
    exit 1
fi
echo "Download complete: $DOWNLOAD_FILENAME"
echo ""

echo "Step 5: Extracting server files..."
echo "This will overwrite existing files if they are present in the archive."
# Assuming .tar.gz
tar -xvzf "$DOWNLOAD_FILENAME"
echo "Extraction complete. Files are in $PWD"
# Note: The archive might extract into a subdirectory.
# The GTAC-Server-Linux-1.7.0.tar.gz likely extracts files into the current directory
# or a folder named "GTACServer" or similar. The binary path might need adjustment.
echo ""

echo "Step 6: Setting execute permissions for server binary..."
echo "Attempting to set execute permission for '$GTAC_SERVER_BINARY_NAME'."
echo "If this name is incorrect, or if files extracted into a subdirectory, this step might fail or target the wrong file."
echo "After extraction, verify the server binary name and its location. You may need to run 'chmod +x path/to/YourServerBinary' manually."

# Check if the binary is in the current directory (SERVER_BASE_DIR)
if [ -f "$GTAC_SERVER_BINARY_NAME" ]; then
    chmod +x "$GTAC_SERVER_BINARY_NAME"
    echo "Set execute permission on $PWD/$GTAC_SERVER_BINARY_NAME"
# Common for GTAC server, it might extract into a folder named like the executable or "server"
elif [ -d "$GTAC_SERVER_BINARY_NAME" ] && [ -f "$GTAC_SERVER_BINARY_NAME/$GTAC_SERVER_BINARY_NAME" ]; then
    # If it extracted into a folder with the same name as the binary, and the binary is inside
    CURRENT_DIR_BEFORE_CD=$(pwd)
    cd "$GTAC_SERVER_BINARY_NAME" || { echo "Error changing to subdirectory $GTAC_SERVER_BINARY_NAME"; exit 1; }
    chmod +x "$GTAC_SERVER_BINARY_NAME"
    echo "Set execute permission on $PWD/$GTAC_SERVER_BINARY_NAME"
    # Consider cd'ing back if subsequent commands expect to be in SERVER_BASE_DIR
    # For now, the script ends with instructions, so current PWD in next steps is fine.
elif [ -f "Server" ]; then # Fallback to "Server" if "GTACServer" not found directly
    echo "Found 'Server' instead of '$GTAC_SERVER_BINARY_NAME'. Setting permissions for 'Server'."
    chmod +x "Server"
    GTAC_SERVER_BINARY_NAME="Server" # Update for the run instructions
    echo "Set execute permission on $PWD/Server"
else
    echo "WARNING: Could not automatically find '$GTAC_SERVER_BINARY_NAME' or 'Server' directly in $PWD or a subdirectory named '$GTAC_SERVER_BINARY_NAME'."
    echo "Please navigate to the correct directory containing the server executable and run 'chmod +x YourServerBinaryName' manually."
fi
echo ""

echo "Step 7: Configuring Firewall (UFW) - ensuring rules are present..."
echo "Allowing UDP traffic on port $DEFAULT_GAME_PORT (game)"
ufw allow "$DEFAULT_GAME_PORT/udp"
echo "Allowing TCP traffic on port $DEFAULT_HTTP_PORT (http downloads)"
ufw allow "$DEFAULT_HTTP_PORT/tcp"

if ! ufw status | grep -qw active; then
    echo "UFW is not active. Enabling UFW..."
    yes | ufw enable # Automatically answer 'yes' to the prompt.
else
    echo "UFW is already active."
fi
ufw status verbose
echo "Firewall configuration checked/updated."
echo ""

echo "--- GTA Connected Server Install/Update Script Finished ---"
echo ""
echo "CURRENT DIRECTORY: $PWD" # This will be the server base dir or a subdirectory if cd'ed into one
echo ""
echo "NEXT STEPS (Manual):"
echo "1. Ensure you are in the directory containing the server files (currently: '$PWD')."
echo "   If the files extracted into a subdirectory not automatically handled by the chmod step, 'cd' into it if you haven't already."
echo "2. Edit the server configuration file (usually 'server.xml'):"
echo "   nano server.xml"
echo "   (Configure server name, max players, RCON password, resources, etc.)"
echo "3. Verify the server binary name. The script attempted to use '$GTAC_SERVER_BINARY_NAME'."
echo "   If it's different, use the correct name in the run command."
echo "4. To run the server in a detached screen session:"
echo "   screen -S gtac_server_session  # Starts a new screen session"
echo "   ./${GTAC_SERVER_BINARY_NAME}       # Runs the server inside the screen (use correct binary name)"
echo "   (Press Ctrl+A, then D to detach from the screen session)"
echo "5. To reattach to the session later: screen -r gtac_server_session"
echo ""
echo "Please refer to the GTA Connected Wiki for more detailed information."
