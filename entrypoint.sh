#!/bin/bash

FOLDER="$1"
LINE_ENDING_TYPE="$(echo $2 | tr '[:upper:]' '[:lower:]')"
INCLUDE_REGEX="$3"
# EXCLUDE_REGEX=$3
EXCLUDE_REGEX="$4"

echo "FOLDER=$1"
echo "LINE_ENDING_TYPE=$(echo $2 | tr '[:upper:]' '[:lower:]')"
echo "INCLUDE_REGEX=$3"
echo "EXCLUDE_REGEX=$4"


BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
NO_COLOR='\033[0m'
echo_err () { echo -e "${BOLD_RED}${@}${NO_COLOR}";}
echo_ok () { echo -e "${BOLD_GREEN}${@}${NO_COLOR}";}
echo_warn () { echo -e "${BOLD_YELLOW}${@}${NO_COLOR}";}

[[ -z "$EXCLUDE_REGEX" ]] && EXCLUDE_REGEX=''
[[ -z "$INCLUDE_REGEX" ]] && INCLUDE_REGEX='*'
# We want to make sure the exclusion pattern is not *
[[ "$EXCLUDE_REGEX" == "*" ]] && echo_err "Exclusion glob pattern cannot be *" && exit -1

echo "Checking $LINE_ENDING_TYPE endings in: $FOLDER"
echo I: "$INCLUDE_REGEX"
echo E: "$EXCLUDE_REGEX"
echo F: "$FOLDER"
case "$LINE_ENDING_TYPE" in
  crlf)
    FOUND_FILES=$(find "$FOLDER" -not -path "*/.git/*" -not -type d -name "$INCLUDE_REGEX" -not -name "$EXCLUDE_REGEX" -exec file "{}" ";" | grep ' CRLF ' | cut -d ":" -f 1);;
  lf)
    FOUND_FILES=$(find "$FOLDER" -not -path "*/.git/*" -not -type d -name "$INCLUDE_REGEX" -not -name "$EXCLUDE_REGEX" -exec file "{}" ";" | grep -v 'CRLF' | cut -d ":" -f 1);;

  mixed)
    FOUND_FILES=$(find "$FOLDER" -not -path "*/.git/*" -not -type d -name "$INCLUDE_REGEX" -not -name "$EXCLUDE_REGEX" -exec file "{}" ";" | grep ' CRLF, LF ' | cut -d ":" -f 1);;
  *)
    echo_err "Invalid line ending type ($LINE_ENDING_TYPE)"
    exit -1;;
esac

echo Files: ${FOUND_FILES[@]}
for i in ${FOUND_FILES[@]}; do echo -e $i;done
# echo "PATTERN_ARG=$PATTERN_ARG"
# find "$FOLDER" ! -path "./.git/*" -not -type d -iname "$INCLUDE_REGEX" ! -iname "$EXCLUDE_REGEX" -exec file "{}" ";" | grep "$GREP_ARG" | cut -d ":" -f 1
exit
if [ -z "$FILES_WITH_TARGET_LINE_END" ]; then
  echo_ok "No files with $LINE_ENDING_TYPE endings found."
  exit 0
else
  NR_FILES=$(echo "$FILES_WITH_TARGET_LINE_END" | wc -l)
  echo_err "Found ${NR_FILES} files with CRLF endings."
  echo "$FILES_WITH_TARGET_LINE_END"
  exit "$NR_FILES"
fi
