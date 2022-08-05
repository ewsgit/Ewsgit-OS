#!/bin/bash

# EwsgitOS © 2022 Ewsgit

export USER_DIR=/home/ewsgit
export USER_NAME=ewsgit

export SCRIPT_VERSION=1

if (("$EUID" != 0)); then
    if [[ -t 1 ]]; then
        sudo -E "$0" "$@"
    else
        gksu "$0" "$@"
    fi
    exit
fi

echo "EwsgitOS intergration script V$SCRIPT_VERSION"

echo "configurating XDG variables"

echo "#!/bin/bash" > /etc/profile.d/ewsgit_os_xdg.sh
echo 'export XDG_DATA_HOME="$HOME/config/local/share/"' >> /etc/profile.d/ewsgit_os_xdg.sh
echo 'export XDG_CONFIG_HOME="$HOME/config/config"' >> /etc/profile.d/ewsgit_os_xdg.sh
echo 'export XDG_STATE_HOME="$HOME/config/local/state"' >> /etc/profile.d/ewsgit_os_xdg.sh
echo 'export XDG_CACHE_HOME="$HOME/config/cache"' >> /etc/profile.d/ewsgit_os_xdg.sh

echo "Backing up current user home to $USER_DIR/pre_ewsgitos_backup/"
mv $USER_DIR/* $USER_DIR/pre_ewsgitos_backup/

echo "Creating default user folders"

mkdir $USER_DIR/projects
mkdir $USER_DIR/downloads
mkdir $USER_DIR/config
mkdir $USER_DIR/config/config
mkdir $USER_DIR/config/local
mkdir $USER_DIR/config/local/share
mkdir $USER_DIR/config/local/state
mkdir $USER_DIR/config/local/bin
mkdir $USER_DIR/config/path
mkdir $USER_DIR/config/cache
mkdir $USER_DIR/mnt
mkdir $USER_DIR/remote

echo "beginning disro-specific installation steps"
select DISTRO in "ubuntu" "arch"; do
    case $DISTRO in
        ubuntu)
            source ./distro/ubuntu.sh
            ;;
        arch)
            source ./distro/arch.sh
            ;;
    esac
done
