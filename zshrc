# Custom functions
source ~/.notify_build_status.sh

# User configuration
export EDITOR=vim
export TERM="xterm-256color"
export DOCKER_HOST=tcp://localhost:4243
export M2_HOME=/usr/share/maven/latest
export M2_REPO=$HOME/.m2/repository
export JAVA_HOME=/usr/lib/jvm/java
export FORGE_HOME=~/.forge/latest
export PATH=$FORGE_HOME/bin:$M2_HOME/bin:$JAVA_HOME/bin:$PATH

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$HOME/.rvm/bin

mvn() {
  project_name=${PWD##*/} 
  timer=${timer:-$SECONDS}
  mvn_cmd=$@
  $M2_HOME/bin/mvn $@; notify_build_status $? "$(($SECONDS - $timer))" "$project_name [mvn $mvn_cmd]"

  unset timer;
}

# Load custom functions
fpath=( ~/.dotfiles/func "${fpath[@]}" )
autoload -Uz arq alm-test alm-core idea rubymine dclean gh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Load sdk managers
[[ -s "/home/bartek/.gvm/scripts/gvm" ]] && source "/home/bartek/.gvm/scripts/gvm"

# Load plugins
source $HOME/.antigenrc
source $HOME/.nvm/nvm.sh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/bartek/.sdkman"
[[ -s "/home/bartek/.sdkman/bin/sdkman-init.sh" ]] && source "/home/bartek/.sdkman/bin/sdkman-init.sh"
