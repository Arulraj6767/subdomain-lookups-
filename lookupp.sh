#!/bin/bash

# Enhanced Subdomain Lookup Script
# Uses assetfinder and httprobe to find live subdomains.

echo "============================================="
echo "   Welcome to the Subdomain Lookup Tool!     "
echo "============================================="

# Check if assetfinder is installed
if ! command -v assetfinder &> /dev/null; then
    echo "[!] 'assetfinder' is not installed."
    read -p "Do you want to install it? (y/n): " install_af
    if [[ "$install_af" == "y" || "$install_af" == "Y" ]]; then
        sudo apt update && sudo apt install assetfinder -y
    else
        echo "[-] assetfinder is required. Exiting."
        exit 1
    fi
fi

# Check if httprobe is installed
if ! command -v httprobe &> /dev/null; then
    echo "[!] 'httprobe' is not installed."
    read -p "Do you want to install it? (y/n): " install_hp
    if [[ "$install_hp" == "y" || "$install_hp" == "Y" ]]; then
        sudo apt update && sudo apt install httprobe -y
    else
        echo "[-] httprobe is required. Exiting."
        exit 1
    fi
fi

# Ask user for domain name
read -p "Enter the domain name (example.com): " domain
if [[ -z "$domain" ]]; then
    echo "[!] No domain entered. Exiting."
    exit 1
fi

# Ask user for output directory
read -p "Enter output directory (press Enter to use current directory): " output_dir

# Set default output directory if not specified
if [[ -z "$output_dir" ]]; then
    output_dir=$(pwd)
else
    # Create the directory if it doesn't exist
    mkdir -p "$output_dir"
fi

# Confirm and wait before proceeding
echo "---------------------------------------------"
echo " Target Domain: $domain"
echo " Output File: $output_dir/Subdomains_list.txt"
echo "---------------------------------------------"
read -p "Press Enter to begin scanning..."

# Set output file path
output_file="$output_dir/Subdomains_list.txt"

# Run assetfinder and httprobe
echo "[*] Finding subdomains for $domain ..."
assetfinder -subs-only "$domain" | httprobe | sort -u > "$output_file"

# Display and save results
echo "============================================="
echo "[+] Subdomains found:"
cat "$output_file"
echo "============================================="
echo "[+] Results saved in: $output_file"
echo "============================================="
