## multi alias
function aliass
    for a in $argv
        alias $a
    end
end

#Prefer doas
if [ (command -v doas) ]
    alias sudo='doas'
end


#terminal
aliass\
             :q='exit'\
              e="$EDITOR"
#    st-256color='st'

#vim/nvim
if command -q nvim
    aliass\
            vim='nvim'\
        vimdiff='nvim -d'
end
alias e $EDITOR

# Verbosity and settings that you pretty much just always are going to want.
aliass\
     cp='cp -iv'\
     mv='mv -iv'\
     rm='rm -rf'\
    mkd='mkdir -pv'

# Colorize commands when possible.
aliass\
     grep='grep --color=auto'\
    egrep='egrep --color=auto'\
    fgrep='fgrep --color=auto'\
     diff='diff --color=auto'\
     ccat='highlight --out-format=ansi'\
       ip='ip -c'

# Pacman / paru
aliass\
          up='paru -Syyu'\
       upall='paru -Syu --noconfirm'\
      unlock='sudo rm /var/lib/pacman/db.lck'\
    paruskip='paru -S --mflags --skipinteg'\
     cleanup="sudo pacman -Rns (pacman -Qtdq)"

# Update mirror
if test -f /etc/pacman.d/mirrorlist-arch
    alias mirror-update 'sudo reflector --verbose --latest 10 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist-arch'
else if grep arch </etc/os-release
    alias mirror-update 'sudo reflector --verbose --latest 10 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist'
end

# Switch between bash and fish
aliass\
    tobash="sudo chsh $USER -s /bin/bash; and echo 'Now log out.'"\
    tofish="sudo chsh $USER -s /bin/fish; and echo 'Now log out.'"

# Shutdown or reboot
if ! stat /sbin/init | grep systemd
    aliass\
        poweroff='loginctl poweroff -i'\
          reboot='loginctl reboot -i'
end

# These common commands are just too long! Abbreviate them.
aliass\
     fish_clean="rm .config/fish/fish_variables"\
           free="free -mt"\
             ka='killall'\
      microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'\
         ps_mem='sudo ps_mem'\
            rsm='sudo rsm'\
      update-fc='sudo fc-cache -fv'\
    update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# Youtube-dlp
aliass\
       yt-aac="yt-dlp --extract-audio --audio-format aac"\
      yt-best="yt-dlp --extract-audio --audio-format best"\
      yt-flac="yt-dlp --extract-audio --audio-format flac"\
       yt-mp3="yt-dlp --extract-audio --audio-format mp3 --add-metadata --embed-thumbnail"\
      yt-opus="yt-dlp --extract-audio --audio-format opus"\
    yt-vorbis="yt-dlp --extract-audio --audio-format vorbis"\
       yt-wav="yt-dlp --extract-audio --audio-format wav"\
     ytv-best="yt-dlp -f bestvideo+bestaudio"

