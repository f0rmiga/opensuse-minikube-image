#!/bin/bash

set -o nounset

#======================================
# Load functions.
#--------------------------------------
# shellcheck disable=SC1091
test -f /.kconfig && source /.kconfig
# shellcheck disable=SC1091
test -f /.profile && source /.profile

#======================================
# Greet.
#--------------------------------------
# shellcheck disable=SC2154
echo "Configure image: [$kiwi_iname]..."

#======================================
# Mount system filesystems.
#--------------------------------------
baseMount

#======================================
# Setup baseproduct link.
#--------------------------------------
suseSetupProduct

#======================================
# Add missing gpg keys to rpm.
#--------------------------------------
suseImportBuildKey
rpm --import /root/virtualization-containers.key
rm /root/virtualization-containers.key

#======================================
# Activate services.
#--------------------------------------
baseInsertService sshd
baseInsertService chronyd

ln -s --no-target-directory /usr/lib/systemd /lib/systemd
baseInsertService minikube-automount

#======================================
# Setup default target, multi-user.
#--------------------------------------
baseSetRunlevel 3

#==========================================
# Remove package docs.
#------------------------------------------
rm -rf /usr/share/doc/packages/*
rm -rf /usr/share/doc/manual/*
rm -rf /opt/kde*

#======================================
# SuSEconfig.
#--------------------------------------
suseConfig

#======================================
# Disable UseDNS.
#--------------------------------------
printf "%b" "
UseDNS no
GSSAPIAuthentication no
MaxSessions 200
UsePAM no
X11Forwarding no
PrintLastLog no
" >> /etc/ssh/sshd_config

#======================================
# Fix zypper defaults.
#--------------------------------------
printf "%b" "
solver.allowVendorChange = true
solver.onlyRequires = true
" >> /etc/zypp/zypp.conf

#======================================
# Write sudoers file.
#--------------------------------------
printf "%b" "
root ALL=(ALL) ALL
%wheel ALL=(ALL) NOPASSWD: ALL
" >> /etc/sudoers

#======================================
# Set $PATH for the docker user.
#--------------------------------------

echo "" >> /home/docker/.bashrc
echo 'export PATH="/bin:/sbin:/usr/bin:/usr/sbin"' >> /home/docker/.bashrc

#======================================
# Extra docker configuration
#--------------------------------------
perl -p -i -e '
# Recommended by minikube
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/
s@^(DOCKER_OPTS=".*?) *(")@$1 --exec-opt=native.cgroupdriver=systemd $2@
' /etc/sysconfig/docker

#======================================
# Disable multi kernel.
#--------------------------------------
sed -i 's/^multiversion/# multiversion/' /etc/zypp/zypp.conf

#======================================
# Remove non-static files.
#--------------------------------------
rm -rf /var/log/YaST2/config_diff_*.log
rm -rf /etc/zypp/repos.d/dir-*.repo

#======================================
# Prevent rebuilds.
#--------------------------------------
touch /var/lib/zypp/AutoInstalled
touch /var/lib/zypp/LastDistributionFlavor

#======================================
# Disable cronjobs.
#--------------------------------------
rm -rf /etc/cron.daily/*

#======================================
# Remove YaST if not in use.
#--------------------------------------
suseRemoveYaST

#======================================
# Umount kernel filesystems.
#--------------------------------------
baseCleanMount

#======================================
# Minikube symlinks.
#--------------------------------------

ln -sf /mnt/sda1/var/lib/rkt-etc /etc/rkt

ln -sf /mnt/sda1/var/log /tmp/log

ln -sf /mnt/sda1/var/lib/localkube /var/lib/localkube

#======================================
# Boot symlinks.
#--------------------------------------

ln -sf "$(readlink /boot/vmlinuz)" /boot/bzimage

#--------------------------------------

exit 0
