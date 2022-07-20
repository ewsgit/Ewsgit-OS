#!/bin/bash

echo "     /\\      "
echo "    /  \\     "
echo "   / /\\ \\   "
echo "  / /  \\ \\ "
echo " /  ----  \\   "
echo " ==     ==     "

echo "configurating XDG variables..."

sudo echo "#!/bin/bash\n" > /etc/profile.d/ewsgit_os_xdg.sh

sudo echo 'export XDG_DATA_HOME="~/config/home"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_CONFIG_HOME="~/config/config"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_STATE_HOME="~/config/state"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_CACHE_HOME="~/config/cache"' >> /etc/profile.d/ewsgit_os_xdg.sh

echo "installing yay (aur helper)"

echo "intergrating defaults"

sudo rm ~/
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

echo "select a desktop environment to install."
select DESKTOP_ENV in "gnome" "kde" "i3" "continue";
do
    if [$DESKTOP_ENV == "continue"]; then;
        echo "The system should reboot shortly"
        break;
    fi
    if [$DESKTOP_ENV == "gnome"]; then;
        echo "Installing the Gnome Desktop Environment"
    fi
    if [$DESKTOP_ENV == "kde"]; then;
        echo "Installing the Kde Desktop Environment"
    fi
    if [$DESKTOP_ENV == "i3"]; then;
        echo "Installing the i3 Window Manager"
        cp ./defaults/i3 ~/config/config/i3
        cp ./defaults/i3status ~/config/config/i3
        yay -S picom
        yay -S i3
        yay -S dmenu
        yay -S feh
        yay -S nmcli
        yay -S nm-applet
        yay -S NetworkManager
        sudo systemctl disable iwd
        sudo systemctl stop iwd
        sudo systemctl enable NetworkManager
        sudo systemctl start NetworkManager
        yay -R iwd
        yay -R iwctl
    fi
done
