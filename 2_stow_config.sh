#!/usr/bin/env sh
## STOW dolfiles script
## By: @agp-id

## Force exit
trap exit SIGINT

## Just user
[[ $(id -u) = 0 ]] && echo "ROOT not alowed !" && exit

## needed before run _line()
clear

## DECOR ===============================================================================
## Colors:
normal=$(tput sgr0) #normal
bold=$(tput bold) #bold
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)

Boldblue="$bold$blue"
Boldred="$bold$red"
Boldyellow="$bold$yellow"

##Title and line----------------------------------------------------------------------
## Usage: _line [symbol [color [title]]]
_line(){
    [[ -z $1 ]] && line="-" || line=$1
    [[ -n $2 ]] && declare -n color=$2 || color=$normal
    [[ -n "$3" ]] && {
        echo $color
        printf "%-$(( ($COLUMNS-${#3}-4)/2 ))s" | sed "s/ /$line/g"
        printf "| $3 |"
        printf "%-$(( ($COLUMNS-${#3}-3)/2 ))s${normal}" | sed "s/ /$line/g"
    } || {
        echo $color
        printf "%-${COLUMNS}s${normal}" | sed "s/ /$line/g"
    }
}

##=========================================================================================
## Check/install STOW
install_stow (){
    sleep 2
    if [[ $(command -v stow) ]]; then
        echo -e $green"----------------------|Installed\n"$normal
    else
        echo -e $purple"----------------------|Installing\n"$normal
        sudo pacman -S --noconfirm --needed stow || error
        install_stow
    fi
    echo
}

## Check dir / file
check (){
    echo ""
    for n in $@; do
        if [[ -L $n ]]; then
            echo "unLINK: $n"
            unlink $n
        elif [[ -f $n || -d $n ]]; then
            rm -rfv $n
        fi
    done
    echo ""
}

## Create dir (unstow)
makedir (){
    for n in $@; do
        [[ ! -d $n ]] &&
        mkdir -pv $n
    done
    echo ""
}

## Error & exit
error (){
    _line = Boldyellow "ERROR !"

    echo "Sorry for error[s] ;')\n"
    exit 1
}

## Git setup ==============================================================================
github_setup (){
    read -p $yellow":: Configur github on your device: $normal[y/N]  " yn
        case $yn in
            [yY])
                printf "Email connected to github: "
                read -r email
                printf "Github username: "
                read -r username
                [ -z $email ] || [ -z $username ] && {
                    echo -e $red"\nPlease insert email and username\n"$normal
                    sleep 1
                    github_setup
                    return
                }
                [[ ! -d ./git/.config/git ]] && mkdir -p ./git/.config/git
                echo -e "[user]\n\temail = $email\n\tname = $username\n[init]\n\tdefaultBranch = main" > ./git/.config/git/config &&
                echo $green"------|Done"$normal
            ;;
            *)
                echo $red"------|Skipped"$normal
                return
            ;;
        esac
}

## bspwm
bspwm (){
    _line - yellow "Bspwm"

    check   ~/.config/bspwm
    stow -v bspwm -t ~/
    sleep 1
}

## cava
cava (){
    _line - yellow "Cava"

    check ~/.config/cava
    makedir ~/.config/cava
    stow -v cava -t ~/
    sleep 1
}

## dunst
dunst (){
    _line - yellow "Cava"

    check   ~/.config/dunst
    stow -v dunst -t ~/
    sleep 1
}

## fish
fish_shell (){
    _line - yellow "Fish"

    ##check fish installed
    [[ $(command -v fish) ]] || {
        echo "Not installed, Skipped!"
        return
    }
    read -p $red":: Remove all file '.*bash*' in home dir ?$normal$bold [Y/n]  "$normal yn
        case $yn in
            * )
                rm -rfv ~/.*bash*
            ;;
            [nN]* )
                return
            ;;
        esac
    check   ~/.config/fish
    makedir ~/.config/fish
    stow -v fish -t ~/
    fish_root

    ## Update completions
    fish << EOF
        fish_update_completions
EOF
    sleep 1
}

## fish root config
fish_root (){
    echo -e $purple"\n-----------|Root\n"$normal
    read -p "${red}:: Make fish config root sama as user?${normal}${bold} [Y/n]${normal}  " yn
        case $yn in
            * )
                sudo rm -rfv root/.config/fish
                sudo mkdir -pv /root/.config/fish/functions
                sudo stow -v fish -t /root
            ;;
            [nN]* )
                return
            ;;
        esac
    sleep 1
}

## gtk
gtk (){
    _line - yellow "GTK"

    check   ~/.config/gtk-*
    makedir ~/.config/gtk-3.0
    stow -v gtk -t ~/
    sleep 1
}

## htop
htop (){
    _line - yellow "Htop"

    check   ~/.config/htop
    stow -v htop -t ~/
    sleep 1
}

## local dir
local_dir (){
    _line - yellow "Local dir (~/.local)"

    check   ~/.local/bin \
            ~/.local/share/applications \
            ~/.local/share/bg \
            ~/.local/share/fonts \
            ~/.local/share/icons \
            ~/.local/share/themes
    makedir ~/.local/share/applications
    stow -v local_dir -t ~/
    sleep 1
}

## mpd & ncmpcpp
ncmpcpp_mpd (){
    _line - yellow "Mpd"

    check   ~/.config/mpd \
            ~/.config/ncmpcpp
    makedir ~/.config/mpd \
            ~/.config/ncmpcpp
    stow -v ncmpcpp_mpd -t ~/
    sleep 1
}

## mpv
mpv (){
   _line - yellow "Mpv"

    check   ~/.config/mpv
    stow -v mpv -t ~/
    sleep 1
}

