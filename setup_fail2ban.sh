### Sample Script Content (`setup_fail2ban.sh`)
#If you wanna host this yourself or tweak it, here's the script. Save it as `setup_fail2ban.sh`, make it executable (`chmod +x setup_fail2ban.sh`), and push to GitHub.

```bash
#!/bin/bash

# Easy Fail2Ban Setup Script
# Author: Mohamad Reza Moghadasi
# Version: 1.0

set -e  # Bail on errors

echo "Hey! Kicking off Fail2Ban setup..."

# Gotta be root, folks
if [[ $EUID -ne 0 ]]; then
   echo "Run this as root or with sudo, please!"
   exit 1
fi

# Update and install
apt update -qq
apt install -y fail2ban

# Drop in the SSH jail config
cat > /etc/fail2ban/jail.d/sshd.conf << EOF
[sshd]
enabled = true
port = all
filter = sshd
logpath = /var/log/auth.log
maxretry = 6
findtime = 180
bantime = 120
ignoreip = 1.1.1.1
backend = auto
banaction = iptables-allports
EOF

# Fire it up
systemctl restart fail2ban
systemctl enable fail2ban

echo "All set! Fail2Ban is installed and guarding your SSH."
echo "Quick check: fail2ban-client status sshd"
