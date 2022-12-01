#!/bin/bash
# this is a sorry excuse for a test, but hey, it kinda works

#tmpdir=$(mktemp -d)
tmpdir=$1;
[ -z "$tmpdir" ] && tmpdir=temp


mkdir -p $tmpdir
files=(
"Line1\r\nLine2;;crlf-only"
"Line1\r\nLine2\nLine3;;crlf-with-lf-mixed"
"Line1\nLine2;;lf-only"
"Line1\r\nLine2;;exclude-crlf"
"Line1\nLine2;;exclude-lf"
"Line1\r\nLine2\nLine3;;exclude-mixed")

for f in "${files[@]}"; do
    c=$(echo $f | awk -F';;' '{print $1}')
    f=$(echo $f | awk -F';;' '{print $2}')
    printf "$c" > "$tmpdir/$f"
done

subdir_name="subdir"
mkdir -p $tmpdir/$subdir_name
for f in "${files[@]}"; do
    c=$(echo $f | awk -F';;' '{print $1}')
    f=$(echo $f | awk -F';;' '{print $2}')
    printf "$c" > "$tmpdir/$subdir_name/$f"
done

# printf "Line1\r\nLine2" >       "$tmpdir/crlf-only"
# printf "Line1\r\nLine2\nLine3" >"$tmpdir/crlf-with-lf-mixed"
# printf "Line1\nLine2" >         "$tmpdir/lf-only"
# printf "Line1\r\nLine2" >       "$tmpdir/exclude-crlf"
# printf "Line1\nLine2" >         "$tmpdir/exclude-lf"
# printf "Line1\r\nLine2\nLine3" >"$tmpdir/exclude-mixed"
