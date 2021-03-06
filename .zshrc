########## zshrc for both WSL2 (Ubuntu) and macOS #####
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

## Linux-only initialization (tested on WSL2 Ubuntu)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # homebrew
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

########## Aliases #####
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"

alias l="exa --oneline"
alias ls="exa --long --classify --group-directories-first"
alias la="exa --long --classify --all"
alias lt="exa --long --classify --tree --level 2"
alias lsize="exa --long --classify --sort size --reverse"

########### Git aliases #####
## prints all local branches with deleted remotes
alias git_prune_print="git fetch --prune && git branch -vv | grep 'origin/.*: gone]' | awk '{print \$1}'"
## deletes all local branches with deleted remotes
alias git_prune="git fetch --prune && git branch -vv | grep 'origin/.*: gone]' | awk '{print \$1}' | xargs git branch -d"

########## fasd #####
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

########## functions #####
# generates gitignore files from that website
function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$1 ;}
## goes into each directory (of depth 1) and deletes all local branches with deleted remotes
function loopdir () { find . -maxdepth 1 -type d \( ! -name . \) -exec zsh -c "cd '{}' && $1" \;}
## make directory then cd in
function mcd() { mkdir -p $1 && cd $1 }

########## PATHs #####
export GPG_TTY=$(tty)
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Linux-only PATHs (tested on Ubuntu)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else [[ "$OSTYPE" == "darwin"* ]];
  #Loads postgresql@12 installed by homebrew (v12 for compatibility)
  export PATH="$PATH:/usr/local/opt/postgresql@12/bin"
  export PATH="$PATH:$HOME/.rvm/bin"
fi

########## Secrets
alias hubb=
export API_KEY_RESCUETIME_GIT=
HUBBLE_CLUSTER_NAME=

########## Hubble-specific #####
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # For WSL only (clip.exe is the Windows clipboard)
  alias kubetoken="aws eks get-token --cluster-name=${HUBBLE_CLUSTER_NAME} | jq .status.token | sed 's/\"//g' | clip.exe"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias kubetoken="aws eks get-token --cluster-name=${HUBBLE_CLUSTER_NAME} | jq .status.token | sed 's/\"//g' | pbcopy"
fi

########## Startup :D ######
fortune | cowsay -f bud-frogs | lolcat
