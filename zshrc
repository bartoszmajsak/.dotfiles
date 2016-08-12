
# Custom functions
source ~/.notify_build_status.sh

# User configuration
export TERM="xterm-256color"
export DOCKER_HOST=tcp://localhost:4243
export M2_HOME=/usr/share/maven/latest
export JAVA_HOME=/usr/lib/jvm/java
export PATH=$M2_HOME/bin:$JAVA_HOME/bin:$PATH

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
autoload -Uz arq


# Load plugins
source $HOME/.antigenrc

source $HOME/.nvm/nvm.sh

source $HOME/.aliases


[[ -s "/home/bartek/.gvm/scripts/gvm" ]] && source "/home/bartek/.gvm/scripts/gvm"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/bartek/.sdkman"
[[ -s "/home/bartek/.sdkman/bin/sdkman-init.sh" ]] && source "/home/bartek/.sdkman/bin/sdkman-init.sh"
