#!/bin/bash
# this is a sorry excuse for a test, but hey, it kinda works

#tmpdir=$(mktemp -d)
tmpdir=$1;
[ -z "$tmpdir" ] && tmpdir=temp

subdir_name="subdir"
subdir_name2="subdir-2"
subdir_dot=".dot-subdir"
subsubdir_name="subsubdir"
dirs_created=("$tmpdir" "$tmpdir/$subdir_name" "$tmpdir/$subdir_dot" "$tmpdir/$subdir_name2" "$tmpdir/$subdir_name/$subsubdir_name" )

files=(
"Line1\r\nLine2;;crlf-only"
"Line1\r\nLine2\nLine3;;crlf-with-lf-mixed"
"Line1\nLine2;;lf-only"
"Line1\r\nLine2;;exclude-crlf"
"Line1\nLine2;;exclude-lf"
"Line1\r\nLine2\nLine3;;exclude-mixed")

for d in "${dirs_created[@]}"; do
    mkdir -p "$d"
    for f in "${files[@]}"; do
        c=$(echo "$f" | awk -F';;' '{print $1}')
        f=$(echo "$f" | awk -F';;' '{print $2}')
        # echo "Writing to: $d/$f"
        # shellcheck disable=SC2059
        printf "$c" > "$d/$f"
    done
done
