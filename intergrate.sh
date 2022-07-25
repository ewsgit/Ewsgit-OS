#!/bin/bash

USER_DIR=$PWD

if (("$EUID" != 0)); then
    if [[ -t 1 ]]; then
        sudo -E "$0" "$@"
    else
        gksu "$0" "$@"
    fi
    exit
fi

echo "EwsgitOS install script"

echo "Beginning install"

echo "configurating XDG variables..."

sudo echo "#!/bin/bash" > /etc/profile.d/ewsgit_os_xdg.sh

sudo echo 'export XDG_DATA_HOME="$HOME/config/home"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_CONFIG_HOME="$HOME/config/config"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_STATE_HOME="$HOME/config/state"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_CACHE_HOME="$HOME/config/cache"' >> /etc/profile.d/ewsgit_os_xdg.sh

echo "intergrating defaults"

mv $USER_DIR $USER_DIR/pre_ewsgit-os_backup/
sudo rm ~/ -r

mkdir $USER_DIR/projects
mkdir $USER_DIR/downloads
mkdir $USER_DIR/desktop
mkdir $USER_DIR/config
mkdir $USER_DIR/config/path
mkdir $USER_DIR/config/config
mkdir $USER_DIR/config/state
mkdir $USER_DIR/config/cache
mkdir $USER_DIR/media
mkdir $USER_DIR/remote

cp ./defaults/nvim -r $USER_DIR/config/config/nvim/
cp ./default/bash -r $USER_DIR/config/home/.bash/
cp ./defaults/alacritty -r $USER_DIR/config/config/alacritty
cp ./defaults/i3 -r $USER_DIR/config/config/i3
cp ./defaults/i3status -r $USER_DIR/config/i3status

echo "Installing vim plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "Syncing Repositories"
sudo pacman -Syy --no-confirm
echo "Installing Git"
sudo pacman -S git --no-confirm
echo "installing yay (aur helper)"
sudo git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

yay -S alacritty neovim xorg --answerdiff=None --noconfirm

echo "select a desktop environment to install."
select DESKTOP_ENV in "gnome" "kde" "i3" "continue";
do
    if [$DESKTOP_ENV == "continue"]; then;
	echo "==========="
	echo "  WARNING  "
	echo "==========="
	echo "No Desktop Environment will be installed!"
        echo "The system will reboot shortly"
        break;
    fi
    if [$DESKTOP_ENV == "gnome"]; then;
        echo "Installing the Gnome Desktop Environment"
        yay -S gdm --answerdiff=None --noconfirm
        sudo systemctl enable gdm.service
        yay -S gnome --noconfirm --answerdiff=None
	break;
    fi
    if [$DESKTOP_ENV == "kde"]; then;
        echo "Installing the Kde Desktop Environment"
        yay -S plasma plasma-wayland-session kde-applications --answerdiff=None --noconfirm
        sudo systemctl enable sddm.service
        sudo systemctl enable NetworkManager.service
        echo "Installing FireFox"
        yay -S firefox --noconfirm --answerdiff=None
    	break;
    fi
    if [$DESKTOP_ENV == "kde"]; then;
        echo "Installing the Kde Desktop Environment"
        yay -S plasma plasma-wayland-session kde-applications
        sudo systemctl enable sddm.service
        sudo systemctl enable NetworkManager.service
        echo "Installing FireFox"
        yay -S firefox
    	break;
    fi
    if [$DESKTOP_ENV == "i3"]; then;
	echo "Installing sddm login manager"
	yay -S sddm --answerdiff=None --noconfirm
	sudo systemctl enable sddm
        echo "Installing the i3 Window Manager"
        yay -S i3-gaps --answerdiff=None --noconfirm
        echo "installing NetworkManager"
        yay -S NetworkManager --answerdiff=None --noconfirm
        sudo systemctl disable iwd
        sudo systemctl stop iwd
        sudo systemctl enable NetworkManager
        sudo systemctl start NetworkManager
        echo "installing default i3 configuration files"
        cp ./defaults/i3 ~/config/config/i3
        cp ./defaults/i3status ~/config/config/i3
        echo "installing default applications"
        echo "installing alacritty"
	yay -S alacritty --answerdiff=None --noconfirm
	echo "installing FireFox"
        yay -S firefox --answerdiff=None --noconfirm
        echo "installing picom"
        yay -S picom --answerdiff=None --noconfirm
        echo "installing dmenu"
        yay -S dmenu --answerdiff=None --noconfirm
        yay -S feh --answerdiff=None --noconfirm
        echo "installing NetworkManager Gui and Cli"
        yay -S nmcli --answerdiff=None --noconfirm
        yay -S nm-applet --answerdiff=None --noconfirm
	echo "installing capnet-assistant (manage and display portal wifi login systems)"
	yay -S capnet-assistant
        echo "removing iwd"
        yay -R iwd --answerdiff=None --noconfirm
        yay -R iwctl --answerdiff=None --noconfirm
    	break;
        echo "removing iwd"
        yay -R iwd --answerdiff=None --noconfirm
        yay -R iwctl --answerdiff=None --noconfirm
    fi
done

yay -Syu
sudo reboot
