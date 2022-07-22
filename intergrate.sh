#!/bin/bash

echo "EwsgitOS install script"

echo "Beginning install"

echo "configurating XDG variables..."

sudo echo "#!/bin/bash\n" > /etc/profile.d/ewsgit_os_xdg.sh

sudo echo 'export XDG_DATA_HOME="~/config/home"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_CONFIG_HOME="~/config/config"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_STATE_HOME="~/config/state"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_CACHE_HOME="~/config/cache"' >> /etc/profile.d/ewsgit_os_xdg.sh

echo "installing yay (aur helper)"

echo "intergrating defaults"

sudo rm ~/ -r
mkdir ~/projects
mkdir ~/downloads
mkdir ~/desktop
mkdir ~/config
mkdir ~/config/path
mkdir ~/config/config
mkdir ~/config/state
mkdir ~/config/cache
mkdir ~/media
mkdir ~/remote

cp ./defaults/nvim -r ~/config/config/.nvim/
cp ./default/bash -r ~/config/config/.bash/
cp ./defaults/alacritty -r ~/config/config/alacritty

# TODO: install yay here
echo "Syncing Repositories"
sudo pacman -Syy --no-confirm
echo "Installing Git"
sudo pacman -S git --no-confirm
sudo git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

yay -S alacritty neovim xorg --answerdiff=None --noconfirm

echo "select a desktop environment to install."
select DESKTOP_ENV in "gnome" "kde" "i3" "continue";
do
    if [$DESKTOP_ENV == "continue"]; then;
        echo "The system should reboot shortly"
        break;
    fi
    if [$DESKTOP_ENV == "gnome"]; then;
        echo "Installing the Gnome Desktop Environment"
        yay -S gdm --answerdiff=None --noconfirm
        sudo systemctl enable gdm.service
        yay -S gnome --noconfirm --answerdiff=None
        sudo reboot now

    fi
    if [$DESKTOP_ENV == "kde"]; then;
        echo "Installing the Kde Desktop Environment"
        yay -S plasma plasma-wayland-session kde-applications
        sudo systemctl enable sddm.service
        sudo systemctl enable NetworkManager.service
        echo "Installing FireFox"
        yay -S firefox
        sudo reboot now
    fi
    if [$DESKTOP_ENV == "i3"]; then;
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
        echo "installing FireFox"
        yay -S firefox --answerdiff=None --noconfirm
        echo "installing picom"
        yay -S picom --answerdiff=None --noconfirm
        echo "installing DMenu"
        yay -S dmenu --answerdiff=None --noconfirm
        yay -S feh --answerdiff=None --noconfirm
        echo "installing NetworkManager Gui and Cli"
        yay -S nmcli --answerdiff=None --noconfirm
        yay -S nm-applet --answerdiff=None --noconfirm
        echo "removing iwd"
        yay -R iwd --answerdiff=None --noconfirm
        yay -R iwctl --answerdiff=None --noconfirm
    fi
done

yay -Syu
