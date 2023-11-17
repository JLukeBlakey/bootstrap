#!/bin/bash

zenbook_debian_ssh_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDgS2LXdAl/G4TJsKI7P60/OMqDNJFc88bB0MSXQ8bK26w0C1xjIokY1/7tM0RUoCA0a5JTDTTc0ROv6MAILMS6N48eXgJ2Np1ZXmMOc895oPTrULUpLxB0wmCMfV+1g3AoIXVrgQQXMMNQzHWDEM6GhEjww1X0M+/5bQucu5KTnZgw8H3AOXIusnH3XqUPPPq6pqXhxcIxpCnh4MGPH1cGN3JGP/c+aHn64gpoMp1S670CGvT8GnQsdTqBDsRaG6cAI6OWWgFPvx+U+QbGzb+aGuOntjJOB9bHlTkJnZYQ7qz/KbN/qdLNZ7eRsNepVoH0J0JHCsbPnQ4ipWjqsj6blkScAygfEKbWplqdMpgxNrkcNcZ1iqX+EfWywmRMu5Yn61iy7xFig8n+CKaOy6yTt/VnPmkoFe6uKzPac6aSjv9Gv1f4c/CL6crqg8yL7NHK3zjO7O4ibL6cIINl503/BhmOIG5RR0FE37gV2zNpCobz9GejvP1dsFBeepyh9us= luke@debian.zenbook"

apt-get update
apt-get upgrade --yes

useradd luke --shell /bin/bash --create-home
echo "luke	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
mkdir /home/luke/.ssh
ssh-keygen -f /home/luke/.ssh/id_rsa -P "" -C luke@"$(hostname)"
echo "$zenbook_debian_ssh_key" > /home/luke/.ssh/authorized_keys
chmod 600 /home/luke/.ssh/authorized_keys
chown -R luke: /home/luke/.ssh
