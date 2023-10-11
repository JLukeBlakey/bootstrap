#!/bin/bash

zenbook_debian_ssh_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL3rXVOUNPVPvmbkU4c1zsSNSmVCEhH5h+Ii3UJ6Tzs5A8iua+sintD/cBlv4uoPClgpB/wNaWEh/bXl/PEm+xvpwCIC5v1KlpC0FpPgp+nJ7//dNmftDWvyLYAUH6Bik/kE4i5bSQUrMTySPsKkI9tA0TjIQKlzgI9TSeXj4WQ5rXi47bz1RJw22+mGR/mt2hDkpHdaa6S0h2UMwrOOgBlOO7pnS93JvIjQ5/KTzHjHcjkUJf2qSy1SXjfKMyt2kvS/zbHSoq1Fj8BLHGMC8yU/r2hv1+nPD1dINzecfY9HPhv0yhD++06Oi2O4+B7gLfTQsBJjlzrUK/J0UzuyCE/r1hbfpbTXbjQlRRAi9v1fGzYI4oUDTYfnepNn54vVb8YnZNMPPn9SC2PHBJD0iZaeQ84kDbl1XQ5cMG8qUcTIj3RhR/Xl2HixrkHrUgw3eP0iMkTXv7h0KJ2AYQkQVgFMYIkc2KBCLu2NIEoecfVToqUrBgp8AeMQsowXlj1YU= luke@zenbook_debian_gnome"

apt-get update
apt-get upgrade --yes

useradd luke --shell /bin/bash --create-home
echo "luke	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
mkdir /home/luke/.ssh
ssh-keygen -f /home/luke/.ssh/id_rsa -P "" -C luke@"$(hostname)"
echo "$zenbook_debian_ssh_key" > /home/luke/.ssh/authorized_keys
chmod 600 /home/luke/.ssh/authorized_keys
chown -R luke: /home/luke/.ssh

sudo apt-get install git --yes
