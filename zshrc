# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

eval "$(mise activate zsh)"

# --- dedupe PATH and ensure mise installs win over system ---
typeset -U path PATH  # dedupe while preserving order
rehash  # refresh zsh command cache

source ~/.notify_build_status.sh

# User configuration
export EDITOR=vim
export TERM="xterm-256color"
export DOCKER_HOST="unix:///var/run/docker.sock"
export M2_REPO=$HOME/.m2/repository

fpath=( ~/.dotfiles/func "${fpath[@]}" )
autoload -Uz dclean diskclean diskusage cleanup update mvn fedora-update fedora-post-update

# History settings
export HISTFILE=$HOME/.histfile
export HISTSIZE=1000000000
export SAVEHIST=${HISTSIZE}
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS

source $HOME/.aliases

# Create cache and completions dir and add to $fpath
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true

# Key bindings
if [[ -n "${terminfo[kLFT5]}" ]]; then
  bindkey "${terminfo[kLFT5]}" backward-word
  bindkey "${terminfo[kRIT5]}" forward-word
fi

if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char
fi

# Auto-generate completions - run manually with: regen-completions
regen-completions() {
  local cache_dir="${ZSH_CACHE_DIR}/completions"
  mkdir -p "$cache_dir"

  for spec in mise $(mise ls --installed --json 2>/dev/null | jq -r 'keys[]' 2>/dev/null | sort -u); do
    local cmd="${spec##*:}"
    echo "$cmd"
    (( $+commands[$cmd] )) || continue
    local cache_file="$cache_dir/_${cmd}"

    echo -n "Generating $cmd... "
    timeout 2s "$cmd" completion zsh > "$cache_file" 2>/dev/null ||
    timeout 2s "$cmd" completions zsh > "$cache_file" 2>/dev/null ||
    timeout 2s "$cmd" completion -s zsh > "$cache_file" 2>/dev/null ||
    timeout 2s "$cmd" gen-completions --shell zsh > "$cache_file" 2>/dev/null ||
    { rm -f "$cache_file" 2>/dev/null; echo "skip"; continue }
    echo "ok"
  done

  rm -f ~/.zcompdump*
  echo "Done. Restart shell to apply."
}

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

export PATH="${HOME}/.krew/bin:${PATH}" 

# Snap bin
export PATH="/var/lib/snapd/snap/bin:${PATH}"

# Needs to be at the end of zshrc
eval "$(starship init zsh)"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


### End of Zinit's installer chunk

source ${HOME}/.zinitrc
eval "$(atuin init zsh)"
export PATH="$HOME/.local/bin:$PATH"