## neovim
neovim (){
    _line - yellow "Neovim"

    rm -rf ~/.config/nvim
    makedir ~/.config/nvim/autoload
    stow -v neovim -t ~/

    echo
    read -p $red":: Update nvim plug-plugin now ?$normal$bold [Y/n]  "$normal yn
            case $yn in
                [nN]* )
                    echo $red'------------|Skip!'$normal &&return
                ;;
                * )
                    plug_nvim
                ;;
            esac
    sleep 1
}

## Neovim update pluggin
plug_nvim (){
    [[ ! $(command -v nvim) ]] &&
        return
    echo -e $purple"=========|Updating nvim plugin"$normal
    echo $blue"Please wait..." && sleep 2

    nvim +PlugUpdate +q +q &&
        echo -e  $green'\n------------|Done'$normal ||
        echo $red'------------|Skip, no connection!'$normal
}

## picom
picom (){
    _line - yellow "Picom"

    check ~/.config/picom
    stow -v picom -t ~/
    sleep 1
}

## polybar
polybar (){
    _line - yellow "Polybar"

    check ~/.config/polybar
    stow -v polybar  -t ~/
    sleep 1
}

## rofi
rofi (){
    _line - yellow "Rofi"

    check ~/.config/rofi
    stow -v rofi -t ~/
    sleep 1
}

## sxhkd
sxhkd (){
    _line - yellow "Sxhkd"

    check ~/.config/sxhkd
    stow -v sxhkd -t ~/
    sleep 1
}

## thunar
thunar (){
    _line - yellow "Thunar"

    check ~/.config/Thunar
    stow -v thunar -t ~/
    sleep 1
}

## xdg
xdg (){
    _line - yellow "xdg-user-dir"

    check ~/.config/user-dirs.dirs
    makedir ~/.config
    stow -v xdg -t ~/
    sleep 1
}

## System-wide =========================================================================
system (){
    _line = yellow "System-wide Config"

    read -p $yellow":: continue?$normal$bold [Y/n]  "$normal yn
        case $yn in
            * )
                do_it
            ;;
            [nN]* )
                echo $red'Skip!' && return
            ;;
        esac
}

do_it (){
    echo -e "\n$yellow------| Global bash,touchpad and udev rules $normal"
    sleep 1
    sudo mkdir -pv \
        /etc/{X11/{xinit/xinitrc.d,xorg.conf.d},bash/bashrc.d,udev/rules.d}
    sudo stow -v system-wide -t /

    [[ -f /etc/pacman.conf ]] &&
        sleep 1
        echo -e "\n$yellow------| Configur Pacman [and paru].$normal\n"
        sudo sed -i --follow-symlinks \
            -e "s/.*Color/Color/" \
            -e "/.*ILove.*/d" \
            -e "/.*Color/a ILoveCandy" \
            -e "s/.*CheckSpace/CheckSpace/" \
            -e "s/.*VerbosePkgLists/VerbosePkgLists/" \
            -e "s/.*ParallelDown.*/ParallelDownloads\ =\ 4/" \
            -e '/^$/{ :l N; s/^\n$//; t l p; d; }' \
            /etc/pacman.conf

    [[ $(command -v paru) ]] && {
        sudo sed -i --follow-symlinks \
            -e "s/.*BottomUp/BottomUp/" \
            -e "s/.*SudoLoop/SudoLoop/" \
            -e "s/.*\[bin\]/\#[bin\]/" \
            -e "s/.*Sudo\ \=.*/#Sudo\ \=\ doas/" \
            /etc/paru.conf
            ## doas
        [[ "$su" == "doas" ]] && {
            sudo sed -i --follow-symlinks \
                -e "s/.*SudoLoop/#SudoLoop/" \
                -e "s/.*\[bin\]/\[bin\]/" \
                -e "s/.*Sudo\ \=.*/Sudo\ \=\ doas/" \
                /etc/paru.conf
        }
    }
    sleep 1
    read -p "$yellow------| Ignore PowerButton to shutdown ?$normal [Y/n] " yn
        case $yn in
            [nN]* )
                return
            ;;
            * )
                [[ $(grep artix /etc/*-release) ]] &&
                    ## Artix
                    sudo sed -i "s/.*HandlePowerKey.*/HandlePowerKey=ignore/" /etc/elogind/logind.conf ||
                    ## Arch
                    sudo sed -i "s/.*HandlePowerKey.*/HandlePowerKey=ignore/" /etc/systemd/logind.conf

                echo -e $green"---|PowerButton ignored.$normal\nYou can still longress PowerButton to force shutdown"
                sleep 2
            ;;
        esac
    sleep 1
}

##=========================================================================================
## WARNING!
_line = Boldred
_line = Boldblue "STOW Configuration"
_line = Boldred

_line " " Boldred ">>> DWYOR <<<"
_line " " Boldyellow "DON'T just run!"
_line " " normal "----Your current config may be lost----"
read -p $normal$yellow":: Continue?$normal$bold [y/N]  "$normal yn
    case $yn in
        [yY]* )
            :
        ;;
        * )
            echo -e "Bye ;)>\n"
            sleep 1 && exit
        ;;
    esac

## Uncomment to stow config, comment to skip
_line =  Boldblue "Start STOW-ing"
_line - yellow "STOW Package"
install_stow

##list stow:
sleep 2

_line - yellow "Minimal github config"
github_setup

bspwm
cava
dunst
fish_shell
gtk
#htop
local_dir
mpv
ncmpcpp_mpd
neovim
picom
polybar
rofi
sxhkd
thunar
xdg

system

_line = Boldblue FINISH
echo "Please Reboot"
_line - Boldred
