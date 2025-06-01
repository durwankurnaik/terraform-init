#!/bin/bash

# Log start of script
echo "Starting VM setup at $(date)" >> /var/log/startup-script.log

# Update system
apt-get update -y

# Install useful tools
apt-get install -y curl wget htop

# Ensure .ssh directory exists for ubuntu user
mkdir -p /home/ubuntu/.ssh
chown ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh

# The public key is already added via metadata ssh-keys
# But we ensure it's in authorized_keys as well for redundancy
echo "${public_key}" >> /home/ubuntu/.ssh/authorized_keys

# Remove duplicates and set proper permissions
sort /home/ubuntu/.ssh/authorized_keys | uniq > /tmp/authorized_keys
mv /tmp/authorized_keys /home/ubuntu/.ssh/authorized_keys
chmod 600 /home/ubuntu/.ssh/authorized_keys
chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys

# Ensure SSH service is running and enabled
systemctl enable ssh
systemctl start ssh

# Configure SSH daemon for better security
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

# Log completion
echo "VM setup completed successfully at $(date)" >> /var/log/startup-script.log
echo "SSH access configured for bastion communication" >> /var/log/startup-script.log