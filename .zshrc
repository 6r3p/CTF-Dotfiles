export ZSH="~/.oh-my-zsh"
#ZSH_THEME="agnoster"
ZSH_THEME="refined"
plugins=(git colored-man-pages)
source $ZSH/oh-my-zsh.sh

# User configuration
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

alias sea="apt search"
alias upd="sudo apt update"
alias upg="sudo apt upgrade -y"
alias listup="apt list --upgradable"
alias ins="sudo apt install"
alias rem="sudo apt remove"
alias arem="sudo apt autoremove"

alias ls="eza --icons"
alias lsl="eza --icons -l"
alias lsa="eza --icons -la"
alias tree="eza --tree lsa"

alias cd1="cd ../"
alias cd2="cd ../../"
alias cd3="cd ../../../"
alias cd4="cd ../../../../"

alias pyup="sudo python -m http.server 8000"
alias ncl="nc -lvnp 1234"

killfzf() {
    ps -ef | awk '{print $2, $8}' | fzf --header="Select a process to kill" --preview="ps -p {} -o pid,ppid,cmd,etime,user" | awk '{print $1}' | xargs -I{} sh -c 'kill -0 {} 2>/dev/null && kill {}'
}
alias kf='killfzf'
alias hf="history -100 | fzf"
alias old-nf='nvim "$(fzf --preview="bat --color=always --style=plain {}" --prompt "Select a file to edit: ")"'
alias nf="find ~/ -type f -not -path '*/\.git/*' | fzf --preview='bat --style=numbers --color=always {} | head -500' --preview-window=right:70%:wrap --bind=ctrl-s:toggle-sort --multi | xargs -r -d '\n' nvim"

eval "$(zoxide init zsh)"

extract() {
  if [ -z "$1" ]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
  else
    if [ -f $1 ]; then
      case $1 in
        *.tar.bz2)   tar xvjf $1    ;;
        *.tar.gz)    tar xvzf $1    ;;
        *.tar.xz)    tar xvJf $1    ;;
        *.lzma)      unlzma $1      ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar x -ad $1 ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xvf $1     ;;
        *.tbz2)      tar xvjf $1    ;;
        *.tgz)       tar xvzf $1    ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *.xz)        unxz $1        ;;
        *.exe)       cabextract $1  ;;
        *)           echo "extract: '$1' - unknown archive method" ;;
      esac
    else
      echo "$1 - file does not exist"
    fi
  fi
}

# Functions
# Courtesy of: https://github.com/Crypto-Cat/CTF/blob/main/my_bash_aliases.md
urlencode() {
    python3 -c "from pwn import *; print(urlencode('$1'));"
}
urldecode() {
    python3 -c "from pwn import *; print(urldecode('$1'));"
}
ffuf-vhost() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist='/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt'
        arg_count=2
    fi
    ffuf -c -H "Host: FUZZ.$1" -u http://$1 -w $wordlist ${@: $arg_count};
}
ffuf-dir() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist='/usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt'
        arg_count=2
    fi
    ffuf -c -u $1FUZZ -w $wordlist ${@: $arg_count};
}
ffuf-req() {
    arg_count=2
    if [[ $1 && $1 != -* ]]; then
        wordlist=$1
    else
        wordlist='/usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt'
        arg_count=1
    fi
    ffuf -c -ic -request new.req -request-proto http -w $wordlist ${@: $arg_count};
}
plzsh() {
    if [[ $1 ]]; then
        port=$1
    else
        port=1337
    fi
    stty raw -echo; (echo 'python3 -c "import pty;pty.spawn(\"/bin/bash\")" || python -c "import pty;pty.spawn(\"/bin/bash\")"' ;echo "stty$(stty -a | awk -F ';' '{print $2 $3}' | head -n 1)"; echo reset;cat) | nc -lvnp $port && reset
}
qssh() {
    sshpass -p $2 ssh -o StrictHostKeyChecking=no $1@$3 ${@: 4};
}
rdp() {
    xfreerdp /u:$1 /p:$2 /v:$3 /size:1440x810 /clipboard /cert-ignore ${@: 4};
}
