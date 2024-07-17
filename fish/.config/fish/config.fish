# Start X at login not root user
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1 -a "$USER" != "root"
        dbus-launch startx -- -keeptty
    end
end

# disable greeting
set -U fish_greeting

# Syntax Highlighting Colors
set -g fish_color_normal white
set -g fish_color_command green
set -g fish_color_quote yellow
set -g fish_color_redirection white
set -g fish_color_end yellow
set -g fish_color_error red
set -g fish_color_param magenta
set -g fish_color_comment blue
set -g fish_color_match --background=black
set -g fish_color_selection --background=black
set -g fish_color_search_match --background=black
set -g fish_color_operator cyan
set -g fish_color_escape magenta
set -g fish_color_autosuggestion brblack

# Completion Pager Colors
set -g fish_pager_color_progress brblue
set -g fish_pager_color_prefix brcyan
set -g fish_pager_color_completion white
set -g fish_pager_color_description brblue
#--------------------------------------------------------------

# alias
. $HOME/.config/fish/alias.fish

sh -c 'rm -r \
    $HOME/.lesshst \
    $HOME/.*_history \
    $HOME/.gore \
    $HOME/.wget-hsts \
#    ' > /dev/null 2>&1 &
