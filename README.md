# 🛡️ Kali WSL Ultimate Setup Script

<div align="center">

![Kali Linux](https://img.shields.io/badge/Kali_Linux-557C94?style=for-the-badge&logo=kali-linux&logoColor=white)
![WSL](https://img.shields.io/badge/WSL-0a97f5?style=for-the-badge&logo=windows&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Version](https://img.shields.io/badge/Version-2.1.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**An automated Kali Linux WSL setup and cybersecurity toolkit installer**

**Developed by ROWNOK AHMED KHAN**  
*Cyber Security Analyst & Digital Design Specialist*

</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Installation](#quick-installation)
- [Installation Flow](#installation-flow)
- [Package Options](#package-options)
- [Directory Structure](#directory-structure)
- [Commands & Aliases](#commands--aliases)
- [Advanced Functions](#advanced-functions)
- [Error Handling](#error-handling)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)
- [Version History](#version-history)

---

## Overview

**Kali WSL Ultimate Setup Script** is an automated Bash-based installer designed to transform a fresh **Kali Linux WSL2** environment into an organized cybersecurity testing workstation.

The script automates system preparation, package installation, directory creation, aliases, helper scripts, verification, logging, and common recovery operations.

### Key Benefits

- One-command installation
- Five predefined installation levels
- Automated dependency handling
- APT/DPKG recovery mechanisms
- Network recovery support
- Comprehensive installation logging
- Organized cybersecurity workspace
- Custom command aliases
- Automated project creation
- Post-installation verification
- Optional GUI support through Kali Win-KeX

---

# Features

## 🔧 Automated Installation

- Automated system preparation
- Five predefined package levels
- Dependency installation
- Batch package installation
- Installation verification
- Automatic cleanup
- Installation summary

## 🛠️ Error Handling & Recovery

- Automatic APT/DPKG recovery
- Retry mechanism for failed installations
- `--fix-missing` support
- Package reinstall support
- Network/DNS recovery
- Permission recovery
- Detailed error logging

## 🎨 Professional Interface

- Color-coded terminal output
- ASCII banner
- Developer information
- Progress indicators
- Installation status messages
- Interactive package selection

## 📁 Workspace Organization

The installer creates a structured cybersecurity workspace containing:

- Scan results
- Loot/evidence
- Reports
- Scripts
- Wordlists
- Custom tools
- Projects
- Notes
- Backups

## ⚡ Automation

The setup provides custom aliases and helper functions for:

- Network scanning
- Reconnaissance
- Web testing
- Packet capture
- System information
- Project creation
- Installation verification

---

# 🧰 Included Tool Categories

Depending on the selected installation level, the toolkit can include:

### Network Scanning

- Nmap
- Masscan
- Netcat
- Net-tools
- IPRoute2

### Packet Analysis

- Wireshark
- Tcpdump

### Web Testing

- Gobuster
- Nikto
- WhatWeb
- FFUF
- Feroxbuster
- SQLMap
- WPScan
- OWASP ZAP

### Enumeration

- Enum4linux
- DNSRecon
- SSLScan
- Whois
- Traceroute

### Exploitation & Security Testing

- Metasploit Framework
- Hydra
- Aircrack-ng
- Reaver
- Bully
- Impacket
- CrackMapExec

### Password & Hash Testing

- John the Ripper
- Hashcat

### Forensics

- Foremost
- TestDisk
- Autopsy

### Python Security Tools

- Scapy
- Impacket
- Python Requests
- BeautifulSoup
- Python-Nmap

### GUI

- Kali Win-KeX

> Tool availability depends on the selected package level and the packages currently available from the configured Kali repositories.

---

# Prerequisites

## System Requirements

| Requirement | Minimum | Recommended |
|---|---|---|
| Operating System | Windows 10 Build 19041+ | Windows 11 |
| WSL | WSL2 | Latest WSL2 |
| RAM | 4 GB | 8 GB+ |
| Disk Space | 5 GB | 20 GB+ |
| CPU | 2 Cores | 4+ Cores |
| Internet | Broadband | High-speed |

## Pre-Installation Checklist

Run the following commands inside Kali Linux WSL:

```bash
wsl --list --verbose
wsl --list --all
sudo -v
ping -c 4 8.8.8.8
df -h /
free -h
```

---

# Quick WSL Setup

If WSL/Kali is not already installed, open **Windows PowerShell as Administrator**:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

wsl --set-default-version 2

wsl --install -d kali-linux

shutdown /r /t 5
```

After Windows restarts, launch Kali Linux and complete the initial user setup.

---

# Quick Installation

## Method 1 — Direct Installation

> Recommended when you trust the repository and want a quick installation.

```bash
curl -sSL https://raw.githubusercontent.com/Rk-000/Kali-Ultimate-Setup-Complete/main/kali_ultimate_setup_complete.sh | bash
```

## Method 2 — Download and Run Manually

```bash
wget [https://raw.githubusercontent.com/rowonk-ahmed-khan/kali-wsl-setup/main/kali_setup.sh](https://raw.githubusercontent.com/Rk-000/Kali-Ultimate-Setup-Complete/main/kali_ultimate_setup_complete.sh

chmod +x kali_ultimate_setup_complete.sh

sed -i 's/\r$//' kali_ultimate_setup_complete.sh

./kali_ultimate_setup_complete.sh
```

## Method 3 — Create the Script Locally

Create a local script file:

```bash
cat > kali_ultimate_setup_complete.sh <<'EOF'
# Paste the contents of kali_setup.sh here
EOF

chmod +x kali_ultimate_setup_complete.sh
sed -i 's/\r$//' kali_ultimate_setup_complete.sh

./kali_ultimate_setup_complete.sh
```

## Method 4 — Using Git Clone

Go To The Desired Folder Where You Want To Download 

```Open Terminal As ROOT
git Clone https://github.com/Rk-000/Kali-Ultimate-Setup-Complete.git

chmod +x kali_ultimate_setup_complete.sh

sed -i 's/\r$//' kali_ultimate_setup_complete.sh

./kali_ultimate_setup_complete.sh
```

> The repository's actual `kali_ultimate_setup_complete.sh` should be used instead of manually copying the script whenever possible.

---

# Installation Flow

```text
START
  │
  ├── Check Prerequisites
  │
  ├── Display Banner
  │
  ├── Select Package Level
  │
  ├── Update System
  │
  ├── Install Required Packages
  │
  ├── Configure Workspace
  │
  ├── Configure Aliases
  │
  ├── Configure Automation Scripts
  │
  ├── Perform Cleanup
  │
  ├── Verify Installation
  │
  ├── Display Installation Summary
  │
  └── COMPLETE
```

---

# Package Options

The installer provides five predefined installation levels.

---

## 1. ⚡ Lightning Core

### Essential Tools

**Best for:** Beginners, basic networking, and lightweight environments.

### Included Tools

- Nmap
- Tcpdump
- Net-tools
- IPRoute2
- Netcat
- Curl
- Wget
- Ping utilities

### Example Commands

```bash
scan 192.168.1.1
ping 8.8.8.8
tcpdump -i any
```

**Approximate size:** ~50 MB

**Approximate tool count:** ~8

---

## 2. 🛡️ Professional Base

### Recommended Daily Security Environment

**Best for:** Security analysts and general cybersecurity workflows.

### Includes

Everything in **Lightning Core**, plus:

- Wireshark
- Gobuster
- WhatWeb
- Nikto
- FFUF
- Python3-pip
- Python3-venv
- DNS utilities
- Whois
- Traceroute

### Example Commands

```bash
wireshark
dirsearch example.com
webscan example.com
```

**Approximate size:** ~200 MB

**Approximate tool count:** ~15

---

## 3. 🔍 Security Analyst

### Web Testing & Enumeration

**Best for:** Web application testing, reconnaissance, enumeration, and security analysis.

### Includes

Everything in **Professional Base**, plus:

- Feroxbuster
- SQLMap
- Hydra
- Enum4linux
- DNSRecon
- SSLScan
- Python-Nmap
- Scapy
- Requests
- BeautifulSoup

### Example Commands

```bash
sqltest example.com
hydra -l admin -P wordlist.txt ssh://TARGET
enum4linux TARGET
```

**Approximate size:** ~400 MB

**Approximate tool count:** ~25

---

## 4. 💥 Pentester Pro

### Full Penetration Testing Environment

**Best for:** Authorized penetration testing, security assessments, CTFs, and advanced security labs.

### Includes

Everything in **Security Analyst**, plus:

- Metasploit Framework
- John the Ripper
- Hashcat
- Dsniff
- ExploitDB
- Aircrack-ng
- Reaver
- Bully
- Impacket
- CrackMapExec

### Example Commands

```bash
msfconsole
john --wordlist=rockyou.txt hash.txt
hashcat -m 0 hash.txt rockyou.txt
```

**Approximate size:** ~1.2 GB

**Approximate tool count:** ~35

---

## 5. 🦾 Cyber Warrior

### Complete Security Arsenal

**Best for:** Comprehensive security testing, bug bounty work, CTFs, penetration testing, and digital forensics.

### Includes

Everything in **Pentester Pro**, plus:

- WPScan
- OWASP ZAP
- BeEF
- Nmap
- Masscan
- Foremost
- TestDisk
- Autopsy
- Kali Win-KeX

### Example Commands

```bash
kex --win -s
foremost -i image.dd
testdisk
autopsy
```

**Approximate size:** ~3 GB+

**Approximate tool count:** 50+

---

# Package Comparison

| Feature | Lightning Core | Professional Base | Security Analyst | Pentester Pro | Cyber Warrior |
|---|:---:|:---:|:---:|:---:|:---:|
| Network Tools | ✅ | ✅ | ✅ | ✅ | ✅ |
| Packet Analysis | ❌ | ✅ | ✅ | ✅ | ✅ |
| Web Testing | ❌ | ✅ | ✅ | ✅ | ✅ |
| Enumeration | ❌ | ❌ | ✅ | ✅ | ✅ |
| Exploitation | ❌ | ❌ | ❌ | ✅ | ✅ |
| Password Testing | ❌ | ❌ | ❌ | ✅ | ✅ |
| Forensics | ❌ | ❌ | ❌ | ❌ | ✅ |
| GUI | ❌ | ❌ | ❌ | ❌ | ✅ |
| Approx. Tools | ~8 | ~15 | ~25 | ~35 | 50+ |
| Approx. Size | ~50 MB | ~200 MB | ~400 MB | ~1.2 GB | ~3 GB+ |

> Package counts and disk usage are approximate and can change as Kali repositories and dependencies are updated.

---

# Directory Structure

The setup creates an organized workspace under the user's home directory:

```text
~/
├── scans/          # Scan output and reconnaissance results
├── loot/           # Extracted data, credentials, and evidence
├── reports/        # Penetration testing and assessment reports
├── scripts/        # Custom Bash and automation scripts
├── wordlists/      # Custom and downloaded wordlists
├── tools/          # Custom and compiled security tools
├── projects/       # Organized security projects
├── notes/          # Personal notes and methodology
└── backups/        # Configuration and data backups
```

## Directory Functions

| Directory | Purpose |
|---|---|
| `~/scans/` | Store scan and reconnaissance results |
| `~/loot/` | Store extracted data and evidence |
| `~/reports/` | Store security assessment reports |
| `~/scripts/` | Store custom automation scripts |
| `~/wordlists/` | Store wordlists |
| `~/tools/` | Store custom tools |
| `~/projects/` | Organize individual projects |
| `~/notes/` | Store documentation and notes |
| `~/backups/` | Store configuration and data backups |

---

# Commands & Aliases

The setup provides convenient aliases and helper commands.

> Exact aliases depend on the package level and the version of the setup script installed.

---

## Network Scanning

```bash
scan 192.168.1.1
scanall 192.168.1.1
scanudp 192.168.1.1
pingsweep 192.168.1.0/24
quick 192.168.1.1
fastscan 192.168.1.1
quick_scan TARGET
```

---

## Reconnaissance

```bash
full_recon example.com
dirsearch example.com
webscan example.com
sqltest example.com
nikto-scan example.com
```

---

## Packet Analysis

```bash
tcpdump
tcpdump -i eth0
tcpdump port 80
wireshark
tailcap
```

---

## System Information

```bash
myip
localip
ports
processes
memory
disk
```

---

## Project Management

```bash
new_project client_name
show_aliases
show_commands
help_me
```

---

## GUI — Cyber Warrior Package

```bash
kex --win -s
kex --sl
kex --stop
```

---

# Advanced Functions

## `quick_scan()`

Performs a fast Nmap scan using:

- Aggressive timing: `-T4`
- Service detection: `-sV`
- OS detection: `-O`
- High packet rate

Example:

```bash
quick_scan TARGET
```

> Only scan systems that you own or have explicit permission to test.

---

## `full_recon()`

Performs automated reconnaissance and organizes the results.

The function can:

1. Create a target directory under `~/scans/`
2. Perform a full-port Nmap scan
3. Perform service/version detection
4. Run default Nmap scripts
5. Attempt OS detection
6. Perform directory enumeration
7. Run web technology fingerprinting
8. Save results under the target directory

Example:

```bash
full_recon example.com
```

---

## `new_project()`

Creates an organized project workspace.

Example:

```bash
new_project client_name
```

Typical project structure:

```text
client_name/
├── scans/
├── loot/
├── reports/
├── notes/
└── backups/
```

---

# Error Handling

## APT/DPKG Recovery

Common recovery commands include:

```bash
sudo dpkg --configure -a
sudo apt --fix-broken install -y
sudo apt install -f -y
sudo apt clean
sudo apt autoclean
sudo apt update --fix-missing
```

## Network Recovery

The installer can attempt to recover common DNS/network problems by:

- Checking network connectivity
- Updating DNS configuration
- Retrying package operations
- Using alternate DNS servers when appropriate

## Permission Recovery

Common permission operations include:

```bash
chmod +x kali_setup.sh
```

> Avoid recursively changing ownership or permissions across your entire home directory unless you understand the consequences.

## Installation Failures

The installer may use:

- Multiple installation attempts
- `--fix-missing`
- Package reinstall operations
- APT recovery
- Error logging

---

# Error Logging

Installation errors can include:

- Timestamp
- Error code
- Line number
- Failed command
- Function context
- Recovery attempts

Example log location:

```text
~/kali_setup_*.log
```

---

# Status Messages

| Symbol | Meaning |
|---|---|
| `✓` | Successful operation |
| `✗` | Error |
| `!` | Warning |
| `i` | Information |
| `✔` | Verification successful |

---

# Verification

## Automated Verification

Run:

```bash
~/scripts/check_status.sh
```

The verification process can check:

- Installed tools
- Executable paths
- Directory structure
- Loaded aliases
- Memory
- Disk usage
- System information

---

## Manual Verification

Check installed tools:

```bash
nmap --version
wireshark --version
gobuster --version
msfconsole --version
```

Check Python packages:

```bash
pip3 list | grep -E "requests|scapy|impacket"
```

Check workspace directories:

```bash
ls -la ~/scans ~/loot ~/reports ~/scripts
```

Check aliases:

```bash
alias | grep -E "scan|recon|myip"
```

Check the configured Bash aliases:

```bash
grep "CYBER_WARRIOR_ALIASES" ~/.bashrc
```

---

# Troubleshooting

## 1. Permission Denied

### Problem

The script does not have execute permission.

### Solution

```bash
chmod +x kali_setup.sh
bash kali_setup.sh
```

---

## 2. `sudo` Not Found

### Solution

```bash
apt-get update
apt-get install -y sudo
```

---

## 3. Network Connectivity Problems

### Problem

DNS resolution fails or APT cannot connect to repositories.

### Check Connectivity

```bash
ping -c 4 8.8.8.8
```

### Temporary DNS Configuration

```bash
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf
```

> WSL may regenerate `/etc/resolv.conf`. For persistent WSL DNS configuration, use the appropriate WSL configuration instead of relying only on manual edits.

---

## 4. APT Fetch Errors

```bash
sudo apt clean
sudo apt autoclean
sudo apt update --fix-missing
sudo apt install -f
```

---

## 5. APT/DPKG Lock Problems

### Problem

APT reports that another process is using the package database.

First, check whether another APT/DPKG process is actually running:

```bash
ps aux | grep -E "apt|dpkg"
```

If no package operation is running, recover the package database:

```bash
sudo dpkg --configure -a
sudo apt --fix-broken install -y
```

> Do not delete APT/DPKG lock files while another package-management process is running.

---

## 6. Broken Packages

```bash
sudo dpkg --configure -a
sudo apt --fix-broken install -y
sudo apt install -f
```

---

# WSL-Specific Troubleshooting

## WSL2 Not Enabled

Run in **PowerShell as Administrator**:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

wsl --set-default-version 2
```

Restart Windows after enabling the required components.

---

## Kali Distribution Not Found

```powershell
wsl --install -d kali-linux
```

Check installed distributions:

```powershell
wsl --list --verbose
```

---

## WSL Not Starting

Try:

```powershell
wsl --shutdown
wsl --update
wsl --set-default-version 2
```

Then start Kali again.

---

# Installation Failures

## Install a Package Manually

```bash
sudo apt install -y PACKAGE_NAME
```

Try again with missing packages:

```bash
sudo apt install -y PACKAGE_NAME --fix-missing
```

Reinstall:

```bash
sudo apt install -y PACKAGE_NAME --reinstall
```

---

## Script Stops Midway

Check the installation log:

```bash
ls -lh ~/kali_setup_*.log
```

Read the latest log:

```bash
cat ~/kali_setup_*.log
```

Then run the setup again:

```bash
./kali_setup.sh
```

---

# Python Package Problems

## `pip3` Not Found

```bash
sudo apt install -y python3-pip
```

## Python Package Installation

Prefer Kali/Debian packages or an isolated virtual environment where possible.

Create a virtual environment:

```bash
python3 -m venv ~/venvs/security
source ~/venvs/security/bin/activate
```

Then install packages:

```bash
python3 -m pip install --upgrade pip
python3 -m pip install PACKAGE_NAME
```

---

# Emergency Recovery

## Backup Configuration First

Before performing destructive recovery operations:

```bash
BACKUP_DIR="$HOME/backup_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP_DIR"

cp ~/.bashrc "$BACKUP_DIR/"
```

Clean unused packages:

```bash
sudo apt autoremove --purge -y
sudo apt autoclean -y
```

> Do not delete `~/scans`, `~/loot`, `~/reports`, `~/scripts`, `~/wordlists`, `~/tools`, or `~/projects` unless you have verified that the data is backed up and can be safely removed.

---

# Log Files

| Log Type | Location | Purpose |
|---|---|---|
| Installation Log | `~/kali_setup_*.log` | Complete installation activity |
| APT Log | `/var/log/apt/` | APT package operations |
| System Log | `/var/log/syslog` | System events |
| Error Log | `~/kali_setup_*.log` | Installation errors and recovery information |

---

# Security Considerations

## 🔐 Secure Your Environment

Protect sensitive directories:

```bash
chmod 700 ~/scans ~/loot ~/reports
```

Protect individual sensitive files:

```bash
chmod 600 ~/loot/* 2>/dev/null
```

Install GPG:

```bash
sudo apt install -y gpg
```

Encrypt a sensitive file:

```bash
gpg -c ~/loot/credentials.txt
```

Generate an SSH ED25519 key:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

---

# Responsible Tool Usage

This project contains tools that can perform security testing, enumeration, password auditing, exploitation, wireless testing, and forensic analysis.

Use them only against:

- Systems you own
- Authorized penetration-testing targets
- Dedicated security laboratories
- CTF environments
- Bug bounty targets within their published scope

### Guidelines

- Always obtain proper authorization before testing systems.
- Follow the target's rules of engagement.
- Respect bug bounty program scope.
- Follow responsible disclosure practices.
- Keep security tools updated.
- Protect collected evidence and credentials.
- Document security testing activities.
- Avoid unauthorized access or disruption.

---

# Legal Compliance

Cybersecurity testing may be regulated by local and international laws.

Examples include:

- **United States:** Computer Fraud and Abuse Act (CFAA)
- **European Union:** General Data Protection Regulation (GDPR)
- **United Kingdom:** Computer Misuse Act (CMA)

Users are responsible for understanding and complying with the laws applicable to their activities and location.

---

# Recommended Security Resources

- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Penetration Testing Execution Standard](http://www.pentest-standard.org/)
- [OSSTMM](https://www.isecom.org/)

---

# Safe Testing Targets

For documentation and basic testing, use intentionally safe targets such as:

- [example.com](https://example.com/)
- [test.example.com](https://test.example.com/)
- Private lab addresses such as `192.168.1.0/24` when they belong to your own network

> Do not assume that a private IP address is authorized merely because it is an RFC1918 address. Test only networks you control or have permission to assess.

---

# Security Checklist

- [ ] Kali Linux is updated
- [ ] WSL2 is properly configured
- [ ] Proper authorization has been obtained
- [ ] Target scope has been confirmed
- [ ] Testing activities are documented
- [ ] Findings are securely stored
- [ ] Sensitive data is protected
- [ ] Tools are regularly updated
- [ ] Important data is backed up
- [ ] Applicable laws and program rules are followed

---

# Contributing

Contributions are welcome.

## How to Contribute

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test your changes thoroughly.
5. Commit your changes.
6. Push the branch.
7. Open a Pull Request.

Example:

```bash
git clone https://github.com/rowonk-ahmed-khan/kali-wsl-setup.git

cd kali-wsl-setup

git checkout -b feature/my-new-feature
```

---

# Contribution Guidelines

## Code Style

- Follow existing Bash conventions.
- Use consistent indentation.
- Add comments for complex logic.
- Use meaningful variable names.
- Keep functions focused and maintainable.
- Avoid unnecessary global variables.
- Validate user input.
- Handle command failures appropriately.

## Documentation

When adding or changing functionality:

- Update `README.md`.
- Document new commands.
- Document new aliases.
- Explain configuration changes.
- Update the version history.
- Update `CHANGELOG.md` if available.

## Testing

Before submitting a Pull Request:

- Test on a clean Kali WSL2 installation.
- Test every affected package level.
- Test error handling.
- Verify aliases.
- Verify directory creation.
- Verify installation logs.
- Verify that existing functionality is not broken.

---

# Contribution Areas

Contributions are welcome in:

- New security tools
- Package management
- Error handling
- Recovery mechanisms
- Terminal UI/UX
- Documentation
- Performance improvements
- Security improvements
- Package profiles
- Automation
- Testing

---

# License

This project is licensed under the **MIT License**.

```text
MIT License

Copyright (c) 2024 ROWNOK AHMED KHAN

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

# Contact

## Developer

**ROWNOK AHMED KHAN**

**Role:** Cyber Security Analyst & Digital Design Specialist

- **Email:** ahmedkhanrowonk@gmail.com
- **Phone:** +88 01725-532232
- **LinkedIn:** [Rownok Ahmed Khan](https://www.linkedin.com/in/rowonk-ahmed-khan-184671352/)
- **Website:** [rownokahmedkhan](https://sites.google.com/view/rownokahmedkhan)

## Support

- **GitHub Issues:** [Open an Issue](https://github.com/rowonk-ahmed-khan/kali-wsl-setup/issues)
- **Email:** ahmedkhanrowonk@gmail.com
- **Project Wiki:** [GitHub Wiki](https://github.com/rowonk-ahmed-khan/kali-wsl-setup/wiki)

---

# Acknowledgments

Special thanks to:

- [Kali Linux](https://www.kali.org/) Team
- [Microsoft WSL](https://learn.microsoft.com/windows/wsl/) Team
- Open Source Community
- All Contributors

---

# Version History

## v2.1.0 — Current

- Fixed heredoc syntax issues
- Enhanced error handling
- Added automatic recovery mechanisms
- Added comprehensive logging
- Improved package verification
- Added README documentation
- Improved installation workflow

## v2.0.0 — Major Update

- Added five package levels
- Added automatic recovery mechanisms
- Added professional terminal UI
- Added GitHub integration
- Improved installation automation

## v1.0.0 — Initial Release

- Basic security tool installation
- Workspace directory creation
- Command aliases
- Initial automation support

---

# ⚠️ Disclaimer

This project is intended for **authorized cybersecurity testing, education, research, CTFs, laboratories, and security assessment environments**.

The author does not condone unauthorized access, exploitation, credential theft, disruption of services, or any activity that violates applicable laws or the rules of a target system.

**You are solely responsible for how you use this software and the tools it installs.**

---

<div align="center">

### 🛡️ Build. Test. Secure.

**Kali WSL Ultimate Setup Script**

Developed by **ROWNOK AHMED KHAN**

</div>
