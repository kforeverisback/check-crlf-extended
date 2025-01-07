#!/bin/bash

#tmpdir=$(mktemp -d)
tmpdir=$1;
[ -z "$tmpdir" ] && tmpdir=temp

test_dirs=(
  "$tmpdir" "$tmpdir/subdir" "$tmpdir/.dot-subdir" "$tmpdir/.dot-subdir with space" "$tmpdir/subdir/subsubdir" "$tmpdir/subdir with space" "$tmpdir/subdir/subsubdir with space" "$tmpdir/subdir with space" "$tmpdir/subdir with space/subsubdir with space"  
  # "$tmpdir" "$tmpdir/subdir" "$tmpdir/subdir2" "$tmpdir/subdir3" "$tmpdir/.dot-subdir" "$tmpdir/subdir/subsubdir" "$tmpdir/subdir/subsubdir2" "$tmpdir/subdir/subsubdir3" "$tmpdir/subdir/subsubdir4" "$tmpdir/subdir with space"
)

files=(
# 8 CRLF only files
"Line1\r\nLine2\r\nLine3\r\n;;crlf-only"
"Line1\r\nLine2\r\nLine3\r\n;;crlf-only with space"
"Line1\r\nLine2\r\nLine3\r\n;;CRLF-only"
"Line1\r\nLine2\r\nLine3\r\n;;CRLF-only with space"

"Line1\r\nLine2\r\nLine3;;exclude-crlf-only"
"Line1\r\nLine2\r\nLine3;;exclude-crlf-only with space"
"Line1\r\nLine2\r\nLine3;;EXCLUDE-CRLF-only"
"Line1\r\nLine2\r\nLine3;;EXCLUDE-CRLF-only with space"

# 8 CRLF with LF mixed files
"Line1\r\nLine2\nLine3\nLine4\r\n;;crlf-with-lf-mixed"
"Line1\r\nLine2\nLine3\nLine4\r\n;;crlf-with-lf-mixed with space"
"Line1\r\nLine2\nLine3\nLine4\r\n;;CRLF-with-LF-mixed"
"Line1\r\nLine2\nLine3\nLine4\r\n;;CRLF-with-LF-mixed with space"

"Line1\r\nLine2\nLine3\r\nLine4\r\n;;exclude-crlf-with-lf-mixed"
"Line1\r\nLine2\nLine3\r\nLine4\r\n;;exclude-crlf-with-lf-mixed with space"
"Line1\r\nLine2\nLine3\r\nLine4\r\n;;EXCLUDE-CRLF-with-LF-mixed"
"Line1\r\nLine2\nLine3\r\nLine4\r\n;;EXCLUDE-CRLF-with-LF-mixed with space"

# 8 LF only files
"Line1\nLine2\nLine3\n;;lf-only"
"Line1\nLine2\nLine3\n;;lf-only with space"
"Line1\nLine2\nLine3\n;;LF-only"
"Line1\nLine2\nLine3\n;;LF-only with space"

"Line1\nLine2\nLine2\n;;exclude-lf-only"
"Line1\nLine2\nLine2\n;;exclude-lf-only with space"
"Line1\nLine2\nLine2\n;;EXCLUDE-LF-only"
"Line1\nLine2\nLine2\n;;EXCLUDE-LF-only with space"

)

file_count=$(( ${#files[@]} * ${#test_dirs[@]} ))
echo "Creating $file_count files in ${#test_dirs[@]} directories">&2
for d in "${test_dirs[@]}"; do
    mkdir -p "$d"
    for f in "${files[@]}"; do
        c=$(echo "$f" | awk -F';;' '{print $1}')
        f=$(echo "$f" | awk -F';;' '{print $2}')
        # echo "Writing to: $d/$f"
        # shellcheck disable=SC2059
        printf "$c" > "$d/$f"
    done
done
