#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

#setup noctalia stack
dnf5 install -y noctalia
dnf5 install -y noctalia-greeter
dnf5 install -y umbriel-nightly

# sed -i "s/autostart = \[\]/autostart = ['noctalia']/1" /usr/share/umbriel/config.toml
# sed -i "s/command =.*/command = \"/usr/bin/noctalia-greeter-session\"" /etc/greetd/config.toml

#replace plasmalogin with greetd
systemctl disable --now plasmalogin.service
systemctl enable --now greetd

#### Example for enabling a System Unit File

systemctl enable podman.socket
