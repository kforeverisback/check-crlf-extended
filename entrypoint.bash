#!/usr/bin/env bash

# set -o noglob
set -f
set -e
shopt -s extglob
# set -o pipefail
# Debugging
# exec 5> ./debug_output.txt
# BASH_XTRACEFD="5"
# PS4='+$BASH_SOURCE:$LINENO: '
# set -x
# set -u

source "$(dirname $0)/bash-logger.bash"

usage() {
    echo "Usage:
    $0  -t TARGET_DIR -l LINE_ENDING -i INCL_REGEX -e EXCL_REGEX -d MAX_DIR_DEPTH --regex-filenames-only --exlucde-first

    Examples:
         $0
         $0 -t /some-dir
         $0 -t .
         $0 -t . -l CRLF
         $0 -t . -l LF
         $0 -t . -l LF -i ".*\.txt"
         $0 -t . -l CRLF -i ".*\.txt" -e ".*exclude\.txt"
         $0 -t . -l CRLF -i ".*\.txt" -N

    Arg              Description
    -------------------------------------------------
    -t  TARGET_DIR   Target dir to scan [default: '.'].
                     NOTE: TARGET_DIR will be included in the path when
                     using 'regex' pattern_type. So craft your regex accordingly.
                     e.g. if you want to include files only in the 'subdir',
                     use '^./target-dir/subdir/.*'
    -l  LINE_ENDING  Line Ending type [default: 'CRLF'].
                     Valid values comes from 'file' cmd (CRLF, LF, or MIXED).
    -i  INCL_PATTERN Regex to include path(s) [default '*'].
    -e  EXCL_PATTERN Regex to exclude path(s) [default:: ''].
    -d  DIR_DEPTH    Directory depth to search [default: 999].
    -p  PATTERN_TYPE Type of pattern match to use (possible val: shell_glob or regex)
                     [default: shell_glob].
    -h|--help        Show this help message.
    
    ***NOTE***
      1. It uses 'find' cmd to search the TARGET_DIR and apply include/exclude regex or glob.
         So find's standard behavior applies. See https://man7.org/linux/man-pages/man1/find.1.html for more info
      2. The '.git' directory is auto excluded from the search.
    "
}

while [ $# -gt 0 ]; do
    opt="$1" value="$2"
    case "$opt" in
        -t)
        target_dir="$value";shift 1;;
        -l)
        line_ending_type="$value";shift 1;;
        -i)
        include_pattern="$value";shift 1;;
        -e)
        exclude_pattern="$value";shift 1;;
        -d)
        max_dir_depth="$value";shift 1;;
        -p)
        pattern_type="$value";shift 1;;
        -h|--help)
            usage;exit 0;;
        *)
            usage; exit 1;;
    esac
    shift 1
done


# All args are optional and have default values
target_dir="${target_dir:-"."}"  # Default is current directory
# [[ -z $folder ]] && folder="." # Default is current directory
line_ending_type="${line_ending_type:-"crlf"}"  # Default is CRLF
line_ending_type="$(tr '[:upper:]' '[:lower:]' <<< "$line_ending_type")"
pattern_type="${pattern_type:-"shell_glob"}"  # Default exclude none
max_dir_depth=${max_dir_depth:-999}

if [[ "$pattern_type" == "shell_glob" ]]; then
  WARNING "Only filenames will be used with shell_glob pattern type for include/exclude pattern, so craft your glob pattern for filenames only"
  include_pattern="${include_pattern:-"*"}"  # Default is include all
  exclude_pattern="${exclude_pattern:-""}"  # Default exclude none
elif [[ "$pattern_type" == "regex" ]]; then
  WARNING "'$target_dir' will be included in the path while applying regex, so craft your regex accordingly"
  include_pattern="${include_pattern:-".*"}"  # Default is include all
  exclude_pattern="${exclude_pattern:-"^$"}"  # Default exclude none
else
  ERROR "Invalid pattern type ($pattern_type). Possible types are 'shell_glob' or 'regex'"
  exit 1
fi

INFO "Line Ending Type: '$line_ending_type'"
INFO "Include regex   : '$include_pattern'"
INFO "Exclude regex   : '$exclude_pattern'"
INFO "Max dir depth   : '$max_dir_depth'"
INFO "Target directory: '$target_dir'"
# log_info "Checking '$line_ending_type' endings in directory: $target_dir"

# Yes yes, this is a bit ugly and duplicate if-else
# but I wanted to organize and print incl/excl info before mapfile,
# declare -a files_array
if [[ "$pattern_type" == "shell_glob" ]]; then
  mapfile -d '' files_array < <(find "$target_dir" -maxdepth "$max_dir_depth" -not -path "*/.git/*" -type f -name "$include_pattern" -not -name "$exclude_pattern" -print0 | xargs -r0 file)
elif [[ "$pattern_type" == "regex" ]]; then
  mapfile -d '' files_array < <(find "$target_dir" -maxdepth "$max_dir_depth" -not -path "*/.git/*" -type f -regextype egrep -regex "$include_pattern" -not -regex "$exclude_pattern" -print0 | xargs -r0 file)
else
  ERROR "Invalid pattern type ($pattern_type). Possible types are 'shell_glob' or 'regex'"
  exit 1
fi

# mapfile -d '' files_array < <(find "$target_dir" -maxdepth "$max_dir_depth" -not -path "*/.git/*" -type f -regextype egrep -regex "$include_pattern" -not -regex "$exclude_pattern" -print0 | xargs -r0 file)

# echo "${files_array[@]}"
case "$line_ending_type" in
  crlf)
    found_files=$(echo "${files_array[@]}" | grep ' CRLF ' | cut -d ":" -f 1)
    ;;
  lf)
    found_files=$(echo "${files_array[@]}" | grep -v 'CRLF' | cut -d ":" -f 1)
    ;;
  mixed)
    found_files=$(echo "${files_array[@]}" | grep ' CRLF, LF ' | cut -d ":" -f 1)
    ;;
  *)
    ERROR "Invalid line ending type ($line_ending_type)"
    exit 1;;
esac

# echo Files found "$(echo "${found_files[@]}" | wc -l)":
# echo "${found_files[*]}"

if [ -z "${found_files[*]}" ]; then
  WARNING "No files with $line_ending_type endings found."
  exit 0
else
  count_of_file=$(echo "${found_files[@]}" | wc -l)
  ERROR "Found ${count_of_file} files with $line_ending_type endings. Check GITHUB_OUTPUT for the count followed by list of files."
  echo -e "List of files:\n${found_files[*]}"

  # Output to Github's next stage
  if [[ -n "$GITHUB_ENV" ]]; then
    echo "FILE_COUNT=${count_of_file}" >> "$GITHUB_ENV"
    {
      echo "FILE_LIST<<EOF"
      echo "${found_files[*]}"
      echo "EOF"
    } >> "$GITHUB_ENV"
  fi
  if [[ -n "$GITHUB_OUTPUT" ]]; then
    echo "FILE_COUNT=${count_of_file}" >> "$GITHUB_OUTPUT"
    {
      echo "FILE_LIST<<EOF"
      echo "${found_files[*]}"
      echo "EOF"
    } >> "$GITHUB_OUTPUT"
  fi
  exit 1
fi

