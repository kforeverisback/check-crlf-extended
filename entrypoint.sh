#!/bin/bash

# set -o noglob
set -f
set -e
shopt -s extglob

# Mandatory arguments
folder="$1"
line_ending_type="$(echo "$2" | tr '[:upper:]' '[:lower:]')"
include_regex="$3"
exclude_regex="$4"
exclude_first="$(echo "$5" | tr '[:upper:]' '[:lower:]')"
max_folder_depth=$6

BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
NO_COLOR='\033[0m'
echo_err () { echo -e "${BOLD_RED}${*}${NO_COLOR}";}
echo_ok () { echo -e "${BOLD_GREEN}${*}${NO_COLOR}";}
echo_warn () { echo -e "${BOLD_YELLOW}${*}${NO_COLOR}";}

echo "Checking $line_ending_type endings in directory: $folder"

if [[ -z "$max_folder_depth" ]]; then
  # We're removing `./` from the result for better regex handling
  all_files=$(find "$folder" -not -path '*/.git/*' -not -path '*/.github/*' -type f)
else
  all_files=$(find "$folder" -not -path "*/.git/*" -not -path "*/.github/*" -type f -maxdepth "$max_folder_depth")
fi

# echo All files: "${all_files[@]}"

all_files_after_regex=$all_files
if [[ "$exclude_first" == "true" ]]; then
  [ -n "$exclude_regex" ] && all_files_after_regex=$(echo "${all_files_after_regex[@]}" | grep -v -E "$exclude_regex")
  [ -n "$include_regex" ] && all_files_after_regex=$(echo "${all_files_after_regex[@]}" | grep -E "$include_regex")
else
  [ -n "$include_regex" ] && all_files_after_regex=$(echo "${all_files_after_regex[@]}" | grep -E "$include_regex")
  [ -n "$exclude_regex" ] && all_files_after_regex=$(echo "${all_files_after_regex[@]}" | grep -v -E "$exclude_regex")
fi
# echo After regex: "${all_files_after_regex[@]}"

found_files=$(for i in ${all_files_after_regex}; do file "$i";done)

# echo "${found_files[@]}"
# exit
# # echo "${FIND_FILES[*]}"
case "$line_ending_type" in
  crlf)
    found_files=$(echo "${found_files[@]}" | grep ' CRLF ' | cut -d ":" -f 1);;
  lf)
    found_files=$(echo "${found_files[@]}" | grep -v 'CRLF' | cut -d ":" -f 1);;
  mixed)
    found_files=$(echo "${found_files[@]}" | grep ' CRLF, LF ' | cut -d ":" -f 1);;
  *)
    echo_err "Invalid line ending type ($line_ending_type)"
    exit 1;;
esac

# echo Files found "$(echo "${found_files[@]}" | wc -l)":
# echo "${found_files[*]}"

if [ -z "$found_files" ]; then
  echo_ok "No files with $line_ending_type endings found."
  exit 0
else
  count_of_file=$(echo "${found_files[@]}" | wc -l)
  echo_err "Found ${count_of_file} files with $line_ending_type endings."
  echo_warn "${found_files[*]}"

  # Output to Github's next stage
  [ -n "$GITHUB_OUTPUT" ] && echo "${found_files[*]}" >> "$GITHUB_OUTPUT"
  exit 1
fi
# # for i in ${found_files[@]}; do echo -e $i;done
# # echo "PATTERN_ARG=$PATTERN_ARG"
# # find "$folder" ! -path "./.git/*" -not -type d -iname "$INCLUDE_REGEX" ! -iname "$EXCLUDE_REGEX" -exec file "{}" ";" | grep "$GREP_ARG" | cut -d ":" -f 1
# exit
# if [ -z "$FILES_WITH_TARGET_LINE_END" ]; then
#   echo_ok "No files with $line_ending_type endings found."
#   exit 0
# else
#   NR_FILES=$(echo "$FILES_WITH_TARGET_LINE_END" | wc -l)
#   echo_err "Found ${NR_FILES} files with CRLF endings."
#   echo "$FILES_WITH_TARGET_LINE_END"
#   exit "$NR_FILES"
# fi
