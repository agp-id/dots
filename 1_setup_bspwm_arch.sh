#!/usr/bin/env sh
## Setup BSPWM in Arch linux (base)
## By    : agp-id (@github)

## Force exit
trap exit SIGINT

## Just user
[[ $(id -u) = 0 ]] && echo "DON'T run as root !" && exit

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

##======================================================================================
## Install PARU ------------------------------------------------------------------------
check_paru (){
    _line - yellow "PARU"
    if [[ $(command -v paru) ]]; then
        echo $green'----------------|Installed'$normal

        ## pacman.conf
        echo -e "${yellow}\n==> Applying pacman config${normal}"
        sudo sed -i --follow-symlinks \
            -e "s/.*Color/Color/" \
            -e "/.*ILove.*/d" \
            -e "/.*Color/a ILoveCandy" \
            -e "s/.*CheckSpace/CheckSpace/" \
            -e "s/.*VerbosePkgLists/VerbosePkgLists/" \
            -e "s/.*ParallelDown.*/ParallelDownloads\ =\ 4/" \
            -e '/^$/{ :l N; s/^\n$//; t l p; d; }' \
                /etc/pacman.conf
        ## paru.conf
        echo -e "${yellow}\n==> Applying paru config${normal}"
        sudo sed -i --follow-symlinks \
            -e "s/.*BottomUp/BottomUp/" \
            -e "s/.*SudoLoop/SudoLoop/" \
            -e "s/.*\[bin\]/\#[bin\]/" \
            -e "s/.*Sudo\ \=.*/#Sudo\ \=\ doas/" \
            /etc/paru.conf
       sleep 2 && :
    else
        ## install paru
        echo $purple'----------------|Installing'$normal

        [[ -d paru-bin ]] && rm -rf paru-bin
        [[ $(command -v git) ]] || sudo pacman -S --noconfirm --needed git
        cdir="$PWD"
        git clone https://aur.archlinux.org/paru-bin.git || error
        cd paru-bin
        sudo pacman -S --noconfirm --needed binutils fakeroot
        makepkg PKGBUILD
        sudo pacman -U --noconfirm --needed paru-bin*
        cd $cdir
        rm -rf paru-bin

        check_paru
    fi
}

## Optional Repository ----------------------------------------------------------------
add_optional_repo (){
    _line = Boldblue "Optional repository"

    ## Artix Optional repo ------------------------------------------------------
    grep artix /etc/*-release > /dev/null && {
        ## UNIVERSE repo
        _line - Boldyellow "Universe"

        echo -e $green"Universe${normal} is a repository maintained by Artix package maintainers,
    mostly programs from the AUR, like 'ungoogled-chromium' and 'Spotify'."

        printf  "$yellow\nAdd Universe repository ?$normal [y/N] "
        read -r yn
        case $yn in
             [yY]*)
                echo -e $blue"\n--------|Adding Universe repository."$normal
                sudo sed -i --follow-symlinks \
                    -e "/.*universe.*/d" \
                    -e '$a[universe] \
Server = https://universe.artixlinux.org/$arch \
Server = https://mirror1.artixlinux.org/universe/$arch \
Server = https://mirror.pascalpuffke.de/artix-universe/$arch \
Server = https://artixlinux.qontinuum.space:4443/universe/os/ \
Server = https://mirror1.cl.netactuate.com/artix/universe/$arch' \
                    /etc/pacman.conf
            ;;
            *)
                echo -e $red"--------|Remove Universe repository if exist."$normal
                sudo sed -i --follow-symlinks \
                    -e "/.*universe.*/d" \
                    /etc/pacman.conf
            ;;
        esac

        ## OMNIVERSE repo
        _line - Boldyellow "Omniverse"

        echo -e $green"Omniverse${normal} unofficial repository maintained by an Artix team member.
    It contains packages from the AUR or [community]. Some included packages are: libreoffice-still, filezilla, audacious and vscodium.
    Unlike [universe], this is hosted on a third-party server but the packages are signed by artist. "

        printf  "$yellow\nAdd Omniverse repository ?$normal [y/N] "
        read -r yn
        case $yn in
            [yY]*)
                echo -e $blue"\n--------|Adding Omniverse repository."$normal
                sudo sed -i --follow-symlinks \
                    -e "/.*omniverse.*/d" \
                    -e '$a[omniverse] \
Server = https://omniverse.artixlinux.org/$arch \
Server = https://eu-mirror.artixlinux.org/omniverse/$arch \
Server = https://artix.sakamoto.pl/omniverse/$arch' \
                    /etc/pacman.conf
            ;;
            *)
                echo -e $red"--------|Remove Omniverse repository if exist."$normal
                sudo sed -i --follow-symlinks \
                    -e "/.*omniverse.*/d" \
                    /etc/pacman.conf
            ;;
        esac

        ## Arch EXTRA repo -------------------------------------------------
        _line - Boldyellow "Extra (Arch-repository)"

        echo -e $green"Extra${normal} is repository from Arch linux,
    Some packages not (yet) available on Artix repository e.g. 'stow' and 'wmctrl'."

        printf  "$yellow\nAdd Extra repository ?$normal [Y/n] "
        read -r yn
        case $yn in
            [nN]*)
                echo -e $red"--------|Remove Extra repository if exist."$normal
                sudo sed -i --follow-symlinks \
                    -e "/.*extra.*/,+1d" \
                    /etc/pacman.conf
            ;;
            *)
                echo -e $blue"\n--------| Installing dependency."$normal
                paru -Sy --needed --noconfirm artix-archlinux-support

                echo -e $blue"\n--------|Adding Extra repository.\n"$normal
                sudo sed -i --follow-symlinks \
                    -e '$a \
\
[extra] \
Include = /etc/pacman.d/mirrorlist-arch \
' \
                    -e "/.*extra.*/,+2d" \
                    /etc/pacman.conf

                sudo pacman-key --populate archlinux
                paru -Sy --needed --noconfirm reflector
                echo -e $blue"\n--------|Updating arch mirror."$normal
                sudo reflector --verbose --latest 5 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist-arch
            ;;
        esac
    }
}

