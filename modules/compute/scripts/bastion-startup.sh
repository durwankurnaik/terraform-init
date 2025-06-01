#!/bin/bash

# Log start of script
echo "Starting bastion setup at $(date)" >> /var/log/startup-script.log

# Update system
apt-get update -y

# Install useful tools
apt-get install -y curl wget htop

# Create .ssh directory for ubuntu user
mkdir -p /home/ubuntu/.ssh
chown ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh

# Store the private key for bastion to access other VMs
cat << 'EOF' > /home/ubuntu/.ssh/id_rsa
${private_key}
EOF

# Set proper permissions for private key
chmod 600 /home/ubuntu/.ssh/id_rsa
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa

# Create SSH config to avoid strict host key checking for internal communication
cat << 'EOF' > /home/ubuntu/.ssh/config
# Config for internal network communication
Host 10.*
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR
    User ubuntu

# Default settings for all hosts
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
EOF

chmod 600 /home/ubuntu/.ssh/config
chown ubuntu:ubuntu /home/ubuntu/.ssh/config

# Log completion
echo "Bastion setup completed successfully at $(date)" >> /var/log/startup-script.log
echo "Private key installed and SSH config created" >> /var/log/startup-script.log