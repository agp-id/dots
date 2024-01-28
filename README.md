# DOTFILES
![Screenshot my desktop](/assets/desktop.png)
![Screenshot my desktop](/assets/terminal.png)
![Screenshot my desktop](/assets/cava.png)
## My Device and System:
**Device** : SSD ekstenal (portable os, encrypted data partition, boot on MBR/GPT)<br />
**Display** : 1366x768 (best resolution for my dots)<br />
**OS** : Linux<br />
**Distro** : Artix (runit)<br />
**Network manager** : Connman<br />
**Display server** : Xorg<br />
**Display Manager** : none (Xinit)<br />
**WM** : BSPWM<br />
**Bar** : Polybar<br />
**Shell** : Fish (interactive shell)<br />
**Terminal** : st (suckless simple terminal)<br />
**Text editor** : Neovim<br />
**Browser** : Firefox<br />
**File manager** : Thunar<br />
## How to use my dolfiles:
### Required:
- Arch Linux base
- Clean installation without Display Manager is recomended (using xinit instead)

### Cloning repo:
```bash
sudo pacman -Sy git
git clone https://github.com/agp-id/dots
cd dots
```
### Check packages:
You can add, remove or replace packages in `pkg.list`
```bash
nvim pkg.list  #use your texteditor i.e: nano, vi or vim
```
### Run setup script:
```bash
sh ./1_setup_bspwm_arch.sh
```
Follow the steps.

### Run Stow script (enable config):
You can run this script from `Setup script`, or using command
```bash
sh ./2_stow_config.sh
```
Reboot system.

## Thanks to:
- Allah SWT
- Internet
- Open source devs
