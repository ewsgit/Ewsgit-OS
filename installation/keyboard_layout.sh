#!/bin/bash

# EwsgitOS © 2022 Ewsgit
# Licensed under the MIT license: https://ewsgit.mit-license.org

select layout in ls /usr/share/kbd/keymaps/**/*.map.gz; do
  echo $layout
done