#!/bin/bash

# Function to print CTF Recon logo
print_logo() {
    echo "        ____ _____ _____   ____                      "
    echo "       / ___|_   _|  ___| |  _ \ ___  ___ ___  _ __  "
    echo "      | |     | | | |_    | |_) / _ \/ __/ _ \| '_ \ "
    echo "      | |___  | | |  _|   |  _ <  __/ (_| (_) | | | |"
    echo "       \____| |_| |_|     |_| \_\___|\___\___/|_| |_|"

                                                              
}
print_logo
# Function to display script usage
display_usage() {
    echo "Usage: $0 [-h] [targate IP] [directory name]"
    echo "Options:"
    echo "  -h      Display this help message"
    echo "Arguments:"
    echo "  targate IP       IP address of the target"
    echo "  directory name   Name of the directory to create"
}

# Function to check if an IP address is valid and pingable
validate_ip() {
    local ip="$1"
    local regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    
    if [[ $ip =~ $regex ]]; then
        # Split the IP address into octets
        IFS='.' read -r -a octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if [[ $octet -lt 0 || $octet -gt 255 ]]; then
                echo -e "\e[31m[ERROR] Invalid IP address format\e[0m"
                return 1 # Invalid octet
            fi
        done
        
        # Ping the IP address
        if ping -c 1 "$ip" > /dev/null 2>&1; then
            return 0 # Everything is OK
        else
            echo -e "\e[31m[ERROR] Target IP is down\e[0m"
            return 1 # Ping failed
        fi
    else
        echo -e "\e[31m[ERROR] Invalid IP address format\e[0m"
        return 1 # Invalid IP address format
    fi
}

# Main script
if [[ $1 == "-h" ]]; then
    display_usage
    exit 0
fi

if [[ $# -ne 2 ]]; then
    echo -e "\e[31m[ERROR] Invalid number of arguments\e[0m"
    display_usage
    exit 1
fi
ip="$1"
createDirectory="$2"

if ! warning_message=$(validate_ip "$ip"); then
    echo "$warning_message"
else
    echo -e "\e[32m[+] Target IP is up\e[0m"
    if [[ -d "$createDirectory" ]]; then
        read -p "Directory already exists. Do you want to continue? (y/n): " continue_choice
        if [[ $continue_choice == "y" ]]; then
            cd "$createDirectory" || { echo -e "\e[31m[ERROR] Unable to change directory\e[0m"; exit 1; }
            scanning "$ip"
        else
            exit
        fi
    else
        if [[ -f nmap.result ]]; then
            read -p "nmap.result file already exists. Do you want to rescan the IP? (y/n): " rescan_choice
            if [[ $rescan_choice == "y" ]]; then
                echo -e "\e[32m[+] Nmap Scanning Started...\e[0m"
                nmap -A -T4 "$ip" > nmap.result || { echo -e "\e[31m[ERROR] Nmap scanning failed\e[0m"; exit 1; }
                echo -e "\e[32m[+] Scanning Complete\e[0m"
            else
                read -p "Enter HTTP Port: " httpPort
                echo -e "\e[32m[+] Directory Fuzzing Started...\e[0m"
                gobuster dir -u "http://$ip:$httpPort" -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -t 100 -t 100 -o gobuster.result || { echo -e "\e[31m[ERROR] Gobuster directory fuzzing failed\e[0m"; exit 1; }
                echo -e "\e[32m[+] Fuzzing Complete\e[0m"
            fi
        else
            echo -e "\e[32m[+] Nmap Scanning Started...\e[0m"
            nmap -A -T4 "$ip" > nmap.result || { echo -e "\e[31m[ERROR] Nmap scanning failed\e[0m"; exit 1; }
            echo -e "\e[32m[+] Scanning Complete\e[0m"
            read -p "Enter HTTP Port: " httpPort
            echo -e "\e[32m[+] Directory Fuzzing Started...\e[0m"
            gobuster dir -u "http://$ip:$httpPort" -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -t 100 -t 100 -o gobuster.result || { echo -e "\e[31m[ERROR] Gobuster directory fuzzing failed\e[0m"; exit 1; }
            echo -e "\e[32m[+] Fuzzing Complete\e[0m"
        fi
    fi
fi
