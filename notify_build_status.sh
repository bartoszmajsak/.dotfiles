#!/bin/zsh

# This function expectes to be called with 3 parameters
# $1 - status code of the operation it's wrapping
# $2 - time execution
# $3 - text to be displayed in the notification bubble
function notify_build_status() {
  
  case "$1" in
    0) result='SUCCESS' ;;
    *) result='FAILURE' ;;
  esac
  notify-send "Build $result [$2s]" "$3" -i ~/.icons/ike_build_${result:l}.png -t 15000
  return $1
}