## Packages & services ------------------------------------------------------------------
install_pkg (){
    _line = Boldblue 'Installing packages'

    echo -e $yellow"\n------|Checking for pkg.list"$normal
    [[ ! -f pkg.list ]] && {
        echo $red'==========|File "pkg.list" not found.'$normal
        exit 1
    }

    echo -e $yellow"\n====================|Installing"$normal
    paru -Sy
    _install

    echo -e $yellow"\n====================|Cleanup"$normal
    sudo pacman -Qtdq && sudo pacman -Runs $(pacman -Qtdq)

    [[ $(command -v runit) ]] &&
    s_runit
    ntp_hc
}

## Installing packages ------------------------------------------------------------------
_install() {
    paket=$(sed 's/[ /#~].*//;/./!d' pkg.list)
    paru -S --needed --noconfirm $paket || {
        read -p "${yellow}Retry ?${normal}  [Y/n]" yn
        case $yn in
            [nN]*)
                exit 1
            ;;
            *)
                _install
                return
            ;;
        esac
    }
}
## Enable services (runit) ------------------------------------------------------------
s_runit (){
    _line = Boldblue 'Enable Runit Services'

    ## List inactive services
    echo -e $Boldyellow"Inactive Services${normal}${green}\n-----------------"$normal
    if [[ $(diff /etc/runit/sv/ /run/runit/service/) ]]; then
        diff /etc/runit/sv/ /run/runit/service/ | sed 's/.*: //;s/elogind//;/agetty.*/d'
    else
        echo -e "none\n-----------------\n\n${yellow}---------------------|Skipped!"$normal
    fi
    echo -e $green"\n-----------------\n"$normal

    echo -e "Select service(s) to activate or empty to skip!\n(separated with spaces)\n"
    read -p "${Boldyellow}Servise(s) : ${normal}" i_init
    [[ -z $i_init ]] && return

    srv="/etc/runit/sv/"
    ln_to="/run/runit/service/"

    echo -e $yellow"\n\n---------------------|Activate service(s)"$normal
    for sr in $i_init; do
        if [[ -d "$srv$sr" && ! -L "$ln_to$sr" ]]; then
            sudo ln -s "$srv$sr" "$ln_to"
        else
            echo -e $yellow"\nService $srv$sr not found! Make sure to type identical to the list\n"$normal
            read -n 1 -srp "${normal}Press any key "
            clear
            s_runit
            return
        fi
    done
}
## NTP & localtim hc --------------------------------------------------------------------
ntp_hc (){
    echo -e $yellow"\n------|Enable connman NTP and HWCLOCK"$normal
    [[ -f /etc/connman/main.conf ]] && {
        sudo sed -i --follow-symlinks \
            -e 's/.*UseGatewaysAsTimeservers = false$/UseGatewayAsTimeservers = false/' \
            -e 's/.*FallbackTimeservers.*/FallbackTimeservers = "pool.ntp.org,asia.pool.ntp.org,time1.google.com"/' \
            /etc/connman/main.conf
    } || echo -e $red ":: connman config not found!"$normal

    [[ -f /etc/rc/rc.conf ]] &&
        sudo sed -i --follow-symlinks 's/.*CLOCK=.*/HARDWARECLOCK="localtime"/' /etc/rc/rc.conf
}

## Instal simple-terminal -------------------------------------------------------------
install_st (){
    _line = Boldblue 'Install Simple-Terminal'

    [[ -d "st" ]] && {
        echo -e $purple"\n-----------|Installing"$normal
        cd st
        ./1_install.sh
        cd ../
        echo -e $green"\n-----------|Done"$normal
    }
}

