!/bin/bash

echo "configurating XDG variables..."

sudo echo "#!/bin/bash\n" > /etc/profile.d/ewsgit_os_xdg.sh

sudo echo 'export XDG_DATA_HOME="~/config/home"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_CONFIG_HOME="~/config/config"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_STATE_HOME="~/config/state"' >> /etc/profile.d/ewsgit_os_xdg.sh
sudo echo 'export XDG_CACHE_HOME="~/config/cache"' >> /etc/profile.d/ewsgit_os_xdg.sh


echo "intergrating defaults"

cp ./defaults/default_home_dir/ -r ~

cp ./defaults/nvim/ -r ~/config/config/.nvim/
cp ./default/bash -r ~/config/config/.bash/
