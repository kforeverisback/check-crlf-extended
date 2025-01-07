#!/bin/bash

# Totally used Gemini+ChatGPT to generate this with some small mod.
# Don't need to spend too much time writing log functions.
# Define color codes
COLOR_DEBUG="\033[0;37m"      # Gray
COLOR_ERROR='\033[0;31m'      # Red
COLOR_SUCCESS='\033[0;32m'    # Green
COLOR_WARNING='\033[0;33m'    # Yellow
COLOR_CRITICAL='\033[41m'     # Red Background
COLOR_INFO='\033[0m'          # No Color
COLOR_NC='\033[0m'            # No Color

# Logger function
log() {
  local level="${1:-INFO}" # Default to no color if not provided
  shift
  local message="$*"
  local timestamp="$(date "+%Y-%m-%d %H:%M:%S")"
  local color_variable="COLOR_$level"
  local color="${!color_variable}"
  echo -e "${color}${timestamp} [$level] ${message}${COLOR_NC}"
}

DEBUG()     { log "$FUNCNAME" "$*"; }
INFO()      { log "$FUNCNAME" "$*"; }
NOTICE()    { log "$FUNCNAME" "$*"; }
WARNING()   { log "$FUNCNAME" "$*"; }
ERROR()     { log "$FUNCNAME" "$*"; }
CRITICAL()  { log "$FUNCNAME" "$*"; exit 1; }
