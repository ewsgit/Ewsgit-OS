!/bin/bash

echo "configurating XDG variables..."

sudo echo "" > /etc/profile

echo "intergrating defaults"

mkdir ~/.config/

cp ./defaults/nvim/ -r ~/.config/.nvim/
cp ./default/bash -r ~/.config/.bash/
