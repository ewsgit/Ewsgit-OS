#!/bin/bash

# Ewsgit OS ©️ 2022 Ewsgit

sudo mkdir /ewsgitos/
sudo chown ewsgit /ewsgitos/

cd /ewsgit/
git clone https://github.com/ewsgit/ewsgit-os .

sudo ./intergrate.sh
