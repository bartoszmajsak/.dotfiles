#!/bin/zsh

function notify_build_status() {
  
  case "$1" in
    0) result='SUCCESS' ;;
    1) result='FAILURE' ;;
  esac
  echo $3
  notify-send "Build $result [$2s]" "$3" -i ~/.icons/ike_build_${result:l}.png -t 15000
}