## Fish shell -------------------------------------------------------------------------
fish_shell (){
    _line = Boldblue 'Enable fish as interactive shell'

    fis=$(command -v fish)
    if [[ -n $fis ]]; then
        printf  "$yellow\nEnable fish as interactive shell?$normal [Y/n] "
        read -r yn
            case $yn in
                [nN]*)
                    return ;;
                *)
                    sudo mkdir -pv /etc/bash/bashrc.d
                    sudo ln -s $PWD/etc/etc/bash/bashrc.d/* /etc/bash/bashrc.d/custom.bashrc

                    echo -e $green"\n------------|completions"$normal
                    fish -c fish_update_completions
                ;;
        esac
    else
        echo $red'=========|FISH not installed.'$normal
    fi
}

## Pipewire config --------------------------------------------------------------------
pipewire_conf (){
    _line = Boldblue 'Audio config (Pipewire)'

    echo -e $green"---|Check pipewire and copy config!\n"$normal
    [[ $(command -v pipewire) ]] || {
        echo $red"----|Pipewire not installed, Skiped."$normal
        return
    }

    sudo cp -rn /usr/share/pipewire /etc/
    [[ $(command -v wireplumber) ]] && {
        sudo sed -i --follow-symlinks \
            -e 's/.*args = "".*/{ path = "\/usr\/bin\/wireplumber" args = "" }/' \
            /etc/pipewire/pipewire.conf
    } || {
        sudo sed -i --follow-symlinks \
            -e 's/.*args = "".*/{ path = "\/usr\/bin\/pipewire-media-session" args = "" }/' \
            /etc/pipewire/pipewire.conf
    }
    [[ $(command -v pipewire-pulse) ]] && {
        sudo sed -i --follow-symlinks \
            -e '/"-c pipewire-pulse.conf"/ s/^.*{/{/' \
            /etc/pipewire/pipewire.conf
    } || {
        sudo sed -i --follow-symlinks \
            -e '/"-c pipewire-pulse.conf"/ s/^.*{/#{/' \
            /etc/pipewire/pipewire.conf
    }
    echo -e $green"\n-----------|Done"$normal
}

## Autologin -----------------------------------------------------------------------
auto_login (){
    _line = Boldblue 'Autologin'

    echo $blue"========|Checking init-system"$normal
    stat /sbin/init | grep runit > /dev/null && init='Runit'
    stat /sbin/init | grep systemd > /dev/null && init='Systemd'

    [[ -z $init ]] && {
        echo $red"---|Runit/Systemd Not Detected, SKIPPED!"$normal
        return
    }

    echo -e $red"---|$init Detected!\n\n"$yellow
    read -p "======| Enable autologin -| $blue$USER$yellow |- in$green TTY1$yellow ?$normal [Y/n] " \
      yn
        case $yn in
            [nN]* )
                [[ $init = Systemd ]] &&
                sudo rm -rf /etc/systemd/system/getty@tty1.service.d ||
                sudo sed -i "s/GETTY_ARGS=\".*\$/GETTY_ARGS=\"--noclear\"/g" /etc/runit/sv/agetty-tty1/conf
                echo $yellow"---|Autologin inactive."$normal
            ;;
            * )
                [[ $init = Systemd ]] && {
                    [[ ! -d /etc/systemd/system/getty@tty1.service.d ]] && sudo mkdir /etc/systemd/system/getty@tty1.service.d
                    echo -e  "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM\nType=simple" |
                    sudo tee -a /etc/systemd/system/getty@tty1.service.d/override.conf
                } ||
                    sudo sed -i "s/GETTY_ARGS=\".*\$/GETTY_ARGS=\"--autologin $USER --noclear\"/g" /etc/runit/sv/agetty-tty1/conf
                echo $green"---|Autologin active."$normal
            ;;
        esac
}

## Stow -------------------------------------------------------------------------------
stow_config (){
    _line = Boldblue 'Install config (STOW)'

    read -p "$yellow::Stow config from Agp ?$normal  [Y/n]" yn
        case $yn in
            [Nn] )
                echo -e "\n"
                _line = Boldblue "FINISH"
                echo "Reboot required, sometime."
                _line - Boldred
                return
            ;;
            * )
                [[ -f 2_stow_config.sh ]] &&
                    ./2_stow_config.sh || {
                    echo $red'File "2_stow_config.sh" not found.'$normal
                    exit
                }
            ;;
        esac
}

## Error ------------------------------------------------------------------------------
error (){
    echo -e "\n"
    _line = Boldred "ERROR !"
    _line - Boldblue
    exit 1
}

##=====================================================================================

##HEADER
_line = Boldred
_line = Boldblue "BSPWM setup for Artix (runit) / Arch base"
_line = Boldred
echo "* Arch base (not runit init), please enable services manually."
sleep 3 &&
##-----------------------------------------------------

_line = Boldblue 'AUR helper'
check_paru

add_optional_repo
install_pkg
install_st
fish_shell
pipewire_conf
auto_login
stow_config


# '/./!d'         hapus baris kosong
# '/^#/d'         hapus '#' didepan baris
# 's|/$||' 's/[/]$//;'    hapus '/' diakhir baris
# 's/[ /#].*//'   hapus teks sampai akhir baris mulai dari salah satu karakter di dalam "[]", disini " "(spasi) termasuk garis kosong, "/", dan "#"
