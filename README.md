# Network Reconnaissance Tool

This Bash script is designed for CTF (Capture The Flag) players to automate common reconnaissance tasks at the beginning of a CTF challenge. It simplifies the process of performing network scans and directory busting on different target machines, allowing CTF players to quickly gather information and identify potential vulnerabilities.

## Features

- Validates the input format of the target IP address.
- Checks the availability of the target IP address by pinging it.
- Scans the target IP address using Nmap to gather detailed information about open ports and services.
- Performs directory fuzzing on the specified HTTP port using Gobuster.
- Supports rescan functionality if the Nmap result file already exists.

## Prerequisites

- Bash (Bourne Again Shell)
- Nmap (Network Mapper)
- Gobuster

## Usage

```bash
./ctf_recon.sh [targate IP] [directory name]
```

## Example
```bash
./ctf_recon.sh 10.10.10.10 target_directory
```
## Instructions

Before running the script, ensure that the script file has executable permission. You can grant executable permission using the following command:
```bash
chmod +x ctf_recon.sh
```

