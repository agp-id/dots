#!/bin/env sh

echo -e "Installing Dependencies: \n"
paru -S --needed --noconfirm make gcc pkgconf \
      ttf-jetbrains-mono-nerd #ttf-menlo-powerline-git libxft-bgra

#install
sudo make clean install
