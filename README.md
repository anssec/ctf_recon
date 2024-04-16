# Network Reconnaissance Tool

This Bash script performs network reconnaissance tasks, including IP address validation, target scanning with Nmap, and directory fuzzing with Gobuster. It provides a simple command-line interface for users to input the target IP address and directory name, and it guides users through the scanning process.

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
