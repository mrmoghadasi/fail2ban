# Fail2Ban Installation and Configuration Guide

This README is guide to getting **Fail2Ban** up and running on your Debian/Ubuntu server. Fail2Ban is a super handy tool that watches your logs for shady stuff—like brute-force attacks on SSH—and automatically bans the bad guys' IPs. It's like a bouncer for your server. Let's make it easy.

## Prerequisites
Before we dive in:
- You're on Debian 10+ or Ubuntu 18.04+ (or similar).
- You've got root or sudo access.
- Internet connection to grab packages.

If that's you, awesome—let's go!

## Manual Installation
Want to do it step by step? No problem. Here's how:

1. **Update your package list:**
```
sudo apt update
```

2. **Install Fail2Ban:**
```
sudo apt install fail2ban
```


3. **Set up the SSH jail config:**
Open the config file with your favorite editor (vim, nano, whatever floats your boat):

```
vim /etc/fail2ban/jail.d/sshd.conf
```


Paste in this config—tweak as needed:

```
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
```


Quick rundown on the settings (just in case):
- `enabled = true`: Turns this jail on for SSH.
- `port = all`: Watches all ports (or swap in your SSH port if you want).
- `maxretry = 6`: Allows 6 failed logins before action.
- `findtime = 180`: Checks the last 3 minutes (180 seconds).
- `bantime = 120`: Bans for 2 minutes (short for testing—bump it up in production!).
- `ignoreip = 1.1.1.1`: Whitelist an IP (like your home one) so you don't lock yourself out.
- `banaction = iptables-allports`: Uses iptables to block 'em.

4. **Start and enable the service:**

```
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban
```


5. **Check if it's humming:**


```
sudo fail2ban-client status sshd
```


## Easy One-Liner Install Script
Too many steps? I've got you. Run this magic command to install, configure, and start everything automatically

```
sh <(curl -s https://raw.githubusercontent.com/mrmoghadasi/fail2ban/refs/heads/main/setup_fail2ban.sh)
```



