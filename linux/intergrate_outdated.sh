#!/bin/bash

USER_DIR=/home/ewsgit
USER_NAME=ewsgit

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

echo "#!/bin/bash" > /etc/profile.d/ewsgit_os_xdg.sh
echo 'export XDG_DATA_HOME="$HOME/config/local/share/"' >> /etc/profile.d/ewsgit_os_xdg.sh
echo 'export XDG_CONFIG_HOME="$HOME/config/config"' >> /etc/profile.d/ewsgit_os_xdg.sh
echo 'export XDG_STATE_HOME="$HOME/config/local/state"' >> /etc/profile.d/ewsgit_os_xdg.sh
echo 'export XDG_CACHE_HOME="$HOME/config/cache"' >> /etc/profile.d/ewsgit_os_xdg.sh

echo "intergrating defaults"

mv $USER_DIR/* $USER_DIR/pre_ewsgit-os_backup/

mkdir $USER_DIR/projects
mkdir $USER_DIR/downloads
mkdir $USER_DIR/config
mkdir $USER_DIR/config/path
mkdir $USER_DIR/config/config
mkdir $USER_DIR/config/cache
mkdir $USER_DIR/config/local
mkdir $USER_DIR/config/local/share
mkdir $USER_DIR/config/local/state
mkdir $USER_DIR/config/local/bin
mkdir $USER_DIR/mnt
mkdir $USER_DIR/remote

echo "attempting to copy config files from the old locations"
cp $USER_DIR/pre_ewsgit-os_backup/.config/* -r $USER_DIR/config/config/
cp $USER_DIR/pre_ewsgit-os_backup/.local/* -r $USER_DIR/config/local/
cp $USER_DIR/pre_ewsgit-os_backup/.cache/* -r $USER_DIR/config/cache/

cp ./defaults/nvim -r $USER_DIR/config/config/nvim/
cp ./defaults/bash -r $USER_DIR/config/config/ewsgit-bash/
cp ./defaults/bash/.bashrc $USER_DIR
cp ./defaults/alacritty -r $USER_DIR/config/config/alacritty
sudo cp ./defaults/os-release /etc/os-release
cp ./defaults/dmenu_runner $USER_DIR/config/local/bin

echo "Installing vim plug"
sudo -u $USER_NAME sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "Syncing Repositories"
sudo pacman -Syy --noconfirm
echo "Installing Git"
sudo pacman -S git --noconfirm
echo "installing go"
sudo pacman -S go --noconfirm
echo "installing base-devel"
sudo pacman -S base-devel --noconfirm
echo "installing yay (aur helper)"
sudo git clone https://aur.archlinux.org/yay-git.git
cd yay-git
sudo -u $USER_NAME makepkg -si

echo "Installing alacritty"
sudo -u $USER_NAME yay -S alacritty --answerdiff=None --noconfirm
echo "Installing neovim"
sudo -u $USER_NAME yay -S neovim --answerdiff=None --noconfirm
echo "Installing xorg"
sudo -u $USER_NAME yay -S xorg --answerdiff=None --noconfirm
echo "installing the 'Jetbrains Mono typeface'"
sudo -u $USER_NAME yay -S ttf-jetbrains-mono --answerdiff=None --noconfirm
sudo -u $USER_NAME yay -S dkms linux-headers --answerdiff=None --noconfirm
echo "installing nodejs (lts) using nvm (node version manager)"
sudo -u $USER_NAME curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source $USER_DIR/.bashrc
sudo -u $USER_NAME nvm install --lts
echo "installing exa"
sudo -u $USER_NAME yay -S exa
echo "installing neovim pluggins (using vimplug)"
sudo -u $USER_NAME nvim +'PlugInstall --sync' +qa

echo "select a desktop environment to install."
select DESKTOP_ENV in "gnome" "kde" "i3" "continue"; do
	case $DESKTOP_ENV in
		continue)
			echo "==========="
			echo "  WARNING  "
			echo "==========="
        	echo "The system will reboot shortly press ctrl+c to cancel this."
        	sudo -u $USER_NAME yay -Syu
            reboot now
            ;;
		gnome)
        		echo "Installing the Gnome Desktop Environment"
        		sudo -u $USER_NAME yay -S gdm --answerdiff=None --noconfirm
        		systemctl enable gdm.service
        		sudo -u $USER_NAME yay -S gnome --noconfirm --answerdiff=None
			    echo "Installing FireFox"
                sudo -u $USER_NAME yay -S firefox --noconfirm --answerdiff=None
		        echo "Installing Gnome-Tweaks"
                sudo -u $USER_NAME yay -S gnome-tweaks --noconfirm --answerdiff=None
            ;;
    		kde)
			echo "Installing the K Desktop Environment (kde)"
        		sudo -u $USER_NAME yay -S plasma plasma-wayland-session kde-applications --answerdiff=None --noconfirm
        		systemctl enable sddm.service
        		systemctl enable NetworkManager.service
        		echo "Installing FireFox"
        		sudo -u $USER_NAME yay -S firefox --noconfirm --answerdiff=None
    		;;
    		i3)
			    echo "Installing sddm login manager"
			    sudo -u $USER_NAME yay -S sddm --answerdiff=None --noconfirm
			    systemctl enable sddm
		        echo "Installing the i3 Window Manager"
	        	sudo -u $USER_NAME yay -S i3-gaps i3status --answerdiff=None --noconfirm
		        echo "installing NetworkManager"
	        	sudo -u $USER_NAME yay -S NetworkManager --answerdiff=None --noconfirm
	        	systemctl enable NetworkManager
		        systemctl start NetworkManager
        		echo "installing default i3 configuration files"
		        cp ./defaults/i3/ ~/config/config/i3/ -r
        		cp ./defaults/i3status/ ~/config/config/i3status/ -r
		        echo "installing default applications"
	    		echo "installing FireFox"
	        	sudo -u $USER_NAME yay -S firefox --answerdiff=None --noconfirm
        		echo "installing picom"
    			sudo -u $USER_NAME yay -S picom --answerdiff=None --noconfirm
        		echo "installing dmenu"
	        	sudo -u $USER_NAME yay -S dmenu --answerdiff=None --noconfirm
	    		sudo -u $USER_NAME yay -S feh --answerdiff=None --noconfirm
	        	echo "installing NetworkManager Gui and Cli"
	        	sudo -u $USER_NAME yay -S nm-applet --answerdiff=None --noconfirm
		    	echo "installing capnet-assistant (manage and display portal wifi login systems)"
			    sudo -u $USER_NAME yay -S capnet-assist --answerdiff=None --noconfirm
		;;
	esac
done
