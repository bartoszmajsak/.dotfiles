# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.notify_build_status.sh

# User configuration
export EDITOR=vim
export TERM="xterm-256color"
export DOCKER_HOST="unix:///var/run/docker.sock"
export M2_HOME=/usr/bin/mvn
export M2_REPO=$HOME/.m2/repository
export JAVA_HOME=/usr/bin/java
export ZPLUG_HOME=$HOME/.zplug
VSCODE_HOME=$HOME/ide/code
HUB_HOME=$HOME/.hub

export PATH=$PATH:$M2_HOME/bin:$JAVA_HOME/bin:$VSCODE_HOME/bin:$HUB_HOME/bin

export PATH=$PATH:/usr/local/bin

fpath=( ~/.dotfiles/func "${fpath[@]}" )
autoload -Uz idea goland rubymine webstorm charm dclean cleanup update make mvn

# History settings
export HISTFILE=$HOME/.histfile
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt share_history

source $HOME/.zplugrc
source $HOME/.nvm/nvm.sh
source $HOME/.aliases

[[ -s "/home/bartek/.gvm/scripts/gvm" ]] && source "/home/bartek/.gvm/scripts/gvm"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

zstyle ':completion:*' menu select.
zstyle ':completion:*' special-dirs true
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$HOME/.rvm/bin:$PATH
