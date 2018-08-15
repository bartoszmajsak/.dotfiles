# Custom functions
source ~/.notify_build_status.sh

# User configuration
export EDITOR=vim
export TERM="xterm-256color"
export DOCKER_HOST="unix:///var/run/docker.sock"
export M2_HOME=/usr/bin/mvn
export M2_REPO=$HOME/.m2/repository
export JAVA_HOME=/usr/bin/java
export FORGE_HOME=$HOME/.forge/latest
export PATH=$PATH:$FORGE_HOME/bin:$M2_HOME/bin:$JAVA_HOME/bin

export PATH=$PATH:/usr/local/bin

mvn() {
  project_name=${PWD##*/} 
  timer=${timer:-$SECONDS}
  mvn_cmd=$@
  $M2_HOME/bin/mvn $@; notify_build_status $? "$(($SECONDS - $timer))" "$project_name [mvn $mvn_cmd]"

  unset timer;
}

# Load custom functionsc
fpath=( ~/.dotfiles/func "${fpath[@]}" )
autoload -Uz arq alm-test alm-core idea goland rubymine webstorm dclean gh cleanup

# Load sdk managers
[[ -s "/home/bartek/.gvm/scripts/gvm" ]] && source "/home/bartek/.gvm/scripts/gvm"

# Load plugins
source $HOME/.antigenrc
source $HOME/.nvm/nvm.sh

# Load aliases
source $HOME/.aliases

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

eval "$(direnv hook zsh)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
