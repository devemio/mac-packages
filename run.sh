#!/usr/bin/env zsh

NC="\033[0m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"

# Helpers
function log {
    echo -e "${GREEN}==>${NC} ${WHITE}Upgrading${NC} ${GREEN}$1${NC}"
}
function logautd {
    echo "Already up-to-date."
}

case "$1" in
  omz)
    log "oh-my-zsh"
    outdated=$(
      cd ~/.oh-my-zsh && \
      git remote update > /dev/null && \
      [[ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]] && echo 1
    )
    if [[ $outdated ]]; then
      zsh -ic "omz update --unattended"
    else
      logautd
    fi
    ;;
  brew)
    log "brew"
    brew update && brew upgrade && brew cleanup
    ;;
  casks)
    log "casks"
    if [[ $(brew outdated --cask --greedy --quiet | grep -v 'font-') ]]; then
      brew upgrade $(brew outdated --cask --greedy --quiet | grep -v 'font-')
    else
      logautd
    fi
    ;;
  composer)
    log "composer"
    if [[ $(composer global outdated --direct 2>/dev/null) ]]; then
      composer global update
      log "valet"
      valet install
    else
      logautd
    fi
    ;;
  npm)
    log "npm"
    if [[ $(npm outdated -g --depth=0) ]]; then
      npm install -g npm@latest
    else
      logautd
    fi
    ;;
  valet)
    log "valet"
    valet install
    ;;
  *)
    echo -e "${GREEN}==>${NC} ${WHITE}Nothing to do${NC}"
    ;;
esac
