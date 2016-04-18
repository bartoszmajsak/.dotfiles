#!/bin/zsh

function notify_build_status() {
  
  case "$1" in
    0) result='SUCCESS' ;;
    1) result='FAILURE' ;;
  esac

  notify-send "Build $result" "$2" -i ~/.icons/ike_build_${result:l}.png -t 15000
}

