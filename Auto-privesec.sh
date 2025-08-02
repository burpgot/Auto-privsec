#!/bin/bash

# ┌────────────────────────────────────────────────────┐
# │      🔓 ZAR Privilege Escalation Helper Tool       │
# └────────────────────────────────────────────────────┘
#        Author: ZAR | Designed for beginner hackers
# -----------------------------------------------------

# Colors for stylish output
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
NC="\033[0m"

OUTPUT_FILE="privesc_report.txt"
echo "" > $OUTPUT_FILE

banner() {
  echo -e "${BLUE}"
  echo "  ╔══════════════════════════════════════════════════════╗"
  echo "  ║            ZAR :: Privilege Escalation Tool          ║"
  echo "  ║        Auto SUID + GTFOBins + Kernel CVEs + Cron     ║"
  echo "  ║            Designed for Beginner Pentesters          ║"
  echo "  ╚══════════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

header() {
  echo -e "\n${YELLOW}[*] $1${NC}"
  echo -e "[*] $1" >> $OUTPUT_FILE
}

success() {
  echo -e "${GREEN}[+] $1${NC}"
  echo -e "[+] $1" >> $OUTPUT_FILE
}

fail() {
  echo -e "${RED}[-] $1${NC}"
  echo -e "[-] $1" >> $OUTPUT_FILE
}

info() {
  echo -e "${CYAN}[i] $1${NC}"
  echo -e "[i] $1" >> $OUTPUT_FILE
}

banner

# Root Check
header "Checking if you are already root..."
if [ "$EUID" -eq 0 ]; then
  success "You are already root! 🎉"
  exit 0
else
  info "You are not root. Let's find a way in..."
fi

# Host Info
header "System Info"
uname -a | tee -a $OUTPUT_FILE
id | tee -a $OUTPUT_FILE
cat /etc/*release 2>/dev/null | tee -a $OUTPUT_FILE

# SUID Checker
header "Searching for SUID Binaries..."
find / -perm -4000 -type f 2>/dev/null | tee suid_found.txt | tee -a $OUTPUT_FILE

# Match with GTFOBins
header "Checking SUID Binaries against GTFOBins..."
while read -r line; do
  bin=$(basename "$line")
  if curl -s https://gtfobins.github.io/gtfobins/$bin/ | grep -q 'sudo'; then
    success "$bin appears on GTFOBins: Potential SUID Exploit!"
    echo "$bin => https://gtfobins.github.io/gtfobins/$bin/" >> $OUTPUT_FILE
  fi
done < suid_found.txt

# Check for writable paths in PATH (for PATH hijacking)
header "Checking PATH for writable directories..."
IFS=':' read -ra DIRS <<< "$PATH"
for dir in "${DIRS[@]}"; do
  if [ -w "$dir" ]; then
    success "Writable PATH directory: $dir — Possible PATH Hijack!"
  fi
done | tee -a $OUTPUT_FILE

# Cron Jobs
header "Looking for cron jobs..."
(crontab -l 2>/dev/null; ls -la /etc/cron* 2>/dev/null) | tee -a $OUTPUT_FILE

# Kernel Exploits
header "Running linux-exploit-suggester.sh (if present)"
if [ -f "linux-exploit-suggester.sh" ]; then
  bash linux-exploit-suggester.sh | tee -a $OUTPUT_FILE
else
  fail "linux-exploit-suggester.sh not found. Please place it in the same directory."
fi

# Basic Exploits Try
header "Trying basic local exploits (dirtycow / overlayfs)"
EXPLOIT_TRIES=0

if grep -q "Ubuntu 16\|4.4.0" /etc/*release 2>/dev/null; then
  info "Target matches old Ubuntu with DirtyCow potential."
  ((EXPLOIT_TRIES++))
fi

if [ $EXPLOIT_TRIES -eq 0 ]; then
  fail "No known direct exploits match, use output above for manual escalation."
else
  info "Possible exploits detected. Review and compile manually for safety."
fi

# Final Words
header "Final Notes"
echo -e "Results saved in: ${YELLOW}$OUTPUT_FILE${NC}"
info "Review GTFOBin links and linux-exploit-suggester output for the best chances."
echo -e "${GREEN}Done! Happy hacking 😎${NC}"
