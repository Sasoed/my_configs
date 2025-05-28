
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Инициализация Starship
starship init fish | source

# Убираем стандартное приветствие
set -U fish_greeting ""

# Устанавливаем редактор по умолчанию
set -x EDITOR nvim

# Добавляем пути в переменную PATH
export PATH="$HOME/.cargo/bin:/home/seva/.local/bin:/home/seva/go/bin:$PATH"
# Алиасы
alias l="ls -lh"
alias ls="eza --tree --level=1 --icons=always"
alias Iam_femboy_UwU="fastfetch && ~/projects/python/notification/sound/bin/python ~/projects/python/notification/sound.py UwU"
alias copy="wl-copy"
alias tint="tint -d -n -l 1"
alias chrome="google-chrome-unstable --ozone-platform=wayland"
alias vim="nvim"
alias open="xdg-open"
alias findme="grep -nr"
alias nano="vim"
alias rp="realpath"
alias po="yay -Syu && /home/seva/git/backup/env/bin/python /home/seva/git/backup/copy.py -pkg && poweroff"
alias config="/home/seva/projects/python/conf/main.py"
alias syncr="/home/seva/git/backup/env/bin/python /home/seva/git/backup/main.py"
alias mpv="mpv --vo=kitty"



function crp
    realpath $argv | wl-copy
end

function vv
    set -l D (pwd)
    set -l FILE "venv/bin/activate.fish"

    while test "$PWD" != "/"
        if test -f $FILE
            source $FILE
            echo "Activated: "(pwd)/$FILE
            cd $D
            return
        end
        cd ..
    end
    cd $D
    read -l -P "$FILE not found, do you want to create venv? [y/N] " ans
    switch $ans
        case y Y
            if python3 -m venv venv
                source $FILE
                echo "$FILE was created and activated"
                return 0
            else
                echo "Not sucsecfully"
                return 1
            end
        case '*'
            return 1
    end
end
