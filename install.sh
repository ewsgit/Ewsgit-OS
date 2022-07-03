#!/bin/bash

# EwsgitOS © 2022 Ewsgit
# Licensed under the MIT license: https://ewsgit.mit-license.org

pacman -Syy -v
pacman -S git -v
git clone https://github.com/ewsgit/Ewsgit-OS/tree/installation-testing/
cd installation-testing
cd installation
./keyboard_layout.sh
